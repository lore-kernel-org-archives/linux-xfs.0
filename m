Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E5B147F52
	for <xfs@oss.sgi.com>; Sun,  6 Oct 2013 17:46:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C6487304048
	for <xfs@oss.sgi.com>; Sun,  6 Oct 2013 15:46:22 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id VjBQQ1SzeI3Dz3bJ for
	<xfs@oss.sgi.com>; Sun, 06 Oct 2013 15:46:22 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r96MkLKL027981
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Sun, 6 Oct 2013 18:46:21 -0400
Received: from Liberator.local (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id r96MkJcN005167
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Sun, 6 Oct 2013 18:46:21 -0400
Message-ID: <5251E83B.8060605@redhat.com>
Date: Sun, 06 Oct 2013 17:46:19 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfstests: handle xfs_quota output w/ long devicenames
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>

Long device names may be split onto their own line
on quota output:

Filesystem   Blocks  Quota  Limit Warn/Time    Mounted on
/dev/mapper/my-very-very-very-long-devicename
                48M      0      0  00 [------] /mnt/scratch

which breaks tests that capture quota output - currently,
only xfs/108.

Add a _filter_quota() which fixes this.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---



diff --git a/common/filter b/common/filter
index 066b353..a0d9d2a 100644
--- a/common/filter
+++ b/common/filter
@@ -240,6 +240,15 @@ _filter_spaces()
        sed -e 's/ [ ]*/ /g'
 }
 
+_filter_quota()
+{
+	# Long dev name might be split onto its own line; last
+	# seds remove that newline if present
+	_filter_scratch | _filter_test_dir | _filter_spaces | \
+	sed -e 'N;s/SCRATCH_DEV\n/SCRATCH_DEV/g' | \
+	sed -e 'N;s/TEST_DEV\n/TEST_DEV/g'
+}
+
 # Account for different "ln" failure messages
 _filter_ln()
 {
diff --git a/tests/xfs/108 b/tests/xfs/108
index 82694f1..5030f63 100755
--- a/tests/xfs/108
+++ b/tests/xfs/108
@@ -71,9 +71,9 @@ test_accounting()
 	for file in $SCRATCH_MNT/{buffer,direct,mmap}; do
 		$here/src/lstat64 $file | head -3 | _filter_scratch
 	done
-	xfs_quota -c "quota -hnb -$type $id" $QARGS | _filter_scratch | _filter_spaces
-	xfs_quota -c "quota -hni -$type $id" $QARGS | _filter_scratch | _filter_spaces
-	xfs_quota -c "quota -hnr -$type $id" $QARGS | _filter_scratch | _filter_spaces
+	xfs_quota -c "quota -hnb -$type $id" $QARGS | _filter_quota
+	xfs_quota -c "quota -hni -$type $id" $QARGS | _filter_quota
+	xfs_quota -c "quota -hnr -$type $id" $QARGS | _filter_quota
 }
 
 export MOUNT_OPTIONS="-opquota"

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
