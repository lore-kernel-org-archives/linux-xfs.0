Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79AF2C4332F
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Dec 2022 09:37:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232637AbiLBJhS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 2 Dec 2022 04:37:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232591AbiLBJhR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Dec 2022 04:37:17 -0500
Received: from out199-11.us.a.mail.aliyun.com (out199-11.us.a.mail.aliyun.com [47.90.199.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1C0110B6;
        Fri,  2 Dec 2022 01:37:11 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R971e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046051;MF=ziyangzhang@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0VWDD4WH_1669973823;
Received: from localhost.localdomain(mailfrom:ZiyangZhang@linux.alibaba.com fp:SMTPD_---0VWDD4WH_1669973823)
          by smtp.aliyun-inc.com;
          Fri, 02 Dec 2022 17:37:08 +0800
From:   Ziyang Zhang <ZiyangZhang@linux.alibaba.com>
To:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Cc:     djwong@kernel.org, Ziyang Zhang <ZiyangZhang@linux.alibaba.com>,
        Gao Xiang <hsiangkao@linux.alibaba.com>
Subject: [PATCH V2] common/populate: Ensure that S_IFDIR.FMT_BTREE is in btree format
Date:   Fri,  2 Dec 2022 17:35:34 +0800
Message-Id: <20221202093534.940907-1-ZiyangZhang@linux.alibaba.com>
X-Mailer: git-send-email 2.18.4
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Sometimes "$((128 * dblksz / 40))" dirents cannot make sure that
S_IFDIR.FMT_BTREE could become btree format for its DATA fork.

Actually we just observed it can fail after apply our inode
extent-to-btree workaround. The root cause is that the kernel may be
too good at allocating consecutive blocks so that the data fork is
still in extents format.

Therefore instead of using a fixed number, let's make sure the number
of extents is large enough than (inode size - inode core size) /
sizeof(xfs_bmbt_rec_t).

Suggested-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Ziyang Zhang <ZiyangZhang@linux.alibaba.com>
---
V2: take Darrick's advice to cleanup code

 common/populate | 28 +++++++++++++++++++++++++++-
 common/xfs      | 17 +++++++++++++++++
 2 files changed, 44 insertions(+), 1 deletion(-)

diff --git a/common/populate b/common/populate
index 6e004997..c6b879fa 100644
--- a/common/populate
+++ b/common/populate
@@ -71,6 +71,31 @@ __populate_create_dir() {
 	done
 }
 
+# Create a large directory and ensure that it's a btree format
+__populate_xfs_create_btree_dir() {
+	local name="$1"
+	local isize="$2"
+	local icore_size=$(_xfs_inode_core_bytes)
+	# We need enough extents to guarantee that the data fork is in
+	# btree format.  Cycling the mount to use xfs_db is too slow, so
+	# watch for when the extent count exceeds the space after the
+	# inode core.
+	local max_nextents="$(((isize - 176) / 16))"
+
+	mkdir -p "${name}"
+	d=0
+	while true; do
+		creat=mkdir
+		test "$((d % 20))" -eq 0 && creat=touch
+		$creat "${name}/$(printf "%.08d" "$d")"
+		if [ "$((d % 40))" -eq 0 ]; then
+			nextents=$(_xfs_get_fsxattr nextents $name)
+			[ $nextents -gt $max_nextents ] && break
+		fi
+		d=$((d+1))
+	done
+}
+
 # Add a bunch of attrs to a file
 __populate_create_attr() {
 	name="$1"
@@ -176,6 +201,7 @@ _scratch_xfs_populate() {
 
 	blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
 	dblksz="$(_xfs_get_dir_blocksize "$SCRATCH_MNT")"
+	isize="$(_xfs_inode_size "$SCRATCH_MNT")"
 	crc="$(_xfs_has_feature "$SCRATCH_MNT" crc -v)"
 	if [ $crc -eq 1 ]; then
 		leaf_hdr_size=64
@@ -226,7 +252,7 @@ _scratch_xfs_populate() {
 
 	# - BTREE
 	echo "+ btree dir"
-	__populate_create_dir "${SCRATCH_MNT}/S_IFDIR.FMT_BTREE" "$((128 * dblksz / 40))" true
+	__populate_xfs_create_btree_dir "${SCRATCH_MNT}/S_IFDIR.FMT_BTREE" "$isize"
 
 	# Symlinks
 	# - FMT_LOCAL
diff --git a/common/xfs b/common/xfs
index 8ac1964e..0359e422 100644
--- a/common/xfs
+++ b/common/xfs
@@ -1486,3 +1486,20 @@ _require_xfsrestore_xflag()
 	$XFSRESTORE_PROG -h 2>&1 | grep -q -e '-x' || \
 			_notrun 'xfsrestore does not support -x flag.'
 }
+
+
+# Number of bytes reserved for a full inode record, which includes the
+# immediate fork areas.
+_xfs_inode_size()
+{
+	local mntpoint="$1"
+
+	$XFS_INFO_PROG "$mntpoint" | grep 'meta-data=.*isize' | sed -e 's/^.*isize=\([0-9]*\).*$/\1/g'
+}
+
+# Number of bytes reserved for only the inode record, excluding the
+# immediate fork areas.
+_xfs_inode_core_bytes()
+{
+	echo 176
+}
-- 
2.18.4

