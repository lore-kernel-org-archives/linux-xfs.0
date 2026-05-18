Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BF2835F180
	for <linux-xfs@vger.kernel.org>; Mon, 18 May 2026 06:52:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.154.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779087175; cv=none; b=IhgYzRpo1aj/RkzRnGTEr/wO7yxVo6pkw3+2FP0wV44zUblS6KiVQNM0qu0fJOpKf8/cOEDLkgn/lcVFFWL6uTncw8+0HPI9uL8TYMGAVqqPVbYxL3gRLlVgJca7jGzt7p3olcUwAuMwULmxzZ/5BR8P2VUxQ0LdFTvVwTVsHko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779087175; c=relaxed/simple;
	bh=S8k56k+xD3tsNxcTFIcvs1YnAchNHw/+6X8WYNTDfNg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Q0pLGnbXQw4RyQzhUYA3U+choHFsqa6qQ0plj02zAAS8ytSOqmgyDrMJNSQkWrjX6If/iDek6jHavGX+Qw1dUmA7djAhbtfhiK3hZmDPm8fKAAs9SbMFeeyeg56Im+F7wEEz1VeqUAaAFQBem836FKR4pFxQxvPNJ9bzP/24cFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=d7MjHsP+; arc=none smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="d7MjHsP+"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1779087173; x=1810623173;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=S8k56k+xD3tsNxcTFIcvs1YnAchNHw/+6X8WYNTDfNg=;
  b=d7MjHsP+vnajhGH40z01QUlHKEgytB3ZWiwBOf2eUkLnTZieaXck5/iF
   kuQefNIY9wWWCGro0iLmsALb9yPtotKUFVZ87nhc8dI2NTBGpU6G3keZj
   4c2uNKF9T0SRZetr/BUu1HrwlZSXM0seAKbeUR4Fj10UyC+3CQok/r7RK
   DrfUvpl4PXSRXANDYwjgkhf8sVjpJuecOg2T04UXfoikm/yMnuT3M9sEf
   WNViCd2EbY7iLuNqIX8O1OtW0M1Z1v6Wc7zpWK3e+rggnfc1rOf4zaOZJ
   e4T7zowk5YbZO76DicqdpIxJ/GAvkDzibj+dtuJNZQJm+1JcIZBbWi+AJ
   w==;
X-CSE-ConnectionGUID: MtcJCTGaQqeXvjmzh+EhZA==
X-CSE-MsgGUID: Kx4KotN3TX2QIayw58rWtw==
X-IronPort-AV: E=Sophos;i="6.23,241,1770566400"; 
   d="scan'208";a="145655688"
Received: from unknown (HELO uls-op-esad1-o.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 18 May 2026 14:52:47 +0800
X-CSE-ConnectionGUID: YjKpQOkxRCiJQxdbazQ8QA==
X-CSE-MsgGUID: FBZC+UHKRz6hCD1KXe95hg==
IronPort-SDR: 6a0ab72f_UzL5aOffGYekAwHpFlCTDbWFeKFdjsn8cGyxagEa5qAGD+e
 rQWY9vy+KP3tYb/lP4avqmWroxJrLCU+f+W7pqg==
Received: from uls-op-esai1-o.wdc.com ([10.248.3.45])
  by uls-op-esad1-o.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 17 May 2026 23:52:30 -0700
X-CSE-ConnectionGUID: OiNGd7c5TYe7NrB/k74BBQ==
X-CSE-MsgGUID: ExkpdtowRMqa73HqMmEQpA==
WDCIronportException: Internal
Received: from wdap-gqqtcuxayi.ad.shared (HELO gcv.wdc.com) ([10.224.16.26])
  by uls-op-esai1-o.wdc.com with ESMTP; 17 May 2026 23:52:29 -0700
From: Hans Holmberg <hans.holmberg@wdc.com>
To: Carlos Maiolino <cem@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	linux-xfs@vger.kernel.org,
	Hans Holmberg <hans.holmberg@wdc.com>
Subject: [PATCH v2] xfs: handle racing deletions in xfs_zone_gc_iter_irec
Date: Mon, 18 May 2026 08:52:24 +0200
Message-ID: <20260518065224.9066-1-hans.holmberg@wdc.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Under heavy garbage collection pressure from RocksDB workloads,
filesystem shutdowns can occur in xfs_zone_gc_iter_irec when
xfs_iget() returns -EINVAL for deleted files.

Fix this by handling -EINVAL just like we handle -ENOENT, allowing
zone GC to safely ignore stale mappings.

Fixes: 080d01c41d44 ("xfs: implement zoned garbage collection")
Signed-off-by: Hans Holmberg <hans.holmberg@wdc.com>
---

v2:
- handle -EINVAL in the the caller in stead of switching error code
  in xfs_imap_lookup

v1:
https://lore.kernel.org/linux-xfs/20260513063745.8067-1-hans.holmberg@wdc.com/


 fs/xfs/xfs_zone_gc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_zone_gc.c b/fs/xfs/xfs_zone_gc.c
index fedcc47048af..96f14d811db2 100644
--- a/fs/xfs/xfs_zone_gc.c
+++ b/fs/xfs/xfs_zone_gc.c
@@ -400,7 +400,7 @@ xfs_zone_gc_iter_irec(
 		/*
 		 * If the inode was already deleted, skip over it.
 		 */
-		if (error == -ENOENT) {
+		if (error == -ENOENT || error == -EINVAL) {
 			iter->rec_idx++;
 			goto retry;
 		}
-- 
2.34.1

