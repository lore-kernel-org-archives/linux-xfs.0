Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:37998 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726038AbfCDVTq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Mar 2019 16:19:46 -0500
Subject: [PATCH 5/5] populate: force large finobt creation on xfs
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 04 Mar 2019 13:19:41 -0800
Message-ID: <155173438168.767.3984211596797515595.stgit@magnolia>
In-Reply-To: <155173434205.767.15128498725168844621.stgit@magnolia>
References: <155173434205.767.15128498725168844621.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: guaneryu@gmail.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Teach the populate routines to create enough inodes that we end up with
multi-level inode btrees.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 common/populate |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)


diff --git a/common/populate b/common/populate
index d49fbc29..95953476 100644
--- a/common/populate
+++ b/common/populate
@@ -260,6 +260,21 @@ _scratch_xfs_populate() {
 	$XFS_IO_PROG -f -c "pwrite -S 0x62 0 $((blksz * nr))" "${SCRATCH_MNT}/BNOBT"
 	./src/punch-alternating "${SCRATCH_MNT}/BNOBT"
 
+	# Inode btree
+	echo "+ inobt btree"
+	local ino_per_rec=64
+	local rec_per_btblock=16
+	local nr="$(( 2 * (blksz / rec_per_btblock) * ino_per_rec ))"
+	local dir="${SCRATCH_MNT}/INOBT"
+	mkdir -p "${dir}"
+	seq 0 "${nr}" | while read f; do
+		touch "${dir}/${f}"
+	done
+
+	seq 0 "$((ino_per_rec + 1))" "${nr}" | while read f; do
+		rm -f "${dir}/${f}"
+	done
+
 	# Reverse-mapping btree
 	is_rmapbt="$($XFS_INFO_PROG "${SCRATCH_MNT}" | grep -c 'rmapbt=1')"
 	if [ $is_rmapbt -gt 0 ]; then
@@ -562,6 +577,8 @@ _scratch_xfs_populate_check() {
 	__populate_check_xfs_aformat "${btree_attr}" "btree"
 	__populate_check_xfs_agbtree_height "bno"
 	__populate_check_xfs_agbtree_height "cnt"
+	__populate_check_xfs_agbtree_height "ino"
+	test $is_finobt -ne 0 && __populate_check_xfs_agbtree_height "fino"
 	test $is_rmapbt -ne 0 && __populate_check_xfs_agbtree_height "rmap"
 	test $is_reflink -ne 0 && __populate_check_xfs_agbtree_height "refcnt"
 }
