Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4354EECDFA1
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Oct 2022 19:06:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234664AbiJZTGb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 Oct 2022 15:06:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234680AbiJZTGN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Oct 2022 15:06:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC8FC11D998;
        Wed, 26 Oct 2022 12:03:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 48B9562059;
        Wed, 26 Oct 2022 19:03:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADA56C433B5;
        Wed, 26 Oct 2022 19:03:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666811011;
        bh=GobzXUV2rznZY1qpeZhliFRiMo8/IXRMXhz0Tsa58VQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=WRXXS7L/kn1tJFNY+YbS83nTbGTKVn41u3tKH5SaqVuPwb7r8pJnIbKFFm7fLGA96
         TGggenh8bR2NdqiqapNzCh3aeQQ1jHie13UJn2Yyy+AQnSG/BWsOM9ytnvTmho8oe6
         GOAae9RB2Hl6Pu+sONimAcae5C/znn5TY14BOL+wb0tFp/S0dyuBa8Di+4JCRM7h4K
         AoSFHe+H0xwyxZPMHmfvCzB06pBCACicezIub1HU6141+4C0xXY647lSFWiqMjex0n
         S5I3VkejFepSf426vM6RW9vYwOtctHQFSsl2DaJa22jYxg9Orx1NUPWwRWFpTMKVsM
         If4APvOx3AgNQ==
Subject: [PATCH 3/4] xfs: refactor filesystem realtime geometry detection
 logic
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Wed, 26 Oct 2022 12:03:31 -0700
Message-ID: <166681101124.3403789.14336511724230043966.stgit@magnolia>
In-Reply-To: <166681099421.3403789.78493769502226810.stgit@magnolia>
References: <166681099421.3403789.78493769502226810.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

There are a lot of places where we open-code detecting the realtime
extent size and extent count of a specific filesystem.  Refactor this
into a couple of helpers to clean up the code.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/populate |    2 +-
 common/xfs      |   31 +++++++++++++++++++++++++++++--
 tests/xfs/146   |    2 +-
 tests/xfs/147   |    2 +-
 tests/xfs/530   |    3 +--
 5 files changed, 33 insertions(+), 7 deletions(-)


diff --git a/common/populate b/common/populate
index 23b2fecf69..d9d4c6c300 100644
--- a/common/populate
+++ b/common/populate
@@ -323,7 +323,7 @@ _scratch_xfs_populate() {
 	fi
 
 	# Realtime Reverse-mapping btree
-	is_rt="$($XFS_INFO_PROG "${SCRATCH_MNT}" | grep -c 'rtextents=[1-9]')"
+	is_rt="$(_xfs_get_rtextents "$SCRATCH_MNT")"
 	if [ $is_rmapbt -gt 0 ] && [ $is_rt -gt 0 ]; then
 		echo "+ rtrmapbt btree"
 		nr="$((blksz * 2 / 32))"
diff --git a/common/xfs b/common/xfs
index 6445bfd9db..7c0f3eee19 100644
--- a/common/xfs
+++ b/common/xfs
@@ -174,6 +174,24 @@ _scratch_mkfs_xfs()
 	return $mkfs_status
 }
 
+# Get the number of realtime extents of a mounted filesystem.
+_xfs_get_rtextents()
+{
+	local path="$1"
+
+	$XFS_INFO_PROG "$path" | grep 'rtextents' | \
+		sed -e 's/^.*rtextents=\([0-9]*\).*$/\1/g'
+}
+
+# Get the realtime extent size of a mounted filesystem.
+_xfs_get_rtextsize()
+{
+	local path="$1"
+
+	$XFS_INFO_PROG "$path" | grep 'realtime.*extsz' | \
+		sed -e 's/^.*extsz=\([0-9]*\).*$/\1/g'
+}
+
 # Get the size of an allocation unit of a file.  Normally this is just the
 # block size of the file, but for realtime files, this is the realtime extent
 # size.
