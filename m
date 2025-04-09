Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0ADC25A2CA
	for <linux-xfs@vger.kernel.org>; Wed,  9 Apr 2025 07:58:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744185485; cv=none; b=Qwi9jnE52jex38zF1wrek1izl/QwTqZQY0z6hscG0EsJkzSSOab3YFP4IEgAf/GU6awq/0NUs1SozVYgaZr3V/yPgza/NsNbGs/MlV1ztHS8FTyKp9U0DsBdCUqoYlPjzReXrcMI9wCI82norrF7zBdts9H37X/g4QTxaeE8Q+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744185485; c=relaxed/simple;
	bh=1yiMOeYJk24IlE0mHMYnRvEWU2AzamlNeAWku0p1GOk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=H01RzhPAjTw7kTdTs908zMdxX/bSoaTecewsW0vFbCi9AVaErjbC2SVLqYUbFoxZJbcx+5m9/1SIucyEypXXnApjC6oYTQ+2jtV6pkngn0MfrzFWwTMasV6DMXfhPYKaUxvtdDHb25Xcn/0szTJEM/OZ9MsdOVNES0rRZU/JCog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=fFyT5nyx; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="fFyT5nyx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:
	To:From:Sender:Reply-To:Content-ID:Content-Description;
	bh=fOtvV8GSVXMIsq+FDE48eLr307gShFKVzr13IOJ9nkY=; b=fFyT5nyxjSLt1nZBjD5OBUy0bF
	wCPsS7CeJ6uUGxynoDVgxXH2ahNwU5WGmNgf2MoPLvefx+m/augpFYyAY1CQkiG7VSAd+Hg60uaVC
	FgSl7jL4VIFVpKsvoT379MExB9smYEYD/gM6CM/gQhrbbURI3cpBoih44RZHFEEFCYZk2/LcQqlt7
	RaBEYO45/7oBnG5+ha/vxNkE3f2fQpZKIw+3m5sWWPuPbjtsDKKzRDf3oBh7PX4kiPRZ+M3OiOxz7
	2a6QQi+B7OVntasJQN6NQvggv0sIV20bZ3oSVGxpJtCbADtQSp1AiOQZwNDqwdluGuyWSgFbr8gbj
	4ZGvxoTg==;
Received: from 2a02-8389-2341-5b80-08b8-afb4-7bb0-fe1c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:8b8:afb4:7bb0:fe1c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1u2QJt-00000006UdQ-1DVN;
	Wed, 09 Apr 2025 07:58:02 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 30/45] xfs_mkfs: support creating zoned file systems
Date: Wed,  9 Apr 2025 09:55:33 +0200
Message-ID: <20250409075557.3535745-31-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250409075557.3535745-1-hch@lst.de>
References: <20250409075557.3535745-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Default to use all sequential write required zoned for the RT device.

Default to 256 and 1% conventional when -r zoned is specified without
further option.  This mimics a SMR HDD and works well with tests.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/init.c     |   2 +-
 mkfs/proto.c      |   3 +-
 mkfs/xfs_mkfs.c   | 553 ++++++++++++++++++++++++++++++++++++++++++----
 repair/agheader.c |   2 +-
 4 files changed, 518 insertions(+), 42 deletions(-)

diff --git a/libxfs/init.c b/libxfs/init.c
index a186369f3fd8..393a94673f7e 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -251,7 +251,7 @@ libxfs_close_devices(
 		libxfs_device_close(&li->data);
 	if (li->log.dev && li->log.dev != li->data.dev)
 		libxfs_device_close(&li->log);
-	if (li->rt.dev)
+	if (li->rt.dev && li->rt.dev != li->data.dev)
 		libxfs_device_close(&li->rt);
 }
 
diff --git a/mkfs/proto.c b/mkfs/proto.c
index 7f56a3d82a06..7f80bef838be 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -1144,7 +1144,8 @@ rtinit_groups(
 				fail(_("rtrmap rtsb init failed"), error);
 		}
 
-		rtfreesp_init(rtg);
+		if (!xfs_has_zoned(mp))
+			rtfreesp_init(rtg);
 	}
 }
 
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 39e3349205fb..133ede8d8483 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -6,6 +6,8 @@
 #include "libfrog/util.h"
 #include "libxfs.h"
 #include <ctype.h>
