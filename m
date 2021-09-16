Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-21.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C00AC433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Sep 2021 01:46:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EC503611C8
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Sep 2021 01:46:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233688AbhIPBsO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Sep 2021 21:48:14 -0400
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:52828 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232171AbhIPBsO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Sep 2021 21:48:14 -0400
Received: from dread.disaster.area (pa49-195-238-16.pa.nsw.optusnet.com.au [49.195.238.16])
        by mail110.syd.optusnet.com.au (Postfix) with ESMTPS id 8A52B106C53
        for <linux-xfs@vger.kernel.org>; Thu, 16 Sep 2021 11:46:53 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mQgUH-00CySk-0q
        for linux-xfs@vger.kernel.org; Thu, 16 Sep 2021 11:46:53 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95-RC2)
        (envelope-from <david@fromorbit.com>)
        id 1mQgUG-007hWw-Vs
        for linux-xfs@vger.kernel.org;
        Thu, 16 Sep 2021 11:46:52 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 3/5] atomic: convert to uatomic
Date:   Thu, 16 Sep 2021 11:46:47 +1000
Message-Id: <20210916014649.1835564-4-david@fromorbit.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916014649.1835564-1-david@fromorbit.com>
References: <20210916013707.GQ2361455@dread.disaster.area>
 <20210916014649.1835564-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
        a=DzKKRZjfViQTE5W6EVc0VA==:117 a=DzKKRZjfViQTE5W6EVc0VA==:17
        a=7QKq2e-ADPsA:10 a=20KFwNOVAAAA:8 a=9uXBr0ESAAAA:20
        a=ildpD4JrNXhSmCI8gPYA:9
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
 include/atomic.h | 65 ++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 54 insertions(+), 11 deletions(-)

diff --git a/include/atomic.h b/include/atomic.h
index e0e1ba84bc82..8c0f96326f08 100644
--- a/include/atomic.h
+++ b/include/atomic.h
@@ -7,21 +7,64 @@
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
+#define atomic_add(a, v)	uatomic_add(a, v)
+#define atomic_sub(a, v)	uatomic_sub(a, v)
+#define atomic_inc(a)		uatomic_inc(a)
+#define atomic_dec(a)		uatomic_dec(a)
+#define atomic_inc_return(a)	uatomic_add_return(a, 1)
+#define atomic_dec_return(a)	uatomic_sub_return(a, 1)
+#define atomic_dec_and_test(a)	(atomic_dec_return(a) == 0)
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
-#define atomic64_add(v, x)	(*(x) += v)
-#define atomic64_inc(x)		((*(x))++)
-#define atomic64_dec(x)		((*(x))--)
+#define atomic64_read(x)	uatomic_read(x)
+#define atomic64_set(x, v)	uatomic_set(x, v)
+#define atomic64_add(a, v)	uatomic_add(a, v)
+#define atomic64_sub(a, v)	uatomic_sub(a, v)
+#define atomic64_inc(a)		uatomic_inc(a)
+#define atomic64_dec(a)		uatomic_dec(a)
 
 #endif /* __ATOMIC_H__ */
-- 
2.33.0