@@ -191,7 +209,7 @@ _xfs_get_file_block_size()
 	while ! $XFS_INFO_PROG "$path" &>/dev/null && [ "$path" != "/" ]; do
 		path="$(dirname "$path")"
 	done
-	$XFS_INFO_PROG "$path" | grep realtime | sed -e 's/^.*extsz=\([0-9]*\).*$/\1/g'
+	_xfs_get_rtextsize "$path"
 }
 
 # Decide if this path is a file on the realtime device
@@ -436,13 +454,22 @@ _require_xfs_crc()
 # third option is -v, echo 1 for success and 0 for not.
 #
 # Starting with xfsprogs 4.17, this also works for unmounted filesystems.
+# The feature 'realtime' looks for rtextents > 0.
 _xfs_has_feature()
 {
 	local fs="$1"
 	local feat="$2"
 	local verbose="$3"
+	local feat_regex="1"
 
-	local answer="$($XFS_INFO_PROG "$fs" 2>&1 | grep -w -c "$feat=1")"
+	case "$feat" in
+	"realtime")
+		feat="rtextents"
+		feat_regex="[1-9][0-9]*"
+		;;
+	esac
+
+	local answer="$($XFS_INFO_PROG "$fs" 2>&1 | grep -E -w -c "$feat=$feat_regex")"
 	if [ "$answer" -ne 0 ]; then
 		test "$verbose" = "-v" && echo 1
 		return 0
diff --git a/tests/xfs/146 b/tests/xfs/146
index 5516d396bf..123bdff59f 100755
--- a/tests/xfs/146
+++ b/tests/xfs/146
@@ -31,7 +31,7 @@ _scratch_mkfs > $seqres.full
 _scratch_mount >> $seqres.full
 
 blksz=$(_get_block_size $SCRATCH_MNT)
-rextsize=$($XFS_INFO_PROG $SCRATCH_MNT | grep realtime.*extsz | sed -e 's/^.*extsz=\([0-9]*\).*$/\1/g')
+rextsize=$(_xfs_get_rtextsize "$SCRATCH_MNT")
 rextblks=$((rextsize / blksz))
 
 echo "blksz $blksz rextsize $rextsize rextblks $rextblks" >> $seqres.full
diff --git a/tests/xfs/147 b/tests/xfs/147
index e21fdd330c..33b3c99633 100755
--- a/tests/xfs/147
+++ b/tests/xfs/147
@@ -29,7 +29,7 @@ _scratch_mkfs -r extsize=256k > $seqres.full
 _scratch_mount >> $seqres.full
 
 blksz=$(_get_block_size $SCRATCH_MNT)
-rextsize=$($XFS_INFO_PROG $SCRATCH_MNT | grep realtime.*extsz | sed -e 's/^.*extsz=\([0-9]*\).*$/\1/g')
+rextsize=$(_xfs_get_rtextsize "$SCRATCH_MNT")
 rextblks=$((rextsize / blksz))
 
 echo "blksz $blksz rextsize $rextsize rextblks $rextblks" >> $seqres.full
diff --git a/tests/xfs/530 b/tests/xfs/530
index c960738db7..56f5e7ebdb 100755
--- a/tests/xfs/530
+++ b/tests/xfs/530
@@ -73,8 +73,7 @@ _try_scratch_mount || _notrun "Couldn't mount fs with synthetic rt volume"
 formatted_blksz="$(_get_block_size $SCRATCH_MNT)"
 test "$formatted_blksz" -ne "$dbsize" && \
 	_notrun "Tried to format with $dbsize blocksize, got $formatted_blksz."
-$XFS_INFO_PROG $SCRATCH_MNT | grep -E -q 'realtime.*blocks=0' && \
-	_notrun "Filesystem should have a realtime volume"
+_require_xfs_has_feature "$SCRATCH_MNT" realtime
 
 echo "Consume free space"
 fillerdir=$SCRATCH_MNT/fillerdir

