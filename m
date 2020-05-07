Return-Path: <SRS0=M5eb=6V=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FABEC38A24
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 12:19:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C08E20CC7
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 12:19:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="bSPxI6ZF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726580AbgEGMTD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 May 2020 08:19:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725857AbgEGMTC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 May 2020 08:19:02 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F555C05BD43
        for <linux-xfs@vger.kernel.org>; Thu,  7 May 2020 05:19:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=nbqXoU5Ty8ud1vEQzu03X/vpIpx7mdmvEiZ783CiRio=; b=bSPxI6ZF47VMlF9GW2wnpKhcrG
        /cG9mumj75i81StEcH6ebwx52bd2UWRxGAoHMHF/7/cXdaeEPhfMr1EepS33jnrVdEzSDWqz0HWIl
        MBspLnJvLqPdnLZCs+CjRIYEyFWT9uW/OqcxwnwI5HZQR9P6y+PKE/IqQ00GJS8oXnFvR2EkRJQft
        gLdV1ZIVcsq7p3Et16owZ8WyzAjea0xt00aLT4FCZIDTB024JmgKUqFFKkkIlhoTLtnNUSmikopQ+
        0Qri7r1SqPPRh8uQjojwKPLcKxKZ+BJW7MQyyvRqvBa99oB6x/9JWt7yvOp8fkFKtSIPeU3jVp4fe
        O5/iHQbA==;
Received: from [2001:4bb8:180:9d3f:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jWfUT-00053n-TB; Thu, 07 May 2020 12:19:02 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH 03/58] xfs: remove the icdinode di_uid/di_gid members
Date:   Thu,  7 May 2020 14:17:56 +0200
Message-Id: <20200507121851.304002-4-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200507121851.304002-1-hch@lst.de>
References: <20200507121851.304002-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Source kernel commit: 542951592c99ff7b15c050954c051dd6dd6c0f97

Use the Linux inode i_uid/i_gid members everywhere and just convert
from/to the scalar value when reading or writing the on-disk inode.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 db/check.c             |  4 ++--
 include/xfs_inode.h    |  3 +++
 libxfs/util.c          |  7 ++++---
 libxfs/xfs_inode_buf.c | 10 ++++------
 libxfs/xfs_inode_buf.h |  2 --
 5 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/db/check.c b/db/check.c
index 3b713bdc..f2eca458 100644
--- a/db/check.c
+++ b/db/check.c
@@ -2898,8 +2898,8 @@ process_inode(
 			break;
 		}
 		if (ic) {
-			quota_add(&xino.i_d.di_projid, &xino.i_d.di_gid,
-				  &xino.i_d.di_uid, 0, bc, ic, rc);
+			quota_add(&xino.i_d.di_projid, &xino.i_vnode.i_gid,
+				  &xino.i_vnode.i_uid, 0, bc, ic, rc);
 		}
 	}
 	totblocks = totdblocks + totiblocks + atotdblocks + atotiblocks;
diff --git a/include/xfs_inode.h b/include/xfs_inode.h
index 5cb5a87b..99b0c3aa 100644
--- a/include/xfs_inode.h
+++ b/include/xfs_inode.h
@@ -46,7 +46,10 @@ struct inode {
 };
 
 #define xfs_uid_to_kuid(uid)	(uid)
+#define xfs_kuid_to_uid(uid)	(uid)
+
 #define xfs_gid_to_kgid(gid)	(gid)
+#define xfs_kgid_to_gid(gid)	(gid)
 
 typedef struct xfs_inode {
 	struct cache_node	i_node;
diff --git a/libxfs/util.c b/libxfs/util.c
index 2e2ade24..d3cbc038 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -255,8 +255,7 @@ libxfs_ialloc(
 
 	VFS_I(ip)->i_mode = mode;
 	set_nlink(VFS_I(ip), nlink);
-	ip->i_d.di_uid = cr->cr_uid;
-	ip->i_d.di_gid = cr->cr_gid;
+	VFS_I(ip)->i_uid = cr->cr_uid;
 	ip->i_d.di_projid = pip ? 0 : fsx->fsx_projid;
 	xfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_CHG | XFS_ICHGTIME_MOD);
 
@@ -275,9 +274,11 @@ libxfs_ialloc(
 	}
 
 	if (pip && (VFS_I(pip)->i_mode & S_ISGID)) {
-		ip->i_d.di_gid = pip->i_d.di_gid;
+		VFS_I(ip)->i_gid = VFS_I(pip)->i_gid;
 		if ((VFS_I(pip)->i_mode & S_ISGID) && (mode & S_IFMT) == S_IFDIR)
 			VFS_I(ip)->i_mode |= S_ISGID;
+	} else {
+		VFS_I(ip)->i_gid = cr->cr_gid;
 	}
 
 	ip->i_d.di_size = 0;
diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
index a7d39f24..9d47208e 100644
--- a/libxfs/xfs_inode_buf.c
+++ b/libxfs/xfs_inode_buf.c
@@ -219,10 +219,8 @@ xfs_inode_from_disk(
 	}
 
 	to->di_format = from->di_format;
-	to->di_uid = be32_to_cpu(from->di_uid);
-	inode->i_uid = xfs_uid_to_kuid(to->di_uid);
-	to->di_gid = be32_to_cpu(from->di_gid);
-	inode->i_gid = xfs_gid_to_kgid(to->di_gid);
+	inode->i_uid = xfs_uid_to_kuid(be32_to_cpu(from->di_uid));
+	inode->i_gid = xfs_gid_to_kgid(be32_to_cpu(from->di_gid));
 	to->di_flushiter = be16_to_cpu(from->di_flushiter);
 
 	/*
@@ -275,8 +273,8 @@ xfs_inode_to_disk(
 
 	to->di_version = from->di_version;
 	to->di_format = from->di_format;
-	to->di_uid = cpu_to_be32(from->di_uid);
-	to->di_gid = cpu_to_be32(from->di_gid);
+	to->di_uid = cpu_to_be32(xfs_kuid_to_uid(inode->i_uid));
+	to->di_gid = cpu_to_be32(xfs_kgid_to_gid(inode->i_gid));
 	to->di_projid_lo = cpu_to_be16(from->di_projid & 0xffff);
 	to->di_projid_hi = cpu_to_be16(from->di_projid >> 16);
 
diff --git a/libxfs/xfs_inode_buf.h b/libxfs/xfs_inode_buf.h
index fd94b107..2683e1e2 100644
--- a/libxfs/xfs_inode_buf.h
+++ b/libxfs/xfs_inode_buf.h
@@ -19,8 +19,6 @@ struct xfs_icdinode {
 	int8_t		di_version;	/* inode version */
 	int8_t		di_format;	/* format of di_c data */
 	uint16_t	di_flushiter;	/* incremented on flush */
-	uint32_t	di_uid;		/* owner's user id */
-	uint32_t	di_gid;		/* owner's group id */
 	uint32_t	di_projid;	/* owner's project id */
 	xfs_fsize_t	di_size;	/* number of bytes in file */
 	xfs_rfsblock_t	di_nblocks;	/* # of direct & btree blocks used */
-- 
2.26.2

