Return-Path: <SRS0=zOuE=3S=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AD4EC2D0DB
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jan 2020 17:04:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2F30B2071E
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jan 2020 17:04:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="PmxlzfyB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727025AbgA2REN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Jan 2020 12:04:13 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:46758 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726955AbgA2REN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Jan 2020 12:04:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=oN8kjUz33jZuwgHaEGlrqZNXsNjRLMxauEkjdU+Et9w=; b=PmxlzfyBviuHpW3H3BADx86IqZ
        f1J71mvFlAXB+0Ed35abTj6EueiIKUKhsNSEdp3c3up0uwKfebAtCw4Pgo1fltkG/YQBCHt9LwuBy
        RH8fT0dnob6cEELLj1uO+bm/fl/tCUXhaVsv6NB7wAlCSUJnlnHTMtIk7eMczBHaDG9Kd4t8iSato
        8DzWg0XsxsdKiPFB4slb0vuLC22qP/SWBKlmADKofe/F9Nyop4x7PhJRRRiO/j14Bog2Br5uzvjM5
        Dq/f561+LVXJN67oK7lFYzHzOMXw9lMokO9NP3xndf6h4nn8Ex7xQIS8O/O2lQLBWfJ9rsliUC6nP
        LfHpQnvg==;
Received: from [2001:4bb8:18c:3335:c19:50e8:dbcf:dcc6] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iwqlB-0006zV-30; Wed, 29 Jan 2020 17:04:13 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Allison Collins <allison.henderson@oracle.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH 24/30] xfs: lift buffer allocation into xfs_ioc_attr_list
Date:   Wed, 29 Jan 2020 18:03:03 +0100
Message-Id: <20200129170310.51370-25-hch@lst.de>
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

