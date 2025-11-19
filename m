Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13FFA1EB9E1
	for <linux-xfs@vger.kernel.org>; Wed, 19 Nov 2025 04:12:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763525546; cv=none; b=J4lj9BS7fW5eQepxvgv0xb5MYMy4ocs9uZO4PmdyjfEnI8ieTOrWMjwTVz/qfrHlMjkttm3UlkxZ+ghaSZ0+mTslMS35Dax7rqjumfWb18v+c7PZxXmBIUdq6Hmj41OjbTfnR4POOZJNteWmsLABjA7WT4XaoRUc6pugCrNEr2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763525546; c=relaxed/simple;
	bh=BUTyI0YPsaO+aXhSxO1xSyOP/Ol27XvhOLjG/wVVvjM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jXoQdb7EBJRHr0Fies+im3rXbveHSzJafp6/7kLTDU2ni8LUDgq9hnOen+Yeuky5Fl6NvRGS84o0978dnskiJq20gY1NuepRxKPZ66fNWgxN6E9y2PgmqdAghM8CQH9INHlkpfkVz/aC7fih3o3p6HV8WFVY3848o+0bk4QKXw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ix9exMPn; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=sgQBFY1L; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ix9exMPn";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="sgQBFY1L"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763525542;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=3LBhqn2Z71rFoZH4yBQdRf1abhnkDpos2VEDXLQ5yGo=;
	b=Ix9exMPnldn2t37YKXO/FDUNTGUC9TBopAv0NfJikG1CzCGGRO6qXvJs2G2eoQUm4m1DXU
	+xCGA5/OINGiKdJFpY4eprXP9MgLwVZNCGkBXl/fTYB8g070LcGd0mZA+LaPzxGmEF/iHr
	f/Qh3Vm7/3S22qfO18XCTEggDQaXIkg=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-208-SVHKIU33Nx6PCSedODD1bQ-1; Tue, 18 Nov 2025 23:12:19 -0500
X-MC-Unique: SVHKIU33Nx6PCSedODD1bQ-1
X-Mimecast-MFC-AGG-ID: SVHKIU33Nx6PCSedODD1bQ_1763525539
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-8823c1345c0so85464166d6.2
        for <linux-xfs@vger.kernel.org>; Tue, 18 Nov 2025 20:12:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1763525538; x=1764130338; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=3LBhqn2Z71rFoZH4yBQdRf1abhnkDpos2VEDXLQ5yGo=;
        b=sgQBFY1LyEDFGTJttHHeCpOkhhi2C3eh/XJAm2m2cU1pK15OSRG1t8NBjnyTls5mib
         e2uK9uveX63AK26kbygI0sxXoYk4Fudda3xqHPjRCnEXzyIbYOTXBtAgUo2Ec7GmLgSB
         S6kCGi2K18myIQk0CrNeVns3NZF9aF1jdAmObUqgVzQMTX/DNZ+X76Xg6AdMcRNctJ/M
         qY05Sqcj8NdOOb1i6m+nULg6JcD9mE4vza06EwueJLaGpBGWWZXpA7trbd5VUj3mMgf+
         ofo/M4ib388ydkpir8UrZLjF9x4KrsHD4jL2ji7re4FcBSBgqkcSr5PEK4fMfXZUVBYH
         SXxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763525538; x=1764130338;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3LBhqn2Z71rFoZH4yBQdRf1abhnkDpos2VEDXLQ5yGo=;
        b=kVQ/EdgvP0XZlk+ziNLMGLGCEzPAlsw/kffuG6I56Ygj45mzG87+rTkTN89UWNWONP
         JpY87lLffK4a0lmknT0fHvgCL12mKonyUvGPijDY9lnE3i2pclJHeu2yaAZ7mCfpWcxI
         dLMG5/G6qU6Ae8GE+Fz3TZo5kUdGmgZBxLqUufOdR2HSnxevqFSe70ZIYn15O+vgsqkE
         mHxbm0iJfXiUKUs1Ovvz4yErMdhuJHOTaX5hRixtc4eHN5lCTY5N4/0rX7pdxmTUl0e9
         EK6LMSdNOgqkhKF94uvDoYUM7A5YvbD3M9As70PbtpPWjXNDodZAHddmE2qN2+eYk8tB
         Nu2w==
