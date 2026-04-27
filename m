Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3710130AAB8;
	Mon, 27 Apr 2026 10:20:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777285206; cv=none; b=o4j8ytETTvlMo4KORL4Z5/8e+RFs9eTIRYf+pddLEaITE9aaRUw+TKIDdfxd2iXqEnhB+5FvaBrada+sM6no5XdDacCdjhtxwVKaxxceLvJtRze4a/MVNl5lkV+7XhGtdWOEDbKS4IGc+EtArPbesmsClhDex6ZVpPXio99mrXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777285206; c=relaxed/simple;
	bh=VwZRCisy/qfCCWVJ0a6E461W3POyJm/hXSbpwzUICM0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LpebCWZ3XRlMaq2sQhELx4rhYdE9DVDwQRDqZUNoXVZS3b4S0sMHZ2BOk3y/hwHHy8Gc1/7rNAR6Hqyxter1EVtswq4GyTbi87Wd4UtCX0urCCl+sQ48VNphdkcVPnpzlOhP/MOO2YALe+ixwb3avS0LOCmr2TpyzqBVmV0P8DQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iGVtO6WD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iGVtO6WD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34A10C2BCB6;
	Mon, 27 Apr 2026 10:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777285205;
	bh=VwZRCisy/qfCCWVJ0a6E461W3POyJm/hXSbpwzUICM0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iGVtO6WDaAMNO18PAQV1ExHzfFMMKiSIY08HZd9RLASaoUp6qoZaX4TM5ffcA7XJG
	 9Q/40piNGv0iiLInrV2mAfGkeDCf5ZIULfoHg6BaGW7lHYLms2CM1COKOKSmM0AyfM
	 TrdP4QSbchZlBvRwnOdSAoQsPy4fJ5rqNpceq0WyaBwr75FaWHQzdKLQjViQaIvW2X
	 9pJ4OFSchq+t9hQc5q5WSeQxTk/sL35ujzDbxMTVIeIslf2Vb0aRpkb4N2NbdbyfUh
	 L/IxMrLpDqJPEz6N25+hu36KAMY0wn8rnmi6kqVpDsxjUJx85nbxybMyuqBo6RIzO4
	 AYd80R52625MQ==
From: Anand Jain <asj@kernel.org>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-f2fs@vger.kernel.org,
	amir73il@gmail.com,
	zlang@redhat.com,
	hch@infradead.org
Subject: [PATCH v3 5/9] fstests: verify f_fsid for cloned filesystems
Date: Mon, 27 Apr 2026 18:19:37 +0800
Message-ID: <8afe801010f2c444a47a87225a8ead03d68ab71e.1777281778.git.asj@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1777281778.git.asj@kernel.org>
References: <cover.1777281778.git.asj@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Verify that the cloned filesystem provides an f_fsid that is persistent
across mount cycles, yet unique from the original filesystem's f_fsid.

Signed-off-by: Anand Jain <asj@kernel.org>
---
 tests/generic/802     | 61 +++++++++++++++++++++++++++++++++++++++++++
 tests/generic/802.out |  7 +++++
 2 files changed, 68 insertions(+)
 create mode 100644 tests/generic/802
 create mode 100644 tests/generic/802.out

diff --git a/tests/generic/802 b/tests/generic/802
new file mode 100644
index 000000000000..83e75dcd0d78
--- /dev/null
+++ b/tests/generic/802
@@ -0,0 +1,61 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2026 Anand Jain <asj@kernel.org>.  All Rights Reserved.
+#
+# FS QA Test 802
+# Verify f_fsid and s_uuid of cloned filesystems across mount cycle.
+
+. ./common/preamble
+
+_begin_fstest auto quick mount clone
+
+_require_test
+_require_loop
+
+[ "$FSTYP" = "btrfs" ] && _fixed_by_kernel_commit xxxxxxxxxxxx \
+	"btrfs: use on-disk uuid for s_uuid in temp_fsid mounts"
+[ "$FSTYP" = "btrfs" ] && _fixed_by_kernel_commit xxxxxxxxxxxx \
+	"btrfs: derive f_fsid from on-disk fsuuid and dev_t"
+
+_cleanup()
+{
+	cd /
+	rm -r -f $tmp.*
+	umount $mnt1 $mnt2 2>/dev/null
+	_loop_image_destroy "${devs[@]}" 2> /dev/null
+}
+
+devs=()
+_loop_image_create_clone devs
+mkdir -p $TEST_DIR/$seq
+mnt1=$TEST_DIR/$seq/mnt1
+mnt2=$TEST_DIR/$seq/mnt2
+mkdir -p $mnt1
+mkdir -p $mnt2
+
+_mount $(_common_dev_mount_options) $(_clone_mount_option) ${devs[0]} $mnt1 || \
+						_fail "Failed to mount dev1"
+_mount $(_common_dev_mount_options) $(_clone_mount_option) ${devs[1]} $mnt2 || \
+						_fail "Failed to mount dev2"
+
+fsid_scratch=$(stat -f -c "%i" $mnt1)
+fsid_clone=$(stat -f -c "%i" $mnt2)
+
+echo "**** fsid initially ****"
+echo $fsid_scratch | sed -e "s/$fsid_scratch/FSID_SCRATCH/g"
+echo $fsid_clone | sed -e "s/$fsid_clone/FSID_CLONE/g"
+
+# Make sure fsid still match across a mount cycle, also reverse the order.
+echo "**** fsid after mount cycle ****"
+_unmount $mnt1
+_unmount $mnt2
+_mount $(_common_dev_mount_options) $(_clone_mount_option) ${devs[1]} $mnt2 || \
+						_fail "Failed to mount dev2"
+_mount $(_common_dev_mount_options) $(_clone_mount_option) ${devs[0]} $mnt1 || \
+						_fail "Failed to mount dev1"
+
+stat -f -c "%i" $mnt1 | sed -e "s/$fsid_scratch/FSID_SCRATCH/g"
+stat -f -c "%i" $mnt2 | sed -e "s/$fsid_clone/FSID_CLONE/g"
+
+status=0
+exit
diff --git a/tests/generic/802.out b/tests/generic/802.out
new file mode 100644
index 000000000000..d1e008f122bb
--- /dev/null
+++ b/tests/generic/802.out
@@ -0,0 +1,7 @@
+QA output created by 802
+**** fsid initially ****
+FSID_SCRATCH
+FSID_CLONE
+**** fsid after mount cycle ****
+FSID_SCRATCH
+FSID_CLONE
-- 
2.43.0