Lift the buffer allocation from the two callers into xfs_ioc_attr_list.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_ioctl.c   | 39 ++++++++++++++++-----------------------
 fs/xfs/xfs_ioctl.h   |  2 +-
 fs/xfs/xfs_ioctl32.c | 22 +++++-----------------
 3 files changed, 22 insertions(+), 41 deletions(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index c8814808a551..cdb3800dfcef 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -351,13 +351,14 @@ xfs_ioc_attr_put_listent(
 int
 xfs_ioc_attr_list(
 	struct xfs_inode		*dp,
-	char				*buffer,
+	void __user			*ubuf,
 	int				bufsize,
 	int				flags,
 	struct attrlist_cursor_kern	*cursor)
 {
 	struct xfs_attr_list_context	context;
 	struct xfs_attrlist		*alist;
+	void				*buffer;
 	int				error;
 
 	if (bufsize < sizeof(struct xfs_attrlist) ||
@@ -381,11 +382,9 @@ xfs_ioc_attr_list(
 	    (cursor->hashval || cursor->blkno || cursor->offset))
 		return -EINVAL;
 
-	/*
-	 * Check for a properly aligned buffer.
-	 */
-	if (((long)buffer) & (sizeof(int)-1))
-		return -EFAULT;
+	buffer = kmem_zalloc_large(bufsize, 0);
+	if (!buffer)
+		return -ENOMEM;
 
 	/*
 	 * Initialize the output buffer.
@@ -406,7 +405,13 @@ xfs_ioc_attr_list(
 	alist->al_offset[0] = context.bufsize;
 
 	error = xfs_attr_list(&context);
-	ASSERT(error <= 0);
+	if (error)
+		goto out_free;
+
+	if (copy_to_user(ubuf, buffer, bufsize))
+		error = -EFAULT;
+out_free:
+	kmem_free(buffer);
 	return error;
 }
 
@@ -420,7 +425,6 @@ xfs_attrlist_by_handle(
 	struct xfs_fsop_attrlist_handlereq __user	*p = arg;
 	xfs_fsop_attrlist_handlereq_t al_hreq;
 	struct dentry		*dentry;
-	char			*kbuf;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
@@ -431,26 +435,15 @@ xfs_attrlist_by_handle(
 	if (IS_ERR(dentry))
 		return PTR_ERR(dentry);
 
-	kbuf = kmem_zalloc_large(al_hreq.buflen, 0);
-	if (!kbuf)
-		goto out_dput;
-
 	cursor = (attrlist_cursor_kern_t *)&al_hreq.pos;
-	error = xfs_ioc_attr_list(XFS_I(d_inode(dentry)), kbuf, al_hreq.buflen,
-					al_hreq.flags, cursor);
+	error = xfs_ioc_attr_list(XFS_I(d_inode(dentry)), al_hreq.buffer,
+				  al_hreq.buflen, al_hreq.flags, cursor);
 	if (error)
-		goto out_kfree;
-
-	if (copy_to_user(&p->pos, cursor, sizeof(attrlist_cursor_kern_t))) {
-		error = -EFAULT;
-		goto out_kfree;
-	}
+		goto out_dput;
 
-	if (copy_to_user(al_hreq.buffer, kbuf, al_hreq.buflen))
+	if (copy_to_user(&p->pos, cursor, sizeof(attrlist_cursor_kern_t)))
 		error = -EFAULT;
 
-out_kfree:
-	kmem_free(kbuf);
 out_dput:
 	dput(dentry);
 	return error;
diff --git a/fs/xfs/xfs_ioctl.h b/fs/xfs/xfs_ioctl.h
index cb7b94c576a7..ec6448b259fb 100644
--- a/fs/xfs/xfs_ioctl.h
+++ b/fs/xfs/xfs_ioctl.h
@@ -39,7 +39,7 @@ xfs_readlink_by_handle(
 int xfs_ioc_attrmulti_one(struct file *parfilp, struct inode *inode,
 		uint32_t opcode, void __user *uname, void __user *value,
 		uint32_t *len, uint32_t flags);
-int xfs_ioc_attr_list(struct xfs_inode *dp, char *buffer, int bufsize,
+int xfs_ioc_attr_list(struct xfs_inode *dp, void __user *ubuf, int bufsize,
 	int flags, struct attrlist_cursor_kern *cursor);
 
 extern struct dentry *
diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
index 840d17951407..17e14916757b 100644
--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -359,7 +359,6 @@ xfs_compat_attrlist_by_handle(
 	compat_xfs_fsop_attrlist_handlereq_t __user *p = arg;
 	compat_xfs_fsop_attrlist_handlereq_t al_hreq;
 	struct dentry		*dentry;
-	char			*kbuf;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
@@ -371,27 +370,16 @@ xfs_compat_attrlist_by_handle(
 	if (IS_ERR(dentry))
 		return PTR_ERR(dentry);
 
-	error = -ENOMEM;
-	kbuf = kmem_zalloc_large(al_hreq.buflen, 0);
-	if (!kbuf)
-		goto out_dput;
-
 	cursor = (attrlist_cursor_kern_t *)&al_hreq.pos;
-	error = xfs_ioc_attr_list(XFS_I(d_inode(dentry)), kbuf, al_hreq.buflen,
-					al_hreq.flags, cursor);
+	error = xfs_ioc_attr_list(XFS_I(d_inode(dentry)),
+			compat_ptr(al_hreq.buffer), al_hreq.buflen,
+			al_hreq.flags, cursor);
 	if (error)
-		goto out_kfree;
-
-	if (copy_to_user(&p->pos, cursor, sizeof(attrlist_cursor_kern_t))) {
-		error = -EFAULT;
-		goto out_kfree;
-	}
+		goto out_dput;
 
-	if (copy_to_user(compat_ptr(al_hreq.buffer), kbuf, al_hreq.buflen))
+	if (copy_to_user(&p->pos, cursor, sizeof(attrlist_cursor_kern_t)))
 		error = -EFAULT;
 
-out_kfree:
-	kmem_free(kbuf);
 out_dput:
 	dput(dentry);
 	return error;
-- 
2.24.1

