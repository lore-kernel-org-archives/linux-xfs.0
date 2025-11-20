Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17FE3376BF8;
	Thu, 20 Nov 2025 16:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763654964; cv=none; b=Tn6hZKuZNoNhhFWCCHBBk5uXb/bIsorbGH89+e3jUA60AIqrCR7nWsW34VS+9hn4ZPlYxqBhyAzGNJmenRDh1i1K2YGnJoN02LYmDJotbRwPVJ/sSYvnysREI4HglES4veuAc1vQ94sHAGDM0gz2D/U5hxJFOS9wGrZTVrfHnZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763654964; c=relaxed/simple;
	bh=AwxgNqL6CsHoxDlLGVJBSknEoVNH25fGO0VDogj0xfk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fy9t+rNcz7mwhhlej6UtbNRDv2dfUtlZvJ2BnSzGSslHPx/stNwFvzfNKn19JWKjy9MKZM3awCvfBzoMh1QJrL2CPioARBQidl5bmAYa4oIY69Bcmp3QxW205hWMu6ejxWhHtrl3JmNnRCN6rP098hkQmqjtk5sY78X+pbAECt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kXaqFP2N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kXaqFP2N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07B40C4CEF1;
	Thu, 20 Nov 2025 16:09:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763654963;
	bh=AwxgNqL6CsHoxDlLGVJBSknEoVNH25fGO0VDogj0xfk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kXaqFP2NvNAkCMigDaOdEh/7Y8Izhsar67ZwWo2vlWxk1Lp5igTM7PoVW6f7bu9sB
	 L4nJqFB4DshPVPRa3PP6HQ7R2S9RirYaUZg+4AZz9/Tr4NtwPiZbUgF3bswfSdk/OJ
	 Jy+Nhh6G8PqLqOQttEkPZvNqhPoU+jdR/3vFy1UPBfTu+lC7RSNTML5GNcm1sugCbX
	 S/NsG18Z9tKCZNv4lGFnKziqjR3LF+RyhKlXGihmHoIWP3/vGVpb7qTl3Aoyai+yLz
	 c9TBhmhL4QMyKRZvqMHJOwKh+UKA4is70OLTmbRj28QuMzOaUcICdQTCHNAUsHYaAc
	 GT4yV2DNQvvPg==
From: cem@kernel.org
To: zlang@kernel.org
Cc: hch@lst.de,
	hans.holmberg@wdc.com,
	johannes.thumshirn@wdc.com,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 2/2] xfs: Add test for mkfs with smaller zone capacity
Date: Thu, 20 Nov 2025 17:08:30 +0100
Message-ID: <20251120160901.63810-3-cem@kernel.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251120160901.63810-1-cem@kernel.org>
References: <20251120160901.63810-1-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Carlos Maiolino <cem@kernel.org>

Add a regression test for initializing zoned block devices with
sequential zones with a capacity smaller than the conventional
zones capacity.

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 tests/xfs/333     | 37 +++++++++++++++++++++++++++++++++++++
 tests/xfs/333.out |  2 ++
 2 files changed, 39 insertions(+)
 create mode 100755 tests/xfs/333
 create mode 100644 tests/xfs/333.out

diff --git a/tests/xfs/333 b/tests/xfs/333
new file mode 100755
index 000000000000..f045b13c73ee
--- /dev/null
+++ b/tests/xfs/333
@@ -0,0 +1,37 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2025 Red Hat, Inc.  All Rights Reserved.
+#
+# FS QA Test 333
+#
+# Test that mkfs can properly initialize zoned devices
+# with a sequential zone capacity smaller than the conventional zone.
+#
+. ./common/preamble
+. ./common/zoned
+
+_begin_fstest auto zone mkfs quick
+_cleanup()
+{
+	_destroy_zloop $zloop
+}
+
+_require_scratch
+_require_zloop
+
+_scratch_mkfs > /dev/null 2>&1
+_scratch_mount >> $seqres.full
+
+zloopdir="$SCRATCH_MNT/zloop"
+zone_size=64
+conv_zones=2
+zone_capacity=63
+
+zloop=$(_create_zloop $zloopdir $zone_size $conv_zones $zone_capacity)
+
+_try_mkfs_dev $zloop >> $seqres.full 2>&1 || \
+	_fail "Cannot mkfs zoned filesystem"
+
+echo Silence is golden
+# success, all done
+_exit 0
diff --git a/tests/xfs/333.out b/tests/xfs/333.out
new file mode 100644
index 000000000000..60a158987a22
--- /dev/null
+++ b/tests/xfs/333.out
@@ -0,0 +1,2 @@
+QA output created by 333
+Silence is golden
-- 
2.51.1

