Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4CB95234
	for <linux-xfs@vger.kernel.org>; Wed, 22 May 2024 02:54:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716346471; cv=none; b=oK9XiB2R9nAK20TPV85Ax1tFwV/Op0UlyPo2toeHd7IwqBuWA/+TkF/Xr8mnGH1MRILSAvCJh5/IiPQ2ULBZXALamYkGtmSQ1NeCvnNk9exng+c0aaatG5tEyAneGyjeO9fyJ/LMAAeYJ1ayLOvR1dnamuXaJ7AAm+mGnOP4YMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716346471; c=relaxed/simple;
	bh=SGPWiLNCoUlv9CACDeTfh9zUbnyFLWgv6o/PSrH36KI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aiq34e0C30x577wL8tGAwMAKOPLMnmziMGRq/dB587CGxsiduAYiuajr5OQCvLI9FhBalZsBDWKhtOhSKmhYcitSZI1jY+QpjoPk5lk/D6of7tuyz7+EoReG+QuGj1npwVYmp/cUB/sSBdn4vekS31GOxTttS1MyUarKYa9Z3cg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Fa3UmEby; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fa3UmEby"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B23E2C2BD11;
	Wed, 22 May 2024 02:54:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716346470;
	bh=SGPWiLNCoUlv9CACDeTfh9zUbnyFLWgv6o/PSrH36KI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Fa3UmEbytT0sizPfEBvSbmQVToYdWqv4GBd9xuf5Sp2SKyhpZuwABmEvswSgSp5RD
	 XfprjGcXJePIovu6caGq7lxxcN849LCrehLmjx/lqIyzNz9DbAZ/OG7PwuuW5PlSbe
	 XVcwK9KlLR6iq23DOmNxM2PG1iJzWaD7CbvsYOngUylKt5tJgII1xMAdvTgtri/4uD
	 7NmyZArrbgCzY0pnVUHPmvxNog9ZGnm/um1CRmSe68wvg1KocmmNc6P5l3rqkMcox3
	 cfYaLaHNLrZrndBpbMG9wfgUqlaG7CSBkrZV2w7d1qWN5LfL5JTn4jyvrKSWQ/qmox
	 W5mQce6p0bLKA==
Date: Tue, 21 May 2024 19:54:30 -0700
Subject: [PATCH 022/111] xfs: report inode corruption errors to the health
 system
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171634532041.2478931.17194737484944376491.stgit@frogsfrogsfrogs>
In-Reply-To: <171634531590.2478931.8474978645585392776.stgit@frogsfrogsfrogs>
References: <171634531590.2478931.8474978645585392776.stgit@frogsfrogsfrogs>
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

