Return-Path: <SRS0=HAJZ=4O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82C17C4BA24
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Feb 2020 20:23:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4EA992072D
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Feb 2020 20:23:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="OkjmwPZE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727335AbgBZUXj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 Feb 2020 15:23:39 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:34720 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727260AbgBZUXi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Feb 2020 15:23:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=ZLSTyaD86BzxjIuGrq6X2EkTrTChBEZATy+GTQ7mr9E=; b=OkjmwPZEVi0v0ezykZDujgEdX3
        BurEeiLOw1FHajgHtQbHlI4Cy54zMu0wnLLkybyCX1zayBLkGQhr1nAQpxyMPa6Cj9I8FX4/l/lTf
        QSZnwQp8CpzzcX7ZJB3ikyJSb7EydJbmQNIkUDSatoZFdhKL7ygfJwyvEvkqvaEjNUmqb58h5A05Z
        7I0agwTo0Yt6XR6ZCFpT+1ySLDM0a9H9POsZ6k3Pa0Lw/+nxfAGhQFWObswnCYj+l5T40yslJuByZ
        2Lc8ML/yqivpTTfNBK7jMUEbQNVNileh994sOa/218CBG9nG9sLckxtzuF9l41VwyMAJ+PUWSuC/F
        V96UpSlA==;
Received: from [199.255.44.128] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j73DW-0008L2-MW; Wed, 26 Feb 2020 20:23:38 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>,
        Chandan Rajendra <chandanrlinux@gmail.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH 04/32] xfs: merge xfs_attrmulti_attr_remove into xfs_attrmulti_attr_set
Date:   Wed, 26 Feb 2020 12:22:38 -0800
Message-Id: <20200226202306.871241-5-hch@lst.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200226202306.871241-1-hch@lst.de>
References: <20200226202306.871241-1-hch@lst.de>
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

