Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E0183D6CA2;
	Wed, 25 Mar 2026 12:51:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.143.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774443066; cv=none; b=Ok58MQXtvljB8Un4/DpMaF9qZyOZAzFWDSAHBVOvspmFuJJQturXUZN/RfLA2D8bfdQnq/PH4wbFS6r/aatZ9GfuRKlnjAQj8ymWd5j7wA9UryP2SNotl1OgreaqgrWTY4difFDNwbfuccZ+EfAKGUGnlugHIfZ9T48gxQo8C9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774443066; c=relaxed/simple;
	bh=LsCbg7Ygwd8iHg2xO+UCMm7ePoyUX+JnkKLpyH4IEfs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=B4sLB3kGV97zJU1iKnWPmyXM+JMgPjDQCd/BrF56P16EdBVSPGqIw8WkS2GreBhv4ysehHDTKsV072KGS2Nv6uqiDiIpLW+5jmAbSIcpGxK6JCzzY0r/bfnso7jykzlUaCjB7gNoUtEMhE63qlTrcwQSgaUTl24AZ3Z7dGlQN84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=gPaPJDfF; arc=none smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="gPaPJDfF"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1774443063; x=1805979063;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=LsCbg7Ygwd8iHg2xO+UCMm7ePoyUX+JnkKLpyH4IEfs=;
  b=gPaPJDfFtkQ9C6I+pIf/3O/dWdVhNvd1b1IkQXEu3f1lABiauUexurgy
   OWHn1Pu1uKYFpMh4lnHi5hX1uwu5zW6/lXUMoOMKR8/iYzasJgId5e03E
   f6yOFSHeEKHhLn+375VskefYwWY48Ss/WDF+I9I1ps6QbQwaJkRy4EBxJ
   S8TinAhbVior6ScUIG+NGmL+sYCyyNmlTS5fBpkJiDBrkXcvyVV0g8t+L
   61mcBVoIfZkfCLAjv9iv475dm/jW3XA5y4oA5St7wSiWO6hdlKoSlJVSM
   2gwo4aswmAhE3s+IxkSPH76SIxJg7pQcG0c/cRmhqwrZHt1OsZs16PsHM
   Q==;
X-CSE-ConnectionGUID: s2b5FesbS228sXojInE60Q==
X-CSE-MsgGUID: 9IPjZqQ6RzWqoW9yp6PH1w==
X-IronPort-AV: E=Sophos;i="6.23,140,1770566400"; 
   d="scan'208";a="144343442"
