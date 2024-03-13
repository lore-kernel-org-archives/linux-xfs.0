Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DEC2BA27
	for <linux-xfs@vger.kernel.org>; Wed, 13 Mar 2024 02:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710295596; cv=none; b=UBxSn6fJI83KLVYJJsQGDIeLd/7CgB7IPao1j2atqcrenVQAeN9JHunkAGW1wLV9ngTl0N0UY8yrjOd1Z7fvQ/1qvAGhH5fILZmRv1o1U/oNTpuehbdrTGDu0Hu7aFd17GQ9f0K7DkvPFTlXbkxtUC1qxhoCqgBGno8YBhy31Go=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710295596; c=relaxed/simple;
	bh=hf1XHQME6cOXumdYrXR7WXApK7eVEM5f3o1K5knPNu0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=grsFUGc/QJ5ijs9hey8t33KrS4+RpEv/zhQ9iTLczOUqUBYBvWgdpUJrVB+DphqwKdZUQMQdg7FvQPgmx7A61PjONS1IJKAaIb23Ls5yd5uuKjSPeEJSUIpOzvXPI5UHpMt3OD5ryv6TCegAUloRHIsclz4pMcG3rb9f3wGyREY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nbTxCQCb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nbTxCQCb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3EC4C433C7;
	Wed, 13 Mar 2024 02:06:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710295595;
	bh=hf1XHQME6cOXumdYrXR7WXApK7eVEM5f3o1K5knPNu0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=nbTxCQCb8/zhC2AoUeZpLOoQc0+eAkmQkBhGmaY0QHyqE0i6Kx4cbPWSS+/LBAn6R
	 fma0Clq+x3EI9t0Nl61n/aRCpGxyFnmvTAY2Y86b7z8B91AMp4+8GHosAbeO/AODRY
	 sIFg+HcESAkLxKIWOPvsXjC1b/LSpPB0VQqn5l98PO7Vw12Mkt5UU1tpceZbv0yq1E
	 nZsrEATTOhRaCQQYkAGvGr38KkYi/RM6M6BzHNY0X90ziSgrIpnGGyLUSh4ZAu6suI
	 VPScMO21KzAURyVz8p+nHzNSWCdBoXvvvxf40NIbqX9gXSJc5nd4mlksl48opF5vHO
	 bY81EWx3DHwCQ==
Date: Tue, 12 Mar 2024 19:06:35 -0700
Subject: [PATCH 52/67] xfs: remove rt-wrappers from xfs_format.h
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Chandan Babu R <chandanbabu@kernel.org>,
 linux-xfs@vger.kernel.org
Message-ID: <171029431944.2061787.16040978514955489550.stgit@frogsfrogsfrogs>
In-Reply-To: <171029431107.2061787.680090905906055791.stgit@frogsfrogsfrogs>
References: <171029431107.2061787.680090905906055791.stgit@frogsfrogsfrogs>
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
---
 db/check.c            |    4 ++--
 libxfs/xfs_format.h   |    8 --------
 libxfs/xfs_rtbitmap.c |   24 ++++++++++++------------
 repair/rt.c           |    6 ++----
 4 files changed, 16 insertions(+), 26 deletions(-)


diff --git a/db/check.c b/db/check.c
index 2f2fbc7cbd81..91d0c094064b 100644
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
index e6ca188e2271..7d2873a79a48 100644
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
index bbf955be852a..eefc45c64e20 100644
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
index e49487829af2..4c81e2114c77 100644
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

