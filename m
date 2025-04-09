Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E524C25B667
	for <linux-xfs@vger.kernel.org>; Wed,  9 Apr 2025 07:58:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744185492; cv=none; b=IzUoijKm2m7fXoqhj/cBD/tA66UpCXv0nqJbZMArRcM59l6AufcSs8DFxf4m/KMJvSZS83hgPWAit+JvxiDKDfScX4mx38J1wiIb/byci4NRHNMjVEU0gSdU1hau3ZFrbwz0l+8lMUGeEwRATEditaUHKA1dkYpVOuDykj7ijfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744185492; c=relaxed/simple;
	bh=nMm/DOfa+vmCHXc0Uq1G2OX8aFi+T3Rp6EV2zc2waCU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vA33vix+sY7mC0KcNajznPxgnae4WIo9DMd5TRNUsbZVD/7n1xxpz2i7T1kH7VIZLh1nxjS/WPR25ge6oNltvGtTSJxib4XIDQ1StcnQadBHi8Oaz5h3iVihO7SZ60JR74OIEnP0Pj8fBz+r3HKrUWfUaQWIj2Y73WOarjB1MEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=DOGKoNXk; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="DOGKoNXk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=ig3hGGrdcUIVZOYD98TjbbKdzWZZTJIKqlHySjIyG5E=; b=DOGKoNXk3vSCThb84QeXZNdFBS
	pbGKsdu/ZRpV4lVsj8vz2XtO88CSVl2u7MEy7g+eF5/DjUtKZnLTMwG4/VWwhY8Jue25MdIKP3uEm
	hZgJc0E+ffH/6O86ISb7NhADXzstToAE57zoGnbh+X6nS9ZJzfVpQBkGKjbDMIXVw+1kfhEAw757R
	3xVTv13gy+YcsaYLbPI1exiEwfV7+4C1MAgL2vZwJ1PJc/fW/xj7oWKrjrTULJBu2YE2cW3j37nBt
	aPymVvISyp3wX1cmWKgLHoHCS7ItkWtyivXK5mZfCgWObFqmZ3K7stYK06UNhy0Z84Cc8GSItrvyz
	lzC/w6SQ==;
Received: from 2a02-8389-2341-5b80-08b8-afb4-7bb0-fe1c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:8b8:afb4:7bb0:fe1c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1u2QK1-00000006UeT-3IwB;
	Wed, 09 Apr 2025 07:58:10 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 32/45] xfs_mkfs: default to rtinherit=1 for zoned file systems
Date: Wed,  9 Apr 2025 09:55:35 +0200
Message-ID: <20250409075557.3535745-33-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250409075557.3535745-1-hch@lst.de>
References: <20250409075557.3535745-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Zone file systems are intended to use sequential write required zones
(or areas treated as such) for data, and the main data device only for
metadata.  rtinherit=1 is the way to achieve that, so enabled it by
default.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 mkfs/xfs_mkfs.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 6b5eb9eb140a..7d4114e8a2ea 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -2957,6 +2957,13 @@ _("rt extent size not supported on realtime devices with zoned mode\n"));
 			}
 			cli->rtextsize = 0;
 		}
+
+		/*
+		 * Force the rtinherit flag on the root inode for zoned file
+		 * systems as they use the data device only as a metadata
+		 * container.
+		 */
+		cli->fsx.fsx_xflags |= FS_XFLAG_RTINHERIT;
 	} else {
 		if (cli->rtstart) {
 			fprintf(stderr,
-- 
2.47.2

