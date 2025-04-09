Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1596025B694
	for <linux-xfs@vger.kernel.org>; Wed,  9 Apr 2025 07:57:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744185474; cv=none; b=RroCzY5lwHnpxHqBXiLUFlCi1/vkwk98vNj6/zToPYTf5MT9p7PMLZGzv4Vt+ADnUBjwexLBn0/F14y9E++itIWWkOAnB/n/CNR8BODoo2h5ftpfwbEFq2qF/Paj5gYedSq8vpBb1exNOuxrpVysBIsK/xhUJhh2RYHGmifnjT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744185474; c=relaxed/simple;
	bh=QMToQoIenGGowk/gwZcqcTo13RgRi/yRgdIyUf77ik4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MDPv4USm9FGO3TSvgY3/GMvfu5Y80gkM/wewU/ZH/v7Dsx97II2dkv8dohZ6rTSo5zh8eYWIvbBCgYGAPogP0XYRhQhJH8Re7p64YRa/GAUxt3CtlqDmixUNgAAUDFt5k/TbZSsRSB/RjYqIiKr2zPL/6ccEnmfz4xHPt7QRil8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=0hV9CmNV; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="0hV9CmNV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=GSuN6SF8NRwXHleys7GPL1ayzG4L4wfu91B3UCIS+Uo=; b=0hV9CmNVZFArtAyHyc5TQjl9vy
	GC5rZGfim4P8AmZ1v73r33e7MkeB5V8olti6ktJSpDAIh4pwRMqYhhayrXE1fwcBDNYrlNzkEJPfv
	IKK6qbfgky1CZ5CibCQcIuFU/6gAoe5oPr2jsau81aLKhtlsxvCpmlIPVCwmjlsMWiaxvxTvvB52q
	TB7An4i5zkGfIXZ6PaMvgf+DtK48FVw72Olc/1xPiC8l5/KVKyrXmot2qe1PluNJUtreAxHjsWD0g
	PdLv+S8ohEpdBVXXs528vdjsowirotl0YLHkncY5enslv+v5U2uFwyHsS5Cr2UN8SA4HXGN0ta2Pc
	eKEAmmNg==;
Received: from 2a02-8389-2341-5b80-08b8-afb4-7bb0-fe1c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:8b8:afb4:7bb0:fe1c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1u2QJj-00000006Ucc-3dtN;
	Wed, 09 Apr 2025 07:57:52 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 28/45] xfs_repair: fix the RT device check in process_dinode_int
Date: Wed,  9 Apr 2025 09:55:31 +0200
Message-ID: <20250409075557.3535745-29-hch@lst.de>
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

Don't look at the variable for the rtname command line option, but
the actual file system geometry.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 repair/dinode.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/repair/dinode.c b/repair/dinode.c
index 7bdd3dcf15c1..0c559c408085 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -3265,8 +3265,9 @@ _("bad (negative) size %" PRId64 " on inode %" PRIu64 "\n"),
 			flags &= XFS_DIFLAG_ANY;
 		}
 
-		/* need an rt-dev for the realtime flag! */
-		if ((flags & XFS_DIFLAG_REALTIME) && !rt_name) {
+		/* need an rt-dev for the realtime flag */
+		if ((flags & XFS_DIFLAG_REALTIME) &&
+		    !mp->m_rtdev_targp) {
 			if (!uncertain) {
 				do_warn(
 	_("inode %" PRIu64 " has RT flag set but there is no RT device\n"),
-- 
2.47.2

