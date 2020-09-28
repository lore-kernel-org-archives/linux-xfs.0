Return-Path: <SRS0=Pbt4=DF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,T_TVD_FUZZY_SECTOR,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98A34C2D0A8
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Sep 2020 23:18:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5717C2076A
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Sep 2020 23:18:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726440AbgI1XSj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 28 Sep 2020 19:18:39 -0400
Received: from sandeen.net ([63.231.237.45]:47196 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726369AbgI1XSj (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 28 Sep 2020 19:18:39 -0400
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 3B984504DEA;
        Mon, 28 Sep 2020 18:17:54 -0500 (CDT)
To:     Gao Xiang <hsiangkao@redhat.com>,
        linux-xfs <linux-xfs@vger.kernel.org>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eric Sandeen <sandeen@redhat.com>
References: <20200804160015.17330-1-hsiangkao@redhat.com>
 <20200806130301.27937-1-hsiangkao@redhat.com>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH v3] mkfs.xfs: introduce sunit/swidth validation helper
Message-ID: <f5df6861-7932-4c5e-f6da-6d5afc2cbf62@sandeen.net>
Date:   Mon, 28 Sep 2020 18:18:37 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <20200806130301.27937-1-hsiangkao@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 8/6/20 8:03 AM, Gao Xiang wrote:
> Currently stripe unit/swidth checking logic is all over xfsprogs.
> So, refactor the same code snippet into a single validation helper
> xfs_validate_stripe_factors(), including:
>  - integer overflows of either value
>  - sunit and swidth alignment wrt sector size
>  - if either sunit or swidth are zero, both should be zero
>  - swidth must be a multiple of sunit
> 
> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> ---
> 
> changes since v2:
>  - try to cover xfs_validate_sb_common() case as well suggested by Eric,
>    so move to libxfs as an attempt for review;
> 
>  - use an static inline helper in xfs_sb.h so compilers can do their
>    best to eliminate unneeded branches / rearrange code according to
>    each individual caller;
> 
>  - get back to use "int error" expression since it's compatible with
>    "enum xfs_stripeval" and it can be laterly reused for future uses
>    in these callers instead of introducing another error code variables;
> 
> just for review/comments for now, if it looks almost fine, I'd like to
> go further to stage up related functions to kernel.
> 
>  libfrog/topology.c | 15 +++++++++++
>  libxfs/xfs_sb.c    | 32 ++++++++++++++++--------
>  libxfs/xfs_sb.h    | 54 ++++++++++++++++++++++++++++++++++++++++
>  mkfs/xfs_mkfs.c    | 62 ++++++++++++++++++++++++----------------------
>  po/pl.po           |  4 +--
>  5 files changed, 124 insertions(+), 43 deletions(-)

Sorry this sat w/o review for a while... I'm going to kind of suggest a new
approach here, since this seems to have gotten rather complicated.

> diff --git a/libfrog/topology.c b/libfrog/topology.c
> index b1b470c9..554afbfc 100644
> --- a/libfrog/topology.c
> +++ b/libfrog/topology.c
> @@ -187,6 +187,7 @@ static void blkid_get_topology(
>  	blkid_probe pr;
>  	unsigned long val;
>  	struct stat statbuf;
> +	int error;
>  
>  	/* can't get topology info from a file */
>  	if (!stat(device, &statbuf) && S_ISREG(statbuf.st_mode)) {
> @@ -230,6 +231,20 @@ static void blkid_get_topology(
>  	*sunit = *sunit >> 9;
>  	*swidth = *swidth >> 9;
>  
> +	error = xfs_validate_stripe_factors(0, sunit, swidth);
> +	if (error) {
> +		fprintf(stderr,
> +_("%s: Volume reports invalid sunit (%d bytes) and swidth (%d bytes) %s, ignoring.\n"),
> +			progname, BBTOB(*sunit), BBTOB(*swidth),
> +			xfs_stripeval_str[error]);


> +		/*
> +		 * if firmware is broken, just give up and set both to zero,
> +		 * we can't trust information from this device.
> +		 */
> +		*sunit = 0;
> +		*swidth = 0;
> +	}
> +
>  	if (blkid_topology_get_alignment_offset(tp) != 0) {
>  		fprintf(stderr,
>  			_("warning: device is not properly aligned %s\n"),
> diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
> index d37d60b3..0c0f5f90 100644
> --- a/libxfs/xfs_sb.c
> +++ b/libxfs/xfs_sb.c
> @@ -210,6 +210,15 @@ xfs_validate_sb_write(
>  	return 0;
>  }
>  
> +const char *xfs_stripeval_str[] = {
> +	"OK",
> +	"SUNIT_MISALIGN",
> +	"SWIDTH_OVERFLOW",
> +	"PARTIAL_VALID",
> +	"SUNIT_TOO_LARGE",
> +	"SWIDTH_MISALIGN",
> +};
> +
>  /* Check the validity of the SB. */
>  STATIC int
>  xfs_validate_sb_common(
> @@ -220,6 +229,8 @@ xfs_validate_sb_common(
>  	struct xfs_dsb		*dsb = bp->b_addr;
>  	uint32_t		agcount = 0;
>  	uint32_t		rem;
> +	int			sunit, swidth;
> +	int			error;
>  
>  	if (!xfs_verify_magic(bp, dsb->sb_magicnum)) {
>  		xfs_warn(mp, "bad magic number");
> @@ -357,21 +368,20 @@ xfs_validate_sb_common(
>  		}
>  	}
>  
> -	if (sbp->sb_unit) {
> -		if (!xfs_sb_version_hasdalign(sbp) ||
> -		    sbp->sb_unit > sbp->sb_width ||
> -		    (sbp->sb_width % sbp->sb_unit) != 0) {
> -			xfs_notice(mp, "SB stripe unit sanity check failed");
> -			return -EFSCORRUPTED;
> -		}
> -	} else if (xfs_sb_version_hasdalign(sbp)) {
> +	sunit = sbp->sb_unit;
> +	swidth = sbp->sb_width;
> +
> +	if (!sunit ^ !xfs_sb_version_hasdalign(sbp)) {
>  		xfs_notice(mp, "SB stripe alignment sanity check failed");
>  		return -EFSCORRUPTED;
> -	} else if (sbp->sb_width) {
> -		xfs_notice(mp, "SB stripe width sanity check failed");
> -		return -EFSCORRUPTED;
>  	}
>  
> +	error = xfs_validate_stripe_factors(0, &sunit, &swidth);
> +	if (error) {
> +		xfs_notice(mp, "SB stripe sanity check failed %s",
> +				xfs_stripeval_str[error]);
> +		return -EFSCORRUPTED;
> +	}
>  
>  	if (xfs_sb_version_hascrc(&mp->m_sb) &&
>  	    sbp->sb_blocksize < XFS_MIN_CRC_BLOCKSIZE) {
> diff --git a/libxfs/xfs_sb.h b/libxfs/xfs_sb.h
> index 92465a9a..c4524bbc 100644
> --- a/libxfs/xfs_sb.h
> +++ b/libxfs/xfs_sb.h
> @@ -41,5 +41,59 @@ extern int	xfs_sb_read_secondary(struct xfs_mount *mp,
>  extern int	xfs_sb_get_secondary(struct xfs_mount *mp,
>  				struct xfs_trans *tp, xfs_agnumber_t agno,
>  				struct xfs_buf **bpp);
> +enum xfs_stripeval {
> +	XFS_STRIPEVAL_OK = 0,
> +	XFS_STRIPEVAL_SUNIT_MISALIGN,
> +	XFS_STRIPEVAL_SWIDTH_OVERFLOW,
> +	XFS_STRIPEVAL_PARTIAL_VALID,
> +	XFS_STRIPEVAL_SUNIT_TOO_LARGE,
> +	XFS_STRIPEVAL_SWIDTH_MISALIGN,
> +};
> +
> +extern const char *xfs_stripeval_str[];
> +
> +/*
> + * This accepts either
> + *  - (sectersize != 0) dsu (in bytes) / dsw (which is multiplier of dsu)
> + * or
> + *  - (sectersize == 0) sunit / swidth (in 512B sectors)
> + * and return sunit/swidth in sectors.
> + */

I'm still troubled by the complicated behavior of this function, even if it's
fully described in the comment.

What if this function:

* only accepts bytes, and does not convert sectors <-> bytes
  - i.e. callers should convert to bytes first

* directly prints the error using xfs_notice/warn() and an i8n'd _("...") string
  - this gets rid of enums & cases for strings, etc
  - kernelspace may need a #define to handle _("...")

* becomes a boolean and returns true (geom ok) or false (geom bad)
  - caller can print more context if needed, i.e. "Device returned bad geometry..."

* sectorsize check could be optional if we are calling from somewhere that
  does not need to or cannot validate against sector size (?)

> +static inline enum xfs_stripeval
> +xfs_validate_stripe_factors(
> +	int	sectorsize,
> +	int	*sunitp,
> +	int	*swidthp)
> +{
> +	int	sunit = *sunitp;
> +	int	swidth = *swidthp;
> +
> +	if (sectorsize) {
> +		long long	big_swidth;
> +
> +		if (sunit % sectorsize)
> +			return XFS_STRIPEVAL_SUNIT_MISALIGN;
> +
> +		sunit = (int)BTOBBT(sunit);
> +		big_swidth = (long long)sunit * swidth;
> +
> +		if (big_swidth > INT_MAX)
> +			return XFS_STRIPEVAL_SWIDTH_OVERFLOW;

I think this check can stay in mkfs.xfs, since it is the only place
that accepts an "sunit multiplier" - i.e. this could be more of a option
parse-time check than a strict geometry check.

> +		swidth = big_swidth;
> +	}
> +
> +	if ((sunit && !swidth) || (!sunit && swidth))
> +		return XFS_STRIPEVAL_PARTIAL_VALID;
> +
> +	if (sunit > swidth)
> +		return XFS_STRIPEVAL_SUNIT_TOO_LARGE;
> +
> +	if (sunit && (swidth % sunit))
> +		return XFS_STRIPEVAL_SWIDTH_MISALIGN;
> +
> +	*sunitp = sunit;
> +	*swidthp = swidth;
> +	return XFS_STRIPEVAL_OK;
> +}
>  
>  #endif	/* __XFS_SB_H__ */
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 2e6cd280..8fdf17d7 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -2255,7 +2255,6 @@ calc_stripe_factors(
>  	struct cli_params	*cli,
>  	struct fs_topology	*ft)
>  {
> -	long long int	big_dswidth;
>  	int		dsunit = 0;
>  	int		dswidth = 0;
>  	int		lsunit = 0;
> @@ -2263,6 +2262,7 @@ calc_stripe_factors(
>  	int		dsw = 0;
>  	int		lsu = 0;
>  	bool		use_dev = false;
> +	int		error;
>  
>  	if (cli_opt_set(&dopts, D_SUNIT))
>  		dsunit = cli->dsunit;
> @@ -2289,29 +2289,40 @@ _("both data su and data sw options must be specified\n"));
>  			usage();
>  		}
>  
> -		if (dsu % cfg->sectorsize) {
> -			fprintf(stderr,
> -_("data su must be a multiple of the sector size (%d)\n"), cfg->sectorsize);
> -			usage();
> -		}
This would still move to the core validator. If some callers do not have sectorsize,
the check could be conditional.

> -
> -		dsunit  = (int)BTOBBT(dsu);
> -		big_dswidth = (long long int)dsunit * dsw;
> -		if (big_dswidth > INT_MAX) {
> -			fprintf(stderr,
> -_("data stripe width (%lld) is too large of a multiple of the data stripe unit (%d)\n"),
> -				big_dswidth, dsunit);
> -			usage();
> -		}

I think this can stay here in mkfs, as a mkfs option validator rather than an actual
geometry validator, since it is the only placle that multiples the two.

So if we leave the multiplier checking in place above, then:

> -		dswidth = big_dswidth;
> +		dsunit = dsu;
> +		dswidth = dsw;
> +		error = xfs_validate_stripe_factors(cfg->sectorsize,
> +				&dsunit, &dswidth);

this call can go away, and we can just call xfs_validate_stripe_factors once,
with sunit and swidth in bytes and no conversion?

> +	} else {
> +		error = xfs_validate_stripe_factors(0, &dsunit, &dswidth);
>  	}


> -	if ((dsunit && !dswidth) || (!dsunit && dswidth) ||
> -	    (dsunit && (dswidth % dsunit != 0))) {
> +	switch (error) {
> +	case XFS_STRIPEVAL_OK:
> +		break;
> +	case XFS_STRIPEVAL_SUNIT_MISALIGN:
> +		fprintf(stderr,
> +_("data su must be a multiple of the sector size (%d)\n"), cfg->sectorsize);
> +		usage();
> +		break;
> +	case XFS_STRIPEVAL_SWIDTH_OVERFLOW:
> +		fprintf(stderr,
> +_("data stripe width (%d) is too large of a multiple of the data stripe unit (%d)\n"),
> +			dsw, dsunit);
> +		usage();
> +		break;
> +	case XFS_STRIPEVAL_PARTIAL_VALID:
> +	case XFS_STRIPEVAL_SWIDTH_MISALIGN:
>  		fprintf(stderr,
>  _("data stripe width (%d) must be a multiple of the data stripe unit (%d)\n"),
>  			dswidth, dsunit);
>  		usage();
> +		break;
> +	default:
> +		fprintf(stderr,
> +_("invalid data stripe unit (%d), width (%d) %s\n"),
> +			dsunit, dswidth, xfs_stripeval_str[error]);
> +		usage();

Then this case statement all goes away, and we can just do

	if (error)
		usage();

because xfs_validate_stripe_factors already printed the inoformation strings.

Does that make sense?  Does it seem like it would work?

Thanks,
-Eric

>  	}
>  
>  	/* If sunit & swidth were manually specified as 0, same as noalign */
> @@ -2328,18 +2339,9 @@ _("data stripe width (%d) must be a multiple of the data stripe unit (%d)\n"),
>  
>  	/* if no stripe config set, use the device default */
>  	if (!dsunit) {
> -		/* Ignore nonsense from device.  XXX add more validation */
> -		if (ft->dsunit && ft->dswidth == 0) {
> -			fprintf(stderr,
> -_("%s: Volume reports stripe unit of %d bytes and stripe width of 0, ignoring.\n"),
> -				progname, BBTOB(ft->dsunit));
> -			ft->dsunit = 0;
> -			ft->dswidth = 0;
> -		} else {
> -			dsunit = ft->dsunit;
> -			dswidth = ft->dswidth;
> -			use_dev = true;
> -		}
> +		dsunit = ft->dsunit;
> +		dswidth = ft->dswidth;
> +		use_dev = true;
>  	} else {
>  		/* check and warn if user-specified alignment is sub-optimal */
>  		if (ft->dsunit && ft->dsunit != dsunit) {
> diff --git a/po/pl.po b/po/pl.po
> index 87109f6b..02d2258f 100644
> --- a/po/pl.po
> +++ b/po/pl.po
> @@ -9085,10 +9085,10 @@ msgstr "su danych musi być wielokrotnością rozmiaru sektora (%d)\n"
>  #: .././mkfs/xfs_mkfs.c:2267
>  #, c-format
>  msgid ""
> -"data stripe width (%lld) is too large of a multiple of the data stripe unit "
> +"data stripe width (%d) is too large of a multiple of the data stripe unit "
>  "(%d)\n"
>  msgstr ""
> -"szerokość pasa danych (%lld) jest zbyt dużą wielokrotnością jednostki pasa "
> +"szerokość pasa danych (%d) jest zbyt dużą wielokrotnością jednostki pasa "
>  "danych (%d)\n"
>  
>  #: .././mkfs/xfs_mkfs.c:2276
> 
