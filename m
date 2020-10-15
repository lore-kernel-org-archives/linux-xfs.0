Return-Path: <SRS0=m1l6=DW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84636C2D0A1
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Oct 2020 07:22:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 38ABA2224D
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Oct 2020 07:22:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729247AbgJOHWM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 15 Oct 2020 03:22:12 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:33398 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729073AbgJOHWL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Oct 2020 03:22:11 -0400
Received: from dread.disaster.area (pa49-179-6-140.pa.nsw.optusnet.com.au [49.179.6.140])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 57D623AB15C
        for <linux-xfs@vger.kernel.org>; Thu, 15 Oct 2020 18:21:57 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kSxaG-000hvV-Kc
        for linux-xfs@vger.kernel.org; Thu, 15 Oct 2020 18:21:56 +1100
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1kSxaG-006qLm-D9
        for linux-xfs@vger.kernel.org; Thu, 15 Oct 2020 18:21:56 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 09/27] atomic: convert to uatomic
Date:   Thu, 15 Oct 2020 18:21:37 +1100
Message-Id: <20201015072155.1631135-10-david@fromorbit.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201015072155.1631135-1-david@fromorbit.com>
References: <20201015072155.1631135-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Ubgvt5aN c=1 sm=1 tr=0 cx=a_idp_d
        a=uDU3YIYVKEaHT0eX+MXYOQ==:117 a=uDU3YIYVKEaHT0eX+MXYOQ==:17
        a=afefHYAZSVUA:10 a=20KFwNOVAAAA:8 a=9uXBr0ESAAAA:20
        a=ypXRH1f5fNK_8avgJkMA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Now we have liburcu, we can make use of it's atomic variable
implementation. It is almost identical to the kernel API - it's just
got a "uatomic" prefix. liburcu also provides all the same aomtic
variable memory barriers as the kernel, so if we pull memory barrier
dependent kernel code across, it will just work with the right
barrier wrappers.

This is preparation the addition of more extensive atomic operations
the that kernel buffer cache requires to function correctly.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 include/atomic.h | 60 +++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 52 insertions(+), 8 deletions(-)

diff --git a/include/atomic.h b/include/atomic.h
index 1aabecc3ae57..5860d7897ae5 100644
--- a/include/atomic.h
+++ b/include/atomic.h
@@ -7,18 +7,62 @@
 #define __ATOMIC_H__
 
 /*
- * Warning: These are not really atomic at all. They are wrappers around the
- * kernel atomic variable interface. If we do need these variables to be atomic
- * (due to multithreading of the code that uses them) we need to add some
- * pthreads magic here.
+ * Atomics are provided by liburcu.
+ *
+ * API and guidelines for which operations provide memory barriers is here:
+ *
+ * https://github.com/urcu/userspace-rcu/blob/master/doc/uatomic-api.md
+ *
+ * Unlike the kernel, the same interface supports 32 and 64 bit atomic integers.
  */
+#include <urcu/uatomic.h>
+#include "spinlock.h"
+
 typedef	int32_t	atomic_t;
 typedef	int64_t	atomic64_t;
 
-#define atomic_inc_return(x)	(++(*(x)))
-#define atomic_dec_return(x)	(--(*(x)))
+#define atomic_read(a)		uatomic_read(a)
+#define atomic_set(a, v)	uatomic_set(a, v)
+
+#define atomic_inc_return(a)	uatomic_add_return(a, 1)
+#define atomic_dec_return(a)	uatomic_sub_return(a, 1)
+
+#define atomic_inc(a)		atomic_inc_return(a)
+#define atomic_dec(a)		atomic_inc_return(a)
+
+#define atomic_dec_and_test(a)	(atomic_dec_return(a) == 0)
+
+#define cmpxchg(a, o, n)        uatomic_cmpxchg(a, o, n);
+
+static inline bool atomic_add_unless(atomic_t *a, int v, int u)
+{
+	int r = atomic_read(a);
+	int n, o;
+
+	do {
+		o = r;
+		if (o == u)
+			break;
+		n = o + v;
+		r = uatomic_cmpxchg(a, o, n);
+	} while (r != o);
+
+	return o != u;
+}
+
+static inline bool atomic_dec_and_lock(atomic_t *a, spinlock_t *lock)
+{
+	if (atomic_add_unless(a, -1, 1))
+		return 0;
+
+	spin_lock(lock);
+	if (atomic_dec_and_test(a))
+		return 1;
+	spin_unlock(lock);
+	return 0;
+}
 
-#define atomic64_read(x)	*(x)
-#define atomic64_set(x, v)	(*(x) = v)
+#define atomic64_read(x)	uatomic_read(x)
+#define atomic64_set(x, v)	uatomic_set(x, v)
 
 #endif /* __ATOMIC_H__ */
-- 
2.28.0

