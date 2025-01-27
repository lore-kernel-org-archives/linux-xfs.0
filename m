Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F5ED1FF7B3
	for <linux-xfs@vger.kernel.org>; Mon, 27 Jan 2025 13:54:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737986052; cv=none; b=iuZxvU1JVm9zbd7w07lzU9/PUEqVX8kIBIkSk7DO5m37PcwbCNp44Ah73g5XFqAzL0ujyU4p6xsRrOODYqW7Y1cAJOchWdoUDxgSzn1AHEbN/2098PU3OGVjsV/1XvuiaYG9+CNkYASnSRprUQfrViqIrEKOtnetJL6pU6OboR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737986052; c=relaxed/simple;
	bh=qrxbGSIYzrM//qmI8rz+ACjIxc/oFTr29hg8vlaZArs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=c8rHbP5WpbKRf44CjdBcjDnq9MPmyoJuwDKlvo7BgVnPpe4b5wInMxKrVx4sDet2wKslrjt1PHAOUQ/SHwd5j/MOO+6NT0axTwGJCTN0GnVPrf/kE0p0M/TPKpHwfbClWXbw2NOUWxTiB2OZz15UDVny46IdBDqJHYbaDYMPEJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=yfYaU4ZB; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="yfYaU4ZB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=sjXAxEiuvv24RJ/2JdtFeUMqz4jJFIgHWR7varncLoE=; b=yfYaU4ZBlN1Uqimgo+IJn9zObM
	KZrA8g7BcqYP8GgKmp24Kdl4Vkyiqjl4JRirMA1XEouUTc0Cn1iZ6355rk6u6zylVb6Ibf1IuqX7U
	pkmnmc92AdNGqIfl7HuP0RbixGOz3wvut6TA4BY/s8iW6zjfRZmm2EARM6vcYKOde/tv0eSQidv19
	z+keI15zVoJTZz2v54UuYhIHJZpPO46HmDTsZWT1UW9UY53EaoGMwB0IvMcE9sbo8tKXPTUoqvZ58
	GtLJwsQs+hQdvnRzOy/19w3TO7IMtBbZCeiQLPSbR0b0wsKdqfu83L80+UlH90jZdffxQT+IzDdfS
	PTM6ZFzw==;
Received: from 2a02-8389-2341-5b80-b8ca-be22-b5e2-4029.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:b8ca:be22:b5e2:4029] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tcPZ1-00000002QgL-41q5;
	Mon, 27 Jan 2025 13:54:08 +0000
From: Christoph Hellwig <hch@lst.de>
To: aalbersh@redhat.com
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH] mkfs: use a default sector size that is also suitable for the rtdev
Date: Mon, 27 Jan 2025 14:54:03 +0100
Message-ID: <20250127135403.525965-1-hch@lst.de>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

When creating a filesytem where the data device has a sector size
smalle than that of the RT device without further options, mkfs
currently fails with:

mkfs.xfs: error - cannot set blocksize 512 on block device $RTDEV: Invalid argument

This is because XFS sets the sector size based on logical block size
of the data device, but not that of the RT device.  Change the code
so that is uses the larger of the two values.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 mkfs/xfs_mkfs.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 6cc7e6439ca1..0627af81da37 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -2368,7 +2368,9 @@ validate_sectorsize(
 		 * advertised sector size of the device.  We use the physical
 		 * sector size unless the requested block size is smaller
 		 * than that, then we can use logical, but warn about the
-		 * inefficiency.
+		 * inefficiency.  If the file system has a RT device, the
+		 * sectorsize needs to be the maximum of the data and RT
+		 * device.
 		 *
 		 * Some architectures have a page size > XFS_MAX_SECTORSIZE.
 		 * In that case, a ramdisk or persistent memory device may
@@ -2378,8 +2380,18 @@ validate_sectorsize(
 			ft->data.physical_sector_size =
 				ft->data.logical_sector_size;
 		}
-
 		cfg->sectorsize = ft->data.physical_sector_size;
+
+		if (cli->xi->rt.name) {
+			if (ft->rt.physical_sector_size > XFS_MAX_SECTORSIZE) {
+				ft->rt.physical_sector_size =
+					ft->rt.logical_sector_size;
+			}
+
+			if (cfg->sectorsize < ft->rt.physical_sector_size)
+				cfg->sectorsize = ft->rt.physical_sector_size;
+		}
+
 		if (cfg->blocksize < cfg->sectorsize &&
 		    cfg->blocksize >= ft->data.logical_sector_size) {
 			fprintf(stderr,
-- 
2.45.2

