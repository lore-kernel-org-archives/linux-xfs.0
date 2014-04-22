Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 3C6977F57
	for <xfs@oss.sgi.com>; Tue, 22 Apr 2014 17:04:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 029218F8049
	for <xfs@oss.sgi.com>; Tue, 22 Apr 2014 15:04:43 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	IAEN1Y79KHWFoIEK for <xfs@oss.sgi.com>;
	Tue, 22 Apr 2014 15:04:42 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1Wcinv-0002PI-Bm
	for xfs@oss.sgi.com; Wed, 23 Apr 2014 08:04:39 +1000
Received: from dave by disappointment with local (Exim 4.82)
	(envelope-from <dave@disappointment.disaster>) id 1Wcinv-0000nx-B4
	for xfs@oss.sgi.com; Wed, 23 Apr 2014 08:04:39 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/6] generic/204: tweak reserve pool size
Date: Wed, 23 Apr 2014 08:04:29 +1000
Message-Id: <1398204274-2113-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1398204274-2113-1-git-send-email-david@fromorbit.com>
References: <1398204274-2113-1-git-send-email-david@fromorbit.com>
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

On small block size filesystems, the reserve pool size is kept
constant at 4MB. filesystems with smaller blocks use comparitively
more blocks for indexing metadata (e.g. in the inode and extent
btrees) and so having a higher indirect block usage. Hence we need
to leave the reserve pool at 1024 block and not scale it for a
constant size.

This makes the test pass on a filesystem made with MKFS_OPTIONS="-b
size=1024 -m crc=1".

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 tests/generic/204 | 2 --
 1 file changed, 2 deletions(-)

diff --git a/tests/generic/204 b/tests/generic/204
index 4ebab26..de029c6 100755
--- a/tests/generic/204
+++ b/tests/generic/204
@@ -74,7 +74,6 @@ space=97920000
 #	files = (97920000 / (isize + bsize))
 
 files=$((space / (isize + dbsize)))
-resv_blks=$((resv_blks * (4096 / dbsize)))
 
 echo files $files, resvblks $resv_blks >> $seqres.full
 _scratch_resvblks $resv_blks >> $seqres.full 2>&1
@@ -88,5 +87,4 @@ _check_scratch_fs
 
 # success, all done
 echo "*** done"
-rm -f $seqres.full
 status=0
-- 
1.9.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