Received: from unknown (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 25 Mar 2026 20:50:57 +0800
IronPort-SDR: 69c3da15_FVTm11UvjEE+V4VStVdTAWFblwhh4nxnKQnEcj03JxtITt5
 e5ddIzy3yYR256T2AQkosLZFudZNqgauk+zS4sA==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 25 Mar 2026 05:50:29 -0700
WDCIronportException: Internal
Received: from unknown (HELO gcv.wdc.com) ([10.224.20.47])
  by uls-op-cesaip01.wdc.com with ESMTP; 25 Mar 2026 05:50:26 -0700
From: Hans Holmberg <hans.holmberg@wdc.com>
To: zlang@kernel.org
Cc: fstests@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org,
	Hans Holmberg <hans.holmberg@wdc.com>
Subject: [PATCH] xfs: test that zone_gc_low_space writes start gc for rw fses
Date: Wed, 25 Mar 2026 13:50:13 +0100
Message-ID: <20260325125013.26631-1-hans.holmberg@wdc.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Test that writes to the systfs attribute zone_gc_low_space triggers
garbage collection for rw (but not ro) file systems.

Signed-off-by: Hans Holmberg <hans.holmberg@wdc.com>
---

This test will fail currently, but i've submitted a fix:
https://lore.kernel.org/linux-xfs/20260325124312.26349-1-hans.holmberg@wdc.com/

 tests/xfs/999     | 89 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/999.out |  2 ++
 2 files changed, 91 insertions(+)
 create mode 100755 tests/xfs/999
 create mode 100644 tests/xfs/999.out

diff --git a/tests/xfs/999 b/tests/xfs/999
new file mode 100755
index 000000000000..f3c2f868cb1e
--- /dev/null
+++ b/tests/xfs/999
@@ -0,0 +1,89 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2026 Western Digital Corporation
+#
+# FS QA Test No. 999
+#
+# Tests that writes to gc_low_space will trigger start of garbage
+# collection for rw (but not ro) file systems
+#
+. ./common/preamble
+_begin_fstest auto rw zone quick
+
+. ./common/zoned
+
+_require_scratch
+_require_odirect
+
+get_scratch_mountstat() {
+	awk -v mount="$SCRATCH_MNT" -v stat="$1" \
+		'$0~"mounted on "mount" with fstype xfs"{f=1} f&&index($0,stat){print $NF;exit}' \
+		/proc/self/mountstats
+}
+
+get_user_available_rt_blocks() {
+	get_scratch_mountstat "user available RT blocks:"
+}
+
+gc_required() {
+	get_scratch_mountstat "RT GC required:"
+}
+
+# figure out if the rt section is internal or not
+if [ -z "$SCRATCH_RTDEV" ]; then
+	zdev=$SCRATCH_DEV
+else
+	zdev=$SCRATCH_RTDEV
+fi
+
+capacity=$(_zone_capacity 0 $zdev)
+_scratch_mkfs_sized $(($capacity * 6)) > $seqres.full 2>&1
+
+# limit max open zones to avoid gc to trigger before we want it to
+export MOUNT_OPTIONS="$MOUNT_OPTIONS -o max_open_zones=2"
+_try_scratch_mount || _notrun "mount option not supported"
+_require_xfs_scratch_zoned
+
+# create three zone-sized files and invalidate 95% of the data
+for i in $(seq 1 3); do
+	filename=$SCRATCH_MNT/data_$i
+	dd if=/dev/zero of=$filename bs=1M oflag=direct\
+		count=$(($capacity / (1024 * 1024))) >> $seqres.full 2>&1
+	truncate -s $(($capacity / 20)) $filename
+done
+
+# remount read-only and set the gc limit to free up unused space
+_scratch_remount ro
+rt_available_pre="$(get_user_available_rt_blocks)"
+_set_fs_sysfs_attr $SCRATCH_DEV "zoned/zonegc_low_space" 100
+
+# reclaiming a zone with 5% used blocks should take way less than 1 second
+sleep 1
+
+# gc should not run for read only file systems
+rt_available_post="$(get_user_available_rt_blocks)"
+[ "$rt_available_post" -gt "$rt_available_pre" ] && _fail "gc should not run while read only"
+
+_set_fs_sysfs_attr $SCRATCH_DEV "zoned/zonegc_low_space" 0
+
+# remount rw and check that gc starts, frees up blocks and stops after
+# the threshold is set to reclaim the unused blocks
+_scratch_remount rw
+
+rt_available_pre="$(get_user_available_rt_blocks)"
+_set_fs_sysfs_attr $SCRATCH_DEV "zoned/zonegc_low_space" 100
+
+i=0
+while [ $(gc_required) -eq "1" ]; do
+	sleep 1
+	let i=$i+1
+	[ $i -gt 3 ] && _fail "gc did not complete within a reasonable time"
+done
+
+rt_available_post="$(get_user_available_rt_blocks)"
+[ "$rt_available_pre" -ge "$rt_available_post" ] && _fail "gc did not free up space"
+
+echo "Silence is golden"
+status=0
+
+exit
diff --git a/tests/xfs/999.out b/tests/xfs/999.out
new file mode 100644
index 000000000000..3b276ca804fc
--- /dev/null
+++ b/tests/xfs/999.out
@@ -0,0 +1,2 @@
+QA output created by 999
+Silence is golden
-- 
2.34.1

