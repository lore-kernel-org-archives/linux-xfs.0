Return-Path: <SRS0=HAJZ=4O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE1B7C4BA24
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Feb 2020 20:23:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8F33224656
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Feb 2020 20:23:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="VmYRfxfY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727240AbgBZUXo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 Feb 2020 15:23:44 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:34770 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727260AbgBZUXo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Feb 2020 15:23:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=+1hjdE0kJ50xlhhrCe88AXhnc5CPe1sSgPJsjHtU5OY=; b=VmYRfxfYtSZm80goF15GdcF/nB
        cb5ZEVwTqrPGbNSvjgl9bycdSsaqE03PGEBiSvg2Nh64aUgUCJsd4/EkIU2+pCvfkV2+k665N4fjA
        o+nXNM+OjwAbA4ViTSdl9iolqi+d77XgM4C4broc2id0hbH/Qan4ZQa3C6p4whREFcqJkA5jva57c
        EjLT2NkseC6MJdA02P+WSWOTv/4XTBx6CP/GJoDULsGYXTtULZX1Dt9Xi2OUyVTiKVJ/QrYbfmzw9
        2iumc4QLvO2ctnc0fFv3ARoqH9fyQILlgG1xy4eh86LmH79CYv06BArGpoUWxRGGxz7xdOYmi29KY
        SaZuBvGw==;
Received: from [199.255.44.128] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j73Db-0008LX-Vh; Wed, 26 Feb 2020 20:23:43 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>,
        Chandan Rajendra <chandanrlinux@gmail.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH 05/32] xfs: use strndup_user in XFS_IOC_ATTRMULTI_BY_HANDLE
Date:   Wed, 26 Feb 2020 12:22:39 -0800
Message-Id: <20200226202306.871241-6-hch@lst.de>
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

Simplify the user copy code by using strndup_user.  This means that we
now do one memory allocation per operation instead of one per ioctl,
but memory allocations are cheap compared to the actual file system
operations.  Also the error for an invalid path is now EINVAL or EFAULT
instead of the previous odd and undocumented ERANGE.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_ioctl.c   | 17 +++++------------
 fs/xfs/xfs_ioctl32.c | 17 +++++------------
 2 files changed, 10 insertions(+), 24 deletions(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index b806003caacd..bb490a954c0b 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -448,11 +448,6 @@ xfs_attrmulti_by_handle(
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
@@ -462,12 +457,11 @@ xfs_attrmulti_by_handle(
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
@@ -498,13 +492,12 @@ xfs_attrmulti_by_handle(
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
index e085f304e539..936c2f62fb6c 100644
--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -445,11 +445,6 @@ xfs_compat_attrmulti_by_handle(
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
@@ -459,13 +454,12 @@ xfs_compat_attrmulti_by_handle(
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
@@ -496,13 +490,12 @@ xfs_compat_attrmulti_by_handle(
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

