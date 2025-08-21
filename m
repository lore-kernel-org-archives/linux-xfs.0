Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7AAB2E62A7
	for <linux-xfs@vger.kernel.org>; Thu, 21 Aug 2025 09:30:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755768620; cv=none; b=Xr1e0sQsMVMSRZV/CNXCHse+cLedyB/C3qGg5EIvd9yXCEYtr2ca7Ev70lf1fLE5+ii1O/fj1J1T6S7dEv0xZz8mwUb86mB00chK02ZyD5G4HqzZvBcX2tcr1D6FkIAGT14QO+YYWnsiTM7OdTS2LbjqSvXJyWOkHBFYdON79eg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755768620; c=relaxed/simple;
	bh=o22Hk9otW/s/CRi3ShVpeEZEHf/i2LjYsH1yhxMsm1Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Llq7ZUFkISc6j3aqWYBQJyAEi/hEGlpRyLQYxlCdKS7/dyhXgAKFJZpK84HyzMajS0kh2FMeZM/oLTPS+Qhb6ea+9NX6k9qqiaZpd3zc2Q/4m2KGv8NkaVrujwBBH+RxDFR5ZJl+mE9oCcyKfd1Oylueaic7FD4nVNAf/k/ovAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hVh/xacx; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hVh/xacx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755768617;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cdKAT3gnEurg7f8F4Qahokkk+t8y1qQUrpo9IdJTSzo=;
	b=hVh/xacxknLWwcmGvaac/V99k7i/CdyYsU95OIjy+z2yvJFHxoPrWsuq598Dqt3CPrpXU0
	FKMUELK5P7TtIRYG6vcJ+xMpIF9hPsyIUy93jMF2gHsICjINk04aJHgk1Eu3/wVuldiUbo
	52NJ4Pwbmr2dVVPKtmuRpUtaaRDGgEY=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-691-rzuLwfV-PleygIyYgOvOWQ-1; Thu, 21 Aug 2025 05:30:16 -0400
X-MC-Unique: rzuLwfV-PleygIyYgOvOWQ-1
X-Mimecast-MFC-AGG-ID: rzuLwfV-PleygIyYgOvOWQ_1755768615
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2445805d386so10330005ad.1
        for <linux-xfs@vger.kernel.org>; Thu, 21 Aug 2025 02:30:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755768615; x=1756373415;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cdKAT3gnEurg7f8F4Qahokkk+t8y1qQUrpo9IdJTSzo=;
        b=VEJGkV+zU2TRSQjcM9oEJdl1r2+PStckVjUZp47Y6rrxZUN8am+2Q25SMw8DOYnMmQ
         7EuFSl3zoHfiNaiABj5aev+zTiO3QftAhnf9f1X1h4QQGeLQR9RvzIuQQHV/pyG5E0g8
         x4c8I/lWfLMobVELdLUCmVr3IxzEt+gBkmXxFFnUHlpypri9b3H7rf6GZpcH0yU4WCM2
         HXklCSjZyiCSRWDi3uRFjQ1pycuNqfhbhO3CIlTXjl2LPqcb4tpdqSEMpPTwWA5fhjR4
         BenTEiLGCS/dZYqgSRjyhmdRdGwB7xRW1RvABni5pe1t0d6pEXpq588h/L9eTLu/pADe
         3MHA==
X-Gm-Message-State: AOJu0Yxu5zPEHVQ8HfWXgKtwX37HhGwG6CLi3zc4ynSBAMBtNLxS/dFf
	ajciHhCQ1pTOEr4xSOQyv+xnSvElHoSPJU0DxXkzARbKo3ei+hCvY5OwTXMuLvk50rYCzo04zv/
	+I2rCRWAbrMf4emIO9yNNS0zQir6BihE9zfe0+vHPiHp+Y0HhlhbewPpWi5RT6ml4Jz/Yrl//bn
	bvaLkss9oYXzh7yeZSShwftOAA2nNe6clR8OBYc/ox6YNU7g==
X-Gm-Gg: ASbGncvzSOFvK0YU9bfhqRz3Dc2rVT6VIj2vW+JfyR4Kkbn0+k5PY9/vTEb7y4DEFYw
	MHnfZdqIm4y21FgpYo5F6aAqMTKnzmqFsh3MfbVYmtkcloQzqQU5PIAhaDhoDxR516ssVDfJSKc
	7bh5lGorGf0abZj7TseG4jHU5uT8T9chpW26B707eZ3to0dhubKtzjbGYCIWdlvCy6wB6gl5nHj
	ShQ+3uYa2n4Mix8qvMUNeEnrdKaVQd0xMN27G3LqIezZ6SUespRjLjboYeOPo6FqHlL7ajy/9oY
	GAQed+aOn5Crh/JESkhKmgKiUNsSd4TkEPx9vdFi0FtsWFsLQMw=
X-Received: by 2002:a17:902:e544:b0:240:71ad:a442 with SMTP id d9443c01a7336-245febef1f9mr22454135ad.9.1755768614733;
        Thu, 21 Aug 2025 02:30:14 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFvGnGKkd+QvIqLEO9xXQi5sQSghWtlQlrNXJvvEg4L+DO5uQ6r0lchBFvq3AAKhh0Jfdcyog==
X-Received: by 2002:a17:902:e544:b0:240:71ad:a442 with SMTP id d9443c01a7336-245febef1f9mr22453775ad.9.1755768614161;
        Thu, 21 Aug 2025 02:30:14 -0700 (PDT)
