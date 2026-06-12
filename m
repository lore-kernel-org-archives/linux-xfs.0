Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10A5A3DA7D0;
	Fri, 12 Jun 2026 07:43:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781250222; cv=none; b=fFpYiizWhG4FDmNcOWa8kYVnQY+rn0N5998Toh1F2ORx9n4yet5cw5jQUrAuGUEuifHeFSt8TLjmoVXrD7xVPEBwHcm4m305aDyiZsBwIuoAmir2eTG5hMl1bcPYfLIKcwiJDlZioLusMFzkQlUWGyVFK4YlV+oCqwbUAqu02+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781250222; c=relaxed/simple;
	bh=VG6R73vj38v4bMGBH44EEnKJz6dPxiGNA/LWNXnfvRE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ivVDVJQF3ujYGSAOcfiRE/Sdu49c+ScTUuHcok0vtcs5Zfb3OkjGABOLiWhPNB0p7x4SiIzcz1s4co3Nm4cpmfmIIqVJrT5gqTALrM7HRGQs0cOsTWOwiXwWNFXaFh4pHeUS4kFYA8dIYhCirt/u9YqoHFucBLduxXvZE4hczhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 4d83e2ca663211f1aa26b74ffac11d73-20260612
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_EXISTED
	SN_EXISTED, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS, CIE_GOOD
	CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO, GTI_C_BU, AMN_T1
	AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:0e0a7a4d-2d18-4871-8de8-6e176657b36d,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:10
X-CID-INFO: VERSION:1.3.12,REQID:0e0a7a4d-2d18-4871-8de8-6e176657b36d,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:10
X-CID-META: VersionHash:e7bac3a,CLOUDID:3e24d094d192f14e502cfa40745704fd,BulkI
	D:260612154328WK595Y91,BulkQuantity:0,Recheck:0,SF:10|66|78|102|127|850|86
	5|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:99|1,File:nil,RT:nil,Bulk:ni
	l,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE
	:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULS
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 4d83e2ca663211f1aa26b74ffac11d73-20260612
X-User: sangyao@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <sangyao@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1067879763; Fri, 12 Jun 2026 15:42:46 +0800
From: Yao Sang <sangyao@kylinos.cn>
To: fstests@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	hch@lst.de,
	djwong@kernel.org,
	zlang@kernel.org,
	Yao Sang <sangyao@kylinos.cn>
Subject: [PATCH] xfs/333: test zoned realtime writeback EIO shutdown
Date: Fri, 12 Jun 2026 15:42:31 +0800
Message-Id: <20260612074231.1109213-1-sangyao@kylinos.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Create a zoned realtime filesystem with a single user data open zone,
dirty one zone worth of data, and inject a writeback error on the
realtime device.

After disabling fault injection, fsync a second write.  The filesystem
must already be shut down so that the second fsync fails quickly instead
of waiting for zoned allocation progress.

Signed-off-by: Yao Sang <sangyao@kylinos.cn>
---
This is a test for the XFS zoned writeback shutdown fix posted as:
https://lore.kernel.org/all/20260611015305.1583003-1-sangyao@kylinos.cn/

Tested on a ZNS realtime XFS setup with fail_make_request enabled.  The
test passes with the v2 XFS fix applied.  On a kernel without that fix,
the second fsync waits behind the consumed open zone and reproduces the
hung writer condition.

 tests/xfs/333     | 69 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/333.out |  1 +
 2 files changed, 70 insertions(+)
 create mode 100755 tests/xfs/333
 create mode 100644 tests/xfs/333.out

diff --git a/tests/xfs/333 b/tests/xfs/333
new file mode 100755
index 00000000..aafee4c3
--- /dev/null
+++ b/tests/xfs/333
@@ -0,0 +1,69 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2026 Kylin Software.
+#
+# FS QA Test No. 333
+#
+# Check that an unrecoverable writeback error on a zoned realtime device shuts
+# down the filesystem.
+#
+. ./common/preamble
+_begin_fstest auto quick rw zone eio
+
+. ./common/filter
+. ./common/fail_make_request
+. ./common/zoned
+
+_require_debugfs
+_require_scratch_nocheck
+_require_realtime
+_require_block_device $SCRATCH_RTDEV
+_require_zoned_device $SCRATCH_RTDEV
+_require_command "$BLKZONE_PROG" blkzone
+_require_fail_make_request
+
+_cleanup()
+{
+	[ -n "$SCRATCH_RTDEV" ] && \
+		_bdev_fail_make_request $SCRATCH_RTDEV 0 > /dev/null 2>&1
+	_disallow_fail_make_request > /dev/null 2>&1
+	_scratch_unmount > /dev/null 2>&1
+	cd /
+	rm -r -f $tmp.*
+}
+_register_cleanup _cleanup
+
+zone_capacity=$(_zone_capacity 0 $SCRATCH_RTDEV)
+echo "zone capacity: $zone_capacity" >> $seqres.full
+
+_scratch_mkfs_sized $((256 * 1024 * 1024)) >> $seqres.full 2>&1
+
+# Leave only one open zone for user data.  If writeback fails after consuming
+# it, further writers must either see shutdown or wait forever for zone space.
+export MOUNT_OPTIONS="$MOUNT_OPTIONS -o max_open_zones=2"
+_try_scratch_mount || _notrun "mount option not supported"
+_require_xfs_scratch_zoned 1
+
+_prepare_for_eio_shutdown $SCRATCH_DEV
+
+testfile=$SCRATCH_MNT/writeback-error
+waitfile=$SCRATCH_MNT/wait-for-zone
+
+$XFS_IO_PROG -f -c "pwrite -S 0x58 0 $zone_capacity" $testfile \
+	>> $seqres.full 2>&1 || _fail "failed to dirty test file"
+
+_allow_fail_make_request 100 100000 0 > /dev/null
+_bdev_fail_make_request $SCRATCH_RTDEV 1 > /dev/null
+
+$XFS_IO_PROG -c "fsync" $testfile >> $seqres.full 2>&1 && \
+	_fail "fsync succeeded despite realtime device error"
+
+_bdev_fail_make_request $SCRATCH_RTDEV 0 > /dev/null
+_disallow_fail_make_request > /dev/null
+
+$XFS_IO_PROG -f -c "pwrite -S 0x59 0 4k" -c "fsync" $waitfile \
+	>> $seqres.full 2>&1 && \
+	_fail "filesystem did not shut down after zoned writeback error"
+
+status=0
+exit
diff --git a/tests/xfs/333.out b/tests/xfs/333.out
new file mode 100644
index 00000000..3e11d156
--- /dev/null
+++ b/tests/xfs/333.out
@@ -0,0 +1 @@
+QA output created by 333
-- 
2.25.1

