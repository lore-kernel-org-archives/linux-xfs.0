Return-Path: <SRS0=OnOM=BO=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	T_TVD_FUZZY_SECTOR,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94A6BC433E0
	for <linux-xfs@archiver.kernel.org>; Tue,  4 Aug 2020 23:44:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6EF8D20792
	for <linux-xfs@archiver.kernel.org>; Tue,  4 Aug 2020 23:44:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gSPXWF2V"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727003AbgHDXoQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 4 Aug 2020 19:44:16 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:40144 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726643AbgHDXoP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Aug 2020 19:44:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596584652;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OQAhzJpJNCfyVygb7pzKkOSDI1+MZSeIRosEJywW+EI=;
        b=gSPXWF2VGv/CwXmYb7kJedogUf791nfC9CL8m9xA73FfK6SY1QLnk8WOfYZyr6U0MbZczz
        ocE/nKgBcjb7V9wEJyuGmWp8Q1l09NJBCVFVRGsmIP5AML9ugxGc51Z3CRDj9za6RuzRgK
        sIb52KAYL4fNtjnuEEPSy4T/RXSKBmU=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-493-W07sr6rGNi2W7EML-XHsUA-1; Tue, 04 Aug 2020 19:44:11 -0400
X-MC-Unique: W07sr6rGNi2W7EML-XHsUA-1
Received: by mail-pg1-f200.google.com with SMTP id h2so29900618pgc.19
        for <linux-xfs@vger.kernel.org>; Tue, 04 Aug 2020 16:44:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=OQAhzJpJNCfyVygb7pzKkOSDI1+MZSeIRosEJywW+EI=;
        b=Rs1oaRl/Ec9d3TqARh3q1HD8XkoBXH+qpIQWS0EzKpTVdza9YPkpbGVhJYEHTkA4TP
         bWyyX/r1kv5QlsMZWMNKWdxL/VOlUGUoJz+wSdXw+jMuft63ViT0Gad4/uQpN1jr87mK
         vR3Fz6dlFe7/4upVkglsUc89N8myPld24uElLvXERvFZVHbmbIOOh8IBMJPW51WqETRx
         yBzm/nvcLfo3nIdFz+9A0iUuCq0rrOJY7eZIuMVm8lgj4WR2QrXwdJyP5J4JjMkdKDdF
         GbPRvdfEuOvfql3ENL3JtHMbPYU48kE4QewrC2ppQhjaNLWXs9d+9lnpbHp+lVQdwZyY
         tasw==
X-Gm-Message-State: AOAM530iolXSD9N1qCwZvANKf/BgHUAJeCqNJSfeg4bTF6OGFTdHMOLv
        e+wyLnlbU6hsrOjSBWec7oVAVA6UegV170FEWE044viwTkVNF1kV8uzpUSMn3ntYBaG+UgPH4vY
        PtvMCvWs8X++IT/3y3evn
X-Received: by 2002:a62:7acb:: with SMTP id v194mr724982pfc.302.1596584649831;
        Tue, 04 Aug 2020 16:44:09 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy7HqU4Cycbcqe/ltO8DVo0099d7l6v/9lfMyRmhH9J+327OdVJzODNJZ2l4BixRYvH6PuEWQ==
X-Received: by 2002:a62:7acb:: with SMTP id v194mr724955pfc.302.1596584649336;
        Tue, 04 Aug 2020 16:44:09 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id s8sm239578pju.54.2020.08.04.16.44.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2020 16:44:08 -0700 (PDT)
Date:   Wed, 5 Aug 2020 07:43:58 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH v2] mkfs.xfs: introduce sunit/swidth validation helper
Message-ID: <20200804234358.GA11753@xiangao.remote.csb>
References: <20200803125018.16718-1-hsiangkao@redhat.com>
 <20200804160015.17330-1-hsiangkao@redhat.com>
 <879f4ac3-4c1f-1890-4be2-04ade8c1e56b@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8\""
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <879f4ac3-4c1f-1890-4be2-04ade8c1e56b@sandeen.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Eric,

