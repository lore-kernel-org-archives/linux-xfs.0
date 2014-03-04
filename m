Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 475A27F58
	for <xfs@oss.sgi.com>; Tue,  4 Mar 2014 02:52:19 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id DD1D38F8065
	for <xfs@oss.sgi.com>; Tue,  4 Mar 2014 00:52:18 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	9eLmmP7pUhmD4jRm for <xfs@oss.sgi.com>;
	Tue, 04 Mar 2014 00:52:17 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1WKl4w-0006HX-LR
	for xfs@oss.sgi.com; Tue, 04 Mar 2014 19:51:58 +1100
Received: from dave by disappointment with local (Exim 4.82)
	(envelope-from <dave@disappointment.disaster>) id 1WKl4w-0006ye-Ke
	for xfs@oss.sgi.com; Tue, 04 Mar 2014 19:51:58 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 04/13] libxfs: skip verification on initial "guess" superblock
	read
Date: Tue,  4 Mar 2014 19:51:48 +1100
Message-Id: <1393923117-9559-5-git-send-email-david@fromorbit.com>
In-Reply-To: <1393923117-9559-1-git-send-email-david@fromorbit.com>
References: <1393923117-9559-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

[userspace port]

When xfs_readsb() does the very first read of the superblock,
it makes a guess at the length of the buffer, based on the
sector size of the underlying storage.  This may or may
not match the filesystem sector size in sb_sectsize, so
we can't i.e. do a CRC check on it; it might be too short.

In fact, mounting a filesystem with sb_sectsize larger
than the device sector size will cause a mount failure
if CRCs are enabled, because we are checksumming a length
which exceeds the buffer passed to it.

So always read twice; the first time we read with NULL
buffer ops to skip verification; then set the proper
read length, hook up the proper verifier, and give it
another go.

Once we are sure that we've got the right buffer length,
we can also use bp->b_length in the xfs_sb_read_verify,
rather than the less-trusted on-disk sectorsize for
secondary superblocks.  Before this we ran the risk of
passing junk to the crc32c routines, which didn't always
handle extreme values.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 libxfs/xfs_sb.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index 5c10c97..6ad99a5 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -566,7 +566,7 @@ xfs_sb_read_verify(
 						XFS_SB_VERSION_5) ||
 	     dsb->sb_crc != 0)) {
 
-		if (!xfs_verify_cksum(bp->b_addr, be16_to_cpu(dsb->sb_sectsize),
+		if (!xfs_verify_cksum(bp->b_addr, BBTOB(bp->b_length),
 				      offsetof(struct xfs_sb, sb_crc))) {
 			/* Only fail bad secondaries on a known V5 filesystem */
 			if (bp->b_bn == XFS_SB_DADDR ||
@@ -599,7 +599,6 @@ xfs_sb_quiet_read_verify(
 {
 	struct xfs_dsb	*dsb = XFS_BUF_TO_SBP(bp);
 
-
 	if (dsb->sb_magicnum == cpu_to_be32(XFS_SB_MAGIC)) {
 		/* XFS filesystem, verify noisily! */
 		xfs_sb_read_verify(bp);
-- 
1.9.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
