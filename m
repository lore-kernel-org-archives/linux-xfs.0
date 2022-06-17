Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7B7BC43334
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Jun 2022 02:31:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229454AbiFQCbG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Jun 2022 22:31:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232957AbiFQCbF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Jun 2022 22:31:05 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEA9064D36
        for <linux-xfs@vger.kernel.org>; Thu, 16 Jun 2022 19:31:04 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id d5so2726151plo.12
        for <linux-xfs@vger.kernel.org>; Thu, 16 Jun 2022 19:31:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=oZUVKPQ86t/gFfVcMQ3TDx3Atx5r3g3Tl8rhISPA5Us=;
        b=mpsJYNlhhhEpiEQYHI9IcgW0B1f2kBmz6YgTJMayHQXk31kMAcXAP4fDGIIQvqZOei
         aFpCELGVaePwrhGMlr+jGDdDh+iZmne1QY/00kplvTIEZB+ycIuZXCeZu09+J/fU2o5A
         9FxVuDnwhICLWflxXy5tJHGMT/i2Thr1c6aBx2NQ2j6T9U1r143cJa9PyYs3BoKP+lb3
         k1D7GB4o4YJrmylMQvnTv1BnU90uAFeX0+T9fdJEJZMU4bUuU+pImXQQlvzEmpDajuUV
         Ehc1Gy8RU3wpTyqi0234aEpGuSOQz1E3QCToqU3wZa1kQ+25BpZxhiSEthL5xanX9din
         VY0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=oZUVKPQ86t/gFfVcMQ3TDx3Atx5r3g3Tl8rhISPA5Us=;
        b=kDyvQ3QZmj8kQYJg3UUpxRuPTQb6rfCpTq3ccI03O6DSJKWVCzTx8yBhlfxIJsA6KQ
         9gTeSFaIoSfW8B0ax46oPPL4drw/J9A1pdO0qd1VZvTZyrtHteHdwowVBoHg9fsfproZ
         1ImALwb0z+cy2FS1lZCXmj5h8sgdqpXuB+GDQJ2W+Dbigtuox41dUPAcCy+OwM0iHvqC
         DfK/spVrw+PLDYMXLmh3K6cqBD1Y026QmoyOWg4wfsFhktQB0pEKWx5Wq1sGWhejF1b+
         j5+e0z3YvfpdLjGqFvE25wPv609WIVQXExBREJ4qmWvbeOGf9gF6mGm8BC2nsTKPJ5jz
         rqOA==
X-Gm-Message-State: AJIora+5r8xS4mEM38rs4Tj3HxGfcjc84gGxoFu/qiiuaaKUyLHV6kqZ
        EbBff9S7PXVZ6A/rySF+9VfXxjGCJg==
X-Google-Smtp-Source: AGRyM1uvksnbdn183fiUJPDFBDlhUrP7yVMtrd7LdXRsEuDUjfGRCwX8l4ADiyIB13bjDt3PTeZCaw==
X-Received: by 2002:a17:90b:4f47:b0:1e3:38c7:70b5 with SMTP id pj7-20020a17090b4f4700b001e338c770b5mr19624698pjb.32.1655433064083;
        Thu, 16 Jun 2022 19:31:04 -0700 (PDT)
Received: from localhost.localdomain ([43.132.141.8])
        by smtp.gmail.com with ESMTPSA id u1-20020a170903124100b0016892555955sm2282654plh.179.2022.06.16.19.31.02
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 16 Jun 2022 19:31:03 -0700 (PDT)
From:   xiakaixu1987@gmail.com
X-Google-Original-From: kaixuxia@tencent.com
To:     linux-xfs@vger.kernel.org
Cc:     djwong@kernel.org, david@fromorbit.com, hch@infradead.org,
        Kaixu Xia <kaixuxia@tencent.com>
Subject: [RESEND PATCH 1/2] xfs: factor out the common lock flags assert
Date:   Fri, 17 Jun 2022 10:30:33 +0800
Message-Id: <1655433034-17934-2-git-send-email-kaixuxia@tencent.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1655433034-17934-1-git-send-email-kaixuxia@tencent.com>
References: <1655433034-17934-1-git-send-email-kaixuxia@tencent.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Kaixu Xia <kaixuxia@tencent.com>

There are similar lock flags assert in xfs_ilock(), xfs_ilock_nowait(),
xfs_iunlock(), thus we can factor it out into a helper that is clear.

Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
---
 fs/xfs/xfs_inode.c | 60 ++++++++++++++++++----------------------------
 1 file changed, 23 insertions(+), 37 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 52d6f2c7d58b..8b8bac7eba8c 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -131,6 +131,26 @@ xfs_ilock_attr_map_shared(
 	return lock_mode;
 }
 
