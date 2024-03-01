Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC81C257A
	for <linux-xfs@vger.kernel.org>; Fri,  1 Mar 2024 14:49:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709304547; cv=none; b=ddtxtjr9FtMUEcZR+dEL0xkSmchK8VyI4BpzzcWZH4CMryk42J3EncxFmvLfsH9e1ekVgIZsCHQOWcPJ5ANWDDHPLklwsQFVmkTYWeDZ34/p/1JLzA8THmop5/vshPf4a0OTbasaPwwaO0PtsQi9i/eiqccaFcKLPScnlhVrQrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709304547; c=relaxed/simple;
	bh=dcZogne+o6BIt2oKk7nCUb2fgdkQ0DQrlQv2zEg7AlU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Hx1tRPgNIS0nefy+l5zbBi18GkntqorVDw67DhNX2Vva42l2KbykxFquIOCjjQRH24uPRbE+DajT8553cg1yD+YukOGJ3R5v4SIyI7xqpg828WaD1jJUQ5MR2zpUBpflY0AEn8cfEJfMFk9P0QZsdqfk2LcdWe1C6XKSzsekHK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Ti2K1kVC; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Ti2K1kVC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=dLW0iIMDGwdxSU+EIcV6V97FAa7nKIijKSJZ7Qdza2A=; b=Ti2K1kVCLbuvaWfo36Q7OO6lPW
	FKa5jvY+Ma1OAAe838MD8lzdRkOEVmFI60Y09qoqu4+nZw5cIj1chIMXgnJceQQpNX6mGrbNvnnt8
	l1xYcgSpbmVeVIbSl0gMRD06E+TE4p3qidpagte/JQZ6kAlOLrdd8BS2aCMvynmzutbioWn1mdHin
	N3jZtngF6Il4BcElIKVjpWtxtmraRKRqmu/w2sxyDInQBohwFG8/UJ0+Jx5zwVgrO41dt9+RQux2d
	989bTn7MeAk8vN8ynaNqC5Yj2sKsTao3rydeWktZ3p5FHn1+lrKFp968xqNpXvHtYttelWpqLyrhb
	W20RGM3Q==;
Received: from [206.0.71.28] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rg4C7-00000000ms3-0tWo;
	Fri, 01 Mar 2024 14:49:04 +0000
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH] xfsdump/xfsrestore: don't use O_DIRECT on the RT device
Date: Fri,  1 Mar 2024 07:48:46 -0700
Message-Id: <20240301144846.1147100-2-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240301144846.1147100-1-hch@lst.de>
References: <20240301144846.1147100-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

For undocumented reasons xfsdump and xfsrestore use O_DIRECT for RT
files  On a rt device with 4k sector size this runs into alignment
issues, e.g. xfs/060 fails with this message:

xfsrestore: attempt to write 237568 bytes to dumpdir/large000 at offset 54947844 failed: Invalid argument

Switch to using buffered I/O to match the main device and remove all
the code to align to the minimum direct I/O size and make these
alignment issues go away.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 doc/xfsdump.html  |  1 -
 dump/content.c    | 46 +++++++++-------------------------------------
 restore/content.c | 41 +----------------------------------------
 3 files changed, 10 insertions(+), 78 deletions(-)

diff --git a/doc/xfsdump.html b/doc/xfsdump.html
index efd3890..eec7dac 100644
--- a/doc/xfsdump.html
+++ b/doc/xfsdump.html
@@ -884,7 +884,6 @@ Initialize the mmap files of:
                    <ul>
                    <li> S_IFREG -> <b>restore_reg</b> - restore regular file
                       <ul>
-                      <li>if realtime set O_DIRECT
                       <li>truncate file to bs_size
                       <li>set the bs_xflags for extended attributes
                       <li>set DMAPI fields if necessary
