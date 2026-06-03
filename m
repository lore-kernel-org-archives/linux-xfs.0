Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC2CC378D9A;
	Wed,  3 Jun 2026 05:28:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.154.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780464508; cv=none; b=LWtCr/uPCKXB64Ey8HqDaLn8qCY1tOuF9igRC9h3ozcpVU3etejOzU48rnls96X/vglrP2uAnQhGEI2qycZvE8vW+MJMSuRLaQu9AiKyA2lSFAmGlGuO832pQKTKfa0W25NNqRAKknTF+F/dKmkq7PkjIztD69Fr0yvul9S/9IU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780464508; c=relaxed/simple;
	bh=MgjwGS+JDA9ZschaeIpkaDYye2zoo1yfAG+rk4JJ1mo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ON9D6FHVgOuvgTh9qbe6TQRCIrkmzNj3oc4HNX7tXuId56D9zp5zC+uVKZ0Af5pS7dlYQ2U/hHvZI2wYKAHpiuekqPBgkE/hXOWy4tduO4T9khsr39PNGMjKA64w+QEeOJ76n8oGO0skhl25k4oM4Fi7bm0JXq+84aGD6r+Vj2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=YYr7uYNG; arc=none smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="YYr7uYNG"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1780464506; x=1812000506;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=MgjwGS+JDA9ZschaeIpkaDYye2zoo1yfAG+rk4JJ1mo=;
  b=YYr7uYNG3rLrX/GUq8qi5B5vzgdXLL22wxDnLBRahM/z9uJRw+aA7/bq
   TGBXJE8wBric5/9hciyg/ZXFAu+aQQubPezbz9CkSJlYFSj66gD2JOgct
   vyJlsEArINRcgMQRXBBDL3oSFGkEO0MgPEP3KvfFmYLm6fCi98Pq3AiUO
   lfMyfaXvmm1izAy+QR0xJckd75eDGHKa2Ths9arepl/xP/0omLNUSTJ+i
   s/7+i57j7WvWqWR5xJHjuED7nWeP9JgFo2gaUSFhpz6mNmgiM+EzMWwcA
   tFKlVlVb51/nFMUAZnfGEAFw08a6yJTpWXQajK7feFJdH3RMAWpXHkI1R
   g==;
X-CSE-ConnectionGUID: Fx0iCadoTT6vs+9C/NWA/g==
X-CSE-MsgGUID: td+6HK3tQWWUsC15d4qh/g==
X-IronPort-AV: E=Sophos;i="6.24,184,1774281600"; 
   d="scan'208";a="144184440"
Received: from unknown (HELO uls-op-esad1-o.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 03 Jun 2026 13:27:17 +0800
X-CSE-ConnectionGUID: 4rf/gAUlTsmOUsgtiw3Ikg==
X-CSE-MsgGUID: 7g+mknUgQFSCzCpg2cAMrQ==
IronPort-SDR: 6a1fbb2b_PAXTINkKnt3ZnqZynGFFTMgmL64EnTicENpQIRrB+moARjc
 5Zi2I7Pv7VpwkRAULIJ+nYYv6Vu3eG4URYdwkDQ==
Received: from uls-op-esai1-o.wdc.com ([10.248.3.45])
  by uls-op-esad1-o.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 02 Jun 2026 22:27:05 -0700
X-CSE-ConnectionGUID: d3/fGswURDGPH/BtD+9c3Q==
X-CSE-MsgGUID: AH923LPJQ1KJOSt7qOLwkw==
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.67.30])
  by uls-op-esai1-o.wdc.com with ESMTP; 02 Jun 2026 22:27:07 -0700
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: fstests@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH] common/filestreams: check zoned device before mkfs with small dsize
Date: Wed,  3 Jun 2026 14:27:06 +0900
Message-ID: <20260603052706.349877-1-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The test case xfs/170 performs file stream tests and must be skipped for
zoned scratch devices since the filestream feature is not supported. The
test calls _require_xfs_scratch_non_zoned() to check if the scratch
device is zoned.

This check is done after _try_scratch_mkfs_xfs() with a small dsize
parameter. However, mkfs.xfs creates an inode for each zone, and when a
zoned device has many zones, the small dsize causes metadata area
shortage and mkfs fails. This unexpected failure causes the test to fail
even though it should be skipped for zoned devices.

Move the zoned device check to occur before the constrained mkfs. First
perform a usual mkfs without the small dsize parameter to ensure the
device can be properly checked for zoned mode, then verify it's non-
zoned before proceeding with the small dsize mkfs.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 common/filestreams | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/common/filestreams b/common/filestreams
index ace8f3b7..838b5921 100644
--- a/common/filestreams
+++ b/common/filestreams
@@ -86,6 +86,14 @@ _test_streams() {
 	# off the filestreams allocator.
 	unset SCRATCH_RTDEV
 
+	# Skip these tests on zoned file systems as filestreams don't work
+	# with the zoned allocator, and the operation below would force it into
+	# the tiny data section only used for metadata anyway.
+	_try_scratch_mkfs_xfs >/dev/null 2>&1 || _fail "mkfs failed"
+	_scratch_mount
+	_require_xfs_scratch_non_zoned
+	_scratch_unmount 2>/dev/null
+
 	local size=`expr $agsize \* 1024 \* 1024 \* $agcount`
 	_try_scratch_mkfs_xfs -dsize=$size,agcount=$agcount >/dev/null 2>&1 \
 		|| _fail "mkfs failed"
@@ -99,11 +107,6 @@ _test_streams() {
 		_scratch_mount
 	fi
 
-	# Skip these tests on zoned file systems as filestreams don't work
-	# with the zoned allocator, and the above would force it into the
-	# tiny data section only used for metadata anyway.
-	_require_xfs_scratch_non_zoned
-
 	cd $SCRATCH_MNT
 
 	# start $stream_count streams
-- 
2.54.0

