Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DCD02EC0B5
	for <linux-xfs@vger.kernel.org>; Wed, 29 Oct 2025 09:07:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761728877; cv=none; b=aD0yq7z07fzdEkWZ1Ls9+0e7WDIxBe95jURqNJ1ww69HHwI+TLSxZzJZVCvuzHQ9v5d07HDr6FVo2O8cXGSA94lxqa922rdQiLbpsRkc+CGP73DX2RbwtZy9Y5Hbc8rsTjHUBPlx42J/IPYs4nKjUML+aUa4wNmbv1r9rpbPCic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761728877; c=relaxed/simple;
	bh=YMb1+6P+fux5+CvHD0PM4E3BBhtGLgx6PDldPEkt0d0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FTP0OzBAlLYt0WY9m8yW2/CcrDwLRRHjlvrl+tAUZJAGIeGdV407i133qm9bvWWko32aFFt4Xi39WIqv6sAK82drhfLIdERHP7bPB//TzMJ6znvracRLWRuPfb/MIuKrQjG5F+Qif+Tmo4lHfPeKpGJ1uLF4GkfiBswBxNh210Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=M09RDKcI; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="M09RDKcI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:
	To:From:Sender:Reply-To:Content-ID:Content-Description;
	bh=oA6fZwo392Xn/MaFmh5sEEg0ZRq/aMLmUUBphdueEPc=; b=M09RDKcIXknPvLTuUfk5DKC9FC
	GNLW+06FcQAC+LAlWobQVramskPZ++f5SPnsw3AaCsNCe+wRp6rbog+tdxF313L/Go5s0kRmaHyfX
	aD6bEUttUnKTPoehIoYFbCTNwtvF8c+9fWHW/8PonABzBk94NKsKprfxVcnKFJSPwkK3VP7CfVXo1
	Rzibqz0gmzH6LlSw30Mjg54E95y3QAPsGWflV6Q4SWxUk0R53P68ZvJzrfEhfHX8uDA/HNUsLkswn
	8kV82Wc/+Ben0vhbKFDgapcUtMc10yHbc4ldoBOYA3N7/xlFmoNtsYbybHWOLV9uOPdw9jLY/JK6C
	pganJ8HA==;
Received: from [2001:4bb8:2dc:1fd0:cc53:aef5:5079:41d6] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vE29q-00000000Qlu-46e1;
	Wed, 29 Oct 2025 09:07:55 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 4/4] mkfs: split zone reset from discard
Date: Wed, 29 Oct 2025 10:07:32 +0100
Message-ID: <20251029090737.1164049-5-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251029090737.1164049-1-hch@lst.de>
References: <20251029090737.1164049-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Zone reset is a mandatory part of creating a file system on a zoned
device, unlike discard, which can be skipped.  It also is implemented
a bit different, so just split the handling.  This also means that we
can now support the -K option to skip discard on the data section for
zoned file systems.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 mkfs/xfs_mkfs.c | 112 +++++++++++++++++++++++-------------------------
 1 file changed, 53 insertions(+), 59 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 09a69af31be5..cd4f3ba4a549 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -1607,34 +1607,6 @@ discard_blocks(int fd, uint64_t nsectors, int quiet)
 		printf("Done.\n");
 }
 
