Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F4F8AD21;
	Wed, 19 Feb 2025 01:03:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739927035; cv=none; b=tar5Uf+Q/G9l6kedAQuJ33oqaT1RwqsWDhQoUsxLn7zu+J5KXLfRdfEiFKJH+NVEsPzGI+G3mPJAJeAsNBbWufbocQFl8e5nROiFBXzy+1+9kInEs2TWTVQhyEZpNSWoCUjtwVQOtR5vLggqe81cHIl/sjFlSQWrbECK0p1wS0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739927035; c=relaxed/simple;
	bh=A99kF8ioYajMwS1mu7hQfDV/O1xCoyRtAdMXY9lr2GE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JBIffvW2tWYbOrOHxlU8XXOjg/wQ6xJhmJbdQfWy930hbpaxAEkw/hybcY/tClYxAx4tuWvM10qnDtmVN2Ypkl8vCGVWY0oOI/pWVOICwulfgSpUCRcImRw14I7B7fn9pRDuSCcpKTB1g2Bh2skYWrMAILLA0FSv9XrKJEixw7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T8na3AgF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T8na3AgF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 656F4C4CEE2;
	Wed, 19 Feb 2025 01:03:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739927035;
	bh=A99kF8ioYajMwS1mu7hQfDV/O1xCoyRtAdMXY9lr2GE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=T8na3AgFPsgYn8wlm/xlgwC79JDEElfrxBEB+zh2vS1vDGg/kWfXA4oaOaeF42O46
	 1Bn/UsZrh69+EZgryAAQzqimEr6N7OfOUPOS6PIZq6yxrIZ/TZ7ysc07GIy7rctpkW
	 3UsBcFAaDeHBV4IDE9cI8gifbQksYxIRdEMfO54oi0sudaq7JGRB2Jd9ha1IMQl1f7
	 TgLxuLo+q8jDQ6hpSzOA2KQ1AFBiOVp7C+XNgI/+qtGox1MK/vJn1Jdmo7JKajKxre
	 DzP7vrfWTwRP4Jh2/XbNPQ8qzaqOnrBBxabVSwI0w27NicGGLrBfCc0ikgbgj5gnaT
	 x73zTxHBYwFMA==
Date: Tue, 18 Feb 2025 17:03:55 -0800
Subject: [PATCH 01/13] xfs: fix tests that try to access the realtime rmap
 inode
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <173992591131.4080556.9851417940463513539.stgit@frogsfrogsfrogs>
In-Reply-To: <173992591052.4080556.14368674525636291029.stgit@frogsfrogsfrogs>
References: <173992591052.4080556.14368674525636291029.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

The realtime rmap tests were added to fstests a long time ago.  Since
they were added, we decided to create a metadata file directory
structure instead of adding more fields to the superblock.  Therefore,
fix all the tests that try to access these paths.

While we're at it, fix xfs/409 to run the *online* scrub program like
it's supposed to.  xfs/408 is the fuzzer for xfs_repair testing.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 common/xfs        |   41 +++++++++++++++++++++++++++++++++++++++++
 tests/xfs/122.out |    1 -
 tests/xfs/333     |   43 -------------------------------------------
 tests/xfs/333.out |    6 ------
 tests/xfs/337     |    2 +-
 tests/xfs/338     |   30 +++++++++++++++++++++++++-----
 tests/xfs/339     |    5 +++--
 tests/xfs/340     |   25 ++++++++++++++++++++-----
 tests/xfs/341     |    2 +-
 tests/xfs/342     |    4 ++--
 10 files changed, 93 insertions(+), 66 deletions(-)
 delete mode 100755 tests/xfs/333
 delete mode 100644 tests/xfs/333.out


diff --git a/common/xfs b/common/xfs
index adad37ea0710e0..1a0ececde39422 100644
--- a/common/xfs
+++ b/common/xfs
@@ -2135,3 +2135,44 @@ _require_xfs_rtquota_if_rtdev() {
 		_notrun "Quotas probably not supported on realtime scratch device; set TEST_RTDEV"
 	fi
 }
