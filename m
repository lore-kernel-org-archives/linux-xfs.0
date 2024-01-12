Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26C895B5B0
	for <linux-xfs@vger.kernel.org>; Fri, 12 Jan 2024 04:47:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="uJd5uQHa"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=iuAjLJyYgb22Vu69NQRlkD5AjpwMro61N8ILoQSdJhE=; b=uJd5uQHaMVH1K3hM8glGPW8Mlx
	YkcwueEGG3btkth2UY6npNYK9gdLVS8PNr2RzD5C5omH+R9D6+FWzqjVfLh9VS7dicRYg15K5zCZC
	rOmxUYxdvr0/KlFwd31cqJF6Q3LkZO1ULE+mYqTcZ3a6SimgLueVpO3iYUrH5oQz9hIN6VrRCQonI
	vrl5suilDuGDrlsRk7bn2JWdPZw9HUfO8jT8lP68x4ld8JVDA7mjZUlh8qOzgo5+u46gQ5uRAk/yk
	3G13eOvBWKa5UtaEr6f3cZD6jKFsigIdPbW5wCcMzh6S4VYuWNaGD8Z9L8IBID40LUliG5a+64dfa
	JhJ8kVqQ==;
Received: from [2001:4bb8:191:2f6b:85c6:d242:5819:3c29] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rO9SS-001sX6-0x;
	Fri, 12 Jan 2024 04:47:52 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cmaiolino@redhat.com>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 2/4] libxfs: refactor the fs_topology structure
Date: Fri, 12 Jan 2024 05:47:41 +0100
Message-Id: <20240112044743.2254211-3-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240112044743.2254211-1-hch@lst.de>
References: <20240112044743.2254211-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

fs_topology is a mess that mixes up data and RT device reporting,
and to make things worse reuses lsectorsize for the logical sector
size while other parts of xfsprogs use it for the log sector size.

Split out a device_topology structure that reports the topology for
one device and embedded two of them into the fs_topology struture.
Rename the sector size members to be more explicit, and move some
of the sanity checking from mkfs into the topology helpers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/topology.c | 61 ++++++++++++++++++++++++++++----------------
 libxfs/topology.h | 14 +++++++----
 mkfs/xfs_mkfs.c   | 64 +++++++++++++++++++++--------------------------
 repair/sb.c       |  2 +-
 4 files changed, 78 insertions(+), 63 deletions(-)

