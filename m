Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7E65E7F37
	for <xfs@oss.sgi.com>; Fri, 17 May 2013 06:13:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6B7EB30405F
	for <xfs@oss.sgi.com>; Fri, 17 May 2013 04:13:40 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	iRM5nvVv1jUPFtCt for <xfs@oss.sgi.com>;
	Fri, 17 May 2013 04:13:39 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UdIbM-0008RR-Lu
	for xfs@oss.sgi.com; Fri, 17 May 2013 21:13:32 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UdIbM-0005Dk-HU
	for xfs@oss.sgi.com; Fri, 17 May 2013 21:13:32 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 01/30] mkfs: fix realtime device initialisation
Date: Fri, 17 May 2013 21:12:56 +1000
Message-Id: <1368789205-19969-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1368789205-19969-1-git-send-email-david@fromorbit.com>
References: <1368789205-19969-1-git-send-email-david@fromorbit.com>
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

The method that libxfs uses for logging inodes is not followed by rtinit().
It fails to join the realtime bitmap inode to the final extent free
transactions, and so mkfs.xfs dies when trying to log changes to the bitmap
inode. Fix it.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 mkfs/proto.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/mkfs/proto.c b/mkfs/proto.c
index 56eed31..f201096 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -733,6 +733,8 @@ rtinit(
 		tp = libxfs_trans_alloc(mp, 0);
 		if ((i = libxfs_trans_reserve(tp, 0, 0, 0, 0, 0)))
 			res_failed(i);
+		libxfs_trans_ijoin(tp, rbmip, 0);
+		libxfs_trans_ihold(tp, rbmip);
 		xfs_bmap_init(&flist, &first);
 		ebno = XFS_RTMIN(mp->m_sb.sb_rextents,
 			bno + NBBY * mp->m_sb.sb_blocksize);
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
