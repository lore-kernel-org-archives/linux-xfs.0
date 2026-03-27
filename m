Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B5152367BA;
	Fri, 27 Mar 2026 12:37:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.154.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774615078; cv=none; b=QSPqNq+bM2ZU2dNy42IpjP/ArIQo2sXyJTE/nXVCNrb2ndMBmIchYUW2CmCSmLyA2p1zieRcSfiO7ctwZ2fsRmlxNm+pO1ybRznVZcAN13EAb1HRi0EmXIZHN4eEVSBXKWxy2/lyOzU6sqmB/Oz8bVB4pyuFo6wzIZyGkE2lPH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774615078; c=relaxed/simple;
	bh=Wc0If43kO7wdn9Dgv7G9kAV3VKypieEwudUPxp9Wo9c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ayqcnP68J7lGEQ25WuhfMvihcyNPfpWqfmdhgis713ubrM4sbjYnvwDTLkxwZay5pu82y2SMm2Bb7HJ6b0FtDGg2Zc5TDZ3geV8oBZp3up0Vf6ciun0sbNofwJ4oxHA4vaF3SAPWoQdTvAh5ynCtb90fV/6rGoOHXLgCm/X7I3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=ECRCARJY; arc=none smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="ECRCARJY"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1774615077; x=1806151077;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Wc0If43kO7wdn9Dgv7G9kAV3VKypieEwudUPxp9Wo9c=;
  b=ECRCARJYl39O8UKNLfZcyzhg/nVdmGbH2541w4s9623uvEst4QU7D5Yr
   ug+YQ4c89RO1c078GM4CNzSgCk6Ue6TUnx/Cw+OU0D1VJ9MbzQugclb96
   inQuCW9XEJxLIxTvyJue6y1B1xDarJkEUnLuY9byNTukbvVr9fTCJ5bAl
   +bL4brFMQXw94mwThN0ZWX+uLF4uJhDuPJvn6QY4qjyvTmlFNP71vL26b
   W/L1e8+KQzyQ8dfQyMwOC4HkAJnf0+zJ+V64cTBikXRbE50ozfC762+41
   +qu+mxx1WnyhYJtekXPGkdDOZteuvPY7ogz1+qp45QsAHDiA76cmMh0aN
   Q==;
X-CSE-ConnectionGUID: O0CKmfe8S72V0XJKtXvgoQ==
X-CSE-MsgGUID: FJmXYQvJSdSkPwPyscYoXA==
X-IronPort-AV: E=Sophos;i="6.23,144,1770566400"; 
   d="scan'208";a="139679419"
Received: from unknown (HELO uls-op-cesaep03.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 27 Mar 2026 20:36:52 +0800
IronPort-SDR: 69c679d6_L0rrgyKF1UPYOKPJhttIBFfvxsSZ+q7bf+NdoQjOhGHJwo2
 r6fhv4K74EJP2TaN2NAs1CrsQJcTnxvLoOK7IgQ==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep03.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Mar 2026 05:36:39 -0700
WDCIronportException: Internal
Received: from unknown (HELO gcv.wdc.com) ([10.224.20.49])
  by uls-op-cesaip02.wdc.com with ESMTP; 27 Mar 2026 05:36:36 -0700
From: Hans Holmberg <hans.holmberg@wdc.com>
To: zlang@kernel.org
Cc: fstests@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org,
	Hans Holmberg <hans.holmberg@wdc.com>
Subject: [PATCH v2 2/2] xfs: test that zone_gc_low_space writes start gc for rw fses
Date: Fri, 27 Mar 2026 13:34:29 +0100
Message-ID: <20260327123429.39330-3-hans.holmberg@wdc.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260327123429.39330-1-hans.holmberg@wdc.com>
References: <20260327123429.39330-1-hans.holmberg@wdc.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Test that writes to the sysfs attribute zone_gc_low_space triggers
garbage collection for rw (but not ro) file systems.

Signed-off-by: Hans Holmberg <hans.holmberg@wdc.com>
---
 common/xfs        | 17 +++++++++++
 tests/xfs/999     | 72 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/999.out |  2 ++
 3 files changed, 91 insertions(+)
 create mode 100755 tests/xfs/999
 create mode 100644 tests/xfs/999.out

diff --git a/common/xfs b/common/xfs
index c81f939e68d2..45d7f75d2064 100644
--- a/common/xfs
+++ b/common/xfs
@@ -748,6 +748,23 @@ _xfs_get_scratch_rtdev_bdev()
 	fi
 }
 
+# Get a stat from /proc/self/mountstats for a specific mount point
+_xfs_get_mountstat() {
+	awk -v mount="$1" -v stat="$2" \
+		'$0~"mounted on "mount" with fstype xfs"{f=1} f&&index($0,stat){print $NF;exit}' \
+		/proc/self/mountstats
+}
+
+# Get the user available blocks for a rt mount
+_xfs_get_user_available_rt_blocks() {
+	_xfs_get_mountstat "$1" "user available RT blocks:"
+}
+
+# Check if gc is required for a rt mount
+_xfs_get_rt_gc_required () {
+	_xfs_get_mountstat "$1" "RT GC required:"
+}
+
 # Snapshot the metadata on the scratch device
 _scratch_xfs_metadump()
 {
diff --git a/tests/xfs/999 b/tests/xfs/999
new file mode 100755
index 000000000000..2c5b54368b6d
--- /dev/null
+++ b/tests/xfs/999
@@ -0,0 +1,72 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2026 Western Digital Corporation
+#
+# FS QA Test No. 999
+#
+# Tests that writes to zonegc_low_space will trigger start of garbage
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
+zdev="$(_xfs_get_scratch_rtdev_bdev)"
+_require_zoned_device "$zdev"
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
+rt_available_pre="$(_xfs_get_user_available_rt_blocks "$SCRATCH_MNT")"
+_set_fs_sysfs_attr $SCRATCH_DEV "zoned/zonegc_low_space" 100
+
+# reclaiming a zone with 5% used blocks should take way less than 1 second
+sleep 1
+
+# gc should not run for read only file systems
+rt_available_post="$(_xfs_get_user_available_rt_blocks "$SCRATCH_MNT")"
+[ "$rt_available_post" -gt "$rt_available_pre" ] && \
+	_fail "gc should not run while read only"
+
+_set_fs_sysfs_attr $SCRATCH_DEV "zoned/zonegc_low_space" 0
+
+# remount rw and check that gc starts, frees up blocks and stops after
+# the threshold is set to reclaim the unused blocks
+_scratch_remount rw
+
+rt_available_pre="$(_xfs_get_user_available_rt_blocks "$SCRATCH_MNT")"
+_set_fs_sysfs_attr $SCRATCH_DEV "zoned/zonegc_low_space" 100
+
+i=0
+while [ $(_xfs_get_rt_gc_required "$SCRATCH_MNT") -eq "1" ]; do
+	sleep 1
+	let i=$i+1
+	[ $i -gt 3 ] && _fail "gc did not complete within a reasonable time"
+done
+
+rt_available_post="$(_xfs_get_user_available_rt_blocks "$SCRATCH_MNT")"
+[ "$rt_available_pre" -ge "$rt_available_post" ] && \
+	_fail "gc did not free up space"
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

