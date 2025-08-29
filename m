Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49E3C8635B
	for <linux-xfs@vger.kernel.org>; Fri, 29 Aug 2025 04:25:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756441503; cv=none; b=FXBBNR79aIGISWfIQsYDcybh+0LpGF/+8/Muks84NTHzrJP9zBxZpSz4m48kLokz7Ix7VFVGnashOXNQn/Wn37tD6jQluEWLSE8ZvLetsK2qK2pudpAg/0WmVKC3xHhw70jWxW7i+m5NJPLnfY6GC9jZqBa3q0gldKD2G8GWb7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756441503; c=relaxed/simple;
	bh=FtTDPacfmoD9HK6zLQlLf2BlSfxN97cbyEKVlgjs2gQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DoT0onUKJ/upa7JCqa7vmtSXXUiFxA4oHAkXI3EuM21L3EFqqsw86jRgfuZslukqMCmhq821rd1mfjIZg+5BjWEHoGkwhqv6iwSumjBzv+hSmMk0vFYpYqXW6qaw/igQHjcqjq6pxVKpTdaEYcNjaCH3fRWY/VtUm+V3ZhDj81U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QtzRTAR+; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QtzRTAR+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756441500;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=dp4BXne68o6Cg8PN64vuhM1+ukqTn/tTVKXRMnVGrrY=;
	b=QtzRTAR+R3qJzfSuzMKWGsAiG4CGiHD+msSgs9A2nZ3UUN4fp7mZHMYU8i8uI+4IV/xESa
	AWvyBMoM9Qn/O/g07+Gvoub3l/lm60Zshyh24Ijm0QjwKKpNy1f/fy70pFaj+cVYSZUED1
	ou3b879zTExewqaTuh7rl4m1486LncQ=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-19-VJ3GT0p7P3-6hzk4sFlxPQ-1; Fri, 29 Aug 2025 00:24:55 -0400
X-MC-Unique: VJ3GT0p7P3-6hzk4sFlxPQ-1
X-Mimecast-MFC-AGG-ID: VJ3GT0p7P3-6hzk4sFlxPQ_1756441495
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-324e4c3af5fso1801911a91.3
        for <linux-xfs@vger.kernel.org>; Thu, 28 Aug 2025 21:24:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756441494; x=1757046294;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dp4BXne68o6Cg8PN64vuhM1+ukqTn/tTVKXRMnVGrrY=;
        b=bpvnJXcLyHUDc84GeW6ZsOG97MnwksQJMPIY0jOWyDC/D44un3Nlqg6XCx9HFtuE50
         Dy25jM/sStG2jOcWkI8N4Y/hCLMq/FK+JyRBSsN3UgZrRDmNmUomXgNUYaSsFdiumPUc
         HawxWOTI/1e1yUKyBelqOnuvG6IiCjW5m5g6DJjtH9/WTWzvckcP0VgD8R8RcN5lw7Mt
         TO5p7K+CfmX4jwsMdNpbtKWDKc8LjavqqTAfTlEepQQxJun+WZD1gIgFpLuKtWu7UGP4
         OONSdYyiL4EUihZGpV+Ov1fm1M8TEgbBxhM9OZ/ATNWQ1RFZv3SftUU4diAHF1+I9dbS
         Zfpg==
X-Gm-Message-State: AOJu0Yw4aIQqajF503Xf9Upbk5FqWjfNk/KYEbk+2Llv5xYXBj8DrWcb
	ALSnvZ62rsC+2/KA7AHDEfDoHjN46KGupP2Xl52hX03byvJLzhZtzp/waCDsL7PufcwItqDQlPk
	WgZkBkL4eFpLx3D7BpreGDEazA+tSkSP3Z0LNWecqTplHt9ixcGW7CXCaar5EQaV1V6AX4XSsTh
	ZUYl4pzWPo/52MnrJRNHTHUIooYd/tpWgbFj3lCG/6egVHpQ==