X-Gm-Message-State: AOJu0Ywac17FusEGgyuk8WFiWMfLQCo3r5oJuDt+xtB+nnWfZu8Mnp3F
	yZ9WlVjHOcLOjZ+V/ruIHR9109/NdG+EdRs2mtGUfrVysQze2vG6a/I7xvYe22IMNYZDDlCQuQv
	1mTDgVeV4/KepGU+X3AJcDlcFC7vj2+PGcS64BGwMt9YTnl6pJR0UZADuP6lri5NlJEkRYQM5Bk
	7BYpK0wjjA1cGXvUQDigoGKTu+J88ZKWkBe5YKv90t66bNLA==
X-Gm-Gg: ASbGncuSFWZThiJezmxmJIkQxXHZF2swC0J8rxpTBATjM/lsDpSg9rWcYaGOmJ9eiTP
	R6Czo99i9xr0zK/fGHM/M9AT5xqqef+r1x/9G+6AOWtcAhG86wE2dKI6jkJnD/DnLBc5fpUoC5q
	wfTPImTU9NuDv2kXG/87qI/RV9mfhXQ2pDIZg9+mmRiRc/SOUtj6Fk3gFCNSTWoZ3nCWZpmfnTJ
	8utiIjzD2Kyva4QXEM3uw20ZJwaHm3IxSDqDk26gbuEGiN5c3EkAWV4vuL8ZG+laMXBkVeyvRTa
	xNJZma8Y1SwTvGhxu1L+RNxHqhbeSWH13yBYIhKMnF4JqP9fvkaVi9vzSA+GhollpyqZ07QaSS9
	re9trQKPJIAgENeV8eTgd
X-Received: by 2002:a05:6214:2421:b0:87c:2919:7db0 with SMTP id 6a1803df08f44-88292686a87mr332784446d6.33.1763525538305;
        Tue, 18 Nov 2025 20:12:18 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH3EXYPJlsYA9s/LP2uNVl48TWIUJ3H0sEJGPKGg5UmQPMj6+XX4L5WGAhNK2KxbJqYZ7Otvg==
X-Received: by 2002:a05:6214:2421:b0:87c:2919:7db0 with SMTP id 6a1803df08f44-88292686a87mr332784166d6.33.1763525537706;
        Tue, 18 Nov 2025 20:12:17 -0800 (PST)
Received: from anathem.redhat.com ([2001:8003:4a36:e700:8cd:5151:364a:2095])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-88286318333sm127943706d6.24.2025.11.18.20.12.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Nov 2025 20:12:17 -0800 (PST)
From: Donald Douwsma <ddouwsma@redhat.com>
To: linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org
Cc: Zorro Lang <zlang@kernel.org>,
	Donald Douwsma <ddouwsma@redhat.com>
Subject: [PATCH v3] xfs: test case for handling io errors when reading extended attributes
Date: Wed, 19 Nov 2025 15:12:10 +1100
Message-ID: <20251119041210.2385106-1-ddouwsma@redhat.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We've seen reports from the field panicking in xfs_trans_brelse after an
IO error when reading an attribute block.

sd 0:0:23:0: [sdx] tag#271 CDB: Read(16) 88 00 00 00 00 00 9b df 5e 78 00 00 00 08 00 00
critical medium error, dev sdx, sector 2615107192 op 0x0:(READ) flags 0x1000 phys_seg 1 prio class 2
XFS (sdx1): metadata I/O error in "xfs_da_read_buf+0xe1/0x140 [xfs]" at daddr 0x9bdf5678 len 8 error 61
BUG: kernel NULL pointer dereference, address: 00000000000000e0
...
RIP: 0010:xfs_trans_brelse+0xb/0xe0 [xfs]

Signed-off-by: Donald Douwsma <ddouwsma@redhat.com>

---
V3
- Zorro's suggestions (_require_scsi_debug, _require_scratch, ..., use _get_file_block_size
  drop dry_run, fix local variables and parameters, common/attr, ...)
