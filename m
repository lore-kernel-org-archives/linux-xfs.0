Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E5B4D26A;
	Tue, 18 Jun 2024 00:49:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718671762; cv=none; b=vCQDryTReCGgkoOMDJEpWIbUXLdZmccO515OrlxGpk0ca5e0zM2vMkWhm4RaQQACS4vJo7pyBUXct8Em52Krj57/Pptw2fCqGVlFplhulUiAm02WjH3HHlMNLOzOVKp7+twPZUfhGdimaVuEp3T9DVAxOBx3nZOGnoh5OtpS6sQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718671762; c=relaxed/simple;
	bh=ZL5mEFJsWf0wQZYiFogbDZJyIjjm20QAoYC2R20UYR4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hYcWI4ea24JEgcsKgXdKhq1eEyJ+AXnXIMKASesXELTy/f7d+IDArWWhfPLr1WML5m6qsSn2iZ2N4eWm7l4KGopCe1okO3SKHC7pItExKHqqXVPnyTrEt+qzm19DhI5ZqF2qpmqExkth8EGY839NCNWSoeqchmwckAl2SPFce8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ueqJquaL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ueqJquaL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68389C2BD10;
	Tue, 18 Jun 2024 00:49:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718671762;
	bh=ZL5mEFJsWf0wQZYiFogbDZJyIjjm20QAoYC2R20UYR4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ueqJquaLcch0EKyxZnYaaJ07SSF8WmIHvJtfKSWZzsWwY35ppJjzPwLlZGwDmBrTz
	 n6cOR3oh5Stziqmgedi7kS0ocBKwKXPyXKHwIdUezIawdYZAaGBjV6y9WmeXMDQLp9
	 cKbAht2/SvuOMRg1RoUIH54K63EyV3Ry4lZUqZvmopKESnuO1/2O55pcFW9JoBwxmt
	 V1YED+47i7KjhtkTdYS6CIzEz7giELKDgw87f1cVrsYqGpgaag+2t13TeXD7FMlqEC
	 EJQSXj2FFL4XQdJ+mEwGMPd9qtZY6RIY8t/d0+BXNSGktTOPvRKHoH1UylFlN21pqc
	 3eCLo9y6WZfcQ==
Date: Mon, 17 Jun 2024 17:49:21 -0700
Subject: [PATCH 10/10] swapext: make sure that we don't swap unwritten extents
 unless they're part of a rt extent(??)
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: fstests@vger.kernel.org, guan@eryu.me, linux-xfs@vger.kernel.org
Message-ID: <171867145451.793463.2794238931520323458.stgit@frogsfrogsfrogs>
In-Reply-To: <171867145284.793463.16426642605476089750.stgit@frogsfrogsfrogs>
References: <171867145284.793463.16426642605476089750.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/1213     |   73 ++++++++++++++++
 tests/xfs/1213.out |    2 
 tests/xfs/1214     |  232 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1214.out |    2 
 4 files changed, 309 insertions(+)
 create mode 100755 tests/xfs/1213
 create mode 100644 tests/xfs/1213.out
 create mode 100755 tests/xfs/1214
 create mode 100644 tests/xfs/1214.out


