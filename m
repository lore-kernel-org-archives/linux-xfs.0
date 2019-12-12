Return-Path: <SRS0=0MSb=2C=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2856DC43603
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Dec 2019 10:55:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E85542173E
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Dec 2019 10:55:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="K31MiIPa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728777AbfLLKzn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Dec 2019 05:55:43 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:53382 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728722AbfLLKzn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Dec 2019 05:55:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=wE7JPBjZ4Yf3CeMt44PkvbgsLqIQnk+qymUfmiN+ow8=; b=K31MiIPagRPjbJBKf+wL+JevLk
        DmgX68kqpxUk3rktqIY/VzpZEowdIaq6Xawpr8mG1M/LqVQQ/w7/E/Tdo93os/ySx1X4ck41qEj16
        fyTRpd4VyCxpPA68605bKM2ZZ/96RzVslAnZh4WspSNTtl+is483E858+uOQ+bWPcJDXcEy54zlN4
        LyBc2DM1gPURCwBEeAG0gpEbyBGxMZMjgsPY7fLxXO5CEgFglu9gu2mtcwK8dFkZZNwDKOwGAtjED
        9nN4+1dQKLulU5kLlCeEvuTiX2HkNwyq7ULStcz8TrQhq564Gqj4YcbJLtYb3uDjlUH1ZDKIJneTb
        v0G1S/yA==;
Received: from clnet-p19-102.ikbnet.co.at ([83.175.77.102] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ifM8E-0002Xu-Ho; Thu, 12 Dec 2019 10:55:42 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Allison Collins <allison.henderson@oracle.com>
Subject: [PATCH 28/33] xfs: lift cursor copy in/out into xfs_ioc_attr_list
Date:   Thu, 12 Dec 2019 11:54:28 +0100
Message-Id: <20191212105433.1692-29-hch@lst.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191212105433.1692-1-hch@lst.de>
References: <20191212105433.1692-1-hch@lst.de>
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
---
 fs/xfs/xfs_ioctl.c   | 36 +++++++++++++++---------------------
 fs/xfs/xfs_ioctl.h   |  2 +-
 fs/xfs/xfs_ioctl32.c | 19 ++++---------------
 3 files changed, 20 insertions(+), 37 deletions(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index f4b1aee0f362..03be37699668 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -356,9 +356,10 @@ xfs_ioc_attr_list(
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
index 79c9f3c64ce6..fd5eb5304b1c 100644
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
2.20.1

