Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A611DC6370A
	for <linux-xfs@archiver.kernel.org>; Thu,  8 Dec 2022 07:29:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229703AbiLHH3P (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 8 Dec 2022 02:29:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229710AbiLHH3O (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 8 Dec 2022 02:29:14 -0500
Received: from out30-43.freemail.mail.aliyun.com (out30-43.freemail.mail.aliyun.com [115.124.30.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D98DD4667A;
        Wed,  7 Dec 2022 23:29:12 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R801e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046056;MF=ziyangzhang@linux.alibaba.com;NM=0;PH=DS;RN=8;SR=0;TI=SMTPD_---0VWpNSao_1670484548;
Received: from localhost.localdomain(mailfrom:ZiyangZhang@linux.alibaba.com fp:SMTPD_---0VWpNSao_1670484548)
          by smtp.aliyun-inc.com;
          Thu, 08 Dec 2022 15:29:09 +0800
From:   Ziyang Zhang <ZiyangZhang@linux.alibaba.com>
To:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Cc:     zlang@redhat.com, david@fromorbit.com, djwong@kernel.org,
        hsiangkao@linux.alibaba.com, allison.henderson@oracle.com,
        Ziyang Zhang <ZiyangZhang@linux.alibaba.com>
Subject: [PATCH V5 2/2] common/populate: Ensure that S_IFDIR.FMT_BTREE is in btree format
Date:   Thu,  8 Dec 2022 15:28:43 +0800
Message-Id: <20221208072843.1866615-3-ZiyangZhang@linux.alibaba.com>
X-Mailer: git-send-email 2.18.4
In-Reply-To: <20221208072843.1866615-1-ZiyangZhang@linux.alibaba.com>
References: <20221208072843.1866615-1-ZiyangZhang@linux.alibaba.com>
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

Reviewed-by: Zorro Lang <zlang@redhat.com>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Suggested-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Ziyang Zhang <ZiyangZhang@linux.alibaba.com>
---
 common/populate | 34 +++++++++++++++++++++++++++++++++-
 common/xfs      |  9 +++++++++
 2 files changed, 42 insertions(+), 1 deletion(-)

diff --git a/common/populate b/common/populate
index 6e004997..0d334a13 100644
--- a/common/populate
+++ b/common/populate
@@ -71,6 +71,37 @@ __populate_create_dir() {
 	done
 }
 
+# Create a large directory and ensure that it's a btree format
+__populate_xfs_create_btree_dir() {
+	local name="$1"
+	local isize="$2"
+	local missing="$3"
+	local icore_size="$(_xfs_inode_core_bytes)"
+	# We need enough extents to guarantee that the data fork is in
+	# btree format.  Cycling the mount to use xfs_db is too slow, so
+	# watch for when the extent count exceeds the space after the
+	# inode core.
+	local max_nextents="$(((isize - icore_size) / 16))"
+	local nr=0
+
+	mkdir -p "${name}"
+	while true; do
+		local creat=mkdir
+		test "$((nr % 20))" -eq 0 && creat=touch
+		$creat "${name}/$(printf "%.08d" "$nr")"
+		if [ "$((nr % 40))" -eq 0 ]; then
+			local nextents="$(_xfs_get_fsxattr nextents $name)"
+			[ $nextents -gt $max_nextents ] && break
+		fi
+		nr=$((nr+1))
+	done
+
+	test -z "${missing}" && return
+	seq 1 2 "${nr}" | while read d; do
+		rm -rf "${name}/$(printf "%.08d" "$d")"
+	done
+}
+
 # Add a bunch of attrs to a file
 __populate_create_attr() {
 	name="$1"
@@ -176,6 +207,7 @@ _scratch_xfs_populate() {
 
 	blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
 	dblksz="$(_xfs_get_dir_blocksize "$SCRATCH_MNT")"
+	isize="$(_xfs_get_inode_size "$SCRATCH_MNT")"
 	crc="$(_xfs_has_feature "$SCRATCH_MNT" crc -v)"
 	if [ $crc -eq 1 ]; then
 		leaf_hdr_size=64
@@ -226,7 +258,7 @@ _scratch_xfs_populate() {
 
 	# - BTREE
 	echo "+ btree dir"
-	__populate_create_dir "${SCRATCH_MNT}/S_IFDIR.FMT_BTREE" "$((128 * dblksz / 40))" true
+	__populate_xfs_create_btree_dir "${SCRATCH_MNT}/S_IFDIR.FMT_BTREE" "$isize" true
 
 	# Symlinks
 	# - FMT_LOCAL
diff --git a/common/xfs b/common/xfs
index 674384a9..7aaa63c7 100644
--- a/common/xfs
+++ b/common/xfs
@@ -1487,6 +1487,15 @@ _require_xfsrestore_xflag()
 			_notrun 'xfsrestore does not support -x flag.'
 }
 
+# Number of bytes reserved for a full inode record, which includes the
+# immediate fork areas.
+_xfs_get_inode_size()
+{
+	local mntpoint="$1"
+
+	$XFS_INFO_PROG "$mntpoint" | sed -n '/meta-data=.*isize/s/^.*isize=\([0-9]*\).*$/\1/p'
+}
+
 # Number of bytes reserved for only the inode record, excluding the
 # immediate fork areas.
 _xfs_get_inode_core_bytes()
-- 
2.18.4