diff --git a/tests/xfs/1213 b/tests/xfs/1213
new file mode 100755
index 0000000000..a9f7e3706e
--- /dev/null
+++ b/tests/xfs/1213
@@ -0,0 +1,73 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2023-2024 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1213
+#
+# Make sure that the XFS_EXCHANGE_RANGE_FILE1_WRITTEN actually skips holes and
+# unwritten extents on the data device and the rt device when the rextsize
+# is 1 fsblock.
+#
+. ./common/preamble
+_begin_fstest auto fiexchange
+
+. ./common/filter
+
+# real QA test starts here
+
+# Modify as appropriate.
+_supported_fs generic
+_require_xfs_io_command "falloc"
+_require_xfs_io_command exchangerange
+_require_scratch
+
+_scratch_mkfs >> $seqres.full
+_scratch_mount
+
+# This test doesn't deal with the unwritten extents that must be created when
+# the realtime file allocation unit is larger than the fs blocksize.
+file_blksz=$(_get_file_block_size $SCRATCH_MNT)
+fs_blksz=$(_get_block_size $SCRATCH_MNT)
+test "$file_blksz" -eq "$fs_blksz" || \
+	_notrun "test requires file alloc unit ($file_blksz) == fs block size ($fs_blksz)"
+
+swap_and_check_contents() {
+	local a="$1"
+	local b="$2"
+	local tag="$3"
+
+	local a_md5_before=$(md5sum $a | awk '{print $1}')
+	local b_md5_before=$(md5sum $b | awk '{print $1}')
+
+	# Test exchangerange.  -w means skip holes in /b
+	echo "swap $tag" >> $seqres.full
+	$XFS_IO_PROG -c fsync -c 'bmap -elpvvvv' $a $b >> $seqres.full
+	$XFS_IO_PROG -c "exchangerange -f -w $b" $a >> $seqres.full
+	$XFS_IO_PROG -c 'bmap -elpvvvv' $a $b >> $seqres.full
+	_scratch_cycle_mount
+
+	local a_md5_after=$(md5sum $a | awk '{print $1}')
+	local b_md5_after=$(md5sum $b | awk '{print $1}')
+
+	test "$a_md5_before" != "$a_md5_after" && \
+		echo "$a: md5 $a_md5_before -> $a_md5_after in $tag"
+
+	test "$b_md5_before" != "$b_md5_after" && \
+		echo "$b: md5 $b_md5_before -> $b_md5_after in $tag"
+}
+
+# plain preallocations on the data device
+$XFS_IO_PROG -c 'extsize 0' $SCRATCH_MNT
+_pwrite_byte 0x58 0 1m $SCRATCH_MNT/dar >> $seqres.full
+$XFS_IO_PROG -f -c 'truncate 1m' -c "falloc 640k 64k" $SCRATCH_MNT/dbr
+swap_and_check_contents $SCRATCH_MNT/dar $SCRATCH_MNT/dbr "plain prealloc"
+
+# extent size hints on the data device
+$XFS_IO_PROG -c 'extsize 1m' $SCRATCH_MNT
+_pwrite_byte 0x58 0 1m $SCRATCH_MNT/dae >> $seqres.full
+$XFS_IO_PROG -f -c 'truncate 1m' -c "falloc 640k 64k" $SCRATCH_MNT/dbe
+swap_and_check_contents $SCRATCH_MNT/dae $SCRATCH_MNT/dbe "data dev extsize prealloc"
+
+echo Silence is golden
+status=0
+exit
diff --git a/tests/xfs/1213.out b/tests/xfs/1213.out
new file mode 100644
index 0000000000..5a28b8b45f
--- /dev/null
+++ b/tests/xfs/1213.out
@@ -0,0 +1,2 @@
+QA output created by 1213
+Silence is golden
diff --git a/tests/xfs/1214 b/tests/xfs/1214
new file mode 100755
index 0000000000..3451565445
--- /dev/null
+++ b/tests/xfs/1214
@@ -0,0 +1,232 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2023-2024 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1214
+#
+# Make sure that the XFS_EXCHANGE_RANGE_FILE1_WRITTEN actually skips holes and
+# unwritten extents on the realtime device when the rextsize is larger than 1
+# fs block.
+#
+. ./common/preamble
+_begin_fstest auto fiexchange
+
+. ./common/filter
+
+# real QA test starts here
+
+# Modify as appropriate.
+_supported_fs generic
+_require_xfs_io_command "falloc"
+_require_xfs_io_command exchangerange
+_require_realtime
+_require_scratch
+
+_scratch_mkfs >> $seqres.full
+_scratch_mount
+
+# This test only deals with the unwritten extents that must be created when
+# the realtime file allocation unit is larger than the fs blocksize.
+file_blksz=$(_get_file_block_size $SCRATCH_MNT)
+fs_blksz=$(_get_block_size $SCRATCH_MNT)
+test "$file_blksz" -ge "$((3 * fs_blksz))" || \
+	_notrun "test requires file alloc unit ($file_blksz) >= 3 * fs block size ($fs_blksz)"
+
+swap_and_check_contents() {
+	local a="$1"
+	local b="$2"
+	local tag="$3"
+
+	sync
+
+	# Test exchangerange.  -w means skip holes in /b
+	echo "swap $tag" >> $seqres.full
+	$XFS_IO_PROG -c 'bmap -elpvvvv' $a $b >> $seqres.full
+	$XFS_IO_PROG -c "exchangerange -f -w $b" $a >> $seqres.full
+	$XFS_IO_PROG -c 'bmap -elpvvvv' $a $b >> $seqres.full
+
+	local a_md5_before=$(md5sum $a | awk '{print $1}')
+	local b_md5_before=$(md5sum $b | awk '{print $1}')
+
+	_scratch_cycle_mount
+
+	local a_md5_check=$(md5sum $a.chk | awk '{print $1}')
+	local b_md5_check=$(md5sum $b.chk | awk '{print $1}')
+
+	local a_md5_after=$(md5sum $a | awk '{print $1}')
+	local b_md5_after=$(md5sum $b | awk '{print $1}')
+
+	test "$a_md5_before" != "$a_md5_after" && \
+		echo "$a: md5 $a_md5_before -> $a_md5_after in $tag"
+
+	test "$b_md5_before" != "$b_md5_after" && \
+		echo "$b: md5 $b_md5_before -> $b_md5_after in $tag"
+
+	if [ "$a_md5_check" != "$a_md5_after" ]; then
+		echo "$a: md5 $a_md5_after, expected $a_md5_check in $tag" | tee -a $seqres.full
+		echo "$a contents" >> $seqres.full
+		od -tx1 -Ad -c $a >> $seqres.full
+		echo "$a.chk contents" >> $seqres.full
+		od -tx1 -Ad -c $a.chk >> $seqres.full
+	fi
+
+	if [ "$b_md5_check" != "$b_md5_after" ]; then
+		echo "$b: md5 $b_md5_after, expected $b_md5_check in $tag" | tee -a $seqres.full
+		echo "$b contents" >> $seqres.full
+		od -tx1 -Ad -c $b >> $seqres.full
+		echo "$b.chk contents" >> $seqres.full
+		od -tx1 -Ad -c $b.chk >> $seqres.full
+	fi
+}
+
+filesz=$((5 * file_blksz))
+
+# first rtblock of the second rtextent is unwritten
+rm -f $SCRATCH_MNT/da $SCRATCH_MNT/db $SCRATCH_MNT/*.chk
+_pwrite_byte 0x58 0 $filesz $SCRATCH_MNT/da >> $seqres.full
+$XFS_IO_PROG -f -c "truncate $filesz" \
+	-c "pwrite -S 0x59 $((file_blksz + fs_blksz)) $((file_blksz - fs_blksz))" \
+	$SCRATCH_MNT/db >> $seqres.full
+$XFS_IO_PROG -f -c "truncate $filesz" \
+	-c "pwrite -S 0x58 0 $file_blksz" \
+	-c "pwrite -S 0x00 $file_blksz $fs_blksz" \
+	-c "pwrite -S 0x59 $((file_blksz + fs_blksz)) $((file_blksz - fs_blksz))" \
+	-c "pwrite -S 0x58 $((file_blksz * 2)) $((filesz - (file_blksz * 2) ))" \
+	$SCRATCH_MNT/da.chk >> /dev/null
+$XFS_IO_PROG -f -c "truncate $filesz" \
+	-c "pwrite -S 0x58 $file_blksz $file_blksz" \
+	$SCRATCH_MNT/db.chk >> /dev/null
+swap_and_check_contents $SCRATCH_MNT/da $SCRATCH_MNT/db \
+	"first rtb of second rtx"
+
+# second rtblock of the second rtextent is unwritten
+rm -f $SCRATCH_MNT/da $SCRATCH_MNT/db $SCRATCH_MNT/*.chk
+_pwrite_byte 0x58 0 $filesz $SCRATCH_MNT/da >> $seqres.full
+$XFS_IO_PROG -f -c "truncate $filesz" \
+	-c "pwrite -S 0x59 $file_blksz $fs_blksz" \
+	-c "pwrite -S 0x59 $((file_blksz + (2 * fs_blksz) )) $((file_blksz - (2 * fs_blksz) ))" \
+	$SCRATCH_MNT/db >> $seqres.full
+$XFS_IO_PROG -f -c "truncate $filesz" \
+	-c "pwrite -S 0x58 0 $file_blksz" \
+	-c "pwrite -S 0x59 $file_blksz $fs_blksz" \
+	-c "pwrite -S 0x00 $((file_blksz + fs_blksz)) $fs_blksz" \
+	-c "pwrite -S 0x59 $((file_blksz + (2 * fs_blksz) )) $((file_blksz - (2 * fs_blksz) ))" \
+	-c "pwrite -S 0x58 $((file_blksz * 2)) $((filesz - (file_blksz * 2) ))" \
+	$SCRATCH_MNT/da.chk >> /dev/null
+$XFS_IO_PROG -f -c "truncate $filesz" \
+	-c "pwrite -S 0x58 $file_blksz $file_blksz" \
+	$SCRATCH_MNT/db.chk >> /dev/null
+swap_and_check_contents $SCRATCH_MNT/da $SCRATCH_MNT/db \
+	"second rtb of second rtx"
+
+# last rtblock of the second rtextent is unwritten
+rm -f $SCRATCH_MNT/da $SCRATCH_MNT/db $SCRATCH_MNT/*.chk
+_pwrite_byte 0x58 0 $filesz $SCRATCH_MNT/da >> $seqres.full
+$XFS_IO_PROG -f -c "truncate $filesz" \
+	-c "pwrite -S 0x59 $file_blksz $((file_blksz - fs_blksz))" \
+	$SCRATCH_MNT/db >> $seqres.full
+$XFS_IO_PROG -f -c "truncate $filesz" \
+	-c "pwrite -S 0x58 0 $file_blksz" \
+	-c "pwrite -S 0x59 $file_blksz $((file_blksz - fs_blksz))" \
+	-c "pwrite -S 0x00 $(( (2 * file_blksz) - fs_blksz)) $fs_blksz" \
+	-c "pwrite -S 0x58 $((file_blksz * 2)) $((filesz - (file_blksz * 2) ))" \
+	$SCRATCH_MNT/da.chk >> /dev/null
+$XFS_IO_PROG -f -c "truncate $filesz" \
+	-c "pwrite -S 0x58 $file_blksz $file_blksz" \
+	$SCRATCH_MNT/db.chk >> /dev/null
+swap_and_check_contents $SCRATCH_MNT/da $SCRATCH_MNT/db \
+	"last rtb of second rtx"
+
+# last rtb of the 2nd rtx and first rtb of the 3rd rtx is unwritten
+rm -f $SCRATCH_MNT/da $SCRATCH_MNT/db $SCRATCH_MNT/*.chk
+_pwrite_byte 0x58 0 $filesz $SCRATCH_MNT/da >> $seqres.full
+$XFS_IO_PROG -f -c "truncate $filesz" \
+	-c "falloc $file_blksz $((2 * file_blksz))" \
+	-c "pwrite -S 0x59 $file_blksz $((file_blksz - fs_blksz))" \
+	-c "pwrite -S 0x59 $(( (2 * file_blksz) + fs_blksz)) $((file_blksz - fs_blksz))" \
+	$SCRATCH_MNT/db >> $seqres.full
+$XFS_IO_PROG -f -c "truncate $filesz" \
+	-c "pwrite -S 0x58 0 $file_blksz" \
+	-c "pwrite -S 0x59 $file_blksz $((file_blksz - fs_blksz))" \
+	-c "pwrite -S 0x00 $(( (2 * file_blksz) - fs_blksz)) $((2 * fs_blksz))" \
+	-c "pwrite -S 0x59 $(( (2 * file_blksz) + fs_blksz)) $((file_blksz - fs_blksz))" \
+	-c "pwrite -S 0x58 $((file_blksz * 3)) $((filesz - (file_blksz * 3) ))" \
+	$SCRATCH_MNT/da.chk >> /dev/null
+$XFS_IO_PROG -f -c "truncate $filesz" \
+	-c "pwrite -S 0x58 $file_blksz $((2 * file_blksz))" \
+	$SCRATCH_MNT/db.chk >> /dev/null
+swap_and_check_contents $SCRATCH_MNT/da $SCRATCH_MNT/db \
+	"last rtb of 2nd rtx and first rtb of 3rd rtx"
+
+# last rtb of the 2nd rtx and first rtb of the 4th rtx is unwritten; 3rd rtx
+# is a hole
+rm -f $SCRATCH_MNT/da $SCRATCH_MNT/db $SCRATCH_MNT/*.chk
+_pwrite_byte 0x58 0 $filesz $SCRATCH_MNT/da >> $seqres.full
+$XFS_IO_PROG -f -c "truncate $filesz" \
+	-c "pwrite -S 0x59 $file_blksz $((file_blksz - fs_blksz))" \
+	-c "pwrite -S 0x59 $(( (3 * file_blksz) + fs_blksz)) $((file_blksz - fs_blksz))" \
+	-c "fpunch $((2 * file_blksz)) $file_blksz" \
+	$SCRATCH_MNT/db >> $seqres.full
+$XFS_IO_PROG -f -c "truncate $filesz" \
+	-c "pwrite -S 0x58 0 $file_blksz" \
+	-c "pwrite -S 0x59 $file_blksz $((file_blksz - fs_blksz))" \
+	-c "pwrite -S 0x00 $(( (2 * file_blksz) - fs_blksz)) $fs_blksz" \
+	-c "pwrite -S 0x58 $((file_blksz * 2)) $file_blksz" \
+	-c "pwrite -S 0x00 $((3 * file_blksz)) $fs_blksz" \
+	-c "pwrite -S 0x59 $(( (3 * file_blksz) + fs_blksz)) $((file_blksz - fs_blksz))" \
+	-c "pwrite -S 0x58 $((file_blksz * 4)) $((filesz - (file_blksz * 4) ))" \
+	$SCRATCH_MNT/da.chk >> /dev/null
+$XFS_IO_PROG -f -c "truncate $filesz" \
+	-c "pwrite -S 0x58 $file_blksz $file_blksz" \
+	-c "pwrite -S 0x58 $((file_blksz * 3)) $file_blksz" \
+	$SCRATCH_MNT/db.chk >> /dev/null
+swap_and_check_contents $SCRATCH_MNT/da $SCRATCH_MNT/db \
+	"last rtb of 2nd rtx and first rtb of 4th rtx; 3rd rtx is hole"
+
+# last rtb of the 2nd rtx and first rtb of the 4th rtx is unwritten; 3rd rtx
+# is preallocated
+rm -f $SCRATCH_MNT/da $SCRATCH_MNT/db $SCRATCH_MNT/*.chk
+_pwrite_byte 0x58 0 $filesz $SCRATCH_MNT/da >> $seqres.full
+$XFS_IO_PROG -f -c "truncate $filesz" \
+	-c "falloc $file_blksz $((file_blksz * 3))" \
+	-c "pwrite -S 0x59 $file_blksz $((file_blksz - fs_blksz))" \
+	-c "pwrite -S 0x59 $(( (3 * file_blksz) + fs_blksz)) $((file_blksz - fs_blksz))" \
+	$SCRATCH_MNT/db >> $seqres.full
+$XFS_IO_PROG -f -c "truncate $filesz" \
+	-c "pwrite -S 0x58 0 $file_blksz" \
+	-c "pwrite -S 0x59 $file_blksz $((file_blksz - fs_blksz))" \
+	-c "pwrite -S 0x00 $(( (2 * file_blksz) - fs_blksz)) $fs_blksz" \
+	-c "pwrite -S 0x58 $((file_blksz * 2)) $file_blksz" \
+	-c "pwrite -S 0x00 $((3 * file_blksz)) $fs_blksz" \
+	-c "pwrite -S 0x59 $(( (3 * file_blksz) + fs_blksz)) $((file_blksz - fs_blksz))" \
+	-c "pwrite -S 0x58 $((file_blksz * 4)) $((filesz - (file_blksz * 4) ))" \
+	$SCRATCH_MNT/da.chk >> /dev/null
+$XFS_IO_PROG -f -c "truncate $filesz" \
+	-c "pwrite -S 0x58 $file_blksz $file_blksz" \
+	-c "pwrite -S 0x58 $((file_blksz * 3)) $file_blksz" \
+	$SCRATCH_MNT/db.chk >> /dev/null
+swap_and_check_contents $SCRATCH_MNT/da $SCRATCH_MNT/db \
+	"last rtb of 2nd rtx and first rtb of 4th rtx; 3rd rtx is prealloc"
+
+# 2nd rtx is preallocated and first rtb of 3rd rtx is unwritten
+rm -f $SCRATCH_MNT/da $SCRATCH_MNT/db $SCRATCH_MNT/*.chk
+_pwrite_byte 0x58 0 $filesz $SCRATCH_MNT/da >> $seqres.full
+$XFS_IO_PROG -f -c "truncate $filesz" \
+	-c "falloc $file_blksz $((file_blksz * 2))" \
+	-c "pwrite -S 0x59 $(( (2 * file_blksz) + fs_blksz)) $((file_blksz - fs_blksz))" \
+	$SCRATCH_MNT/db >> $seqres.full
+$XFS_IO_PROG -f -c "truncate $filesz" \
+	-c "pwrite -S 0x58 0 $((2 * file_blksz))" \
+	-c "pwrite -S 0x00 $((2 * file_blksz)) $fs_blksz" \
+	-c "pwrite -S 0x59 $(( (2 * file_blksz) + fs_blksz)) $((file_blksz - fs_blksz))" \
+	-c "pwrite -S 0x58 $((file_blksz * 3)) $((filesz - (file_blksz * 3) ))" \
+	$SCRATCH_MNT/da.chk >> /dev/null
+$XFS_IO_PROG -f -c "truncate $filesz" \
+	-c "pwrite -S 0x58 $((2 * file_blksz)) $file_blksz" \
+	$SCRATCH_MNT/db.chk >> /dev/null
+swap_and_check_contents $SCRATCH_MNT/da $SCRATCH_MNT/db \
+	"2nd rtx is prealloc and first rtb of 3rd rtx is unwritten"
+
+echo Silence is golden
+status=0
+exit
diff --git a/tests/xfs/1214.out b/tests/xfs/1214.out
new file mode 100644
index 0000000000..a529e42333
--- /dev/null
+++ b/tests/xfs/1214.out
@@ -0,0 +1,2 @@
+QA output created by 1214
+Silence is golden

