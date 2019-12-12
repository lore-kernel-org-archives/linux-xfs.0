Return-Path: <SRS0=0MSb=2C=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23866C43603
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Dec 2019 10:54:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EEF222077B
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Dec 2019 10:54:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="MM6Avn07"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728839AbfLLKyy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Dec 2019 05:54:54 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:53202 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728832AbfLLKyy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Dec 2019 05:54:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=RLp7ezyWzNQu/3q8pF+P5nl/eQNmwDR3+Atf070uD/g=; b=MM6Avn07ykZmSbKaP1ejuHqES3
        vvSQBrdIwflPl+ZPQWFjzbZIsYVCBrLATMhMx3OyL/Ej+Euat2ApH9mX+K9akejumMmVF7GQ9mmMg
        OChMY6oYNIk74oxTcPTefRqxG5i4JaLZwRbuEMgpaO5Q1wc4E8+Zmo7ih8hWdxYeXLZb/rh1PihpY
        0n3qaK/QQ6EnX99gYbpeeEEKeYQINXf5hzgIlfmPcAfX4XmfSY2Qyp3bXHwEJKQcR65B2dFOeQhHO
        ZQeZEbi4/jltJua6U3p7jOjqDv6IkF/x6DPuXwsQX3dCBYYYqnwfVKTLyiX65q88aSSoWs4XcdK1/
        JUOKULmA==;
Received: from clnet-p19-102.ikbnet.co.at ([83.175.77.102] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ifM7R-00019q-Uj; Thu, 12 Dec 2019 10:54:54 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Allison Collins <allison.henderson@oracle.com>
Subject: [PATCH 08/33] xfs: use strndup_user in XFS_IOC_ATTRMULTI_BY_HANDLE
Date:   Thu, 12 Dec 2019 11:54:08 +0100
Message-Id: <20191212105433.1692-9-hch@lst.de>
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

Simplify the user copy code by using strndup_user.  This means that we
now do one memory allocation per operation instead of one per ioctl,
but memory allocations are cheap compared to the actual file system
operations.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_ioctl.c   | 17 +++++------------
 fs/xfs/xfs_ioctl32.c | 17 +++++------------
 2 files changed, 10 insertions(+), 24 deletions(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 7f3cd5648e7a..2e81d354b37d 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -441,11 +441,6 @@ xfs_attrmulti_by_handle(
 		goto out_dput;
 	}
 
-	error = -ENOMEM;
-	attr_name = kmalloc(MAXNAMELEN, GFP_KERNEL);
-	if (!attr_name)
-		goto out_kfree_ops;
-
 	error = 0;
 	for (i = 0; i < am_hreq.opcount; i++) {
 		if ((ops[i].am_flags & ATTR_ROOT) &&
@@ -455,12 +450,11 @@ xfs_attrmulti_by_handle(
 		}
 		ops[i].am_flags &= ATTR_KERNEL_FLAGS;
 
-		ops[i].am_error = strncpy_from_user((char *)attr_name,
-				ops[i].am_attrname, MAXNAMELEN);
-		if (ops[i].am_error == 0 || ops[i].am_error == MAXNAMELEN)
-			error = -ERANGE;
-		if (ops[i].am_error < 0)
+		attr_name = strndup_user(ops[i].am_attrname, MAXNAMELEN);
+		if (IS_ERR(attr_name)) {
+			ops[i].am_error = PTR_ERR(attr_name);
 			break;
+		}
 
 		switch (ops[i].am_opcode) {
 		case ATTR_OP_GET:
@@ -491,13 +485,12 @@ xfs_attrmulti_by_handle(
 		default:
 			ops[i].am_error = -EINVAL;
 		}
+		kfree(attr_name);
 	}
 
 	if (copy_to_user(am_hreq.ops, ops, size))
 		error = -EFAULT;
 
-	kfree(attr_name);
- out_kfree_ops:
 	kfree(ops);
  out_dput:
 	dput(dentry);
diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
index 76b1382c2214..ffcf175efc48 100644
--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -443,11 +443,6 @@ xfs_compat_attrmulti_by_handle(
 		goto out_dput;
 	}
 
-	error = -ENOMEM;
-	attr_name = kmalloc(MAXNAMELEN, GFP_KERNEL);
-	if (!attr_name)
-		goto out_kfree_ops;
-
 	error = 0;
 	for (i = 0; i < am_hreq.opcount; i++) {
 		if ((ops[i].am_flags & ATTR_ROOT) &&
@@ -457,13 +452,12 @@ xfs_compat_attrmulti_by_handle(
 		}
 		ops[i].am_flags &= ATTR_KERNEL_FLAGS;
 
-		ops[i].am_error = strncpy_from_user((char *)attr_name,
-				compat_ptr(ops[i].am_attrname),
+		attr_name = strndup_user(compat_ptr(ops[i].am_attrname),
 				MAXNAMELEN);
-		if (ops[i].am_error == 0 || ops[i].am_error == MAXNAMELEN)
-			error = -ERANGE;
-		if (ops[i].am_error < 0)
+		if (IS_ERR(attr_name)) {
+			ops[i].am_error = PTR_ERR(attr_name);
 			break;
+		}
 
 		switch (ops[i].am_opcode) {
 		case ATTR_OP_GET:
@@ -494,13 +488,12 @@ xfs_compat_attrmulti_by_handle(
 		default:
 			ops[i].am_error = -EINVAL;
 		}
+		kfree(attr_name);
 	}
 
 	if (copy_to_user(compat_ptr(am_hreq.ops), ops, size))
 		error = -EFAULT;
 
-	kfree(attr_name);
- out_kfree_ops:
 	kfree(ops);
  out_dput:
 	dput(dentry);
-- 
2.20.1