+#include <linux/blkzoned.h>
+#include "libxfs/xfs_zones.h"
 #include "xfs_multidisk.h"
 #include "libxcmd.h"
 #include "libfrog/fsgeom.h"
@@ -135,6 +137,9 @@ enum {
 	R_RGCOUNT,
 	R_RGSIZE,
 	R_CONCURRENCY,
+	R_ZONED,
+	R_START,
+	R_RESERVED,
 	R_MAX_OPTS,
 };
 
@@ -739,6 +744,9 @@ static struct opt_params ropts = {
 		[R_RGCOUNT] = "rgcount",
 		[R_RGSIZE] = "rgsize",
 		[R_CONCURRENCY] = "concurrency",
+		[R_ZONED] = "zoned",
+		[R_START] = "start",
+		[R_RESERVED] = "reserved",
 		[R_MAX_OPTS] = NULL,
 	},
 	.subopt_params = {
@@ -804,6 +812,28 @@ static struct opt_params ropts = {
 		  .maxval = INT_MAX,
 		  .defaultval = 1,
 		},
+		{ .index = R_ZONED,
+		  .conflicts = { { &ropts, R_EXTSIZE },
+				 { NULL, LAST_CONFLICT } },
+		  .minval = 0,
+		  .maxval = 1,
+		  .defaultval = 1,
+		},
+		{ .index = R_START,
+		  .conflicts = { { &ropts, R_DEV },
+				 { NULL, LAST_CONFLICT } },
+		  .convert = true,
+		  .minval = 0,
+		  .maxval = LLONG_MAX,
+		  .defaultval = SUBOPT_NEEDS_VAL,
+		},
+		{ .index = R_RESERVED,
+		  .conflicts = { { NULL, LAST_CONFLICT } },
+		  .convert = true,
+		  .minval = 0,
+		  .maxval = LLONG_MAX,
+		  .defaultval = SUBOPT_NEEDS_VAL,
+		},
 	},
 };
 
@@ -1012,6 +1042,8 @@ struct sb_feat_args {
 	bool	nortalign;
 	bool	nrext64;
 	bool	exchrange;		/* XFS_SB_FEAT_INCOMPAT_EXCHRANGE */
+	bool	zoned;
+	bool	zone_gaps;
 
 	uint16_t qflags;
 };
@@ -1035,6 +1067,8 @@ struct cli_params {
 	char	*lsu;
 	char	*rtextsize;
 	char	*rtsize;
+	char	*rtstart;
+	uint64_t rtreserved;
 
 	/* parameters where 0 is a valid CLI value */
 	int	dsunit;
@@ -1121,6 +1155,8 @@ struct mkfs_params {
 	char		*label;
 
 	struct sb_feat_args	sb_feat;
+	uint64_t	rtstart;
+	uint64_t	rtreserved;
 };
 
 /*
@@ -1172,7 +1208,7 @@ usage( void )
 /* prototype file */	[-p fname]\n\
 /* quiet */		[-q]\n\
 /* realtime subvol */	[-r extsize=num,size=num,rtdev=xxx,rgcount=n,rgsize=n,\n\
-			    concurrency=num]\n\
+			    concurrency=num,zoned=0|1,start=n,reserved=n]\n\
 /* sectorsize */	[-s size=num]\n\
 /* version */		[-V]\n\
 			devicename\n\
@@ -1539,6 +1575,30 @@ discard_blocks(int fd, uint64_t nsectors, int quiet)
 		printf("Done.\n");
 }
 
+static void
+reset_zones(struct mkfs_params *cfg, int fd, uint64_t start_sector,
+		uint64_t nsectors, int quiet)
+{
+	struct blk_zone_range range = {
+		.sector		= start_sector,
+		.nr_sectors	= nsectors,
+	};
+
+	if (!quiet) {
+		printf("Resetting zones...");
+		fflush(stdout);
+	}
+
+	if (ioctl(fd, BLKRESETZONE, &range) < 0) {
+		if (!quiet)
+			printf(" FAILED\n");
+		exit(1);
+	}
+
+	if (!quiet)
+		printf("Done.\n");
+}
+
 static __attribute__((noreturn)) void
 illegal_option(
 	const char		*value,
@@ -2144,6 +2204,15 @@ rtdev_opts_parser(
 	case R_CONCURRENCY:
 		set_rtvol_concurrency(opts, subopt, cli, value);
 		break;
+	case R_ZONED:
+		cli->sb_feat.zoned = getnum(value, opts, subopt);
+		break;
+	case R_START:
+		cli->rtstart = getstr(value, opts, subopt);
+		break;
+	case R_RESERVED:
+		cli->rtreserved = getnum(value, opts, subopt);
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -2445,7 +2514,208 @@ _("Version 1 logs do not support sector size %d\n"),
 _("log stripe unit specified, using v2 logs\n"));
 		cli->sb_feat.log_version = 2;
 	}
