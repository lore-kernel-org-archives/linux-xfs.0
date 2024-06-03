Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCF1C13B2A5
	for <linux-xfs@vger.kernel.org>; Mon,  3 Jun 2024 18:57:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717441067; cv=none; b=tQ3fauaGiUKXnfu28shySgkTU8pTEwOWCyE558xrgNzv4uNzS2d/5f0n85rt0/q69inHbBT4BGc7/QKliva1Og452NiLwZE4gRXPci8ke2i1qKxWw4HxiuoaugcAxdnLcJltIqtlY6UAVvLAd29cgIrOrbVBAi3bJHlERuOnbvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717441067; c=relaxed/simple;
	bh=rjjD5dTgItxX7JA7+LQYnUXrYlojLQHU2KFsq/XcFgI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MoPlJ3jt1zVi2uTSm76jKBj7PouTDRpKt9i62AV1iZ9oH9EXJ+3x3A5ISvDGI0Knm3AIDjHyFEKWng96fN7qgdnjQaFu9uBPlzXKTFC5ulAmVm79Uy3PBMq72kh79+rET+rqlkF8Bjgmeobh14cvSudBuQbe9v+EWWobdlIfia0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vPpjP+hg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vPpjP+hg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADED4C4AF0B;
	Mon,  3 Jun 2024 18:57:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717441067;
	bh=rjjD5dTgItxX7JA7+LQYnUXrYlojLQHU2KFsq/XcFgI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=vPpjP+hgDEbrXdO+XjYndUr7pbDUgMMHJu8TOT6e7JrJ3TFP6zgWbAi2N4XAKq7VG
	 +kog13SG8FuuBeRLW9tUJLZ+QTtL5q/8EbRtDwEUDK1joE6wn9HNExnAMCjDjPRGyR
	 2Q98s1ZYR2cdzph1Owdt95KKuhfLQZCrcxOfizhMadUaoi5/UWrVUVSBzHfPqmf5BG
	 bfuzsxbkRvx0L7YCSoAHp+wt3Jor9v0/awV8sNbFpLkibpHyhM894ojhcS2xaab71d
	 ntu9uCL6+n+f/k0zgzla5JYZQhZLOpX7IRP3/unZKoKgvZJpCp8KQZL9wJSnT1NW2V
	 La/M6dIYUNV4Q==
Date: Mon, 03 Jun 2024 11:57:47 -0700
Subject: [PATCH 022/111] xfs: report inode corruption errors to the health
 system
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cmaiolino@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171744039700.1443973.14563522154008277743.stgit@frogsfrogsfrogs>
In-Reply-To: <171744039240.1443973.5959953049110025783.stgit@frogsfrogsfrogs>
References: <171744039240.1443973.5959953049110025783.stgit@frogsfrogsfrogs>
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

Source kernel commit: baf44fa5c37a2357a7ae92889f74bc1824f33fd4

Whenever we encounter corrupt inode records, we should report that to
the health monitoring system for later reporting.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 libxfs/util.c           |    1 +
 libxfs/xfs_ialloc.c     |    1 +
 libxfs/xfs_inode_buf.c  |   12 +++++++++---
 libxfs/xfs_inode_fork.c |    8 ++++++++
 4 files changed, 19 insertions(+), 3 deletions(-)


diff --git a/libxfs/util.c b/libxfs/util.c
index 6c326e84a..6d8847363 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -736,3 +736,4 @@ void xfs_bmap_mark_sick(struct xfs_inode *ip, int whichfork) { }
 void xfs_btree_mark_sick(struct xfs_btree_cur *cur) { }
 void xfs_dirattr_mark_sick(struct xfs_inode *ip, int whichfork) { }
 void xfs_da_mark_sick(struct xfs_da_args *args) { }
