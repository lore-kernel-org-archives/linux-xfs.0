Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 27 Jun 2008 01:43:54 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5R8hl6I025165
	for <xfs@oss.sgi.com>; Fri, 27 Jun 2008 01:43:48 -0700
Received: from ipmail04.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F037DD64442
	for <xfs@oss.sgi.com>; Fri, 27 Jun 2008 01:44:48 -0700 (PDT)
Received: from ipmail04.adl2.internode.on.net (ipmail04.adl2.internode.on.net [203.16.214.57]) by cuda.sgi.com with ESMTP id ktfnpDsVrFJUP9Op for <xfs@oss.sgi.com>; Fri, 27 Jun 2008 01:44:48 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3/6] Extend completions to provide XFS object flush requirements
Date: Fri, 27 Jun 2008 18:44:41 +1000
Message-Id: <1214556284-4160-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1214556284-4160-1-git-send-email-david@fromorbit.com>
References: <1214556284-4160-1-git-send-email-david@fromorbit.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com
Cc: linux-kernel@vger.kernel.org, matthew@wil.cx, dwalker@mvista.com, Dave Chinner <david@fromorbit.com>

XFS object flushing doesn't quite match existing completion semantics.  It
mixed exclusive access with completion. That is, we need to mark an object as
being flushed before flushing it to disk, and then block any other attempt to
flush it until the completion occurs. We do this but adding an extra count
to the completion before we start using them. However, we still need
to determine if there is a completion in progress, and allow no-blocking
attempts fo completions to decrement the count.

To do this we introduce:

int try_wait_for_completion(struct completion *x)
	returns a failure status if done == 0, otherwise decrements done
	to zero and returns a "started" status. This is provided
	to allow counted completions to begin safely while holding
	object locks in inverted order.

int completion_done(struct completion *x)
	returns 1 if there is no waiter, 0 if there is a waiter
	(i.e. a completion in progress).

This replaces the use of semaphores for providing this exclusion
and completion mechanism.

Version 2:
o remove "flush" based API and just add the minimum necessary
  extensions to allow counting completions to do what is needed
  by XFS.
o docbook format comments

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 include/linux/completion.h |   45 ++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 45 insertions(+), 0 deletions(-)

diff --git a/include/linux/completion.h b/include/linux/completion.h
index d2961b6..57faa60 100644
--- a/include/linux/completion.h
+++ b/include/linux/completion.h
@@ -55,4 +55,49 @@ extern void complete_all(struct completion *);
 
 #define INIT_COMPLETION(x)	((x).done = 0)
 
+
+/**
+ *	try_wait_for_completion - try to decrement a completion without blocking
+ *	@x:	completion structure
+ *
+ *	Returns: 0 if a decrement cannot be done without blocking
+ *		 1 if a decrement succeeded.
+ *
+ *	If a completion is being used as a counting completion,
+ *	attempt to decrement the counter without blocking. This
+ *	enables us to avoid waiting if the resource the completion
+ *	is protecting is not available.
+ */
+static inline bool try_wait_for_completion(struct completion *x)
+{
+	int ret = 1;
+
+	spin_lock_irq(&x->wait.lock);
+	if (!x->done)
+		ret = 0;
+	else
+		x->done--;
+	spin_unlock_irq(&x->wait.lock);
+	return ret;
+}
+
+/**
+ *	completion_done - Test to see if a completion has any waiters
+ *	@x:	completion structure
+ *
+ *	Returns: 0 if there are waiters (wait_for_completion() in progress)
+ *		 1 if there are no waiters.
+ *
+ */
+static inline bool completion_done(struct completion *x)
+{
+	int ret = 1;
+
+	spin_lock_irq(&x->wait.lock);
+	if (!x->done)
+		ret = 0;
+	spin_unlock_irq(&x->wait.lock);
+	return ret;
+}
+
 #endif
-- 
1.5.5.4
