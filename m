Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC239881E
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 01:23:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722302597; cv=none; b=isTkVUdRelilbfdjLO0t14QczxYxBcgpO6PWIIBY8nZxH9JvGt8slKboDQBmiF4im4fjghbRA0Km3tfzPkZln+9eJHa6KxrQXzECaKmUt0PNtiOtObVqWPaS+fMUAPomi+TMfie2zcklGyxi2intc04TyJktwjIGFmUQdeyjPLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722302597; c=relaxed/simple;
	bh=Rn6R/sXW1kFGZsFQVwj79VkcMwrb+97KZ+GGk5oCWdE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JnPr5UX3OIHZCHmflvZFTG0M+P4us4pbJVj9eJIhEpbmUq4qE8TVZiHLyhGr5A0U+3+uKIri85RK2c5zk1pZlSDR2sxEbybAEzBVsprrgNfF8VPpzh40OWtAzLgXFSq7HDHNfhz5I4xtX79jyhi7GfkCu7HTRhnpHrVIQQvRSUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vGPniq/w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vGPniq/w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A60AFC4AF0C;
	Tue, 30 Jul 2024 01:23:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722302597;
	bh=Rn6R/sXW1kFGZsFQVwj79VkcMwrb+97KZ+GGk5oCWdE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=vGPniq/wdfKgXjltdIKWk25do1kPjkfs74eZY8FJZio2KnFDveQliJSBZMI0KMScq
	 fI7aZlvmODTgTvCTdCcBiqdM0VBgqOeoQW78Df10iaEFidsMdlsd5y+P9m0l4Yielk
	 bkhNAVkaaLDJR/YVPOrfCkGtLDjGgTQxq5F4DsIah9ghr1lh0cUoJKCZxzZpqkVXBQ
	 RrSDmabelPLb2yw6n09/nsXpVlWtDdvyY+1TtrG96HQsF/75sA4cEhFkMEq+A39BIT
	 xJOJqHEQsqw5XieT/cBlQUgCvbepi9ysFLB/SwC37ThPIyErdfOS1m1AO+QLD3uLxJ
	 a88nTiWLUGovQ==
Date: Mon, 29 Jul 2024 18:23:17 -0700
Subject: [PATCH 17/24] libxfs: export attr3_leaf_hdr_from_disk via
 libxfs_api_defs.h
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
 catherine.hoang@oracle.com, allison.henderson@oracle.com
Message-ID: <172229850739.1350924.16674915691043133675.stgit@frogsfrogsfrogs>
In-Reply-To: <172229850491.1350924.499207407445096350.stgit@frogsfrogsfrogs>
References: <172229850491.1350924.499207407445096350.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Do the xfs -> libxfs switcheroo and cleanups separately so the next
patch doesn't become an even larger mess.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 db/attr.c                |    2 +-
 db/metadump.c            |    2 +-
 libxfs/libxfs_api_defs.h |    5 +++++
 repair/attr_repair.c     |    6 +++---
 4 files changed, 10 insertions(+), 5 deletions(-)