On Tue, Aug 04, 2020 at 12:55:43PM -0700, Eric Sandeen wrote:
> On 8/4/20 9:00 AM, Gao Xiang wrote:
> > Currently stripe unit/swidth checking logic is all over xfsprogs.
> > So, refactor the same code snippet into a single validation helper
> > xfs_validate_stripe_factors(), including:
> >  - integer overflows of either value
> >  - sunit and swidth alignment wrt sector size
> >  - if either sunit or swidth are zero, both should be zero
> >  - swidth must be a multiple of sunit
> > 
> > Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> > ---
> > changes since v1:
> >  - several update (errant space, full names...) suggested by Darrick;
> >  - rearrange into a unique handler in calc_stripe_factors();
> >  - add libfrog_stripeval_str[] yet I'm not sure if it needs localization;
> >  - update po translalation due to (%lld type -> %d).
> > 
> > (I'd still like to post it in advance...)
> 
> Sorry for not commenting sooner.
> 
> I wonder - would it be possible to factor out a stripe value validation
> helper from xfs_validate_sb_common() in libxfs/xfs_sb.c, so that this
> could be called from userspace too?
> 
> It is a bit different because kernelspace checks against whether the
> superblock has XFS_SB_VERSION_DALIGNBIT set, and that makes no sense
> in i.e. blkid_get_topology.

Ah, sorry for not noticing that code snippet.

I think dalign check could be outside this helper since it doesn't
need to be considered for the other userspace callers (e.g. if considering
passing in it, it seems needing 2 extra arguments (has_dalign_check and
isdalign and it seems uncessary)?

maybe such condition can be simplified in a line in the
xfs_validate_sb_common() as
	if (!sbp->sb_unit ^ !xfs_sb_version_hasdalign(sbp)) {
		...
		return -FSCURRUPTTED;
	}


> 
> On the other hand, the code below currently checks against sector size,
> which seems to be something that kernelspace does not do currently
> (but it probably could).

It seems that it doesn't matter since we could pass (sectorsize == 0)
and use sunit/swidth rather than the specfic dsu/dsw argument approach
to skip the related check.

> 
> Doing all of this checking in a common location in libxfs for
> both userspace and kernelspace seems like it would be a good goal.

I will try to fold xfs_validate_sb_common() case (in xfsprogs first
for review), the prefix should be xfs_ then?

Thanks,
Gao Xiang

> 
> Thoughts?
> 
> -Eric
> 
> >  libfrog/topology.c | 68 +++++++++++++++++++++++++++++++++++++++++
> >  libfrog/topology.h | 17 +++++++++++
> >  mkfs/xfs_mkfs.c    | 76 ++++++++++++++++++++++++----------------------
> >  po/pl.po           |  4 +--
> >  4 files changed, 126 insertions(+), 39 deletions(-)
> > 
> > diff --git a/libfrog/topology.c b/libfrog/topology.c
> > index b1b470c9..1ce151fd 100644
> > --- a/libfrog/topology.c
> > +++ b/libfrog/topology.c
> > @@ -174,6 +174,59 @@ out:
> >  	return ret;
> >  }
> >  
> > +/*
> > + * This accepts either
> > + *  - (sectersize != 0) dsu (in bytes) / dsw (which is mulplier of dsu)
> > + * or
> > + *  - (sectersize == 0) dunit / dwidth (in 512b sector size)
> > + * and return sunit/swidth in sectors.
> > + */
> > +enum libfrog_stripeval
> > +libfrog_validate_stripe_factors(
> > +	int	sectorsize,
> > +	int	*sunitp,
> > +	int	*swidthp)
> > +{
> > +	int	sunit = *sunitp;
> > +	int	swidth = *swidthp;
> > +
> > +	if (sectorsize) {
> > +		long long	big_swidth;
> > +
> > +		if (sunit % sectorsize)
> > +			return LIBFROG_STRIPEVAL_SUNIT_MISALIGN;
> > +
> > +		sunit = (int)BTOBBT(sunit);
> > +		big_swidth = (long long)sunit * swidth;
> > +
> > +		if (big_swidth > INT_MAX)
> > +			return LIBFROG_STRIPEVAL_SWIDTH_OVERFLOW;
> > +		swidth = big_swidth;
> > +	}
> > +
> > +	if ((sunit && !swidth) || (!sunit && swidth))
> > +		return LIBFROG_STRIPEVAL_PARTIAL_VALID;
> > +
> > +	if (sunit > swidth)
> > +		return LIBFROG_STRIPEVAL_SUNIT_TOO_LARGE;
> > +
> > +	if (sunit && (swidth % sunit))
> > +		return LIBFROG_STRIPEVAL_SWIDTH_MISALIGN;
> > +
> > +	*sunitp = sunit;
> > +	*swidthp = swidth;
> > +	return LIBFROG_STRIPEVAL_OK;
> > +}
> > +
> > +const char *libfrog_stripeval_str[] = {
> > +	"OK",
> > +	"SUNIT_MISALIGN",
> > +	"SWIDTH_OVERFLOW",
> > +	"PARTIAL_VALID",
> > +	"SUNIT_TOO_LARGE",
> > +	"SWIDTH_MISALIGN",
> > +};
> > +
> >  static void blkid_get_topology(
> >  	const char	*device,
> >  	int		*sunit,
> > @@ -187,6 +240,7 @@ static void blkid_get_topology(
> >  	blkid_probe pr;
> >  	unsigned long val;
> >  	struct stat statbuf;
> > +	enum libfrog_stripeval error;
> >  
> >  	/* can't get topology info from a file */
> >  	if (!stat(device, &statbuf) && S_ISREG(statbuf.st_mode)) {
> > @@ -230,6 +284,20 @@ static void blkid_get_topology(
> >  	*sunit = *sunit >> 9;
> >  	*swidth = *swidth >> 9;
> >  
> > +	error = libfrog_validate_stripe_factors(0, sunit, swidth);
> > +	if (error) {
> > +		fprintf(stderr,
> > +_("%s: Volume reports invalid sunit (%d bytes) and swidth (%d bytes) %s, ignoring.\n"),
> > +			progname, BBTOB(*sunit), BBTOB(*swidth),
> > +			libfrog_stripeval_str[error]);
> > +		/*
> > +		 * if firmware is broken, just give up and set both to zero,
> > +		 * we can't trust information from this device.
> > +		 */
> > +		*sunit = 0;
> > +		*swidth = 0;
> > +	}
> > +
> >  	if (blkid_topology_get_alignment_offset(tp) != 0) {
> >  		fprintf(stderr,
> >  			_("warning: device is not properly aligned %s\n"),
> > diff --git a/libfrog/topology.h b/libfrog/topology.h
> > index 6fde868a..507fe121 100644
> > --- a/libfrog/topology.h
> > +++ b/libfrog/topology.h
> > @@ -36,4 +36,21 @@ extern int
> >  check_overwrite(
> >  	const char	*device);
> >  
> > +enum libfrog_stripeval {
> > +	LIBFROG_STRIPEVAL_OK = 0,
> > +	LIBFROG_STRIPEVAL_SUNIT_MISALIGN,
> > +	LIBFROG_STRIPEVAL_SWIDTH_OVERFLOW,
> > +	LIBFROG_STRIPEVAL_PARTIAL_VALID,
> > +	LIBFROG_STRIPEVAL_SUNIT_TOO_LARGE,
> > +	LIBFROG_STRIPEVAL_SWIDTH_MISALIGN,
> > +};
> > +
> > +extern const char *libfrog_stripeval_str[];
> > +
> > +enum libfrog_stripeval
> > +libfrog_validate_stripe_factors(
> > +	int	sectorsize,
> > +	int	*sunitp,
> > +	int	*swidthp);
> > +
> >  #endif	/* __LIBFROG_TOPOLOGY_H__ */
> > diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> > index 2e6cd280..f7b38b36 100644
> > --- a/mkfs/xfs_mkfs.c
> > +++ b/mkfs/xfs_mkfs.c
> > @@ -2255,14 +2255,14 @@ calc_stripe_factors(
> >  	struct cli_params	*cli,
> >  	struct fs_topology	*ft)
> >  {
> > -	long long int	big_dswidth;
> > -	int		dsunit = 0;
> > -	int		dswidth = 0;
> > -	int		lsunit = 0;
> > -	int		dsu = 0;
> > -	int		dsw = 0;
> > -	int		lsu = 0;
> > -	bool		use_dev = false;
> > +	int			dsunit = 0;
> > +	int			dswidth = 0;
> > +	int			lsunit = 0;
> > +	int			dsu = 0;
> > +	int			dsw = 0;
> > +	int			lsu = 0;
> > +	bool			use_dev = false;
> > +	enum libfrog_stripeval	error;
> >  
> >  	if (cli_opt_set(&dopts, D_SUNIT))
> >  		dsunit = cli->dsunit;
> > @@ -2289,29 +2289,40 @@ _("both data su and data sw options must be specified\n"));
> >  			usage();
> >  		}
> >  
> > -		if (dsu % cfg->sectorsize) {
> > -			fprintf(stderr,
> > -_("data su must be a multiple of the sector size (%d)\n"), cfg->sectorsize);
> > -			usage();
> > -		}
> > -
> > -		dsunit  = (int)BTOBBT(dsu);
> > -		big_dswidth = (long long int)dsunit * dsw;
> > -		if (big_dswidth > INT_MAX) {
> > -			fprintf(stderr,
> > -_("data stripe width (%lld) is too large of a multiple of the data stripe unit (%d)\n"),
> > -				big_dswidth, dsunit);
> > -			usage();
> > -		}
> > -		dswidth = big_dswidth;
> > +		dsunit = dsu;
> > +		dswidth = dsw;
> > +		error = libfrog_validate_stripe_factors(cfg->sectorsize,
> > +				&dsunit, &dswidth);
> > +	} else {
> > +		error = libfrog_validate_stripe_factors(0, &dsunit, &dswidth);
> >  	}
> >  
> > -	if ((dsunit && !dswidth) || (!dsunit && dswidth) ||
> > -	    (dsunit && (dswidth % dsunit != 0))) {
> > +	switch (error) {
> > +	case LIBFROG_STRIPEVAL_OK:
> > +		break;
> > +	case LIBFROG_STRIPEVAL_SUNIT_MISALIGN:
> > +		fprintf(stderr,
> > +_("data su must be a multiple of the sector size (%d)\n"), cfg->sectorsize);
> > +		usage();
> > +		break;
> > +	case LIBFROG_STRIPEVAL_SWIDTH_OVERFLOW:
> > +		fprintf(stderr,
> > +_("data stripe width (%d) is too large of a multiple of the data stripe unit (%d)\n"),
> > +			dsw, dsunit);
> > +		usage();
> > +		break;
> > +	case LIBFROG_STRIPEVAL_PARTIAL_VALID:
> > +	case LIBFROG_STRIPEVAL_SWIDTH_MISALIGN:
> >  		fprintf(stderr,
> >  _("data stripe width (%d) must be a multiple of the data stripe unit (%d)\n"),
> >  			dswidth, dsunit);
> >  		usage();
> > +		break;
> > +	default:
> > +		fprintf(stderr,
> > +_("invalid data stripe unit (%d), width (%d) %s\n"),
> > +			dsunit, dswidth, libfrog_stripeval_str[error]);
> > +		usage();
> >  	}
> >  
> >  	/* If sunit & swidth were manually specified as 0, same as noalign */
> > @@ -2328,18 +2339,9 @@ _("data stripe width (%d) must be a multiple of the data stripe unit (%d)\n"),
> >  
> >  	/* if no stripe config set, use the device default */
> >  	if (!dsunit) {
> > -		/* Ignore nonsense from device.  XXX add more validation */
> > -		if (ft->dsunit && ft->dswidth == 0) {
> > -			fprintf(stderr,
> > -_("%s: Volume reports stripe unit of %d bytes and stripe width of 0, ignoring.\n"),
> > -				progname, BBTOB(ft->dsunit));
> > -			ft->dsunit = 0;
> > -			ft->dswidth = 0;
> > -		} else {
> > -			dsunit = ft->dsunit;
> > -			dswidth = ft->dswidth;
> > -			use_dev = true;
> > -		}
> > +		dsunit = ft->dsunit;
> > +		dswidth = ft->dswidth;
> > +		use_dev = true;
> >  	} else {
> >  		/* check and warn if user-specified alignment is sub-optimal */
> >  		if (ft->dsunit && ft->dsunit != dsunit) {
> > diff --git a/po/pl.po b/po/pl.po
> > index 87109f6b..02d2258f 100644
> > --- a/po/pl.po
> > +++ b/po/pl.po
> > @@ -9085,10 +9085,10 @@ msgstr "su danych musi być wielokrotnością rozmiaru sektora (%d)\n"
> >  #: .././mkfs/xfs_mkfs.c:2267
> >  #, c-format
> >  msgid ""
> > -"data stripe width (%lld) is too large of a multiple of the data stripe unit "
> > +"data stripe width (%d) is too large of a multiple of the data stripe unit "
> >  "(%d)\n"
> >  msgstr ""
> > -"szerokość pasa danych (%lld) jest zbyt dużą wielokrotnością jednostki pasa "
> > +"szerokość pasa danych (%d) jest zbyt dużą wielokrotnością jednostki pasa "
> >  "danych (%d)\n"
> >  
> >  #: .././mkfs/xfs_mkfs.c:2276
> > 
> 

