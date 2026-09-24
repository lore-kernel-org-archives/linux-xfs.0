Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9385A405C38
	for <linux-xfs@vger.kernel.org>; Thu, 24 Sep 2026 10:07:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790244450; cv=none; b=oczpsbmxiDWEEZ6hN8xScoQomg4/D8PtlTkJOlKXTBtJpboZPr1662no+BSwWtmbu2VV9aG/CQI+OCW4NSQNEK8IAj1q9rYQEgPPpYynt+3y7QeRPii3OOxDboQ17Ra8Aa5HonrTnPYvQc20dy8yKqFeBvEsbNukulGA/mQr9IM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790244450; c=relaxed/simple;
	bh=rx0A6t8Iydk/EHF4rZ0MUqacgr0fxp7e47QNzH8XoCs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sVpmekbj2JQgKiFzz/+VkShaWjqIkE11G5q4zKO6q93XknhT/oj1fiSbWwvSp1l+Z6dPe3zdn0aKokjRqhxJFr107OXSoK5wb2U6VuKeVFUgAlY900M4QQZULBiL4ln7ah1430aTmc5pd937Uxc7IsFqDMRqoZNb4UF5FljUM/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=kdC4RXUE; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="kdC4RXUE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Wm7tnpxAW4rtvCDsge4xfMM1Hv0Qvk/0InW/B7LffOk=; b=kdC4RXUEIndawxz/LCCqJrLs1y
	jIk0CHNdFHqC7kKJ3sJIeIe3lSsTchb5Dc8BFClMZTPTretMoaSLsE5lVVD5QqAZ8VJKS27CM9srF
	ilSBDmQ/GgP9zDYjWwHtDZFHGQhTAUzxZlnt8tKHqKHXgMHorICgqQsvKeMc6My5ewwblcn7/MeLS
	YpI/0cmYzsgvmYyGKhRQuVRfSUEX16mOT2oP6+arVZ9lrmSXko2EqkR5zJppn4Aac7rK2BlFffXFr
	dC1sCyMSTnQHxMGKbAkIgcMtqag9t6XDHr2ELNO6KxwHA7wCsU35GbAayWLXVbN4EfbVnLe6def+j
	YxaFNMRw==;
Received: from 85-127-111-79.dsl.dynamic.surfer.at ([85.127.111.79] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x9gMG-0000000AfYY-3FjO;
	Thu, 24 Sep 2026 10:07:17 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 29/32] mkfs: support RT data checksums
Date: Thu, 24 Sep 2026 12:04:19 +0200
Message-ID: <20260924100512.2733748-30-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260924100512.2733748-1-hch@lst.de>
References: <20260924100512.2733748-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Parse the -r csum and -r csumbisze options, set the superblock fields
based on that and create the per-RTG csum files when requested.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 man/man8/mkfs.xfs.8.in |  17 ++++++
 mkfs/proto.c           |   9 +++
 mkfs/xfs_mkfs.c        | 126 ++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 149 insertions(+), 3 deletions(-)

diff --git a/man/man8/mkfs.xfs.8.in b/man/man8/mkfs.xfs.8.in
index 927cd075bf8a..b2da1e76f10f 100644
--- a/man/man8/mkfs.xfs.8.in
+++ b/man/man8/mkfs.xfs.8.in
@@ -1315,6 +1315,23 @@ Controls the amount of space in the realtime section that is reserved for
 internal use by garbage collection and reorganization algorithms.
 Defaults to 0 if not set.
 This option is only valid if the zoned realtime allocator is used.
+.TP
+.BI csum= value
+Controls which data checksum is used.
+Valid options are
+.I none
+,
+.I crc32c
+and
+.I crc64.
+Defaults to
+.I none
+if not set.
+This option is only valid if the zoned realtime allocator is used.
+.TP
+.BI csumbsize= value
+Controls the blocksize of the data checksum files.  Valid values are
+32k and 64k.  Defaults to 32k or the filesystem block size if larger.
 .RE
 .PP
 .PD 0
diff --git a/mkfs/proto.c b/mkfs/proto.c
index 7ef8cc9d88a1..c232d1171d44 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -11,6 +11,8 @@
 #include <sys/xattr.h>
 #include <linux/xattr.h>
 #include "libfrog/convert.h"
