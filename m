Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A33B47F7C
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 21:35:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713389721; cv=none; b=LFqkRqx2tDihuzYGFuu+PR7wleMwBHZsBCdbrg4i2YdUfe6BWURwAeTxCsgfQwC6yfSJ5DTDTC6zNJZMOPbpU20ew94QnTTBlykPUMwRl9JpOWEUi/jidc/+Lu/hoLqW7Mg/4vP438D4TPdS8hQalGwpUAYvTQMAp83gqVedrfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713389721; c=relaxed/simple;
	bh=laL1pfppCxKSERmJnQ2sflGdub/9t0g0aP2NVjICxgg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ueQFG0KR0GOTlAkC7HPoVWqxvNBtfvvYsCRaoUu9LFzPojkw0mtNOxRjJOOdkeqiLHo4jZ64PBvD7b7W3x1J7BohFbPJkiUsbKT9p8TwLy6/lcdth048XefJppeas5jDuLDbekePYGb0AfwnLT53X5hN+CI+BNhyPAjfR5ZrjkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Kk4inBx4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Kk4inBx4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1504BC072AA;
	Wed, 17 Apr 2024 21:35:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713389721;
	bh=laL1pfppCxKSERmJnQ2sflGdub/9t0g0aP2NVjICxgg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Kk4inBx4BfXTA4PeDTD08MVHM+AhyMxacWPa6+UART9KvD1gfk4/Wu6zZ/rKHF0AT
	 6p9IEOyOhuYjpkO6fyi3N4AAqtfi1w5ALet300uIPxJkgMtScx4AZj/OR5h8WjqtGK
	 6YNhVXp9WR0iqfr5HCfubP0k3IZjlnKitx5sxV9kH/x5yq9ECkJvLMA12sSeMJivIy
	 emuL8SHMVQIKGMqTRKZlYpG16lWT2xrqmgf3dIN4/B2y1b0XvLZLGvl+f2gfu4x3wR
	 eg/FXaKUqkNkJgsknNWtTn8gk7eRJOEsYaHdJkbXTq4UVuRpEMptw/dLVdtPmiBUrc
	 DyV/uq0Ty0uOg==
Date: Wed, 17 Apr 2024 14:35:20 -0700
Subject: [PATCH 52/67] xfs: remove rt-wrappers from xfs_format.h
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Chandan Babu R <chandanbabu@kernel.org>,
 Bill O'Donnell <bodonnel@redhat.com>, linux-xfs@vger.kernel.org
Message-ID: <171338843120.1853449.5390832963341216896.stgit@frogsfrogsfrogs>
In-Reply-To: <171338842269.1853449.4066376212453408283.stgit@frogsfrogsfrogs>
References: <171338842269.1853449.4066376212453408283.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: 3abfe6c2759e2e3000b13f8ce8a1a325e80987a1

