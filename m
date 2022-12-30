Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62063C3DA7C
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 03:13:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236335AbiLaDNK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 22:13:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236334AbiLaDNI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 22:13:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49FD8FCD8;
        Fri, 30 Dec 2022 19:13:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CEE2E61D11;
        Sat, 31 Dec 2022 03:13:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31CC7C433D2;
        Sat, 31 Dec 2022 03:13:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672456386;
        bh=VZqkYzqcVJ4BNbT5Dw9NFgcKVqlCex7OsHFIvfLszCk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=hpxvrD6Gju2ca95g7RXeWldDtxQ9PixFORUs2CFSRQU5HoXrMu8uVKNCCCZfQSwjz
         gmKgTD1oUFHJDS44FBZIk0VHzLojh5ngh6SZ5iCwKK0xnDNPxnv34VQWI/XdgvvNvj
         1UJ7jZn3lKEKomrcH1CPFIzZBYeSdgBdBVaI8H13OGNIxWVU3dtFxfJwcBo7ZnueRy
         Rp5cXX+OcheG9V4jRxhjdwgzvcR2T6FC5UqCVvA3nowaD1z4A65QZ7kuoO6Q5BD653
         Jb4yFZL1YwsLYnevLGEDLIc7HDrJfOJUMsQjVtrg9IV2tQvXZDCDu2OVeol1I1C8Ql
         FX+EFzQfYUa8w==
Subject: [PATCH 02/13] fuzz: for fuzzing the rtrmapbt,
 find the path to the rt rmap btree file
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:20:44 -0800
Message-ID: <167243884421.739669.14830141556148374386.stgit@magnolia>
In-Reply-To: <167243884390.739669.13524725872131241203.stgit@magnolia>
References: <167243884390.739669.13524725872131241203.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

The fs population code creates a realtime rmap btree in /some/ realtime
group with at least two levels.  This rmapbt file isn't necessarily the
one for group 0, so we need to find it programmatically.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/xfs    |   33 +++++++++++++++++++++++++++++++++
 tests/xfs/406 |    6 ++++--
 tests/xfs/407 |    6 ++++--
 tests/xfs/408 |    7 +++++--
 tests/xfs/409 |    7 +++++--
 tests/xfs/481 |    6 ++++--
 tests/xfs/482 |    7 +++++--
 7 files changed, 60 insertions(+), 12 deletions(-)


diff --git a/common/xfs b/common/xfs
index aea2b678c8..63eff39d47 100644
--- a/common/xfs
+++ b/common/xfs
@@ -1814,6 +1814,39 @@ _scratch_xfs_find_agbtree_height() {
 	return 1
 }
 