+}
+
+struct zone_info {
+	/* number of zones, conventional or sequential */
+	unsigned int		nr_zones;
+	/* number of conventional zones */
+	unsigned int		nr_conv_zones;
+
+	/* size of the address space for a zone, in 512b blocks */
+	xfs_daddr_t		zone_size;
+	/* write capacity of a zone, in 512b blocks */
+	xfs_daddr_t		zone_capacity;
+};
 
+struct zone_topology {
+	struct zone_info	data;
+	struct zone_info	rt;
+	struct zone_info	log;
+};
+
+/* random size that allows efficient processing */
+#define ZONES_PER_IOCTL			16384
+
+static int report_zones(const char *name, struct zone_info *zi)
+{
+	struct blk_zone_report *rep;
+	size_t rep_size;
+	struct stat st;
+	unsigned int i, n = 0;
+	uint64_t device_size;
+	uint64_t sector = 0;
+	bool found_seq = false;
+	int ret = 0;
+	int fd;
+
+	fd = open(name, O_RDONLY);
+	if (fd < 0)
+		return -EIO;
+
+	if (fstat(fd, &st) < 0) {
+		ret = -EIO;
+		goto out_close;
+	}
+        if (!S_ISBLK(st.st_mode))
+		goto out_close;
+
+	if (ioctl(fd, BLKGETSIZE64, &device_size)) {
+		ret = -EIO;
+		goto out_close;
+	}
+	if (ioctl(fd, BLKGETZONESZ, &zi->zone_size) || !zi->zone_size)
+		goto out_close; /* not zoned */
+
+	device_size /= 512; /* BLKGETSIZE64 reports a byte value */
+	zi->nr_zones = device_size / zi->zone_size;
+	zi->nr_conv_zones = 0;
+
+	rep_size = sizeof(struct blk_zone_report) +
+		   sizeof(struct blk_zone) * ZONES_PER_IOCTL;
+	rep = malloc(rep_size);
+	if (!rep) {
+		ret = -ENOMEM;
+		goto out_close;
+	}
+
+	while (n < zi->nr_zones) {
+		struct blk_zone *zones = (struct blk_zone *)(rep + 1);
+
+		memset(rep, 0, rep_size);
+		rep->sector = sector;
+		rep->nr_zones = ZONES_PER_IOCTL;
+
+		ret = ioctl(fd, BLKREPORTZONE, rep);
+		if (ret) {
+			fprintf(stderr,
+_("ioctl(BLKREPORTZONE) failed: %d!\n"), ret);
+			goto out_free;
+		}
+		if (!rep->nr_zones)
+			break;
+
+		for (i = 0; i < rep->nr_zones; i++) {
+			if (n >= zi->nr_zones)
+				break;
+
+			if (zones[i].len != zi->zone_size) {
+				fprintf(stderr,
+_("Inconsistent zone size!\n"));
+				ret = -EIO;
+				goto out_free;
+			}
+
+			switch (zones[i].type) {
+			case BLK_ZONE_TYPE_CONVENTIONAL:
+				/*
+				 * We can only use the conventional space at the
+				 * start of the device for metadata, so don't
+				 * count later conventional zones.  This is
+				 * not an error because we can use them for data
+				 * just fine.
+				 */
+				if (!found_seq)
+					zi->nr_conv_zones++;
+				break;
+			case BLK_ZONE_TYPE_SEQWRITE_REQ:
+				found_seq = true;
+				break;
+			case BLK_ZONE_TYPE_SEQWRITE_PREF:
+				fprintf(stderr,
+_("Sequential write preferred zones not supported.\n"));
+				ret = -EIO;
+				goto out_free;
+			default:
+				fprintf(stderr,
+_("Unknown zone type (0x%x) found.\n"), zones[i].type);
+				ret = -EIO;
+				goto out_free;
+			}
+
+			if (!n) {
+				zi->zone_capacity = zones[i].capacity;
+				if (zi->zone_capacity > zi->zone_size) {
+					fprintf(stderr,
+_("Zone capacity larger than zone size!\n"));
+					ret = -EIO;
+					goto out_free;
+				}
+			} else if (zones[i].capacity != zi->zone_capacity) {
+				fprintf(stderr,
+_("Inconsistent zone capacity!\n"));
+				ret = -EIO;
+				goto out_free;
+			}
+
+			n++;
+		}
+		sector = zones[rep->nr_zones - 1].start +
+			 zones[rep->nr_zones - 1].len;
+	}
+
+out_free:
+	free(rep);
+out_close:
+	close(fd);
+	return ret;
+}
+
+static void
+validate_zoned(
+	struct mkfs_params	*cfg,
+	struct cli_params	*cli,
+	struct mkfs_default_params *dft,
+	struct zone_topology	*zt)
+{
+	if (!cli->xi->data.isfile) {
+		report_zones(cli->xi->data.name, &zt->data);
+		if (zt->data.nr_zones) {
+			if (!zt->data.nr_conv_zones) {
+				fprintf(stderr,
+_("Data devices requires conventional zones.\n"));
+				usage();
+			}
+			if (zt->data.zone_capacity != zt->data.zone_size) {
+				fprintf(stderr,
+_("Zone capacity equal to Zone size required for conventional zones.\n"));
+				usage();
+			}
+
+			cli->sb_feat.zoned = true;
+			cfg->rtstart =
+				zt->data.nr_conv_zones * zt->data.zone_capacity;
+		}
+	}
+
+	if (cli->xi->rt.name && !cli->xi->rt.isfile) {
+		report_zones(cli->xi->rt.name, &zt->rt);
+		if (zt->rt.nr_zones && !cli->sb_feat.zoned)
+			cli->sb_feat.zoned = true;
+		if (zt->rt.zone_size != zt->rt.zone_capacity)
+			cli->sb_feat.zone_gaps = true;
+	}
+
+	if (cli->xi->log.name && !cli->xi->log.isfile) {
+		report_zones(cli->xi->log.name, &zt->log);
+		if (zt->log.nr_zones) {
+			fprintf(stderr,
+_("Zoned devices not supported as log device!\n"));
+			usage();
+		}
+	}
+
+	if (cli->rtstart) {
+		if (cfg->rtstart) {
+			fprintf(stderr,
+_("rtstart override not allowed on zoned devices.\n"));
+			usage();
+		}
+		cfg->rtstart = getnum(cli->rtstart, &ropts, R_START) / 512;
+	}
+
+	if (cli->rtreserved)
+		cfg->rtreserved = cli->rtreserved;
 }
 
 /*
@@ -2670,7 +2940,37 @@ _("inode btree counters not supported without finobt support\n"));
 		cli->sb_feat.inobtcnt = false;
 	}
 
-	if (cli->xi->rt.name) {
+	if (cli->sb_feat.zoned) {
+		if (!cli->sb_feat.metadir) {
+			if (cli_opt_set(&mopts, M_METADIR)) {
+				fprintf(stderr,
+_("zoned realtime device not supported without metadir support\n"));
+				usage();
+			}
+			cli->sb_feat.metadir = true;
+		}
+		if (cli->rtextsize) {
+			if (cli_opt_set(&ropts, R_EXTSIZE)) {
+				fprintf(stderr,
+_("rt extent size not supported on realtime devices with zoned mode\n"));
+				usage();
+			}
+			cli->rtextsize = 0;
+		}
+	} else {
+		if (cli->rtstart) {
+			fprintf(stderr,
+_("internal RT section only supported in zoned mode\n"));
+			usage();
+		}
+		if (cli->rtreserved) {
+			fprintf(stderr,
+_("reserved RT blocks only supported in zoned mode\n"));
+			usage();
+		}
+	}
+
+	if (cli->xi->rt.name || cfg->rtstart) {
 		if (cli->rtextsize && cli->sb_feat.reflink) {
 			if (cli_opt_set(&mopts, M_REFLINK)) {
 				fprintf(stderr,
@@ -2911,6 +3211,11 @@ validate_rtextsize(
 			usage();
 		}
 		cfg->rtextblocks = 1;
+	} else if (cli->sb_feat.zoned) {
+		/*
+		 * Zoned mode only supports a rtextsize of 1.
+		 */
+		cfg->rtextblocks = 1;
 	} else {
 		/*
 		 * If realtime extsize has not been specified by the user,
@@ -3315,7 +3620,8 @@ _("log stripe unit (%d bytes) is too large (maximum is 256KiB)\n"
 static void
 open_devices(
 	struct mkfs_params	*cfg,
-	struct libxfs_init	*xi)
+	struct libxfs_init	*xi,
+	struct zone_topology	*zt)
 {
 	uint64_t		sector_mask;
 
@@ -3330,6 +3636,34 @@ open_devices(
 		usage();
 	}
 
+	if (zt->data.nr_zones) {
+		zt->rt.zone_size = zt->data.zone_size;
+		zt->rt.zone_capacity = zt->data.zone_capacity;
+		zt->rt.nr_zones = zt->data.nr_zones - zt->data.nr_conv_zones;
+	} else if (cfg->sb_feat.zoned && !cfg->rtstart && !xi->rt.dev) {
+		/*
+		 * By default reserve at 1% of the total capacity (rounded up to
+		 * the next power of two) for metadata, but match the minimum we
+		 * enforce elsewhere. This matches what SMR HDDs provide.
+		 */
+		uint64_t rt_target_size = max((xi->data.size + 99) / 100,
+					      BTOBB(300 * 1024 * 1024));
+
+		cfg->rtstart = 1;
+		while (cfg->rtstart < rt_target_size)
+			cfg->rtstart <<= 1;
+	}
+
+	if (cfg->rtstart) {
+		if (cfg->rtstart >= xi->data.size) {
+			fprintf(stderr,
+ _("device size %lld too small for zoned allocator\n"), xi->data.size);
+			usage();
+		}
+		xi->rt.size = xi->data.size - cfg->rtstart;
+		xi->data.size = cfg->rtstart;
+	}
+
 	/*
 	 * Ok, Linux only has a 1024-byte resolution on device _size_,
 	 * and the sizes below are in basic 512-byte blocks,
@@ -3348,17 +3682,42 @@ open_devices(
 
 static void
 discard_devices(
+	struct mkfs_params	*cfg,
 	struct libxfs_init	*xi,
+	struct zone_topology	*zt,
 	int			quiet)
 {
 	/*
 	 * This function has to be called after libxfs has been initialized.
 	 */
 
