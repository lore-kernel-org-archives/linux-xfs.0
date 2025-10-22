Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 740F43064B7
	for <linux-xfs@vger.kernel.org>; Wed, 22 Oct 2025 08:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761123166; cv=none; b=Pxrxh0YrSVv9H6LBmwiobzQJHZUvInnuM6G6Rztb/5qdwWY+8uNv5R+oJ91Zt8pTJBpdpQ+9STpX4P0gdFsWJ8qo85Eg8Xg3HPy8vynQfzWxI6TqgNAjC/hYcN0xQxwk7dt1/RNG2vrh5bc62riTWlA3avJkN66wUAsRUrSYJGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761123166; c=relaxed/simple;
	bh=DxT/ae+TT8oooqhbReopMURDPGSsrSr1i0kLo7N5um8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yc52LnILFGcg9iteYpVI/Qzi5ieZtG6xfv86qTO0Rc0m1YvM2HjI+Tqb/Gk1ReUUfLOcq2UXSdvuE6nDd4b2d1+42M2kwm9JOHu1Flj2lT3LT69N7YkIvU0oqiRjxryGHHvTli/yF+AbWkeqOcRTs+/pmMBodNGajbdqTU4pkj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=BBUQIUcQ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="BBUQIUcQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=qtcyGqiWflcvA3jJhUN0Yv+lNL4956WYwIMHZW7Fyi4=; b=BBUQIUcQaRO4PvnamF4CLDjvcB
	joOf7binaDBQN/RKF8ZpRfMl9GYwJU2xO8pDkM89Yv4YsAxkL93klPqV4/bO3RgV3vuWzX3qy6Ng+
	hr8DpnKMBB9bxLLJTYoG7HlRIgYy6PIorp6mXlGPe4gesBW8IaCvav6o69/oy+1f7eFK8PJdC6392
	ZVAt3SbALXCktdsBn7dedy9BaQ+SCvzT86wRxfbl5AhFPorQydzsTGJORGnoltPCgz9gRchvvoO6U
	mZQkHgAp+a6BltZv8kD82+2l8whxrIYq7yLKrHuMc/yEae1CSqjFBNdPx/nXqqnEXdHzNICQBrxVt
	ak2DRW3g==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vBUaK-000000029SS-1RHB;
	Wed, 22 Oct 2025 08:52:44 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 2/3] mkfs: improve the error message from check_device_type
Date: Wed, 22 Oct 2025 10:52:04 +0200
Message-ID: <20251022085232.2151491-3-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251022085232.2151491-1-hch@lst.de>
References: <20251022085232.2151491-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Tell the user what device is missing.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 mkfs/xfs_mkfs.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index bc6a28b63c24..e66f71b903eb 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -1333,6 +1333,7 @@ check_device_type(
 	struct libxfs_dev	*dev,
 	bool			no_size,
 	bool			dry_run,
+	const char		*device_type,
 	const char		*optname)
 {
 	struct stat statbuf;
@@ -1345,7 +1346,8 @@ check_device_type(
 	}
 
 	if (!dev->name) {
-		fprintf(stderr, _("No device name specified\n"));
+		fprintf(stderr, _("No %s device name specified\n"),
+				device_type);
 		usage();
 	}
 
@@ -2376,11 +2378,13 @@ validate_sectorsize(
 	 * Before anything else, verify that we are correctly operating on
 	 * files or block devices and set the control parameters correctly.
 	 */
-	check_device_type(&cli->xi->data, !cli->dsize, dry_run, "d");
+	check_device_type(&cli->xi->data, !cli->dsize, dry_run, "data", "d");
 	if (!cli->loginternal)
-		check_device_type(&cli->xi->log, !cli->logsize, dry_run, "l");
+		check_device_type(&cli->xi->log, !cli->logsize, dry_run, "log",
+				"l");
 	if (cli->xi->rt.name)
-		check_device_type(&cli->xi->rt, !cli->rtsize, dry_run, "r");
+		check_device_type(&cli->xi->rt, !cli->rtsize, dry_run, "RT",
+				"r");
 
 	/*
 	 * Explicitly disable direct IO for image files so we don't error out on
-- 
2.47.3

