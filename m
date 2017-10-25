Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from LGEAMRELO11.lge.com ([156.147.23.51]:41906 "EHLO
        lgeamrelo11.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932439AbdJYI4d (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Oct 2017 04:56:33 -0400
From: Byungchul Park <byungchul.park@lge.com>
Subject: [PATCH v5 3/9] completion: Change the prefix of lock name for completion variable
Date: Wed, 25 Oct 2017 17:55:59 +0900
Message-Id: <1508921765-15396-4-git-send-email-byungchul.park@lge.com>
In-Reply-To: <1508921765-15396-1-git-send-email-byungchul.park@lge.com>
References: <1508921765-15396-1-git-send-email-byungchul.park@lge.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: peterz@infradead.org, mingo@kernel.org, axboe@kernel.dk
Cc: johan@kernel.org, tglx@linutronix.de, linux-kernel@vger.kernel.org, linux-mm@kvack.org, tj@kernel.org, johannes.berg@intel.com, oleg@redhat.com, amir73il@gmail.com, david@fromorbit.com, darrick.wong@oracle.com, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, hch@infradead.org, idryomov@gmail.com, kernel-team@lge.com

CONFIG_LOCKDEP_COMPLETIONS uses "(complete)" as a prefix of lock name
for completion variable.

However, "complete" is a verb or adjective and lock symbol names
should be nouns. Use "(completion)" instead, for normal completions.

Suggested-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Byungchul Park <byungchul.park@lge.com>
---
 include/linux/completion.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/completion.h b/include/linux/completion.h
index cae5400..9121803 100644
--- a/include/linux/completion.h
+++ b/include/linux/completion.h
@@ -53,7 +53,7 @@ static inline void complete_release_commit(struct completion *x)
 do {									\
 	static struct lock_class_key __key;				\
 	lockdep_init_map_crosslock((struct lockdep_map *)&(x)->map,	\
-			"(complete)" #x,				\
+			"(completion)" #x,				\
 			&__key, 0);					\
 	__init_completion(x);						\
 } while (0)
@@ -67,7 +67,7 @@ static inline void complete_release_commit(struct completion *x) {}
 #ifdef CONFIG_LOCKDEP_COMPLETIONS
 #define COMPLETION_INITIALIZER(work) \
 	{ 0, __WAIT_QUEUE_HEAD_INITIALIZER((work).wait), \
-	STATIC_CROSS_LOCKDEP_MAP_INIT("(complete)" #work, &(work)) }
+	STATIC_CROSS_LOCKDEP_MAP_INIT("(completion)" #work, &(work)) }
 #else
 #define COMPLETION_INITIALIZER(work) \
 	{ 0, __WAIT_QUEUE_HEAD_INITIALIZER((work).wait) }
-- 
1.9.1

