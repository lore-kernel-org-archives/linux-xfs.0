Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0BDD25A34A
	for <linux-xfs@vger.kernel.org>; Wed,  9 Apr 2025 07:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744185488; cv=none; b=FkBMgUldH+wDXf5y+SPtKte8KQPzSOXxLLh+uIGnbZ6+j/vSmtA0lITsZMf3Bf1YGh5uXyfCxWVNjgEjndfb/hpDTZfdkhQv9MfXCwRLfcJaNCJ3+NKc0L7vK1TU4i2Q0vCBVbWN0w2sFvLIgoSrtFELLvLD8p1O6kGlt4Fx+Rs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744185488; c=relaxed/simple;
	bh=yC7tUuVEGBK04zpFqAIzo8s1EhxuuufQh1TZMjwZj+g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V3choiEV8P4syjEuJswWWG6MUSP5nBWou0Q7o6yoc5RW0Cp+VccyNzUK7BFgsUCQ2K6FKOdKFZrNZrQUecD+mOcjOFQQXaufXdIqoyOG0tKEaJsgkIz2H0wPd0mQ7oHo2t0bGACvDQZq7tAiumbRedBoe+bOYot8clvS1rCTHy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=X+rUgeg5; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="X+rUgeg5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=sZW1zCMhgaxQbvDbHwkbIBmeJaPl4mLYFdaaQhWZ1TI=; b=X+rUgeg5Dn/wieMoa82GmT045m
	lzDq2m0UzKEBaO5vgeWjlaU6CRVopeGw/0LkDQFpZMi5pZiYaa25H248fubq+/+pEWJhrN+rKkdty
	HnG9otyiEQKVElPQen5fqsIkU/cKCUiS34BUoq9WWa/xlk90sYoDItnqpDok8+G6BtcQVhrhH6PPj
	NcIRi19XjVyVCQMiYSM6p2HXqbeAcA7hgg4kvhKM586ZDJ1ixkfmnoBiyehMsqx5X7yVf2FHhq2Lu
	UF5g/nywHSBxCZvY7jh9jV6A2pLQfW5jqjbr86cW7XQ46FaT3n56vnhz4J4N35T5ebyD3J26W5llv
	IyQrmmNA==;
Received: from 2a02-8389-2341-5b80-08b8-afb4-7bb0-fe1c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:8b8:afb4:7bb0:fe1c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1u2QJy-00000006UeI-0It5;
	Wed, 09 Apr 2025 07:58:06 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 31/45] xfs_mkfs: calculate zone overprovisioning when specifying size
Date: Wed,  9 Apr 2025 09:55:34 +0200
Message-ID: <20250409075557.3535745-32-hch@lst.de>
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

When size is specified for zoned file systems, calculate the required
over provisioning to back the requested capacity.

Signed-off-by: Hans Holmberg <hans.holmberg@wdc.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 mkfs/xfs_mkfs.c | 46 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 133ede8d8483..6b5eb9eb140a 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -4413,6 +4413,49 @@ _("rgsize (%s) not a multiple of fs blk size (%d)\n"),
 			NBBY * (cfg->blocksize - sizeof(struct xfs_rtbuf_blkinfo)));
 }
 
+/*
+ * If we're creating a zoned filesystem and the user specified a size, add
+ * enough over-provisioning to be able to back the requested amount of
+ * writable space.
+ */
+static void
+adjust_nr_zones(
+	struct mkfs_params	*cfg,
+	struct cli_params	*cli,
+	struct libxfs_init	*xi,
+	struct zone_topology	*zt)
+{
+	uint64_t		new_rtblocks, slack;
+	unsigned int		max_zones;
+
+	if (zt->rt.nr_zones)
+		max_zones = zt->rt.nr_zones;
+	else
+		max_zones = DTOBT(xi->rt.size, cfg->blocklog) / cfg->rgsize;
+
+	if (!cli->rgcount)
+		cfg->rgcount += XFS_RESERVED_ZONES;
+	if (cfg->rgcount > max_zones) {
+		cfg->rgcount = max_zones;
+		fprintf(stderr,
+_("Warning: not enough zones for backing requested rt size due to\n"
+  "over-provisioning needs, writeable size will be less than %s\n"),
+			cli->rtsize);
+	}
+	new_rtblocks = (cfg->rgcount * cfg->rgsize);
+	slack = (new_rtblocks - cfg->rtblocks) % cfg->rgsize;
+
+	cfg->rtblocks = new_rtblocks;
+	cfg->rtextents = cfg->rtblocks / cfg->rtextblocks;
+
+	/*
+	 * Add the slack to the end of the last zone to the reserved blocks.
+	 * This ensures the visible user capacity is exactly the one that the
+	 * user asked for.
+	 */
+	cfg->rtreserved += (slack * cfg->blocksize);
+}
+
 static void
 calculate_zone_geometry(
 	struct mkfs_params	*cfg,
@@ -4485,6 +4528,9 @@ _("rgsize (%s) not a multiple of fs blk size (%d)\n"),
 		}
 	}
 
+	if (cli->rtsize || cli->rgcount)
+		adjust_nr_zones(cfg, cli, xi, zt);
+
 	if (cfg->rgcount < XFS_MIN_ZONES)  {
 		fprintf(stderr,
 _("realtime group count (%llu) must be greater than the minimum zone count (%u)\n"),
-- 
2.47.2