+#include "libfrog/crc64.h"
+#include "libxfs/xfs_rtcsumfile.h"
 #include "proto.h"
 
 /*
@@ -1221,6 +1223,13 @@ rtinit_groups(
 				fail(_("rtrmap rtsb init failed"), error);
 		}
 
+		if (xfs_has_rtcsum(mp)) {
+			error = xfs_rtcsum_alloc_blocks(rtg);
+			if (error)
+				fail(_("Initialization of rtcsum inode failed"),
+					error);
+		}
+
 		if (!xfs_has_zoned(mp))
 			rtfreesp_init(rtg);
 	}
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 334367b81555..9abeca61ee2a 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -6,15 +6,17 @@
 #include "libfrog/util.h"
 #include "libxfs.h"
 #include <ctype.h>
-#include "libxfs/xfs_zones.h"
 #include "xfs_multidisk.h"
 #include "libxcmd.h"
 #include "libfrog/fsgeom.h"
 #include "libfrog/convert.h"
 #include "libfrog/crc32cselftest.h"
+#include "libfrog/crc64.h"
 #include "libfrog/dahashselftest.h"
 #include "libfrog/fsproperties.h"
 #include "libfrog/zones.h"
+#include "libxfs/xfs_zones.h"
+#include "libxfs/xfs_rtcsumfile.h"
 #include "proto.h"
 #include <ini.h>
 
@@ -145,6 +147,8 @@ enum {
 	R_ZONED,
 	R_START,
 	R_RESERVED,
+	R_CSUM,
+	R_CSUMBSIZE,
 	R_MAX_OPTS,
 };
 
@@ -777,6 +781,8 @@ static struct opt_params ropts = {
 		[R_ZONED] = "zoned",
 		[R_START] = "start",
 		[R_RESERVED] = "reserved",
+		[R_CSUM] = "csum",
+		[R_CSUMBSIZE] = "csumbsize",
 		[R_MAX_OPTS] = NULL,
 	},
 	.subopt_params = {
@@ -864,6 +870,19 @@ static struct opt_params ropts = {
 		  .maxval = LLONG_MAX,
 		  .defaultval = SUBOPT_NEEDS_VAL,
 		},
+		{ .index = R_CSUM,
+		  .conflicts = { { NULL, LAST_CONFLICT } },
+		  .minval = 0,
+		  .maxval = LLONG_MAX,
+		  .defaultval = SUBOPT_NEEDS_VAL,
+		},
+		{ .index = R_CSUMBSIZE,
+		  .conflicts = { { NULL, LAST_CONFLICT } },
+		  .convert = true,
+		  .minval = 1u << XFS_RTCSUM_BSIZE_LOG_MIN,
+		  .maxval = 1u << XFS_RTCSUM_BSIZE_LOG_MAX,
+		  .defaultval = SUBOPT_NEEDS_VAL,
+		},
 	},
 };
 
@@ -1074,6 +1093,8 @@ struct sb_feat_args {
 	bool	exchrange;		/* XFS_SB_FEAT_INCOMPAT_EXCHRANGE */
 	bool	zoned;
 	bool	zone_gaps;
+	uint8_t	rtcsum_type;
+	uint8_t	rtcsum_blklog;
 
 	uint16_t qflags;
 };
@@ -1102,6 +1123,7 @@ struct cli_params {
 	char	*rtstart;
 	uint64_t rtreserved;
 	char	*max_atomic_write;
+	char	*rtcsumbsize;
 
 	/* parameters where 0 is a valid CLI value */
 	int	dsunit;
@@ -1191,6 +1213,7 @@ struct mkfs_params {
 	struct sb_feat_args	sb_feat;
 	uint64_t	rtstart;
 	uint64_t	rtreserved;
+	uint32_t	rtcsumbsize;
 
 	uint64_t	max_atomic_write;
 };
@@ -1229,7 +1252,8 @@ usage( void )
 			    pquota|pqnoenforce]\n\
 /* data subvol */	[-d agcount=n,agsize=n,file,name=xxx,size=num,\n\
 			    (sunit=value,swidth=value|su=num,sw=num|noalign),\n\
-			    sectsize=num,concurrency=num]\n\
+			    sectsize=num,concurrency=num,\n\
+			    csum=type]\n\
 /* force overwrite */	[-f]\n\
 /* inode size */	[-i perblock=n|size=num,maxpct=n,attr=0|1|2,\n\
 			    projid32bit=0|1,sparse=0|1,nrext64=0|1,\n\
@@ -1245,7 +1269,8 @@ usage( void )
 /* populate from directory */	[-p dirname,atime=0|1]\n\
 /* quiet */		[-q]\n\
 /* realtime subvol */	[-r extsize=num,size=num,rtdev=xxx,rgcount=n,rgsize=n,\n\
-			    concurrency=num,zoned=0|1,start=n,reserved=n]\n\
+			    concurrency=num,zoned=0|1,start=n,reserved=n,\n\
+			    csum=type],csumbsize=n\n\
 /* sectorsize */	[-s size=num]\n\
 /* version */		[-V]\n\
 			devicename\n\
@@ -1858,6 +1883,24 @@ set_data_concurrency(
 		cli->data_concurrency = optnum;
 }
 