- Override SELINUX_MOUNT_OPTIONS to avoid _scratch_mount breaking the test
- Add test to quick attr
- Change test_attr() to work with blocks instead of bytes
- Name the scsi_debug options to make it clearer where the error is active
- Determine size of the attr value required based on filesystem block size
V2
- As this is specific to ENODATA test using scsi_debug instead of dmerror
which returns EIO.
---
 common/scsi_debug |   8 ++-
 tests/xfs/999     | 139 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/999.out |   2 +
 3 files changed, 148 insertions(+), 1 deletion(-)
 create mode 100755 tests/xfs/999
 create mode 100644 tests/xfs/999.out

diff --git a/common/scsi_debug b/common/scsi_debug
index 1e0ca255..c3fe7be6 100644
--- a/common/scsi_debug
+++ b/common/scsi_debug
@@ -6,6 +6,7 @@
 
 . common/module
 
+# _require_scsi_debug [mod_param]
 _require_scsi_debug()
 {
 	local mod_present=0
@@ -30,9 +31,14 @@ _require_scsi_debug()
 			_patient_rmmod scsi_debug || _notrun "scsi_debug module in use"
 		fi
 	fi
+
 	# make sure it has the features we need
 	# logical/physical sectors plus unmap support all went in together
-	modinfo scsi_debug | grep -wq sector_size || _notrun "scsi_debug too old"
+	grep -wq sector_size <(modinfo scsi_debug) || _notrun "scsi_debug too old"
+	# make sure it supports this module parameter
+	if [ -n "$1" ];then
+		grep -Ewq "$1" <(modinfo scsi_debug) || _notrun "scsi_debug not support $1"
+	fi
 }
 
 # Args: [physical sector size, [logical sector size, [unaligned(0|1), [size in megs]]]]