X-Gm-Gg: ASbGncurZ46BpDrEKnBJkDOteu3Py9aSBUe/zYAFAYIjkmpK/odePzVw1JZsQR0YL0E
	Msvhu33aXzB1k7At3jgopXBGvYwpgeH1DiukjLO2pOFbzuSMlFRRZCQ2e0FKlX1PbaUicA8UvO6
	th9yQXAj8dItUZP7Afre+upqwkbNuG9CXGGxGjEIF0hB1xNt46jv3E1hedgLNVHLAHlnDBzdwBv
	H/jNIvmRKLFhWRlBogeUXnKn/A8GBoMZvMxQamnV19PM3Z+DqbVzJh80WjBmDhHC6qzQkVlp4p+
	hmiVmsqwo5eQwZfWSY/6Ge4knLih1yXVEZpTFYMKnQgTyI+G2gI=
X-Received: by 2002:a17:90b:580f:b0:327:7220:f579 with SMTP id 98e67ed59e1d1-3277220fafdmr10345533a91.1.1756441494213;
        Thu, 28 Aug 2025 21:24:54 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG/u5ws/USceBHJevRCpT7Lh7kUQ6FIrgDU1lsl7emU4vp5r70e2phEKMYAfd1q8UcPKg6QoA==
X-Received: by 2002:a17:90b:580f:b0:327:7220:f579 with SMTP id 98e67ed59e1d1-3277220fafdmr10345498a91.1.1756441493553;
        Thu, 28 Aug 2025 21:24:53 -0700 (PDT)
Received: from anathem.redhat.com ([2001:8003:4a36:e700:8cd:5151:364a:2095])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b4cd28ad188sm919668a12.26.2025.08.28.21.24.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Aug 2025 21:24:53 -0700 (PDT)
From: Donald Douwsma <ddouwsma@redhat.com>
To: linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org
Cc: Eric Sandeen <sandeen@sandeen.net>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Donald Douwsma <ddouwsma@redhat.com>
Subject: [PATCH v2] xfs: test case for handling io errors when reading extended attributes
Date: Fri, 29 Aug 2025 14:24:19 +1000
Message-ID: <20250829042419.1084367-1-ddouwsma@redhat.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We've seen reports from the field panicing in xfs_trans_brelse after
an io error for an attribute block.

sd 0:0:23:0: [sdx] tag#271 CDB: Read(16) 88 00 00 00 00 00 9b df 5e 78 00 00 00 08 00 00
critical medium error, dev sdx, sector 2615107192 op 0x0:(READ) flags 0x1000 phys_seg 1 prio class 2
XFS (sdx1): metadata I/O error in "xfs_da_read_buf+0xe1/0x140 [xfs]" at daddr 0x9bdf5678 len 8 error 61
BUG: kernel NULL pointer dereference, address: 00000000000000e0
...
RIP: 0010:xfs_trans_brelse+0xb/0xe0 [xfs]
...
Call Trace:
 <TASK>
 ...
 ? xfs_trans_brelse+0xb/0xe0 [xfs]
 xfs_attr_leaf_get+0xb6/0xc0 [xfs]
 xfs_attr_get+0xa0/0xd0 [xfs]
 xfs_xattr_get+0x75/0xb0 [xfs]
 __vfs_getxattr+0x53/0x70
 inode_doinit_use_xattr+0x63/0x180
 inode_doinit_with_dentry+0x196/0x510
 security_d_instantiate+0x2f/0x50
 d_splice_alias+0x46/0x2b0
 xfs_vn_lookup+0x8b/0xb0 [xfs]
 __lookup_slow+0x84/0x130
 walk_component+0x158/0x1d0
 path_lookupat+0x6e/0x1c0
 filename_lookup+0xcf/0x1d0
 vfs_statx+0x8d/0x170
 vfs_fstatat+0x54/0x70
 __do_sys_newfstatat+0x26/0x60

As this is specific to ENODATA test using scsi_debug instead of dmerror
which returns EIO.

Signed-off-by: Donald Douwsma <ddouwsma@redhat.com>
---
 tests/xfs/999     | 193 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/999.out |   2 +
 2 files changed, 195 insertions(+)
 create mode 100755 tests/xfs/999
 create mode 100644 tests/xfs/999.out

