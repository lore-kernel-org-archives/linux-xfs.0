Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 110BA128814
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:16:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711422985; cv=none; b=r9AgAPC4oOkO4VJd3sQ59kFGFRihNW/ew5rulIJ1hksPj47fHX/HzehV2KXHfn1vPX5eLbmNQzZ2LkImc0ZLKPAA/spBEqCIS+RZTtqZfX79R5F7523XFGAXg0s0gL9UvKzDfdDzxtt0Bvrl0VgNOf/1XKYVVX0mPruPbuSbQbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711422985; c=relaxed/simple;
	bh=gXIgfZNjh4mrUgd0kSEAMSUz693ACdMNN0c/4AeF3QY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cDtWcJfQZgljQGxhTqdP0+2cAHBGS3M+ocoqHUknjZQ7t7/A3Cp74YgEB4JcWSaPeHz2S0uZejZeBk36QvyWBHcLvo98h1SWu67FLG7Fey+E1Bum4wGPyIVUxq1DB9pAVutFFCl2EIxYA2wZrZZ+PgO/orV4vWLwZyFllLBWKmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ebwwQn8M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ebwwQn8M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98FB5C433F1;
	Tue, 26 Mar 2024 03:16:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711422984;
	bh=gXIgfZNjh4mrUgd0kSEAMSUz693ACdMNN0c/4AeF3QY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ebwwQn8MeOpuyznWm4KKWWBG2UM9/mMRgJ51PfnYtK2CKuxwTSLEdtbhn2X1NMXyA
	 UYRxa6k5S9dt/w8riIX0vGVg+yvFQGYK7j4pxqHjJPOP9xr6O2m3Nb0hfUBFhDYv2s
	 JFgmfAHRv3FcQqqEkYT+Ok6+SpkV/+AlwAXUaZHxAqBGoJIu/pCfnfTrPiWEumFxVj
	 UMBJdKnjadHzoUHhAC3iuQPdkebCENkFJd9TDwgVxzOEWT64R29S0V8US7+Lvmrdbr
	 gf076xevvMJDQICT8DMikVtqLbQDBozhRIzV5fDvZpMg7oIxYegfchRjLmhZQ7Ptd0
	 Ifrr06C2rtSiw==
Date: Mon, 25 Mar 2024 20:16:24 -0700
Subject: [PATCH 52/67] xfs: remove rt-wrappers from xfs_format.h
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Chandan Babu R <chandanbabu@kernel.org>,
 Bill O'Donnell <bodonnel@redhat.com>, linux-xfs@vger.kernel.org
Message-ID: <171142127705.2212320.203713272045813378.stgit@frogsfrogsfrogs>
In-Reply-To: <171142126868.2212320.6212071954549567554.stgit@frogsfrogsfrogs>
References: <171142126868.2212320.6212071954549567554.stgit@frogsfrogsfrogs>
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

