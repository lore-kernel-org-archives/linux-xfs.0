Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:52602 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726549AbeJaC6C (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Oct 2018 22:58:02 -0400
Subject: [PATCH 1/3] populate: create leafn dir when populating xfs
 filesystem
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 30 Oct 2018 11:03:28 -0700
Message-ID: <154092260885.14882.10714249211090490549.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: guaneryu@gmail.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

We've had some problems lately with directories containing a single
leafn directory.  It turns out that the populate script doesn't create
these, so teach it to do so.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 common/populate |   15 +++++++++++++++
 1 file changed, 15 insertions(+)


diff --git a/common/populate b/common/populate
index 8c08f516..610425f9 100644
--- a/common/populate
+++ b/common/populate
@@ -136,6 +136,12 @@ _scratch_xfs_populate() {
 	_scratch_mount
 	blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
 	dblksz="$($XFS_INFO_PROG "${SCRATCH_MNT}" | grep naming.*bsize | sed -e 's/^.*bsize=//g' -e 's/\([0-9]*\).*$/\1/g')"
+	crc="$($XFS_INFO_PROG "${SCRATCH_MNT}" | grep crc= | sed -e 's/^.*crc=//g' -e 's/\([0-9]*\).*$/\1/g')"
+	if [ $crc -eq 1 ]; then
+		leaf_hdr_size=64
+	else
+		leaf_hdr_size=16
+	fi
 	leaf_lblk="$((32 * 1073741824 / blksz))"
 	node_lblk="$((64 * 1073741824 / blksz))"
 
@@ -171,6 +177,10 @@ _scratch_xfs_populate() {
 	echo "+ leaf dir"
 	__populate_create_dir "${SCRATCH_MNT}/S_IFDIR.FMT_LEAF" "$((dblksz / 12))"
 
+	# - LEAFN
+	echo "+ leafn dir"
+	__populate_create_dir "${SCRATCH_MNT}/S_IFDIR.FMT_LEAFN" "$(( ((dblksz - leaf_hdr_size) / 8) - 3 ))"
+
 	# - NODE
 	echo "+ node dir"
 	__populate_create_dir "${SCRATCH_MNT}/S_IFDIR.FMT_NODE" "$((16 * dblksz / 40))" true
@@ -433,6 +443,9 @@ __populate_check_xfs_dir() {
 	"leaf")
 		(test "${datab}" -eq 1 && test "${leafb}" -eq 1 && test "${freeb}" -eq 0) || _fail "failed to create ${dtype} dir ino ${inode} datab ${datab} leafb ${leafb} freeb ${freeb}"
 		;;
+	"leafn")
+		_scratch_xfs_db -x -c "inode ${inode}" -c "dblock ${leaf_lblk}" -c "p lhdr.info.hdr.magic" | egrep -q '(0x3dff|0xd2ff)' || _fail "failed to create ${dtype} dir ino ${inode} datab ${datab} leafb ${leafb} freeb ${freeb}"
+		;;
 	"node"|"btree")
 		(test "${datab}" -eq 1 && test "${leafb}" -eq 1 && test "${freeb}" -eq 1) || _fail "failed to create ${dtype} dir ino ${inode} datab ${datab} leafb ${leafb} freeb ${freeb}"
 		;;
@@ -508,6 +521,7 @@ _scratch_xfs_populate_check() {
 	inline_dir="$(__populate_find_inode "${SCRATCH_MNT}/S_IFDIR.FMT_INLINE")"
 	block_dir="$(__populate_find_inode "${SCRATCH_MNT}/S_IFDIR.FMT_BLOCK")"
 	leaf_dir="$(__populate_find_inode "${SCRATCH_MNT}/S_IFDIR.FMT_LEAF")"
+	leafn_dir="$(__populate_find_inode "${SCRATCH_MNT}/S_IFDIR.FMT_LEAFN")"
 	node_dir="$(__populate_find_inode "${SCRATCH_MNT}/S_IFDIR.FMT_NODE")"
 	btree_dir="$(__populate_find_inode "${SCRATCH_MNT}/S_IFDIR.FMT_BTREE")"
 	local_slink="$(__populate_find_inode "${SCRATCH_MNT}/S_IFLNK.FMT_LOCAL")"
@@ -533,6 +547,7 @@ _scratch_xfs_populate_check() {
 	__populate_check_xfs_dir "${inline_dir}" "inline"
 	__populate_check_xfs_dir "${block_dir}" "block"
 	__populate_check_xfs_dir "${leaf_dir}" "leaf"
+	__populate_check_xfs_dir "${leafn_dir}" "leafn"
 	__populate_check_xfs_dir "${node_dir}" "node"
 	__populate_check_xfs_dir "${btree_dir}" "btree"
 	__populate_check_xfs_dformat "${btree_dir}" "btree"