+/*
+ * You can't set both SHARED and EXCL for the same lock,
+ * and only XFS_IOLOCK_SHARED, XFS_IOLOCK_EXCL, XFS_MMAPLOCK_SHARED,
+ * XFS_MMAPLOCK_EXCL, XFS_ILOCK_SHARED, XFS_ILOCK_EXCL are valid values
+ * to set in lock_flags.
+ */
+static inline void
+xfs_lock_flags_assert(
+	uint		lock_flags)
+{
+	ASSERT((lock_flags & (XFS_IOLOCK_SHARED | XFS_IOLOCK_EXCL)) !=
+		(XFS_IOLOCK_SHARED | XFS_IOLOCK_EXCL));
+	ASSERT((lock_flags & (XFS_MMAPLOCK_SHARED | XFS_MMAPLOCK_EXCL)) !=
+		(XFS_MMAPLOCK_SHARED | XFS_MMAPLOCK_EXCL));
+	ASSERT((lock_flags & (XFS_ILOCK_SHARED | XFS_ILOCK_EXCL)) !=
+		(XFS_ILOCK_SHARED | XFS_ILOCK_EXCL));
+	ASSERT((lock_flags & ~(XFS_LOCK_MASK | XFS_LOCK_SUBCLASS_MASK)) == 0);
+	ASSERT(lock_flags != 0);
+}
+
 /*
  * In addition to i_rwsem in the VFS inode, the xfs inode contains 2
  * multi-reader locks: invalidate_lock and the i_lock.  This routine allows
@@ -168,18 +188,7 @@ xfs_ilock(
 {
 	trace_xfs_ilock(ip, lock_flags, _RET_IP_);
 
-	/*
-	 * You can't set both SHARED and EXCL for the same lock,
-	 * and only XFS_IOLOCK_SHARED, XFS_IOLOCK_EXCL, XFS_ILOCK_SHARED,
-	 * and XFS_ILOCK_EXCL are valid values to set in lock_flags.
-	 */
-	ASSERT((lock_flags & (XFS_IOLOCK_SHARED | XFS_IOLOCK_EXCL)) !=
-	       (XFS_IOLOCK_SHARED | XFS_IOLOCK_EXCL));
-	ASSERT((lock_flags & (XFS_MMAPLOCK_SHARED | XFS_MMAPLOCK_EXCL)) !=
-	       (XFS_MMAPLOCK_SHARED | XFS_MMAPLOCK_EXCL));
-	ASSERT((lock_flags & (XFS_ILOCK_SHARED | XFS_ILOCK_EXCL)) !=
-	       (XFS_ILOCK_SHARED | XFS_ILOCK_EXCL));
-	ASSERT((lock_flags & ~(XFS_LOCK_MASK | XFS_LOCK_SUBCLASS_MASK)) == 0);
+	xfs_lock_flags_assert(lock_flags);
 
 	if (lock_flags & XFS_IOLOCK_EXCL) {
 		down_write_nested(&VFS_I(ip)->i_rwsem,
@@ -222,18 +231,7 @@ xfs_ilock_nowait(
 {
 	trace_xfs_ilock_nowait(ip, lock_flags, _RET_IP_);
 
-	/*
-	 * You can't set both SHARED and EXCL for the same lock,
-	 * and only XFS_IOLOCK_SHARED, XFS_IOLOCK_EXCL, XFS_ILOCK_SHARED,
-	 * and XFS_ILOCK_EXCL are valid values to set in lock_flags.
-	 */
-	ASSERT((lock_flags & (XFS_IOLOCK_SHARED | XFS_IOLOCK_EXCL)) !=
-	       (XFS_IOLOCK_SHARED | XFS_IOLOCK_EXCL));
-	ASSERT((lock_flags & (XFS_MMAPLOCK_SHARED | XFS_MMAPLOCK_EXCL)) !=
-	       (XFS_MMAPLOCK_SHARED | XFS_MMAPLOCK_EXCL));
-	ASSERT((lock_flags & (XFS_ILOCK_SHARED | XFS_ILOCK_EXCL)) !=
-	       (XFS_ILOCK_SHARED | XFS_ILOCK_EXCL));
-	ASSERT((lock_flags & ~(XFS_LOCK_MASK | XFS_LOCK_SUBCLASS_MASK)) == 0);
+	xfs_lock_flags_assert(lock_flags);
 
 	if (lock_flags & XFS_IOLOCK_EXCL) {
 		if (!down_write_trylock(&VFS_I(ip)->i_rwsem))
@@ -291,19 +289,7 @@ xfs_iunlock(
 	xfs_inode_t		*ip,
 	uint			lock_flags)
 {
-	/*
-	 * You can't set both SHARED and EXCL for the same lock,
-	 * and only XFS_IOLOCK_SHARED, XFS_IOLOCK_EXCL, XFS_ILOCK_SHARED,
-	 * and XFS_ILOCK_EXCL are valid values to set in lock_flags.
-	 */
-	ASSERT((lock_flags & (XFS_IOLOCK_SHARED | XFS_IOLOCK_EXCL)) !=
-	       (XFS_IOLOCK_SHARED | XFS_IOLOCK_EXCL));
-	ASSERT((lock_flags & (XFS_MMAPLOCK_SHARED | XFS_MMAPLOCK_EXCL)) !=
-	       (XFS_MMAPLOCK_SHARED | XFS_MMAPLOCK_EXCL));
-	ASSERT((lock_flags & (XFS_ILOCK_SHARED | XFS_ILOCK_EXCL)) !=
-	       (XFS_ILOCK_SHARED | XFS_ILOCK_EXCL));
-	ASSERT((lock_flags & ~(XFS_LOCK_MASK | XFS_LOCK_SUBCLASS_MASK)) == 0);
-	ASSERT(lock_flags != 0);
+	xfs_lock_flags_assert(lock_flags);
 
 	if (lock_flags & XFS_IOLOCK_EXCL)
 		up_write(&VFS_I(ip)->i_rwsem);
-- 
2.27.0

