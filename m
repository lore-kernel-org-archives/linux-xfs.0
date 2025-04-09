Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4310E25B67D
	for <linux-xfs@vger.kernel.org>; Wed,  9 Apr 2025 07:58:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744185495; cv=none; b=CIQGcon3/0kORaNqP80xhkI/OHZ2C7yUc6xZA5Q40f2iYuL3EYM8/bv5pZF+ZIp/0RxST/gI/jYAbfb2Sj1shHQ7La8hudaXFNyaPNCezljKVeH8TwFPvIRNu8Mpr2suG13nCYqmbOaP+NVp5W2+Q2yTWtguc/3FekuM6xDLwuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744185495; c=relaxed/simple;
	bh=2GB/Vhf63Nvy4sQikpzvInmWjT5n7O+95z+dde9F27I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W2drA6Punr3LJlw67qQ7ica6zRx7S7Uw5h2DFXVAK1s0Jh+2BSdIpyaG6bSJrrYceKDGolgu1ASwTTnW7t2giMumkO3RUvAdl02J8OL5sQAc1OcteWuZHAnIpWMPUaiG0NH6KFAhuIt+LFWUsiXJN12xgzS63SjLmO+QMAO5G3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=FI/dfVgg; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="FI/dfVgg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=6kIyk7JJBJzv6CmAmK/lluChD+jTZqAhOMs9+DoDEVw=; b=FI/dfVggew7PVVVUKIS+qWr3VQ
	T2VP2hlvQST61Neiq2a/QyVC1qFNP9J2u9VUCFJE8yKQOYRTGkY+Ft5ziwcMPNwO4OpxhjscLtzxD
	24YTmdR2in2HsxG9Va2a+VOJchjvUNg5RZV8Sk3lzI9ioyqPMR88JSqplNXMTGC+/XjT0NW//QQip
	03Bs2NwxW/22a5VYmkA4fqi+Wh5K7zCPV9c6BYfsBzAQDoy1BNu5ElLXk/UxEnMCwaKeOdYiTqd36
	Zc0pQzDgeN/lll/KDe6fiYxMyr3gQlTKnGnPLz37RBaUWaTIyMLHPfTzYN0aXAvlPN7RiyQRskKEX
	FtHBIbrg==;
Received: from 2a02-8389-2341-5b80-08b8-afb4-7bb0-fe1c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:8b8:afb4:7bb0:fe1c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1u2QK5-00000006Uf4-1zDU;
	Wed, 09 Apr 2025 07:58:13 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 33/45] xfs_mkfs: reflink conflicts with zoned file systems for now
Date: Wed,  9 Apr 2025 09:55:36 +0200
Message-ID: <20250409075557.3535745-34-hch@lst.de>
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

Until GC is enhanced to not unshared reflinked blocks we better prohibit
this combination.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 mkfs/xfs_mkfs.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 7d4114e8a2ea..0e351f9efc32 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -2957,6 +2957,14 @@ _("rt extent size not supported on realtime devices with zoned mode\n"));
 			}
 			cli->rtextsize = 0;
 		}
+		if (cli->sb_feat.reflink) {
+			if (cli_opt_set(&mopts, M_REFLINK)) {
+				fprintf(stderr,
+_("reflink not supported on realtime devices with zoned mode specified\n"));
+				usage();
+			}
+			cli->sb_feat.reflink = false;
+		}
 
 		/*
 		 * Force the rtinherit flag on the root inode for zoned file
-- 
2.47.2

