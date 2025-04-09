Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D49C278147
	for <linux-xfs@vger.kernel.org>; Wed,  9 Apr 2025 18:54:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744224890; cv=none; b=dnXWanEPcE5sCqY58FMErye26kRF+nMT+ZUfn4jrdL61u2UQyrRjl/A6Ef6hPd7v9rA8MM3QBkGCxvSpK7WeZNRJ6oJNISSz9tNr8nVrTcEPQRpW5gwjFx1+TChwFNzxYQDbdimVU1G0XFHcEtvMZrBVR+26ZBgFczGQv/h0vPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744224890; c=relaxed/simple;
	bh=Cs+soZ5enA5cI7PcprNw1A8PxjHvbMe83HTlenydirM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B20r//L0QAAHQb1jgx6esn1msNYZCNwJ9yUhEMOSCMpCI/N/zPonoYbAvWXdlKTvFx7pTkg4bAEwDs0rfP7Wg0bTvpqohTTGp8OCqIVN2fMkhMqxtBfb2dCwKU5uSV9dg2bYaJ/fcKm+cJnUcQumbe5cZOwW2NqdpFGEqubMUi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mB4bmQDF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mB4bmQDF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF1B1C4CEE2;
	Wed,  9 Apr 2025 18:54:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744224889;
	bh=Cs+soZ5enA5cI7PcprNw1A8PxjHvbMe83HTlenydirM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mB4bmQDFPF2rTWBTDWMU/O27L0Eh56mdE7vUe0OPcviYndXja1jOexBzjrfTkWdlO
	 D8eD8fhv0XQ6y691VzlA9ATt2Nba6eWfd1uVkIp+PW8d9unPq5Ah03aSMhGS1Ui51k
	 WmxjSjuzfG5Cff+TTZuHdDREifiu5028PCRB+FfbgYCOHBP6qiwVv/BcBq54zDv9dD
	 9O1dpvesuM1dzbPYnKnhTEEbxIDaa8OMogyv2kWJEs8NFUYIfTHuGdD3338wHjXATj
	 Mx8ofCrNZ2xkukO6LhET9r1cG2bnw5QHB17BfRfZRgpiZUXhCn9z3pwqxA+K1nEhl0
	 TfeEQvq7+X7Mw==
Date: Wed, 9 Apr 2025 11:54:49 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 30/45] xfs_mkfs: support creating zoned file systems
Message-ID: <20250409185449.GF6283@frogsfrogsfrogs>
References: <20250409075557.3535745-1-hch@lst.de>
 <20250409075557.3535745-31-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250409075557.3535745-31-hch@lst.de>

