Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAC7EFA3742
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Oct 2022 17:42:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230391AbiJ1Rmi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 28 Oct 2022 13:42:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230400AbiJ1RmR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Oct 2022 13:42:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C70CA22C46A;
        Fri, 28 Oct 2022 10:42:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5E7A0B82C11;
        Fri, 28 Oct 2022 17:42:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00313C433D6;
        Fri, 28 Oct 2022 17:41:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666978920;
        bh=9YFaC+15HX6mGO+gDFXUc64KJM4rKw+uq8kvdyNHwXU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=al8wQxojd4CQWHm2sfjZuGcjqtAvXFyaoGpxtU1h9wx9IPEnjeecGg2U2c45Iahtj
         CBOdPkr8+i9lpAoNFSaIZSjBg7AyYyYfLRuNFhGivZXd/7w6szVok+itmUqfONQDET
         3mv6u7FkuLxIvinyl22BJsAvmF0Dfhg5mq7EsQ6Ddn/70Byq6FuyHsJyK6o0Rs7ADG
         4jWOj+swCqkuylXJl6a7RvmraHhHS9JHDVqidr1wUwKkBHTIIkj7Vyis66M68B3I3S
         tpKwTLoaPS2fgqMUtVsf03ZByYNhBmZLGeb6QospBxS7RrRGrE6izPGwc3gsYgjKHJ
         p+wNe1QlJffaA==
Subject: [PATCH 2/4] xfs: refactor filesystem directory block size extraction
 logic
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 28 Oct 2022 10:41:59 -0700
Message-ID: <166697891959.4183768.4250658285402219552.stgit@magnolia>
In-Reply-To: <166697890818.4183768.10822596619783607332.stgit@magnolia>
References: <166697890818.4183768.10822596619783607332.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

There are a lot of places where we open-code determining the directory
block size for a specific filesystem.  Refactor this into a single
helper to clean up existing tests.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/populate |    4 ++--
 common/xfs      |    9 +++++++++
 tests/xfs/099   |    2 +-
 tests/xfs/100   |    2 +-
 tests/xfs/101   |    2 +-
 tests/xfs/102   |    2 +-
 tests/xfs/105   |    2 +-
 tests/xfs/112   |    2 +-
 tests/xfs/113   |    2 +-
 9 files changed, 18 insertions(+), 9 deletions(-)


