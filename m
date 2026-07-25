Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A4CE2874F5;
	Sat, 25 Jul 2026 07:04:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.141.245
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784963093; cv=none; b=PPc+hxZNW8Mh2F2w/58iLJMsNF/mNv/Wz7s31ovL+nw5VGZv+EJW2f4VPB2/tXVLiTye4iAc9nqeIQ0HDKJaFQvfzbMwidwaETtJ2tGAvJxbleAh9qm69+plYR/v05bzB4sjeieneQLzBN7/mr3mKPrQTaDtEC54VLSq2QXVj30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784963093; c=relaxed/simple;
	bh=1isfoNU/w9mlDP/QQbX0kUAYq4effW2SAXBfOmRT3pg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ety+e5j0n+SxQRoA50BMaUfPMtvWDNBf6K/jQ67I6NCcQ13SQQrT49AOJpSlhUX050X+Sr6D2hmXhUjtVdZL6MBY14mFovHKI8mafaUGmt4e/IvF+lcsTYhExWdG+ZA9ck+hbvhTKhKm8nlpjr3B38KVW5sj9bFERDLY5gba2EM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=fVk2uyVc; arc=none smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="fVk2uyVc"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1784963092; x=1816499092;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1isfoNU/w9mlDP/QQbX0kUAYq4effW2SAXBfOmRT3pg=;
  b=fVk2uyVcHG9CKlaTHn71JxrMUIGxVIvFhT1Idk51VIdeuE1HvEi63F5p
   kqvHQQo3fkMLaeXktjrNxmPe30v3DxpOOypmKLQU6anh5Q87Su7yzFWcx
   YofgtVfgN0PJHOmVQHMLRMWYyVc+VYni8KCpBN/GWqpB6phZh1acrgAW/
   mU+89szyWPZIuUjFBUs0L7rqSMldE6ZVKYcs6Yl2tmvAgD/jt1amGPUaf
   4V/3LW5tNwDQ0hbOn24b+sdbNd9BQPBI7xldBgeXdqTlFUwOnTlasSsFP
   RrVMJ8rQp9etizW+SxZWEnmK1QOotBFDskslWjkjSWobATlxwoIYjrO3b
   Q==;
X-CSE-ConnectionGUID: np87v88lSdypCWzEt7Y16A==
X-CSE-MsgGUID: 5TF4AI76SiOgEkF5c4fQuw==
X-IronPort-AV: E=Sophos;i="6.25,184,1779120000"; 
   d="scan'208";a="151480314"
Received: from unknown (HELO uls-op-esad3-o.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 25 Jul 2026 15:04:44 +0800
X-CSE-ConnectionGUID: 8URuvM3yQ3CiJAQXFsqh1A==
X-CSE-MsgGUID: tR8qQ7QLTXqF9iweMN8BNw==
IronPort-SDR: 6a645ff1_wvGrtFT/nfcKi3SgL7FuRXZzBZUZTaYEZkWqW8y3VXdDTLL
 iZR4qAu8tjkzZgXvF6YLGdWTOm0/XbOOU4DPayA==
Received: from uls-op-esai1-o.wdc.com ([10.248.3.45])
  by uls-op-esad3-o.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 25 Jul 2026 00:04:17 -0700
X-CSE-ConnectionGUID: Wrm+g+d1RRCv7qtzzXybIw==
X-CSE-MsgGUID: KjJuSPiaR3CUv5HfyCdc+g==
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.67.30])
  by uls-op-esai1-o.wdc.com with ESMTP; 25 Jul 2026 00:04:16 -0700
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: fstests@vger.kernel.org,
	Zorro Lang <zlang@kernel.org>
Cc: linux-xfs@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 2/2] generic/563: limit loop device size
Date: Sat, 25 Jul 2026 16:04:12 +0900
Message-ID: <20260725070412.1636557-3-shinichiro.kawasaki@wdc.com>
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

The test case generic/563 sets up a loop device on top of SCRATCH_DEV.
Currently, the loop device has the same size as SCRATCH_DEV. When
SCRATCH_DEV has huge size, mkfs for the loop device can take very long
time. Especially, when SCRATCH_DEV is a NVMe device that takes long time
for discard operation, mkfs for huge loop device can take hours.

To avoid the long mkfs time, limit the size of the loop device. Choose a
size four times the test's I/O size, then round it up to the
filesystem's minimum supported size by calling _small_fs_size_mb().

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 tests/generic/563 | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tests/generic/563 b/tests/generic/563
index f95eb073..670238ae 100755
--- a/tests/generic/563
+++ b/tests/generic/563
@@ -91,7 +91,9 @@ reset()
 
 # cgroup I/O accounting doesn't work on partitions. Use a loop device to rule
 # that out.
-loop_dev=$(_create_loop_device_like_bdev $SCRATCH_DEV $SCRATCH_DEV)
+loopsize_mb=$(_small_fs_size_mb $(( iosize * 4 / 1024 / 1024 )))
+loop_dev=$(_create_loop_device_like_bdev $SCRATCH_DEV $SCRATCH_DEV \
+					 $((loopsize_mb * 1024 * 1024)))
 smajor=$((0x`stat -L -c %t $loop_dev`))
 sminor=$((0x`stat -L -c %T $loop_dev`))
 
-- 
2.54.0

