Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id F317429DF8
	for <xfs@oss.sgi.com>; Mon, 13 Jan 2014 14:02:58 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 83BE2AC004
	for <xfs@oss.sgi.com>; Mon, 13 Jan 2014 12:02:58 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id XfUJpLy2RnYZtqwi for
	<xfs@oss.sgi.com>; Mon, 13 Jan 2014 12:02:54 -0800 (PST)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s0DK2qeV024402
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Mon, 13 Jan 2014 15:02:52 -0500
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s0DK2oaE006195
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Mon, 13 Jan 2014 15:02:50 -0500
Message-ID: <52D4466A.7000003@redhat.com>
Date: Mon, 13 Jan 2014 14:02:50 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfstests 049, 073: use MKFS_XFS_PROG where appropriate
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

I got burned on a mishmash system with /usr/sbin/mkfs but
/sbin/mkfs.xfs - or was it the other way around...

Anyway, in these tests, there's no need for the concatenation
to create "mkfs.xfs" - just use MKFS_XFS_PROG.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/tests/xfs/049 b/tests/xfs/049
index 850d371..dc76baa 100755
--- a/tests/xfs/049
+++ b/tests/xfs/049
@@ -82,7 +82,7 @@ mount -t ext2 $SCRATCH_DEV $SCRATCH_MNT >> $seqres.full 2>&1 \
     || _fail "!!! failed to mount"
 
 _log "Create xfs fs in file on scratch"
-${MKFS_PROG}.xfs -f -dfile,name=$SCRATCH_MNT/test.xfs,size=40m \
+${MKFS_XFS_PROG} -f -dfile,name=$SCRATCH_MNT/test.xfs,size=40m \
     >> $seqres.full 2>&1 \
     || _fail "!!! failed to mkfs xfs"
 
diff --git a/tests/xfs/073 b/tests/xfs/073
index ad38059..4280fa9 100755
--- a/tests/xfs/073
+++ b/tests/xfs/073
@@ -153,7 +153,7 @@ _verify_copy $imgs.image $SCRATCH_DEV $SCRATCH_MNT
 
 echo 
 echo === copying scratch device to single target, large ro device
-${MKFS_PROG}.xfs -dfile,name=$imgs.source,size=100g | _filter_mkfs 2>/dev/null
+${MKFS_XFS_PROG} -dfile,name=$imgs.source,size=100g | _filter_mkfs 2>/dev/null
 rmdir $imgs.source_dir 2>/dev/null
 mkdir $imgs.source_dir
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
