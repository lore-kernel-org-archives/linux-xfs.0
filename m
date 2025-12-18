Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6A15361DAD
	for <linux-xfs@vger.kernel.org>; Thu, 18 Dec 2025 16:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766074182; cv=none; b=WezA0mZQXpBY4EqJOxjxuqsQbidKDJnlgyi5mFy4MUVr1o9+WN3megGi73G6QGzIsuNPI1Iit8XmEvTjKSBz4/lodQPA40a8FOxA5Cq+iIVpv1u3MWuuavRR9f0Ac3ee4//7lzMWpHYQWOYoCbxZCbeRxsPhxt8XnjJye3F39i0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766074182; c=relaxed/simple;
	bh=4Rrgfhklk/ICpaE3CiMkQodhIU4bLXwPxjwIU9+lKmU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=om89y1JpnptyTFUqGIm+dAYxKhvHQywzScLfowAmLQ34aATEzJvwNsZAucv/VO5RyQnxTfcT3+oqFT3UivFMJEhqZBBRsDkhQuF1bO7t+0+qHtSupQJOgTfpnFdxYEhwkJStBWTP1ZqAebD8oFuifOo20o9u6NVJA/Fwj87s9vQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=1At8XKIM; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="1At8XKIM"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=wc4BzCj53Rzd5ZkF31iIj2bTBCgTRwoUzetknBUD3IU=; b=1At8XKIMXJmxqjQIRXTvodlasi
	AGR61dagJfoVCPv3yBd4DSlRicYgAVDMHxaAjMR2bEvNAvuD5noH7idsQ1g76m1afF9r4ch2dvCza
	zUyv6CcqfMEEGTCXmdS3jMtS6bKpq5d6FihKhDaEoILeigInv+3ChZZacmeeVoGv+nXErLmSVyCPr
	2s73rIJQd2wkbqiGZ6jsh4Q4Ok514PzXcIJbtH6YdrlzlUShWNAPs0sOuVdRYS0ZfPD5dis/0hEA8
	xFrUZ7ssWo/sR2omobEP+ormKEtK8PyXBeUCI6oxR33TF090yJnoS6bGER9tr8Un0eNtTrY3MtI9k
	FeuI3RNw==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vWGZM-00000008myT-1hJJ;
	Thu, 18 Dec 2025 16:09:36 +0000
From: Christoph Hellwig <hch@lst.de>
To: aalbersh@kernel.org
Cc: dlemoal@kernel.org,
	hans.holmberg@wdc.com,
	linux-xfs@vger.kernel.org
Subject: [PATCH] mkfs: adjust_nr_zones for zoned file system on conventional devices
Date: Thu, 18 Dec 2025 17:09:32 +0100
Message-ID: <20251218160932.1652588-1-hch@lst.de>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

When creating zoned file systems on conventional devices, mkfs doesn't
currently align the RT device size to the zone size, which can create
unmountable file systems.  Fix this by moving the rgcount modification
to account for reserved zoned and then calling adjust_nr_zones
unconditionally, and thus ensuring that the rtblocks and rtextents values
are guaranteed to always be a multiple of the zone size.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 mkfs/xfs_mkfs.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 8db51217016e..b34407725f76 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -4558,8 +4558,6 @@ adjust_nr_zones(
 		max_zones = DTOBT(cli->xi->rt.size, cfg->blocklog) /
 				cfg->rgsize;
 
-	if (!cli->rgcount)
-		cfg->rgcount += XFS_RESERVED_ZONES;
 	if (cfg->rgcount > max_zones) {
 		fprintf(stderr,
 _("Warning: not enough zones (%lu/%u) for backing requested rt size due to\n"
@@ -4652,9 +4650,9 @@ _("rgsize (%s) not a multiple of fs blk size (%d)\n"),
 		}
 	}
 
-	if (cli->rtsize || cli->rgcount)
-		adjust_nr_zones(cfg, cli, zt);
-
+	if (cli->rtsize)
+		cfg->rgcount += XFS_RESERVED_ZONES;
+	adjust_nr_zones(cfg, cli, zt);
 	if (cfg->rgcount < XFS_MIN_ZONES)  {
 		fprintf(stderr,
 _("realtime group count (%llu) must be greater than the minimum zone count (%u)\n"),
-- 
2.47.3

