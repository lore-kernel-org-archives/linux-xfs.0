Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40234 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753572AbcITLjS (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 20 Sep 2016 07:39:18 -0400
Received: from int-mx13.intmail.prod.int.phx2.redhat.com (int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4739C3D94B
        for <linux-xfs@vger.kernel.org>; Tue, 20 Sep 2016 11:39:18 +0000 (UTC)
Received: from localhost (dhcp-12-196.nay.redhat.com [10.66.12.196])
        by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id u8KBdHk9012216
        for <linux-xfs@vger.kernel.org>; Tue, 20 Sep 2016 07:39:17 -0400
Date: Tue, 20 Sep 2016 19:39:16 +0800
From: Zorro Lang <zlang@redhat.com>
Subject: xfs_copy V5 XFS to multi-targets cause targets corruption
Message-ID: <20160920113916.GN12847@dhcp12-143.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi,

I'm trying to change xfstests xfs/073. xfs_copy support to copy V5
XFS without "-d" option now, xfs/073 can test V5 xfs without "-d"
before, but there're two commits changed that behavior:

  8346e53a common: append -d option to XFS_COPY_PROG when testing v5 xfs
  c5223b92 filter: inode size output of mkfs.xfs can change

I haven't had a good idea to change that, so only do below simple
change first:
diff --git a/common/rc b/common/rc
index 04039a4..1d03897 100644
--- a/common/rc
+++ b/common/rc
@@ -3761,11 +3761,6 @@ init_rc()
        # Figure out if we need to add -F ("foreign", deprecated) option to xfs_io
        xfs_io -c stat $TEST_DIR 2>&1 | grep -q "is not on an XFS filesystem" && \
        export XFS_IO_PROG="$XFS_IO_PROG -F"
-
-       # xfs_copy doesn't work on v5 xfs yet without -d option
-       if [ "$FSTYP" == "xfs" ] && [[ $MKFS_OPTIONS =~ crc=1 ]]; then
-               export XFS_COPY_PROG="$XFS_COPY_PROG -d"
-       fi
 }
 
 # get real device path name by following link
diff --git a/tests/xfs/073 b/tests/xfs/073
index 9e29223..7228dd9 100755
--- a/tests/xfs/073
+++ b/tests/xfs/073
@@ -138,7 +138,7 @@ _require_loop
 
 rm -f $seqres.full
 
-_scratch_mkfs_xfs -m crc=0 -dsize=41m,agcount=2 >>$seqres.full 2>&1
+_scratch_mkfs_xfs -dsize=41m,agcount=2 >>$seqres.full 2>&1
 _scratch_mount 2>/dev/null || _fail "initial scratch mount failed"
 
 echo
@@ -158,11 +158,7 @@ _verify_copy $imgs.image $SCRATCH_DEV $SCRATCH_MNT
 
 echo 
 echo === copying scratch device to single target, large ro device
-mkfs_crc_opts="-m crc=0"
-if [ -n "$XFS_MKFS_HAS_NO_META_SUPPORT" ]; then
-       mkfs_crc_opts=""
-fi
-${MKFS_XFS_PROG} $mkfs_crc_opts -dfile,name=$imgs.source,size=100g \
+${MKFS_XFS_PROG} -dfile,name=$imgs.source,size=100g \
        | _filter_mkfs 2>/dev/null
 rmdir $imgs.source_dir 2>/dev/null
 mkdir $imgs.source_dir


Then I got problem when I ran xfs/073 with MKFS_OPTIONS="-m crc=1":
[root@dhcp-13-149 xfstests-dev]# diff -Nurp tests/xfs/073.out results/xfs/073.out.bad 
--- tests/xfs/073.out   2016-04-13 11:44:17.809000000 +0800
+++ results/xfs/073.out.bad     2016-09-20 19:12:40.194000000 +0800
@@ -59,8 +59,5 @@ comparing new image directories to old
 comparing new image geometry to old
 unmounting and removing new image
 checking new image
-mounting new image on loopback
-comparing new image files to old
-comparing new image directories to old
-comparing new image geometry to old
-unmounting and removing new image
+_check_xfs_filesystem: filesystem on /mnt/test/9672.image2 is inconsistent (c) (see /root/git/xfstests-dev/results//xfs/073.full)
+_check_xfs_filesystem: filesystem on /mnt/test/9672.image2 is inconsistent (r) (see /root/git/xfstests-dev/results//xfs/073.full)


The last test stes of xfs/073 failed:
echo === copying scratch device to multiple targets
$XFS_COPY_PROG -d -L$imgs.log -b $SCRATCH_DEV $imgs.image1 $imgs.image2 \
        | _filter_copy '#' $imgs.image1 '#' $imgs.image2
_verify_copy $imgs.image1 $SCRATCH_DEV $SCRATCH_MNT
_verify_copy $imgs.image2 $SCRATCH_DEV $SCRATCH_MNT


The full output is too long, so I paste it to below link (this link will
keep alive in one month):
http://paste.fedoraproject.org/431361/74370897/

I can't find this problem on V4 XFS(crc=0). I tested this bug with upstream
linux v4.8-rc7(d2ffb01 Merge branch 'akpm' (patches from Andrew)) and xfsprogs
v4.8-rc1(130093a xfsprogs: Release 4.8.0-rc1).

This problem can be simply reproduced by below steps:
1. mkfs.xfs -d name=fsfile,size=512m,file=1 -m crc=1
2. xfs_copy fsfile target1 target2
3. xfs_repair -n target2
4. xfs_repair -n target1

But these steps can't make target1 corrupted(in my test).

Thanks,
Zorro
