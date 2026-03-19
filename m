Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7521310E3
	for <linux-xfs@vger.kernel.org>; Thu, 19 Mar 2026 04:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773895845; cv=none; b=KdLRzuIsn2tg3SchvD3juIkA0uPlMjBhBPdw/EAEsD6eArk1CuW9bJjo3vfUuzCA9osbg64FFWnISazQG+6mS2YpIW5gBQX+yGNx0m3eMP5+mP8lm1GwvtIuuuxIlVQMc1nuDWmmHu2zYMBgNH+YS4dgInly3ih2WygjkH5t2gI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773895845; c=relaxed/simple;
	bh=2C0dotuL6IgvEXshX7ypAKmC0fEJVPOl6sAr3efDtn8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZnBzGP7PTc/k4cFoutwCI9AkcUYLgaLHe+DXaGqt+2Mn+iehu7+ChygZJBkQvtfFxGMzsJD0pyYvHVhKqKFuqmAAbV871EeO8X+E+/MtQmagqWM6GVbDJvs4kqR1jP7RaHvscpVWf8Sc4gWKpIHOxw3j4sCSscsEmCd8ChuLCf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BS4KHdYc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BS4KHdYc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FB8CC19425;
	Thu, 19 Mar 2026 04:50:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773895845;
	bh=2C0dotuL6IgvEXshX7ypAKmC0fEJVPOl6sAr3efDtn8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=BS4KHdYc07qUx0TxmKqnww09pKuJBs6QUgkd9+BtT7QUaauHV6u8+5Khs8MW5b86c
	 kzgjfmvH/p4oCAgzikdR+sFvZgjzVpevuyrsj4Phv5rjCWCSXAYJi6vLMQO11YyjaC
	 Ar2sCgKK1k/eY+WKpNpIl+9yFj+HymiWbU70jQEP8X8BDLEwfp7jZ8ojC01zR5GPYL
	 dKazoZAwramBZH18WTKFRwUsfJwLgNw9IwuvAzpZVgyYGPn5h8n7/m2e6wmcLIgKo6
	 cX9WWUMTdQVTetgvcD/VOavOhw5obwdNOgbSHJXvnz8RxmLnrgl4SJETNaKlKAS8Om
	 BIktGtFrbqUOA==
Date: Wed, 18 Mar 2026 21:50:44 -0700
Subject: [PATCH 20/22] xfs_scrub: drop SCSI_VERIFY code from disk.
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <177389507307.3681140.7579091494209455124.stgit@frogsfrogsfrogs>
In-Reply-To: <177389506832.3681140.14985419190965827651.stgit@frogsfrogsfrogs>
References: <177389506832.3681140.14985419190965827651.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Now that we have a media verification ioctl in the kernel, drop the
SCSI_VERIFY code, which enables us to drop the dependency on sg and
obviates the need to fix some unit-handling bugs in the HDIO_GETGEO
code.

A subsequent patch will enable larger verification IO sizes, which this
old code cannot handle.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 scrub/disk.h            |    2 -
 doc/README-env-vars.txt |    1 
 scrub/disk.c            |  133 -----------------------------------------------
 scrub/read_verify.c     |    5 --
 scrub/xfs_scrub.c       |    1 
 5 files changed, 1 insertion(+), 141 deletions(-)


diff --git a/scrub/disk.h b/scrub/disk.h
index 73c73ab57fb5c7..a9155bf1f75eb4 100644
--- a/scrub/disk.h
+++ b/scrub/disk.h
@@ -6,7 +6,6 @@
 #ifndef XFS_SCRUB_DISK_H_
 #define XFS_SCRUB_DISK_H_
 
