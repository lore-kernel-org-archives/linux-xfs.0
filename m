Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFCED2F7EEE;
	Sat, 25 Jul 2026 07:04:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.141.245
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784963093; cv=none; b=O0cjr69QNtgg5ByOcYvSrgxQSGayKknAdfRjis/+CE+cbE1U4XnNB79HurT6Y1JGPGht5RDgGGD4oyGrKTpicPAmrBuME5Lae0J5aixzAUQeVDDEbcfrRisr/emQvOuHwYJlP3rfMDw2XbaenYGsIG5yE/godcHe5Naj3QG7G2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784963093; c=relaxed/simple;
	bh=9AapP5LIpevdbL1P38TwAikOP2GuR8oziqsDSmA1/ak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jXuwzzU+Mn07y3mKi0TwyqYQG1EhHPRSzlxSmHt5jF7JAzZiHNdpCY1cVnDzqU87YEZ3hbE54LKgYWjnHP45LAZK2HP3hH1j19DWblZWeDLpR2K2UEVwz+W3O5JA33v2CQR5vY1s0sCGk3Zo6NTILoT6Tk9TvjeUkvGIgg90QG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=MbUuHYM4; arc=none smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="MbUuHYM4"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1784963091; x=1816499091;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9AapP5LIpevdbL1P38TwAikOP2GuR8oziqsDSmA1/ak=;
  b=MbUuHYM4frXO2794dhwMGaG2egV1LKzxO/8v1wl9xkCAwXokSR1y60/9
   gbeOd0lzNeZeW+zIR3tW7IBsg9RLMP+Y/v+0v7dYJQU+nqTb7RpziYuYH
   X6ySTiDElUdLYr2FZDGeIJIw+t3QFPgl1sV9YNHlfggG1fHCh4vPMJ8se
   pt4R4Qv+fZusaA4GHTyDZRFe0pNlZ6twYMylpvzMNvPd1XYTfAnR4dDqf
   S/OTN8BlBTV2TPRa7hzLvFKdtL3K7+mQpkaN7DUKnZBU/B4xQhaLze/WG
   MbbqcrL0Z1iFti/xebWTh4UJGx1Zr80OuFJZgciYgEpOFPUrUlahCE2Vq
   A==;
X-CSE-ConnectionGUID: u8G0zcT9SCi9gi/vpotBGg==
X-CSE-MsgGUID: KSLK8KtQSj2bcrNzk8HilQ==
X-IronPort-AV: E=Sophos;i="6.25,184,1779120000"; 
   d="scan'208";a="151480313"
Received: from unknown (HELO uls-op-esad3-o.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 25 Jul 2026 15:04:44 +0800
X-CSE-ConnectionGUID: H907gQ7yRLioPsC8EhYcvg==
X-CSE-MsgGUID: m/qkgc19R0mdnuVC2WwByg==
IronPort-SDR: 6a645fef_rMSlQpPc4twlIHWXgCByiO+felnhg2K+XDpzK8rfgleWv7R
 IBeVgXMwkCKoXEx9HM42Sg6PVkmeO0pEzaonnrQ==
Received: from uls-op-esai1-o.wdc.com ([10.248.3.45])
  by uls-op-esad3-o.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 25 Jul 2026 00:04:15 -0700
X-CSE-ConnectionGUID: xbdEqA6vRB+eJqQOskDEhQ==
X-CSE-MsgGUID: 5oZgY2kdT822DXBqInb3RQ==
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.67.30])
  by uls-op-esai1-o.wdc.com with ESMTP; 25 Jul 2026 00:04:15 -0700
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: fstests@vger.kernel.org,
	Zorro Lang <zlang@kernel.org>
Cc: linux-xfs@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 1/2] common/rc: add argument to _create_loop_device() to specify device size
Date: Sat, 25 Jul 2026 16:04:11 +0900
Message-ID: <20260725070412.1636557-2-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260725070412.1636557-1-shinichiro.kawasaki@wdc.com>
References: <20260725070412.1636557-1-shinichiro.kawasaki@wdc.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently, _create_loop_device() does not specify the --sizelimit option
to the losetup command. As a result, the loop device has the same size
as the backing file or device. To allow controlling the loop device
size, add a third optional argument to _create_loop_device(). Also,
modify _create_loop_device_like_bdev() to pass its third argument to
_create_loop_device().

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 common/rc | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/common/rc b/common/rc
index 336441c7..4be9e719 100644
--- a/common/rc
+++ b/common/rc
@@ -4610,11 +4610,13 @@ _create_loop_device()
 {
 	local file="$1"
 	local blksize="$2"
+	local sizelimit="$3"
 	local dev
 	local dio_args="--direct-io=on"
 	local args
 
 	test -n "$blksize" && args="--sector-size=$blksize"
+	test -n "$sizelimit" && args+=" --sizelimit=$sizelimit"
 
 	# Try to enable asynchronous directio mode on the loopback device so
 	# that writeback started by a filesystem mounted on the loop device
@@ -4650,7 +4652,8 @@ _create_loop_device_like_bdev()
 
 	blksize="$(blockdev --getss "$bdev")"
 
-	_create_loop_device "$file" "$blksize"
+	shift 2
+	_create_loop_device "$file" "$blksize" "$@"
 }
 
 _destroy_loop_device()
-- 
2.54.0

