Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E0E91A08CA
	for <linux-xfs@vger.kernel.org>; Mon, 14 Apr 2025 05:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744609084; cv=none; b=N9mxz6yqwrHqANNZpsKf8twCanInd9gTR972xIEmOE5uoKyDlNPVYNQm4ned2yOy2fWd2hRLh+FVD3eOjtZEw5fv/ju/uipF1a2ZoF4UjQw2iK+sqLGDCIGJCDBYBMCnnQFFIhbRRugwgO4m2C66vD4TOif6HhUr9tuJwYXk/Zc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744609084; c=relaxed/simple;
	bh=4+kGuwzrVodaH78wHSdFqfDLtHAvzd3AKajBq3bd+hE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rGwthi4toIaUNem5KnJoOFtgBONTkVqtkmEhZ6f2rnasbLGwQ0JG7P/XPWCViMXxS3QpAgRLhoStoowB0bKm02OzxUxnkOywnx7i/OPAeaDJQk++/jBH6kMpIpEZAl3iwEJ+uPeAjXyfkeWxIn0k1+ZzJNOqe3MZcVKzSqXRjRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=3MzHmYQG; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="3MzHmYQG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=9Hy3Hg2JF0uqejvJKmDp/VA+RC68wW04H+mbzNrLcLA=; b=3MzHmYQGD7PF1nOCgBCNbf24DE
	EJRNT+9sYBU7YhUcwxr8FEpdHA5v03pZDTwoST91FXRc5myfgaZSG9IeQj/BTWpF/14C8LV+9jFNI
	b9HAlsyK30cEoN092c2g+AweOVFgp64LCaDpMClQBGHWC2ol/kwRbhIDX6vCPOoG2YTUOZDj/Z6C4
	Orzf+DMR3PS77eCqmwQhaFzcN8iCSBcyTtDdYuEy+Eh5bl9XfDc9bPB9woPEzdiR6N6knsvvpRrt9
	3ZXaspnhdutZHkv4aMqaTXrtJ+ktkfE7w9NGp4cd92eeKBTglnzCIleaizSMvBmPW388sn6aJh893
	GWzsH1fA==;
Received: from 2a02-8389-2341-5b80-9d44-dd57-c276-829a.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:9d44:dd57:c276:829a] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1u4CWA-00000000iOM-3n8e;
	Mon, 14 Apr 2025 05:38:03 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 32/43] xfs_mkfs: calculate zone overprovisioning when specifying size
Date: Mon, 14 Apr 2025 07:36:15 +0200
Message-ID: <20250414053629.360672-33-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250414053629.360672-1-hch@lst.de>
References: <20250414053629.360672-1-hch@lst.de>
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
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 mkfs/xfs_mkfs.c | 46 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 8b7a0b617d3e..5cd100c87f43 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -4422,6 +4422,49 @@ _("rgsize (%s) not a multiple of fs blk size (%d)\n"),
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
+  "over-provisioning needs, writable size will be less than %s\n"),
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
@@ -4494,6 +4537,9 @@ _("rgsize (%s) not a multiple of fs blk size (%d)\n"),
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