-static void
-reset_zones(
-	struct mkfs_params	*cfg,
-	int			fd,
-	uint64_t		start_sector,
-	uint64_t		nsectors,
-	int			quiet)
-{
-	struct blk_zone_range range = {
-		.sector		= start_sector,
-		.nr_sectors	= nsectors,
-	};
-
-	if (!quiet) {
-		printf("Resetting zones...");
-		fflush(stdout);
-	}
-
-	if (ioctl(fd, BLKRESETZONE, &range) < 0) {
-		if (!quiet)
-			printf(" FAILED (%d)\n", -errno);
-		exit(1);
-	}
-
-	if (!quiet)
-		printf("Done.\n");
-}
-
 static __attribute__((noreturn)) void
 illegal_option(
 	const char		*value,
@@ -3780,41 +3752,66 @@ discard_devices(
 	struct zone_topology	*zt,
 	int			quiet)
 {
-	/*
-	 * This function has to be called after libxfs has been initialized.
-	 */
-
 	if (!xi->data.isfile) {
 		uint64_t	nsectors = xi->data.size;
 
-		if (cfg->rtstart && zt->data.nr_zones) {
-			/*
-			 * Note that the zone reset here includes the LBA range
-			 * for the data device.
-			 *
-			 * This is because doing a single zone reset all on the
-			 * entire device (which the kernel automatically does
-			 * for us for a full device range) is a lot faster than
-			 * resetting each zone individually and resetting
-			 * the conventional zones used for the data device is a
-			 * no-op.
-			 */
-			reset_zones(cfg, xi->data.fd, 0,
-					cfg->rtstart + xi->rt.size, quiet);
+		if (cfg->rtstart && zt->data.nr_zones)
 			nsectors -= cfg->rtstart;
-		}
 		discard_blocks(xi->data.fd, nsectors, quiet);
 	}
-	if (xi->rt.dev && !xi->rt.isfile) {
-		if (zt->rt.nr_zones)
-			reset_zones(cfg, xi->rt.fd, 0, xi->rt.size, quiet);
-		else
-			discard_blocks(xi->rt.fd, xi->rt.size, quiet);
-	}
+	if (xi->rt.dev && !xi->rt.isfile && !zt->rt.nr_zones)
+		discard_blocks(xi->rt.fd, xi->rt.size, quiet);
 	if (xi->log.dev && xi->log.dev != xi->data.dev && !xi->log.isfile)
 		discard_blocks(xi->log.fd, xi->log.size, quiet);
 }
 
+static void
+reset_zones(
+	struct mkfs_params	*cfg,
+	struct libxfs_dev	*dev,
+	uint64_t		size,
+	bool			quiet)
+{
+	struct blk_zone_range range = {
+		.nr_sectors	= size,
+	};
+
+	if (!quiet) {
+		printf("Resetting zones...");
+		fflush(stdout);
+	}
+	if (ioctl(dev->fd, BLKRESETZONE, &range) < 0) {
+		if (!quiet)
+			printf(" FAILED (%d)\n", -errno);
+		exit(1);
+	}
+	if (!quiet)
+		printf("Done.\n");
+}
+
+static void
+reset_devices(
+	struct mkfs_params	*cfg,
+	struct libxfs_init	*xi,
+	struct zone_topology	*zt,
+	int			quiet)
+{
+	/*
+	 * Note that the zone reset here includes the conventional zones used
+	 * for the data device.
+	 *
+	 * It is done that way because doing a single zone reset all on the
+	 * entire device (which the kernel automatically does for us for a full
+	 * device range) is a lot faster than resetting each zone individually
+	 * and resetting the conventional zones used for the data device is a
+	 * no-op.
+	 */
+	if (!xi->data.isfile && zt->data.nr_zones && cfg->rtstart)
+		reset_zones(cfg, &xi->data, cfg->rtstart + xi->rt.size, quiet);
+	if (xi->rt.dev && !xi->rt.isfile && zt->rt.nr_zones)
+		reset_zones(cfg, &xi->rt, xi->rt.size, quiet);
+}
+
 static void
 validate_datadev(
 	struct mkfs_params	*cfg,
@@ -6196,13 +6193,10 @@ main(
 	/*
 	 * All values have been validated, discard the old device layout.
 	 */
-	if (cli.sb_feat.zoned && !discard) {
-		fprintf(stderr,
- _("-K not support for zoned file systems.\n"));
-		return 1;
-	}
 	if (discard && !dry_run)
-		discard_devices(&cfg, &xi, &zt, quiet);
+		discard_devices(&cfg, cli.xi, &zt, quiet);
+	if (cli.sb_feat.zoned && !dry_run)
+		reset_devices(&cfg, cli.xi, &zt, quiet);
 
 	/*
 	 * we need the libxfs buffer cache from here on in.
-- 
2.47.3