+
+# Resolve a metadata directory tree path and return the inode number.
+_scratch_metadir_lookup() {
+	local res="$(_scratch_xfs_db -c "ls -i -m $1")"
+	test "${PIPESTATUS[0]}" -eq 0 && echo "$res"
+}
+
+# Figure out which directory entry we have to change to update the rtrmap
+# inode pointer.  The last line of output is inumber field within a metadata
+# object; any previous lines are the accessor commands that must be fed to
+# xfs_db to get to the correct directory block.
+_scratch_find_rt_metadir_entry() {
+	local sfkey="$(_scratch_xfs_db -c 'path -m /rtgroups' -c print | \
+		grep "\"$1\"" | \
+		sed -e 's/.name.*$//g' -e 's/\[/\\[/g' -e 's/\]/\\]/g' )"
+	if [ -n "$sfkey" ]; then
+		echo 'path -m /rtgroups'
+		_scratch_xfs_db -c 'path -m /rtgroups' -c print | \
+			grep "${sfkey}.inumber" | awk '{print $1}'
+		return 0
+	fi
+
+	local size=$(_scratch_xfs_db -c 'path -m /rtgroups' -c 'print core.size' | awk '{print $3}')
+	local blksz=$(_scratch_xfs_db -c 'sb 0' -c 'print blocksize' | awk '{print $3}')
+	local dirblklog=$(_scratch_xfs_db -c 'sb 0' -c 'print dirblklog' | awk '{print $3}')
+	local dirblksz=$((blksz << dirblklog ))
+	for ((fileoff = 0; fileoff < (size / dirblksz); fileoff++)); do
+		local dbkey="$(_scratch_xfs_db -c 'path -m /rtgroups' -c "dblock $fileoff" -c 'print' | \
+			grep "\"$1\"" | \
+			sed -e 's/.name.*$//g' -e 's/\[/\\[/g' -e 's/\]/\\]/g' )"
+		if [ -n "$dbkey" ]; then
+			echo 'path -m /rtgroups'
+			echo "dblock $fileoff"
+			_scratch_xfs_db -c 'path -m /rtgroups' -c "dblock $fileoff" -c print | \
+				grep "${dbkey}.inumber" | awk '{print $1}'
+			return 0
+		fi
+	done
+
+	return 1
+}
diff --git a/tests/xfs/122.out b/tests/xfs/122.out
index 4dc7d7d0a3602b..ec5028621a8e75 100644
--- a/tests/xfs/122.out
+++ b/tests/xfs/122.out
@@ -44,7 +44,6 @@ offsetof(xfs_sb_t, sb_rextents) = 24
 offsetof(xfs_sb_t, sb_rextsize) = 80
 offsetof(xfs_sb_t, sb_rextslog) = 125
 offsetof(xfs_sb_t, sb_rootino) = 56
-offsetof(xfs_sb_t, sb_rrmapino) = 264
 offsetof(xfs_sb_t, sb_rsumino) = 72
 offsetof(xfs_sb_t, sb_sectlog) = 121
 offsetof(xfs_sb_t, sb_sectsize) = 102
diff --git a/tests/xfs/333 b/tests/xfs/333
deleted file mode 100755
index f68f2f01320420..00000000000000
--- a/tests/xfs/333
+++ /dev/null
@@ -1,43 +0,0 @@
-#! /bin/bash
-# SPDX-License-Identifier: GPL-2.0
-# Copyright (c) 2016, Oracle and/or its affiliates.  All Rights Reserved.
-#
-# FS QA Test No. 333
-#
-# Set rrmapino to another inode on an non-rt rmap fs and see if repair fixes it.
-#
-. ./common/preamble
-_begin_fstest auto quick rmap realtime
-
-# Import common functions.
-. ./common/filter
-
-_require_xfs_scratch_rmapbt
-_disable_dmesg_check
-
-rm -f "$seqres.full"
-
-unset SCRATCH_RTDEV
-
-echo "Format and mount"
-_scratch_mkfs > "$seqres.full" 2>&1
-rrmapino="$(_scratch_xfs_db -c 'sb 0' -c 'p rrmapino' 2>&1)"
-test "${rrmapino}" = "field rrmapino not found" && _notrun "realtime rmapbt not supported"
-_scratch_mount
-
-echo "Create some files"
-$XFS_IO_PROG -f -c "pwrite -S 0x68 0 9999" $SCRATCH_MNT/f1 >> $seqres.full
-$XFS_IO_PROG -f -c "pwrite -S 0x68 0 9999" $SCRATCH_MNT/f2 >> $seqres.full
-echo garbage > $SCRATCH_MNT/f3
-ino=$(stat -c '%i' $SCRATCH_MNT/f3)
-_scratch_unmount
-
-echo "Corrupt fs"
-_scratch_xfs_db -x -c 'sb 0' -c "write rrmapino $ino" >> $seqres.full
-_try_scratch_mount 2>&1 | _filter_error_mount
-
-echo "Test done, mount should have failed"
-
-# success, all done
-status=0
-exit
diff --git a/tests/xfs/333.out b/tests/xfs/333.out
deleted file mode 100644
index b3c698750f8fb1..00000000000000
--- a/tests/xfs/333.out
+++ /dev/null
@@ -1,6 +0,0 @@
-QA output created by 333
-Format and mount
-Create some files
-Corrupt fs
-mount: Structure needs cleaning
-Test done, mount should have failed
diff --git a/tests/xfs/337 b/tests/xfs/337
index 2ba508044ba16b..64429347fcba70 100755
--- a/tests/xfs/337
+++ b/tests/xfs/337
@@ -51,7 +51,7 @@ echo "+ check fs"
 _scratch_xfs_repair -n >> $seqres.full 2>&1 || echo "xfs_repair should not fail"
 
 echo "+ corrupt image"
