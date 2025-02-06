Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AF8E237711
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 22:51:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738882310; cv=none; b=WZLLRPewUD8StlEPyXcXbC31Czq6/HpPVsWT3XigIzO2s2uS0Cf5kOAG+EvRhuYwVE76vkfEUM1qbESBMyhTzbZkW9fRRhUkOYCAZNHJ4owQGQnfR68DsCnmwRLdvu0TBdBJXIdAaqbDc03reOI/lmJatPflVz685DC5m+kz0HI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738882310; c=relaxed/simple;
	bh=zmVOTi6pY/U+jx4QcESAizugxO0vRQ2r+bxWLCWxBD8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=B7pbzSlr3VtLNatmiOuQ/Fep0C+Hu6ZSEQoNM8etrHimF4Y6DNsKVudHhwXsAkui3EhVLq9ks/P1F4uMRrErzlIVNZmmZGQbASfsHa4JqCr/6X8r1TnwmSO3pDWqzZJfSTgnNZfeSymIx6rTc+pWcaD5617xyLD8Dqvp64vI0tA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hFfzF40I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hFfzF40I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C2C9C4CEDD;
	Thu,  6 Feb 2025 22:51:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738882309;
	bh=zmVOTi6pY/U+jx4QcESAizugxO0vRQ2r+bxWLCWxBD8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=hFfzF40Iic0S5q9yaKJ3sDGCViyvL8KVYqxoHOZNLS0/zU+JMpTGfapoDI//Nb9qx
	 JDJPL8NWnEoklFdpWgUSRszXd8YGXitemE1LqsWs43s4APgqxOo2UT227tLzQWivKP
	 Tux0SM04GJuS1046fpJR62HkPZePV0nExfOQoJQzN0Np0EBlqmoz5ST+VCtMVWSAda
	 6gfJQM32NJxHAbOZ6mT0W6b2uM4Ddf107MIMYp0cqC1cBoa2iDKWway9dXoV5H/VDW
	 C0+MmythnLV6YdCMTtE8mNcJgT/R4657cPww2pX5ckVpmlFTg6H9bB21HclW5rayuU
	 m0Y3NopYiGL+Q==
Date: Thu, 06 Feb 2025 14:51:49 -0800
Subject: [PATCH 08/27] xfs_db: support the realtime rmapbt
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173888088218.2741033.7947778465817978960.stgit@frogsfrogsfrogs>
In-Reply-To: <173888088056.2741033.17433872323468891160.stgit@frogsfrogsfrogs>
References: <173888088056.2741033.17433872323468891160.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Wire up various parts of xfs_db for realtime rmap support so that we can
dump the btree contents.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 db/btblock.c             |    3 ++
 db/btdump.c              |   63 ++++++++++++++++++++++++++++++++++++++++++++++
 db/btheight.c            |    5 ++++
 libxfs/libxfs_api_defs.h |    1 +
 man/man8/xfs_db.8        |    3 +-
 5 files changed, 74 insertions(+), 1 deletion(-)


diff --git a/db/btblock.c b/db/btblock.c
index 5cad166278d98b..70f6c3f6aedde5 100644
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
index 81642cde2b6d8f..55301d25de10cd 100644
--- a/db/btdump.c
+++ b/db/btdump.c
@@ -441,6 +441,66 @@ dump_dabtree(
 	return ret;
 }
 
+static bool
+is_btree_inode(void)
+{
+	struct xfs_dinode	*dip = iocur_top->data;
+
+	return dip->di_format == XFS_DINODE_FMT_META_BTREE;
+}
+
+static int
+dump_btree_inode(
+	bool			dump_node_blocks)
+{
+	char			*prefix;
+	struct xfs_dinode	*dip = iocur_top->data;
+	struct xfs_rtrmap_root	*rtrmap;
+	int			level;
+	int			numrecs;
+	int			ret;
+
+	switch (be16_to_cpu(dip->di_metatype)) {
+	case XFS_METAFILE_RTRMAP:
+		prefix = "u3.rtrmapbt";
+		rtrmap = (struct xfs_rtrmap_root *)XFS_DFORK_DPTR(dip);
+		level = be16_to_cpu(rtrmap->bb_level);
+		numrecs = be16_to_cpu(rtrmap->bb_numrecs);
+		break;
+	default:
+		dbprintf("Unknown metadata inode btree type %u\n",
+				be16_to_cpu(dip->di_metatype));
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
@@ -488,8 +548,11 @@ btdump_f(
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
index 0456af08b39edf..31dff1c924a2e0 100644
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
index fcbcaaa11f1025..cf88656946ab1b 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -311,6 +311,7 @@
 #define xfs_rtfree_blocks		libxfs_rtfree_blocks
 #define xfs_update_rtsb			libxfs_update_rtsb
 #define xfs_rtrmapbt_droot_maxrecs	libxfs_rtrmapbt_droot_maxrecs
+#define xfs_rtrmapbt_maxlevels_ondisk	libxfs_rtrmapbt_maxlevels_ondisk
 #define xfs_rtrmapbt_maxrecs		libxfs_rtrmapbt_maxrecs
 
 #define xfs_sb_from_disk		libxfs_sb_from_disk
diff --git a/man/man8/xfs_db.8 b/man/man8/xfs_db.8
index ddbabe36b5fc41..83a8734d3c0b47 100644
--- a/man/man8/xfs_db.8
+++ b/man/man8/xfs_db.8
@@ -535,8 +535,9 @@ .SH COMMANDS
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

