Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1238171B2
	for <linux-xfs@vger.kernel.org>; Tue, 19 Dec 2023 12:08:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="unVcpjnl"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=4lobJdkgttRnfcjay0e76jDLIW9dCfTHLhTgwHPV2RU=; b=unVcpjnlqUilEswv+3NSOQaHIj
	vDi/E4lXewkUlItHUfsnRAzulErsrPu+tjQHrEIqQJYNRDuN16ZxvSCNewdcE+D+Ih7L2p10sQ1XO
	PUsPyGaJ2ZTXwKYuh0h88JgInLzVd5WlcPnvcbdgrai6sspj0wnYvnGWZ4750g4sDD/pfW74vCzk+
	qEs8LykE66rcGaUNEl8btkFL+w9o+DaTylS78JgIS1rVRyX/R6gvyePOX6c5NHv7fNnpwkEjjaJ81
	16xl1NiNBMi0CUmALZgKpAydODnDFQuJlwZGqZvKsFaiaSIUvWDUDKRsQYBrj8INSO6yROImIU3Cm
	ps4JxspA==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rFYtp-00DyGM-3C;
	Tue, 19 Dec 2023 12:08:38 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 8/8] xfs: remove xfs_attr_sf_hdr_t
Date: Tue, 19 Dec 2023 13:08:17 +0100
Message-Id: <20231219120817.923421-9-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231219120817.923421-1-hch@lst.de>
References: <20231219120817.923421-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Remove the last two users of the typedef.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr_leaf.c | 4 ++--
 fs/xfs/libxfs/xfs_attr_sf.h   | 8 --------
 2 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index e1281ab413c832..6374bf10724207 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -816,7 +816,7 @@ xfs_attr_sf_removename(
 	/*
 	 * Fix up the start offset of the attribute fork
 	 */
-	if (totsize == sizeof(xfs_attr_sf_hdr_t) && xfs_has_attr2(mp) &&
+	if (totsize == sizeof(struct xfs_attr_sf_hdr) && xfs_has_attr2(mp) &&
 	    (dp->i_df.if_format != XFS_DINODE_FMT_BTREE) &&
 	    !(args->op_flags & (XFS_DA_OP_ADDNAME | XFS_DA_OP_REPLACE))) {
 		xfs_attr_fork_remove(dp, args->trans);
@@ -824,7 +824,7 @@ xfs_attr_sf_removename(
 		xfs_idata_realloc(dp, -size, XFS_ATTR_FORK);
 		dp->i_forkoff = xfs_attr_shortform_bytesfit(dp, totsize);
 		ASSERT(dp->i_forkoff);
-		ASSERT(totsize > sizeof(xfs_attr_sf_hdr_t) ||
+		ASSERT(totsize > sizeof(struct xfs_attr_sf_hdr) ||
 				(args->op_flags & XFS_DA_OP_ADDNAME) ||
 				!xfs_has_attr2(mp) ||
 				dp->i_df.if_format == XFS_DINODE_FMT_BTREE);
diff --git a/fs/xfs/libxfs/xfs_attr_sf.h b/fs/xfs/libxfs/xfs_attr_sf.h
index 9abf7de95465f5..bc442222302486 100644
--- a/fs/xfs/libxfs/xfs_attr_sf.h
+++ b/fs/xfs/libxfs/xfs_attr_sf.h
@@ -6,14 +6,6 @@
 #ifndef __XFS_ATTR_SF_H__
 #define	__XFS_ATTR_SF_H__
 
-/*
- * Attribute storage when stored inside the inode.
- *
- * Small attribute lists are packed as tightly as possible so as
- * to fit into the literal area of the inode.
- */
-typedef struct xfs_attr_sf_hdr xfs_attr_sf_hdr_t;
-
 /*
  * We generate this then sort it, attr_list() must return things in hash-order.
  */
-- 
2.39.2