xfs_format.h has a bunch odd wrappers for helper functions and mount
structure access using RT* prefixes.  Replace them with their open coded
versions (for those that weren't entirely unused) and remove the wrappers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>
---
 db/check.c            |    4 ++--
 libxfs/xfs_format.h   |    8 --------
 libxfs/xfs_rtbitmap.c |   24 ++++++++++++------------
 repair/rt.c           |    6 ++----
 4 files changed, 16 insertions(+), 26 deletions(-)


diff --git a/db/check.c b/db/check.c
index 2f2fbc7cb..91d0c0940 100644
--- a/db/check.c
+++ b/db/check.c
@@ -3688,7 +3688,7 @@ process_rtbitmap(
 			} else if (prevbit == 1) {
 				len = ((int)bmbno - start_bmbno) *
 					bitsperblock + (bit - start_bit);
-				log = XFS_RTBLOCKLOG(len);
+				log = libxfs_highbit64(len);
 				offs = xfs_rtsumoffs(mp, log, start_bmbno);
 				inc_sumcount(mp, sumcompute, offs);
 				prevbit = 0;
@@ -3701,7 +3701,7 @@ process_rtbitmap(
 	if (prevbit == 1) {
 		len = ((int)bmbno - start_bmbno) * bitsperblock +
 			(bit - start_bit);
-		log = XFS_RTBLOCKLOG(len);
+		log = libxfs_highbit64(len);
 		offs = xfs_rtsumoffs(mp, log, start_bmbno);
 		inc_sumcount(mp, sumcompute, offs);
 	}
diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index e6ca188e2..7d2873a79 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -1156,20 +1156,12 @@ static inline bool xfs_dinode_has_large_extent_counts(
 #define	XFS_DFL_RTEXTSIZE	(64 * 1024)	        /* 64kB */
 #define	XFS_MIN_RTEXTSIZE	(4 * 1024)		/* 4kB */
 
-#define	XFS_BLOCKSIZE(mp)	((mp)->m_sb.sb_blocksize)
-#define	XFS_BLOCKMASK(mp)	((mp)->m_blockmask)
-
 /*
  * RT bit manipulation macros.
  */
 #define	XFS_RTMIN(a,b)	((a) < (b) ? (a) : (b))
 #define	XFS_RTMAX(a,b)	((a) > (b) ? (a) : (b))
 
-#define	XFS_RTLOBIT(w)	xfs_lowbit32(w)
-#define	XFS_RTHIBIT(w)	xfs_highbit32(w)
-
-#define	XFS_RTBLOCKLOG(b)	xfs_highbit64(b)
-
 /*
  * Dquot and dquot block format definitions
  */
diff --git a/libxfs/xfs_rtbitmap.c b/libxfs/xfs_rtbitmap.c
index bbf955be8..eefc45c64 100644
--- a/libxfs/xfs_rtbitmap.c
+++ b/libxfs/xfs_rtbitmap.c
@@ -193,7 +193,7 @@ xfs_rtfind_back(
 			/*
 			 * Different.  Mark where we are and return.
 			 */
-			i = bit - XFS_RTHIBIT(wdiff);
+			i = bit - xfs_highbit32(wdiff);
 			*rtx = start - i + 1;
 			return 0;
 		}
@@ -231,7 +231,7 @@ xfs_rtfind_back(
 			/*
 			 * Different, mark where we are and return.
 			 */
-			i += XFS_NBWORD - 1 - XFS_RTHIBIT(wdiff);
+			i += XFS_NBWORD - 1 - xfs_highbit32(wdiff);
 			*rtx = start - i + 1;
 			return 0;
 		}
@@ -270,7 +270,7 @@ xfs_rtfind_back(
 			/*
 			 * Different, mark where we are and return.
 			 */
-			i += XFS_NBWORD - 1 - XFS_RTHIBIT(wdiff);
+			i += XFS_NBWORD - 1 - xfs_highbit32(wdiff);
 			*rtx = start - i + 1;
 			return 0;
 		} else
@@ -346,7 +346,7 @@ xfs_rtfind_forw(
 			/*
 			 * Different.  Mark where we are and return.
 			 */
-			i = XFS_RTLOBIT(wdiff) - bit;
+			i = xfs_lowbit32(wdiff) - bit;
 			*rtx = start + i - 1;
 			return 0;
 		}
@@ -384,7 +384,7 @@ xfs_rtfind_forw(
 			/*
 			 * Different, mark where we are and return.
 			 */
-			i += XFS_RTLOBIT(wdiff);
+			i += xfs_lowbit32(wdiff);
 			*rtx = start + i - 1;
 			return 0;
 		}
@@ -421,7 +421,7 @@ xfs_rtfind_forw(
 			/*
 			 * Different, mark where we are and return.
 			 */
-			i += XFS_RTLOBIT(wdiff);
+			i += xfs_lowbit32(wdiff);
 			*rtx = start + i - 1;
 			return 0;
 		} else
@@ -706,7 +706,7 @@ xfs_rtfree_range(
 	 */
 	if (preblock < start) {
 		error = xfs_rtmodify_summary(args,
-				XFS_RTBLOCKLOG(start - preblock),
+				xfs_highbit64(start - preblock),
 				xfs_rtx_to_rbmblock(mp, preblock), -1);
 		if (error) {
 			return error;
@@ -718,7 +718,7 @@ xfs_rtfree_range(
 	 */
 	if (postblock > end) {
 		error = xfs_rtmodify_summary(args,
-				XFS_RTBLOCKLOG(postblock - end),
+				xfs_highbit64(postblock - end),
 				xfs_rtx_to_rbmblock(mp, end + 1), -1);
 		if (error) {
 			return error;
@@ -729,7 +729,7 @@ xfs_rtfree_range(
 	 * (new) free extent.
 	 */
 	return xfs_rtmodify_summary(args,
-			XFS_RTBLOCKLOG(postblock + 1 - preblock),
+			xfs_highbit64(postblock + 1 - preblock),
 			xfs_rtx_to_rbmblock(mp, preblock), 1);
 }
 
@@ -798,7 +798,7 @@ xfs_rtcheck_range(
 			/*
 			 * Different, compute first wrong bit and return.
 			 */
-			i = XFS_RTLOBIT(wdiff) - bit;
+			i = xfs_lowbit32(wdiff) - bit;
 			*new = start + i;
 			*stat = 0;
 			return 0;
@@ -837,7 +837,7 @@ xfs_rtcheck_range(
 			/*
 			 * Different, compute first wrong bit and return.
 			 */
-			i += XFS_RTLOBIT(wdiff);
+			i += xfs_lowbit32(wdiff);
 			*new = start + i;
 			*stat = 0;
 			return 0;
@@ -875,7 +875,7 @@ xfs_rtcheck_range(
 			/*
 			 * Different, compute first wrong bit and return.
 			 */
-			i += XFS_RTLOBIT(wdiff);
+			i += xfs_lowbit32(wdiff);
 			*new = start + i;
 			*stat = 0;
 			return 0;
diff --git a/repair/rt.c b/repair/rt.c
index e49487829..4c81e2114 100644
--- a/repair/rt.c
+++ b/repair/rt.c
@@ -14,8 +14,6 @@
 #include "err_protos.h"
 #include "rt.h"
 
-#define xfs_highbit64 libxfs_highbit64	/* for XFS_RTBLOCKLOG macro */
-
 void
 rtinit(xfs_mount_t *mp)
 {
@@ -115,7 +113,7 @@ generate_rtinfo(
 				}
 			} else if (in_extent == 1) {
 				len = (int) (extno - start_ext);
-				log = XFS_RTBLOCKLOG(len);
+				log = libxfs_highbit64(len);
 				offs = xfs_rtsumoffs(mp, log, start_bmbno);
 				inc_sumcount(mp, sumcompute, offs);
 				in_extent = 0;
@@ -131,7 +129,7 @@ generate_rtinfo(
 	}
 	if (in_extent == 1) {
 		len = (int) (extno - start_ext);
-		log = XFS_RTBLOCKLOG(len);
+		log = libxfs_highbit64(len);
 		offs = xfs_rtsumoffs(mp, log, start_bmbno);
 		inc_sumcount(mp, sumcompute, offs);
 	}

