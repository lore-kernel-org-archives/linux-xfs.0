Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pB1BTTh0261291 for <xfs@oss.sgi.com>; Thu, 1 Dec 2011 05:29:30 -0600
Received: from ipmail05.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 92A4A162F678
	for <xfs@oss.sgi.com>; Thu,  1 Dec 2011 03:29:27 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	Iz35GpL63tmieDat for <xfs@oss.sgi.com>;
	Thu, 01 Dec 2011 03:29:27 -0800 (PST)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1RW4kX-0007G3-2c
	for xfs@oss.sgi.com; Thu, 01 Dec 2011 22:24:21 +1100
Received: from dave by disappointment with local (Exim 4.76)
	(envelope-from <dave@disappointment.disaster>) id 1RW4kW-00086C-Ho
	for xfs@oss.sgi.com; Thu, 01 Dec 2011 22:24:20 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfs: fix allocation length overflow in xfs_bmapi_write()
Date: Thu,  1 Dec 2011 22:24:20 +1100
Message-Id: <1322738660-31102-1-git-send-email-david@fromorbit.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

When testing the new xfstests --large-fs option that does very large
file preallocations, this assert was tripped deep in
xfs_alloc_vextent():

XFS: Assertion failed: args->minlen <= args->maxlen, file: fs/xfs/xfs_alloc.c, line: 2239

The allocation was trying to allocate a zero length extent because
the lower 32 bits of the allocation length was zero. The remaining
length of the allocation to be done was an exact multiple of 2^32 -
the first case I saw was at 496TB remaining to be allocated.

This turns out to be an overflow when converting the allocation
length (a 64 bit quantity) into the extent length to allocate (a 32
bit quantity), and it requires the length to be allocated an exact
multiple of 2^32 blocks to trip the assert.

Fix it by limiting the extent lenth to allocate to MAXEXTLEN.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_bmap.c |   20 +++++++++++++++++++-
 1 files changed, 19 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/xfs_bmap.c b/fs/xfs/xfs_bmap.c
index c68baeb..8d93823 100644
--- a/fs/xfs/xfs_bmap.c
+++ b/fs/xfs/xfs_bmap.c
@@ -2383,6 +2383,8 @@ xfs_bmap_btalloc(
 	int		tryagain;
 	int		error;
 
+	ASSERT(ap->length);
+
 	mp = ap->ip->i_mount;
 	align = ap->userdata ? xfs_get_extsz_hint(ap->ip) : 0;
 	if (unlikely(align)) {
@@ -4629,6 +4631,8 @@ xfs_bmapi_allocate(
 	int			error;
 	int			rt;
 
+	ASSERT(bma->length > 0);
+
 	rt = (whichfork == XFS_DATA_FORK) && XFS_IS_REALTIME_INODE(bma->ip);
 
 	/*
@@ -4849,6 +4853,7 @@ xfs_bmapi_write(
 	ASSERT(*nmap <= XFS_BMAP_MAX_NMAP);
 	ASSERT(!(flags & XFS_BMAPI_IGSTATE));
 	ASSERT(tp != NULL);
+	ASSERT(len > 0);
 
 	whichfork = (flags & XFS_BMAPI_ATTRFORK) ?
 		XFS_ATTR_FORK : XFS_DATA_FORK;
@@ -4918,9 +4923,22 @@ xfs_bmapi_write(
 			bma.eof = eof;
 			bma.conv = !!(flags & XFS_BMAPI_CONVERT);
 			bma.wasdel = wasdelay;
-			bma.length = len;
 			bma.offset = bno;
 
+			/*
+			 * There's a 32/64 bit type mismatch between the
+			 * allocation length request (which can be 64 bits in
+			 * length) and the bma length request, which is
+			 * xfs_extlen_t and therefore 32 bits. Hence we have to
+			 * check for 32-bit overflows and handle them here. 
+			 */
+			if (len > (xfs_filblks_t)MAXEXTLEN)
+				bma.length = MAXEXTLEN;
+			else
+				bma.length = len;
+
+			ASSERT(len > 0);
+			ASSERT(bma.length > 0);
 			error = xfs_bmapi_allocate(&bma, flags);
 			if (error)
 				goto error0;
-- 
1.7.5.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