diff --git a/tests/xfs/999 b/tests/xfs/999
new file mode 100755
index 00000000..2a571195
--- /dev/null
+++ b/tests/xfs/999
@@ -0,0 +1,139 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2025 Red Hat Inc.  All Rights Reserved.
+#
+# FS QA Test 999
+#
+# Regression test for panic following IO error when reading extended attribute blocks
+#
+#   XFS (sda): metadata I/O error in "xfs_da_read_buf+0xe1/0x140 [xfs]" at daddr 0x78 len 8 error 61
+#   BUG: kernel NULL pointer dereference, address: 00000000000000e0
+#   ...
+#   RIP: 0010:xfs_trans_brelse+0xb/0xe0 [xfs]
+#
+# For SELinux enabled filesystems the attribute security.selinux will be
+# created before any additional attributes are added. In this case the
+# regression will trigger via security_d_instantiate() during a stat(2),
+# without SELinux this should trigger from fgetxattr(2).
+#
+# Kernels prior to v4.16 don't have medium_error_start, and only return errors
+# for a specific location, making scsi_debug unsuitable for checking old
+# kernels. See d9da891a892a scsi: scsi_debug: Add two new parameters to
+# scsi_debug driver
+#
+
+. ./common/preamble
+_begin_fstest auto quick attr
+
+_fixed_by_kernel_commit ae668cd567a6 \
+	"xfs: do not propagate ENODATA disk errors into xattr code"
+
+# Override the default cleanup function.
+_cleanup()
+{
+	_unmount $SCRATCH_MNT 2>/dev/null
+	_put_scsi_debug_dev
+	cd /
+	rm -f $tmp.*
+}
+
+# Import common functions.
+. ./common/attr
+. ./common/scsi_debug
+
+_require_scratch_nocheck
+_require_scsi_debug "medium_error_start"
+_require_attrs user
+
+# If SELinux is enabled common/config sets a default context, which which breaks this test.
+export SELINUX_MOUNT_OPTIONS=""
+
+scsi_debug_dev=$(_get_scsi_debug_dev)
+scsi_debug_opt_noerror=0
+scsi_debug_opt_error=${scsi_debug_opt_error:=2}
+test -b $scsi_debug_dev || _notrun "Failed to initialize scsi debug device"
+echo "SCSI debug device $scsi_debug_dev" >>$seqres.full
+
+SCRATCH_DEV=$scsi_debug_dev
+_scratch_mkfs >> $seqres.full
+_scratch_mount
+
+block_size=$(_get_file_block_size $SCRATCH_MNT)
+inode_size=$(_xfs_get_inode_size $SCRATCH_MNT)
+error_length=$((block_size/512)) # Error all sectors in the block
+
+echo Block size $block_size >> $seqres.full
+echo Inode size $inode_size >> $seqres.full
+
+test_attr()
+{
+	local test=$1
+	local testfile=$SCRATCH_MNT/$test
+	local attr_blocks=$2
+	local error_at_block=${3:-0}
+
+	local attr_size_bytes=$((block_size/2*attr_blocks))
+
+	# The maximum size for a single value is ATTR_MAX_VALUELEN (64*1024)
+	# If we wanted to test a larger range of extent combinations the test
+	# would need to use multiple values.
+	[[ $attr_size_bytes -ge 65536 ]] && echo "Test would need to be modified to support > 64k values for $attr_blocks blocks".
+
+	echo $scsi_debug_opt_noerror > /sys/module/scsi_debug/parameters/opts
+
+	echo -e "\nTesting : $test" >> $seqres.full
+	echo -e "attr size: $attr_blocks" >> $seqres.full
+	echo -e "error at block: $error_at_block\n" >> $seqres.full
+
+	touch $testfile
+	local inode=$(stat -c '%i' $testfile)
+	$SETFATTR_PROG -n user.test_attr -v $(printf "%0*d" $attr_size_bytes $attr_size_bytes) $testfile
+
+	$XFS_IO_PROG -c "bmap -al" $testfile >> $seqres.full
+	start_blocks=($($XFS_IO_PROG -c "bmap -al" $testfile | awk 'match($3, /[0-9]+/, a) {print a[0]}'))
+	echo "Attribute fork extent(s) start at ${start_blocks[*]}" >> $seqres.full
+
+	_scratch_unmount
+
+	echo "Dump inode $inode details with xfs_db" >> $seqres.full
+	_scratch_xfs_db -c "inode $inode" -c "print core.aformat core.naextents a" >> $seqres.full
+
+	if [[ start_blocks[0] -ne 0 ]]; then
+		# Choose the block to error, currently only works with a single extent.
+		error_daddr=$((start_blocks[0] + error_at_block*block_size/512))
+	else
+		# Default to the inode daddr when no extents were found.
+		# Errors when getfattr(1) stats the inode and doesnt get to getfattr(2)
+		error_daddr=$(_scratch_xfs_db -c "inode $inode" -c "daddr" | awk '{print $4}')
+	fi
+
+	_scratch_mount
+
+	echo "Setup scsi_debug to error when reading attributes from block" \
+	     "$error_at_block at daddr $error_daddr" >> $seqres.full
+	echo $error_daddr > /sys/module/scsi_debug/parameters/medium_error_start
+	echo $error_length > /sys/module/scsi_debug/parameters/medium_error_count
+	echo $scsi_debug_opt_error > /sys/module/scsi_debug/parameters/opts
+	grep ^ /sys/module/scsi_debug/parameters/{medium_error_start,medium_error_count,opts} >> $seqres.full
+
+	echo "Read the extended attribute on $testfile" >> $seqres.full
+	sync # the fstests logs to disk.
+
+	_getfattr -d -m - $testfile >> $seqres.full 2>&1 # Panic here on failure
+}
+
+# aformat shortform
+test_attr "attr_local" 0 0
+
+# aformat extents
+# Single leaf block, known to panic
+test_attr "attr_extent_one_block" 1 0
+
+# Other tests to exercise multi block extents
+test_attr "attr_extent_two_blocks_1" 2 1
+test_attr "attr_extent_two_blocks_2" 2 2
+
+# success, all done
+echo Silence is golden
+status=0
+exit
diff --git a/tests/xfs/999.out b/tests/xfs/999.out
new file mode 100644
index 00000000..3b276ca8
--- /dev/null
+++ b/tests/xfs/999.out
@@ -0,0 +1,2 @@
+QA output created by 999
+Silence is golden
-- 
2.47.3