-	if (!xi->data.isfile)
-		discard_blocks(xi->data.fd, xi->data.size, quiet);
-	if (xi->rt.dev && !xi->rt.isfile)
-		discard_blocks(xi->rt.fd, xi->rt.size, quiet);
+	if (!xi->data.isfile) {
+		uint64_t	nsectors = xi->data.size;
+
+		if (cfg->rtstart && zt->data.nr_zones) {
+			/*
+			 * Note that the zone reset here includes the LBA range
+			 * for the data device.
+			 *
+			 * This is because doing a single zone reset all on the
+			 * entire device (which the kernel automatically does
+			 * for us for a full device range) is a lot faster than
+			 * resetting each zone individually and resetting
+			 * the conventional zones used for the data device is a
+			 * no-op.
+			 */
+			reset_zones(cfg, xi->data.fd, 0,
+					cfg->rtstart + xi->rt.size, quiet);
+			nsectors -= cfg->rtstart;
+		}
+		discard_blocks(xi->data.fd, nsectors, quiet);
+	}
+	if (xi->rt.dev && !xi->rt.isfile) {
+		if (zt->rt.nr_zones)
+			reset_zones(cfg, xi->rt.fd, 0, xi->rt.size, quiet);
+		else
+			discard_blocks(xi->rt.fd, xi->rt.size, quiet);
+	}
 	if (xi->log.dev && xi->log.dev != xi->data.dev && !xi->log.isfile)
 		discard_blocks(xi->log.fd, xi->log.size, quiet);
 }
