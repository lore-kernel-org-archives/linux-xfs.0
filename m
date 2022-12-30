Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CF87C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:48:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236198AbiLaCsB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:48:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236196AbiLaCsA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:48:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F910DF76
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:47:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ECE88B81E6E
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:47:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2233C433EF;
        Sat, 31 Dec 2022 02:47:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672454876;
        bh=ML+t6bStewtvDZSJFIzt69x6Fgk2Q9TYDXNnFYQz3nY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=N/C00Suzt66Uf0wlnOejF8LKxoZyGm534cHLDX2LB30hKxzZ2GLcxsLHmaz7a5lx5
         ZCALcnMBuXrAYkMght6Yhy6UhST3Nzk8ZIK9wXqCCCTgLXL/mkTiQrHIgjsH4A72ki
         pKumk1OcKCNKkXYB7F2W1Z4rG8ihgLlykkPMQrDEhQHOKUtTjTgMGiXqd8UxJqOx57
         DoscXziI0OmCvu7WAcfxwjIM71Ba0iU4GHzrmlMksgANTVyNysqQwwpFuclJEqsIhE
         ciP00+odjTSOCQqmkFTkLWwySmyYXQlAoVrSf90t2XsSuj7EXqSj/EHD/0vpoIc/ml
         hm8R8dCgI2k6w==
Subject: [PATCH 21/41] xfs_db: support the realtime rmapbt
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:58 -0800
Message-ID: <167243879872.732820.16471267077095248353.stgit@magnolia>
In-Reply-To: <167243879574.732820.4725863402652761218.stgit@magnolia>
References: <167243879574.732820.4725863402652761218.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Wire up various parts of xfs_db for realtime rmap support.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/btblock.c             |    3 ++
 db/btdump.c              |   64 ++++++++++++++++++++++++++++++++++++++++++++++
 db/btheight.c            |    5 ++++
 libxfs/libxfs_api_defs.h |    1 +
 man/man8/xfs_db.8        |    3 +-
 5 files changed, 75 insertions(+), 1 deletion(-)


diff --git a/db/btblock.c b/db/btblock.c
index 5cad166278d..70f6c3f6aed 100644
--- a/db/btblock.c
+++ b/db/btblock.c
@@ -147,6 +147,9 @@ block_to_bt(
 	case TYP_RMAPBT:
 		magic = crc ? XFS_RMAP_CRC_MAGIC : 0;
 		break;
+	case TYP_RTRMAPBT:
+		magic = crc ? XFS_RTRMAP_CRC_MAGIC : 0;
+		break;
 	case TYP_REFCBT:
 		magic = crc ? XFS_REFC_CRC_MAGIC : 0;
 		break;
diff --git a/db/btdump.c b/db/btdump.c
index 81642cde2b6..9c528e5a11a 100644
--- a/db/btdump.c
+++ b/db/btdump.c
@@ -441,6 +441,67 @@ dump_dabtree(
 	return ret;
 }
 
+static bool
+is_btree_inode(void)
+{
+	struct xfs_dinode	*dip;
+
+	dip = iocur_top->data;
+	return dip->di_format == XFS_DINODE_FMT_RMAP;
+}
+
+static int
+dump_btree_inode(
+	bool			dump_node_blocks)
+{
+	char			*prefix;
+	struct xfs_dinode	*dip;
+	struct xfs_rtrmap_root	*rtrmap;
+	int			level;
+	int			numrecs;
+	int			ret;
+
+	dip = iocur_top->data;
+	switch (dip->di_format) {
+	case XFS_DINODE_FMT_RMAP:
+		prefix = "u3.rtrmapbt";
+		rtrmap = (struct xfs_rtrmap_root *)XFS_DFORK_DPTR(dip);
+		level = be16_to_cpu(rtrmap->bb_level);
+		numrecs = be16_to_cpu(rtrmap->bb_numrecs);
+		break;
+	default:
+		dbprintf("Unknown metadata inode type %u\n", dip->di_format);
+		return 0;
+	}
+
+	if (numrecs == 0)
+		return 0;
+	if (level > 0) {
+		if (dump_node_blocks) {
+			ret = eval("print %s.keys", prefix);
+			if (ret)
+				goto err;
+			ret = eval("print %s.ptrs", prefix);
+			if (ret)
+				goto err;
+		}
+		ret = eval("addr %s.ptrs[1]", prefix);
+		if (ret)
+			goto err;
+		ret = dump_btree_long(dump_node_blocks);
+	} else {
+		ret = eval("print %s.recs", prefix);
+	}
+	if (ret)
+		goto err;
+
+	ret = eval("pop");
+	return ret;
+err:
+	eval("pop");
+	return ret;
+}
+
 static int
 btdump_f(
 	int		argc,
@@ -488,8 +549,11 @@ btdump_f(
 		return dump_btree_short(iflag);
 	case TYP_BMAPBTA:
 	case TYP_BMAPBTD:
+	case TYP_RTRMAPBT:
 		return dump_btree_long(iflag);
 	case TYP_INODE:
+		if (is_btree_inode())
+			return dump_btree_inode(iflag);
 		return dump_inode(iflag, aflag);
 	case TYP_ATTR:
 		return dump_dabtree(iflag, crc ? &attr3_print : &attr_print);
diff --git a/db/btheight.c b/db/btheight.c
index 6643489c82c..25ce3400334 100644
--- a/db/btheight.c
+++ b/db/btheight.c
@@ -53,6 +53,11 @@ struct btmap {
 		.maxlevels	= libxfs_rmapbt_maxlevels_ondisk,
 		.maxrecs	= libxfs_rmapbt_maxrecs,
 	},
+	{
+		.tag		= "rtrmapbt",
+		.maxlevels	= libxfs_rtrmapbt_maxlevels_ondisk,
+		.maxrecs	= libxfs_rtrmapbt_maxrecs,
+	},
 };
 
 static void
diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index ae92c909265..0e284e515d8 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -245,6 +245,7 @@
 #define xfs_rtgroup_update_super	libxfs_rtgroup_update_super
 #define xfs_rtrmapbt_create_path	libxfs_rtrmapbt_create_path
 #define xfs_rtrmapbt_droot_maxrecs	libxfs_rtrmapbt_droot_maxrecs
+#define xfs_rtrmapbt_maxlevels_ondisk	libxfs_rtrmapbt_maxlevels_ondisk
 #define xfs_rtrmapbt_maxrecs		libxfs_rtrmapbt_maxrecs
 
 #define xfs_sb_from_disk		libxfs_sb_from_disk
diff --git a/man/man8/xfs_db.8 b/man/man8/xfs_db.8
index 92d22cbc15f..2efa45297db 100644
--- a/man/man8/xfs_db.8
+++ b/man/man8/xfs_db.8
@@ -454,8 +454,9 @@ The supported btree types are:
 .IR finobt ,
 .IR bmapbt ,
 .IR refcountbt ,
+.IR rmapbt ,
 and
-.IR rmapbt .
+.IR rtrmapbt .
 The magic value
 .I all
 can be used to walk through all btree types.

