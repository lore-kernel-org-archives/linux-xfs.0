Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59B865C613
	for <linux-xfs@vger.kernel.org>; Wed, 26 Aug 2026 12:33:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.153.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787747583; cv=none; b=H4LI8oindW9qNQd/LVnQ1G8SyVMGapegm8FzqjVc6MgPF5MqjYZCQ5wFaUtzW72EnLyj0bGcOsh4qapiL1eZ6VbXKNb6G+ptUId7WFcTszHwcqs/GbapfLhkR3GH8NzZRjpTqjRwWHoLh0O5i+qJs3VQa8FlA6+h+QknVFHrMFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787747583; c=relaxed/simple;
	bh=n5L6v6JiJcrtcDfCyiPMKh+UBXoLQXL4kjazR66BBHU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=t/3SwK/pBZGOOR8+8ClLtmzCRdjvQWcNeDAHJkvrTtwWIfeCu6kkNGLfRCLgATQvi/28Dq0HziBBXR1XqFdPCpiYSh46gWtGFucOjmDeiimX+SVJnS/E1gQgijwz9bBpjU4c19FKaktvIvvxu80xPfrpXSSUrQyB0mnj4VvB/18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=LFt1Ewf+; arc=none smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="LFt1Ewf+"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1787747582; x=1819283582;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=n5L6v6JiJcrtcDfCyiPMKh+UBXoLQXL4kjazR66BBHU=;
  b=LFt1Ewf+/YN7flPdsxz6IsPeRgBBZ08qRE/ozpzr5u/RrDjZe6TWvdIo
   Rv3AKTgf9D6iCgRfCem0/f+VLl7b4CUUWDDfTqLwe63gjmjrcaGNmdany
   UccnzhTXgjIMErcwiG+DeD66+JuJWv2fWxou7HNGm6L9PQq8MWichnz9l
   ZWIru7pRyTg3oClTvDHxQbgBOScYQW1MBW0Az1Z5JvMqy1bO1sPXcmLR5
   v4MlCxF/6nLGN2grQrmYyQea+lFuKzdUyMe3Kp9P17AyUD3TavqEUI/yC
   ICfdIIXM85j3vH82kJwwizd82iqAX+GsXqs6Y/Xi5pwNTuKwWiQZL9hi2
   Q==;
X-CSE-ConnectionGUID: SZ26l/lLR76yd8gVN64nOg==
X-CSE-MsgGUID: IvtWtC2ORNuiGGsXO3521A==
X-IronPort-AV: E=Sophos;i="6.25,244,1779120000"; 
   d="scan'208";a="154308505"
Received: from unknown (HELO uls-op-esad3-o.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 26 Aug 2026 20:32:55 +0800
X-CSE-ConnectionGUID: MIUyg8cJQIi8IWX+7P7YMg==
X-CSE-MsgGUID: q8/CdSLWQ12mDi/ky/s85g==
IronPort-SDR: 6a8edce5_ea/n3duaFAh0SnVFpSqVkXCouxj0N4kEljQXBK417mZdENE
 93YP2edr7NnoxRKe3XKYGf1tHbfqpPztN0+XvEw==
Received: from uls-op-esai1-o.wdc.com ([10.248.3.45])
  by uls-op-esad3-o.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 26 Aug 2026 05:32:37 -0700
X-CSE-ConnectionGUID: JQeDQJX0QBqCsaQl1AnoUA==
X-CSE-MsgGUID: xG9W4LHqTbesDOu42DDMOA==
WDCIronportException: Internal
Received: from bxsczh3.ad.shared (HELO gcv.wdc.com) ([10.224.5.75])
  by uls-op-esai1-o.wdc.com with ESMTP; 26 Aug 2026 05:32:34 -0700
From: Hans Holmberg <hans.holmberg@wdc.com>
To: cem@kernel.org,
	linux-xfs@vger.kernel.org
Cc: hch@lst.de,
	djwong@kernel.org,
	dlemoal@kernel.org,
	shinichiro.kawasaki@wdc.com,
	sashiko-bot@kernel.org,
	Hans Holmberg <hans.holmberg@wdc.com>
Subject: [PATCH] xfs: prevent race in zoned space reservations
Date: Wed, 26 Aug 2026 14:32:19 +0200
Message-ID: <20260826123219.73978-1-hans.holmberg@wdc.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

xfs_zoned_add_available() checks whether the reservation list is empty
before adding blocks to the available-space counter.  This check is not
serialized against a task adding itself to the reservation list however.

This allows the space provider to observe an empty list, after which a
reserver can enqueue itself and retry the counter before the new space is
added.  The provider then adds the space and returns without waking the
now-eligible reserver, leaving it asleep until GC or another event
provides a wakeup, potentially adding seconds to max write latency.

Take the reservation lock before updating the counter and checking the
list.  Use list_empty() because the list is now inspected under its lock.

Taking a per-mount lock when handing back space is far from ideal, but
benchmarking with null_blk showed no measurable performance regression.

Fixes: 0bb2193056b5 ("xfs: add support for zoned space reservations")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260609075655.1698743-1-hch@lst.de?part=2
Signed-off-by: Hans Holmberg <hans.holmberg@wdc.com>
---
 fs/xfs/xfs_zone_space_resv.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_zone_space_resv.c b/fs/xfs/xfs_zone_space_resv.c
index 5c6e6ef627e4..7aa3c74fb2e0 100644
--- a/fs/xfs/xfs_zone_space_resv.c
+++ b/fs/xfs/xfs_zone_space_resv.c
@@ -85,13 +85,13 @@ xfs_zoned_add_available(
 	struct xfs_zone_info		*zi = mp->m_zone_info;
 	struct xfs_zone_reservation	*reservation;
 
-	if (list_empty_careful(&zi->zi_reclaim_reservations)) {
-		xfs_add_freecounter(mp, XC_FREE_RTAVAILABLE, count_fsb);
+	spin_lock(&zi->zi_reservation_lock);
+	xfs_add_freecounter(mp, XC_FREE_RTAVAILABLE, count_fsb);
+	if (list_empty(&zi->zi_reclaim_reservations)) {
+		spin_unlock(&zi->zi_reservation_lock);
 		return;
 	}
 
-	spin_lock(&zi->zi_reservation_lock);
-	xfs_add_freecounter(mp, XC_FREE_RTAVAILABLE, count_fsb);
 	count_fsb = xfs_sum_freecounter(mp, XC_FREE_RTAVAILABLE);
 	list_for_each_entry(reservation, &zi->zi_reclaim_reservations, entry) {
 		if (reservation->count_fsb > count_fsb)
-- 
2.43.0

