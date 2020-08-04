Return-Path: <SRS0=OnOM=BO=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,T_TVD_FUZZY_SECTOR,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A3EBC433DF
	for <linux-xfs@archiver.kernel.org>; Tue,  4 Aug 2020 19:55:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 50B7F20842
	for <linux-xfs@archiver.kernel.org>; Tue,  4 Aug 2020 19:55:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728502AbgHDTzr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 4 Aug 2020 15:55:47 -0400
Received: from sandeen.net ([63.231.237.45]:42372 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726090AbgHDTzr (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 4 Aug 2020 15:55:47 -0400
Received: from Liberator.local (c-71-237-195-212.hsd1.or.comcast.net [71.237.195.212])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 4ABEF48C7AE;
        Tue,  4 Aug 2020 14:54:43 -0500 (CDT)
Subject: Re: [PATCH v2] mkfs.xfs: introduce sunit/swidth validation helper
To:     Gao Xiang <hsiangkao@redhat.com>,
        linux-xfs <linux-xfs@vger.kernel.org>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eric Sandeen <sandeen@redhat.com>
References: <20200803125018.16718-1-hsiangkao@redhat.com>
 <20200804160015.17330-1-hsiangkao@redhat.com>
From:   Eric Sandeen <sandeen@sandeen.net>
Autocrypt: addr=sandeen@sandeen.net; prefer-encrypt=mutual; keydata=
 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 pA==
Message-ID: <879f4ac3-4c1f-1890-4be2-04ade8c1e56b@sandeen.net>
Date:   Tue, 4 Aug 2020 12:55:43 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200804160015.17330-1-hsiangkao@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 8/4/20 9:00 AM, Gao Xiang wrote:
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
> changes since v1:
>  - several update (errant space, full names...) suggested by Darrick;
>  - rearrange into a unique handler in calc_stripe_factors();
>  - add libfrog_stripeval_str[] yet I'm not sure if it needs localization;
>  - update po translalation due to (%lld type -> %d).
> 
> (I'd still like to post it in advance...)

Sorry for not commenting sooner.

I wonder - would it be possible to factor out a stripe value validation
helper from xfs_validate_sb_common() in libxfs/xfs_sb.c, so that this
could be called from userspace too?

It is a bit different because kernelspace checks against whether the
superblock has XFS_SB_VERSION_DALIGNBIT set, and that makes no sense
in i.e. blkid_get_topology.

On the other hand, the code below currently checks against sector size,
which seems to be something that kernelspace does not do currently
(but it probably could).

Doing all of this checking in a common location in libxfs for
both userspace and kernelspace seems like it would be a good goal.

Thoughts?

-Eric

>  libfrog/topology.c | 68 +++++++++++++++++++++++++++++++++++++++++
>  libfrog/topology.h | 17 +++++++++++
>  mkfs/xfs_mkfs.c    | 76 ++++++++++++++++++++++++----------------------
>  po/pl.po           |  4 +--
>  4 files changed, 126 insertions(+), 39 deletions(-)
> 
> diff --git a/libfrog/topology.c b/libfrog/topology.c
> index b1b470c9..1ce151fd 100644
> --- a/libfrog/topology.c
> +++ b/libfrog/topology.c
> @@ -174,6 +174,59 @@ out:
>  	return ret;
>  }
>  
> +/*
> + * This accepts either
> + *  - (sectersize != 0) dsu (in bytes) / dsw (which is mulplier of dsu)
> + * or
> + *  - (sectersize == 0) dunit / dwidth (in 512b sector size)
> + * and return sunit/swidth in sectors.
> + */
> +enum libfrog_stripeval
> +libfrog_validate_stripe_factors(
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
> +			return LIBFROG_STRIPEVAL_SUNIT_MISALIGN;
> +
> +		sunit = (int)BTOBBT(sunit);
> +		big_swidth = (long long)sunit * swidth;
> +
> +		if (big_swidth > INT_MAX)
> +			return LIBFROG_STRIPEVAL_SWIDTH_OVERFLOW;
> +		swidth = big_swidth;
> +	}
> +
> +	if ((sunit && !swidth) || (!sunit && swidth))
> +		return LIBFROG_STRIPEVAL_PARTIAL_VALID;
> +
> +	if (sunit > swidth)
> +		return LIBFROG_STRIPEVAL_SUNIT_TOO_LARGE;
> +
> +	if (sunit && (swidth % sunit))
> +		return LIBFROG_STRIPEVAL_SWIDTH_MISALIGN;
> +
> +	*sunitp = sunit;
> +	*swidthp = swidth;
> +	return LIBFROG_STRIPEVAL_OK;
> +}
> +
> +const char *libfrog_stripeval_str[] = {
> +	"OK",
> +	"SUNIT_MISALIGN",
> +	"SWIDTH_OVERFLOW",
> +	"PARTIAL_VALID",
> +	"SUNIT_TOO_LARGE",
> +	"SWIDTH_MISALIGN",
> +};
> +
>  static void blkid_get_topology(
>  	const char	*device,
>  	int		*sunit,
> @@ -187,6 +240,7 @@ static void blkid_get_topology(
>  	blkid_probe pr;
>  	unsigned long val;
>  	struct stat statbuf;
> +	enum libfrog_stripeval error;
>  
>  	/* can't get topology info from a file */
>  	if (!stat(device, &statbuf) && S_ISREG(statbuf.st_mode)) {
> @@ -230,6 +284,20 @@ static void blkid_get_topology(
>  	*sunit = *sunit >> 9;
>  	*swidth = *swidth >> 9;
>  
> +	error = libfrog_validate_stripe_factors(0, sunit, swidth);
> +	if (error) {
> +		fprintf(stderr,
> +_("%s: Volume reports invalid sunit (%d bytes) and swidth (%d bytes) %s, ignoring.\n"),
> +			progname, BBTOB(*sunit), BBTOB(*swidth),
> +			libfrog_stripeval_str[error]);
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
> diff --git a/libfrog/topology.h b/libfrog/topology.h
> index 6fde868a..507fe121 100644
> --- a/libfrog/topology.h
> +++ b/libfrog/topology.h
> @@ -36,4 +36,21 @@ extern int
>  check_overwrite(
>  	const char	*device);
>  
> +enum libfrog_stripeval {
> +	LIBFROG_STRIPEVAL_OK = 0,
> +	LIBFROG_STRIPEVAL_SUNIT_MISALIGN,
> +	LIBFROG_STRIPEVAL_SWIDTH_OVERFLOW,
> +	LIBFROG_STRIPEVAL_PARTIAL_VALID,
> +	LIBFROG_STRIPEVAL_SUNIT_TOO_LARGE,
> +	LIBFROG_STRIPEVAL_SWIDTH_MISALIGN,
> +};
> +
> +extern const char *libfrog_stripeval_str[];
> +
> +enum libfrog_stripeval
> +libfrog_validate_stripe_factors(
> +	int	sectorsize,
> +	int	*sunitp,
> +	int	*swidthp);
> +
>  #endif	/* __LIBFROG_TOPOLOGY_H__ */
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 2e6cd280..f7b38b36 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -2255,14 +2255,14 @@ calc_stripe_factors(
>  	struct cli_params	*cli,
>  	struct fs_topology	*ft)
>  {
> -	long long int	big_dswidth;
> -	int		dsunit = 0;
> -	int		dswidth = 0;
> -	int		lsunit = 0;
> -	int		dsu = 0;
> -	int		dsw = 0;
> -	int		lsu = 0;
> -	bool		use_dev = false;
> +	int			dsunit = 0;
> +	int			dswidth = 0;
> +	int			lsunit = 0;
> +	int			dsu = 0;
> +	int			dsw = 0;
> +	int			lsu = 0;
> +	bool			use_dev = false;
> +	enum libfrog_stripeval	error;
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
> -
> -		dsunit  = (int)BTOBBT(dsu);
> -		big_dswidth = (long long int)dsunit * dsw;
> -		if (big_dswidth > INT_MAX) {
> -			fprintf(stderr,
> -_("data stripe width (%lld) is too large of a multiple of the data stripe unit (%d)\n"),
> -				big_dswidth, dsunit);
> -			usage();
> -		}
> -		dswidth = big_dswidth;
> +		dsunit = dsu;
> +		dswidth = dsw;
> +		error = libfrog_validate_stripe_factors(cfg->sectorsize,
> +				&dsunit, &dswidth);
> +	} else {
> +		error = libfrog_validate_stripe_factors(0, &dsunit, &dswidth);
>  	}
>  
> -	if ((dsunit && !dswidth) || (!dsunit && dswidth) ||
> -	    (dsunit && (dswidth % dsunit != 0))) {
> +	switch (error) {
> +	case LIBFROG_STRIPEVAL_OK:
> +		break;
> +	case LIBFROG_STRIPEVAL_SUNIT_MISALIGN:
> +		fprintf(stderr,
> +_("data su must be a multiple of the sector size (%d)\n"), cfg->sectorsize);
> +		usage();
> +		break;
> +	case LIBFROG_STRIPEVAL_SWIDTH_OVERFLOW:
> +		fprintf(stderr,
> +_("data stripe width (%d) is too large of a multiple of the data stripe unit (%d)\n"),
> +			dsw, dsunit);
> +		usage();
> +		break;
> +	case LIBFROG_STRIPEVAL_PARTIAL_VALID:
> +	case LIBFROG_STRIPEVAL_SWIDTH_MISALIGN:
>  		fprintf(stderr,
>  _("data stripe width (%d) must be a multiple of the data stripe unit (%d)\n"),
>  			dswidth, dsunit);
>  		usage();
> +		break;
> +	default:
> +		fprintf(stderr,
> +_("invalid data stripe unit (%d), width (%d) %s\n"),
> +			dsunit, dswidth, libfrog_stripeval_str[error]);
> +		usage();
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
