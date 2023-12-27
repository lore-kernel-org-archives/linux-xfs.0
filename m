Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 531841368
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:32:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QYZf8i0F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BABDEC433C7;
	Mon,  1 Jan 2024 00:32:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704069160;
	bh=UhraoKaT0k66RaVHa0zmmLgefl1WYzGlH263mbxOk10=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=QYZf8i0FLeC3MDGDKOGRxhOf9mH/m00Ord4CsYfimC330kdWFk/DfwptmtGqQ21yX
	 jrjUEpvFfELrFz2O39AYBers/pPiUstdsxaHrs/pPnMEvjM1D2HWn1r57vmNkBVtQc
	 f24IU380n5RgwIFS4vGOw7o++xrNdwcV6+Az7JHfhvtSX4mBG8QwCAneldMYm4w0ru
	 hbo7xj4wiTGuJx8TAZ5rmOkDBQqyfYddeCR1U0FG9PARU16CwGt46bPFRb75qhlmIE
	 QEYaQW6bwlw/cC3faUshASJIgE4N9fCIvzO29k+lOt+hioU2C1EubwOtXUhNFZusS4
	 nnksB7FnSI3FA==
Date: Sun, 31 Dec 2023 16:32:40 +9900
Subject: [PATCH 25/42] xfs_db: support the realtime refcountbt
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405017459.1817107.4296095343220480584.stgit@frogsfrogsfrogs>
In-Reply-To: <170405017092.1817107.5442809166380700367.stgit@frogsfrogsfrogs>
References: <170405017092.1817107.5442809166380700367.stgit@frogsfrogsfrogs>
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

Wire up various parts of xfs_db for realtime refcount support.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/btblock.c             |    3 +++
 db/btdump.c              |   11 ++++++++++-
 db/btheight.c            |    5 +++++
 libxfs/libxfs_api_defs.h |    1 +
 man/man8/xfs_db.8        |    1 +
 5 files changed, 20 insertions(+), 1 deletion(-)


diff --git a/db/btblock.c b/db/btblock.c
index 40913a09437..e9e5d2f86b9 100644
--- a/db/btblock.c
+++ b/db/btblock.c
@@ -159,6 +159,9 @@ block_to_bt(
 	case TYP_REFCBT:
 		magic = crc ? XFS_REFC_CRC_MAGIC : 0;
 		break;
+	case TYP_RTREFCBT:
+		magic = crc ? XFS_RTREFC_CRC_MAGIC : 0;
+		break;
 	default:
 		ASSERT(0);
 	}
diff --git a/db/btdump.c b/db/btdump.c
index 9c528e5a11a..31f32a8f7a5 100644
--- a/db/btdump.c
+++ b/db/btdump.c
@@ -447,7 +447,8 @@ is_btree_inode(void)
 	struct xfs_dinode	*dip;
 
 	dip = iocur_top->data;
-	return dip->di_format == XFS_DINODE_FMT_RMAP;
+	return dip->di_format == XFS_DINODE_FMT_RMAP ||
+	       dip->di_format == XFS_DINODE_FMT_REFCOUNT;
 }
 
 static int
@@ -457,6 +458,7 @@ dump_btree_inode(
 	char			*prefix;
 	struct xfs_dinode	*dip;
 	struct xfs_rtrmap_root	*rtrmap;
+	struct xfs_rtrefcount_root *rtrefc;
 	int			level;
 	int			numrecs;
 	int			ret;
@@ -469,6 +471,12 @@ dump_btree_inode(
 		level = be16_to_cpu(rtrmap->bb_level);
 		numrecs = be16_to_cpu(rtrmap->bb_numrecs);
 		break;
+	case XFS_DINODE_FMT_REFCOUNT:
+		prefix = "u3.rtrefcbt";
+		rtrefc = (struct xfs_rtrefcount_root *)XFS_DFORK_DPTR(dip);
+		level = be16_to_cpu(rtrefc->bb_level);
+		numrecs = be16_to_cpu(rtrefc->bb_numrecs);
+		break;
 	default:
 		dbprintf("Unknown metadata inode type %u\n", dip->di_format);
 		return 0;
@@ -550,6 +558,7 @@ btdump_f(
 	case TYP_BMAPBTA:
 	case TYP_BMAPBTD:
 	case TYP_RTRMAPBT:
+	case TYP_RTREFCBT:
 		return dump_btree_long(iflag);
 	case TYP_INODE:
 		if (is_btree_inode())
diff --git a/db/btheight.c b/db/btheight.c
index 25ce3400334..9dd21ddae9a 100644
--- a/db/btheight.c
+++ b/db/btheight.c
@@ -58,6 +58,11 @@ struct btmap {
 		.maxlevels	= libxfs_rtrmapbt_maxlevels_ondisk,
 		.maxrecs	= libxfs_rtrmapbt_maxrecs,
 	},
+	{
+		.tag		= "rtrefcountbt",
+		.maxlevels	= libxfs_rtrefcountbt_maxlevels_ondisk,
+		.maxrecs	= libxfs_rtrefcountbt_maxrecs,
+	},
 };
 
 static void
diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 1a21eb30f39..36e09b3a237 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -295,6 +295,7 @@
 
 #define xfs_rtrefcountbt_create_path	libxfs_rtrefcountbt_create_path
 #define xfs_rtrefcountbt_droot_maxrecs	libxfs_rtrefcountbt_droot_maxrecs
+#define xfs_rtrefcountbt_maxlevels_ondisk	libxfs_rtrefcountbt_maxlevels_ondisk
 #define xfs_rtrefcountbt_maxrecs	libxfs_rtrefcountbt_maxrecs
 
 #define xfs_rtrmapbt_calc_reserves	libxfs_rtrmapbt_calc_reserves
diff --git a/man/man8/xfs_db.8 b/man/man8/xfs_db.8
index 71859b3af44..3e80bcc57de 100644
--- a/man/man8/xfs_db.8
+++ b/man/man8/xfs_db.8
@@ -455,6 +455,7 @@ The supported btree types are:
 .IR bmapbt ,
 .IR refcountbt ,
 .IR rmapbt ,
+.IR rtrefcountbt ,
 and
 .IR rtrmapbt .
 The magic value

