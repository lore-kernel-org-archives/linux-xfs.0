Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 776A6C636CC
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 21:06:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230078AbjBPVGx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 16:06:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230100AbjBPVGx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 16:06:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D8972B632
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 13:06:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B1418B8217A
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 21:06:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 714FBC433D2;
        Thu, 16 Feb 2023 21:06:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676581609;
        bh=rlZY2hureLjwd7HVSepenAKow1b7C3bQF03fZOGtYsc=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=FYx6iCD92sLNCLz5/r2Lr7DCvls9JQJhE0V/Zifvj7OuTlZyMFGGSeXR69E4TmYso
         k4otDzTYBhIDaRMpkmd8WcoeavLYTOsMBGhTpKVUQ/ZNtgHoxJDhv9AwSIhnPQa1kj
         djGToWXy4w9XrR5VOkxjEJ7jvJpjQsd0Kgt1IFuzEApx+RDXr0abVK3uNvqoqpn/BU
         vHX73usJjLiwldbKeXjInTFWR+oayXDEvz46Prep5YPrZ1MBAnDkA1HsI/I/HB+29c
         /uwIip0sxSZaW8ngMvP13CduAmB3nSSzFRYtvNiQgsSCGTbblXb9dnavSIfviCwYS0
         h0e11LJ+9NpNA==
Date:   Thu, 16 Feb 2023 13:06:48 -0800
Subject: [PATCH 4/4] libxfs: export attr3_leaf_hdr_from_disk via
 libxfs_api_defs.h
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167657880733.3477371.14571769745474857902.stgit@magnolia>
In-Reply-To: <167657880680.3477371.18364607478868446486.stgit@magnolia>
References: <167657880680.3477371.18364607478868446486.stgit@magnolia>
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
 libxfs/libxfs_api_defs.h |    1 +
 repair/attr_repair.c     |    6 +++---
 4 files changed, 6 insertions(+), 5 deletions(-)


diff --git a/db/attr.c b/db/attr.c
index db7cf54b..8ea7b36e 100644
--- a/db/attr.c
+++ b/db/attr.c
@@ -253,7 +253,7 @@ attr_leaf_entry_walk(
 		return 0;
 
 	off = byteize(startoff);
-	xfs_attr3_leaf_hdr_from_disk(mp->m_attr_geo, &leafhdr, leaf);
+	libxfs_attr3_leaf_hdr_from_disk(mp->m_attr_geo, &leafhdr, leaf);
 	entries = xfs_attr3_leaf_entryp(leaf);
 
 	for (i = 0; i < leafhdr.count; i++) {
diff --git a/db/metadump.c b/db/metadump.c
index bb441fbb..4be23993 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -1757,7 +1757,7 @@ process_attr_block(
 	}
 
 	/* Ok, it's a leaf - get header; accounts for crc & non-crc */
-	xfs_attr3_leaf_hdr_from_disk(mp->m_attr_geo, &hdr, leaf);
+	libxfs_attr3_leaf_hdr_from_disk(mp->m_attr_geo, &hdr, leaf);
 
 	nentries = hdr.count;
 	if (nentries == 0 ||
diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 055d2862..6d045867 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -33,6 +33,7 @@
 #define xfs_alloc_read_agf		libxfs_alloc_read_agf
 #define xfs_alloc_vextent		libxfs_alloc_vextent
 
+#define xfs_attr3_leaf_hdr_from_disk	libxfs_attr3_leaf_hdr_from_disk
 #define xfs_attr_get			libxfs_attr_get
 #define xfs_attr_leaf_newentsize	libxfs_attr_leaf_newentsize
 #define xfs_attr_namecheck		libxfs_attr_namecheck
diff --git a/repair/attr_repair.c b/repair/attr_repair.c
index afe8073c..d3fd7a47 100644
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

