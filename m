Return-Path: <SRS0=OQuR=ZA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3814AFA372C
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 05:23:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F2676214DB
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 05:23:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="g8IL6Avd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725794AbfKHFXJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 8 Nov 2019 00:23:09 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:39900 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725765AbfKHFXJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Nov 2019 00:23:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=wO/rvKHc49CMffP4LEUO48u2c0KVqJb2xzmMg3g5a7k=; b=g8IL6AvdnlUIEw5XuewJaIzul
        ILEGRyJ6rosD39/6fUJcjCaXZaFwS7a2xxznL46k8nCL19n/OeBVhe3iVL6s9LCBu1CBiVDsoo282
        MeBrQidrBEY+o3jHbFiRyQ8fyyTd/Hyl8BLQbLYe5grOIZxljHL/3xd7ztkzRMM5BftM76WYlt3yn
        wj9+UoDShnQ3PcVqpDkkhYBl/j4Eo6DCYwT3kuR9PztHMC+3KPptYqQcYSYIm/EIc7xHJI3sF7Bkd
        ky6uyLyEAxgcY5pNFR+BXjeRp4m2ig95XyWRQ/qabr+5i8R4GGdUR29HRSYtZXUifVNj7N4pTqCRy
        yt+QWK7gw==;
Received: from [2001:4bb8:184:e48:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iSwjk-0005zD-G6
        for linux-xfs@vger.kernel.org; Fri, 08 Nov 2019 05:23:08 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: remove XFS_IOC_FSSETDM and XFS_IOC_FSSETDM_BY_HANDLE
Date:   Fri,  8 Nov 2019 06:23:03 +0100
Message-Id: <20191108052303.15052-1-hch@lst.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Thes ioctls set DMAPI specific flags in the on-disk inode, but there is
no way to actually ever query those flags.  The only known user is
xfsrestore with the -D option, which is documented to be only useful
inside a DMAPI enviroment, which isn't supported by upstream XFS.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_ioctl.c   | 94 --------------------------------------------
 fs/xfs/xfs_ioctl.h   |  6 ---
 fs/xfs/xfs_ioctl32.c | 40 -------------------
 fs/xfs/xfs_ioctl32.h |  9 -----
 4 files changed, 149 deletions(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 287f83eb791f..a979d730203a 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -291,82 +291,6 @@ xfs_readlink_by_handle(
 	return error;
 }
 
-int
-xfs_set_dmattrs(
-	xfs_inode_t     *ip,
-	uint		evmask,
-	uint16_t	state)
-{
-	xfs_mount_t	*mp = ip->i_mount;
-	xfs_trans_t	*tp;
-	int		error;
-
-	if (!capable(CAP_SYS_ADMIN))
-		return -EPERM;
-
-	if (XFS_FORCED_SHUTDOWN(mp))
-		return -EIO;
-
-	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_ichange, 0, 0, 0, &tp);
-	if (error)
-		return error;
-
-	xfs_ilock(ip, XFS_ILOCK_EXCL);
-	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
-
-	ip->i_d.di_dmevmask = evmask;
-	ip->i_d.di_dmstate  = state;
-
-	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
-	error = xfs_trans_commit(tp);
-
-	return error;
-}
-
-STATIC int
-xfs_fssetdm_by_handle(
-	struct file		*parfilp,
-	void			__user *arg)
-{
-	int			error;
-	struct fsdmidata	fsd;
-	xfs_fsop_setdm_handlereq_t dmhreq;
-	struct dentry		*dentry;
-
-	if (!capable(CAP_MKNOD))
-		return -EPERM;
-	if (copy_from_user(&dmhreq, arg, sizeof(xfs_fsop_setdm_handlereq_t)))
-		return -EFAULT;
-
-	error = mnt_want_write_file(parfilp);
-	if (error)
-		return error;
-
-	dentry = xfs_handlereq_to_dentry(parfilp, &dmhreq.hreq);
-	if (IS_ERR(dentry)) {
-		mnt_drop_write_file(parfilp);
-		return PTR_ERR(dentry);
-	}
-
-	if (IS_IMMUTABLE(d_inode(dentry)) || IS_APPEND(d_inode(dentry))) {
-		error = -EPERM;
-		goto out;
-	}
-
-	if (copy_from_user(&fsd, dmhreq.data, sizeof(fsd))) {
-		error = -EFAULT;
-		goto out;
-	}
-
-	error = xfs_set_dmattrs(XFS_I(d_inode(dentry)), fsd.fsd_dmevmask,
-				 fsd.fsd_dmstate);
-
- out:
-	mnt_drop_write_file(parfilp);
-	dput(dentry);
-	return error;
-}
-
 STATIC int
 xfs_attrlist_by_handle(
 	struct file		*parfilp,
@@ -2126,22 +2050,6 @@ xfs_file_ioctl(
 	case XFS_IOC_SETXFLAGS:
 		return xfs_ioc_setxflags(ip, filp, arg);
 
-	case XFS_IOC_FSSETDM: {
-		struct fsdmidata	dmi;
-
-		if (copy_from_user(&dmi, arg, sizeof(dmi)))
-			return -EFAULT;
-
-		error = mnt_want_write_file(filp);
-		if (error)
-			return error;
-
-		error = xfs_set_dmattrs(ip, dmi.fsd_dmevmask,
-				dmi.fsd_dmstate);
-		mnt_drop_write_file(filp);
-		return error;
-	}
-
 	case XFS_IOC_GETBMAP:
 	case XFS_IOC_GETBMAPA:
 	case XFS_IOC_GETBMAPX:
@@ -2169,8 +2077,6 @@ xfs_file_ioctl(
 			return -EFAULT;
 		return xfs_open_by_handle(filp, &hreq);
 	}
-	case XFS_IOC_FSSETDM_BY_HANDLE:
-		return xfs_fssetdm_by_handle(filp, arg);
 
 	case XFS_IOC_READLINK_BY_HANDLE: {
 		xfs_fsop_handlereq_t	hreq;
diff --git a/fs/xfs/xfs_ioctl.h b/fs/xfs/xfs_ioctl.h
index 25ef178cbb74..420bd95dc326 100644
--- a/fs/xfs/xfs_ioctl.h
+++ b/fs/xfs/xfs_ioctl.h
@@ -70,12 +70,6 @@ xfs_file_compat_ioctl(
 	unsigned int		cmd,
 	unsigned long		arg);
 
-extern int
-xfs_set_dmattrs(
-	struct xfs_inode	*ip,
-	uint			evmask,
-	uint16_t		state);
-
 struct xfs_ibulk;
 struct xfs_bstat;
 struct xfs_inogrp;
diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
index 3c0d518e1039..c4c4f09113d3 100644
--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -500,44 +500,6 @@ xfs_compat_attrmulti_by_handle(
 	return error;
 }
 
-STATIC int
-xfs_compat_fssetdm_by_handle(
-	struct file		*parfilp,
-	void			__user *arg)
-{
-	int			error;
-	struct fsdmidata	fsd;
-	compat_xfs_fsop_setdm_handlereq_t dmhreq;
-	struct dentry		*dentry;
-
-	if (!capable(CAP_MKNOD))
-		return -EPERM;
-	if (copy_from_user(&dmhreq, arg,
-			   sizeof(compat_xfs_fsop_setdm_handlereq_t)))
-		return -EFAULT;
-
-	dentry = xfs_compat_handlereq_to_dentry(parfilp, &dmhreq.hreq);
-	if (IS_ERR(dentry))
-		return PTR_ERR(dentry);
-
-	if (IS_IMMUTABLE(d_inode(dentry)) || IS_APPEND(d_inode(dentry))) {
-		error = -EPERM;
-		goto out;
-	}
-
-	if (copy_from_user(&fsd, compat_ptr(dmhreq.data), sizeof(fsd))) {
-		error = -EFAULT;
-		goto out;
-	}
-
-	error = xfs_set_dmattrs(XFS_I(d_inode(dentry)), fsd.fsd_dmevmask,
-				 fsd.fsd_dmstate);
-
-out:
-	dput(dentry);
-	return error;
-}
-
 long
 xfs_file_compat_ioctl(
 	struct file		*filp,
@@ -646,8 +608,6 @@ xfs_file_compat_ioctl(
 		return xfs_compat_attrlist_by_handle(filp, arg);
 	case XFS_IOC_ATTRMULTI_BY_HANDLE_32:
 		return xfs_compat_attrmulti_by_handle(filp, arg);
-	case XFS_IOC_FSSETDM_BY_HANDLE_32:
-		return xfs_compat_fssetdm_by_handle(filp, arg);
 	default:
 		/* try the native version */
 		return xfs_file_ioctl(filp, cmd, (unsigned long)arg);
diff --git a/fs/xfs/xfs_ioctl32.h b/fs/xfs/xfs_ioctl32.h
index 7985344d3aa6..7cbd6a0ee3e9 100644
--- a/fs/xfs/xfs_ioctl32.h
+++ b/fs/xfs/xfs_ioctl32.h
@@ -143,15 +143,6 @@ typedef struct compat_xfs_fsop_attrmulti_handlereq {
 #define XFS_IOC_ATTRMULTI_BY_HANDLE_32 \
 	_IOW('X', 123, struct compat_xfs_fsop_attrmulti_handlereq)
 
-typedef struct compat_xfs_fsop_setdm_handlereq {
-	struct compat_xfs_fsop_handlereq hreq;	/* handle information   */
-	/* ptr to struct fsdmidata */
-	compat_uptr_t			data;	/* DMAPI data   */
-} compat_xfs_fsop_setdm_handlereq_t;
-
-#define XFS_IOC_FSSETDM_BY_HANDLE_32 \
-	_IOW('X', 121, struct compat_xfs_fsop_setdm_handlereq)
-
 #ifdef BROKEN_X86_ALIGNMENT
 /* on ia32 l_start is on a 32-bit boundary */
 typedef struct compat_xfs_flock64 {
-- 
2.20.1

