Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77A71C43334
	for <linux-xfs@archiver.kernel.org>; Sat, 11 Jun 2022 12:55:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233328AbiFKMzM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 11 Jun 2022 08:55:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233379AbiFKMzM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 11 Jun 2022 08:55:12 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28B1C4C7A4
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 05:55:10 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id f8so1400681plo.9
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 05:55:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=oZUVKPQ86t/gFfVcMQ3TDx3Atx5r3g3Tl8rhISPA5Us=;
        b=EGBug1YF+ZWUJnmWqA6DWAVQChJkhQve1vl/eH5Jl/9mQDlYdEBYnlV82z2VcIUzBD
         W6+w6UvCKV6/YN4p60CZ8yG/1QHFvRvBrNZBvzLprg426qwdVZWCpoRU51vJ3+Vta68w
         B/5xATn6pWkD4WUqPBq/Ey7zdIhN674wZUj3C26LVyV3M1HGXyFNW1xCEbuhuOjK6iGj
         esrtnZC9SNf21SjzH3QAS3KkU5twgYgQiqe458Cp+knE9CWZNtHP92n2XBzPyuyrtkzA
         5z1N8Yv2wVBVBB7hAZDLeE+AvngKn/dejtotIblLNZo/djVELLPc3U3ogmn2dvFkBwow
         DKGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=oZUVKPQ86t/gFfVcMQ3TDx3Atx5r3g3Tl8rhISPA5Us=;
        b=PNnfFWvlLhos+AtXlQZOYKVuhEzU//rWYP/5ztEOZgho4NBNfFW+M+A8bQQku3hh3F
         iV3mZA475ZlSp+/dmxroKyeavnFf/ks+H8xiAsZY6aDKmtHCt6ExDpgHzi601tsZtUvC
         fQGQnnfxPm4IsEZmjxBOS2S5ozUvUPCeDiPfXWewZnaz18kOWyooITTfRA1meGzWbuQR
         BidOG9HEo0g8C7mKKRjmobDal1ZEbH1052Gd0mwj9R8Zvw7ItXiY/sfedxNC4PsXrEy7
         tsFd1+syQSOdoNz73I85QfJ4fB2b91WLPz3aQzXUq1pn2qm2tjg5w0LwCjKXAZcGbQlx
         iuHw==
X-Gm-Message-State: AOAM533R1p/ZCqDgytMyxPiusudlqq78aSIVGQullNvPCZfwkX11Lhzn
        W1ZuXr9eH7onX/gzch4M0rmL0GtlVQ==
X-Google-Smtp-Source: ABdhPJyPTzqwlaJmjAMy989rb4FDnUYANqJXZX6EmyL1Q/zs/9e1+0zpMusyhL/iNzygsKuO/yMgKg==
X-Received: by 2002:a17:902:ea93:b0:168:bc83:9ae3 with SMTP id x19-20020a170902ea9300b00168bc839ae3mr7539721plb.123.1654952109538;
        Sat, 11 Jun 2022 05:55:09 -0700 (PDT)
Received: from localhost.localdomain ([43.132.141.9])
        by smtp.gmail.com with ESMTPSA id b10-20020a170902bd4a00b00168b7d639acsm1440115plx.170.2022.06.11.05.55.08
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 11 Jun 2022 05:55:09 -0700 (PDT)
From:   xiakaixu1987@gmail.com
X-Google-Original-From: kaixuxia@tencent.com
To:     linux-xfs@vger.kernel.org
Cc:     djwong@kernel.org, david@fromorbit.com,
        Kaixu Xia <kaixuxia@tencent.com>
Subject: [PATCH 1/2] xfs: factor out the common lock flags assert
Date:   Sat, 11 Jun 2022 20:54:44 +0800
Message-Id: <1654952085-13035-2-git-send-email-kaixuxia@tencent.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1654952085-13035-1-git-send-email-kaixuxia@tencent.com>
References: <1654952085-13035-1-git-send-email-kaixuxia@tencent.com>
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