diff --git a/libxfs/topology.c b/libxfs/topology.c
index 06013d429..227f8c44f 100644
--- a/libxfs/topology.c
+++ b/libxfs/topology.c
@@ -286,47 +286,64 @@ static void blkid_get_topology(
 
 #endif /* ENABLE_BLKID */
 
-void
-get_topology(
-	struct libxfs_init	*xi,
-	struct fs_topology	*ft,
+static void
+get_device_topology(
+	struct libxfs_dev	*dev,
+	struct device_topology	*dt,
 	int			force_overwrite)
 {
-	struct stat statbuf;
+	struct stat		st;
+
+	/*
+	 * Nothing to do if this particular subvolume doesn't exist.
+	 */
+	if (!dev->name)
+		return;
 
 	/*
 	 * If our target is a regular file, use platform_findsizes
 	 * to try to obtain the underlying filesystem's requirements
 	 * for direct IO; we'll set our sector size to that if possible.
 	 */
-	if (xi->data.isfile ||
-	    (!stat(xi->data.name, &statbuf) && S_ISREG(statbuf.st_mode))) {
-		int fd;
+	if (dev->isfile || (!stat(dev->name, &st) && S_ISREG(st.st_mode))) {
 		int flags = O_RDONLY;
 		long long dummy;
+		int fd;
 
 		/* with xi->disfile we may not have the file yet! */
-		if (xi->data.isfile)
+		if (dev->isfile)
 			flags |= O_CREAT;
 
-		fd = open(xi->data.name, flags, 0666);
+		fd = open(dev->name, flags, 0666);
 		if (fd >= 0) {
-			platform_findsizes(xi->data.name, fd, &dummy,
-					&ft->lsectorsize);
+			platform_findsizes(dev->name, fd, &dummy,
+					&dt->logical_sector_size);
 			close(fd);
-			ft->psectorsize = ft->lsectorsize;
-		} else
-			ft->psectorsize = ft->lsectorsize = BBSIZE;
+		} else {
+			dt->logical_sector_size = BBSIZE;
+		}
 	} else {
-		blkid_get_topology(xi->data.name, &ft->dsunit, &ft->dswidth,
-				   &ft->lsectorsize, &ft->psectorsize,
+		blkid_get_topology(dev->name, &dt->sunit, &dt->swidth,
+				   &dt->logical_sector_size,
+				   &dt->physical_sector_size,
 				   force_overwrite);
 	}
 
-	if (xi->rt.name && !xi->rt.isfile) {
-		int sunit, lsectorsize, psectorsize;
+	ASSERT(dt->logical_sector_size);
 
-		blkid_get_topology(xi->rt.name, &sunit, &ft->rtswidth,
-				   &lsectorsize, &psectorsize, force_overwrite);
-	}
+	/*
+	 * Older kernels may not have physical/logical distinction.
+	 */
+	if (!dt->physical_sector_size)
+		dt->physical_sector_size = dt->logical_sector_size;
+}
+
+void
+get_topology(
+	struct libxfs_init	*xi,
+	struct fs_topology	*ft,
+	int			force_overwrite)
+{
+	get_device_topology(&xi->data, &ft->data, force_overwrite);
+	get_device_topology(&xi->rt, &ft->rt, force_overwrite);
 }
diff --git a/libxfs/topology.h b/libxfs/topology.h
index 3a309a4da..ba0c8f669 100644
--- a/libxfs/topology.h
+++ b/libxfs/topology.h
@@ -10,12 +10,16 @@
 /*
  * Device topology information.
  */
+struct device_topology {
+	int	logical_sector_size;	/* logical sector size */
+	int	physical_sector_size;	/* physical sector size */
+	int	sunit;		/* stripe unit */
+	int	swidth;		/* stripe width  */
+};
+
 struct fs_topology {
-	int	dsunit;		/* stripe unit - data subvolume */
-	int	dswidth;	/* stripe width - data subvolume */
-	int	rtswidth;	/* stripe width - rt subvolume */
-	int	lsectorsize;	/* logical sector size &*/
-	int	psectorsize;	/* physical sector size */
+	struct device_topology	data;
+	struct device_topology	rt;
 };
 
 void
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index fcbf54132..be65ccc1e 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -1986,31 +1986,24 @@ validate_sectorsize(
 		 * than that, then we can use logical, but warn about the
 		 * inefficiency.
 		 *
-		 * Set the topology sectors if they were not probed to the
-		 * minimum supported sector size.
-		 */
-		if (!ft->lsectorsize)
-			ft->lsectorsize = dft->sectorsize;
-
-		/*
-		 * Older kernels may not have physical/logical distinction.
-		 *
 		 * Some architectures have a page size > XFS_MAX_SECTORSIZE.
 		 * In that case, a ramdisk or persistent memory device may
 		 * advertise a physical sector size that is too big to use.
 		 */
-		if (!ft->psectorsize || ft->psectorsize > XFS_MAX_SECTORSIZE)
-			ft->psectorsize = ft->lsectorsize;
+		if (ft->data.physical_sector_size > XFS_MAX_SECTORSIZE) {
+			ft->data.physical_sector_size =
+				ft->data.logical_sector_size;
+		}
 
-		cfg->sectorsize = ft->psectorsize;
+		cfg->sectorsize = ft->data.physical_sector_size;
 		if (cfg->blocksize < cfg->sectorsize &&
-		    cfg->blocksize >= ft->lsectorsize) {
+		    cfg->blocksize >= ft->data.logical_sector_size) {
 			fprintf(stderr,
 _("specified blocksize %d is less than device physical sector size %d\n"
   "switching to logical sector size %d\n"),
-				cfg->blocksize, ft->psectorsize,
-				ft->lsectorsize);
-			cfg->sectorsize = ft->lsectorsize;
+				cfg->blocksize, ft->data.physical_sector_size,
+				ft->data.logical_sector_size);
+			cfg->sectorsize = ft->data.logical_sector_size;
 		}
 	} else
 		cfg->sectorsize = cli->sectorsize;
@@ -2031,9 +2024,9 @@ _("block size %d cannot be smaller than sector size %d\n"),
 		usage();
 	}
 
-	if (cfg->sectorsize < ft->lsectorsize) {
+	if (cfg->sectorsize < ft->data.logical_sector_size) {
 		fprintf(stderr, _("illegal sector size %d; hw sector is %d\n"),
-			cfg->sectorsize, ft->lsectorsize);
+			cfg->sectorsize, ft->data.logical_sector_size);
 		usage();
 	}
 }
