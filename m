Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:38141 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750935AbcKEARm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Nov 2016 20:17:42 -0400
Subject: [PATCH 4/9] populate: fix some silly errors when modifying a fs
 while fuzzing
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 04 Nov 2016 17:17:35 -0700
Message-ID: <147830505553.1919.3040999600042003549.stgit@birch.djwong.org>
In-Reply-To: <147830503054.1919.4998804611100937975.stgit@birch.djwong.org>
References: <147830503054.1919.4998804611100937975.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, eguan@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

There were some silly errors in _scratch_fuzz_modify such that it
wasn't really doing much of anything because of undefined variables.
(Sloppy refactoring when converting xfsfuzz.sh into xfstests.)

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 common/populate |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)


diff --git a/common/populate b/common/populate
index 5d451e3..d2df121 100644
--- a/common/populate
+++ b/common/populate
@@ -590,7 +590,7 @@ _scratch_populate() {
 		_scratch_xfs_populate
 		_scratch_xfs_populate_check
 		;;
-	"ext4")
+	"ext2"|"ext3"|"ext4")
 		_scratch_ext4_populate
 		_scratch_ext4_populate_check
 		;;
@@ -606,22 +606,24 @@ _scratch_fuzz_modify() {
 
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

