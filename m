Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2QJUbUT074319 for <xfs@oss.sgi.com>; Mon, 26 Mar 2012 14:30:37 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id oFrdm9QsqQyAOqir for
	<xfs@oss.sgi.com>; Mon, 26 Mar 2012 12:30:35 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q2QJUZA1006775
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Mon, 26 Mar 2012 15:30:35 -0400
Message-ID: <4F70C3D9.80708@redhat.com>
Date: Mon, 26 Mar 2012 14:30:33 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfstests 235: do smaller test IO
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
To: xfs-oss <xfs@oss.sgi.com>
Cc: Eryu Guan <eguan@redhat.com>

Test 235 fails on ext2/ext3 with 1024 fs block size because a
16k write uses an extra metadata block.  If we do a smaller write
this won't happen.

Reported by: Eryu Guan <eguan@redhat.com>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/235 b/235
index 7150fca..0c2ae8f 100755
--- a/235
+++ b/235
@@ -70,7 +70,7 @@ mount -o remount,ro $SCRATCH_DEV 2>&1 | tee -a $seq.full | _filter_scratch
 touch $SCRATCH_MNT/failed 2>&1 | tee -a $seq.full | _filter_scratch
 mount -o remount,rw $SCRATCH_DEV 2>&1 | tee -a $seq.full | _filter_scratch
 
-$XFS_IO_PROG -F -c 'pwrite 0 16k' -c 'fsync' \
+$XFS_IO_PROG -F -c 'pwrite 0 8k' -c 'fsync' \
 			$SCRATCH_MNT/testfile >>$seq.full 2>&1
 repquota -u -g $SCRATCH_MNT  | grep -v "^root" | _filter_scratch
 
diff --git a/235.out b/235.out
index 345e29d..a095694 100644
--- a/235.out
+++ b/235.out
@@ -21,7 +21,7 @@ Block grace time: 7days; Inode grace time: 7days
                         Block limits                File limits
 User            used    soft    hard  grace    used  soft  hard  grace
 ----------------------------------------------------------------------
-fsgqa     --      16       0       0              1     0     0       
+fsgqa     --       8       0       0              1     0     0       
 
 
 *** Report for group quotas on device SCRATCH_DEV
@@ -29,6 +29,6 @@ Block grace time: 7days; Inode grace time: 7days
                         Block limits                File limits
 Group           used    soft    hard  grace    used  soft  hard  grace
 ----------------------------------------------------------------------
-fsgqa     --      16       0       0              1     0     0       
+fsgqa     --       8       0       0              1     0     0       
 
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
