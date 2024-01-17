Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E84EB22F08
	for <linux-xfs@vger.kernel.org>; Wed, 17 Jan 2024 17:33:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705512816; cv=none; b=B/848+wDow/nK1+wKBaQMvT3ikUxJ8jvO3uxvHYHYfQoq4l0GACoxZiUhGrRpw4tNVTjTc6qUerXtQvprk1QzrM3W5LQ5oDTvwsLtVR2CWbhlA6ReP6yqMz4MiVzHDX6lW8Ej7KB0tW0dEfAq1h8DuY3yd0Ii7+vzjdgkREuULg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705512816; c=relaxed/simple;
	bh=5BeUFQTAQIoodBzCeodmekbuZZUqF80gqtzyYTWTq/g=;
	h=DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-Id:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-SRS-Rewrite; b=MwuW/YPcGptYIf9vjp3V+lLHfwGOOq4AOB+3fBp2DF/GcJK1Z2NzyXkqXoQWXKt9f11B/mmbb+k0GCEWk4Mm8ZqZSm6P0mxyd8iqRY5VmQPftycRIpw7Ap3Z7dofNJXLfKu9ADDtMJvVjDQMWkVIbMQqxxHctulat4fy9A6Oc7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=NcnpjlGB; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="NcnpjlGB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=ppU7E4QdOrA6uPgv6tis+KifYdoJLmBXIb/FZWnn5Y8=; b=NcnpjlGB0hFDAJ61KA/wsNxAVR
	pJUcuODwL0RWVhY9jUMlhojMMGbdSDnXXtGNA7MjJ1pW6hDbaFlh9d6FLWMP7F6btHINtA6HF0Ba0
	fSCCOXsBlFhS+stLRF3Rh5eoylisIzn5Q49X5lDb9hN6DalZEBu388M009SNuCCypoDQqpV0tHmPl
	YtoAC81rq8QVnSvSqJAV8CY8JFk2BQCFBdy5tt4ZZJsnR+2j4anOfpDFYTrgdkmMJHraz1d4ctSb5
	X7FBxX6FgORfESucOruMm8r8HFyzkfiItw101Q2oC05bDaFpfA96CA83qqhbQPpTgcZoQ/Qp95vLD
	ED3u/dYw==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rQ9nA-000ESw-2n;
	Wed, 17 Jan 2024 17:33:33 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cmaiolino@redhat.com>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 5/5] mkfs: use a sensible log sector size default
Date: Wed, 17 Jan 2024 18:33:12 +0100
Message-Id: <20240117173312.868103-6-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240117173312.868103-1-hch@lst.de>
References: <20240117173312.868103-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Currently the XFS log sector size defaults to the 512 bytes unless
explicitly overriden.  Default to the device logical block size queried
by get_topology instead.  If that is also 512 nothing changes, and if
the device logical block size is larger this prevents a mkfs failure
because the libxfs buffer cache blows up and as we obviously can't
use a smaller than hardware supported sector size.  This fixes xfs/157
with a 4k block size device.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 mkfs/xfs_mkfs.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index be65ccc1e..022a11a7f 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -2075,7 +2075,8 @@ static void
 validate_log_sectorsize(
 	struct mkfs_params	*cfg,
 	struct cli_params	*cli,
-	struct mkfs_default_params *dft)
+	struct mkfs_default_params *dft,
+	struct fs_topology	*ft)
 {
 
 	if (cli->loginternal && cli->lsectorsize &&
@@ -2090,7 +2091,7 @@ _("Can't change sector size on internal log!\n"));
 	else if (cli->loginternal)
 		cfg->lsectorsize = cfg->sectorsize;
 	else
-		cfg->lsectorsize = dft->sectorsize;
+		cfg->lsectorsize = ft->log.logical_sector_size;
 	cfg->lsectorlog = libxfs_highbit32(cfg->lsectorsize);
 
 	if (cfg->lsectorsize < XFS_MIN_SECTORSIZE ||
@@ -4196,7 +4197,7 @@ main(
 	blocksize = cfg.blocksize;
 	sectorsize = cfg.sectorsize;
 
-	validate_log_sectorsize(&cfg, &cli, &dft);
+	validate_log_sectorsize(&cfg, &cli, &dft, &ft);
 	validate_sb_features(&cfg, &cli);
 
 	/*
-- 
2.39.2

