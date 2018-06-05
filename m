Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:5837 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751223AbeFEGYb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Jun 2018 02:24:31 -0400
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1fQ5OM-00022R-Qi
        for linux-xfs@vger.kernel.org; Tue, 05 Jun 2018 16:24:26 +1000
Received: from dave by discord.disaster.area with local (Exim 4.91)
        (envelope-from <david@fromorbit.com>)
        id 1fQ5OM-0001JE-PV
        for linux-xfs@vger.kernel.org; Tue, 05 Jun 2018 16:24:26 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/6] xfs: verify extent size hint is valid in inode verifier
Date: Tue,  5 Jun 2018 16:24:19 +1000
Message-Id: <20180605062423.4877-3-david@fromorbit.com>
In-Reply-To: <20180605062423.4877-1-david@fromorbit.com>
References: <20180605062423.4877-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

There are rules for vald extent size hints. We enforce them when
applications set them, but fuzzers violate those rules and that
screws us over.

This results in alignment assertion failures when setting up
allocations such as this in direct IO:

XFS: Assertion failed: ap->length, file: fs/xfs/libxfs/xfs_bmap.c, line: 3432
....
Call Trace:
 xfs_bmap_btalloc+0x415/0x910
 xfs_bmapi_write+0x71c/0x12e0
 xfs_iomap_write_direct+0x2a9/0x420
 xfs_file_iomap_begin+0x4dc/0xa70
 iomap_apply+0x43/0x100
 iomap_file_buffered_write+0x62/0x90
 xfs_file_buffered_aio_write+0xba/0x300
 __vfs_write+0xd5/0x150
 vfs_write+0xb6/0x180
 ksys_write+0x45/0xa0
 do_syscall_64+0x5a/0x180
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

And from xfs_db:

core.extsize = 10380288

Which is not an integer multiple of the block size, and so violates
Rule #7 for setting extent size hints. Validate extent size hint
rules in the inode verifier to catch this.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_inode_buf.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index f5fff1ccb61d..be197c91307b 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -385,6 +385,7 @@ xfs_dinode_verify(
 	xfs_ino_t		ino,
 	struct xfs_dinode	*dip)
 {
+	xfs_failaddr_t		fa;
 	uint16_t		mode;
 	uint16_t		flags;
 	uint64_t		flags2;
@@ -501,6 +502,12 @@ xfs_dinode_verify(
 			return __this_address;
 	}
 
+	/* extent size hint validation */
+	fa = xfs_inode_validate_extsize(mp, be32_to_cpu(dip->di_extsize),
+					mode, be32_to_cpu(dip->di_flags));
+	if (fa)
+		return fa;
+
 	/* only version 3 or greater inodes are extensively verified here */
 	if (dip->di_version < 3)
 		return NULL;
-- 
2.17.0

