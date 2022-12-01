Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E7E6C43217
	for <linux-xfs@archiver.kernel.org>; Thu,  1 Dec 2022 08:12:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229501AbiLAIMU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 1 Dec 2022 03:12:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbiLAIMT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Dec 2022 03:12:19 -0500
Received: from out30-57.freemail.mail.aliyun.com (out30-57.freemail.mail.aliyun.com [115.124.30.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB37B1D67D;
        Thu,  1 Dec 2022 00:12:17 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R301e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045170;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0VW7y28d_1669882328;
Received: from e18g06460.et15sqa.tbsite.net(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0VW7y28d_1669882328)
          by smtp.aliyun-inc.com;
          Thu, 01 Dec 2022 16:12:15 +0800
From:   Gao Xiang <hsiangkao@linux.alibaba.com>
To:     fstests <fstests@vger.kernel.org>, linux-xfs@vger.kernel.org
Cc:     Gao Xiang <hsiangkao@linux.alibaba.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Ziyang Zhang <ZiyangZhang@linux.alibaba.com>
Subject: [PATCH] common/populate: Ensure that S_IFDIR.FMT_BTREE is in btree format
Date:   Thu,  1 Dec 2022 16:12:08 +0800
Message-Id: <20221201081208.40147-1-hsiangkao@linux.alibaba.com>
X-Mailer: git-send-email 2.24.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
Cc: Ziyang Zhang <ZiyangZhang@linux.alibaba.com>
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
---
 common/populate | 22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/common/populate b/common/populate
index 6e004997..e179a300 100644
--- a/common/populate
+++ b/common/populate
@@ -71,6 +71,25 @@ __populate_create_dir() {
 	done
 }
 
+# Create a large directory and ensure that it's a btree format
+__populate_create_btree_dir() {
+	name="$1"
+	isize="$2"
+
+	mkdir -p "${name}"
+	d=0
+	while true; do
+		creat=mkdir
+		test "$((d % 20))" -eq 0 && creat=touch
+		$creat "${name}/$(printf "%.08d" "$d")"
+		if [ "$((d % 40))" -eq 0 ]; then
+			nexts="$($XFS_IO_PROG -c "stat" $name | grep 'fsxattr.nextents' | sed -e 's/^.*nextents = //g' -e 's/\([0-9]*\).*$/\1/g')"
+			[ "$nexts" -gt "$(((isize - 176) / 16))" ] && break
+		fi
+		d=$((d+1))
+	done
+}
+
 # Add a bunch of attrs to a file
 __populate_create_attr() {
 	name="$1"
@@ -176,6 +195,7 @@ _scratch_xfs_populate() {
 
 	blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
 	dblksz="$(_xfs_get_dir_blocksize "$SCRATCH_MNT")"
+	isize="$($XFS_INFO_PROG "${SCRATCH_MNT}" | grep meta-data=.*isize | sed -e 's/^.*isize=//g' -e 's/\([0-9]*\).*$/\1/g')"
 	crc="$(_xfs_has_feature "$SCRATCH_MNT" crc -v)"
 	if [ $crc -eq 1 ]; then
 		leaf_hdr_size=64
@@ -226,7 +246,7 @@ _scratch_xfs_populate() {
 
 	# - BTREE
 	echo "+ btree dir"
-	__populate_create_dir "${SCRATCH_MNT}/S_IFDIR.FMT_BTREE" "$((128 * dblksz / 40))" true
+	__populate_create_btree_dir "${SCRATCH_MNT}/S_IFDIR.FMT_BTREE" "$isize"
 
 	# Symlinks
 	# - FMT_LOCAL
-- 
2.24.4

