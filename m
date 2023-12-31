Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A08B5C2C0
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:12:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O0xtbnKo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F104C433C8;
	Sun, 31 Dec 2023 23:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704064329;
	bh=Phe7FxD7STkHY5TjHf4voB6bCmpPTq7ktKtJn7fqX/s=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=O0xtbnKoaIRiK/G1IK7diDH9J/ZH6DIJdxr3vsqG4neD1n17M8euJX8Hxvr4eGpBb
	 Dz5/Ph2pblCAQAX+zBj9wEUA/YZdSYwBdaA9u+p7mcTygWNmoxMU5/n98baAIzqJDD
	 /FXAoDKC5H/CwPr3/+y+vlYO1v4dD2Hzi3rerbRVSWRQZBFemeH/9ZENq5iLw3emS8
	 3nvvrfykALUNMMGv72VZGETYw7+BkBZVaEdi/QAZGqMIoppl1NfLIJOy4uXUUg9iN2
	 NuDLE6vhd85lk7ihTsBDJpRTg7s5B5mTmMATha4mwV+2WYoIzbjXxZb3gDfxiJvSam
	 QEgKkvjsyAzSg==
Date: Sun, 31 Dec 2023 15:12:08 -0800
Subject: [PATCH 27/32] libxfs: export attr3_leaf_hdr_from_disk via
 libxfs_api_defs.h
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: catherine.hoang@oracle.com, linux-xfs@vger.kernel.org,
 allison.henderson@oracle.com
Message-ID: <170405006461.1804688.5728263139637208432.stgit@frogsfrogsfrogs>
In-Reply-To: <170405006077.1804688.8762482665401724622.stgit@frogsfrogsfrogs>
References: <170405006077.1804688.8762482665401724622.stgit@frogsfrogsfrogs>
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
---
 db/attr.c                |    2 +-
 db/metadump.c            |    2 +-
 libxfs/libxfs_api_defs.h |    5 +++++
 repair/attr_repair.c     |    6 +++---
 4 files changed, 10 insertions(+), 5 deletions(-)


diff --git a/db/attr.c b/db/attr.c
index 9e7bbd164df..95969d115d4 100644
--- a/db/attr.c
+++ b/db/attr.c
@@ -256,7 +256,7 @@ attr_leaf_entry_walk(
 		return 0;
 
 	off = byteize(startoff);
-	xfs_attr3_leaf_hdr_from_disk(mp->m_attr_geo, &leafhdr, leaf);
+	libxfs_attr3_leaf_hdr_from_disk(mp->m_attr_geo, &leafhdr, leaf);
 	entries = xfs_attr3_leaf_entryp(leaf);
 
 	for (i = 0; i < leafhdr.count; i++) {
diff --git a/db/metadump.c b/db/metadump.c
index 5f5a33335b0..f5b930d51d2 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -1701,7 +1701,7 @@ process_attr_block(
 	}
 
 	/* Ok, it's a leaf - get header; accounts for crc & non-crc */
-	xfs_attr3_leaf_hdr_from_disk(mp->m_attr_geo, &hdr, leaf);
+	libxfs_attr3_leaf_hdr_from_disk(mp->m_attr_geo, &hdr, leaf);
 
 	nentries = hdr.count;
 	if (nentries == 0 ||
diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index a6b561b5b40..22e4c569170 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -36,7 +36,10 @@
 
 #define xfs_ascii_ci_hashname		libxfs_ascii_ci_hashname
 
+#define xfs_attr3_leaf_hdr_from_disk	libxfs_attr3_leaf_hdr_from_disk
+#define xfs_attr3_leaf_read		libxfs_attr3_leaf_read
 #define xfs_attr_get			libxfs_attr_get
+#define xfs_attr_is_leaf		libxfs_attr_is_leaf
 #define xfs_attr_leaf_newentsize	libxfs_attr_leaf_newentsize
 #define xfs_attr_namecheck		libxfs_attr_namecheck
 #define xfs_attr_set			libxfs_attr_set
@@ -91,6 +94,7 @@
 #define xfs_compute_rextslog		libxfs_compute_rextslog
 #define xfs_create_space_res		libxfs_create_space_res
 #define xfs_da3_node_hdr_from_disk	libxfs_da3_node_hdr_from_disk
+#define xfs_da3_node_read		libxfs_da3_node_read
 #define xfs_da_get_buf			libxfs_da_get_buf
 #define xfs_da_hashname			libxfs_da_hashname
 #define xfs_da_read_buf			libxfs_da_read_buf
@@ -164,6 +168,7 @@
 #define xfs_inobt_stage_cursor		libxfs_inobt_stage_cursor
 #define xfs_inode_from_disk		libxfs_inode_from_disk
 #define xfs_inode_from_disk_ts		libxfs_inode_from_disk_ts
+#define xfs_inode_hasattr		libxfs_inode_hasattr
 #define xfs_inode_to_disk		libxfs_inode_to_disk
 #define xfs_inode_validate_cowextsize	libxfs_inode_validate_cowextsize
 #define xfs_inode_validate_extsize	libxfs_inode_validate_extsize
diff --git a/repair/attr_repair.c b/repair/attr_repair.c
index 314a9cb4d6e..b0f6ee11ae4 100644
--- a/repair/attr_repair.c
+++ b/repair/attr_repair.c
@@ -596,7 +596,7 @@ process_leaf_attr_block(
 	da_freemap_t *attr_freemap;
 	struct xfs_attr3_icleaf_hdr leafhdr;
 
-	xfs_attr3_leaf_hdr_from_disk(mp->m_attr_geo, &leafhdr, leaf);
+	libxfs_attr3_leaf_hdr_from_disk(mp->m_attr_geo, &leafhdr, leaf);
 	clearit = usedbs = 0;
 	firstb = mp->m_sb.sb_blocksize;
 	stop = xfs_attr3_leaf_hdr_size(leaf);
@@ -819,7 +819,7 @@ process_leaf_attr_level(xfs_mount_t	*mp,
 		}
 
 		leaf = bp->b_addr;
-		xfs_attr3_leaf_hdr_from_disk(mp->m_attr_geo, &leafhdr, leaf);
+		libxfs_attr3_leaf_hdr_from_disk(mp->m_attr_geo, &leafhdr, leaf);
 
 		/* check magic number for leaf directory btree block */
 		if (!(leafhdr.magic == XFS_ATTR_LEAF_MAGIC ||
@@ -1017,7 +1017,7 @@ process_longform_leaf_root(
 	 * check sibling pointers in leaf block or root block 0 before
 	 * we have to release the btree block
 	 */
-	xfs_attr3_leaf_hdr_from_disk(mp->m_attr_geo, &leafhdr, bp->b_addr);
+	libxfs_attr3_leaf_hdr_from_disk(mp->m_attr_geo, &leafhdr, bp->b_addr);
 	if (leafhdr.forw != 0 || leafhdr.back != 0)  {
 		if (!no_modify)  {
 			do_warn(

