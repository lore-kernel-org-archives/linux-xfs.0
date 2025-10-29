Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F24F2EC0B9
	for <linux-xfs@vger.kernel.org>; Wed, 29 Oct 2025 09:07:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761728868; cv=none; b=p1OdS7v6lhRd2I8ec0VES7/k6oWYoXV3Z9wnVIJilAEyd6HtKqMkvkkW2J+Uo+kT04GOSHwni39VPTrSUGuMOQsGR/avs59QogaIvS8gJSzncnUfPP/El+nPKJYb/X1bLcadfYibLxudaVGFQaLm6ce5oqDMaKz3sXdX/2bN99g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761728868; c=relaxed/simple;
	bh=SSnOdDSTAiuWFCQZlxWYEhRrnT+7ftJxnlVF8Did3hk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lWj7KTQS2LSOPa+xPf/th1adsFjv33/4S2Wo3l1r18ybM6wvfnO59SkmsUVV4e4+ahVmTP06vdw2eESMs7i2gaEsfndidsH4WhYdd7eL6KGXG44h9yI8U5Fbxl1xyVPJ3lCqlc6ISnFBTfA13SrqPacIMmAPjIs/+UXdrLgeTUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=S5Pu6+dS; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="S5Pu6+dS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=6N8bJaB+CrKTrm3nD2dJ60rgijkwj3bflu6VJYnncKo=; b=S5Pu6+dS6216aTXC1FRXzduWbX
	/NJmypluEuaQpd+55HrsbdI9B1DhicxkuV9rn832tQLfcGo2hZPgjHHhhKuptS9WIC+CE5QtjW1oT
	OvprKaCMRBGXb+awn9qWsPP4oQt6OlqNVCZ/Bj34nYZa3k3bLQHnztKMHlwdmebSqWSM0tAS3vS9m
	CjkkSinG8alMEIplwInD/oBSOoDItsoHL+uRmsz4YyS54hAtqlDu4RTJNyvVFYpC1Z3vr5600UIqp
	5mOgykdjd91JviLCmpoW6uB3z1RIwaEPCIeuteiOrCm9NXamS6x4OzXBsxeEBRpWgObaa2X8LFIip
	jRwMP78Q==;
Received: from [2001:4bb8:2dc:1fd0:cc53:aef5:5079:41d6] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vE29h-00000000Qjc-2Q8T;
	Wed, 29 Oct 2025 09:07:45 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 1/4] mkfs: move clearing LIBXFS_DIRECT into check_device_type
Date: Wed, 29 Oct 2025 10:07:29 +0100
Message-ID: <20251029090737.1164049-2-hch@lst.de>
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

Keep it close to the block device vs regular file logic and remove
the checks for each device in the caller.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 mkfs/xfs_mkfs.c | 27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index cb7c20e3aa18..3ccd37920321 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -1330,6 +1330,7 @@ nr_cpus(void)
 
 static void
 check_device_type(
+	struct cli_params	*cli,
 	struct libxfs_dev	*dev,
 	bool			no_size,
 	bool			dry_run,
@@ -1375,6 +1376,13 @@ check_device_type(
 			dev->isfile = 1;
 		else if (!dry_run)
 			dev->create = 1;
+
+		/*
+		 * Explicitly disable direct IO for image files so we don't
+		 * error out on sector size mismatches between the new
+		 * filesystem and the underlying host filesystem.
+		 */
+		cli->xi->flags &= ~LIBXFS_DIRECT;
 		return;
 	}
 
@@ -2378,21 +2386,14 @@ validate_sectorsize(
 	 * Before anything else, verify that we are correctly operating on
 	 * files or block devices and set the control parameters correctly.
 	 */
-	check_device_type(&cli->xi->data, !cli->dsize, dry_run, "data", "d");
+	check_device_type(cli, &cli->xi->data, !cli->dsize, dry_run,
+			"data", "d");
 	if (!cli->loginternal)
-		check_device_type(&cli->xi->log, !cli->logsize, dry_run, "log",
-				"l");
+		check_device_type(cli, &cli->xi->log, !cli->logsize, dry_run,
+				"log", "l");
 	if (cli->xi->rt.name)
-		check_device_type(&cli->xi->rt, !cli->rtsize, dry_run, "RT",
-				"r");
-
-	/*
-	 * Explicitly disable direct IO for image files so we don't error out on
-	 * sector size mismatches between the new filesystem and the underlying
-	 * host filesystem.
-	 */
-	if (cli->xi->data.isfile || cli->xi->log.isfile || cli->xi->rt.isfile)
-		cli->xi->flags &= ~LIBXFS_DIRECT;
+		check_device_type(cli, &cli->xi->rt, !cli->rtsize, dry_run,
+				"RT", "r");
 
 	memset(ft, 0, sizeof(*ft));
 	get_topology(cli->xi, ft, force_overwrite);
-- 
2.47.3