Received: from anathem.redhat.com ([2001:8003:4a36:e700:8cd:5151:364a:2095])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-245ed336002sm50310155ad.5.2025.08.21.02.30.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Aug 2025 02:30:13 -0700 (PDT)
From: Donald Douwsma <ddouwsma@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	Eric Sandeen <sandeen@redhat.com>,
	Donald Douwsma <ddouwsma@redhat.com>
Subject: [PATCH] xfs: test case for handling io errors when reading extended attributes
Date: Thu, 21 Aug 2025 19:29:54 +1000
Message-ID: <20250821092954.3428519-1-ddouwsma@redhat.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <85ac8fbf-2d12-4b2e-9bfa-010867a91ecd@redhat.com>
References: <85ac8fbf-2d12-4b2e-9bfa-010867a91ecd@redhat.com>
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

This was an unsuccessful attempt to reproduce this using dmerror.

It should provoke the problem if a system tap or custom kernel is used
to return ENODATA as seen above, and not EIO as returned by dmerror.

Signed-off-by: Donald Douwsma <ddouwsma@redhat.com>
---
 tests/xfs/999     | 107 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/999.out |   2 +
 2 files changed, 109 insertions(+)
 create mode 100755 tests/xfs/999
 create mode 100644 tests/xfs/999.out

diff --git a/tests/xfs/999 b/tests/xfs/999
new file mode 100755
index 00000000..627ca14e
--- /dev/null
+++ b/tests/xfs/999
@@ -0,0 +1,107 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2025 YOUR NAME HERE.  All Rights Reserved.
+#
+# FS QA Test 601
+#
+# what am I here for?
+# Test for panic during ioerror reading xattr blocks
+#
+. ./common/preamble
+_begin_fstest auto
+
+# Override the default cleanup function.
+_cleanup()
+{
+	cd /
+	rm -f $tmp.*
+	_dmerror_cleanup
+}
+
+# Import common functions.
+# . ./common/filter
+. ./common/dmerror
+
+# real QA test starts here
+
+# Modify as appropriate.
+_require_scratch
+_require_dm_target error
+
+_scratch_mkfs >> $seqres.full
+_scratch_mount
+
+# TODO: Avoid assumptions about inode size using _xfs_get_inode_size and
+#       _xfs_get_inode_core_bytes, currently assuming 512 byte inodes.
+
+# Shortform
+# Include shortform for completeness, we can only inject errors for attributes
+# stored outside of the inode.
+testfile="$SCRATCH_MNT/attr_shortform"
+touch $testfile
+ls -i $testfile >> $seqres.full
+setfattr -n user.test_shortform -v $(printf "%0.12d" 12) $testfile
+
+# leaf with single block extent
+testfile="$SCRATCH_MNT/attr_leaf_oneblock"
+touch $testfile
+ls -i $testfile >> $seqres.full
+setfattr -n user.test_leaf -v $(printf "%0.512d" 512) $testfile
+
+# leaf with single multiple block extent
+testfile="$SCRATCH_MNT/attr_leaf_twoblocks"
+touch $testfile
+ls -i $testfile >> $seqres.full
+inode=$(ls -i $testfile|awk '{print $1}')
+setfattr -n user.test_leaf -v $(printf "%0.5000d" 5000) $testfile
+
+# Generalise to for multiple attributes accross many blocks
+# size_name=
+# size_val=256 # how dows value>block-size work out?
+# num_attrs=2022
+# testfile="$SCRATCH_MNT/attr_leaf_manyblocks"
+# touch $testfile
+# ls -li $testfile
+# inode=$(ls -i $testfile|awk '{print $1}')
+#
+# for n_attr in $(seq 0 $num_attrs); do
+#	echo $n_attr;
+#	setfattr -n $(printf "user.test_leaf_%04d" $n_attr) \
+#		 -v $(printf "%0.${size_val}d" $size_val) \
+#		 $testfile
+# done
+
+$XFS_IO_PROG -c "bmap -al" $testfile >> $seqres.full
+attrblocks=($($XFS_IO_PROG -c "bmap -al" $testfile | awk 'match($3, /[0-9]+/, a) {print a[0]}'))
+echo Attribute fork at blocks ${attrblocks[*]} >> $seqres.full
+
+_scratch_unmount
+
+echo "Dump inode $inode details with xfs_db" >> $seqres.full
+# _scratch_xfs_db -c "inode $inode" -c "print core.aformat core.naextents a" >> $seqres.full
+_scratch_xfs_db -c "inode $inode" -c print >> $seqres.full
+
+_dmerror_init >> $seqres.full 2>&1
+_dmerror_reset_table >> $seqres.full 2>&1
+_dmerror_mount >> $seqres.full 2>&1
+
+echo "Setup dm-error when reading the second attribute block ${attrblocks[1]}" >> $seqres.full
+_dmerror_mark_range_bad ${attrblocks[1]} 1 $SCRATCH_DEV
+
+# Debug from tests/xfs/556
+cat >> $seqres.full << ENDL
+dmerror after marking bad:
+$DMERROR_TABLE
+$DMERROR_RTTABLE
+<end table>
+ENDL
+
+_dmerror_load_error_table
+
+# Panic here if failure
+echo "Re-read the extended attribute, panics on unandled ioerrors" >> $seqres.full
+getfattr -d -m - $testfile >> $seqres.full
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/999.out b/tests/xfs/999.out
new file mode 100644
index 00000000..e7f4becf
--- /dev/null
+++ b/tests/xfs/999.out
@@ -0,0 +1,2 @@
+QA output created by 999 
+Silence is golden
-- 
2.47.3

