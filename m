Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C291743F0A9;
	Thu, 16 Jul 2026 01:38:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.143.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784165892; cv=none; b=FkjeHwAAarKGptFYD2vdqTh78lqPaZUcFP8NDXz8YTpvLPVf7VjVAyw+7ysWbpFcij5phcKpjKmvqlBkOSHYCx60DbSrADAOez25wCER/fRPsI6W7rExMVRNYL9V4lLQ+HYZw3w7Z1wuvWAz/EwjWAqFBNA901etmRxGgkvNw1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784165892; c=relaxed/simple;
	bh=bfe5YijdD+G8B7V+RZp8vVrAtE3Vwwb7v/BeuK5C6Xg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Yol7qYRtiRTjx2E+vyzYqjgut3vg8/6Zry1Zz7Ems58aByTmi3KF6Iq5z9wNqRlzxp9m/fw7+wNvU/UeiwkqdBA6C/7cJxcrARc8aMdHsX9H8k/gX4v3F8eSVMI9vgXttbH7rkpYjsAI4Rlo0zjkABHZIvOF/hPv7KlOU5rJPYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=AWKeBgjV; arc=none smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="AWKeBgjV"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1784165890; x=1815701890;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=bfe5YijdD+G8B7V+RZp8vVrAtE3Vwwb7v/BeuK5C6Xg=;
  b=AWKeBgjVd8BJsPF2QSpnrjJhoK4Ch1R2HdkFMKBwLVs4OdC3btge1Dln
   2t71tNMxb1mVXMjXHLOpU4yD7jOsRLhFZQvR4RWVcCRjaTX9hXCjGJwof
   EAPyrzuU8XtIxKA6XcWiLZ941+xHUcwyyB2YKZid8+yuQ7DUqLpjkhKng
   ArF9pldfKzqaDT9OxVdwjr0XorXjDFgw+RwwwBZYQLItdl/GNpwmoH5Xx
   HGjcIJD8E+KCYKEZ4Ig/jjEZkqLjSU1j2FZuMYoOIxksPjtiwh/qQk/jC
   fKmPzzNZxF7oqyA1MXCmtQRsdXZCGeT+gbWJNW8/oSulmTEd6r9W8hWei
   g==;
X-CSE-ConnectionGUID: Js/jkwlnRzWiKKZHnCnHXA==
X-CSE-MsgGUID: lRx60GI0S2m6z1a9aacHvw==
X-IronPort-AV: E=Sophos;i="6.25,166,1779120000"; 
   d="scan'208";a="152027378"
Received: from unknown (HELO uls-op-esad3-o.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 16 Jul 2026 09:38:04 +0800
X-CSE-ConnectionGUID: jtEX3HzpSaSpP+QxMSlZ/A==
X-CSE-MsgGUID: N9ZspUTsQVSYidyONzXgaQ==
IronPort-SDR: 6a5835ed_zX2fxtR3fUFL9taK3hm3UVfI15z3opNJPohntoSjReK2UWh
 NvUz2N/Myo4J1ropFOEpMVUOizDZzoh52IF1ruQ==
Received: from uls-op-esai1-o.wdc.com ([10.248.3.45])
  by uls-op-esad3-o.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 15 Jul 2026 18:37:49 -0700
X-CSE-ConnectionGUID: pEmxLEVWQcGSNjs5EXKWFQ==
X-CSE-MsgGUID: aDPp3ebCSAGz9bADDw+kEg==
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.67.30])
  by uls-op-esai1-o.wdc.com with ESMTP; 15 Jul 2026 18:37:48 -0700
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: fstests@vger.kernel.org,
	Zorro Lang <zlang@kernel.org>
Cc: linux-xfs@vger.kernel.org,
	Yao Sang <sangyao@kylinos.cn>,
	Christoph Hellwig <hch@lst.de>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH] xfs/333: require external scratch device
Date: Thu, 16 Jul 2026 10:37:47 +0900
Message-ID: <20260716013747.1288925-1-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The test case xfs/333 uses the external scratch device SCRATCH_RTDEV.
When SCRATCH_RTDEV is not specified, the test case fails at
"_require_block_device $SCRATCH_RTDEV". To confirm the requirement, the
test case calls the helper function _require_realtime(). However, it
does not check SCRATCH_RTDEV when the zone type of SCRATCH_DEV is
'none'.

To avoid the failure, ensure the SCRATCH_RTDEV check by calling
_require_external_realtime_device() instead of _require_realtime(). With
this, the test case is skipped when SCRATCH_RTDEV is not specified
regardless of the zone type of SCRATCH_DEV.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 tests/xfs/333 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/xfs/333 b/tests/xfs/333
index f2d4077d..7235dc24 100755
--- a/tests/xfs/333
+++ b/tests/xfs/333
@@ -16,7 +16,7 @@ _begin_fstest auto quick rw zone eio
 
 _require_debugfs
 _require_scratch_nocheck
-_require_realtime
+_require_external_realtime_device
 _require_block_device $SCRATCH_RTDEV
 _require_zoned_device $SCRATCH_RTDEV
 _require_command "$BLKZONE_PROG" blkzone
-- 
2.54.0

