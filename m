Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 950BDC77B7A
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 02:28:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229842AbjEZC2X (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 22:28:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbjEZC2X (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 22:28:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F60DB2
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 19:28:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A381764C5C
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 02:28:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F0E5C433EF;
        Fri, 26 May 2023 02:28:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685068101;
        bh=ahvvS9EeB9uSJnNm+zUaZt85i9Nh/470VuB/yww1Cp8=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=UDgJ/UsXoql92gY4zgQIyzt4DrbnOKDBcL73xq37qw3yzL03Dg+KYDhfraE1IYXRw
         Xp8/oOlMts1TCA6v4aJeDI3thVYUNsGFSu7/vMIIQC8hF09MVoE0HS9OZmaVlqFWO8
         uWwwl7Form+j0XHPLaP4bv1K1dh81Iqq8E8gcYu6W819JrrgxD+yov+3RqCe/FqzlF
         IhjKU8O9akAdMmgETsatkrskznQcU5mX883jfm73KbhvtEdicJA45cnpoyTGro9lXb
         0CujYm/3oPbEuzNUeL5OvjEe3W8mrwvFNpeTS5I7FxP7e0apfSLLSDmb/4AknyYNUs
         sGmrjCjW3XdWA==
Date:   Thu, 25 May 2023 19:28:20 -0700
Subject: [PATCH 25/30] libxfs: export attr3_leaf_hdr_from_disk via
 libxfs_api_defs.h
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com,
        catherine.hoang@oracle.com
Message-ID: <168506078228.3749421.1486690706353918248.stgit@frogsfrogsfrogs>
In-Reply-To: <168506077876.3749421.7883085669588003826.stgit@frogsfrogsfrogs>
References: <168506077876.3749421.7883085669588003826.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

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
index 9b036c7b5db..dc0c29ae45e 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -1704,7 +1704,7 @@ process_attr_block(
 	}
 
 	/* Ok, it's a leaf - get header; accounts for crc & non-crc */
-	xfs_attr3_leaf_hdr_from_disk(mp->m_attr_geo, &hdr, leaf);
+	libxfs_attr3_leaf_hdr_from_disk(mp->m_attr_geo, &hdr, leaf);
 
 	nentries = hdr.count;
 	if (nentries == 0 ||
diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 7779040f0ba..7d1d1ddf624 100644
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
@@ -89,6 +92,7 @@
 #define xfs_calc_dquots_per_chunk	libxfs_calc_dquots_per_chunk
 #define xfs_create_space_res		libxfs_create_space_res
 #define xfs_da3_node_hdr_from_disk	libxfs_da3_node_hdr_from_disk
+#define xfs_da3_node_read		libxfs_da3_node_read
 #define xfs_da_get_buf			libxfs_da_get_buf
 #define xfs_da_hashname			libxfs_da_hashname
 #define xfs_da_read_buf			libxfs_da_read_buf
@@ -161,6 +165,7 @@
 #define xfs_inobt_stage_cursor		libxfs_inobt_stage_cursor
 #define xfs_inode_from_disk		libxfs_inode_from_disk
 #define xfs_inode_from_disk_ts		libxfs_inode_from_disk_ts
+#define xfs_inode_hasattr		libxfs_inode_hasattr
 #define xfs_inode_to_disk		libxfs_inode_to_disk
 #define xfs_inode_validate_cowextsize	libxfs_inode_validate_cowextsize
 #define xfs_inode_validate_extsize	libxfs_inode_validate_extsize
diff --git a/repair/attr_repair.c b/repair/attr_repair.c
index afe8073ca8e..d3fd7a47a5b 100644
--- a/repair/attr_repair.c
+++ b/repair/attr_repair.c
@@ -579,7 +579,7 @@ process_leaf_attr_block(
 	da_freemap_t *attr_freemap;
 	struct xfs_attr3_icleaf_hdr leafhdr;
 
-	xfs_attr3_leaf_hdr_from_disk(mp->m_attr_geo, &leafhdr, leaf);
+	libxfs_attr3_leaf_hdr_from_disk(mp->m_attr_geo, &leafhdr, leaf);
 	clearit = usedbs = 0;
 	firstb = mp->m_sb.sb_blocksize;
 	stop = xfs_attr3_leaf_hdr_size(leaf);
@@ -802,7 +802,7 @@ process_leaf_attr_level(xfs_mount_t	*mp,
 		}
 
 		leaf = bp->b_addr;
-		xfs_attr3_leaf_hdr_from_disk(mp->m_attr_geo, &leafhdr, leaf);
+		libxfs_attr3_leaf_hdr_from_disk(mp->m_attr_geo, &leafhdr, leaf);
 
 		/* check magic number for leaf directory btree block */
 		if (!(leafhdr.magic == XFS_ATTR_LEAF_MAGIC ||
@@ -1000,7 +1000,7 @@ process_longform_leaf_root(
 	 * check sibling pointers in leaf block or root block 0 before
 	 * we have to release the btree block
 	 */
-	xfs_attr3_leaf_hdr_from_disk(mp->m_attr_geo, &leafhdr, bp->b_addr);
+	libxfs_attr3_leaf_hdr_from_disk(mp->m_attr_geo, &leafhdr, bp->b_addr);
 	if (leafhdr.forw != 0 || leafhdr.back != 0)  {
 		if (!no_modify)  {
 			do_warn(

