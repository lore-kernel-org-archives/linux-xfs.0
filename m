Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C273BA22
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:11:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nK+KhKBX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E131BC433C8;
	Sun, 31 Dec 2023 20:11:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704053504;
	bh=OgtaGJDo29r5oLu3V/Tj0gOhysFlErEafgMHwcmKYnQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=nK+KhKBXaFSRfrCqNmbJ9eNGA2wX20ACskMEf5leKHgKICHJMZBWFjIf6Y4UI9wqH
	 hziBqPoZ8WwqqzvpPqZq89j19BTDv/zhPzJVlc6MSOsqom6x+RWeQgIlpTARTxXMjA
	 vGFSJQrv/cB44dZj/e9g6kDWwb9Ov7Mps2TQ8NniN/fGBQOYx1fQNG2CwooYXora78
	 MKqZSncxNDHrMdcjwtlO8LWxQp42LabR9szcUC6URWIZ7hO3L68ii0u9G0M8H1cWbg
	 8fq90lxUREM8MVFP55MVRfXMXFnXNZsq8A2f7Er7A5sPx04EkNYNQjagG0xwZQ/Vov
	 1iT4isTiEh0uQ==
Date: Sun, 31 Dec 2023 12:11:44 -0800
Subject: [PATCH 08/11] xfs: report inode corruption errors to the health
 system
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404828410.1748329.12890166621662444693.stgit@frogsfrogsfrogs>
In-Reply-To: <170404828253.1748329.6550106654194720629.stgit@frogsfrogsfrogs>
References: <170404828253.1748329.6550106654194720629.stgit@frogsfrogsfrogs>
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
index b86d57589f67e..88aff6b0bda02 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -25,6 +25,7 @@
 #include "xfs_attr_leaf.h"
 #include "xfs_types.h"
 #include "xfs_errortag.h"
+#include "xfs_health.h"
 
 struct kmem_cache *xfs_ifork_cache;
 
@@ -84,6 +85,7 @@ xfs_iformat_local(
 		xfs_inode_verifier_error(ip, -EFSCORRUPTED,
 				"xfs_iformat_local", dip, sizeof(*dip),
 				__this_address);
+		xfs_inode_mark_sick(ip, XFS_SICK_INO_CORE);
 		return -EFSCORRUPTED;
 	}
 
@@ -121,6 +123,7 @@ xfs_iformat_extents(
 		xfs_inode_verifier_error(ip, -EFSCORRUPTED,
 				"xfs_iformat_extents(1)", dip, sizeof(*dip),
 				__this_address);
+		xfs_inode_mark_sick(ip, XFS_SICK_INO_CORE);
 		return -EFSCORRUPTED;
 	}
 
@@ -140,6 +143,7 @@ xfs_iformat_extents(
 				xfs_inode_verifier_error(ip, -EFSCORRUPTED,
 						"xfs_iformat_extents(2)",
 						dp, sizeof(*dp), fa);
+				xfs_inode_mark_sick(ip, XFS_SICK_INO_CORE);
 				return xfs_bmap_complain_bad_rec(ip, whichfork,
 						fa, &new);
 			}
@@ -198,6 +202,7 @@ xfs_iformat_btree(
 		xfs_inode_verifier_error(ip, -EFSCORRUPTED,
 				"xfs_iformat_btree", dfp, size,
 				__this_address);
+		xfs_inode_mark_sick(ip, XFS_SICK_INO_CORE);
 		return -EFSCORRUPTED;
 	}
 
@@ -262,12 +267,14 @@ xfs_iformat_data_fork(
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
@@ -340,6 +347,7 @@ xfs_iformat_attr_fork(
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
index 0ba41fa29e9e7..6db00c5097ec0 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3435,6 +3435,8 @@ xfs_iflush(
 
 	/* generate the checksum. */
 	xfs_dinode_calc_crc(mp, dip);
+	if (error)
+		xfs_inode_mark_sick(ip, XFS_SICK_INO_CORE);
 	return error;
 }
 

