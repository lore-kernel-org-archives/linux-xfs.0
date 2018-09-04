Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:65144 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725992AbeIDMxI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Sep 2018 08:53:08 -0400
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1fx6hn-0001wy-Uq
        for linux-xfs@vger.kernel.org; Tue, 04 Sep 2018 18:29:00 +1000
Received: from dave by discord.disaster.area with local (Exim 4.91)
        (envelope-from <david@fromorbit.com>)
        id 1fx6hn-0000jb-TY
        for linux-xfs@vger.kernel.org; Tue, 04 Sep 2018 18:28:59 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/2] mkfs: stop zeroing old superblocks excessively
Date: Tue,  4 Sep 2018 18:28:56 +1000
Message-Id: <20180904082857.2180-2-david@fromorbit.com>
In-Reply-To: <20180904082857.2180-1-david@fromorbit.com>
References: <20180904082857.2180-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

When making a new filesystem, don't zero superblocks way beyond the
end of the new filesystem. If the old filesystem was an EB scale
filesytsem, then this zeroing requires millions of IOs to complete.
We don't want to do this if the new filesystem on the device is only
going to be 100TB. Sure, zeroing old superblocks a good distance
beyond the new size is a good idea, as is zeroing the ones in the
middle and end, but the other 7,999,000 superblocks? Not so much.

Make a sane cut-off decision - zero out to 10x the size of the new
filesystem, then zero the middle AGs in the old filesystem, then
zero the last ones.

The initial zeroing out to 10x the new fs size means that this code
will only ever trigger in rare corner cases outside a testing
environment - there are very few production workloads where a huge
block device is reused immediately and permanently for a tiny much
smaller filesystem. Those that do this (e.g. on thing provisioned
devices) discard the in use blocks anyway and so the zeroing won't
actually do anything useful.

Time to mkfs a 1TB filsystem on a big device after it held another
larger filesystem:

previous FS size	10PB	100PB	 1EB
old mkfs time		1.95s	8.9s	81.3s
patched			0.95s	1.2s	 1.2s


Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 mkfs/xfs_mkfs.c | 64 +++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 59 insertions(+), 5 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 2e53c1e83b6a..c153592c705e 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -1155,14 +1155,15 @@ validate_ag_geometry(
 
 static void
 zero_old_xfs_structures(
-	libxfs_init_t		*xi,
-	xfs_sb_t		*new_sb)
+	struct libxfs_xinit	*xi,
+	struct xfs_sb		*new_sb)
 {
-	void 			*buf;
-	xfs_sb_t 		sb;
+	void			*buf;
+	struct xfs_sb		sb;
 	uint32_t		bsize;
 	int			i;
 	xfs_off_t		off;
+	xfs_off_t		end;
 
 	/*
 	 * We open regular files with O_TRUNC|O_CREAT. Nothing to do here...
@@ -1220,15 +1221,68 @@ zero_old_xfs_structures(
 
 	/*
 	 * block size and basic geometry seems alright, zero the secondaries.
+	 *
+	 * Don't be insane when it comes to overwriting really large filesystems
+	 * as it could take millions of IOs to zero every secondary
+	 * superblock. If we are remaking a huge filesystem, then do the
+	 * zeroing, but if we are replacing it with a small one (typically done
+	 * in test environments, limit the zeroing to:
+	 *
+	 *	- around the range of the new filesystem
+	 *	- the middle of the old filesystem
+	 *	- the end of the old filesystem
+	 *
+	 * Killing the middle and end of the old filesystem will prevent repair
+	 * from finding it with it's fast secondary sb scan algorithm. The slow
+	 * scan algorithm will then confirm the small filesystem geometry by
+	 * brute force scans.
 	 */
 	memset(buf, 0, new_sb->sb_sectsize);
+
+	/* this carefully avoids integer overflows */
+	end = sb.sb_dblocks;
+	if (sb.sb_agcount > 10000 &&
+	    new_sb->sb_dblocks < end / 10)
+		end = new_sb->sb_dblocks * 10;
 	off = 0;
-	for (i = 1; i < sb.sb_agcount; i++)  {
+	for (i = 1; i < sb.sb_agcount && off < end; i++)  {
+		off += sb.sb_agblocks;
+		if (pwrite(xi->dfd, buf, new_sb->sb_sectsize,
+					off << sb.sb_blocklog) == -1)
+			break;
+	}
+
+	if (end == sb.sb_dblocks)
+		return;
+
+	/*
+	 * Trash the middle 1000 AGs of the old fs, which we know has at least
+	 * 10000 AGs at this point. Cast to make sure we are doing 64bit
+	 * multiplies, otherwise off gets truncated to 32 bit. I hate C.
+	 */
+	i = (sb.sb_agcount / 2) - 500;
+	off = (xfs_off_t)sb.sb_agblocks * i;
+	off = (xfs_off_t)sb.sb_agblocks * ((sb.sb_agcount / 2) - 500);
+	end = off + 1000 * sb.sb_agblocks;
+	while (off < end) {
+		if (pwrite(xi->dfd, buf, new_sb->sb_sectsize,
+					off << sb.sb_blocklog) == -1)
+			break;
 		off += sb.sb_agblocks;
+	}
+
+	/*
+	 * Trash the last 1000 AGs of the old fs
+	 */
+	off = (xfs_off_t)sb.sb_agblocks * (sb.sb_agcount - 1000);
+	end = sb.sb_dblocks;
+	while (off < end) {
 		if (pwrite(xi->dfd, buf, new_sb->sb_sectsize,
 					off << sb.sb_blocklog) == -1)
 			break;
+		off += sb.sb_agblocks;
 	}
+
 done:
 	free(buf);
 }
-- 
2.17.0
