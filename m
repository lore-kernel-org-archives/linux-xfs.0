Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58188 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753141AbdDSUzs (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 19 Apr 2017 16:55:48 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A0FD92E604D
        for <linux-xfs@vger.kernel.org>; Wed, 19 Apr 2017 20:55:47 +0000 (UTC)
Received: from Liberator.local (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3B67560F88
        for <linux-xfs@vger.kernel.org>; Wed, 19 Apr 2017 20:55:47 +0000 (UTC)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfs: more do_div cleanups
Message-ID: <a366521f-769b-7453-2f47-8dbaa69eab7b@redhat.com>
Date: Wed, 19 Apr 2017 15:55:49 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

On some architectures do_div does the pointer compare
trick to make sure that we've sent it an unsigned 64-bit
number.  (Why unsigned?  I don't know.)

Fix up the few places that squawk about this; in 
xfs_bmap_wants_extents() we just used a bare int64_t so change
that to unsigned.

In xfs_adjust_extent_unmap_boundaries() all we wanted was the
mod, and we have an xfs-specific function to handle that w/o
side effects, which includes proper casting for do_div.

In xfs_daddr_to_ag[b]no, we were using the wrong type anyway;
XFS_BB_TO_FSBT returns a block in the filesystem, so use
xfs_rfsblock_t not xfs_daddr_t, and gain the unsignedness
from that type as a bonus.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Lightly tested via cross-compile to parisc as well as
(incomplete) xfstests testing.


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index bfc00de..fce43fb 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4856,7 +4856,7 @@ static inline bool xfs_bmap_wants_extents(struct xfs_inode *ip, int whichfork)
 	ASSERT(got_endoff >= del_endoff);
 
 	if (isrt) {
-		int64_t rtexts = XFS_FSB_TO_B(mp, del->br_blockcount);
+		uint64_t rtexts = XFS_FSB_TO_B(mp, del->br_blockcount);
 
 		do_div(rtexts, mp->m_sb.sb_rextsize);
 		xfs_mod_frextents(mp, rtexts);
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index c141791..5c9e3d6 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1222,11 +1222,8 @@
 		return error;
 
 	if (nimap && imap.br_startblock != HOLESTARTBLOCK) {
-		xfs_daddr_t	block;
-
 		ASSERT(imap.br_startblock != DELAYSTARTBLOCK);
-		block = imap.br_startblock;
-		mod = do_div(block, mp->m_sb.sb_rextsize);
+		mod = do_mod(imap.br_startblock, mp->m_sb.sb_rextsize);
 		if (mod)
 			*startoffset_fsb += mp->m_sb.sb_rextsize - mod;
 	}
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 7f351f7..dea4e2b 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -311,7 +311,7 @@ void xfs_do_force_shutdown(struct xfs_mount *mp, int flags, char *fname,
 static inline xfs_agnumber_t
 xfs_daddr_to_agno(struct xfs_mount *mp, xfs_daddr_t d)
 {
-	xfs_daddr_t ld = XFS_BB_TO_FSBT(mp, d);
+	xfs_rfsblock_t ld = XFS_BB_TO_FSBT(mp, d);
 	do_div(ld, mp->m_sb.sb_agblocks);
 	return (xfs_agnumber_t) ld;
 }
@@ -319,7 +319,7 @@ void xfs_do_force_shutdown(struct xfs_mount *mp, int flags, char *fname,
 static inline xfs_agblock_t
 xfs_daddr_to_agbno(struct xfs_mount *mp, xfs_daddr_t d)
 {
-	xfs_daddr_t ld = XFS_BB_TO_FSBT(mp, d);
+	xfs_rfsblock_t ld = XFS_BB_TO_FSBT(mp, d);
 	return (xfs_agblock_t) do_div(ld, mp->m_sb.sb_agblocks);
 }
 