-#define DISK_FLAG_SCSI_VERIFY	0x1
 struct disk {
 	struct stat	d_sb;
 	int		d_fd;
@@ -15,7 +14,6 @@ struct disk {
 	unsigned int	d_flags;
 	unsigned int	d_blksize;	/* bytes */
 	uint64_t	d_size;		/* bytes */
-	uint64_t	d_start;	/* bytes */
 };
 
 unsigned int disk_heads(struct disk *disk);
diff --git a/doc/README-env-vars.txt b/doc/README-env-vars.txt
index eec59a82513f36..6862dcad71e217 100644
--- a/doc/README-env-vars.txt
+++ b/doc/README-env-vars.txt
@@ -17,7 +17,6 @@ Known debug tweaks (pass -d and set the environment variable):
 XFS_SCRUB_FORCE_ERROR        -- pretend all metadata is corrupt
 XFS_SCRUB_FORCE_REPAIR       -- repair all metadata even if it's ok
 XFS_SCRUB_NO_KERNEL          -- pretend there is no kernel ioctl
-XFS_SCRUB_NO_SCSI_VERIFY     -- disable SCSI VERIFY (if present)
 XFS_SCRUB_PHASE              -- run only this scrub phase
 XFS_SCRUB_THREADS            -- start exactly this number of threads
 
diff --git a/scrub/disk.c b/scrub/disk.c
index afce801d3f2076..ca37724249e551 100644
--- a/scrub/disk.c
+++ b/scrub/disk.c
@@ -10,8 +10,6 @@
 #include <fcntl.h>
 #include <sys/types.h>
 #include <sys/statvfs.h>
-#include <scsi/sg.h>
-#include <linux/hdreg.h>
 #include "platform_defs.h"
 #include "libfrog/util.h"
 #include "libfrog/paths.h"
@@ -78,113 +76,12 @@ disk_heads(
 	return __disk_heads(disk);
 }
 
-/*
- * Execute a SCSI VERIFY(16) to verify disk contents.
- * For devices that support this command, this can sharply reduce the
- * runtime of the data block verification phase if the storage device's
- * internal bandwidth exceeds its link bandwidth.  However, it only
- * works if we're talking to a raw SCSI device, and only if we trust the
- * firmware.
- */
-#define SENSE_BUF_LEN		64
-#define VERIFY16_CMDLEN	16
-#define VERIFY16_CMD		0x8F
-
-#ifndef SG_FLAG_Q_AT_TAIL
-# define SG_FLAG_Q_AT_TAIL	0x10
-#endif
-static int
-disk_scsi_verify(
-	struct disk		*disk,
-	uint64_t		startblock, /* lba */
-	uint64_t		blockcount) /* lba */
-{
-	struct sg_io_hdr	iohdr;
-	unsigned char		cdb[VERIFY16_CMDLEN];
-	unsigned char		sense[SENSE_BUF_LEN];
-	uint64_t		llba;
-	uint64_t		veri_len = blockcount;
-	int			error;
-
-	assert(!debug_tweak_on("XFS_SCRUB_NO_SCSI_VERIFY"));
-
-	llba = startblock + (disk->d_start >> BBSHIFT);
-
-	/* Borrowed from sg_verify */
-	cdb[0] = VERIFY16_CMD;
-	cdb[1] = 0; /* skip PI, DPO, and byte check. */
-	cdb[2] = (llba >> 56) & 0xff;
-	cdb[3] = (llba >> 48) & 0xff;
-	cdb[4] = (llba >> 40) & 0xff;
-	cdb[5] = (llba >> 32) & 0xff;
-	cdb[6] = (llba >> 24) & 0xff;
-	cdb[7] = (llba >> 16) & 0xff;
-	cdb[8] = (llba >> 8) & 0xff;
-	cdb[9] = llba & 0xff;
-	cdb[10] = (veri_len >> 24) & 0xff;
-	cdb[11] = (veri_len >> 16) & 0xff;
-	cdb[12] = (veri_len >> 8) & 0xff;
-	cdb[13] = veri_len & 0xff;
-	cdb[14] = 0;
-	cdb[15] = 0;
-	memset(sense, 0, SENSE_BUF_LEN);
-
-	/* v3 SG_IO */
-	memset(&iohdr, 0, sizeof(iohdr));
-	iohdr.interface_id = 'S';
-	iohdr.dxfer_direction = SG_DXFER_NONE;
-	iohdr.cmdp = cdb;
-	iohdr.cmd_len = VERIFY16_CMDLEN;
-	iohdr.sbp = sense;
-	iohdr.mx_sb_len = SENSE_BUF_LEN;
-	iohdr.flags |= SG_FLAG_Q_AT_TAIL;
-	iohdr.timeout = 30000; /* 30s */
-
-	error = ioctl(disk->d_fd, SG_IO, &iohdr);
-	if (error < 0)
-		return error;
-
-	dbg_printf("VERIFY(16) fd %d lba %"PRIu64" len %"PRIu64" info %x "
-			"status %d masked %d msg %d host %d driver %d "
-			"duration %d resid %d\n",
-			disk->d_fd, startblock, blockcount, iohdr.info,
-			iohdr.status, iohdr.masked_status, iohdr.msg_status,
-			iohdr.host_status, iohdr.driver_status, iohdr.duration,
-			iohdr.resid);
-
-	if (iohdr.info & SG_INFO_CHECK) {
-		dbg_printf("status: msg %x host %x driver %x\n",
-				iohdr.msg_status, iohdr.host_status,
-				iohdr.driver_status);
-		errno = EIO;
-		return -1;
-	}
-
-	return blockcount << BBSHIFT;
-}
-
-/* Test the availability of the kernel scrub ioctl. */
-static bool
-disk_can_scsi_verify(
-	struct disk		*disk)
-{
-	int			error;
-
-	if (debug_tweak_on("XFS_SCRUB_NO_SCSI_VERIFY"))
-		return false;
-
-	error = disk_scsi_verify(disk, 0, 1);
-	return error == 0;
-}
-
 /* Open a disk device and discover its geometry. */
 struct disk *
 disk_open(
 	const char		*pathname)
 {
-	struct hd_geometry	bdgeo;
 	struct disk		*disk;
-	bool			suspicious_disk = false;
 	int			error;
 
 	disk = calloc(1, sizeof(struct disk));
@@ -214,32 +111,11 @@ disk_open(
 		error = ioctl(disk->d_fd, BLKBSZGET, &disk->d_blksize);
 		if (error)
 			disk->d_blksize = 0;
-		error = ioctl(disk->d_fd, HDIO_GETGEO, &bdgeo);
-		if (!error) {
-			/*
-			 * dm devices will pass through ioctls, which means
-			 * we can't use SCSI VERIFY unless the start is 0.
-			 * Most dm devices don't set geometry (unlike scsi
-			 * and nvme) so use a zeroed out CHS to screen them
-			 * out.
-			 */
-			if (bdgeo.start != 0 &&
-			    (unsigned long long)bdgeo.heads * bdgeo.sectors *
-					bdgeo.sectors == 0)
-				suspicious_disk = true;
-			disk->d_start = bdgeo.start << BBSHIFT;
-		} else
-			disk->d_start = 0;
 	} else {
 		disk->d_size = disk->d_sb.st_size;
 		disk->d_blksize = disk->d_sb.st_blksize;
-		disk->d_start = 0;
 	}
 
-	/* Can we issue SCSI VERIFY? */
-	if (!suspicious_disk && disk_can_scsi_verify(disk))
-		disk->d_flags |= DISK_FLAG_SCSI_VERIFY;
-
 	return disk;
 out_close:
 	close(disk->d_fd);
@@ -262,10 +138,6 @@ disk_close(
 	return error;
 }
 
-#define BTOLBAT(d, bytes)	((uint64_t)(bytes) >> (d)->d_lbalog)
-#define LBASIZE(d)		(1ULL << (d)->d_lbalog)
-#define BTOLBA(d, bytes)	(((uint64_t)(bytes) + LBASIZE(d) - 1) >> (d)->d_lbalog)
-
 /* Read-verify an extent of a disk device. */
 ssize_t
 disk_read_verify(
@@ -274,10 +146,5 @@ disk_read_verify(
 	uint64_t		start,
 	uint64_t		length)
 {
-	/* Convert to logical block size. */
-	if (disk->d_flags & DISK_FLAG_SCSI_VERIFY)
-		return disk_scsi_verify(disk, BTOLBAT(disk, start),
-				BTOLBA(disk, length));
-
 	return pread(disk->d_fd, buf, length, start);
 }
diff --git a/scrub/read_verify.c b/scrub/read_verify.c
index 4eb7484317e5ca..6789f5f668b46c 100644
--- a/scrub/read_verify.c
+++ b/scrub/read_verify.c
@@ -27,10 +27,7 @@
  * pool takes care of issuing multiple IOs to the device, if possible.
  */
 
-/*
- * Perform all IO in 32M chunks.  This cannot exceed 65536 sectors
- * because that's the biggest SCSI VERIFY(16) we dare to send.
- */
+/* Perform all verification IO in 32M chunks. */
 #define RVP_IO_MAX_SIZE		(33554432)
 
 /*
diff --git a/scrub/xfs_scrub.c b/scrub/xfs_scrub.c
index b74dc1635141aa..aae24ec83c1c75 100644
--- a/scrub/xfs_scrub.c
+++ b/scrub/xfs_scrub.c
@@ -111,7 +111,6 @@
  * XFS_SCRUB_FORCE_ERROR	-- pretend all metadata is corrupt
  * XFS_SCRUB_FORCE_REPAIR	-- repair all metadata even if it's ok
  * XFS_SCRUB_NO_KERNEL		-- pretend there is no kernel ioctl
- * XFS_SCRUB_NO_SCSI_VERIFY	-- disable SCSI VERIFY (if present)
  * XFS_SCRUB_PHASE		-- run only this scrub phase
  * XFS_SCRUB_THREADS		-- start exactly this number of threads
  * XFS_SCRUB_DISK_ERROR_INTERVAL-- simulate a disk error every this many bytes