diff --git a/dump/content.c b/dump/content.c
index 9117d39..6462267 100644
--- a/dump/content.c
+++ b/dump/content.c
@@ -4319,15 +4319,8 @@ init_extent_group_context(jdm_fshandle_t *fshandlep,
 			   struct xfs_bstat *statp,
 			   extent_group_context_t *gcp)
 {
-	bool_t isrealtime;
-	int oflags;
 	struct flock fl;
 
-	isrealtime = (bool_t)(statp->bs_xflags & XFS_XFLAG_REALTIME);
-	oflags = O_RDONLY;
-	if (isrealtime) {
-		oflags |= O_DIRECT;
-	}
 	(void)memset((void *)gcp, 0, sizeof(*gcp));
 	gcp->eg_bmap[0].bmv_offset = 0;
 	gcp->eg_bmap[0].bmv_length = -1;
@@ -4336,7 +4329,7 @@ init_extent_group_context(jdm_fshandle_t *fshandlep,
 	gcp->eg_endbmapp = &gcp->eg_bmap[1];
 	gcp->eg_bmapix = 0;
 	gcp->eg_gbmcnt = 0;
-	gcp->eg_fd = jdm_open(fshandlep, statp, oflags);
+	gcp->eg_fd = jdm_open(fshandlep, statp, O_RDONLY);
 	if (gcp->eg_fd < 0) {
 		return RV_ERROR;
 	}
@@ -4387,7 +4380,6 @@ dump_extent_group(drive_t *drivep,
 		   off64_t *bytecntp,
 		   bool_t *cmpltflgp)
 {
-	struct dioattr da;
 	drive_ops_t *dop = drivep->d_opsp;
 	bool_t isrealtime = (bool_t)(statp->bs_xflags
 					&
@@ -4397,18 +4389,6 @@ dump_extent_group(drive_t *drivep,
 	int rval;
 	rv_t rv;
 
-	/*
-	 * Setup realtime I/O size.
-	 */
-	if (isrealtime) {
-		if ((ioctl(gcp->eg_fd, XFS_IOC_DIOINFO, &da) < 0)) {
-			mlog(MLOG_NORMAL | MLOG_WARNING, _(
-			      "dioinfo failed ino %llu\n"),
-			      statp->bs_ino);
-			da.d_miniosz = PGSZ;
-		}
-	}
-
 	/* dump extents until the recommended extent length is achieved
 	 */
 	nextoffset = *nextoffsetp;
@@ -4677,17 +4657,13 @@ dump_extent_group(drive_t *drivep,
 		}
 		assert(extsz > 0);
 
-		/* if the resultant extent would put us over maxcnt,
-		 * shorten it, and round up to the next BBSIZE (round
-		 * upto d_miniosz for realtime).
+		/*
+		 * If the resultant extent would put us over maxcnt,
+		 * shorten it, and round up to the next BBSIZE.
 		 */
 		if (extsz > maxcnt - (bytecnt + sizeof(extenthdr_t))) {
-			int iosz;
+			int iosz = BBSIZE;
 
-			if (isrealtime)
-				iosz = da.d_miniosz;
-			else
-				iosz = BBSIZE;
 			extsz = maxcnt - (bytecnt + sizeof(extenthdr_t));
 			extsz = (extsz + (off64_t)(iosz - 1))
 				&
@@ -4723,18 +4699,14 @@ dump_extent_group(drive_t *drivep,
 			return RV_OK;
 		}
 
-		/* if the resultant extent extends beyond the end of the
+		/*
+		 * If the resultant extent extends beyond the end of the
 		 * file, shorten the extent to the nearest BBSIZE alignment
-		 * at or beyond EOF.  (Shorten to d_miniosz for realtime
-		 * files).
+		 * at or beyond EOF.
 		 */
 		if (extsz > statp->bs_size - offset) {
-			int iosz;
+			int iosz = BBSIZE;
 
-			if (isrealtime)
-				iosz = da.d_miniosz;
-			else
-				iosz = BBSIZE;
 			extsz = statp->bs_size - offset;
 			extsz = (extsz + (off64_t)(iosz - 1))
 				&
diff --git a/restore/content.c b/restore/content.c
index 488ae20..7ec3a4d 100644
--- a/restore/content.c
+++ b/restore/content.c
@@ -7435,7 +7435,6 @@ restore_reg(drive_t *drivep,
 	int rval;
 	struct fsxattr fsxattr;
 	struct stat64 stat;
-	int oflags;
 
 	if (!path)
 		return BOOL_TRUE;
@@ -7470,11 +7469,7 @@ restore_reg(drive_t *drivep,
 	if (tranp->t_toconlypr)
 		return BOOL_TRUE;
 
-	oflags = O_CREAT | O_RDWR;
-	if (persp->a.dstdirisxfspr && bstatp->bs_xflags & XFS_XFLAG_REALTIME)
-		oflags |= O_DIRECT;
-
-	*fdp = open(path, oflags, S_IRUSR | S_IWUSR);
+	*fdp = open(path, O_CREAT | O_RDWR, S_IRUSR | S_IWUSR);
 	if (*fdp < 0) {
 		mlog(MLOG_NORMAL | MLOG_WARNING,
 		      _("open of %s failed: %s: discarding ino %llu\n"),
@@ -8392,8 +8387,6 @@ restore_extent(filehdr_t *fhdrp,
 	off64_t off = ehdrp->eh_offset;
 	off64_t sz = ehdrp->eh_sz;
 	off64_t new_off;
-	struct dioattr da;
-	bool_t isrealtime = BOOL_FALSE;
 
 	*bytesreadp = 0;
 
@@ -8418,18 +8411,6 @@ restore_extent(filehdr_t *fhdrp,
 		}
 		assert(new_off == off);
 	}
-	if ((fd != -1) && (bstatp->bs_xflags & XFS_XFLAG_REALTIME)) {
-		if ((ioctl(fd, XFS_IOC_DIOINFO, &da) < 0)) {
-			mlog(MLOG_NORMAL | MLOG_WARNING, _(
-			      "dioinfo %s failed: "
-			      "%s: discarding ino %llu\n"),
-			      path,
-			      strerror(errno),
-			      fhdrp->fh_stat.bs_ino);
-			fd = -1;
-		} else
-			isrealtime = BOOL_TRUE;
-	}
 
 	/* move from media to fs.
 	 */
@@ -8519,26 +8500,6 @@ restore_extent(filehdr_t *fhdrp,
 					assert(remaining
 						<=
 						(size_t)INTGENMAX);
-					/*
-					 * Realtime files must be written
-					 * to the end of the block even if
-					 * it has been truncated back.
-					 */
-					if (isrealtime &&
-					    (remaining % da.d_miniosz != 0 ||
-					     remaining < da.d_miniosz)) {
-						/*
-						 * Since the ring and static
-						 * buffers from the different
-						 * drives are always large, we
-						 * just need to write to the
-						 * end of the next block
-						 * boundry and truncate.
-						 */
-						rttrunc = remaining;
-						remaining += da.d_miniosz -
-						   (remaining % da.d_miniosz);
-					}
 					/*
 					 * Do the write. Due to delayed allocation
 					 * it's possible to receive false ENOSPC
-- 
2.39.2

