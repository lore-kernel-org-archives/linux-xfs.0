Return-Path: <SRS0=M5eb=6V=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7727BC4724C
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 12:19:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 547FB20CC7
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 12:19:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="lRx2nwx4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726661AbgEGMTF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 May 2020 08:19:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725857AbgEGMTE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 May 2020 08:19:04 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE06AC05BD43
        for <linux-xfs@vger.kernel.org>; Thu,  7 May 2020 05:19:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=UHtt/SxDcyuDdbUn1VsIVOdx0HBAl2wZr/MeP+K1VBI=; b=lRx2nwx46KMX3B8z7spOZokkI/
        N68QJiFMJQKTzeUYd6PsHaYopzbtxRPDOL1S9wYrgYO10S6F7PEupRRSF4kkonFRIR+J8MnY8ixqp
        B8KB3UcK5YtacUbFMlZ1Nhpwdh4cZ7vsSOV2n1imVmeIIZ+xJ+hHxqExY73ts22HKStXmSQJdXGrg
        SKm6RtkIbWGxkPASCnJI4YWEn812YmYOzR+IlYfTgBB6dVKbLvSPJPZa5PlfQX5z8oXG8pbWpVTMP
        A3/GfjWsB1CyR1tHzcojgldK3Tf9sw9DtuHU9fzZqacSKbZ7xkXCQldes1GPxKRB9+Bkh1MOKebJ/
        m1RRlasg==;
Received: from [2001:4bb8:180:9d3f:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jWfUW-00054C-9e; Thu, 07 May 2020 12:19:04 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH 04/58] xfs: remove the kuid/kgid conversion wrappers
Date:   Thu,  7 May 2020 14:17:57 +0200
Message-Id: <20200507121851.304002-5-hch@lst.de>
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

Source kernel commit: ba8adad5d036733d240fa8a8f4d055f3d4490562

Remove the XFS wrappers for converting from and to the kuid/kgid types.
Mostly this means switching to VFS i_{u,g}id_{read,write} helpers, but
in a few spots the calls to the conversion functions is open coded.
To match the use of sb->s_user_ns in the helpers and other file systems,
sb->s_user_ns is also used in the quota code.  The ACL code already does
the conversion in a grotty layering violation in the VFS xattr code,
so it keeps using init_user_ns for the identity mapping.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/xfs_inode.h    | 8 ++++----
 libxfs/xfs_inode_buf.c | 8 ++++----
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/include/xfs_inode.h b/include/xfs_inode.h
index 99b0c3aa..b9cdd8ca 100644
--- a/include/xfs_inode.h
+++ b/include/xfs_inode.h
@@ -45,11 +45,11 @@ struct inode {
 	struct timespec	i_ctime;
 };
 
-#define xfs_uid_to_kuid(uid)	(uid)
-#define xfs_kuid_to_uid(uid)	(uid)
+#define i_uid_write(inode, uid)		(inode)->i_uid = (uid)
+#define i_uid_read(inode)		((inode)->i_uid)
 
-#define xfs_gid_to_kgid(gid)	(gid)
-#define xfs_kgid_to_gid(gid)	(gid)
+#define i_gid_write(inode, gid)		(inode)->i_gid = (gid)
+#define i_gid_read(inode)		((inode)->i_gid)
 
 typedef struct xfs_inode {
 	struct cache_node	i_node;
diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
index 9d47208e..64651d4e 100644
--- a/libxfs/xfs_inode_buf.c
+++ b/libxfs/xfs_inode_buf.c
@@ -219,8 +219,8 @@ xfs_inode_from_disk(
 	}
 
 	to->di_format = from->di_format;
-	inode->i_uid = xfs_uid_to_kuid(be32_to_cpu(from->di_uid));
-	inode->i_gid = xfs_gid_to_kgid(be32_to_cpu(from->di_gid));
+	i_uid_write(inode, be32_to_cpu(from->di_uid));
+	i_gid_write(inode, be32_to_cpu(from->di_gid));
 	to->di_flushiter = be16_to_cpu(from->di_flushiter);
 
 	/*
@@ -273,8 +273,8 @@ xfs_inode_to_disk(
 
 	to->di_version = from->di_version;
 	to->di_format = from->di_format;
-	to->di_uid = cpu_to_be32(xfs_kuid_to_uid(inode->i_uid));
-	to->di_gid = cpu_to_be32(xfs_kgid_to_gid(inode->i_gid));
+	to->di_uid = cpu_to_be32(i_uid_read(inode));
+	to->di_gid = cpu_to_be32(i_gid_read(inode));
 	to->di_projid_lo = cpu_to_be16(from->di_projid & 0xffff);
 	to->di_projid_hi = cpu_to_be16(from->di_projid >> 16);
 
-- 
2.26.2