+# Find us the path to the inode containing a realtime btree with a specific
+# height.
+_scratch_xfs_find_rgbtree_height() {
+	local bt_type="$1"
+	local bt_height="$2"
+	local rgcount=$(_xfs_mount_rgcount $SCRATCH_DEV)
+	local path
+	local path_format
+	local bt_prefix
+
+	case "${bt_type}" in
+	"rmap")
+		path_format="/realtime/%u.rmap"
+		bt_prefix="u3.rtrmapbt"
+		;;
+	*)
+		_fail "Don't know about rt btree ${bt_type}"
+		;;
+	esac
+
+	for ((rgno = 0; rgno < rgcount; rgno++)); do
+		path="$(printf "${path_format}" "${rgno}")"
+		bt_level=$(_scratch_xfs_db -c "path -m ${path}" -c "p ${bt_prefix}.level" | awk '{print $3}')
+		# "level" is the actual level within the btree
+		if [ "${bt_level}" -eq "$((bt_height - 1))" ]; then
+			echo "${path}"
+			return 0
+		fi
+	done
+
+	return 1
+}
+
 _require_xfs_mkfs_atomicswap()
 {
 	# atomicswap can be activated on rmap or reflink filesystems.
diff --git a/tests/xfs/406 b/tests/xfs/406
index 78db18077c..8c5570886b 100755
--- a/tests/xfs/406
+++ b/tests/xfs/406
@@ -26,10 +26,12 @@ _require_scratch_xfs_fuzz_fields
 echo "Format and populate"
 _scratch_populate_cached nofill > $seqres.full 2>&1
 
-inode_ver=$(_scratch_xfs_get_metadata_field "core.version" 'sb 0' 'addr rrmapino')
+path="$(_scratch_xfs_find_rgbtree_height 'rmap' 2)" || \
+	_fail "could not find two-level rtrmapbt"
+inode_ver=$(_scratch_xfs_get_metadata_field "core.version" "path -m $path")
 
 echo "Fuzz rtrmapbt recs"
-_scratch_xfs_fuzz_metadata '' 'offline' 'sb 0' 'addr rrmapino' "addr u${inode_ver}.rtrmapbt.ptrs[1]" >> $seqres.full
+_scratch_xfs_fuzz_metadata '' 'offline' "path -m $path" "addr u${inode_ver}.rtrmapbt.ptrs[1]" >> $seqres.full
 echo "Done fuzzing rtrmapbt recs"
 
 # success, all done
diff --git a/tests/xfs/407 b/tests/xfs/407
index 5a43775b55..2460ea336c 100755
--- a/tests/xfs/407
+++ b/tests/xfs/407
@@ -26,10 +26,12 @@ _require_scratch_xfs_fuzz_fields
 echo "Format and populate"
 _scratch_populate_cached nofill > $seqres.full 2>&1
 
-inode_ver=$(_scratch_xfs_get_metadata_field "core.version" 'sb 0' 'addr rrmapino')
+path="$(_scratch_xfs_find_rgbtree_height 'rmap' 1)" || \
+	_fail "could not find two-level rtrmapbt"
+inode_ver=$(_scratch_xfs_get_metadata_field "core.version" "path -m $path")
 
 echo "Fuzz rtrmapbt recs"
-_scratch_xfs_fuzz_metadata '' 'online' 'sb 0' 'addr rrmapino' "addr u${inode_ver}.rtrmapbt.ptrs[1]" >> $seqres.full
+_scratch_xfs_fuzz_metadata '' 'online' "path -m $path" "addr u${inode_ver}.rtrmapbt.ptrs[1]" >> $seqres.full
 echo "Done fuzzing rtrmapbt recs"
 
 # success, all done
diff --git a/tests/xfs/408 b/tests/xfs/408
index 8049d6bead..3bed3824e8 100755
--- a/tests/xfs/408
+++ b/tests/xfs/408
@@ -4,7 +4,7 @@
 #
 # FS QA Test No. 408
 #
-# Populate a XFS filesystem and fuzz every rtrmapbt keyptr field.
+# Populate a XFS filesystem and fuzz every rtrmapbt key/pointer field.
 # Use xfs_repair to fix the corruption.
 #
 . ./common/preamble
@@ -26,8 +26,11 @@ _require_scratch_xfs_fuzz_fields
 echo "Format and populate"
 _scratch_populate_cached nofill > $seqres.full 2>&1
 
+path="$(_scratch_xfs_find_rgbtree_height 'rmap' 2)" || \
+	_fail "could not find two-level rtrmapbt"
+
 echo "Fuzz rtrmapbt keyptrs"
-_scratch_xfs_fuzz_metadata '(rtrmapbt)' 'offline' 'sb 0' 'addr rrmapino' >> $seqres.full
+_scratch_xfs_fuzz_metadata '(rtrmapbt)' 'offline' "path -m $path" >> $seqres.full
 echo "Done fuzzing rtrmapbt keyptrs"
 
 # success, all done
diff --git a/tests/xfs/409 b/tests/xfs/409
index adac95fea8..ce66175c6e 100755
--- a/tests/xfs/409
+++ b/tests/xfs/409
@@ -4,7 +4,7 @@
 #
 # FS QA Test No. 409
 #
-# Populate a XFS filesystem and fuzz every rtrmapbt keyptr field.
+# Populate a XFS filesystem and fuzz every rtrmapbt key/pointer field.
 # Use xfs_scrub to fix the corruption.
 #
 . ./common/preamble
@@ -26,8 +26,11 @@ _require_scratch_xfs_fuzz_fields
 echo "Format and populate"
 _scratch_populate_cached nofill > $seqres.full 2>&1
 
+path="$(_scratch_xfs_find_rgbtree_height 'rmap' 2)" || \
+	_fail "could not find two-level rtrmapbt"
+
 echo "Fuzz rtrmapbt keyptrs"
-_scratch_xfs_fuzz_metadata '(rtrmapbt)' 'offline' 'sb 0' 'addr rrmapino' >> $seqres.full
+_scratch_xfs_fuzz_metadata '(rtrmapbt)' 'online' "path -m $path" >> $seqres.full
 echo "Done fuzzing rtrmapbt keyptrs"
 
 # success, all done
diff --git a/tests/xfs/481 b/tests/xfs/481
index 48c7580ccb..d303f2c27d 100755
--- a/tests/xfs/481
+++ b/tests/xfs/481
@@ -27,10 +27,12 @@ _disable_dmesg_check
 echo "Format and populate"
 _scratch_populate_cached nofill > $seqres.full 2>&1
 
-inode_ver=$(_scratch_xfs_get_metadata_field "core.version" 'sb 0' 'addr rrmapino')
+path="$(_scratch_xfs_find_rgbtree_height 'rmap' 2)" || \
+	_fail "could not find two-level rtrmapbt"
+inode_ver=$(_scratch_xfs_get_metadata_field "core.version" "path -m $path")
 
 echo "Fuzz rtrmapbt recs"
-_scratch_xfs_fuzz_metadata '' 'none' 'sb 0' 'addr rrmapino' "addr u${inode_ver}.rtrmapbt.ptrs[1]" >> $seqres.full
+_scratch_xfs_fuzz_metadata '' 'none' "path -m $path" "addr u${inode_ver}.rtrmapbt.ptrs[1]" >> $seqres.full
 echo "Done fuzzing rtrmapbt recs"
 
 # success, all done
diff --git a/tests/xfs/482 b/tests/xfs/482
index 0192b94cc0..32a3012154 100755
--- a/tests/xfs/482
+++ b/tests/xfs/482
@@ -4,7 +4,7 @@
 #
 # FS QA Test No. 482
 #
-# Populate a XFS filesystem and fuzz every rtrmapbt keyptr field.
+# Populate a XFS filesystem and fuzz every rtrmapbt key/pointer field.
 # Do not fix the filesystem, to test metadata verifiers.
 
 . ./common/preamble
@@ -27,8 +27,11 @@ _disable_dmesg_check
 echo "Format and populate"
 _scratch_populate_cached nofill > $seqres.full 2>&1
 
+path="$(_scratch_xfs_find_rgbtree_height 'rmap' 2)" || \
+	_fail "could not find two-level rtrmapbt"
+
 echo "Fuzz rtrmapbt keyptrs"
-_scratch_xfs_fuzz_metadata '(rtrmapbt)' 'offline' 'sb 0' 'addr rrmapino' >> $seqres.full
+_scratch_xfs_fuzz_metadata '(rtrmapbt)' 'offline' "path -m $path" >> $seqres.full
 echo "Done fuzzing rtrmapbt keyptrs"
 
 # success, all done

