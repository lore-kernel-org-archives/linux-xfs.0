Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA7AUddN053651 for <xfs@oss.sgi.com>; Mon, 7 Nov 2011 04:30:40 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 362E4101E25B
	for <xfs@oss.sgi.com>; Mon,  7 Nov 2011 02:30:37 -0800 (PST)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	OmHtYEpLHU7wAq9i for <xfs@oss.sgi.com>;
	Mon, 07 Nov 2011 02:30:37 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1RNMTN-0005MY-E9
	for xfs@oss.sgi.com; Mon, 07 Nov 2011 10:30:37 +0000
Date: Mon, 7 Nov 2011 05:30:37 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: xfs_getbmap assert
Message-ID: <20111107103037.GA16213@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

With Dmitris fsstress updates I can hit the following assert fairly
regularly:

[11904.943956] XFS: Assertion failed: ((iflags & BMV_IF_DELALLOC) != 0) ||
(map[i].br_startblock != DELAYSTARTBLOCK), file:
/home/hch/work/linux-2.6/fs/xfs/xfs_bmap.c, line: 5604

which means we get an delalloc extent back from FIEMAP/GETBMAP despite
asking for a flush beforehand.  While we hold the iolock over the call
and thus exclude new buffered writers from appearing that doesn't
prevent shared writeable mmaps from creating new delalloc extents.

I don't think this actually is a real issue, and a workaround would
be extremly hard.  For now I've just remove the assert in my tree:


Index: xfs/fs/xfs/xfs_bmap.c
===================================================================
--- xfs.orig/fs/xfs/xfs_bmap.c	2011-11-05 09:02:24.410021945 +0100
+++ xfs/fs/xfs/xfs_bmap.c	2011-11-05 09:03:54.036494235 +0100
@@ -5600,8 +5600,6 @@ xfs_getbmap(
 				XFS_FSB_TO_BB(mp, map[i].br_blockcount);
 			out[cur_ext].bmv_unused1 = 0;
 			out[cur_ext].bmv_unused2 = 0;
-			ASSERT(((iflags & BMV_IF_DELALLOC) != 0) ||
-			      (map[i].br_startblock != DELAYSTARTBLOCK));
                         if (map[i].br_startblock == HOLESTARTBLOCK &&
 			    whichfork == XFS_ATTR_FORK) {
 				/* came to the end of attribute fork */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
