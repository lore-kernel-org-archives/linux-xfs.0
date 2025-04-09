Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 811D025D538
	for <linux-xfs@vger.kernel.org>; Wed,  9 Apr 2025 07:58:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744185529; cv=none; b=m9TxZhuPJ3BU/JwPKCSB9ptVwJbAVDypD8FmFrulU+OK6GL4W6m8PRHhrtcibmawco5AY/FJJxJluELymD0G+3T0kFOiGZQAefTKx5087Ev1YLJi8nri9WsF5or/EZkDpyVOb81tlYqCvupsUpyZRvt5Ix/ix3QKqT0Kgv0dt4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744185529; c=relaxed/simple;
	bh=hgrtWT8hFplPYVWxrB5fdfqkAubNvP/eLg3rKHI/IDs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=doQXJEN97Urik86sP1QZm8z+ZB5BI8SaioDhZD+VDHgYhX+alftk3ExwXJJIvJx2eMJyFOktoLDnaYY7pAfgvIXvoyjpy1eeFgmrJ36c12adml3FBTuCdotflyrGkhvREFISQc94bBskDiFPVLBa6c8g36o6v/BqQnhi9qPVOg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=DYOhZTaQ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="DYOhZTaQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Ja6DXChtQgxrXDjnNENvbL5W+0bawBiMI58JQvY9jr8=; b=DYOhZTaQEwEqqaXR6Uu4v9+O2I
	YFQiqXWOfA2imKaZb5J1/zFZ4UbYaIX14GA8QtqnvRinAZtOblN24Te7Eh80+xhc+TavoFzhUhpxp
	OKAo2lNSS4yhGPAS3Ab0FBTq2K9YAzVAiadF6CeLfit7e96h50e4I4C+K4klZobLLEPJbCj+VH+xl
	hbuJ/oy4yQyKVweolGrHKiynZXPL4QyLTVTWzJuTHxI3ApdgC1SKlWTxl8K9Fv8QyDlYkDXJXVW3I
	i5JqI9Z+WDYNr/rYMXnQnmhEIZf/9e4kIX5HyqmIsUvCrTw2lcRNpiuOl2VXePp5nHJz+s1F7FQV5
	NBYSQ9NQ==;
Received: from 2a02-8389-2341-5b80-08b8-afb4-7bb0-fe1c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:8b8:afb4:7bb0:fe1c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1u2QKd-00000006Uny-1YQX;
	Wed, 09 Apr 2025 07:58:48 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 42/45] xfs_scrub: support internal RT sections
Date: Wed,  9 Apr 2025 09:55:45 +0200
Message-ID: <20250409075557.3535745-43-hch@lst.de>
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

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 scrub/phase1.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/scrub/phase1.c b/scrub/phase1.c
index d03a9099a217..e71cab7b7d90 100644
--- a/scrub/phase1.c
+++ b/scrub/phase1.c
@@ -341,7 +341,8 @@ _("Kernel metadata repair facility is not available.  Use -n to scrub."));
 _("Unable to find log device path."));
 		return ECANCELED;
 	}
-	if (ctx->mnt.fsgeom.rtblocks && ctx->fsinfo.fs_rt == NULL) {
+	if (ctx->mnt.fsgeom.rtblocks && ctx->fsinfo.fs_rt == NULL &&
+	    !(ctx->mnt.fsgeom.flags & XFS_FSOP_GEOM_FLAGS_ZONED)) {
 		str_error(ctx, ctx->mntpoint,
 _("Unable to find realtime device path."));
 		return ECANCELED;
-- 
2.47.2