+void xfs_inode_mark_sick(struct xfs_inode *ip, unsigned int mask) { }
diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index 92ca3d460..63922f44f 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -2994,6 +2994,7 @@ xfs_ialloc_check_shrink(
 		goto out;
 
 	if (!has) {
+		xfs_ag_mark_sick(pag, XFS_SICK_AG_INOBT);
 		error = -EFSCORRUPTED;
 		goto out;
 	}
diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
index fd351c252..83d936981 100644
--- a/libxfs/xfs_inode_buf.c
+++ b/libxfs/xfs_inode_buf.c
@@ -16,6 +16,7 @@
 #include "xfs_trans.h"
 #include "xfs_ialloc.h"
 #include "xfs_dir2.h"
+#include "xfs_health.h"
 
 
 /*
@@ -129,9 +130,14 @@ xfs_imap_to_bp(
 	struct xfs_imap		*imap,
 	struct xfs_buf		**bpp)
 {
-	return xfs_trans_read_buf(mp, tp, mp->m_ddev_targp, imap->im_blkno,
-				   imap->im_len, XBF_UNMAPPED, bpp,
-				   &xfs_inode_buf_ops);
+	int			error;
+
+	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp, imap->im_blkno,
+			imap->im_len, XBF_UNMAPPED, bpp, &xfs_inode_buf_ops);
+	if (xfs_metadata_is_sick(error))
+		xfs_agno_mark_sick(mp, xfs_daddr_to_agno(mp, imap->im_blkno),
+				XFS_SICK_AG_INOBT);
+	return error;
 }
 
 static inline struct timespec64 xfs_inode_decode_bigtime(uint64_t ts)
diff --git a/libxfs/xfs_inode_fork.c b/libxfs/xfs_inode_fork.c
index 6d8175723..53ff82678 100644
--- a/libxfs/xfs_inode_fork.c
+++ b/libxfs/xfs_inode_fork.c
@@ -23,6 +23,7 @@
 #include "xfs_attr_leaf.h"
 #include "xfs_types.h"
 #include "xfs_errortag.h"
+#include "xfs_health.h"
 
 struct kmem_cache *xfs_ifork_cache;
 
@@ -86,6 +87,7 @@ xfs_iformat_local(
 		xfs_inode_verifier_error(ip, -EFSCORRUPTED,
 				"xfs_iformat_local", dip, sizeof(*dip),
 				__this_address);
+		xfs_inode_mark_sick(ip, XFS_SICK_INO_CORE);
 		return -EFSCORRUPTED;
 	}
 
@@ -123,6 +125,7 @@ xfs_iformat_extents(
 		xfs_inode_verifier_error(ip, -EFSCORRUPTED,
 				"xfs_iformat_extents(1)", dip, sizeof(*dip),
 				__this_address);
+		xfs_inode_mark_sick(ip, XFS_SICK_INO_CORE);
 		return -EFSCORRUPTED;
 	}
 
@@ -142,6 +145,7 @@ xfs_iformat_extents(
 				xfs_inode_verifier_error(ip, -EFSCORRUPTED,
 						"xfs_iformat_extents(2)",
 						dp, sizeof(*dp), fa);
+				xfs_inode_mark_sick(ip, XFS_SICK_INO_CORE);
 				return xfs_bmap_complain_bad_rec(ip, whichfork,
 						fa, &new);
 			}
@@ -200,6 +204,7 @@ xfs_iformat_btree(
 		xfs_inode_verifier_error(ip, -EFSCORRUPTED,
 				"xfs_iformat_btree", dfp, size,
 				__this_address);
+		xfs_inode_mark_sick(ip, XFS_SICK_INO_CORE);
 		return -EFSCORRUPTED;
 	}
 
@@ -265,12 +270,14 @@ xfs_iformat_data_fork(
 		default:
 			xfs_inode_verifier_error(ip, -EFSCORRUPTED, __func__,
 					dip, sizeof(*dip), __this_address);
+			xfs_inode_mark_sick(ip, XFS_SICK_INO_CORE);
 			return -EFSCORRUPTED;
 		}
 		break;
 	default:
 		xfs_inode_verifier_error(ip, -EFSCORRUPTED, __func__, dip,
 				sizeof(*dip), __this_address);
+		xfs_inode_mark_sick(ip, XFS_SICK_INO_CORE);
 		return -EFSCORRUPTED;
 	}
 }
@@ -342,6 +349,7 @@ xfs_iformat_attr_fork(
 	default:
 		xfs_inode_verifier_error(ip, error, __func__, dip,
 				sizeof(*dip), __this_address);
+		xfs_inode_mark_sick(ip, XFS_SICK_INO_CORE);
 		error = -EFSCORRUPTED;
 		break;
 	}

