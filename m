Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 25 Jun 2008 21:41:05 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5Q4eMFS008309
	for <xfs@oss.sgi.com>; Wed, 25 Jun 2008 21:40:22 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7A23AD5613B
	for <xfs@oss.sgi.com>; Wed, 25 Jun 2008 21:41:22 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id H7QWsVUplx5pU4nz for <xfs@oss.sgi.com>; Wed, 25 Jun 2008 21:41:22 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/6] Extend completions to provide XFS object flush requirements
Date: Thu, 26 Jun 2008 14:41:12 +1000
Message-Id: <1214455277-6387-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1214455277-6387-1-git-send-email-david@fromorbit.com>
References: <1214455277-6387-1-git-send-email-david@fromorbit.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com
Cc: matthew@wil.cx, linux-kernel@vger.kernel.org, Dave Chinner <david@fromorbit.com>

XFS object flushing doesn't quite match existing completion semantics.  It
mixed exclusive access with completion. That is, we need to mark an object as
being flushed before flushing it to disk, and then block any other attempt to
flush it until the completion occurs.

To do this we introduce:

void init_completion_flush(struct completion *x)
	which initialises x->done = 1

void completion_flush_start(struct completion *x)
	which blocks if done == 0, otherwise decrements done to zero and
	allows the caller to continue.

bool completion_flush_start_nowait(struct completion *x)
	returns a failure status if done == 0, otherwise decrements done
	to zero and returns a "flush started" status. This is provided
	to allow flushing to begin safely while holding object locks in
	inverted order.

This replaces the use of semaphores for providing this exclusion
and completion mechanism.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 include/linux/completion.h |   65 ++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 65 insertions(+), 0 deletions(-)

diff --git a/include/linux/completion.h b/include/linux/completion.h
index d2961b6..82d9fa4 100644
--- a/include/linux/completion.h
+++ b/include/linux/completion.h
@@ -55,4 +55,69 @@ extern void complete_all(struct completion *);
 
 #define INIT_COMPLETION(x)	((x).done = 0)
 
+/*
+ * Give completions flush lock semantics.
+ *
+ * A flush lock is a completion that allows only a single thread to be flushing
+ * a queue. That is, the first thread does not block on the completion, but
+ * forces all subsequent threads to block until the first thread issues a
+ * complete().  This allows only a single I/O at a time on an object protected
+ * by such a completion queue.
+ *
+ * Rather than make the code using this confusing by calling
+ * "wait_for_completion()", introduce a new interface that "starts
+ * a flush." In some cases, we may want to try to start a flush
+ * but not do so if it would involve sleeping, so allow those
+ * semantics as well.
+ */
+
+static inline void init_completion_flush(struct completion *x)
+{
+	x->done = 1;
+	init_waitqueue_head(&x->wait);
+}
+
+
+static inline void completion_flush_start(struct completion *x)
+{
+	wait_for_completion(x);
+}
+
+/*
+ * Start a flush without blocking if possible.
+ *
+ * Returns 0 if a completion is in progress without
+ * modifying the done counter. Otherwise, take a count
+ * so that others will see a completion in progress and
+ * return 1 to indicate a flush can be started.
+ */
+static inline bool completion_flush_start_nowait(struct completion *x)
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
+/*
+ * Test to see if a flush is in progress.
+ *
+ * Returns 1 if a flush is in progress, otherwise 0.
+ */
+static inline bool completion_flush_inprogress(struct completion *x)
+{
+	int ret = 0;
+
+	spin_lock_irq(&x->wait.lock);
+	if (!x->done)
+		ret = 1;
+	spin_unlock_irq(&x->wait.lock);
+	return ret;
+}
+
 #endif
-- 
1.5.5.4
