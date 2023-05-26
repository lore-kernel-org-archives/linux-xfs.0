Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0587BC77B7A
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 01:02:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231990AbjEZBCS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 21:02:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbjEZBCR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 21:02:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 096F212E
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 18:02:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 92DCA64B7B
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 01:02:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01F11C433EF;
        Fri, 26 May 2023 01:02:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685062935;
        bh=UvRrSaeXhgqi2Z5ibb2MT6tVtpiha5U3ZhBz0jjhJs0=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=D4TSTZHsRNrVGfVwStc42y5ROG0+XEyK/KpPUNz+237HF6+ifFSwt/4ETFIE3vHrC
         T4UVSeSe5yTN5W3s4C9cx/9z6wy5w2L6lldEC+sDppUmixwUIMekbaScmy32Nb9pIg
         IxqSWAsKLZis6dZSNnu42864D/mqmlls6Kh7X3QT62BfarD6V577bGaTQ4eHrc7fXW
         I+/cW40M34OcTk0hBU7P6T/BNWu/S/WQ1FLcPDZDcxPLdydfahUdchuPZCRVxfELom
         BluoUe/ApC5AShwuC/Lkr2qTtexjL7nFaADdr5K13FPjy3bHL4NRFrb1VSVfrrJhd7
         udYpxYyEKI9EQ==
Date:   Thu, 25 May 2023 18:02:14 -0700
Subject: [PATCH 08/11] xfs: report inode corruption errors to the health
 system
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506060792.3732173.5491890806325147743.stgit@frogsfrogsfrogs>
In-Reply-To: <168506060658.3732173.4915476844741652700.stgit@frogsfrogsfrogs>
References: <168506060658.3732173.4915476844741652700.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

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
index 60db196cc8f7..bcb4af9cfea9 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -3002,6 +3002,7 @@ xfs_ialloc_check_shrink(
 		goto out;
 
 	if (!has) {
+		xfs_ag_mark_sick(pag, XFS_SICK_AG_INOBT);
 		error = -EFSCORRUPTED;
 		goto out;
 	}
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 758aacd8166b..992ce2d5b9d0 100644
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
index 2390884e0075..f32f02c414ac 100644
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
index 0048a8b290bc..402f4b22de56 100644
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
@@ -619,6 +626,8 @@ xfs_iget_cache_miss(
 				xfs_buf_offset(bp, ip->i_imap.im_boffset));
 		if (!error)
 			xfs_buf_set_ref(bp, XFS_INO_REF);
+		else
+			xfs_inode_mark_sick(ip, XFS_SICK_INO_CORE);
 		xfs_trans_brelse(tp, bp);
 
 		if (error)
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 6e5e2bf8e8ac..70506b1ed022 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3338,6 +3338,8 @@ xfs_iflush(
 
 	/* generate the checksum. */
 	xfs_dinode_calc_crc(mp, dip);
+	if (error)
+		xfs_inode_mark_sick(ip, XFS_SICK_INO_CORE);
 	return error;
 }
 

