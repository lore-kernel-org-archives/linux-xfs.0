Return-Path: <SRS0=HAJZ=4O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34916C4BA24
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Feb 2020 20:23:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F091A24670
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Feb 2020 20:23:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="bE+riqxF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727338AbgBZUXt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 Feb 2020 15:23:49 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:34788 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727260AbgBZUXt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Feb 2020 15:23:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=FjhIvotEOW062HzhZx5fOlj65sjV4+Brk4BJR/P8jRc=; b=bE+riqxFqPO/BvW/ZZjsp1OFZt
        ng8bOdmyqxafWTenrbNgOXZzihMF/wHVq66pDx9FGEEi/F55rlgQ0mbH3WSrvxuLBZsLMnTXTjQAA
        r4dCZiTrf81bJWStdGbaRWQbPGEKJZGPMqSANoq05mW3oMwEp/rTmh1SDeCzxLM0GFNHLb/PEnQaD
        j24BbYCUc/+UTc8t11fEFUwuFrcfhEOC7g0DMQCjx3oxVwd+/r7VhTdOF4TtQb4cu7Srybp9MbpWd
        xxvD28rPoIrc0KmttUPhMzdE3j3sDXp9ZrEaUZdmcsSVd0aeUzrcXBiLwHWgQr7ZftjHxcjSSqBkZ
        dOhtypMQ==;
Received: from [199.255.44.128] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j73Dh-0008MY-7x; Wed, 26 Feb 2020 20:23:49 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>,
        Chandan Rajendra <chandanrlinux@gmail.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH 06/32] xfs: factor out a helper for a single XFS_IOC_ATTRMULTI_BY_HANDLE op
Date:   Wed, 26 Feb 2020 12:22:40 -0800
Message-Id: <20200226202306.871241-7-hch@lst.de>
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

Add a new helper to handle a single attr multi ioctl operation that
can be shared between the native and compat ioctl implementation.