-_scratch_xfs_db -x -c "sb" -c "addr rrmapino" -c "addr u3.rtrmapbt.ptrs[1]" \
+_scratch_xfs_db -x -c "path -m /rtgroups/0.rmap" -c "addr u3.rtrmapbt.ptrs[1]" \
 	-c "stack" -c "blocktrash -x 4096 -y 4096 -n 8 -3 -z" \
 	>> $seqres.full 2>&1
 
diff --git a/tests/xfs/338 b/tests/xfs/338
index 9648c9df485223..713a808dc8e3da 100755
--- a/tests/xfs/338
+++ b/tests/xfs/338
@@ -27,13 +27,33 @@ $XFS_IO_PROG -f -R -c "pwrite -S 0x68 0 9999" $SCRATCH_MNT/f2 >> $seqres.full
 _scratch_unmount
 
 echo "Corrupt fs"
-_scratch_xfs_db -x -c 'sb 0' -c 'addr rrmapino' \
-	-c 'write core.nlinkv2 0' -c 'write core.mode 0' -c 'sb 0' \
-	-c 'write rrmapino 0' >> $seqres.full
-_try_scratch_mount >> $seqres.full 2>&1 && echo "mount should have failed"
+readarray -t rtrmap_path < <(_scratch_find_rt_metadir_entry 0.rmap)
+
+rtrmap_accessors=()
+rtrmap_path_len="${#rtrmap_path[@]}"
+for ((i = 0; i < rtrmap_path_len - 1; i++)); do
+	rtrmap_accessors+=(-c "${rtrmap_path[i]}")
+done
+rtrmap_entry="${rtrmap_path[rtrmap_path_len - 1]}"
+test -n "$rtrmap_entry" || _fail "Could not find rtrmap metadir entry?"
+
+_scratch_xfs_db -x -c 'path -m /rtgroups/0.rmap' \
+	-c 'write core.nlinkv2 0' -c 'write core.mode 0' \
+	"${rtrmap_accessors[@]}" \
+	-c "print $rtrmap_entry" \
+	-c "write -d $rtrmap_entry 0" >> $seqres.full
+if _try_scratch_mount >> $seqres.full 2>&1; then
+       echo "mount should have failed"
+       _scratch_unmount
+else
+	# If the verifiers are working properly, the mount will fail because
+	# we fuzzed the metadata root directory.  This causes loud complaints
+	# to dmesg, so we want to ignore those.
+	_disable_dmesg_check
+fi
 
 echo "Repair fs"
-_scratch_unmount 2>&1 | _filter_scratch
+_scratch_unmount 2>&1 | _filter_scratch | _filter_ending_dot
 _repair_scratch_fs >> $seqres.full 2>&1
 
 echo "Try to create more files (again)"
diff --git a/tests/xfs/339 b/tests/xfs/339
index 4dabe43ff298fc..caadf87987e433 100755
--- a/tests/xfs/339
+++ b/tests/xfs/339
@@ -29,7 +29,8 @@ ln $SCRATCH_MNT/f3 $SCRATCH_MNT/f4
 _scratch_unmount
 
 echo "Corrupt fs"
-rrmapino=`_scratch_xfs_get_sb_field rrmapino`
+rrmapino=$(_scratch_metadir_lookup /rtgroups/0.rmap)
+test -n "$rrmapino" || _fail "Could not find rtrmap inode?"
 _scratch_xfs_set_metadata_field "u3.sfdir3.list[3].inumber.i4" $rrmapino \
 	'sb 0' 'addr rootino' >> $seqres.full
 _scratch_mount
@@ -41,7 +42,7 @@ echo "Try to create more files"
 $XFS_IO_PROG -f -R -c "pwrite -S 0x68 0 9999" $SCRATCH_MNT/f5 >> $seqres.full 2>&1
 
 echo "Repair fs"
