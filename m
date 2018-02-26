Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:44030 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752363AbeBZI0n (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Feb 2018 03:26:43 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w1Q8MXuR002089
        for <linux-xfs@vger.kernel.org>; Mon, 26 Feb 2018 08:26:43 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2120.oracle.com with ESMTP id 2gcdywr563-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 26 Feb 2018 08:26:43 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w1Q8QfnV024253
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Mon, 26 Feb 2018 08:26:42 GMT
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w1Q8QfJp006350
        for <linux-xfs@vger.kernel.org>; Mon, 26 Feb 2018 08:26:41 GMT
From: Shan Hai <shan.hai@oracle.com>
Subject: [PATCH 1/1] xfs: update the output of AG metadata corruption checking and repair tests
Date: Mon, 26 Feb 2018 16:26:13 +0800
Message-Id: <1519633573-7807-1-git-send-email-shan.hai@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

The xfs/087 and xfs/097 fail after the introduction of the
"xfs: set up per-AG free space reservations" in the kernel code,
because the filesystem is shutdown by the per-AG metadata reservation
code on the -EFSCORRUPTED error, the above mentioned tests initiate
the -EFSCORRUPTED error intentionally but its results checking part is
out of date and cause the failure of the tests.

Update the output of the tests to match with the current kernel behavior.

Signed-off-by: Shan Hai <shan.hai@oracle.com>
---
 tests/xfs/087     | 32 ++++++++++++++++----------------
 tests/xfs/087.out | 26 ++++++++++++++------------
 tests/xfs/097     | 32 ++++++++++++++++----------------
 tests/xfs/097.out | 26 ++++++++++++++------------
 4 files changed, 60 insertions(+), 56 deletions(-)

diff --git a/tests/xfs/087 b/tests/xfs/087
index 58ba958..d557c12 100755
--- a/tests/xfs/087
+++ b/tests/xfs/087
@@ -58,14 +58,14 @@ rm -f $seqres.full
 TESTDIR="${SCRATCH_MNT}/scratchdir"
 TESTFILE="${TESTDIR}/testfile"
 
-echo "+ create scratch fs"
+echo "create scratch fs"
 _scratch_mkfs_xfs > /dev/null
 
-echo "+ mount fs image"
+echo "mount fs image"
 _scratch_mount
 blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
 
-echo "+ make some files"
+echo "make some files"
 mkdir -p "${TESTDIR}"
 for x in `seq 1 1024`; do
 	touch "${SCRATCH_MNT}/junk.${x}"
@@ -80,45 +80,45 @@ for x in `seq 2 64`; do
 done
 inode="$(stat -c '%i' "${TESTFILE}.1")"
 agcount="$(xfs_info "${SCRATCH_MNT}" | grep agcount= | sed -e 's/^.*agcount=\([0-9]*\),.*$/\1/g')"
-umount "${SCRATCH_MNT}"
+_scratch_unmount
 
-echo "+ check fs"
+echo "check fs"
 _scratch_xfs_repair -n >> $seqres.full 2>&1 || _fail "xfs_repair should not fail"
 
-echo "+ corrupt image"
+echo "corrupt image"
 for ag in $(seq 1 $((agcount - 1))) 0; do
 	_scratch_xfs_db -x -c "agi ${ag}" -c "agi ${ag}" -c "stack" -c "blocktrash -x 32 -o +64 -y 4096 -z ${FUZZ_ARGS}" >> $seqres.full 2>&1
 done
 
-echo "+ mount image"
-_scratch_mount
+echo "mount image"
+_try_scratch_mount 2>&1 | _filter_error_mount
 
-echo "+ modify files"
+echo "modify files"
 broken=0
 for x in `seq 65 70`; do
 	touch "${TESTFILE}.${x}" 2> /dev/null || broken=1
 done
 echo "broken: ${broken}"
-umount "${SCRATCH_MNT}"
+_scratch_unmount 2>&1 | _filter_scratch
 
-echo "+ repair fs"
+echo "repair fs"
 _scratch_xfs_repair >> $seqres.full 2>&1
 
-echo "+ mount image (2)"
+echo "mount image (2)"
 _scratch_mount
 
-echo "+ chattr -R -i"
+echo "chattr -R -i"
 $CHATTR_PROG -R -f -i "${SCRATCH_MNT}/"
 
-echo "+ modify files (2)"
+echo "modify files (2)"
 broken=0
 for x in `seq 65 70`; do
 	touch "${TESTFILE}.${x}" || broken=1
 done
 echo "broken: ${broken}"
-umount "${SCRATCH_MNT}"
+_scratch_unmount
 
-echo "+ check fs (2)"
+echo "check fs (2)"
 _scratch_xfs_repair -n >> $seqres.full 2>&1 || _fail "xfs_repair should not fail"
 
 status=0
diff --git a/tests/xfs/087.out b/tests/xfs/087.out
index 1f6e0b5..c4aee5a 100644
--- a/tests/xfs/087.out
+++ b/tests/xfs/087.out
@@ -1,15 +1,17 @@
 QA output created by 087
-+ create scratch fs
-+ mount fs image
-+ make some files
-+ check fs
-+ corrupt image
-+ mount image
-+ modify files
+create scratch fs
+mount fs image
+make some files
+check fs
+corrupt image
+mount image
+mount: Structure needs cleaning
+modify files
 broken: 1
-+ repair fs
-+ mount image (2)
-+ chattr -R -i
-+ modify files (2)
+umount: SCRATCH_DEV: not mounted.
+repair fs
+mount image (2)
+chattr -R -i
+modify files (2)
 broken: 0
-+ check fs (2)
+check fs (2)
diff --git a/tests/xfs/097 b/tests/xfs/097
index 303ad04..4d6fda5 100755
--- a/tests/xfs/097
+++ b/tests/xfs/097
@@ -60,15 +60,15 @@ rm -f $seqres.full
 TESTDIR="${SCRATCH_MNT}/scratchdir"
 TESTFILE="${TESTDIR}/testfile"
 
-echo "+ create scratch fs"
+echo "create scratch fs"
 _scratch_mkfs_xfs > /dev/null
 
-echo "+ mount fs image"
+echo "mount fs image"
 _scratch_mount
 xfs_info "${SCRATCH_MNT}" | grep -q "finobt=1" || _notrun "finobt not enabled"
 blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
 
-echo "+ make some files"
+echo "make some files"
 mkdir -p "${TESTDIR}"
 for x in `seq 1 1024`; do
 	touch "${SCRATCH_MNT}/junk.${x}"
@@ -83,45 +83,45 @@ for x in `seq 2 64`; do
 done
 inode="$(stat -c '%i' "${TESTFILE}.1")"
 agcount="$(xfs_info "${SCRATCH_MNT}" | grep agcount= | sed -e 's/^.*agcount=\([0-9]*\),.*$/\1/g')"
-umount "${SCRATCH_MNT}"
+_scratch_unmount 2>&1 | _filter_scratch
 
-echo "+ check fs"
+echo "check fs"
 _scratch_xfs_repair -n >> $seqres.full 2>&1 || _fail "xfs_repair should not fail"
 
-echo "+ corrupt image"
+echo "corrupt image"
 for ag in $(seq 1 $((agcount - 1))) 0; do
 	_scratch_xfs_db -x -c "agi ${ag}" -c "agi ${ag}" -c "addr free_root" -c "stack" -c "blocktrash -x 32 -y $((blksz * 8)) -z ${FUZZ_ARGS}" >> $seqres.full 2>&1
 done
 
-echo "+ mount image"
-_scratch_mount
+echo "mount image"
+_try_scratch_mount 2>&1 | _filter_error_mount
 
-echo "+ modify files"
+echo "modify files"
 broken=0
 for x in `seq 65 70`; do
 	touch "${TESTFILE}.${x}" 2> /dev/null || broken=1
 done
 echo "broken: ${broken}"
-umount "${SCRATCH_MNT}"
+_scratch_unmount 2>&1 | _filter_scratch
 
-echo "+ repair fs"
+echo "repair fs"
 _scratch_xfs_repair >> $seqres.full 2>&1
 
-echo "+ mount image (2)"
+echo "mount image (2)"
 _scratch_mount
 
-echo "+ chattr -R -i"
+echo "chattr -R -i"
 $CHATTR_PROG -R -f -i "${SCRATCH_MNT}/"
 
-echo "+ modify files (2)"
+echo "modify files (2)"
 broken=0
 for x in `seq 65 70`; do
 	touch "${TESTFILE}.${x}" || broken=1
 done
 echo "broken: ${broken}"
-umount "${SCRATCH_MNT}"
+_scratch_unmount
 
-echo "+ check fs (2)"
+echo "check fs (2)"
 _scratch_xfs_repair -n >> $seqres.full 2>&1 || _fail "xfs_repair should not fail"
 
 status=0
diff --git a/tests/xfs/097.out b/tests/xfs/097.out
index 84f6a70..0eb2085 100644
--- a/tests/xfs/097.out
+++ b/tests/xfs/097.out
@@ -1,15 +1,17 @@
 QA output created by 097
-+ create scratch fs
-+ mount fs image
-+ make some files
-+ check fs
-+ corrupt image
-+ mount image
-+ modify files
+create scratch fs
+mount fs image
+make some files
+check fs
+corrupt image
+mount image
+mount: Structure needs cleaning
+modify files
 broken: 1
-+ repair fs
-+ mount image (2)
-+ chattr -R -i
-+ modify files (2)
+umount: SCRATCH_DEV: not mounted.
+repair fs
+mount image (2)
+chattr -R -i
+modify files (2)
 broken: 0
-+ check fs (2)
+check fs (2)
-- 
2.7.4

