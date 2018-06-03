Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail01.adl6.internode.on.net ([150.101.137.136]:49927 "EHLO
        ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751132AbeFCXDo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 3 Jun 2018 19:03:44 -0400
Date: Mon, 4 Jun 2018 09:03:41 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: NULL pointer dereference in xfs_bmap_extents_to_btree() when
 mounting and operating a crafted image
Message-ID: <20180603230341.GV10363@dastard>
References: <CANrHXgzLvaud2HEv3jAFGTfn5S80d7Rwj-ztJNWPT8eyFTohMg@mail.gmail.com>
 <20180603223435.GU10363@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180603223435.GU10363@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Wen Xu <xuwen.sjtu@gmail.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Jun 04, 2018 at 08:34:35AM +1000, Dave Chinner wrote:
> On Sun, Jun 03, 2018 at 06:19:54PM -0400, Wen Xu wrote:
> > Hi XFS developers and maintainers,
> > Please check: https://bugzilla.kernel.org/show_bug.cgi?id=199915
> 
> Please report bugs straight to this list - it's much easier to
> track and faster to discuss bugs through email than it is through
> bugzilla.

Image log size is too small for the filesystem config. If this was
a v5 filesystem, then the image would refuse to mount right there.

As it is, a CONFIG_XFS_DEBUG=y kernel assert fails at mount in
xfs_check_agi_unlinked().

#ifdef DEBUG
STATIC void
xfs_check_agi_unlinked(
        struct xfs_agi          *agi)
{
        int                     i;

        for (i = 0; i < XFS_AGI_UNLINKED_BUCKETS; i++)
                ASSERT(agi->agi_unlinked[i]);
}
#else
#define xfs_check_agi_unlinked(agi)
#endif

With the patch below, the image fails to mount with an error:

[   89.695774] XFS (loop0): Mounting V4 Filesystem
[   89.696941] XFS (loop0): Log size 864 blocks too small, minimum size is 942 blocks
[   89.698603] XFS (loop0): Log size out of supported range.
[   89.699833] XFS (loop0): Continuing onwards, but if log hangs are experienced then please report this message in the bug report.
[   89.703651] XFS (loop0): Metadata corruption detected at xfs_agi_verify+0x153/0x170, xfs_agi block 0x2
[   89.705349] XFS (loop0): Unmount and run xfs_repair
[   89.706179] XFS (loop0): First 128 bytes of corrupted metadata buffer:
[   89.707317] 00000000bef77f4d: 58 41 47 49 00 00 00 01 00 00 00 00 00 00 10 00  XAGI............
[   89.708824] 000000003cd6f10c: 00 00 00 40 00 00 00 03 00 00 00 01 00 00 00 00  ...@............
[   89.710309] 000000002ec75c4c: 00 00 00 00 00 00 00 00 00 00 00 ff ff ff ff ff  ................
[   89.711749] 00000000d83fa14d: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  ................
[   89.713127] 00000000c41242dd: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  ................
[   89.714484] 000000006c41c134: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  ................
[   89.715841] 00000000b8f9ac70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  ................
[   89.717145] 000000005258d181: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff 00  ................
[   89.718444] XFS (loop0): metadata I/O error in "xfs_trans_read_buf_map" at daddr 0x2 len 1 error 117
[   89.719834] XFS (loop0): xfs_imap_lookup: xfs_ialloc_read_agi() returned error -117, agno 0
[   89.721099] XFS (loop0): failed to read root inode

Please rework the test image so that it mounts cleanly without
warnings or shutdowns with the patch below and then retest the POC
code.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

xfs: verify AGI unlinked list contains valid blocks

From: Dave Chinner <dchinner@redhat.com>

The heads of tha AGI unlinked list are only scanned on debug
kernels when the verifier runs. Change that to always scan the heads
and validate that the inode numbers are valid.

Signed-off-by: Dave Chinner <dchinner@redhat.com>

---
 fs/xfs/libxfs/xfs_ialloc.c | 23 ++++++++---------------
 1 file changed, 8 insertions(+), 15 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 1ef6ff2ca002..ec5ea02b5553 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -2465,26 +2465,13 @@ xfs_ialloc_log_agi(
 	}
 }
 
-#ifdef DEBUG
-STATIC void
-xfs_check_agi_unlinked(
-	struct xfs_agi		*agi)
-{
-	int			i;
-
-	for (i = 0; i < XFS_AGI_UNLINKED_BUCKETS; i++)
-		ASSERT(agi->agi_unlinked[i]);
-}
-#else
-#define xfs_check_agi_unlinked(agi)
-#endif
-
 static xfs_failaddr_t
 xfs_agi_verify(
 	struct xfs_buf	*bp)
 {
 	struct xfs_mount *mp = bp->b_target->bt_mount;
 	struct xfs_agi	*agi = XFS_BUF_TO_AGI(bp);
+	int		i;
 
 	if (xfs_sb_version_hascrc(&mp->m_sb)) {
 		if (!uuid_equal(&agi->agi_uuid, &mp->m_sb.sb_meta_uuid))
@@ -2520,7 +2507,13 @@ xfs_agi_verify(
 	if (bp->b_pag && be32_to_cpu(agi->agi_seqno) != bp->b_pag->pag_agno)
 		return __this_address;
 
-	xfs_check_agi_unlinked(agi);
+	for (i = 0; i < XFS_AGI_UNLINKED_BUCKETS; i++) {
+		if (agi->agi_unlinked[i] == NULLAGINO)
+			continue;
+		if (!xfs_verify_ino(mp, be32_to_cpu(agi->agi_unlinked[i])))
+			return __this_address;
+	}
+
 	return NULL;
 }
 
