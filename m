Return-Path: <SRS0=zOuE=3S=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4B28C2D0DB
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jan 2020 17:04:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A8C972070E
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jan 2020 17:04:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="VFV9vGj5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726955AbgA2REQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Jan 2020 12:04:16 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:46772 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726847AbgA2REQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Jan 2020 12:04:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=YAkJO01Y/EBHGmr2xJfh//rqk9j+BqL7+OXwkfP6d4U=; b=VFV9vGj5u93hm3j3reaywP4Jvc
        IdA/R1Psr0geP0YcGtcFlYlkXV+I9rMrJSkDXW3kfvh2RzeoHPsGEIKNs4JL6MCwm//1rwa5I486r
        RM3cOA1FaESOhnKgbbSAnHejBK+oj0zSYCyaMMmOEEek7NcbnMoRpHF4/blBHbRDcwdvx606dxy0t
        FmCO3CasYnAQeoyD1xljQ++c4cOMVzXlc75NRTFR6xssCfY0SYijWEQIViS6GaO1yS+C9n1eYr5/8
        87uN+VrO2jTRm+4yp15GdlNx/QLjRZUbzg5Eld95DQPX/5RnGhd1n0cdtt3k5VY2UQ48IdHvUdd2j
        a+UFwVcw==;
Received: from [2001:4bb8:18c:3335:c19:50e8:dbcf:dcc6] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iwqlD-0006zt-Ir; Wed, 29 Jan 2020 17:04:15 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Allison Collins <allison.henderson@oracle.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH 25/30] xfs: lift cursor copy in/out into xfs_ioc_attr_list
Date:   Wed, 29 Jan 2020 18:03:04 +0100
Message-Id: <20200129170310.51370-26-hch@lst.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200129170310.51370-1-hch@lst.de>
References: <20200129170310.51370-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Lift the common code to copy the cursor from and to user space into
xfs_ioc_attr_list.  Note that this means we copy in twice now as
the cursor is in the middle of the conaining structure, but we never
touch the memory for the original copy.  Doing so keeps the cursor
handling isolated in the common helper.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_ioctl.c   | 36 +++++++++++++++---------------------
 fs/xfs/xfs_ioctl.h   |  2 +-
 fs/xfs/xfs_ioctl32.c | 19 ++++---------------
 3 files changed, 20 insertions(+), 37 deletions(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index cdb3800dfcef..5d160e82778e 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -354,9 +354,10 @@ xfs_ioc_attr_list(
 	void __user			*ubuf,
 	int				bufsize,
 	int				flags,
-	struct attrlist_cursor_kern	*cursor)
+	struct xfs_attrlist_cursor __user *ucursor)
 {
 	struct xfs_attr_list_context	context;
+	struct attrlist_cursor_kern	cursor;
 	struct xfs_attrlist		*alist;
 	void				*buffer;
 	int				error;
@@ -376,10 +377,12 @@ xfs_ioc_attr_list(
 	/*
 	 * Validate the cursor.
 	 */
-	if (cursor->pad1 || cursor->pad2)
+	if (copy_from_user(&cursor, ucursor, sizeof(cursor)))
+		return -EFAULT;
+	if (cursor.pad1 || cursor.pad2)
 		return -EINVAL;
-	if ((cursor->initted == 0) &&
-	    (cursor->hashval || cursor->blkno || cursor->offset))
+	if ((cursor.initted == 0) &&
+	    (cursor.hashval || cursor.blkno || cursor.offset))
 		return -EINVAL;
 
 	buffer = kmem_zalloc_large(bufsize, 0);
@@ -391,7 +394,7 @@ xfs_ioc_attr_list(
 	 */
 	memset(&context, 0, sizeof(context));
 	context.dp = dp;
-	context.cursor = cursor;
+	context.cursor = &cursor;
 	context.resynch = 1;
 	context.flags = flags;
 	context.buffer = buffer;
@@ -408,7 +411,8 @@ xfs_ioc_attr_list(
 	if (error)
 		goto out_free;
 
-	if (copy_to_user(ubuf, buffer, bufsize))
+	if (copy_to_user(ubuf, buffer, bufsize) ||
+	    copy_to_user(ucursor, &cursor, sizeof(cursor)))
 		error = -EFAULT;
 out_free:
 	kmem_free(buffer);
@@ -418,33 +422,23 @@ xfs_ioc_attr_list(
 STATIC int
 xfs_attrlist_by_handle(
 	struct file		*parfilp,
-	void			__user *arg)
+	struct xfs_fsop_attrlist_handlereq __user *p)
 {
-	int			error = -ENOMEM;
-	attrlist_cursor_kern_t	*cursor;
-	struct xfs_fsop_attrlist_handlereq __user	*p = arg;
-	xfs_fsop_attrlist_handlereq_t al_hreq;
+	struct xfs_fsop_attrlist_handlereq al_hreq;
 	struct dentry		*dentry;
+	int			error = -ENOMEM;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
-	if (copy_from_user(&al_hreq, arg, sizeof(xfs_fsop_attrlist_handlereq_t)))
+	if (copy_from_user(&al_hreq, p, sizeof(al_hreq)))
 		return -EFAULT;
 
 	dentry = xfs_handlereq_to_dentry(parfilp, &al_hreq.hreq);
 	if (IS_ERR(dentry))
 		return PTR_ERR(dentry);
 
-	cursor = (attrlist_cursor_kern_t *)&al_hreq.pos;
 	error = xfs_ioc_attr_list(XFS_I(d_inode(dentry)), al_hreq.buffer,
-				  al_hreq.buflen, al_hreq.flags, cursor);
-	if (error)
-		goto out_dput;
-
-	if (copy_to_user(&p->pos, cursor, sizeof(attrlist_cursor_kern_t)))
-		error = -EFAULT;
-
-out_dput:
+				  al_hreq.buflen, al_hreq.flags, &p->pos);
 	dput(dentry);
 	return error;
 }
diff --git a/fs/xfs/xfs_ioctl.h b/fs/xfs/xfs_ioctl.h
index ec6448b259fb..d6e8000ad825 100644
--- a/fs/xfs/xfs_ioctl.h
+++ b/fs/xfs/xfs_ioctl.h
@@ -40,7 +40,7 @@ int xfs_ioc_attrmulti_one(struct file *parfilp, struct inode *inode,
 		uint32_t opcode, void __user *uname, void __user *value,
 		uint32_t *len, uint32_t flags);
 int xfs_ioc_attr_list(struct xfs_inode *dp, void __user *ubuf, int bufsize,
-	int flags, struct attrlist_cursor_kern *cursor);
+	int flags, struct xfs_attrlist_cursor __user *ucursor);
 
 extern struct dentry *
 xfs_handle_to_dentry(
diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
index 17e14916757b..c1771e728117 100644
--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -352,35 +352,24 @@ xfs_compat_handlereq_to_dentry(
 STATIC int
 xfs_compat_attrlist_by_handle(
 	struct file		*parfilp,
-	void			__user *arg)
+	compat_xfs_fsop_attrlist_handlereq_t __user *p)
 {
-	int			error;
-	attrlist_cursor_kern_t	*cursor;
-	compat_xfs_fsop_attrlist_handlereq_t __user *p = arg;
 	compat_xfs_fsop_attrlist_handlereq_t al_hreq;
 	struct dentry		*dentry;
+	int			error;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
-	if (copy_from_user(&al_hreq, arg,
-			   sizeof(compat_xfs_fsop_attrlist_handlereq_t)))
+	if (copy_from_user(&al_hreq, p, sizeof(al_hreq)))
 		return -EFAULT;
 
 	dentry = xfs_compat_handlereq_to_dentry(parfilp, &al_hreq.hreq);
 	if (IS_ERR(dentry))
 		return PTR_ERR(dentry);
 
-	cursor = (attrlist_cursor_kern_t *)&al_hreq.pos;
 	error = xfs_ioc_attr_list(XFS_I(d_inode(dentry)),
 			compat_ptr(al_hreq.buffer), al_hreq.buflen,
-			al_hreq.flags, cursor);
-	if (error)
-		goto out_dput;
-
-	if (copy_to_user(&p->pos, cursor, sizeof(attrlist_cursor_kern_t)))
-		error = -EFAULT;
-
-out_dput:
+			al_hreq.flags, &p->pos);
 	dput(dentry);
 	return error;
 }
-- 
2.24.1

