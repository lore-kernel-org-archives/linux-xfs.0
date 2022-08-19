Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42813C32773
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Aug 2022 10:02:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347856AbiHSKCB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 19 Aug 2022 06:02:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347754AbiHSKB7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 19 Aug 2022 06:01:59 -0400
Received: from mail-qv1-xf2a.google.com (mail-qv1-xf2a.google.com [IPv6:2607:f8b0:4864:20::f2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B6C2F4CB4;
        Fri, 19 Aug 2022 03:01:53 -0700 (PDT)
Received: by mail-qv1-xf2a.google.com with SMTP id e4so3008570qvr.2;
        Fri, 19 Aug 2022 03:01:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=EneCWmEoSgB/f9h0VrVEOr3N1gugxPzCn6ZhheADvZg=;
        b=Cb2rKR5Q+ZaFOsQF4JAkkVciBu9QlxbKijmxKc91WoqRXP0RxRmlP2IJ7G7l89J16L
         ZNLf+kBcVbMGF3ND4BrWXmR7vBVtbeVp8J0Ppwi8CzB1hhacsmccYymIW8S/RtH49Fn1
         N1YoafwchUK3QTuj6A9X6n4EXrrqqgAgGm6rGkZQr1GDpO2nvjkjV+8HuN2GnOW8FPld
         ZNcxdwPXBi7ZfosdYN9DEYMl4rOG5nUvvJOfhAr9DwJ0B5EGSus1COrLoy+ErFVXgmPf
         /fr581jHV06vSY7IpbOquyPx4HtGuNwB8KK0PjyfDJaVQOkRj8if9cxB2HPfgvxeCD1S
         uh6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=EneCWmEoSgB/f9h0VrVEOr3N1gugxPzCn6ZhheADvZg=;
        b=oFZ3eJm3YeH0rglm5bN3fo3fCqdmKrHEUgJM0Tyo4Q04onw9lIQFVv0Vw/U5qs3O4Y
         uv5nfhWfQpU1VoTeL5B8UcLjIQP+hjtKMMDdyVKKIIIqpHtMX/YxR5Mb9el5oRotLNwF
         jWzgiHqb3UtD8sJhrrXosht213BI3eItGPDuUXLWgNbr99NPXZqXWkSUCEVXgSTEz0Fj
         5tQjT8AA8Er+ijfVrjMTBLQwTF2n0k+9epYcUf7WykocAVlMPQ5r3ZoIF+oQl7HD6cPn
         vklcY6GME45bPT/uH5a5KLROSiYkCBO3atmbeXYwMVSZwJkz6GnMgE9fFZorJc+6zc+r
         uOWw==
X-Gm-Message-State: ACgBeo0AtfVbNmUOA+ySkTniodo21iPU4FECcJtIWp3jlT598FhQtK2C
        3t/g8kQYSTj3Mi6sbTUKDDWPftlaQPY=
X-Google-Smtp-Source: AA6agR4JUl2PdUwqY3nWh0nj8AIfGRtV9p5GJ+s+raOpxrZRiHP0z23xYfznnc2jEjkKnZxoGuaCBA==
X-Received: by 2002:a05:6214:509e:b0:496:a98a:fd5 with SMTP id kk30-20020a056214509e00b00496a98a0fd5mr5692540qvb.2.1660903310981;
        Fri, 19 Aug 2022 03:01:50 -0700 (PDT)
Received: from xzhouw.hosts.qa.psi.rdu2.redhat.com ([66.187.232.127])
        by smtp.gmail.com with ESMTPSA id m13-20020aed27cd000000b003422c7ccbc5sm2760195qtg.59.2022.08.19.03.01.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Aug 2022 03:01:50 -0700 (PDT)
From:   Murphy Zhou <jencce.kernel@gmail.com>
To:     fstests@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH] tests: increase fs size for _scratch_mkfs_sized
Date:   Fri, 19 Aug 2022 18:01:49 +0800
Message-Id: <20220819100149.1520583-1-jencce.kernel@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Since this xfsprogs commit:
	6e0ed3d19c54 mkfs: stop allowing tiny filesystems
testcases that makes fs smaller then 300M are not working for xfs.

Increase thoese numbers to 512M at least. There is no special
reason for the magic number 512, just double it from original
256M for being reasonable small.

Signed-off-by: Murphy Zhou <jencce.kernel@gmail.com>
---
 tests/generic/015 | 2 +-
 tests/generic/027 | 2 +-
 tests/generic/077 | 2 +-
 tests/generic/081 | 4 ++--
 tests/generic/083 | 2 +-
 tests/generic/085 | 2 +-
 tests/generic/204 | 2 +-
 tests/generic/226 | 2 +-
 tests/generic/250 | 2 +-
 tests/generic/252 | 2 +-
 tests/generic/371 | 2 +-
 tests/generic/387 | 2 +-
 tests/generic/416 | 2 +-
 tests/generic/427 | 2 +-
 tests/generic/449 | 2 +-
 tests/generic/511 | 2 +-
 tests/generic/520 | 4 ++--
 tests/generic/536 | 2 +-
 tests/generic/619 | 2 +-
 tests/generic/626 | 2 +-
 tests/xfs/015     | 2 +-
 tests/xfs/107     | 4 ++--
 tests/xfs/118     | 4 ++--
 tests/xfs/227     | 2 +-
 tests/xfs/233     | 2 +-
 25 files changed, 29 insertions(+), 29 deletions(-)

diff --git a/tests/generic/015 b/tests/generic/015
index 10423a29..f6804897 100755
--- a/tests/generic/015
+++ b/tests/generic/015
@@ -31,7 +31,7 @@ _require_no_large_scratch_dev
 
 # btrfs needs at least 256MB (with upward round off) to create a non-mixed mode
 # fs. Ref: btrfs-progs: btrfs_min_dev_size()
-_scratch_mkfs_sized $((256 * 1024 * 1024)) >> $seqres.full 2>&1 \
+_scratch_mkfs_sized $((512 * 1024 * 1024)) >> $seqres.full 2>&1 \
     || _fail "mkfs failed"
 _scratch_mount
 out=$SCRATCH_MNT/fillup.$$
diff --git a/tests/generic/027 b/tests/generic/027
index 47f1981d..ad8175c1 100755
--- a/tests/generic/027
+++ b/tests/generic/027
@@ -35,7 +35,7 @@ _require_scratch
 
 echo "Silence is golden"
 
-_scratch_mkfs_sized $((256 * 1024 * 1024)) >>$seqres.full 2>&1
+_scratch_mkfs_sized $((512 * 1024 * 1024)) >>$seqres.full 2>&1
 _scratch_mount
 
 echo "Reserve 2M space" >>$seqres.full
diff --git a/tests/generic/077 b/tests/generic/077
index 94d89fae..639564ed 100755
--- a/tests/generic/077
+++ b/tests/generic/077
@@ -49,7 +49,7 @@ echo "*** create filesystem"
 _scratch_unmount >/dev/null 2>&1
 echo "*** MKFS ***"                         >>$seqres.full
 echo ""                                     >>$seqres.full
-fs_size=$((256 * 1024 * 1024))
+fs_size=$((512 * 1024 * 1024))
 _scratch_mkfs_sized $fs_size >> $seqres.full 2>&1 || _fail "mkfs failed"
 _scratch_mount
 mkdir $SCRATCH_MNT/subdir
diff --git a/tests/generic/081 b/tests/generic/081
index 22ac94de..8b481cb5 100755
--- a/tests/generic/081
+++ b/tests/generic/081
@@ -62,9 +62,9 @@ snapname=snap_$seq
 mnt=$TEST_DIR/mnt_$seq
 mkdir -p $mnt
 
-# make sure there's enough disk space for 256M lv, test for 300M here in case
+# make sure there's enough disk space for 256M lv, test for 512M here in case
 # lvm uses some space for metadata
-_scratch_mkfs_sized $((300 * 1024 * 1024)) >>$seqres.full 2>&1
+_scratch_mkfs_sized $((512 * 1024 * 1024)) >>$seqres.full 2>&1
 $LVM_PROG vgcreate -f $vgname $SCRATCH_DEV >>$seqres.full 2>&1
 # We use yes pipe instead of 'lvcreate --yes' because old version of lvm
 # (like 2.02.95 in RHEL6) don't support --yes option
diff --git a/tests/generic/083 b/tests/generic/083
index 2a5af3cc..4c79538c 100755
--- a/tests/generic/083
+++ b/tests/generic/083
@@ -62,7 +62,7 @@ workout()
 
 echo "*** test out-of-space handling for random write operations"
 
-filesize=`expr 256 \* 1024 \* 1024`
+filesize=`expr 512 \* 1024 \* 1024`
 agcount=6
 numprocs=15
 numops=1500
diff --git a/tests/generic/085 b/tests/generic/085
index 786d8e6f..006fcb5d 100755
--- a/tests/generic/085
+++ b/tests/generic/085
@@ -50,7 +50,7 @@ setup_dmdev()
 
 echo "Silence is golden"
 
-size=$((256 * 1024 * 1024))
+size=$((512 * 1024 * 1024))
 size_in_sector=$((size / 512))
 _scratch_mkfs_sized $size >>$seqres.full 2>&1
 
diff --git a/tests/generic/204 b/tests/generic/204
index a33a090f..3589b084 100755
--- a/tests/generic/204
+++ b/tests/generic/204
@@ -30,7 +30,7 @@ _require_scratch
 # time solves this problem.
 [ $FSTYP = "xfs" ] && MKFS_OPTIONS="$MKFS_OPTIONS -l size=16m -i maxpct=50"
 
-SIZE=`expr 115 \* 1024 \* 1024`
+SIZE=`expr 512 \* 1024 \* 1024`
 _scratch_mkfs_sized $SIZE 2> /dev/null > $tmp.mkfs.raw
 cat $tmp.mkfs.raw | _filter_mkfs 2> $tmp.mkfs > /dev/null
 _scratch_mount
diff --git a/tests/generic/226 b/tests/generic/226
index 34434730..d814b365 100755
--- a/tests/generic/226
+++ b/tests/generic/226
@@ -19,7 +19,7 @@ _require_odirect
 
 _scratch_unmount 2>/dev/null
 echo "--> mkfs 256m filesystem"
-_scratch_mkfs_sized `expr 256 \* 1024 \* 1024` >> $seqres.full 2>&1
+_scratch_mkfs_sized `expr 512 \* 1024 \* 1024` >> $seqres.full 2>&1
 _scratch_mount
 
 loops=16
diff --git a/tests/generic/250 b/tests/generic/250
index 97e9522f..bd1c6ffd 100755
--- a/tests/generic/250
+++ b/tests/generic/250
@@ -32,7 +32,7 @@ _require_odirect
 # bitmap consuming all the free space in our small data device.
 unset SCRATCH_RTDEV
 
-fssize=$((196 * 1048576))
+fssize=$((512 * 1048576))
 echo "Format and mount"
 $XFS_IO_PROG -d -c "pwrite -S 0x69 -b 1048576 0 $fssize" $SCRATCH_DEV >> $seqres.full
 _scratch_mkfs_sized $fssize > $seqres.full 2>&1
diff --git a/tests/generic/252 b/tests/generic/252
index 8c5adb53..93ab5242 100755
--- a/tests/generic/252
+++ b/tests/generic/252
@@ -33,7 +33,7 @@ AIO_TEST="$here/src/aio-dio-regress/aiocp"
 # bitmap consuming all the free space in our small data device.
 unset SCRATCH_RTDEV
 
-fssize=$((196 * 1048576))
+fssize=$((512 * 1048576))
 echo "Format and mount"
 $XFS_IO_PROG -d -c "pwrite -S 0x69 -b 1048576 0 $fssize" $SCRATCH_DEV >> $seqres.full
 _scratch_mkfs_sized $fssize > $seqres.full 2>&1
diff --git a/tests/generic/371 b/tests/generic/371
index a2fdaf7b..538df647 100755
--- a/tests/generic/371
+++ b/tests/generic/371
@@ -20,7 +20,7 @@ _require_scratch
 _require_xfs_io_command "falloc"
 test "$FSTYP" = "xfs" && _require_xfs_io_command "extsize"
 
-_scratch_mkfs_sized $((256 * 1024 * 1024)) >> $seqres.full 2>&1
+_scratch_mkfs_sized $((512 * 1024 * 1024)) >> $seqres.full 2>&1
 _scratch_mount
 
 # Disable speculative post-EOF preallocation on XFS, which can grow fast enough
diff --git a/tests/generic/387 b/tests/generic/387
index 25ca86bb..0546b7de 100755
--- a/tests/generic/387
+++ b/tests/generic/387
@@ -19,7 +19,7 @@ _supported_fs generic
 _require_scratch_reflink
 
 #btrfs needs 256mb to create default blockgroup fs
-_scratch_mkfs_sized $((256 * 1024 * 1024)) >> $seqres.full 2>&1
+_scratch_mkfs_sized $((512 * 1024 * 1024)) >> $seqres.full 2>&1
 _scratch_mount
 
 testfile=$SCRATCH_MNT/testfile
diff --git a/tests/generic/416 b/tests/generic/416
index deb05f07..24fdb737 100755
--- a/tests/generic/416
+++ b/tests/generic/416
@@ -21,7 +21,7 @@ _begin_fstest auto enospc
 _supported_fs generic
 _require_scratch
 
-fs_size=$((128 * 1024 * 1024))
+fs_size=$((512 * 1024 * 1024))
 page_size=$(get_page_size)
 
 # We will never reach this number though
diff --git a/tests/generic/427 b/tests/generic/427
index 26385d36..4f44c2ea 100755
--- a/tests/generic/427
+++ b/tests/generic/427
@@ -27,7 +27,7 @@ _require_aiodio aio-dio-eof-race
 _require_no_compress
 
 # limit the filesystem size, to save the time of filling filesystem
-_scratch_mkfs_sized $((256 * 1024 * 1024)) >>$seqres.full 2>&1
+_scratch_mkfs_sized $((512 * 1024 * 1024)) >>$seqres.full 2>&1
 _scratch_mount
 
 # try to write more bytes than filesystem size to fill the filesystem,
diff --git a/tests/generic/449 b/tests/generic/449
index 2b77a6a4..aebb5620 100755
--- a/tests/generic/449
+++ b/tests/generic/449
@@ -24,7 +24,7 @@ _require_test
 _require_acls
 _require_attrs trusted
 
-_scratch_mkfs_sized $((256 * 1024 * 1024)) >> $seqres.full 2>&1
+_scratch_mkfs_sized $((512 * 1024 * 1024)) >> $seqres.full 2>&1
 _scratch_mount || _fail "mount failed"
 
 # This is a test of xattr behavior when we run out of disk space for xattrs,
diff --git a/tests/generic/511 b/tests/generic/511
index 058d8401..8b1209d3 100755
--- a/tests/generic/511
+++ b/tests/generic/511
@@ -19,7 +19,7 @@ _require_scratch
 _require_xfs_io_command "falloc" "-k"
 _require_xfs_io_command "fzero"
 
-_scratch_mkfs_sized $((1024 * 1024 * 256)) >>$seqres.full 2>&1
+_scratch_mkfs_sized $((1024 * 1024 * 512)) >>$seqres.full 2>&1
 _scratch_mount
 
 $XFS_IO_PROG -fc "pwrite 0 256m" -c fsync $SCRATCH_MNT/file >>$seqres.full 2>&1
diff --git a/tests/generic/520 b/tests/generic/520
index ad6764c7..2a96dce1 100755
--- a/tests/generic/520
+++ b/tests/generic/520
@@ -24,8 +24,8 @@ _cleanup()
 . ./common/filter
 . ./common/dmflakey
 
-# 256MB in byte
-fssize=$((2**20 * 256))
+# 512MB in byte
+fssize=$((2**20 * 512))
 
 # real QA test starts here
 _supported_fs generic
diff --git a/tests/generic/536 b/tests/generic/536
index 986ea1ee..aac05587 100755
--- a/tests/generic/536
+++ b/tests/generic/536
@@ -21,7 +21,7 @@ _require_scratch
 _require_scratch_shutdown
 
 # create a small fs and initialize free blocks with a unique pattern
-_scratch_mkfs_sized $((1024 * 1024 * 100)) >> $seqres.full 2>&1
+_scratch_mkfs_sized $((1024 * 1024 * 512)) >> $seqres.full 2>&1
 _scratch_mount
 $XFS_IO_PROG -f -c "pwrite -S 0xab 0 100m" -c fsync $SCRATCH_MNT/spc \
 	>> $seqres.full 2>&1
diff --git a/tests/generic/619 b/tests/generic/619
index 6e42d677..1e883394 100755
--- a/tests/generic/619
+++ b/tests/generic/619
@@ -26,7 +26,7 @@
 . ./common/preamble
 _begin_fstest auto rw enospc
 
-FS_SIZE=$((240*1024*1024)) # 240MB
+FS_SIZE=$((512*1024*1024)) # 512MB
 DEBUG=1 # set to 0 to disable debug statements in shell and c-prog
 FACT=0.7
 
diff --git a/tests/generic/626 b/tests/generic/626
index 7e577798..a0411f01 100755
--- a/tests/generic/626
+++ b/tests/generic/626
@@ -22,7 +22,7 @@ _supported_fs generic
 _require_scratch
 _require_renameat2 whiteout
 
-_scratch_mkfs_sized $((256 * 1024 * 1024)) >> $seqres.full 2>&1
+_scratch_mkfs_sized $((512 * 1024 * 1024)) >> $seqres.full 2>&1
 _scratch_mount
 
 # Create lots of files, to help to trigger the bug easily
diff --git a/tests/xfs/015 b/tests/xfs/015
index 2bb7b8d5..1f487cae 100755
--- a/tests/xfs/015
+++ b/tests/xfs/015
@@ -43,7 +43,7 @@ _scratch_mount
 _require_fs_space $SCRATCH_MNT 131072
 _scratch_unmount
 
-_scratch_mkfs_sized $((32 * 1024 * 1024)) > $tmp.mkfs.raw || _fail "mkfs failed"
+_scratch_mkfs_sized $((512 * 1024 * 1024)) > $tmp.mkfs.raw || _fail "mkfs failed"
 cat $tmp.mkfs.raw | _filter_mkfs >$seqres.full 2>$tmp.mkfs
 # get original data blocks number and agcount
 . $tmp.mkfs
diff --git a/tests/xfs/107 b/tests/xfs/107
index 1ea9c492..e1f9b537 100755
--- a/tests/xfs/107
+++ b/tests/xfs/107
@@ -23,9 +23,9 @@ _require_scratch
 _require_xfs_io_command allocsp		# detect presence of ALLOCSP ioctl
 _require_test_program allocstale
 
-# Create a 256MB filesystem to avoid running into mkfs problems with too-small
+# Create a 512MB filesystem to avoid running into mkfs problems with too-small
 # filesystems.
-size_mb=256
+size_mb=512
 
 # Write a known pattern to the disk so that we can detect stale disk blocks
 # being mapped into the file.  In the test author's experience, the bug will
diff --git a/tests/xfs/118 b/tests/xfs/118
index 03755b28..6fc3cdaa 100755
--- a/tests/xfs/118
+++ b/tests/xfs/118
@@ -27,8 +27,8 @@ _require_scratch
 _require_command "$XFS_FSR_PROG" "xfs_fsr"
 _require_xfs_io_command "falloc"
 
-# 50M
-_scratch_mkfs_sized $((50 * 1024 * 1024)) >> $seqres.full 2>&1
+# 512M
+_scratch_mkfs_sized $((512 * 1024 * 1024)) >> $seqres.full 2>&1
 _scratch_mount
 
 echo "Silence is golden"
diff --git a/tests/xfs/227 b/tests/xfs/227
index cd927dc4..5f5f519e 100755
--- a/tests/xfs/227
+++ b/tests/xfs/227
@@ -122,7 +122,7 @@ create_target_attr_last()
 }
 
 # use a small filesystem so we can control freespace easily
-_scratch_mkfs_sized $((50 * 1024 * 1024)) >> $seqres.full 2>&1
+_scratch_mkfs_sized $((512 * 1024 * 1024)) >> $seqres.full 2>&1
 _scratch_mount
 fragment_freespace
 
diff --git a/tests/xfs/233 b/tests/xfs/233
index 2b2b8666..573b7a17 100755
--- a/tests/xfs/233
+++ b/tests/xfs/233
@@ -18,7 +18,7 @@ _require_xfs_scratch_rmapbt
 _require_no_large_scratch_dev
 
 echo "Format and mount"
-_scratch_mkfs_sized $((2 * 4096 * 4096)) > $seqres.full 2>&1
+_scratch_mkfs_sized $((32 * 4096 * 4096)) > $seqres.full 2>&1
 _scratch_mount >> $seqres.full 2>&1
 
 testdir=$SCRATCH_MNT/test-$seq
-- 
2.31.1