@@ -2455,7 +2448,7 @@ validate_rtextsize(
 
 		if (!cfg->sb_feat.nortalign && !cli->xi->rt.isfile &&
 		    !(!cli->rtsize && cli->xi->data.isfile))
-			rswidth = ft->rtswidth;
+			rswidth = ft->rt.swidth;
 		else
 			rswidth = 0;
 
@@ -2700,13 +2693,14 @@ _("data stripe width (%lld) is too large of a multiple of the data stripe unit (
 	/* if no stripe config set, use the device default */
 	if (!dsunit) {
 		/* Ignore nonsense from device report. */
-		if (!libxfs_validate_stripe_geometry(NULL, BBTOB(ft->dsunit),
-				BBTOB(ft->dswidth), 0, true)) {
+		if (!libxfs_validate_stripe_geometry(NULL, BBTOB(ft->data.sunit),
+				BBTOB(ft->data.swidth), 0, true)) {
 			fprintf(stderr,
 _("%s: Volume reports invalid stripe unit (%d) and stripe width (%d), ignoring.\n"),
-				progname, BBTOB(ft->dsunit), BBTOB(ft->dswidth));
-			ft->dsunit = 0;
-			ft->dswidth = 0;
+				progname,
+				BBTOB(ft->data.sunit), BBTOB(ft->data.swidth));
+			ft->data.sunit = 0;
+			ft->data.swidth = 0;
 		} else if (cfg->dblocks < GIGABYTES(1, cfg->blocklog)) {
 			/*
 			 * Don't use automatic stripe detection if the device
@@ -2714,29 +2708,29 @@ _("%s: Volume reports invalid stripe unit (%d) and stripe width (%d), ignoring.\
 			 * on such a small system are not worth the risk that
 			 * we'll end up with an undersized log.
 			 */
-			if (ft->dsunit || ft->dswidth)
+			if (ft->data.sunit || ft->data.swidth)
 				fprintf(stderr,
 _("%s: small data volume, ignoring data volume stripe unit %d and stripe width %d\n"),
-						progname, ft->dsunit,
-						ft->dswidth);
-			ft->dsunit = 0;
-			ft->dswidth = 0;
+						progname, ft->data.sunit,
+						ft->data.swidth);
+			ft->data.sunit = 0;
+			ft->data.swidth = 0;
 		} else {
-			dsunit = ft->dsunit;
-			dswidth = ft->dswidth;
+			dsunit = ft->data.sunit;
+			dswidth = ft->data.swidth;
 			use_dev = true;
 		}
 	} else {
 		/* check and warn if user-specified alignment is sub-optimal */
-		if (ft->dsunit && ft->dsunit != dsunit) {
+		if (ft->data.sunit && ft->data.sunit != dsunit) {
 			fprintf(stderr,
 _("%s: Specified data stripe unit %d is not the same as the volume stripe unit %d\n"),
-				progname, dsunit, ft->dsunit);
+				progname, dsunit, ft->data.sunit);
 		}
-		if (ft->dswidth && ft->dswidth != dswidth) {
+		if (ft->data.swidth && ft->data.swidth != dswidth) {
 			fprintf(stderr,
 _("%s: Specified data stripe width %d is not the same as the volume stripe width %d\n"),
-				progname, dswidth, ft->dswidth);
+				progname, dswidth, ft->data.swidth);
 		}
 	}
 
diff --git a/repair/sb.c b/repair/sb.c
index dedac53af..02c10d9a5 100644
--- a/repair/sb.c
+++ b/repair/sb.c
@@ -189,7 +189,7 @@ guess_default_geometry(
 	 * Use default block size (2^12)
 	 */
 	blocklog = 12;
-	multidisk = ft.dswidth | ft.dsunit;
+	multidisk = ft.data.swidth | ft.data.sunit;
 	dblocks = x->data.size >> (blocklog - BBSHIFT);
 	calc_default_ag_geometry(blocklog, dblocks, multidisk,
 				 agsize, agcount);
-- 
2.39.2

