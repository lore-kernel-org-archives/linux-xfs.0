Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B35B71D53C
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:34:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711424049; cv=none; b=cyoypbDWLJ/0YpVvlL8RNrKrKdM+VLyqtgMiio5OQeaJNYSpcyqe+3Oa+apJCN1I5UfdkE+TOwqYkDCruG3ATeY+tYkpJeDyr3jOKeLljKBwcHfE164gvv0JzSqsFuMJUkA3LDzSPZibjWy2jb6l8mVtC9KR9f3mfEaD0zH++FI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711424049; c=relaxed/simple;
	bh=7JzKUnbMPKA/qZVLr3ZZS38s4+kicm61vWiENcLDzyA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=t5HLqS4xbILxfDfE0LoOvOJ100rLBZuqdnXG8sKsE3uvLgED3mejpJi7Yr4+jN3TKo1ndfOqCoQVuCYo1rQzzDy0TOw46+rrJCF1JxiMUzDjHJWQGN1bCKR7QUZ+8gP8fX+lrtzYUnsKFxCJAz0yM2zK51todK2U3cymphFLnfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ajrPCAKn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ajrPCAKn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DBE2C433F1;
	Tue, 26 Mar 2024 03:34:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711424049;
	bh=7JzKUnbMPKA/qZVLr3ZZS38s4+kicm61vWiENcLDzyA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ajrPCAKntX0sWY9HjhaqUrM1cj4SE/4oLvuR5FO9uSxCSFYH3HI/WapRmuQeJPrNy
	 3/Xmz0OQ0XyLZiP52Vk6VXrlkBVYfHW3HbfyXeiAF1bNI6HuI+J7sbq6zvifX8Grwr
	 ElcyCUZCqffX6bHjX4h18zIZkXRXPxHZcRcODv9iyrRzUmxrkxOR8jgdPJdN14tqn8
	 QXmvynXGWj3dPwYfyxTuht9zgQAyQtPspBSNYV/LS+S562D9luCYWJ5HnSWTd8fHKJ
	 hz710DLJJxYOfdQJDOGQPQxsoZIg5hO4rJJCQLCLEYAxr3lOKKU4Y0kuHnXpGE/L0j
	 C3PSm37Zf493g==
Date: Mon, 25 Mar 2024 20:34:08 -0700
Subject: [PATCH 022/110] xfs: report inode corruption errors to the health
 system
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171142131702.2215168.7790936500405501079.stgit@frogsfrogsfrogs>
In-Reply-To: <171142131228.2215168.2795743548791967397.stgit@frogsfrogsfrogs>
References: <171142131228.2215168.2795743548791967397.stgit@frogsfrogsfrogs>
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
index 6c326e84aab6..6d8847363433 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -736,3 +736,4 @@ void xfs_bmap_mark_sick(struct xfs_inode *ip, int whichfork) { }
 void xfs_btree_mark_sick(struct xfs_btree_cur *cur) { }
 void xfs_dirattr_mark_sick(struct xfs_inode *ip, int whichfork) { }
 void xfs_da_mark_sick(struct xfs_da_args *args) { }
+void xfs_inode_mark_sick(struct xfs_inode *ip, unsigned int mask) { }
diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index 92ca3d460e04..63922f44ffe7 100644
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
index fd351c252af0..83d936981166 100644
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
index 6d81757239bb..53ff8267803b 100644
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