There is a slight change in behaviour in that we don't break out of the
loop when copying in the attribute name fails.  The previous behaviour
was rather inconsistent here as it continued for any other kind of
error, and that we don't clear the flags in the structure returned
to userspace, a behavior only introduced as a bug fix in the last
merge window.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_ioctl.c   | 97 +++++++++++++++++++++++---------------------
 fs/xfs/xfs_ioctl.h   | 18 ++------
 fs/xfs/xfs_ioctl32.c | 50 +++--------------------
 3 files changed, 59 insertions(+), 106 deletions(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index bb490a954c0b..b17458c8947e 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -349,7 +349,7 @@ xfs_attrlist_by_handle(
 	return error;
 }
 
-int
+static int
 xfs_attrmulti_attr_get(
 	struct inode		*inode,
 	unsigned char		*name,
@@ -381,7 +381,7 @@ xfs_attrmulti_attr_get(
 	return error;
 }
 
-int
+static int
 xfs_attrmulti_attr_set(
 	struct inode		*inode,
 	unsigned char		*name,
@@ -412,6 +412,51 @@ xfs_attrmulti_attr_set(
 	return error;
 }
 
+int
+xfs_ioc_attrmulti_one(
+	struct file		*parfilp,
+	struct inode		*inode,
+	uint32_t		opcode,
+	void __user		*uname,
+	void __user		*value,
+	uint32_t		*len,
+	uint32_t		flags)
+{
+	unsigned char		*name;
+	int			error;
+
+	if ((flags & ATTR_ROOT) && (flags & ATTR_SECURE))
+		return -EINVAL;
+	flags &= ~ATTR_KERNEL_FLAGS;
+
+	name = strndup_user(uname, MAXNAMELEN);
+	if (IS_ERR(name))
+		return PTR_ERR(name);
+
+	switch (opcode) {
+	case ATTR_OP_GET:
+		error = xfs_attrmulti_attr_get(inode, name, value, len, flags);
+		break;
+	case ATTR_OP_REMOVE:
+		value = NULL;
+		*len = 0;
+		/* fall through */
+	case ATTR_OP_SET:
+		error = mnt_want_write_file(parfilp);
+		if (error)
+			break;
+		error = xfs_attrmulti_attr_set(inode, name, value, *len, flags);
+		mnt_drop_write_file(parfilp);
+		break;
+	default:
+		error = -EINVAL;
+		break;
+	}
+
+	kfree(name);
+	return error;
+}
+
 STATIC int
 xfs_attrmulti_by_handle(
 	struct file		*parfilp,
@@ -422,7 +467,6 @@ xfs_attrmulti_by_handle(
 	xfs_fsop_attrmulti_handlereq_t am_hreq;
 	struct dentry		*dentry;
 	unsigned int		i, size;
-	unsigned char		*attr_name;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
@@ -450,49 +494,10 @@ xfs_attrmulti_by_handle(
 
 	error = 0;
 	for (i = 0; i < am_hreq.opcount; i++) {
-		if ((ops[i].am_flags & ATTR_ROOT) &&
-		    (ops[i].am_flags & ATTR_SECURE)) {
-			ops[i].am_error = -EINVAL;
-			continue;
-		}
-		ops[i].am_flags &= ~ATTR_KERNEL_FLAGS;
-
-		attr_name = strndup_user(ops[i].am_attrname, MAXNAMELEN);
-		if (IS_ERR(attr_name)) {
-			ops[i].am_error = PTR_ERR(attr_name);
-			break;
-		}
-
-		switch (ops[i].am_opcode) {
-		case ATTR_OP_GET:
-			ops[i].am_error = xfs_attrmulti_attr_get(
-					d_inode(dentry), attr_name,
-					ops[i].am_attrvalue, &ops[i].am_length,
-					ops[i].am_flags);
-			break;
-		case ATTR_OP_SET:
-			ops[i].am_error = mnt_want_write_file(parfilp);
-			if (ops[i].am_error)
-				break;
-			ops[i].am_error = xfs_attrmulti_attr_set(
-					d_inode(dentry), attr_name,
-					ops[i].am_attrvalue, ops[i].am_length,
-					ops[i].am_flags);
-			mnt_drop_write_file(parfilp);
-			break;
-		case ATTR_OP_REMOVE:
-			ops[i].am_error = mnt_want_write_file(parfilp);
-			if (ops[i].am_error)
-				break;
-			ops[i].am_error = xfs_attrmulti_attr_set(
-					d_inode(dentry), attr_name, NULL, 0,
-					ops[i].am_flags);
-			mnt_drop_write_file(parfilp);
-			break;
-		default:
-			ops[i].am_error = -EINVAL;
-		}
-		kfree(attr_name);
+		ops[i].am_error = xfs_ioc_attrmulti_one(parfilp,
+				d_inode(dentry), ops[i].am_opcode,
+				ops[i].am_attrname, ops[i].am_attrvalue,
+				&ops[i].am_length, ops[i].am_flags);
 	}
 
 	if (copy_to_user(am_hreq.ops, ops, size))
diff --git a/fs/xfs/xfs_ioctl.h b/fs/xfs/xfs_ioctl.h
index 819504df00ae..bb50cb3dc61f 100644
--- a/fs/xfs/xfs_ioctl.h
+++ b/fs/xfs/xfs_ioctl.h
@@ -30,21 +30,9 @@ xfs_readlink_by_handle(
 	struct file		*parfilp,
 	xfs_fsop_handlereq_t	*hreq);
 
-extern int
-xfs_attrmulti_attr_get(
-	struct inode		*inode,
-	unsigned char		*name,
-	unsigned char		__user *ubuf,
-	uint32_t		*len,
-	uint32_t		flags);
-
-extern int
-xfs_attrmulti_attr_set(
-	struct inode		*inode,
-	unsigned char		*name,
-	const unsigned char	__user *ubuf,
-	uint32_t		len,
-	uint32_t		flags);
+int xfs_ioc_attrmulti_one(struct file *parfilp, struct inode *inode,
+		uint32_t opcode, void __user *uname, void __user *value,
+		uint32_t *len, uint32_t flags);
 
 extern struct dentry *
 xfs_handle_to_dentry(
diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
index 936c2f62fb6c..e1daf095c585 100644
--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -418,7 +418,6 @@ xfs_compat_attrmulti_by_handle(
 	compat_xfs_fsop_attrmulti_handlereq_t	am_hreq;
 	struct dentry				*dentry;
 	unsigned int				i, size;
-	unsigned char				*attr_name;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
@@ -447,50 +446,11 @@ xfs_compat_attrmulti_by_handle(
 
 	error = 0;
 	for (i = 0; i < am_hreq.opcount; i++) {
-		if ((ops[i].am_flags & ATTR_ROOT) &&
-		    (ops[i].am_flags & ATTR_SECURE)) {
-			ops[i].am_error = -EINVAL;
-			continue;
-		}
-		ops[i].am_flags &= ~ATTR_KERNEL_FLAGS;
-
-		attr_name = strndup_user(compat_ptr(ops[i].am_attrname),
-				MAXNAMELEN);
-		if (IS_ERR(attr_name)) {
-			ops[i].am_error = PTR_ERR(attr_name);
-			break;
-		}
-
-		switch (ops[i].am_opcode) {
-		case ATTR_OP_GET:
-			ops[i].am_error = xfs_attrmulti_attr_get(
-					d_inode(dentry), attr_name,
-					compat_ptr(ops[i].am_attrvalue),
-					&ops[i].am_length, ops[i].am_flags);
-			break;
-		case ATTR_OP_SET:
-			ops[i].am_error = mnt_want_write_file(parfilp);
-			if (ops[i].am_error)
-				break;
-			ops[i].am_error = xfs_attrmulti_attr_set(
-					d_inode(dentry), attr_name,
-					compat_ptr(ops[i].am_attrvalue),
-					ops[i].am_length, ops[i].am_flags);
-			mnt_drop_write_file(parfilp);
-			break;
-		case ATTR_OP_REMOVE:
-			ops[i].am_error = mnt_want_write_file(parfilp);
-			if (ops[i].am_error)
-				break;
-			ops[i].am_error = xfs_attrmulti_attr_set(
-					d_inode(dentry), attr_name, NULL, 0,
-					ops[i].am_flags);
-			mnt_drop_write_file(parfilp);
-			break;
-		default:
-			ops[i].am_error = -EINVAL;
-		}
-		kfree(attr_name);
+		ops[i].am_error = xfs_ioc_attrmulti_one(parfilp,
+				d_inode(dentry), ops[i].am_opcode,
+				compat_ptr(ops[i].am_attrname),
+				compat_ptr(ops[i].am_attrvalue),
+				&ops[i].am_length, ops[i].am_flags);
 	}
 
 	if (copy_to_user(compat_ptr(am_hreq.ops), ops, size))
-- 
2.24.1

