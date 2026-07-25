Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F38C2874F5;
	Sat, 25 Jul 2026 07:04:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.141.245
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784963091; cv=none; b=s1cmzy0zm8nUxXcMd+o01C9mDpMm+shSEleMPhFcg3NpxMWGhK45SBVo37NrR5JhUTLpTMBEo3HufHz03X0YPni/0nJCnzNE+TVS/mR8gUoAKFgb/in/bRNoDn3Xt3LDQWjDwO+rJvKSzZ3eqngTE5nzIm+VOUEJR5/Uw051gtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784963091; c=relaxed/simple;
	bh=iTDpI7glTXZ7KblTdKgeME6yRcc+avtrNCRhMWeTSvs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=WL8BgKOdyE5wDFjaF+M8+/Y5gxW5376B8Z6vHx+YYjOKYaaZBLUPYkgq3EWJYIrh1RrXuLyZy4q2pNPCPcNQrLMdwL6Qb6j8ZDN04FLBQAIqg+l5+7PExz16vyZ73PTOed98iRmA2+023suOKWBZNlDkaE1GpfLfBuO6XvrFvgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=FrijWlb9; arc=none smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="FrijWlb9"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1784963090; x=1816499090;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=iTDpI7glTXZ7KblTdKgeME6yRcc+avtrNCRhMWeTSvs=;
  b=FrijWlb9j6fH4M5gGMzkRAoSDKpsmGTSsIjU8hQwA0lup+FnD0I5XE7S
   ceT5wheGsTHgQ16fF1hxcBEQYd1Wh9Yloz4UlU+qTG09QWdhK7rpiPAip
   PUmba5qyu9wNOd8fSDbwyj0ehsJ7+pj8emU6YFdMAdF+/kMe4EBfYI+Nc
   F+FA8l0USIunQ5pwarktMzAo8XqDXR0Ffvbfc5CT6tN1p3kXwG1uQ1T3j
   MGnxEBCS6tSaB1yYRH88xwfAVYRMWZdOHTvidcaA1YOT5xDFuXSWABUSr
   63wcPgf773YjzTOru1QYvUvdgQ1+Y2h773TrRdIOHzLdopBjg0P398ms+
   Q==;
X-CSE-ConnectionGUID: pSHTAsxgT5WVwzXXjcc+PQ==
X-CSE-MsgGUID: 6AWLeQEbQfKqF8UGgITQCg==
X-IronPort-AV: E=Sophos;i="6.25,184,1779120000"; 
   d="scan'208";a="151480312"
Received: from unknown (HELO uls-op-esad3-o.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 25 Jul 2026 15:04:44 +0800
X-CSE-ConnectionGUID: 0I2yP9bjTl2BX7ITMEPpVA==
X-CSE-MsgGUID: YCRuK5S9QlGX7HBt7QaJIg==
IronPort-SDR: 6a645fee_p3zh/Y/tYGohw4gIu45Rfyo+Hs9tMwoTZCfe4U4S/NgO56b
 ehkb8UkClE3AvB8ju6xyimFhz8vc8UkkY/bi8gw==
Received: from uls-op-esai1-o.wdc.com ([10.248.3.45])
  by uls-op-esad3-o.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 25 Jul 2026 00:04:14 -0700
X-CSE-ConnectionGUID: 921blOR5T8ujQm1bxyDXuA==
X-CSE-MsgGUID: PSnSE86PTsSY669IIzn2/w==
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.67.30])
  by uls-op-esai1-o.wdc.com with ESMTP; 25 Jul 2026 00:04:14 -0700
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: fstests@vger.kernel.org,
	Zorro Lang <zlang@kernel.org>
Cc: linux-xfs@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 0/2] generic/563: limit loop device size
Date: Sat, 25 Jul 2026 16:04:10 +0900
Message-ID: <20260725070412.1636557-1-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When SCRATCH_DEV is a large NVMe that takes long time for discard
operation, the test case generic/563 takes hours to complete for xfs.
To avoid this long test time, limit the size of the loop device created
on SCRATCH_DEV.

The first patch adds an optional argument to _create_loop_device().
The second patch enables the argument in generic/563.

Shin'ichiro Kawasaki (2):
  common/rc: add argument to _create_loop_device() to specify device
    size
  generic/563: limit loop device size

 common/rc         | 5 ++++-
 tests/generic/563 | 4 +++-
 2 files changed, 7 insertions(+), 2 deletions(-)

-- 
2.54.0