@@ -3477,11 +3836,12 @@ reported by the device (%u).\n"),
 static void
 validate_rtdev(
 	struct mkfs_params	*cfg,
-	struct cli_params	*cli)
+	struct cli_params	*cli,
+	struct zone_topology	*zt)
 {
 	struct libxfs_init	*xi = cli->xi;
 
-	if (!xi->rt.dev) {
+	if (!xi->rt.dev && !cfg->rtstart) {
 		if (cli->rtsize) {
 			fprintf(stderr,
 _("size specified for non-existent rt subvolume\n"));
@@ -3501,7 +3861,7 @@ _("size specified for non-existent rt subvolume\n"));
 	if (cli->rtsize) {
 		if (cfg->rtblocks > DTOBT(xi->rt.size, cfg->blocklog)) {
 			fprintf(stderr,
-_("size %s specified for rt subvolume is too large, maxi->um is %lld blocks\n"),
+_("size %s specified for rt subvolume is too large, maximum is %lld blocks\n"),
 				cli->rtsize,
 				(long long)DTOBT(xi->rt.size, cfg->blocklog));
 			usage();
@@ -3512,6 +3872,9 @@ _("size %s specified for rt subvolume is too large, maxi->um is %lld blocks\n"),
 reported by the device (%u).\n"),
 				cfg->sectorsize, xi->rt.bsize);
 		}
+	} else if (zt->rt.nr_zones) {
+		cfg->rtblocks = DTOBT(zt->rt.nr_zones * zt->rt.zone_capacity,
+				      cfg->blocklog);
 	} else {
 		/* grab volume size */
 		cfg->rtblocks = DTOBT(xi->rt.size, cfg->blocklog);
@@ -3950,6 +4313,42 @@ out:
 	cfg->rgcount = howmany(cfg->rtblocks, cfg->rgsize);
 }
 
+static void
+validate_rtgroup_geometry(
+	struct mkfs_params	*cfg)
+{
+	if (cfg->rgsize > XFS_MAX_RGBLOCKS) {
+		fprintf(stderr,
+_("realtime group size (%llu) must be less than the maximum (%u)\n"),
+				(unsigned long long)cfg->rgsize,
+				XFS_MAX_RGBLOCKS);
+		usage();
+	}
+
+	if (cfg->rgsize % cfg->rtextblocks != 0) {
+		fprintf(stderr,
+_("realtime group size (%llu) not a multiple of rt extent size (%llu)\n"),
+				(unsigned long long)cfg->rgsize,
+				(unsigned long long)cfg->rtextblocks);
+		usage();
+	}
+
+	if (cfg->rgsize <= cfg->rtextblocks) {
+		fprintf(stderr,
+_("realtime group size (%llu) must be at least two realtime extents\n"),
+				(unsigned long long)cfg->rgsize);
+		usage();
+	}
+
+	if (cfg->rgcount > XFS_MAX_RGNUMBER) {
+		fprintf(stderr,
+_("realtime group count (%llu) must be less than the maximum (%u)\n"),
+				(unsigned long long)cfg->rgcount,
+				XFS_MAX_RGNUMBER);
+		usage();
+	}
+}
+
 static void
 calculate_rtgroup_geometry(
 	struct mkfs_params	*cfg,
@@ -4007,40 +4406,97 @@ _("rgsize (%s) not a multiple of fs blk size (%d)\n"),
 				(cfg->rtblocks % cfg->rgsize != 0);
 	}
 
-	if (cfg->rgsize > XFS_MAX_RGBLOCKS) {
-		fprintf(stderr,
-_("realtime group size (%llu) must be less than the maximum (%u)\n"),
-				(unsigned long long)cfg->rgsize,
-				XFS_MAX_RGBLOCKS);
-		usage();
-	}
+	validate_rtgroup_geometry(cfg);
 
-	if (cfg->rgsize % cfg->rtextblocks != 0) {
+	if (cfg->rtextents)
+		cfg->rtbmblocks = howmany(cfg->rgsize / cfg->rtextblocks,
+			NBBY * (cfg->blocksize - sizeof(struct xfs_rtbuf_blkinfo)));
+}
+
+static void
+calculate_zone_geometry(
+	struct mkfs_params	*cfg,
+	struct cli_params	*cli,
+	struct libxfs_init	*xi,
+	struct zone_topology	*zt)
+{
+	if (cfg->rtblocks == 0) {
 		fprintf(stderr,
-_("realtime group size (%llu) not a multiple of rt extent size (%llu)\n"),
-				(unsigned long long)cfg->rgsize,
-				(unsigned long long)cfg->rtextblocks);
+_("empty zoned realtime device not supported.\n"));
 		usage();
 	}
 
-	if (cfg->rgsize <= cfg->rtextblocks) {
-		fprintf(stderr,
-_("realtime group size (%llu) must be at least two realtime extents\n"),
-				(unsigned long long)cfg->rgsize);
-		usage();
+	if (zt->rt.nr_zones) {
+		/* The RT device has hardware zones */
+		cfg->rgsize = zt->rt.zone_capacity * 512;
+
+		if (cfg->rgsize % cfg->blocksize) {
+			fprintf(stderr,
+_("rgsize (%s) not a multiple of fs blk size (%d)\n"),
+				cli->rgsize, cfg->blocksize);
+			usage();
+		}
+		if (cli->rgsize) {
+			fprintf(stderr,
+_("rgsize (%s) may not be specified when the rt device is zoned\n"),
+				cli->rgsize);
+			usage();
+		}
+
+		cfg->rgsize /= cfg->blocksize;
+		cfg->rgcount = howmany(cfg->rtblocks, cfg->rgsize);
+
+		if (cli->rgcount > cfg->rgcount) {
+			fprintf(stderr,
+_("rgcount (%llu) is larger than hardware zone count (%llu)\n"),
+					(unsigned long long)cli->rgcount,
+					(unsigned long long)cfg->rgcount);
+			usage();
+		} else if (cli->rgcount && cli->rgcount < cfg->rgcount) {
+			/* constrain the rt device to the given rgcount */
+			cfg->rgcount = cli->rgcount;
+		}
+	} else {
+		/* No hardware zones */
+		if (cli->rgsize) {
+			/* User-specified rtgroup size */
+			cfg->rgsize = getnum(cli->rgsize, &ropts, R_RGSIZE);
+
+			/* Check specified agsize is a multiple of blocksize. */
+			if (cfg->rgsize % cfg->blocksize) {
+				fprintf(stderr,
+_("rgsize (%s) not a multiple of fs blk size (%d)\n"),
+					cli->rgsize, cfg->blocksize);
+				usage();
+			}
+			cfg->rgsize /= cfg->blocksize;
+			cfg->rgcount = cfg->rtblocks / cfg->rgsize +
+					(cfg->rtblocks % cfg->rgsize != 0);
+		} else if (cli->rgcount) {
+			/* User-specified rtgroup count */
+			cfg->rgcount = cli->rgcount;
+			cfg->rgsize = cfg->rtblocks / cfg->rgcount +
+					(cfg->rtblocks % cfg->rgcount != 0);
+		} else {
+			/* 256MB zones just like typical SMR HDDs */
+			cfg->rgsize = MEGABYTES(256, cfg->blocklog);
+			cfg->rgcount = cfg->rtblocks / cfg->rgsize +
+					(cfg->rtblocks % cfg->rgsize != 0);
+		}
 	}
 
-	if (cfg->rgcount > XFS_MAX_RGNUMBER) {
+	if (cfg->rgcount < XFS_MIN_ZONES)  {
 		fprintf(stderr,
-_("realtime group count (%llu) must be less than the maximum (%u)\n"),
+_("realtime group count (%llu) must be greater than the minimum zone count (%u)\n"),
 				(unsigned long long)cfg->rgcount,
-				XFS_MAX_RGNUMBER);
+				XFS_MIN_ZONES);
 		usage();
 	}
 
-	if (cfg->rtextents)
-		cfg->rtbmblocks = howmany(cfg->rgsize / cfg->rtextblocks,
-			NBBY * (cfg->blocksize - sizeof(struct xfs_rtbuf_blkinfo)));
+	validate_rtgroup_geometry(cfg);
+
+	/* Zoned RT devices don't use the rtbitmap, and have no bitmap blocks */
+	cfg->rtbmblocks = 0;
 }
 
 static void
@@ -4206,6 +4662,14 @@ sb_set_features(
 		sbp->sb_rgblklog = libxfs_compute_rgblklog(sbp->sb_rgextents,
 							   cfg->rtextblocks);
 	}
+
+	if (fp->zoned) {
+		sbp->sb_features_incompat |= XFS_SB_FEAT_INCOMPAT_ZONED;
+		sbp->sb_rtstart = (cfg->rtstart * 512) / cfg->blocksize;
+		sbp->sb_rtreserved = cfg->rtreserved / cfg->blocksize;
+	}
+	if (fp->zone_gaps)
+		sbp->sb_features_incompat |= XFS_SB_FEAT_INCOMPAT_ZONE_GAPS;
 }
 
 /*
@@ -4768,9 +5232,11 @@ prepare_devices(
 			 (xfs_extlen_t)XFS_FSB_TO_BB(mp, cfg->logblocks),
 			 &sbp->sb_uuid, cfg->sb_feat.log_version,
 			 lsunit, XLOG_FMT, XLOG_INIT_CYCLE, false);
-
 	/* finally, check we can write the last block in the realtime area */
-	if (mp->m_rtdev_targp->bt_bdev && cfg->rtblocks > 0) {
+	if (mp->m_rtdev_targp->bt_bdev &&
+	    mp->m_rtdev_targp != mp->m_ddev_targp &&
+	    cfg->rtblocks > 0 &&
+	    !xfs_has_zoned(mp)) {
 		buf = alloc_write_buf(mp->m_rtdev_targp,
 				XFS_FSB_TO_BB(mp, cfg->rtblocks - 1LL),
 				BTOBB(cfg->blocksize));
@@ -5209,7 +5675,7 @@ main(
 			 */
 		},
 	};
-
+	struct zone_topology zt = {};
 	struct list_head	buffer_list;
 	int			error;
 
@@ -5311,6 +5777,7 @@ main(
 	sectorsize = cfg.sectorsize;
 
 	validate_log_sectorsize(&cfg, &cli, &dft, &ft);
+	validate_zoned(&cfg, &cli, &dft, &zt);
 	validate_sb_features(&cfg, &cli);
 
 	/*
@@ -5335,11 +5802,11 @@ main(
 	/*
 	 * Open and validate the device configurations
 	 */
-	open_devices(&cfg, &xi);
+	open_devices(&cfg, &xi, &zt);
 	validate_overwrite(xi.data.name, force_overwrite);
 	validate_datadev(&cfg, &cli);
 	validate_logdev(&cfg, &cli);
-	validate_rtdev(&cfg, &cli);
+	validate_rtdev(&cfg, &cli, &zt);
 	calc_stripe_factors(&cfg, &cli, &ft);
 
 	/*
@@ -5350,7 +5817,10 @@ main(
 	 */
 	calculate_initial_ag_geometry(&cfg, &cli, &xi);
 	align_ag_geometry(&cfg);
-	calculate_rtgroup_geometry(&cfg, &cli, &xi);
+	if (cfg.sb_feat.zoned)
+		calculate_zone_geometry(&cfg, &cli, &xi, &zt);
+	else
+		calculate_rtgroup_geometry(&cfg, &cli, &xi);
 
 	calculate_imaxpct(&cfg, &cli);
 
@@ -5403,8 +5873,13 @@ main(
 	/*
 	 * All values have been validated, discard the old device layout.
 	 */
+	if (cli.sb_feat.zoned && !discard) {
+		fprintf(stderr,
+ _("-K not support for zoned file systems.\n"));
+		return 1;
+	}
 	if (discard && !dry_run)
-		discard_devices(&xi, quiet);
+		discard_devices(&cfg, &xi, &zt, quiet);
 
 	/*
 	 * we need the libxfs buffer cache from here on in.
diff --git a/repair/agheader.c b/repair/agheader.c
index 5bb4e47e0c5b..048e6c3143b5 100644
--- a/repair/agheader.c
+++ b/repair/agheader.c
@@ -486,7 +486,7 @@ secondary_sb_whack(
 	 * size is the size of data which is valid for this sb.
 	 */
 	if (xfs_sb_version_haszoned(sb))
-		size = offsetofend(struct xfs_dsb, sb_rtstart);
+		size = offsetofend(struct xfs_dsb, sb_rtreserved);
 	else if (xfs_sb_version_hasmetadir(sb))
 		size = offsetofend(struct xfs_dsb, sb_pad);
 	else if (xfs_sb_version_hasmetauuid(sb))
-- 
2.47.2

