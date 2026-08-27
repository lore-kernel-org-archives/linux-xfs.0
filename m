Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C11723DC4C9
	for <linux-xfs@vger.kernel.org>; Thu, 27 Aug 2026 11:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.154.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787830188; cv=none; b=hZUGH1ANruaitRcTMQqyPspYoVyX6E4H1sgXBFS1wAY4PqZL1VQ+FyRtPWLfcohl8qTa3Xv05ZlRcG/afykyA6Nj3Nabs1/tr4vq9fr9qA1SchPzSV/uRyA7xKuTkZvHjyqYua9WkPOTnFt3ItwBDvW6SGv8ZVFMWZQNW9lVr+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787830188; c=relaxed/simple;
	bh=+XPnwlIbu+tsH3ohB2f40JGhiOIvFvL82ek5c2eOtmc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=svfEcARj2t695XwYo34SEqr3NS4ZGFFv2HJaNefa5hhpjGqgdq4KEL02Nm/j0EUoIEywpCKKV+m1XYWE/2WPSMNNvdxj+cmWl2J8j3vDE7HyJSchBJ+ZdXGOrdiFB/L8AVRmaHa4FWp+XkSZXHUAcvC/iYc3O8ocWQdevqatZ4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=VT4xUfMa; arc=none smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="VT4xUfMa"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1787830186; x=1819366186;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=+XPnwlIbu+tsH3ohB2f40JGhiOIvFvL82ek5c2eOtmc=;
  b=VT4xUfMaRUJzW9v0L76/mAok/ceHtHbxUqsLVH2Hk+h/csmaOOwtDSxx
   UtbDfNSEL+GdIG0ToX6U3i+63gbS+rDasEfOGTf4lEo5ca8mlZoHXsq30
   0yuQvy2Tnx/XvKtpCKskX/dZzQYl5do5ISh5ru2L16Q1nXmeFwi2yVbsN
   j3ivBSvLXBcYeKE9QLlMogweIcdVZXjXiot6QQVvVxA4SS/Dl9P2s0PC/
   TZpae1etLwpMpBRZaHq5SA95ydV8ErQTGxlSqLc+zxrquZeqJSEXVR8mu
   +Uxtqb0FExSJE8NEIuizzxJ419AaWW5uTac4pD5WfSK6zG7j4p/ZVPjL0
   Q==;
X-CSE-ConnectionGUID: 5VUV7e8AR56TrwzxqW2UWg==
X-CSE-MsgGUID: yTiUagbJRay/g4HmudZxiQ==
X-IronPort-AV: E=Sophos;i="6.25,246,1779120000"; 
   d="scan'208";a="152807474"
Received: from unknown (HELO uls-op-esad2-o.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 27 Aug 2026 19:29:40 +0800
X-CSE-ConnectionGUID: TakA28ljS3aZMvV6NOgzig==
X-CSE-MsgGUID: ZYe7J/9pTuuzk2XItPKBvw==
IronPort-SDR: 6a901f86_bre8fEYm6+dyk0QGYcrrTb/T3ljXXajpWO+o0M1qgZpKBZF
 /aIY3NyAl8BgBdVmzVYB4h0b0Bay8F+Fr9wIwFw==
Received: from uls-op-esai2-o.wdc.com ([10.248.3.38])
  by uls-op-esad2-o.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Aug 2026 04:29:10 -0700
X-CSE-ConnectionGUID: /qkPHxDNQ5KNCmqedSk/BA==
X-CSE-MsgGUID: bI2/3xvJTKGbm7TXX0lHZQ==
WDCIronportException: Internal
Received: from wdap-i5yqra7zl2.ad.shared (HELO gcv.wdc.com) ([10.224.5.77])
  by uls-op-esai2-o.wdc.com with ESMTP; 27 Aug 2026 04:29:09 -0700
From: Hans Holmberg <hans.holmberg@wdc.com>
To: linux-xfs@vger.kernel.org
Cc: aalbersh@kernel.org,
	cem@kernel.org,
	hch@lst.de,
	djwong@kernel.org,
	Hans Holmberg <hans.holmberg@wdc.com>
Subject: [PATCH] libxfs: report device open errors during topology probing
Date: Thu, 27 Aug 2026 13:28:55 +0200
Message-ID: <20260827112855.70037-1-hans.holmberg@wdc.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

mkfs probes the device topology before libxfs_init opens the target.
If blkid cannot open the device, blkid_new_probe_from_filename returns
NULL and leaves the topology sector sizes initialized to zero.  This
causes mkfs to report the misleading error "illegal sector size 0".

Report the underlying open error immediately so that permission
failures are diagnosed correctly. For example:

cannot probe device topology for device /dev/nvme1n1: Permission denied

Signed-off-by: Hans Holmberg <hans.holmberg@wdc.com>
---
 libxfs/topology.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/libxfs/topology.c b/libxfs/topology.c
index dc2aaa17..5571c9d8 100644
--- a/libxfs/topology.c
+++ b/libxfs/topology.c
@@ -230,8 +230,12 @@ blkid_get_topology(
 	blkid_probe pr;
 
 	pr = blkid_new_probe_from_filename(device);
-	if (!pr)
-		return;
+	if (!pr) {
+		fprintf(stderr,
+			_("cannot probe device topology for device %s: %s\n"),
+			device, strerror(errno));
+		exit(EXIT_FAILURE);
+	}
 
 	tp = blkid_probe_get_topology(pr);
 	if (!tp)
-- 
2.53.0