diff --git a/common/populate b/common/populate
index 9fa1a06798..23b2fecf69 100644
--- a/common/populate
+++ b/common/populate
@@ -175,7 +175,7 @@ _scratch_xfs_populate() {
 	_xfs_force_bdev data $SCRATCH_MNT
 
 	blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
-	dblksz="$($XFS_INFO_PROG "${SCRATCH_MNT}" | grep naming.*bsize | sed -e 's/^.*bsize=//g' -e 's/\([0-9]*\).*$/\1/g')"
+	dblksz="$(_xfs_get_dir_blocksize "$SCRATCH_MNT")"
 	crc="$(_xfs_has_feature "$SCRATCH_MNT" crc -v)"
 	if [ $crc -eq 1 ]; then
 		leaf_hdr_size=64
@@ -602,7 +602,7 @@ _scratch_xfs_populate_check() {
 	is_reflink=$(_xfs_has_feature "$SCRATCH_MNT" reflink -v)
 
 	blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
-	dblksz="$($XFS_INFO_PROG "${SCRATCH_MNT}" | grep naming.*bsize | sed -e 's/^.*bsize=//g' -e 's/\([0-9]*\).*$/\1/g')"
+	dblksz="$(_xfs_get_dir_blocksize "$SCRATCH_MNT")"
 	leaf_lblk="$((32 * 1073741824 / blksz))"
 	node_lblk="$((64 * 1073741824 / blksz))"
 	umount "${SCRATCH_MNT}"
diff --git a/common/xfs b/common/xfs
index b2ac78de0c..9b6575b5f2 100644
--- a/common/xfs
+++ b/common/xfs
@@ -194,6 +194,15 @@ _xfs_get_file_block_size()
 	$XFS_INFO_PROG "$path" | grep realtime | sed -e 's/^.*extsz=\([0-9]*\).*$/\1/g'
 }
 
+# Get the directory block size of a mounted filesystem.
+_xfs_get_dir_blocksize()
+{
+	local fs="$1"
+
+	$XFS_INFO_PROG "$fs" | grep 'naming.*bsize' | \
+		sed -e 's/^.*bsize=//g' -e 's/\([0-9]*\).*$/\1/g'
+}
+
 # Set or clear the realtime status of every supplied path.  The first argument
 # is either 'data' or 'realtime'.  All other arguments should be paths to
 # existing directories or empty regular files.
diff --git a/tests/xfs/099 b/tests/xfs/099
index a7eaff6e0c..82bef8ad26 100755
--- a/tests/xfs/099
+++ b/tests/xfs/099
@@ -37,7 +37,7 @@ _scratch_mkfs_xfs > /dev/null
 
 echo "+ mount fs image"
 _scratch_mount
-dblksz="$($XFS_INFO_PROG "${SCRATCH_MNT}" | grep naming.*bsize | sed -e 's/^.*bsize=//g' -e 's/\([0-9]*\).*$/\1/g')"
+dblksz=$(_xfs_get_dir_blocksize "$SCRATCH_MNT")
 nr="$((dblksz / 40))"
 blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
 leaf_lblk="$((32 * 1073741824 / blksz))"
diff --git a/tests/xfs/100 b/tests/xfs/100
index 79da8cb02c..e638b4ba17 100755
--- a/tests/xfs/100
+++ b/tests/xfs/100
@@ -37,7 +37,7 @@ _scratch_mkfs_xfs > /dev/null
 
 echo "+ mount fs image"
 _scratch_mount
-dblksz="$($XFS_INFO_PROG "${SCRATCH_MNT}" | grep naming.*bsize | sed -e 's/^.*bsize=//g' -e 's/\([0-9]*\).*$/\1/g')"
+dblksz=$(_xfs_get_dir_blocksize "$SCRATCH_MNT")
 nr="$((dblksz / 12))"
 blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
 leaf_lblk="$((32 * 1073741824 / blksz))"
diff --git a/tests/xfs/101 b/tests/xfs/101
index 64f4705aca..11ed329110 100755
--- a/tests/xfs/101
+++ b/tests/xfs/101
@@ -37,7 +37,7 @@ _scratch_mkfs_xfs > /dev/null
 
 echo "+ mount fs image"
 _scratch_mount
-dblksz="$($XFS_INFO_PROG "${SCRATCH_MNT}" | grep naming.*bsize | sed -e 's/^.*bsize=//g' -e 's/\([0-9]*\).*$/\1/g')"
+dblksz=$(_xfs_get_dir_blocksize "$SCRATCH_MNT")
 nr="$((dblksz / 12))"
 blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
 leaf_lblk="$((32 * 1073741824 / blksz))"
diff --git a/tests/xfs/102 b/tests/xfs/102
index 24dce43058..43f4539181 100755
--- a/tests/xfs/102
+++ b/tests/xfs/102
@@ -37,7 +37,7 @@ _scratch_mkfs_xfs > /dev/null
 
 echo "+ mount fs image"
 _scratch_mount
-dblksz="$($XFS_INFO_PROG "${SCRATCH_MNT}" | grep naming.*bsize | sed -e 's/^.*bsize=//g' -e 's/\([0-9]*\).*$/\1/g')"
+dblksz=$(_xfs_get_dir_blocksize "$SCRATCH_MNT")
 nr="$((16 * dblksz / 40))"
 blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
 leaf_lblk="$((32 * 1073741824 / blksz))"
diff --git a/tests/xfs/105 b/tests/xfs/105
index 22a8bf9fb0..002a712883 100755
--- a/tests/xfs/105
+++ b/tests/xfs/105
@@ -37,7 +37,7 @@ _scratch_mkfs_xfs > /dev/null
 
 echo "+ mount fs image"
 _scratch_mount
-dblksz="$($XFS_INFO_PROG "${SCRATCH_MNT}" | grep naming.*bsize | sed -e 's/^.*bsize=//g' -e 's/\([0-9]*\).*$/\1/g')"
+dblksz=$(_xfs_get_dir_blocksize "$SCRATCH_MNT")
 nr="$((16 * dblksz / 40))"
 blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
 leaf_lblk="$((32 * 1073741824 / blksz))"
diff --git a/tests/xfs/112 b/tests/xfs/112
index bc1ab62895..e2d5932da6 100755
--- a/tests/xfs/112
+++ b/tests/xfs/112
@@ -37,7 +37,7 @@ _scratch_mkfs_xfs > /dev/null
 
 echo "+ mount fs image"
 _scratch_mount
-dblksz="$($XFS_INFO_PROG "${SCRATCH_MNT}" | grep naming.*bsize | sed -e 's/^.*bsize=//g' -e 's/\([0-9]*\).*$/\1/g')"
+dblksz=$(_xfs_get_dir_blocksize "$SCRATCH_MNT")
 nr="$((16 * dblksz / 40))"
 blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
 leaf_lblk="$((32 * 1073741824 / blksz))"
diff --git a/tests/xfs/113 b/tests/xfs/113
index e820ed96da..9bb2cd304b 100755
--- a/tests/xfs/113
+++ b/tests/xfs/113
@@ -37,7 +37,7 @@ _scratch_mkfs_xfs > /dev/null
 
 echo "+ mount fs image"
 _scratch_mount
-dblksz="$($XFS_INFO_PROG "${SCRATCH_MNT}" | grep naming.*bsize | sed -e 's/^.*bsize=//g' -e 's/\([0-9]*\).*$/\1/g')"
+dblksz=$(_xfs_get_dir_blocksize "$SCRATCH_MNT")
 nr="$((128 * dblksz / 40))"
 blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
 leaf_lblk="$((32 * 1073741824 / blksz))"