-_scratch_unmount 2>&1 | _filter_scratch
+_scratch_unmount 2>&1 | _filter_scratch | _filter_ending_dot
 _repair_scratch_fs >> $seqres.full 2>&1
 
 echo "Try to create more files (again)"
diff --git a/tests/xfs/340 b/tests/xfs/340
index 248d3233c94ed3..c4a23bcb1cfe70 100755
--- a/tests/xfs/340
+++ b/tests/xfs/340
@@ -29,16 +29,31 @@ ino=$(stat -c '%i' $SCRATCH_MNT/f3)
 _scratch_unmount
 
 echo "Corrupt fs"
-rrmapino=$(_scratch_xfs_get_sb_field rrmapino)
-_scratch_xfs_db -x -c "inode $rrmapino" \
+readarray -t rtrmap_path < <(_scratch_find_rt_metadir_entry 0.rmap)
+
+rtrmap_accessors=()
+rtrmap_path_len="${#rtrmap_path[@]}"
+for ((i = 0; i < rtrmap_path_len - 1; i++)); do
+	rtrmap_accessors+=(-c "${rtrmap_path[i]}")
+done
+rtrmap_entry="${rtrmap_path[rtrmap_path_len - 1]}"
+test -n "$rtrmap_entry" || _fail "Could not find rtrmap metadir entry?"
+
+rrmapino=$(_scratch_metadir_lookup /rtgroups/0.rmap)
+test -n "$rrmapino" || _fail "Could not find rtrmap inode?"
+_scratch_xfs_db -x -c "path -m /rtgroups/0.rmap" \
 	-c 'write core.format 2' -c 'write core.size 0' \
-	-c 'write core.nblocks 0' -c 'sb 0' -c 'addr rootino' \
+	-c 'write core.nblocks 0' \
+	-c 'sb 0' -c 'addr rootino' \
+	-c "print u3.sfdir3.list[2].inumber" \
 	-c "write u3.sfdir3.list[2].inumber.i4 $rrmapino" \
-	-c 'sb 0' -c "write rrmapino $ino" >> $seqres.full
+	"${rtrmap_accessors[@]}" \
+	-c "print $rtrmap_entry" \
+	-c "write $rtrmap_entry $ino" >> $seqres.full
 _try_scratch_mount >> $seqres.full 2>&1 && echo "mount should have failed"
 
 echo "Repair fs"
-_scratch_unmount 2>&1 | _filter_scratch
+_scratch_unmount 2>&1 | _filter_scratch | _filter_ending_dot
 _repair_scratch_fs >> $seqres.full 2>&1
 
 echo "Try to create more files (again)"
diff --git a/tests/xfs/341 b/tests/xfs/341
index 9b12febf8d5c49..e9aea42f429ffd 100755
--- a/tests/xfs/341
+++ b/tests/xfs/341
@@ -51,7 +51,7 @@ echo "Corrupt fs"
 fsbno=$(_scratch_xfs_db -c "inode $ino" -c 'bmap' | grep 'flag 0' | head -n 1 | \
 	sed -e 's/^.*startblock \([0-9]*\) .*$/\1/g')
 
-_scratch_xfs_db -x -c 'sb 0' -c 'addr rrmapino' \
+_scratch_xfs_db -x -c 'path -m /rtgroups/0.rmap' \
 	-c "write u3.rtrmapbt.ptrs[1] $fsbno" -c 'p' >> $seqres.full
 _scratch_mount
 
diff --git a/tests/xfs/342 b/tests/xfs/342
index 5c0e916dbe32ac..3bf353dd79b29b 100755
--- a/tests/xfs/342
+++ b/tests/xfs/342
@@ -45,9 +45,9 @@ ino=$(stat -c '%i' $SCRATCH_MNT/f3)
 _scratch_unmount
 
 echo "Corrupt fs"
-_scratch_xfs_db -c 'sb 0' -c 'addr rrmapino' -c 'p u3.rtrmapbt.ptrs[1]' >> $seqres.full
+_scratch_xfs_db -c 'path -m /rtgroups/0.rmap' -c 'p u3.rtrmapbt.ptrs[1]' >> $seqres.full
 
-fsbno=$(_scratch_xfs_db -c 'sb 0' -c 'addr rrmapino' \
+fsbno=$(_scratch_xfs_db -c 'path -m /rtgroups/0.rmap' \
 	-c 'p u3.rtrmapbt.ptrs[1]' | sed -e 's/^.*://g')
 _scratch_xfs_db -x -c "inode $ino" -c "write u3.bmx[0].startblock $fsbno" >> $seqres.full
 _scratch_mount

