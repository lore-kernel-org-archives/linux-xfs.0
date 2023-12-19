Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCAA3171B9
	for <linux-xfs@vger.kernel.org>; Tue, 19 Dec 2023 12:08:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Va4kMSTP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=0Be44y24lWwRowcw0c/OPmCPbXLNaDULpfJUMqYn8Lg=; b=Va4kMSTPM7pc10AmDTb1PTBdO7
	yYZhm0EgmqCiQ6GqT4WbBIbpLe/pv2ohvG4nbsy2zSEP85njNI/pn72NP4Qd5E25dKtGFqj9HtM+0
	2VSGTLnGjyeC5LY7W3OGP45JeiSFHERhXHWsOz6Eyp3YozXw9NC2Edpyu/5SoWNA8AfWj7SDSSa6Y
	DTx86yqXDGi22lgwLV5BR98KFpUIiJ7fQ+lgjH1swU6DTiGiMQqHM2sodpgxECkO0zKsJh9uryXlx
	Lgg/gZ+TeWtvFpedt8wrOO/iQrsQW8i1wBJTZx3UwXgYhv7kCjntODeeL2k2HX6ztVcBKIVRyxgJ/
	xe1ihRnA==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rFYti-00DyE3-2c;
	Tue, 19 Dec 2023 12:08:31 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 5/8] xfs: remove xfs_attr_shortform_lookup
Date: Tue, 19 Dec 2023 13:08:14 +0100
Message-Id: <20231219120817.923421-6-hch@lst.de>
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

xfs_attr_shortform_lookup is only used by xfs_attr_shortform_addname,
which is much better served by calling xfs_attr_sf_findname.  Switch
it over and remove xfs_attr_shortform_lookup.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.c      | 16 ++++------------
 fs/xfs/libxfs/xfs_attr_leaf.c | 24 ------------------------
 fs/xfs/libxfs/xfs_attr_leaf.h |  1 -
 3 files changed, 4 insertions(+), 37 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index bcf8748cb1a333..d6173888ed0d56 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -1070,13 +1070,7 @@ xfs_attr_shortform_addname(
 
 	trace_xfs_attr_sf_addname(args);
 
-	error = xfs_attr_shortform_lookup(args);
-	switch (error) {
-	case -ENOATTR:
-		if (args->op_flags & XFS_DA_OP_REPLACE)
-			return error;
-		break;
-	case -EEXIST:
+	if (xfs_attr_sf_findname(args)) {
 		if (!(args->op_flags & XFS_DA_OP_REPLACE))
 			return error;
 
@@ -1091,11 +1085,9 @@ xfs_attr_shortform_addname(
 		 * around.
 		 */
 		args->op_flags &= ~XFS_DA_OP_REPLACE;
-		break;
-	case 0:
-		break;
-	default:
-		return error;
+	} else {
+		if (args->op_flags & XFS_DA_OP_REPLACE)
+			return error;
 	}
 
 	if (args->namelen >= XFS_ATTR_SF_ENTSIZE_MAX ||
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 7a623efd23a6a4..75c597805ffa8b 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -837,30 +837,6 @@ xfs_attr_sf_removename(
 	return 0;
 }
 
-/*
- * Look up a name in a shortform attribute list structure.
- */
-/*ARGSUSED*/
-int
-xfs_attr_shortform_lookup(
-	struct xfs_da_args		*args)
-{
-	struct xfs_ifork		*ifp = &args->dp->i_af;
-	struct xfs_attr_shortform	*sf = ifp->if_data;
-	struct xfs_attr_sf_entry	*sfe;
-	int				i;
-
-	ASSERT(ifp->if_format == XFS_DINODE_FMT_LOCAL);
-	sfe = &sf->list[0];
-	for (i = 0; i < sf->hdr.count;
-				sfe = xfs_attr_sf_nextentry(sfe), i++) {
-		if (xfs_attr_match(args, sfe->namelen, sfe->nameval,
-				sfe->flags))
-			return -EEXIST;
-	}
-	return -ENOATTR;
-}
-
 /*
  * Retrieve the attribute value and length.
  *
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.h b/fs/xfs/libxfs/xfs_attr_leaf.h
index 56fcd689eedfe7..35e668ae744fb1 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.h
+++ b/fs/xfs/libxfs/xfs_attr_leaf.h
@@ -47,7 +47,6 @@ struct xfs_attr3_icleaf_hdr {
  */
 void	xfs_attr_shortform_create(struct xfs_da_args *args);
 void	xfs_attr_shortform_add(struct xfs_da_args *args, int forkoff);
-int	xfs_attr_shortform_lookup(struct xfs_da_args *args);
 int	xfs_attr_shortform_getvalue(struct xfs_da_args *args);
 int	xfs_attr_shortform_to_leaf(struct xfs_da_args *args);
 int	xfs_attr_sf_removename(struct xfs_da_args *args);
-- 
2.39.2

