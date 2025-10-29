Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 980C630B52B
	for <linux-xfs@vger.kernel.org>; Wed, 29 Oct 2025 09:07:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761728871; cv=none; b=au8OaNtWm1tBWxS8vhQWM4usj7PaOTloHK9v/6K5XsFtyElMxD0/UOVnOaxRouP+3E4BtOmTxkDP8onvwcdh8zenib8TZD1oeTZeWqQzgrejuD++11L7Vt6370q53+OxpaEkK1dBw8kRS7zJNYIz1TS6e044ybFb2ZGwhCXc74U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761728871; c=relaxed/simple;
	bh=NSisV2LXqLP0cEiiBxm5rDptwedsld/AP3lwZZLJ1N8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MR3FN0/RomOi43wI2Omhrdf0AtfrWgLxvZV8gz8Ja+nACRmmPeCsSC01X84HUfvj6w+aBI/+V8iTfzpAQqO41DoyEApkGQGeq7fwzvA9B5me48cBxiXZcAeZucctIvetl7X0qKUwu8LKvjLIYe3L/PR3vFyh78QHpwBt2k2ZRAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=KgQFk0tC; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="KgQFk0tC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=BxVX5BYg6gNR5YjGhzZ9iKMk5UHmNqNV7JGpYLtSBZs=; b=KgQFk0tCrhh3VUfTenZFqA98mZ
	FU29LVhu4rhFN9NZVj+DoUZ/Upoqaq5ATjQ9JQX9ab9jQs4+yYzKp4xma07Jis4QRaC5EJvUTh3xG
	GAOFcgnHok3RmJsojKPLWevCLkTsjWIPHty/yO6INdwPf/2sL78MH+xsE4JaKymTCroTPM1sBUroV
	9xMnvXg1Omr/4ICp+etwUiJ8GmfrZNL+NMK2cL9H6Fyht5Ics113TxhlAdfmdfMNGv66GOninAIef
	IwZUU5P/0yxGvir96aBZX5fYimyWo2N+GV9y9IbEUlDqlSIXHY455jX8mRh9AUwcAyoCe6LfqUS+X
	JaSCr+pg==;
Received: from [2001:4bb8:2dc:1fd0:cc53:aef5:5079:41d6] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vE29k-00000000Qku-36mw;
	Wed, 29 Oct 2025 09:07:49 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 2/4] libxfs: cleanup get_topology
Date: Wed, 29 Oct 2025 10:07:30 +0100
Message-ID: <20251029090737.1164049-3-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251029090737.1164049-1-hch@lst.de>
References: <20251029090737.1164049-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Add a libxfs_ prefix to the name, clear the structure in the helper
instead of in the callers, and use a bool to pass a boolean argument.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/topology.c | 9 +++++----
 libxfs/topology.h | 7 ++-----
 mkfs/xfs_mkfs.c   | 3 +--
 repair/sb.c       | 3 +--
 4 files changed, 9 insertions(+), 13 deletions(-)

diff --git a/libxfs/topology.c b/libxfs/topology.c
index 7764687beac0..366165719c84 100644
--- a/libxfs/topology.c
+++ b/libxfs/topology.c
@@ -224,7 +224,7 @@ static void
 blkid_get_topology(
 	const char		*device,
 	struct device_topology	*dt,
-	int			force_overwrite)
+	bool			force_overwrite)
 {
 	blkid_topology tp;
 	blkid_probe pr;
@@ -317,7 +317,7 @@ static void
 get_device_topology(
 	struct libxfs_dev	*dev,
 	struct device_topology	*dt,
-	int			force_overwrite)
+	bool			force_overwrite)
 {
 	struct stat		st;
 
@@ -364,11 +364,12 @@ get_device_topology(
 }
 
 void
-get_topology(
+libxfs_get_topology(
 	struct libxfs_init	*xi,
 	struct fs_topology	*ft,
-	int			force_overwrite)
+	bool			force_overwrite)
 {
+	memset(ft, 0, sizeof(*ft));
 	get_device_topology(&xi->data, &ft->data, force_overwrite);
 	get_device_topology(&xi->rt, &ft->rt, force_overwrite);
 	get_device_topology(&xi->log, &ft->log, force_overwrite);
diff --git a/libxfs/topology.h b/libxfs/topology.h
index f0ca65f3576e..3688d56b542f 100644
--- a/libxfs/topology.h
+++ b/libxfs/topology.h
@@ -25,11 +25,8 @@ struct fs_topology {
 	struct device_topology	log;
 };
 
-void
-get_topology(
-	struct libxfs_init	*xi,
-	struct fs_topology	*ft,
-	int			force_overwrite);
+void libxfs_get_topology(struct libxfs_init *xi, struct fs_topology *ft,
+		bool force_overwrite);
 
 extern void
 calc_default_ag_geometry(
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 3ccd37920321..0ba7798eccf6 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -2395,8 +2395,7 @@ validate_sectorsize(
 		check_device_type(cli, &cli->xi->rt, !cli->rtsize, dry_run,
 				"RT", "r");
 
-	memset(ft, 0, sizeof(*ft));
-	get_topology(cli->xi, ft, force_overwrite);
+	libxfs_get_topology(cli->xi, ft, force_overwrite);
 
 	/* set configured sector sizes in preparation for checks */
 	if (!cli->sectorsize) {
diff --git a/repair/sb.c b/repair/sb.c
index 0e4827e04678..ee1cc63fae64 100644
--- a/repair/sb.c
+++ b/repair/sb.c
@@ -184,8 +184,7 @@ guess_default_geometry(
 	uint64_t		dblocks;
 	int			multidisk;
 
-	memset(&ft, 0, sizeof(ft));
-	get_topology(x, &ft, 1);
+	libxfs_get_topology(x, &ft, true);
 
 	/*
 	 * get geometry from get_topology result.
-- 
2.47.3