On Wed, Apr 09, 2025 at 09:55:33AM +0200, Christoph Hellwig wrote:
> Default to use all sequential write required zoned for the RT device.
> 
> Default to 256 and 1% conventional when -r zoned is specified without
> further option.  This mimics a SMR HDD and works well with tests.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  libxfs/init.c     |   2 +-
>  mkfs/proto.c      |   3 +-
>  mkfs/xfs_mkfs.c   | 553 ++++++++++++++++++++++++++++++++++++++++++----
>  repair/agheader.c |   2 +-
>  4 files changed, 518 insertions(+), 42 deletions(-)
> 
> diff --git a/libxfs/init.c b/libxfs/init.c
> index a186369f3fd8..393a94673f7e 100644
> --- a/libxfs/init.c
> +++ b/libxfs/init.c
> @@ -251,7 +251,7 @@ libxfs_close_devices(
>  		libxfs_device_close(&li->data);
>  	if (li->log.dev && li->log.dev != li->data.dev)
>  		libxfs_device_close(&li->log);
> -	if (li->rt.dev)
> +	if (li->rt.dev && li->rt.dev != li->data.dev)
>  		libxfs_device_close(&li->rt);
>  }
>  
> diff --git a/mkfs/proto.c b/mkfs/proto.c
> index 7f56a3d82a06..7f80bef838be 100644
> --- a/mkfs/proto.c
> +++ b/mkfs/proto.c
> @@ -1144,7 +1144,8 @@ rtinit_groups(
>  				fail(_("rtrmap rtsb init failed"), error);
>  		}
>  
> -		rtfreesp_init(rtg);
> +		if (!xfs_has_zoned(mp))
> +			rtfreesp_init(rtg);
>  	}
>  }
>  
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 39e3349205fb..133ede8d8483 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -6,6 +6,8 @@
>  #include "libfrog/util.h"
>  #include "libxfs.h"
>  #include <ctype.h>
> +#include <linux/blkzoned.h>
> +#include "libxfs/xfs_zones.h"
>  #include "xfs_multidisk.h"
>  #include "libxcmd.h"
>  #include "libfrog/fsgeom.h"
> @@ -135,6 +137,9 @@ enum {
>  	R_RGCOUNT,
>  	R_RGSIZE,
>  	R_CONCURRENCY,
> +	R_ZONED,
> +	R_START,
> +	R_RESERVED,
>  	R_MAX_OPTS,
>  };
>  
> @@ -739,6 +744,9 @@ static struct opt_params ropts = {
>  		[R_RGCOUNT] = "rgcount",
>  		[R_RGSIZE] = "rgsize",
>  		[R_CONCURRENCY] = "concurrency",
> +		[R_ZONED] = "zoned",
> +		[R_START] = "start",
> +		[R_RESERVED] = "reserved",
>  		[R_MAX_OPTS] = NULL,
>  	},
>  	.subopt_params = {
> @@ -804,6 +812,28 @@ static struct opt_params ropts = {
>  		  .maxval = INT_MAX,
>  		  .defaultval = 1,
>  		},
> +		{ .index = R_ZONED,
> +		  .conflicts = { { &ropts, R_EXTSIZE },
> +				 { NULL, LAST_CONFLICT } },
> +		  .minval = 0,
> +		  .maxval = 1,
> +		  .defaultval = 1,
> +		},
> +		{ .index = R_START,
> +		  .conflicts = { { &ropts, R_DEV },
> +				 { NULL, LAST_CONFLICT } },
> +		  .convert = true,
> +		  .minval = 0,
> +		  .maxval = LLONG_MAX,
> +		  .defaultval = SUBOPT_NEEDS_VAL,
> +		},
> +		{ .index = R_RESERVED,
> +		  .conflicts = { { NULL, LAST_CONFLICT } },
> +		  .convert = true,
> +		  .minval = 0,
> +		  .maxval = LLONG_MAX,
> +		  .defaultval = SUBOPT_NEEDS_VAL,
> +		},
>  	},
>  };
>  
> @@ -1012,6 +1042,8 @@ struct sb_feat_args {
>  	bool	nortalign;
>  	bool	nrext64;
>  	bool	exchrange;		/* XFS_SB_FEAT_INCOMPAT_EXCHRANGE */
> +	bool	zoned;
> +	bool	zone_gaps;
>  
>  	uint16_t qflags;
>  };
> @@ -1035,6 +1067,8 @@ struct cli_params {
>  	char	*lsu;
>  	char	*rtextsize;
>  	char	*rtsize;
> +	char	*rtstart;
> +	uint64_t rtreserved;
>  
>  	/* parameters where 0 is a valid CLI value */
>  	int	dsunit;
> @@ -1121,6 +1155,8 @@ struct mkfs_params {
>  	char		*label;
>  
>  	struct sb_feat_args	sb_feat;
> +	uint64_t	rtstart;
> +	uint64_t	rtreserved;
>  };
>  
>  /*
> @@ -1172,7 +1208,7 @@ usage( void )
>  /* prototype file */	[-p fname]\n\
>  /* quiet */		[-q]\n\
>  /* realtime subvol */	[-r extsize=num,size=num,rtdev=xxx,rgcount=n,rgsize=n,\n\
> -			    concurrency=num]\n\
> +			    concurrency=num,zoned=0|1,start=n,reserved=n]\n\
>  /* sectorsize */	[-s size=num]\n\
>  /* version */		[-V]\n\
>  			devicename\n\
> @@ -1539,6 +1575,30 @@ discard_blocks(int fd, uint64_t nsectors, int quiet)
>  		printf("Done.\n");
>  }
>  
> +static void
> +reset_zones(struct mkfs_params *cfg, int fd, uint64_t start_sector,
> +		uint64_t nsectors, int quiet)
> +{
> +	struct blk_zone_range range = {
> +		.sector		= start_sector,
> +		.nr_sectors	= nsectors,
> +	};
> +
> +	if (!quiet) {
> +		printf("Resetting zones...");
> +		fflush(stdout);
> +	}
> +
> +	if (ioctl(fd, BLKRESETZONE, &range) < 0) {
> +		if (!quiet)
> +			printf(" FAILED\n");

Should we print /why/ the zone reset failed?

> +		exit(1);
> +	}
> +
> +	if (!quiet)
> +		printf("Done.\n");
> +}
> +
>  static __attribute__((noreturn)) void
>  illegal_option(
>  	const char		*value,
> @@ -2144,6 +2204,15 @@ rtdev_opts_parser(
>  	case R_CONCURRENCY:
>  		set_rtvol_concurrency(opts, subopt, cli, value);
>  		break;
> +	case R_ZONED:
> +		cli->sb_feat.zoned = getnum(value, opts, subopt);
> +		break;
> +	case R_START:
> +		cli->rtstart = getstr(value, opts, subopt);
> +		break;
> +	case R_RESERVED:
> +		cli->rtreserved = getnum(value, opts, subopt);
> +		break;
>  	default:
>  		return -EINVAL;
>  	}
> @@ -2445,7 +2514,208 @@ _("Version 1 logs do not support sector size %d\n"),
>  _("log stripe unit specified, using v2 logs\n"));
>  		cli->sb_feat.log_version = 2;
>  	}
> +}
> +
> +struct zone_info {
> +	/* number of zones, conventional or sequential */
> +	unsigned int		nr_zones;
> +	/* number of conventional zones */
> +	unsigned int		nr_conv_zones;
> +
> +	/* size of the address space for a zone, in 512b blocks */
> +	xfs_daddr_t		zone_size;
> +	/* write capacity of a zone, in 512b blocks */
> +	xfs_daddr_t		zone_capacity;
> +};
>  
> +struct zone_topology {
> +	struct zone_info	data;
> +	struct zone_info	rt;
> +	struct zone_info	log;
> +};
> +
> +/* random size that allows efficient processing */
> +#define ZONES_PER_IOCTL			16384
> +
> +static int report_zones(const char *name, struct zone_info *zi)
> +{
> +	struct blk_zone_report *rep;
> +	size_t rep_size;
> +	struct stat st;
> +	unsigned int i, n = 0;
> +	uint64_t device_size;
> +	uint64_t sector = 0;
> +	bool found_seq = false;
> +	int ret = 0;
> +	int fd;

Nit: indenting

> +
> +	fd = open(name, O_RDONLY);
> +	if (fd < 0)
> +		return -EIO;
> +
> +	if (fstat(fd, &st) < 0) {
> +		ret = -EIO;
> +		goto out_close;
> +	}
> +        if (!S_ISBLK(st.st_mode))

    ^^^^^^ especially here

> +		goto out_close;
> +
> +	if (ioctl(fd, BLKGETSIZE64, &device_size)) {
> +		ret = -EIO;

ret = errno; ?  But then...

> +		goto out_close;
> +	}

...what's the point in returning errors if the caller never checks?

> +	if (ioctl(fd, BLKGETZONESZ, &zi->zone_size) || !zi->zone_size)
> +		goto out_close; /* not zoned */
> +
> +	device_size /= 512; /* BLKGETSIZE64 reports a byte value */

BTOBB

> +	zi->nr_zones = device_size / zi->zone_size;
> +	zi->nr_conv_zones = 0;
> +
> +	rep_size = sizeof(struct blk_zone_report) +
> +		   sizeof(struct blk_zone) * ZONES_PER_IOCTL;
> +	rep = malloc(rep_size);
> +	if (!rep) {
> +		ret = -ENOMEM;
> +		goto out_close;
> +	}
> +
> +	while (n < zi->nr_zones) {
> +		struct blk_zone *zones = (struct blk_zone *)(rep + 1);
> +
> +		memset(rep, 0, rep_size);
> +		rep->sector = sector;
> +		rep->nr_zones = ZONES_PER_IOCTL;
> +
> +		ret = ioctl(fd, BLKREPORTZONE, rep);
> +		if (ret) {
> +			fprintf(stderr,
> +_("ioctl(BLKREPORTZONE) failed: %d!\n"), ret);
> +			goto out_free;
> +		}
> +		if (!rep->nr_zones)
> +			break;
> +
> +		for (i = 0; i < rep->nr_zones; i++) {
> +			if (n >= zi->nr_zones)
> +				break;
> +
> +			if (zones[i].len != zi->zone_size) {
> +				fprintf(stderr,
> +_("Inconsistent zone size!\n"));
> +				ret = -EIO;
> +				goto out_free;
> +			}
> +
> +			switch (zones[i].type) {
> +			case BLK_ZONE_TYPE_CONVENTIONAL:
> +				/*
> +				 * We can only use the conventional space at the
> +				 * start of the device for metadata, so don't
> +				 * count later conventional zones.  This is
> +				 * not an error because we can use them for data
> +				 * just fine.
> +				 */
> +				if (!found_seq)
> +					zi->nr_conv_zones++;
> +				break;
> +			case BLK_ZONE_TYPE_SEQWRITE_REQ:
> +				found_seq = true;
> +				break;
> +			case BLK_ZONE_TYPE_SEQWRITE_PREF:
> +				fprintf(stderr,
> +_("Sequential write preferred zones not supported.\n"));
> +				ret = -EIO;
> +				goto out_free;
> +			default:
> +				fprintf(stderr,
> +_("Unknown zone type (0x%x) found.\n"), zones[i].type);
> +				ret = -EIO;
> +				goto out_free;
> +			}
> +
> +			if (!n) {
> +				zi->zone_capacity = zones[i].capacity;
> +				if (zi->zone_capacity > zi->zone_size) {
> +					fprintf(stderr,
> +_("Zone capacity larger than zone size!\n"));
> +					ret = -EIO;
> +					goto out_free;
> +				}
> +			} else if (zones[i].capacity != zi->zone_capacity) {
> +				fprintf(stderr,
> +_("Inconsistent zone capacity!\n"));
> +				ret = -EIO;
> +				goto out_free;
> +			}
> +
> +			n++;
> +		}
> +		sector = zones[rep->nr_zones - 1].start +
> +			 zones[rep->nr_zones - 1].len;
> +	}
> +
> +out_free:
> +	free(rep);
> +out_close:
> +	close(fd);
> +	return ret;
> +}
> +
> +static void
> +validate_zoned(
> +	struct mkfs_params	*cfg,
> +	struct cli_params	*cli,
> +	struct mkfs_default_params *dft,
> +	struct zone_topology	*zt)
> +{
> +	if (!cli->xi->data.isfile) {
> +		report_zones(cli->xi->data.name, &zt->data);
> +		if (zt->data.nr_zones) {
> +			if (!zt->data.nr_conv_zones) {
> +				fprintf(stderr,
> +_("Data devices requires conventional zones.\n"));
> +				usage();
> +			}
> +			if (zt->data.zone_capacity != zt->data.zone_size) {
> +				fprintf(stderr,
> +_("Zone capacity equal to Zone size required for conventional zones.\n"));
> +				usage();
> +			}
> +
> +			cli->sb_feat.zoned = true;
> +			cfg->rtstart =
> +				zt->data.nr_conv_zones * zt->data.zone_capacity;
> +		}
> +	}
> +
> +	if (cli->xi->rt.name && !cli->xi->rt.isfile) {
> +		report_zones(cli->xi->rt.name, &zt->rt);
> +		if (zt->rt.nr_zones && !cli->sb_feat.zoned)
> +			cli->sb_feat.zoned = true;
> +		if (zt->rt.zone_size != zt->rt.zone_capacity)
> +			cli->sb_feat.zone_gaps = true;
> +	}
> +
> +	if (cli->xi->log.name && !cli->xi->log.isfile) {
> +		report_zones(cli->xi->log.name, &zt->log);
> +		if (zt->log.nr_zones) {
> +			fprintf(stderr,
> +_("Zoned devices not supported as log device!\n"));

Too bad, we really ought to be able to write logs to a zone device.
But that's not in scope here.

> +			usage();
> +		}
> +	}
> +
> +	if (cli->rtstart) {
> +		if (cfg->rtstart) {

Er... why are we checking the variable that we set four lines down?
Is this supposed to be a check for external zoned rt devices?

> +			fprintf(stderr,
> +_("rtstart override not allowed on zoned devices.\n"));
> +			usage();
> +		}
> +		cfg->rtstart = getnum(cli->rtstart, &ropts, R_START) / 512;
> +	}
> +
> +	if (cli->rtreserved)
> +		cfg->rtreserved = cli->rtreserved;
>  }
>  
>  /*
> @@ -2670,7 +2940,37 @@ _("inode btree counters not supported without finobt support\n"));
>  		cli->sb_feat.inobtcnt = false;
>  	}
>  
> -	if (cli->xi->rt.name) {
> +	if (cli->sb_feat.zoned) {
> +		if (!cli->sb_feat.metadir) {
> +			if (cli_opt_set(&mopts, M_METADIR)) {
> +				fprintf(stderr,
> +_("zoned realtime device not supported without metadir support\n"));
> +				usage();
> +			}
> +			cli->sb_feat.metadir = true;
> +		}
> +		if (cli->rtextsize) {
> +			if (cli_opt_set(&ropts, R_EXTSIZE)) {
> +				fprintf(stderr,
> +_("rt extent size not supported on realtime devices with zoned mode\n"));
> +				usage();
> +			}
> +			cli->rtextsize = 0;
> +		}
> +	} else {
> +		if (cli->rtstart) {
> +			fprintf(stderr,
> +_("internal RT section only supported in zoned mode\n"));
> +			usage();
> +		}
> +		if (cli->rtreserved) {
> +			fprintf(stderr,
> +_("reserved RT blocks only supported in zoned mode\n"));
> +			usage();
> +		}
> +	}
> +
> +	if (cli->xi->rt.name || cfg->rtstart) {
>  		if (cli->rtextsize && cli->sb_feat.reflink) {
>  			if (cli_opt_set(&mopts, M_REFLINK)) {
>  				fprintf(stderr,
> @@ -2911,6 +3211,11 @@ validate_rtextsize(
>  			usage();
>  		}
>  		cfg->rtextblocks = 1;
> +	} else if (cli->sb_feat.zoned) {
> +		/*
> +		 * Zoned mode only supports a rtextsize of 1.
> +		 */
> +		cfg->rtextblocks = 1;
>  	} else {
>  		/*
>  		 * If realtime extsize has not been specified by the user,
> @@ -3315,7 +3620,8 @@ _("log stripe unit (%d bytes) is too large (maximum is 256KiB)\n"
>  static void
>  open_devices(
>  	struct mkfs_params	*cfg,
> -	struct libxfs_init	*xi)
> +	struct libxfs_init	*xi,
> +	struct zone_topology	*zt)
>  {
>  	uint64_t		sector_mask;
>  
> @@ -3330,6 +3636,34 @@ open_devices(
>  		usage();
>  	}
>  
> +	if (zt->data.nr_zones) {
> +		zt->rt.zone_size = zt->data.zone_size;
> +		zt->rt.zone_capacity = zt->data.zone_capacity;
> +		zt->rt.nr_zones = zt->data.nr_zones - zt->data.nr_conv_zones;
> +	} else if (cfg->sb_feat.zoned && !cfg->rtstart && !xi->rt.dev) {
> +		/*
> +		 * By default reserve at 1% of the total capacity (rounded up to
> +		 * the next power of two) for metadata, but match the minimum we
> +		 * enforce elsewhere. This matches what SMR HDDs provide.
> +		 */
> +		uint64_t rt_target_size = max((xi->data.size + 99) / 100,
> +					      BTOBB(300 * 1024 * 1024));
> +
> +		cfg->rtstart = 1;
> +		while (cfg->rtstart < rt_target_size)
> +			cfg->rtstart <<= 1;
> +	}
> +
> +	if (cfg->rtstart) {
> +		if (cfg->rtstart >= xi->data.size) {
> +			fprintf(stderr,
> + _("device size %lld too small for zoned allocator\n"), xi->data.size);
> +			usage();
> +		}
> +		xi->rt.size = xi->data.size - cfg->rtstart;
> +		xi->data.size = cfg->rtstart;
> +	}
> +
>  	/*
>  	 * Ok, Linux only has a 1024-byte resolution on device _size_,
>  	 * and the sizes below are in basic 512-byte blocks,
> @@ -3348,17 +3682,42 @@ open_devices(
>  
>  static void
>  discard_devices(
> +	struct mkfs_params	*cfg,
>  	struct libxfs_init	*xi,
> +	struct zone_topology	*zt,
>  	int			quiet)
>  {
>  	/*
>  	 * This function has to be called after libxfs has been initialized.
>  	 */
>  
> -	if (!xi->data.isfile)
> -		discard_blocks(xi->data.fd, xi->data.size, quiet);
> -	if (xi->rt.dev && !xi->rt.isfile)
> -		discard_blocks(xi->rt.fd, xi->rt.size, quiet);
> +	if (!xi->data.isfile) {
> +		uint64_t	nsectors = xi->data.size;
> +
> +		if (cfg->rtstart && zt->data.nr_zones) {
> +			/*
> +			 * Note that the zone reset here includes the LBA range
> +			 * for the data device.
> +			 *
> +			 * This is because doing a single zone reset all on the
> +			 * entire device (which the kernel automatically does
> +			 * for us for a full device range) is a lot faster than
> +			 * resetting each zone individually and resetting
> +			 * the conventional zones used for the data device is a
> +			 * no-op.
> +			 */
> +			reset_zones(cfg, xi->data.fd, 0,
> +					cfg->rtstart + xi->rt.size, quiet);
> +			nsectors -= cfg->rtstart;
> +		}
> +		discard_blocks(xi->data.fd, nsectors, quiet);
> +	}
> +	if (xi->rt.dev && !xi->rt.isfile) {
> +		if (zt->rt.nr_zones)
> +			reset_zones(cfg, xi->rt.fd, 0, xi->rt.size, quiet);
> +		else
> +			discard_blocks(xi->rt.fd, xi->rt.size, quiet);
> +	}
>  	if (xi->log.dev && xi->log.dev != xi->data.dev && !xi->log.isfile)
>  		discard_blocks(xi->log.fd, xi->log.size, quiet);
>  }
> @@ -3477,11 +3836,12 @@ reported by the device (%u).\n"),
>  static void
>  validate_rtdev(
>  	struct mkfs_params	*cfg,
> -	struct cli_params	*cli)
> +	struct cli_params	*cli,
> +	struct zone_topology	*zt)
>  {
>  	struct libxfs_init	*xi = cli->xi;
>  
> -	if (!xi->rt.dev) {
> +	if (!xi->rt.dev && !cfg->rtstart) {
>  		if (cli->rtsize) {
>  			fprintf(stderr,
>  _("size specified for non-existent rt subvolume\n"));
> @@ -3501,7 +3861,7 @@ _("size specified for non-existent rt subvolume\n"));
>  	if (cli->rtsize) {
>  		if (cfg->rtblocks > DTOBT(xi->rt.size, cfg->blocklog)) {
>  			fprintf(stderr,
> -_("size %s specified for rt subvolume is too large, maxi->um is %lld blocks\n"),
> +_("size %s specified for rt subvolume is too large, maximum is %lld blocks\n"),
>  				cli->rtsize,
>  				(long long)DTOBT(xi->rt.size, cfg->blocklog));
>  			usage();
> @@ -3512,6 +3872,9 @@ _("size %s specified for rt subvolume is too large, maxi->um is %lld blocks\n"),
>  reported by the device (%u).\n"),
>  				cfg->sectorsize, xi->rt.bsize);
>  		}
> +	} else if (zt->rt.nr_zones) {
> +		cfg->rtblocks = DTOBT(zt->rt.nr_zones * zt->rt.zone_capacity,
> +				      cfg->blocklog);
>  	} else {
>  		/* grab volume size */
>  		cfg->rtblocks = DTOBT(xi->rt.size, cfg->blocklog);
> @@ -3950,6 +4313,42 @@ out:
>  	cfg->rgcount = howmany(cfg->rtblocks, cfg->rgsize);
>  }
>  
> +static void
> +validate_rtgroup_geometry(
> +	struct mkfs_params	*cfg)
> +{
> +	if (cfg->rgsize > XFS_MAX_RGBLOCKS) {
> +		fprintf(stderr,
> +_("realtime group size (%llu) must be less than the maximum (%u)\n"),
> +				(unsigned long long)cfg->rgsize,
> +				XFS_MAX_RGBLOCKS);
> +		usage();
> +	}
> +
> +	if (cfg->rgsize % cfg->rtextblocks != 0) {
> +		fprintf(stderr,
> +_("realtime group size (%llu) not a multiple of rt extent size (%llu)\n"),
> +				(unsigned long long)cfg->rgsize,
> +				(unsigned long long)cfg->rtextblocks);
> +		usage();
> +	}
> +
> +	if (cfg->rgsize <= cfg->rtextblocks) {
> +		fprintf(stderr,
> +_("realtime group size (%llu) must be at least two realtime extents\n"),
> +				(unsigned long long)cfg->rgsize);
> +		usage();
> +	}
> +
> +	if (cfg->rgcount > XFS_MAX_RGNUMBER) {
> +		fprintf(stderr,
> +_("realtime group count (%llu) must be less than the maximum (%u)\n"),
> +				(unsigned long long)cfg->rgcount,
> +				XFS_MAX_RGNUMBER);
> +		usage();
> +	}
> +}

Hoisting this out probably should've been a separate patch.

<snip>

> diff --git a/repair/agheader.c b/repair/agheader.c
> index 5bb4e47e0c5b..048e6c3143b5 100644
> --- a/repair/agheader.c
> +++ b/repair/agheader.c

Should this be in a different patch?

--D

> @@ -486,7 +486,7 @@ secondary_sb_whack(
>  	 * size is the size of data which is valid for this sb.
>  	 */
>  	if (xfs_sb_version_haszoned(sb))
> -		size = offsetofend(struct xfs_dsb, sb_rtstart);
> +		size = offsetofend(struct xfs_dsb, sb_rtreserved);
>  	else if (xfs_sb_version_hasmetadir(sb))
>  		size = offsetofend(struct xfs_dsb, sb_pad);
>  	else if (xfs_sb_version_hasmetauuid(sb))
> -- 
> 2.47.2
> 
> 
