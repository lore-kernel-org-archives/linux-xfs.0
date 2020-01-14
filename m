Return-Path: <SRS0=8ZQd=3D=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18B6CC33CB1
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Jan 2020 08:15:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DF9A2207FF
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Jan 2020 08:15:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jAD/uLqx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725842AbgANIP2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Jan 2020 03:15:28 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:42136 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725820AbgANIP2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Jan 2020 03:15:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=qyMdmNAw3LtAU8NfqsXJWbiHH/5dM77veTKhWSwqros=; b=jAD/uLqxZBLlhXGchEmPRLMxrm
        Y8+51NclOwM1vS4MKABqnpdEWasLsBnBy4Hao5g+Nt9NOwz+q9GRDMOHgOOU2PfIGcZF3ETmEXo4U
        UNlTb+eYk/W2W++d58z1wCpZhegL8sWvk4qfIAUYSxZP12738ZgXSep9FstFxy20bKHmRld/MjD3h
        h8cOVmwDYI7vgtQzIiTt4ALlr98Ycs1Ep+pEO6NW38yMCoUaKCLQXCdq3zwOJsTVF5eJMEO1scr20
        hnoYgmRMNvVjm4tMh6qKyf4yZ3mSTSvAAiQcTv4G6nkNv2e1mv/BGoNYL15TtWGQsW4ky70iNQ5mF
        c5s5XZIQ==;
Received: from [2001:4bb8:18c:4f54:fcbb:a92b:61e1:719] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1irHMF-0006x5-OB; Tue, 14 Jan 2020 08:15:28 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Allison Collins <allison.henderson@oracle.com>
Subject: [PATCH 04/29] xfs: use strndup_user in XFS_IOC_ATTRMULTI_BY_HANDLE
Date:   Tue, 14 Jan 2020 09:10:26 +0100
Message-Id: <20200114081051.297488-5-hch@lst.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200114081051.297488-1-hch@lst.de>
References: <20200114081051.297488-1-hch@lst.de>
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
index 6bd0684a3528..f4d5c865e29e 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -446,11 +446,6 @@ xfs_attrmulti_by_handle(
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
@@ -460,12 +455,11 @@ xfs_attrmulti_by_handle(
 		}
 		ops[i].am_flags &= ~ATTR_KERNEL_FLAGS;
 
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
@@ -496,13 +490,12 @@ xfs_attrmulti_by_handle(
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
index 1092c66e48d6..e6a7f619a54c 100644
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
 		ops[i].am_flags &= ~ATTR_KERNEL_FLAGS;
 
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
2.24.1