diff --git a/db/attr.c b/db/attr.c
index 3b556c43d..0b1f498e4 100644
--- a/db/attr.c
+++ b/db/attr.c
@@ -248,7 +248,7 @@ attr_leaf_entry_walk(
 		return 0;
 
 	off = byteize(startoff);
-	xfs_attr3_leaf_hdr_from_disk(mp->m_attr_geo, &leafhdr, leaf);
+	libxfs_attr3_leaf_hdr_from_disk(mp->m_attr_geo, &leafhdr, leaf);
 	entries = xfs_attr3_leaf_entryp(leaf);
 
 	for (i = 0; i < leafhdr.count; i++) {
diff --git a/db/metadump.c b/db/metadump.c
index e95238fb0..424544f9f 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -1680,7 +1680,7 @@ process_attr_block(
 	}
 
 	/* Ok, it's a leaf - get header; accounts for crc & non-crc */
-	xfs_attr3_leaf_hdr_from_disk(mp->m_attr_geo, &hdr, leaf);
+	libxfs_attr3_leaf_hdr_from_disk(mp->m_attr_geo, &hdr, leaf);
 
 	nentries = hdr.count;
 	if (nentries == 0 ||
diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index c3dde1511..5713e5221 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -36,10 +36,13 @@
 
 #define xfs_ascii_ci_hashname		libxfs_ascii_ci_hashname
 
+#define xfs_attr3_leaf_hdr_from_disk	libxfs_attr3_leaf_hdr_from_disk
+#define xfs_attr3_leaf_read		libxfs_attr3_leaf_read
 #define xfs_attr_check_namespace	libxfs_attr_check_namespace
 #define xfs_attr_get			libxfs_attr_get
 #define xfs_attr_hashname		libxfs_attr_hashname
 #define xfs_attr_hashval		libxfs_attr_hashval
+#define xfs_attr_is_leaf		libxfs_attr_is_leaf
 #define xfs_attr_leaf_newentsize	libxfs_attr_leaf_newentsize
 #define xfs_attr_namecheck		libxfs_attr_namecheck
 #define xfs_attr_set			libxfs_attr_set
@@ -103,6 +106,7 @@
 #define xfs_compute_rextslog		libxfs_compute_rextslog
 #define xfs_create_space_res		libxfs_create_space_res
 #define xfs_da3_node_hdr_from_disk	libxfs_da3_node_hdr_from_disk
+#define xfs_da3_node_read		libxfs_da3_node_read
 #define xfs_da_get_buf			libxfs_da_get_buf
 #define xfs_da_hashname			libxfs_da_hashname
 #define xfs_da_read_buf			libxfs_da_read_buf
@@ -177,6 +181,7 @@
 #define xfs_inobt_stage_cursor		libxfs_inobt_stage_cursor
 #define xfs_inode_from_disk		libxfs_inode_from_disk
 #define xfs_inode_from_disk_ts		libxfs_inode_from_disk_ts
+#define xfs_inode_hasattr		libxfs_inode_hasattr
 #define xfs_inode_to_disk		libxfs_inode_to_disk
 #define xfs_inode_validate_cowextsize	libxfs_inode_validate_cowextsize
 #define xfs_inode_validate_extsize	libxfs_inode_validate_extsize
diff --git a/repair/attr_repair.c b/repair/attr_repair.c
index 8321c9b67..2e97fd977 100644
--- a/repair/attr_repair.c
+++ b/repair/attr_repair.c
@@ -610,7 +610,7 @@ process_leaf_attr_block(
 	da_freemap_t *attr_freemap;
 	struct xfs_attr3_icleaf_hdr leafhdr;
 
-	xfs_attr3_leaf_hdr_from_disk(mp->m_attr_geo, &leafhdr, leaf);
+	libxfs_attr3_leaf_hdr_from_disk(mp->m_attr_geo, &leafhdr, leaf);
 	clearit = usedbs = 0;
 	firstb = mp->m_sb.sb_blocksize;
 	stop = xfs_attr3_leaf_hdr_size(leaf);
@@ -849,7 +849,7 @@ process_leaf_attr_level(xfs_mount_t	*mp,
 		}
 
 		leaf = bp->b_addr;
-		xfs_attr3_leaf_hdr_from_disk(mp->m_attr_geo, &leafhdr, leaf);
+		libxfs_attr3_leaf_hdr_from_disk(mp->m_attr_geo, &leafhdr, leaf);
 
 		/* check magic number for leaf directory btree block */
 		if (!(leafhdr.magic == XFS_ATTR_LEAF_MAGIC ||
@@ -1052,7 +1052,7 @@ process_longform_leaf_root(
 	 * check sibling pointers in leaf block or root block 0 before
 	 * we have to release the btree block
 	 */
-	xfs_attr3_leaf_hdr_from_disk(mp->m_attr_geo, &leafhdr, bp->b_addr);
+	libxfs_attr3_leaf_hdr_from_disk(mp->m_attr_geo, &leafhdr, bp->b_addr);
 	if (leafhdr.forw != 0 || leafhdr.back != 0)  {
 		if (!no_modify)  {
 			do_warn(