+static bool
+set_data_csum(
+	const char		*value,
+	uint8_t			*csum_val)
+{
+	if (!value)
+		return false;
+	if (!strcmp(value, "none"))
+		*csum_val = XFS_CSUM_TYPE_NONE;
+	else if (!strcmp(value, "crc32c"))
+		*csum_val = XFS_CSUM_TYPE_CRC32C;
+	else if (!strcmp(value, "crc64"))
+		*csum_val = XFS_CSUM_TYPE_CRC64;
+	else
+		return false;
+	return true;
+}
+
 static int
 data_opts_parser(
 	struct opt_params	*opts,
@@ -2269,6 +2312,13 @@ rtdev_opts_parser(
 	case R_RESERVED:
 		cli->rtreserved = getnum(value, opts, subopt);
 		break;
+	case R_CSUM:
+		if (!set_data_csum(value, &cli->sb_feat.rtcsum_type))
+			return -EINVAL;
+		break;
+	case R_CSUMBSIZE:
+		cli->rtcsumbsize = getstr(value, opts, subopt);
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -3048,6 +3098,11 @@ _("internal RT section only supported in zoned mode\n"));
 _("reserved RT blocks only supported in zoned mode\n"));
 			usage();
 		}
+		if (cli->sb_feat.rtcsum_type || cli->sb_feat.rtcsum_blklog) {
+			fprintf(stderr,
+_("data checksums not supported without zoned mode\n"));
+			usage();
+		}
 	}
 
 	if (cli->xi->rt.name || cfg->rtstart) {
@@ -4921,6 +4976,11 @@ sb_set_features(
 	}
 	if (fp->zone_gaps)
 		sbp->sb_features_incompat |= XFS_SB_FEAT_INCOMPAT_ZONE_GAPS;
+	if (fp->rtcsum_type) {
+		sbp->sb_features_ro_compat |= XFS_SB_FEAT_RO_COMPAT_RTCSUM;
+		sbp->sb_rtcsum_type = fp->rtcsum_type;
+		sbp->sb_rtcsum_blklog = fp->rtcsum_blklog;
+	}
 }
 
 /*
@@ -5243,6 +5303,63 @@ validate_max_atomic_write_ags(
 	}
 }
 
+static void
+validate_rtcsumbsize(
+	struct mkfs_params	*cfg,
+	struct cli_params	*cli,
+	struct xfs_mount	*mp)
+{
+	unsigned int		l;
+
+	if (!cli->sb_feat.rtcsum_type) {
+		if (cli->rtcsumbsize) {
+			fprintf(stderr,
+ _("RT data csum block size options requires RT data csum type.\n"));
+			exit(1);
+		}
+		return;
+	}
+
+	if (!cfg->sb_feat.zoned) {
+		fprintf(stderr,
+ _("RT data checksums require a zoned RT subvolume\n"));
+		exit(1);
+	}
+
+	if (cli->rtcsumbsize) {
+		cfg->rtcsumbsize =
+			 getnum(cli->rtcsumbsize, &ropts, R_CSUMBSIZE);
+	} else {
+		cfg->rtcsumbsize =
+			 max(1u << XFS_RTCSUM_BSIZE_LOG_MIN, cfg->blocksize);
+	}
+
+	if (!is_power_of_2(cfg->rtcsumbsize)) {
+		fprintf(stderr,
+ _("RT data csum block size of %u bytes is not a power of 2\n"),
+			cfg->rtcsumbsize);
+		exit(1);
+	}
+
+	if (cfg->rtcsumbsize < cfg->blocksize) {
+		fprintf(stderr,
+ _("RT data csum block size of %u bytes is smaller than fsblock size %u.\n"),
+			cfg->rtcsumbsize, cfg->blocksize);
+		exit(1);
+	}
+
+	if (cfg->rtcsumbsize % cfg->blocksize) {
+		fprintf(stderr,
+ _("RT data csum block size of %u bytes not aligned with fsblock size %u.\n"),
+			cfg->rtcsumbsize, cfg->blocksize);
+		exit(1);
+	}
+
+	cfg->sb_feat.rtcsum_blklog = 0;
+	for (l = cfg->rtcsumbsize; l > 1; l >>= 1)
+		cfg->sb_feat.rtcsum_blklog++;
+}
+
 static void
 calculate_log_size(
 	struct mkfs_params	*cfg,
@@ -5523,6 +5640,8 @@ finish_superblock_setup(
 	sbp->sb_unit = cfg->dsunit;
 	sbp->sb_width = cfg->dswidth;
 	mp->m_features |= libxfs_sb_version_to_features(sbp);
+	mp->m_rtcsum_shift = xfs_data_csum_shift(mp->m_sb.sb_rtcsum_type);
+	mp->m_rtcsum_bsize = 1u << mp->m_sb.sb_rtcsum_blklog;
 	libxfs_sb_mount_rextsize(mp, sbp);
 }
 
@@ -6290,6 +6409,7 @@ main(
 	validate_datadev(&cfg, &cli);
 	validate_logdev(&cfg, &cli);
 	validate_rtdev(&cfg, &cli, &zt);
+	validate_rtcsumbsize(&cfg, &cli, mp);
 	calc_stripe_factors(&cfg, &cli, &ft);
 
 	/*
-- 
2.53.0

