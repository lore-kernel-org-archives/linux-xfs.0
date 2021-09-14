Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD3F0C433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Sep 2021 02:42:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AD3B8610F9
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Sep 2021 02:42:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236205AbhINCno (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 13 Sep 2021 22:43:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:53670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235706AbhINCno (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 13 Sep 2021 22:43:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C3EA4610D1;
        Tue, 14 Sep 2021 02:42:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631587347;
        bh=88kMTTtqTBBJhjS5KThb3f1QRpQlsBZCiQ74xdy3TIw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=fmWG4kZLo1UMEKl0sz7NS/fxW8S+kyv9fXQBeFFmHAHGMPC86jykjG4mQed1GiDP+
         6SkfBhy2fXOqrI+yZSZYrVGThkC/kNLGFKzJ7rckPMvBrM9JB9Pi5kPwEL+neLOAGg
         HkLi6oMKj+VwqTizYk3gL2rkn1X9+XZgpv82+rhx0PM0pEKU9ObfmFrEf0LxSt6ES4
         CqFqbXqaQacbIwiENyvSItX9Yjte6NydCkC3AkGKtb+1O2/v3sCVINikarME7vDRCA
         rv3moyF/LGGcr2szYIq/cbmAVN5VBze9PqGhqHkdAhZjvbFB9uTkmk+r6Nj9jxgphz
         KiNlXQBGBfxqA==
Subject: [PATCH 27/43] xfs: replace XFS_FORCED_SHUTDOWN with xfs_is_shutdown
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Date:   Mon, 13 Sep 2021 19:42:27 -0700
Message-ID: <163158734752.1604118.2557899186280810389.stgit@magnolia>
In-Reply-To: <163158719952.1604118.14415288328687941574.stgit@magnolia>
References: <163158719952.1604118.14415288328687941574.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Source kernel commit: 75c8c50fa16a23f8ac89ea74834ae8ddd1558d75

Remove the shouty macro and instead use the inline function that
matches other state/feature check wrapper naming. This conversion
was done with sed.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 include/xfs_mount.h  |    1 +
 libxfs/libxfs_priv.h |    1 -
 libxfs/xfs_alloc.c   |    2 +-
 libxfs/xfs_attr.c    |    4 ++--
 libxfs/xfs_bmap.c    |   16 ++++++++--------
 libxfs/xfs_btree.c   |    2 +-
 libxfs/xfs_ialloc.c  |    6 +++---
 7 files changed, 16 insertions(+), 16 deletions(-)


diff --git a/include/xfs_mount.h b/include/xfs_mount.h
index 0f7b9787..29d0440e 100644
--- a/include/xfs_mount.h
+++ b/include/xfs_mount.h
@@ -242,6 +242,7 @@ static inline bool xfs_is_ ## name (struct xfs_mount *mp) \
 	return false; \
 }
 __XFS_UNSUPP_OPSTATE(readonly)
+__XFS_UNSUPP_OPSTATE(shutdown)
 
 #define LIBXFS_MOUNT_DEBUGGER		0x0001
 #define LIBXFS_MOUNT_32BITINODES	0x0002
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 07fc2942..3e5ff2a8 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -161,7 +161,6 @@ enum ce { CE_DEBUG, CE_CONT, CE_NOTE, CE_WARN, CE_ALERT, CE_PANIC };
 	(unlikely(expr) ? XFS_WARN_CORRUPT((mp), (expr)) : false)
 
 #define XFS_ERRLEVEL_LOW		1
-#define XFS_FORCED_SHUTDOWN(mp)		0
 #define XFS_ILOCK_EXCL			0
 #define XFS_STATS_INC(mp, count)	do { (mp) = (mp); } while (0)
 #define XFS_STATS_DEC(mp, count, x)	do { (mp) = (mp); } while (0)
diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index 163c726f..c6159743 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -3075,7 +3075,7 @@ xfs_alloc_read_agf(
 			atomic64_add(allocbt_blks, &mp->m_allocbt_blks);
 	}
 #ifdef DEBUG
-	else if (!XFS_FORCED_SHUTDOWN(mp)) {
+	else if (!xfs_is_shutdown(mp)) {
 		ASSERT(pag->pagf_freeblks == be32_to_cpu(agf->agf_freeblks));
 		ASSERT(pag->pagf_btreeblks == be32_to_cpu(agf->agf_btreeblks));
 		ASSERT(pag->pagf_flcount == be32_to_cpu(agf->agf_flcount));
diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 3a712e36..00f3ecb5 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -146,7 +146,7 @@ xfs_attr_get(
 
 	XFS_STATS_INC(args->dp->i_mount, xs_attr_get);
 
-	if (XFS_FORCED_SHUTDOWN(args->dp->i_mount))
+	if (xfs_is_shutdown(args->dp->i_mount))
 		return -EIO;
 
 	args->geo = args->dp->i_mount->m_attr_geo;
@@ -710,7 +710,7 @@ xfs_attr_set(
 	int			rmt_blks = 0;
 	unsigned int		total;
 
-	if (XFS_FORCED_SHUTDOWN(dp->i_mount))
+	if (xfs_is_shutdown(dp->i_mount))
 		return -EIO;
 
 	error = xfs_qm_dqattach(dp);
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index bea9340a..1735717c 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -3931,7 +3931,7 @@ xfs_bmapi_read(
 	    XFS_TEST_ERROR(false, mp, XFS_ERRTAG_BMAPIFORMAT))
 		return -EFSCORRUPTED;
 
-	if (XFS_FORCED_SHUTDOWN(mp))
+	if (xfs_is_shutdown(mp))
 		return -EIO;
 
 	XFS_STATS_INC(mp, xs_blk_mapr);
@@ -4413,7 +4413,7 @@ xfs_bmapi_write(
 		return -EFSCORRUPTED;
 	}
 
-	if (XFS_FORCED_SHUTDOWN(mp))
+	if (xfs_is_shutdown(mp))
 		return -EIO;
 
 	XFS_STATS_INC(mp, xs_blk_mapw);
@@ -4696,7 +4696,7 @@ xfs_bmapi_remap(
 		return -EFSCORRUPTED;
 	}
 
-	if (XFS_FORCED_SHUTDOWN(mp))
+	if (xfs_is_shutdown(mp))
 		return -EIO;
 
 	error = xfs_iread_extents(tp, ip, whichfork);
@@ -5354,7 +5354,7 @@ __xfs_bunmapi(
 	ifp = XFS_IFORK_PTR(ip, whichfork);
 	if (XFS_IS_CORRUPT(mp, !xfs_ifork_has_extents(ifp)))
 		return -EFSCORRUPTED;
-	if (XFS_FORCED_SHUTDOWN(mp))
+	if (xfs_is_shutdown(mp))
 		return -EIO;
 
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
@@ -5845,7 +5845,7 @@ xfs_bmap_collapse_extents(
 		return -EFSCORRUPTED;
 	}
 
-	if (XFS_FORCED_SHUTDOWN(mp))
+	if (xfs_is_shutdown(mp))
 		return -EIO;
 
 	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL | XFS_ILOCK_EXCL));
@@ -5923,7 +5923,7 @@ xfs_bmap_can_insert_extents(
 
 	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL));
 
-	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
+	if (xfs_is_shutdown(ip->i_mount))
 		return -EIO;
 
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
@@ -5960,7 +5960,7 @@ xfs_bmap_insert_extents(
 		return -EFSCORRUPTED;
 	}
 
-	if (XFS_FORCED_SHUTDOWN(mp))
+	if (xfs_is_shutdown(mp))
 		return -EIO;
 
 	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL | XFS_ILOCK_EXCL));
@@ -6063,7 +6063,7 @@ xfs_bmap_split_extent(
 		return -EFSCORRUPTED;
 	}
 
-	if (XFS_FORCED_SHUTDOWN(mp))
+	if (xfs_is_shutdown(mp))
 		return -EIO;
 
 	/* Read in all the extents */
diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index 79be19ec..da3895a6 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -371,7 +371,7 @@ xfs_btree_del_cursor(
 	}
 
 	ASSERT(cur->bc_btnum != XFS_BTNUM_BMAP || cur->bc_ino.allocated == 0 ||
-	       XFS_FORCED_SHUTDOWN(cur->bc_mp));
+	       xfs_is_shutdown(cur->bc_mp));
 	if (unlikely(cur->bc_flags & XFS_BTREE_STAGING))
 		kmem_free(cur->bc_ops);
 	if (!(cur->bc_flags & XFS_BTREE_LONG_PTRS) && cur->bc_ag.pag)
diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index 4075ff5a..7ba6b5e9 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -236,7 +236,7 @@ xfs_check_agi_freecount(
 			}
 		} while (i == 1);
 
-		if (!XFS_FORCED_SHUTDOWN(cur->bc_mp))
+		if (!xfs_is_shutdown(cur->bc_mp))
 			ASSERT(freecount == cur->bc_ag.pag->pagi_freecount);
 	}
 	return 0;
@@ -1779,7 +1779,7 @@ xfs_dialloc(
 				break;
 		}
 
-		if (XFS_FORCED_SHUTDOWN(mp)) {
+		if (xfs_is_shutdown(mp)) {
 			error = -EFSCORRUPTED;
 			break;
 		}
@@ -2619,7 +2619,7 @@ xfs_ialloc_read_agi(
 	 * we are in the middle of a forced shutdown.
 	 */
 	ASSERT(pag->pagi_freecount == be32_to_cpu(agi->agi_freecount) ||
-		XFS_FORCED_SHUTDOWN(mp));
+		xfs_is_shutdown(mp));
 	return 0;
 }
 

