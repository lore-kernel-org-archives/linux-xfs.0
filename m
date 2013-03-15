Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A3D0C7FDB
	for <xfs@oss.sgi.com>; Fri, 15 Mar 2013 06:53:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 93DEE304043
	for <xfs@oss.sgi.com>; Fri, 15 Mar 2013 04:53:51 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	wCD1Kg7QeENPDxbP for <xfs@oss.sgi.com>;
	Fri, 15 Mar 2013 04:53:50 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UGTCj-0001U7-KB
	for xfs@oss.sgi.com; Fri, 15 Mar 2013 22:53:45 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UGTCj-0005iS-GE
	for xfs@oss.sgi.com; Fri, 15 Mar 2013 22:53:45 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 12/13] xfstests: filter files in 019 for --large-fs
Date: Fri, 15 Mar 2013 22:53:30 +1100
Message-Id: <1363348411-21867-13-git-send-email-david@fromorbit.com>
In-Reply-To: <1363348411-21867-1-git-send-email-david@fromorbit.com>
References: <1363348411-21867-1-git-send-email-david@fromorbit.com>
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

Make sure that the .use_space files don't appear in the files dumped
to the output files.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 019 |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/019 b/019
index 42e3c22..88be464 100755
--- a/019
+++ b/019
@@ -128,15 +128,16 @@ _verify_fs()
 
 	echo "*** verify FS"
 	(cd $SCRATCH_MNT ; find . | LC_COLLATE=POSIX sort \
+		| grep -v ".use_space" \
 		| xargs $here/src/lstat64 | _filter_stat)
 	diff -q $SCRATCH_MNT/bigfile $tempfile.2 \
 		|| _fail "bigfile corrupted"
-    
+
 	echo "*** unmount FS"
 	_full "umount"
 	umount $SCRATCH_DEV >>$seqfull 2>&1 \
 		|| _fail "umount failed"
-	    
+
 	echo "*** check FS"
 	_check_scratch_fs
 }
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
