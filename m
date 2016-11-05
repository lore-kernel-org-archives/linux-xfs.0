Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:38121 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750935AbcKEARf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Nov 2016 20:17:35 -0400
Subject: [PATCH 3/9] populate: optionally fill the filesystem when
 populating fs
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 04 Nov 2016 17:17:29 -0700
Message-ID: <147830504936.1919.13567740350388016487.stgit@birch.djwong.org>
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

Be a little more flexible in how much we fill up a pre-populated
filesystem.  For the field fuzzing tests, we don't need the extra
space/inode usage and therefore won't want much at all.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 common/populate |   35 ++++++++++++++++++++++++++++-------
 1 file changed, 28 insertions(+), 7 deletions(-)


diff --git a/common/populate b/common/populate
index 2ac2c22..5d451e3 100644
--- a/common/populate
+++ b/common/populate
@@ -73,26 +73,39 @@ __populate_create_attr() {
 	done
 }
 
-# Fill up 60% of the remaining free space
+# Fill up some percentage of the remaining free space
 __populate_fill_fs() {
 	dir="$1"
 	pct="$2"
 	test -z "${pct}" && pct=60
 
-	SRC_SZ="$(du -ks "${SRCDIR}" | cut -f 1)"
+	mkdir -p "${dir}/test/1"
+	cp -pRdu "${dir}"/S_IFREG* "${dir}/test/1/"
+
+	SRC_SZ="$(du -ks "${dir}/test/1" | cut -f 1)"
 	FS_SZ="$(( $(stat -f "${dir}" -c '%a * %S') / 1024 ))"
 
 	NR="$(( (FS_SZ * ${pct} / 100) / SRC_SZ ))"
-	test "${NR}" -lt 1 && NR=1
 
-	seq 1 "${NR}" | while read nr; do
-		cp -pRdu "${SRCDIR}" "${dir}/test.${nr}" >> $seqres.full 2>&1
+	echo "FILL FS"
+	echo "src_sz $SRC_SZ fs_sz $FS_SZ nr $NR"
+	seq 2 "${NR}" | while read nr; do
+		cp -pRdu "${dir}/test/1" "${dir}/test/${nr}"
 	done
 }
 
 # Populate an XFS on the scratch device with (we hope) all known
 # types of metadata block
 _scratch_xfs_populate() {
+	fill=1
+
+	for arg in $@; do
+		case "${arg}" in
+		"nofill")
+			fill=0;;
+		esac
+	done
+
 	_scratch_mount
 	blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
 	dblksz="$(xfs_info "${SCRATCH_MNT}" | grep naming.*bsize | sed -e 's/^.*bsize=//g' -e 's/\([0-9]*\).*$/\1/g')"
@@ -227,6 +240,15 @@ _scratch_xfs_populate() {
 # Populate an ext4 on the scratch device with (we hope) all known
 # types of metadata block
 _scratch_ext4_populate() {
+	fill=1
+
+	for arg in $@; do
+		case "${arg}" in
+		"nofill")
+			fill=0;;
+		esac
+	done
+
 	_scratch_mount
 	blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
 	dblksz="${blksz}"
@@ -294,8 +316,7 @@ _scratch_ext4_populate() {
 
 	# Copy some real files (xfs tests, I guess...)
 	echo "+ real files"
-	__populate_fill_fs "${SCRATCH_MNT}"
-	cp -pRdu --reflink=always "${SCRATCH_MNT}/S_IFREG.FMT_ETREE" "${SCRATCH_MNT}/S_IREG.FMT_ETREE.REFLINK" 2> /dev/null
+	test $fill -ne 0 && __populate_fill_fs "${SCRATCH_MNT}" 5
 
 	umount "${SCRATCH_MNT}"
 }

