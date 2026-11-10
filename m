Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=216.71.154.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794306968;
	b=j1jS+QY6zrrTGibQYHlNia+H/p1fHE6iofsisXfPJznv3eI8C0ms2oUuaz/A25Cs/hUX
	 ebeCW8DJ6MoKZE/XKLNfutttu7TuSnFe7xYP5A1sZmk39hDU2U9zHHHMfuDmHfs8Frjjp
	 KNfMpo54erJSz27cF5bj+3rx+r8dVBGOOvUmA05O7Htcrnl5+bbf9vpEfkSscqFNwwMxo
	 fcHNECSYdA3YMBCsQDqPkNTqoG8sva6hXjeELCz3i1yFRWrsvQV4nN4fAY83B6jPVIcO3
	 IFQiFs2bnDNZXuW3ihAo71oOjMJtarJkN0eV073H99HELcxD/DOzcWZcRKZrAslDUFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794306968;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:Received:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 IronPort-SDR:Received:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 WDCIronportException:Received:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=2hxOxjlGMrPM0QFhnkfocvI73AEOvS4//4rlUGWI7JA=;
	b=FB9FIiDCSiI4XN+xgDFqFeVbK1oh8Y0VV7ZN/QMP4qwn9QR2UkXoYAnDDvopwqdO3mCC
	 XF+vsi4Q6tDJkgBqxvReLDV9+QtiZ9SKa3+0+Zsg052HhA10iIlO7N8wVg9xVl+jcHKjI
	 tuk4OtY4QHw0UracoKM5QqGYCYfKnI+0TERScXPOq2Pl6M/sZxszibbJelHg/BWx3A6d0
	 GffytoFLvr9tqMAgDmHqCdqTIEsqGyQ0kHzGwn+F46x2JAbHpJkd0XxRtJENnlyM6M8kU
	 bDX8W+FA7m/f1NAkR7azb2dvB1FGYdpjmQ/8BWw9bkQtIRLLjJwTMJdvHKSgx3fEY4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=qsa3jpHa;
	arc=none smtp.remote-ip=216.71.154.45
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6201E606A331;
	Tue, 10 Nov 2026 10:36:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6201E606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=qsa3jpHa
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1794306967; x=1825842967;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Y+AJYPlpY+zynm5z8WbHr6UHP3Yjw0vvsiDt8K5jUG8=;
  b=qsa3jpHaZtTYKBvoPxTkIXzXBITDILeNsZ1uR/ShWXrK9q3aZmt55nwP
   IgJ1ZrOAzHTK4+w9ZSKwki2Y8EdOwLs0cA6qZbmscHpOZtRTp0IvvUOd6
   UYntte8l3wANoyIQepCmH7pUHvXv2k+LyJFYzkbvfG6iDj8OIeBORgKdV
   STsU2VQhnKybU0Dh7xYCzNlrUi/5CsJPRf48CC1in8M0TM1KotKyr3ZF6
   MyRpuhChuXTD08osIqqeB3H3YTwuvcDkP95peucqe7TY0KwKuHvUci/Fx
   /9yL3Bhz1cfCdQO+NJ7ngO9Y6qBDyeJ9AJqMUaBIZMhy/fXEyZiwLBiab
   A==;
X-CSE-ConnectionGUID: Mr7unLDlTK6R/BcFCSzELw==
X-CSE-MsgGUID: QwT3GstzQQ+QVpGccnapZw==
X-IronPort-AV: E=Sophos;i="6.27,205,1786982400"; 
   d="scan'208";a="158891401"
Received: from h199-255-45-14.hgst.com (HELO uls-op-esad1-o.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 10 Nov 2026 18:36:07 +0800
X-CSE-ConnectionGUID: rvPk2RUeSy2cyYver+O4CQ==
X-CSE-MsgGUID: XFQfnBpLRzachDF9DR7f4g==
IronPort-SDR: 6af2f397_kLFzSwcgxmR0Wr/cwzNdhupd9M5CwI0JZdJ9NDCCoHJ2WVV
 +O8G5yXYVLertKgaF9akr4U92yr60hjg74BREMg==
Received: from uls-op-esai1-o.wdc.com ([10.248.3.45])
  by uls-op-esad1-o.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 10 Nov 2026 02:36:07 -0800
X-CSE-ConnectionGUID: aPY6VsCCTRyw0gHbEaXx6g==
X-CSE-MsgGUID: 39k4AA0BTxaBXd3CXNRJCQ==
WDCIronportException: Internal
Received: from unknown (HELO gcv.wireless.wdc) ([10.224.5.251])
  by uls-op-esai1-o.wdc.com with ESMTP; 10 Nov 2026 02:36:04 -0800
From: Hans Holmberg <hans.holmberg@wdc.com>
To: brauner@kernel.org,
	hch@lst.de,
	djwong@kernel.org,
	dgc@kernel.org,
	cem@kernel.org,
	jack@suse.cz,
	axboe@kernel.dk,
	kbusch@kernel.org
Cc: dlemoal@kernel.org,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	gost.dev@samsung.com,
	Anuj Gupta <anuj20.g@samsung.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Hans Holmberg <hans.holmberg@wdc.com>
Subject: [RFC 3/4] xfs: report zoned write streams on realtime inheriting directories
Date: Tue, 10 Nov 2026 11:35:39 +0100
Message-ID: <20261110103540.46876-4-hans.holmberg@wdc.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261110103540.46876-1-hans.holmberg@wdc.com>
References: <20261103110640.1000095-1-anuj20.g@samsung.com>
 <20261110103540.46876-1-hans.holmberg@wdc.com>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On zoned file systems the data device usually only holds metadata, and
mkfs sets the realtime inherit flag on the root directory so that all
regular files are realtime files.  Report and allocate write streams
from the zoned pool for directories with the realtime inherit flag set,
so that streams queried or allocated through a directory can be used
for the files created in it.

Signed-off-by: Hans Holmberg <hans.holmberg@wdc.com>
---
 fs/xfs/xfs_inode.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index ab71f3bc5c03..045323c40c2f 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -49,12 +49,20 @@
 
 struct kmem_cache *xfs_inode_cache;
 
-/* Write stream pool that backs data placement for @ip. */
+/*
+ * Write stream pool that backs data placement for @ip.
+ *
+ * On zoned file systems, directories that pass the realtime flag on to new
+ * files report the pool for the zoned realtime files created in them.
+ */
 struct write_stream_pool *
 xfs_inode_write_stream_pool(
 	struct xfs_inode	*ip)
 {
-	if (XFS_IS_REALTIME_INODE(ip) && xfs_has_zoned(ip->i_mount))
+	if (xfs_has_zoned(ip->i_mount) &&
+	    (XFS_IS_REALTIME_INODE(ip) ||
+	     (S_ISDIR(VFS_I(ip)->i_mode) &&
+	      (ip->i_diflags & XFS_DIFLAG_RTINHERIT))))
 		return xfs_zoned_write_stream_pool(ip->i_mount);
 	return &xfs_inode_buftarg(ip)->bt_stream_pool;
 }
-- 
2.43.0

