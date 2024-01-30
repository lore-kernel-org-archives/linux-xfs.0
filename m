Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EE8337179
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 05:11:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706591479; cv=none; b=Bey0UfvGi3YPM8ovtWB4Nx7Hak72xRCIZyLdbj664iJVDYZWACPdS+ldyY7UrqHDheYBzcy+1yI0Hjkm8rSb3LsdK6+uL2IONf0Q+hEwtRVhKudka+UAnp0ZeS5t3SRVV96vtQfa+7GtpqbGJk7Kvd+f4v3ItdxgU2zIW+5z7NY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706591479; c=relaxed/simple;
	bh=r8GrGsQEklIWHyIR1Q0AGq1/TklQrNzFnILWUAozLZM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HMcJNCcXhIzH3kDVt3QQTc+eWU3qjLRHVxKbcQaugvDw8SZ9zMU/gMT3Mu6SDKYcuwAKlH4WThKxi5ASpC9qNAWqoYSMnsMf0ithqAn0Z3gmDKU/07Ff1+su72AFrFI8Pe7zsmuV7raAn4mJjyxpLnWiwVmlvsIQHX3jjfSBaaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gTDcq/DH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gTDcq/DH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D051C433F1;
	Tue, 30 Jan 2024 05:11:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706591479;
	bh=r8GrGsQEklIWHyIR1Q0AGq1/TklQrNzFnILWUAozLZM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=gTDcq/DHg+rxJwIdGWtZQCkgx2nDqqKEvdYDTkFPVHZh4nmLv6XDmTiK6HwXbduli
	 rKzHBAwXEGbYRF0swbE5aH8PSmX+vX04Cz24VM0djDnJzo9/ZXA2kt2kjHnbBVyo/7
	 5UQsHRgnCcEmCVQtc5Ice+rjD/xGMaIjbbkpZgakF10ZU4At5bajjXwhk9CPhfHopM
	 dxVbjsmN+Zui6pq/0o27HXWRkj9fFt5bmYhRr5ZOB9mv3fOeru2rbXNX5mN7eV4BzU
	 Wa1XoqYVCr+vDTpTbYYmugrvzOFCQbPsoaSG5VUEFqdlcWl7kwy/sPyPikdnqAx7k3
	 lBsrMchUd747Q==
Date: Mon, 29 Jan 2024 21:11:18 -0800
Subject: [PATCH 08/11] xfs: report inode corruption errors to the health
 system
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <170659063859.3353909.8168846642980979928.stgit@frogsfrogsfrogs>
In-Reply-To: <170659063695.3353909.12657412146136100266.stgit@frogsfrogsfrogs>
References: <170659063695.3353909.12657412146136100266.stgit@frogsfrogsfrogs>
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

Whenever we encounter corrupt inode records, we should report that to
the health monitoring system for later reporting.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_ialloc.c     |    1 +
 fs/xfs/libxfs/xfs_inode_buf.c  |   12 +++++++++---
 fs/xfs/libxfs/xfs_inode_fork.c |    8 ++++++++
 fs/xfs/xfs_icache.c            |    9 +++++++++
 fs/xfs/xfs_inode.c             |    2 ++
 5 files changed, 29 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 91584e96f05f6..56f82b8af07e8 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -2999,6 +2999,7 @@ xfs_ialloc_check_shrink(
 		goto out;
 
 	if (!has) {
+		xfs_ag_mark_sick(pag, XFS_SICK_AG_INOBT);
 		error = -EFSCORRUPTED;
 		goto out;
 	}
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 137a65bda95dc..1280d6acd1c1b 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -18,6 +18,7 @@
 #include "xfs_trans.h"
 #include "xfs_ialloc.h"
 #include "xfs_dir2.h"
+#include "xfs_health.h"
 
 #include <linux/iversion.h>
 
@@ -132,9 +133,14 @@ xfs_imap_to_bp(
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
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index f4569e18a8d0e..3e63567810e5b 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -25,6 +25,7 @@
 #include "xfs_attr_leaf.h"
 #include "xfs_types.h"
 #include "xfs_errortag.h"
+#include "xfs_health.h"
 
 struct kmem_cache *xfs_ifork_cache;
 
@@ -87,6 +88,7 @@ xfs_iformat_local(
 		xfs_inode_verifier_error(ip, -EFSCORRUPTED,
 				"xfs_iformat_local", dip, sizeof(*dip),
 				__this_address);
+		xfs_inode_mark_sick(ip, XFS_SICK_INO_CORE);
 		return -EFSCORRUPTED;
 	}
 
@@ -124,6 +126,7 @@ xfs_iformat_extents(
 		xfs_inode_verifier_error(ip, -EFSCORRUPTED,
 				"xfs_iformat_extents(1)", dip, sizeof(*dip),
 				__this_address);
+		xfs_inode_mark_sick(ip, XFS_SICK_INO_CORE);
 		return -EFSCORRUPTED;
 	}
 
@@ -143,6 +146,7 @@ xfs_iformat_extents(
 				xfs_inode_verifier_error(ip, -EFSCORRUPTED,
 						"xfs_iformat_extents(2)",
 						dp, sizeof(*dp), fa);
+				xfs_inode_mark_sick(ip, XFS_SICK_INO_CORE);
 				return xfs_bmap_complain_bad_rec(ip, whichfork,
 						fa, &new);
 			}
@@ -201,6 +205,7 @@ xfs_iformat_btree(
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
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index dba514a2c84d9..f6a9c4f40cfd0 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -24,6 +24,7 @@
 #include "xfs_ialloc.h"
 #include "xfs_ag.h"
 #include "xfs_log_priv.h"
+#include "xfs_health.h"
 
 #include <linux/iversion.h>
 
@@ -415,6 +416,9 @@ xfs_iget_check_free_state(
 			xfs_warn(ip->i_mount,
 "Corruption detected! Free inode 0x%llx not marked free! (mode 0x%x)",
 				ip->i_ino, VFS_I(ip)->i_mode);
+			xfs_agno_mark_sick(ip->i_mount,
+					XFS_INO_TO_AGNO(ip->i_mount, ip->i_ino),
+					XFS_SICK_AG_INOBT);
 			return -EFSCORRUPTED;
 		}
 
@@ -422,6 +426,9 @@ xfs_iget_check_free_state(
 			xfs_warn(ip->i_mount,
 "Corruption detected! Free inode 0x%llx has blocks allocated!",
 				ip->i_ino);
+			xfs_agno_mark_sick(ip->i_mount,
+					XFS_INO_TO_AGNO(ip->i_mount, ip->i_ino),
+					XFS_SICK_AG_INOBT);
 			return -EFSCORRUPTED;
 		}
 		return 0;
@@ -640,6 +647,8 @@ xfs_iget_cache_miss(
 				xfs_buf_offset(bp, ip->i_imap.im_boffset));
 		if (!error)
 			xfs_buf_set_ref(bp, XFS_INO_REF);
+		else
+			xfs_inode_mark_sick(ip, XFS_SICK_INO_CORE);
 		xfs_trans_brelse(tp, bp);
 
 		if (error)
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 8dabe9e12f796..6412b558edf08 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3435,6 +3435,8 @@ xfs_iflush(
 
 	/* generate the checksum. */
 	xfs_dinode_calc_crc(mp, dip);
+	if (error)
+		xfs_inode_mark_sick(ip, XFS_SICK_INO_CORE);
 	return error;
 }
 

