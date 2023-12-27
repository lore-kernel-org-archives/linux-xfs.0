Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81304384
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:16:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h4nP7Zu3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52205C433C7;
	Mon,  1 Jan 2024 00:16:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704068191;
	bh=HHnhsG+HS1rs8NrdzbvxQDpoiAc7M4/Mp9+5FLeb9kw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=h4nP7Zu3317NAqXJ3J/IvnJaPB+HXIxDq5QcQ+sn92+oOCMQt9gQHlmpIk5RWxRBs
	 h2mhqgteN689ruyc1XP42GZvzCNeCjtME1/lUt+9b+aG6Ds2QmfrhjPBNshOmXnqCt
	 zh6XJV7SFmItNcd7+6C0ky7EUH6jeUOc6KDATWutz/NSSPYTZjNC1SPXy7Rg03CyRp
	 e9jXvIjLkJtCy/UPEDmWM6vgpuzLCA7EUoLRfqdE59cmzMYiuKs7Be1N1u5Cj2QCv2
	 C6cYcpaZ9yXrEPRn+hP65Stk4cBHrAy+QqT2PucAJm7uxCbF5sCXMnIsEy9+173Fci
	 1/Kb2xyKvG18Q==
Date: Sun, 31 Dec 2023 16:16:30 +9900
Subject: [PATCH 23/47] xfs_db: support the realtime rmapbt
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405015619.1815505.6319090856730567215.stgit@frogsfrogsfrogs>
In-Reply-To: <170405015275.1815505.16749821217116487639.stgit@frogsfrogsfrogs>
References: <170405015275.1815505.16749821217116487639.stgit@frogsfrogsfrogs>
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
index e961453052a..4b2fbd7cac9 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -288,6 +288,7 @@
 #define xfs_rtgroup_update_super	libxfs_rtgroup_update_super
 #define xfs_rtrmapbt_create_path	libxfs_rtrmapbt_create_path
 #define xfs_rtrmapbt_droot_maxrecs	libxfs_rtrmapbt_droot_maxrecs
+#define xfs_rtrmapbt_maxlevels_ondisk	libxfs_rtrmapbt_maxlevels_ondisk
 #define xfs_rtrmapbt_maxrecs		libxfs_rtrmapbt_maxrecs
 
 #define xfs_sb_from_disk		libxfs_sb_from_disk
diff --git a/man/man8/xfs_db.8 b/man/man8/xfs_db.8
index 0e20108fb51..778e3f9dd70 100644
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