diff --git a/tests/xfs/999 b/tests/xfs/999
new file mode 100755
index 00000000..2a45eb7c
--- /dev/null
+++ b/tests/xfs/999
@@ -0,0 +1,193 @@
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
+#   [53887.310123] Call Trace:
+#    <TASK>
+#    ? show_trace_log_lvl+0x1c4/0x2df
+#    ? show_trace_log_lvl+0x1c4/0x2df
+#    ? xfs_attr_leaf_get+0xb6/0xc0 [xfs]
+#    ? __die_body.cold+0x8/0xd
+#    ? page_fault_oops+0x134/0x170
+#    ? xfs_trans_read_buf_map+0x133/0x300 [xfs]
+#    ? exc_page_fault+0x62/0x150
+#    ? asm_exc_page_fault+0x22/0x30
+#    ? xfs_trans_brelse+0xb/0xe0 [xfs]
+#    xfs_attr_leaf_get+0xb6/0xc0 [xfs]
+#    xfs_attr_get+0xa0/0xd0 [xfs]
+#    xfs_xattr_get+0x88/0xd0 [xfs]
+#    __vfs_getxattr+0x7b/0xb0
+#    inode_doinit_use_xattr+0x63/0x180
+#    inode_doinit_with_dentry+0x196/0x510
+#    security_d_instantiate+0x3a/0xb0
+#    d_splice_alias+0x46/0x2b0
+#    xfs_vn_lookup+0x8b/0xb0 [xfs]
+#    __lookup_slow+0x81/0x130
+#    walk_component+0x158/0x1d0
+#    ? path_init+0x2c5/0x3f0
+#    path_lookupat+0x6e/0x1c0
+#    filename_lookup+0xcf/0x1d0
+#    ? tlb_finish_mmu+0x65/0x150
+#    vfs_statx+0x82/0x160
+#    vfs_fstatat+0x54/0x70
+#    __do_sys_newfstatat+0x26/0x60
+#    do_syscall_64+0x5c/0xe0
+#
+# For SELinux enabled filesystems the attribute security.selinux will be
+# created before any additional attributes are added. Any attempt to open the
+# file will read this entry, leading to the panic being triggered as above, via
+# security_d_instantiate, rather than fgetxattr(2), to test via fgetxattr mount
+# with a fixed context=
+#
+# Kernels prior to v4.16 don't have medium_error_start, and only return errors
+# for a specific location, making scsi_debug unsuitable for checking old kernels.
+# See d9da891a892a scsi: scsi_debug: Add two new parameters to scsi_debug driver
+#
+
+. ./common/preamble
+_begin_fstest auto
+
+_fixed_by_kernel_commit ae668cd567a6 "xfs: do not propagate ENODATA disk errors into xattr code"
+
+# Override the default cleanup function.
+_cleanup()
+{
+	cd /
+	rm -f $tmp.*
+	_unmount $SCRATCH_MNT
+	_put_scsi_debug_dev
+}
+
+# Import common functions.
+. ./common/scsi_debug
+
+_require_scsi_debug
+modinfo scsi_debug | grep -wq medium_error_start || _notrun "test requires scsi_debug medium_error_start"
+scsi_debug_dev=$(_get_scsi_debug_dev)
+test -b $scsi_debug_dev || _notrun "Failed to initialize scsi debug device"
+echo "SCSI debug device $scsi_debug_dev" >>$seqres.full
+
+_mkfs_dev $scsi_debug_dev  >> $seqres.full
+_mount $scsi_debug_dev $SCRATCH_MNT  >> $seqres.full
+
+blocksize=$(_get_block_size $SCRATCH_MNT) >> $seqres.full
+echo Blocksize $blocksize >> $seqres.full
+
+# Use dry_run=1 when verifying the test to avoid panicking.
+enable_error=1
+[ ${dry_run:-0} -eq 1 ] && enable_error=0
+
+test_attr()
+{
+	test=$1
+	testfile=$SCRATCH_MNT/$test
+	attr_size=$2 # bytes
+	error_at_block=${3:-0}
+	shift 3
+
+	value_size=$attr_size
+
+	echo 0 > /sys/module/scsi_debug/parameters/opts
+
+	echo -e "\nTesting : $test" >> $seqres.full
+	echo -e "attr size: $attr_size" >> $seqres.full
+	echo -e "error at block: $error_at_block\n" >> $seqres.full
+
+	touch $testfile
+
+	inode=$(ls -i $testfile|awk '{print $1}')
+	printf "inode: %d Testfile: %s\n" $inode $testfile >> $seqres.full
+	setfattr -n user.test_attr -v $(printf "%0*d" $value_size $value_size) $testfile
+
+	$XFS_IO_PROG -c "bmap -al" $testfile >> $seqres.full
+	start_blocks=($($XFS_IO_PROG -c "bmap -al" $testfile | awk 'match($3, /[0-9]+/, a) {print a[0]}'))
+	echo "Attribute fork extent(s) start at ${attrblocks[*]}" >> $seqres.full
+
+	_unmount $SCRATCH_MNT >>$seqres.full 2>&1
+
+	echo "Dump inode $inode details with xfs_db" >> $seqres.full
+	$XFS_DB_PROG -c "inode $inode" -c "print core.aformat core.naextents a" $scsi_debug_dev >> $seqres.full
+	inode_daddr=$($XFS_DB_PROG -c "inode $inode" -c "daddr" $scsi_debug_dev | awk '{print $4}')
+	echo inode daddr $inode_daddr >> $seqres.full
+
+
+	_mount $scsi_debug_dev $SCRATCH_MNT  >> $seqres.full
+
+        if [[ start_blocks[0] -ne 0 ]]; then
+                # Choose the block to error, currently only works with a single extent.
+                error_daddr=$((start_blocks[0] + error_at_block*blocksize/512))
+        else
+                # Default to the inode daddr when no extents were found.
+                # Fails reading the inode during stat, so arguably useless
+                # even for testing the upper layers of getfattr.
+                error_daddr=$inode_daddr
+        fi
+
+	echo "Setup scsi_debug to error when reading attributes from block" \
+	     "$error_at_block at daddr $error_daddr" >> $seqres.full
+	echo $error_daddr > /sys/module/scsi_debug/parameters/medium_error_start
+	echo $(($blocksize/512)) > /sys/module/scsi_debug/parameters/medium_error_count
+
+	if [ $enable_error -eq 1 ]; then
+		echo Enabling error >> $seqres.full
+        	echo 2 > /sys/module/scsi_debug/parameters/opts
+	fi
+
+	grep ^ /sys/module/scsi_debug/parameters/{medium_error_start,medium_error_count,opts} >> $seqres.full
+
+	echo "Re-read the extended attribute on $testfile, panics on IO errors" >> $seqres.full
+	sync # Let folk see where we failed in the results.
+	getfattr -d -m - $testfile >> $seqres.full 2>&1 # Panic here on failure
+}
+
+
+# TODO: Avoid assumptions about inode size using _xfs_get_inode_size and
+#       _xfs_get_inode_core_bytes, currently assuming 512 byte inodes.
+
+# aformat shortform
+# Include shortform for completeness, we can only inject errors for attributes
+# stored outside of the inode.
+test_attr "attr_local" 1 0
+
+# aformat extents
+# Single leaf block, known to panic
+test_attr "attr_extent_one_block" 512 0
+
+# Other tests to exercise multi block extents and multi extent attribute forks.
+# Before the panic was understood it seemed possible that failing on the second
+# block of a multi block attribute fork was involved. Seems like it may be
+# worth testing in the future.
+
+test_attr "attr_extent_two_blocks_1" 5000 0
+test_attr "attr_extent_two_blocks_2" 5000 1
+# test_attr "attr_extent_many_blocks" 16000 4
+#
+# When using a single name=value pair to fill the space these tend to push out
+# to multiple extents, rather than a single long extent, so don't yet test
+# failing subsequent blocks within the first extent.
+#
+# i.e.
+# xfs_bmap -va $testfile
+# /mnt/test/testfile:
+# EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET        TOTAL
+#   0: [0..7]:          96..103           0 (96..103)            8
+#   1: [8..23]:         80..95            0 (80..95)            16
+
+# aformat btree
+# test_attr "attr_extents" 50000 0
+# test_attr "attr_extents" 50000 $blocksize
+# test_attr "attr_extents" 50000 $((blocksize+1))
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

