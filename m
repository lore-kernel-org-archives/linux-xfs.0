Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:20788 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751161AbdAUIKv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 21 Jan 2017 03:10:51 -0500
Subject: [PATCH 4/9] populate: fix some silly errors when modifying a fs
 while fuzzing
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 21 Jan 2017 00:10:44 -0800
Message-ID: <148498624430.17109.15974367384561217234.stgit@birch.djwong.org>
In-Reply-To: <148498621936.17109.4249711513404036449.stgit@birch.djwong.org>
References: <148498621936.17109.4249711513404036449.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: eguan@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

There were some silly errors in _scratch_fuzz_modify such that it
wasn't really doing much of anything because of undefined variables.
(Sloppy refactoring when converting xfsfuzz.sh into xfstests.)

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 common/populate |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)


diff --git a/common/populate b/common/populate
index 23a8ffd..1afab46 100644
--- a/common/populate
+++ b/common/populate
@@ -596,7 +596,7 @@ _scratch_populate() {
 		_scratch_xfs_populate
 		_scratch_xfs_populate_check
 		;;
-	"ext4")
+	"ext2"|"ext3"|"ext4")
 		_scratch_ext4_populate
 		_scratch_ext4_populate_check
 		;;
@@ -612,22 +612,24 @@ _scratch_fuzz_modify() {
 
 	test -z "${nr}" && nr=50000
 	echo "+++ touch ${nr} files"
-	$XFS_IO_PROG -f -c "pwrite -S 0x63 0 ${BLK_SZ}" "/tmp/afile" > /dev/null
+	blk_sz=$(stat -f -c '%s' ${SCRATCH_MNT})
+	$XFS_IO_PROG -f -c "pwrite -S 0x63 0 ${blk_sz}" "/tmp/afile" > /dev/null
 	date="$(date)"
 	find "${SCRATCH_MNT}/" -type f 2> /dev/null | head -n "${nr}" | while read f; do
 		setfattr -n "user.date" -v "${date}" "$f"
 		cat "/tmp/afile" >> "$f"
 		mv "$f" "$f.longer"
 	done
+	sync
 	rm -rf "/tmp/afile"
 
 	echo "+++ create files"
-	cp -pRdu "${SRCDIR}" "${SCRATCH_MNT}/test.moo"
+	mkdir -p "${SCRATCH_MNT}/test.moo"
+	$XFS_IO_PROG -f -c 'pwrite -S 0x80 0 65536' "${SCRATCH_MNT}/test.moo/urk"
 	sync
 
 	echo "+++ remove files"
 	rm -rf "${SCRATCH_MNT}/test.moo"
-	rm -rf "${SCRATCH_MNT}/test.1"
 }
 
 # Try to access files after fuzzing

