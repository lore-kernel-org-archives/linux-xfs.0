Return-Path: <SRS0=ByWF=4N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3D0EC4BA09
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 23:10:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C8EDB2176D
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 23:10:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="WzinHhni"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729141AbgBYXKO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Feb 2020 18:10:14 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:53228 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729230AbgBYXKN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Feb 2020 18:10:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=ZLSTyaD86BzxjIuGrq6X2EkTrTChBEZATy+GTQ7mr9E=; b=WzinHhniv8mE4H9iEOWon76WHG
        lxas8O5/XQyVMApozh5tDKeiGclRCFky/IkbUaRKuZFnpyOBOSOy+SqaLwxz/YVIvwindNeBUO98h
        wJpIBTw8nMvXRn6NxK1cU8ZJKYopXcQyVtZBb8nWq8K0cNGrTX+fHOTKp684wrTNKTa+Wno5h8n7F
        sVzN+jgEtEw1f4JFecAhau8K2hr5uTNW61nPv0U1wwC12wBmuOfmeDu/mfWgSPbkeWb/x2eCWnXqQ
        1pW8tqwmOHDEhM2VNOxXa4cSe6Z/ZKU7/qz8bv4LzXGap39zTc4YObIIKyZzeJiQPMf/x9VO9Yl/N
        okKa+UMQ==;
Received: from [4.28.11.157] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j6jLB-00035Z-Kf; Tue, 25 Feb 2020 23:10:13 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>,
        Chandan Rajendra <chandanrlinux@gmail.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH 04/30] xfs: merge xfs_attrmulti_attr_remove into xfs_attrmulti_attr_set
Date:   Tue, 25 Feb 2020 15:09:46 -0800
Message-Id: <20200225231012.735245-5-hch@lst.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200225231012.735245-1-hch@lst.de>
References: <20200225231012.735245-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Merge the ioctl handlers just like the low-level xfs_attr_set function.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_ioctl.c   | 34 ++++++++++------------------------
 fs/xfs/xfs_ioctl.h   |  6 ------
 fs/xfs/xfs_ioctl32.c |  4 ++--
 3 files changed, 12 insertions(+), 32 deletions(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 79c418888e9a..b806003caacd 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -389,18 +389,20 @@ xfs_attrmulti_attr_set(
 	uint32_t		len,
 	uint32_t		flags)
 {
-	unsigned char		*kbuf;
+	unsigned char		*kbuf = NULL;
 	int			error;
 	size_t			namelen;
 
 	if (IS_IMMUTABLE(inode) || IS_APPEND(inode))
 		return -EPERM;
-	if (len > XFS_XATTR_SIZE_MAX)
-		return -EINVAL;
 
-	kbuf = memdup_user(ubuf, len);
-	if (IS_ERR(kbuf))
-		return PTR_ERR(kbuf);
+	if (ubuf) {
+		if (len > XFS_XATTR_SIZE_MAX)
+			return -EINVAL;
+		kbuf = memdup_user(ubuf, len);
+		if (IS_ERR(kbuf))
+			return PTR_ERR(kbuf);
+	}
 
 	namelen = strlen(name);
 	error = xfs_attr_set(XFS_I(inode), name, namelen, kbuf, len, flags);
@@ -410,22 +412,6 @@ xfs_attrmulti_attr_set(
 	return error;
 }
 
-int
-xfs_attrmulti_attr_remove(
-	struct inode		*inode,
-	unsigned char		*name,
-	uint32_t		flags)
-{
-	int			error;
-
-	if (IS_IMMUTABLE(inode) || IS_APPEND(inode))
-		return -EPERM;
-	error = xfs_attr_set(XFS_I(inode), name, strlen(name), NULL, 0, flags);
-	if (!error)
-		xfs_forget_acl(inode, name, flags);
-	return error;
-}
-
 STATIC int
 xfs_attrmulti_by_handle(
 	struct file		*parfilp,
@@ -504,8 +490,8 @@ xfs_attrmulti_by_handle(
 			ops[i].am_error = mnt_want_write_file(parfilp);
 			if (ops[i].am_error)
 				break;
-			ops[i].am_error = xfs_attrmulti_attr_remove(
-					d_inode(dentry), attr_name,
+			ops[i].am_error = xfs_attrmulti_attr_set(
+					d_inode(dentry), attr_name, NULL, 0,
 					ops[i].am_flags);
 			mnt_drop_write_file(parfilp);
 			break;
diff --git a/fs/xfs/xfs_ioctl.h b/fs/xfs/xfs_ioctl.h
index 420bd95dc326..819504df00ae 100644
--- a/fs/xfs/xfs_ioctl.h
+++ b/fs/xfs/xfs_ioctl.h
@@ -46,12 +46,6 @@ xfs_attrmulti_attr_set(
 	uint32_t		len,
 	uint32_t		flags);
 
-extern int
-xfs_attrmulti_attr_remove(
-	struct inode		*inode,
-	unsigned char		*name,
-	uint32_t		flags);
-
 extern struct dentry *
 xfs_handle_to_dentry(
 	struct file		*parfilp,
diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
index 9705172e5410..e085f304e539 100644
--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -488,8 +488,8 @@ xfs_compat_attrmulti_by_handle(
 			ops[i].am_error = mnt_want_write_file(parfilp);
 			if (ops[i].am_error)
 				break;
-			ops[i].am_error = xfs_attrmulti_attr_remove(
-					d_inode(dentry), attr_name,
+			ops[i].am_error = xfs_attrmulti_attr_set(
+					d_inode(dentry), attr_name, NULL, 0,
 					ops[i].am_flags);
 			mnt_drop_write_file(parfilp);
 			break;
-- 
2.24.1

