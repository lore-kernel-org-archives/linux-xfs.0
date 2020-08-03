Return-Path: <SRS0=ns7q=BN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F064EC433E1
	for <linux-xfs@archiver.kernel.org>; Mon,  3 Aug 2020 15:45:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CC3C1207FB
	for <linux-xfs@archiver.kernel.org>; Mon,  3 Aug 2020 15:45:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gcEzxXKj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726825AbgHCPpr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 3 Aug 2020 11:45:47 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:52887 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726805AbgHCPpr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Aug 2020 11:45:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596469543;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VXbOCPN9NqqRPCB3KVI6w19e/RqccpwUbF9NPylWPJg=;
        b=gcEzxXKj7MN0Zf7yoY+7UBEv3j6XH4Fz7NWXkt07llrcddF8LYwUhvjWzMLujsFHSuzUYG
        6l9tVRfVSV6YCcJmX3fDUOEO4yzIR/I7VgHA+Ls4YSt0X9h0lfezj7Y/XQ9sVvbeVUfeqs
        Tkon7tcVlUf4YrfPng/0i28KT8JqjVo=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-73-lT2NZ-w0PW-g9kT-YFr3Jg-1; Mon, 03 Aug 2020 11:45:42 -0400
X-MC-Unique: lT2NZ-w0PW-g9kT-YFr3Jg-1
Received: by mail-pl1-f199.google.com with SMTP id f4so27920805plo.3
        for <linux-xfs@vger.kernel.org>; Mon, 03 Aug 2020 08:45:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=VXbOCPN9NqqRPCB3KVI6w19e/RqccpwUbF9NPylWPJg=;
        b=FTWGY0ADrB1VJZJs2TGI9vb1ql1iAXFbCkQw5/oZja0UQ06Tw8w3VV0vFWOT4NEsyU
         8xVQFdi6kk9WRyMbIPcYbZOYyy1yMRMukmP63kxwyesrjXZEPfGGwaNfZp8zx6pCyIZm
         Pa1mE1wvVItbVzN9835P44piz2CFB8lfCVMPbEq+MbtbeAc5tnlf9nhnVJm4CoE75cfb
         Y7Yzd4Zu17j3aw5BMUPbkbUQ72h6OGDAr618hWimq3bZ43KSznoRkdUXJCOmSjqw+Rxj
         C12pfKm2+O5h/RGrLOqRkVNAMVjfaw8tSwxUkkS+daAEWYhuG/jyr4U217Uh7NDCKHs4
         9pJA==
X-Gm-Message-State: AOAM530JfXL7MtRzSrtUMn311xi2/7J3HfQrsK2h1M/faUZC0B2RCkYO
        cqhhrGeTHKFl+BlyuLH3VV2cXTC31G6kETEsjO4S/5N1zFTsWn6NSk/oayXvw9TD+lzhA97Ybhh
        ul3JbxK0huuOKiJuMsyDB
X-Received: by 2002:a63:4545:: with SMTP id u5mr15123555pgk.229.1596469540788;
        Mon, 03 Aug 2020 08:45:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJypME1/4wBOyJW1irXnYoGiwiLTh3ZdL38nDru9jUI73HnxFGFx/bA3vqoijM1AmJV2i90oRA==
X-Received: by 2002:a63:4545:: with SMTP id u5mr15123522pgk.229.1596469540181;
        Mon, 03 Aug 2020 08:45:40 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id k8sm21426532pfu.68.2020.08.03.08.45.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2020 08:45:39 -0700 (PDT)
Date:   Mon, 3 Aug 2020 23:45:30 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] mkfs.xfs: introduce sunit/swidth validation helper
Message-ID: <20200803154530.GA7751@xiangao.remote.csb>
References: <a673fbd3-5038-2dc8-8135-a58c24042734@redhat.com>
 <20200803125018.16718-1-hsiangkao@redhat.com>
 <20200803152609.GA67818@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=gbk
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200803152609.GA67818@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Darrick,

On Mon, Aug 03, 2020 at 08:26:09AM -0700, Darrick J. Wong wrote:
> On Mon, Aug 03, 2020 at 08:50:18PM +0800, Gao Xiang wrote:
> > Currently stripe unit/width checking logic is all over xfsprogs.
> > So, refactor the same code snippet into a single validation helper
> > xfs_validate_stripe_factors(), including:
> >  - integer overflows of either value
> >  - sunit and swidth alignment wrt sector size
> >  - if either sunit or swidth are zero, both should be zero
> >  - swidth must be a multiple of sunit
> > 
> > Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> > ---
> > 
> > This patch follows Darrick's original suggestion [1], yet I'm
> > not sure if I'm doing the right thing or if something is still
> > missing (e.g the meaning of six(ish) places)... So post it
> > right now...
> > 
> > TBH, especially all these naming and the helper location (whether
> > in topology.c)...plus, click a dislike on calc_stripe_factors()
> > itself...
> > 
> > (Hopefully hear some advice about this... Thanks!)
> > 
> > [1] https://lore.kernel.org/r/20200515204802.GO6714@magnolia
> > 
> >  libfrog/topology.c | 50 ++++++++++++++++++++++++++++++++++++++++++++++
> >  libfrog/topology.h | 15 ++++++++++++++
> >  mkfs/xfs_mkfs.c    | 48 ++++++++++++++++++++++----------------------
> >  3 files changed, 89 insertions(+), 24 deletions(-)
> > 
> > diff --git a/libfrog/topology.c b/libfrog/topology.c
> > index b1b470c9..cf56fb03 100644
> > --- a/libfrog/topology.c
> > +++ b/libfrog/topology.c
> > @@ -174,6 +174,41 @@ out:
> >  	return ret;
> >  }
> >  
> > +enum xfs_stripe_retcode
> > +xfs_validate_stripe_factors(
> 
> libfrog functions (and enums) should be prefixed with libfrog, not xfs.
> 
> LIBFROG_STRIPEVAL_{OK,SUNIT_MISALIGN, etc.}
> 
> > +	int	sectorsize,
> > +	int 	*sup,
> 
> Errant space between "int" and "*sup".

Ack. Sorry about that.

> 
> > +	int	*swp)
> 
> Strange that a validator function has out parameters...
> 
> Also, uh, .... full names, please.

see the reasons below...

> 
> 	int	*sunitp,
> 	int	*swidthp)
> 
> (I'm vaguely wondering why we use signed ints here vs. unsigned, but
> that isn't critical...)

That is because I saw many previous "sunit/swidth" usage in the codebase
by using "int" rather than "unsigned int". I don't have much tendency
of this. (either form is ok with me since signed int is also enough here.)

> 
> > +{
> > +	int sunit = *sup, swidth = *swp;
> > +
> > +	if (sectorsize) {
> > +		long long	big_swidth;
> > +
> > +		if (sunit % sectorsize)
> > +			return XFS_STRIPE_RET_SUNIT_MISALIGN;
> > +
> > +		sunit = (int)BTOBBT(sunit);
> 
> Hmm.  On input, *sup is in units of bytes, but on output it can be in
> units of 512b blocks?  That is very surprising...

Yeah, It seems a bit weird at first. But I have no better idea
how to fulfill/wrap up "- sunit and swidth alignment wrt sector
size" check from the original thread in the validator helper.

So I finally implemented the helper in a form which accepts
either:
 [1] (sectersize != 0) dsu (in bytes) / dsw (which is multiple of dsu)

Or
 [2] (sectersize == 0) dunit / dwidth (in 512b sector size)

In [1], dsu and dsw would be turned into dunit / dwidth finally...


Yeah, that's my premature thought about this tho... hope for better
idea about this :)

> 
> > +		big_swidth = (long long)sunit * swidth;
> > +
> > +		if (big_swidth > INT_MAX)
> > +			return XFS_STRIPE_RET_SWIDTH_OVERFLOW;
> > +		swidth = big_swidth;
> > +	}
> > +	if ((sunit && !swidth) || (!sunit && swidth))
> > +		return XFS_STRIPE_RET_PARTIAL_VALID;
> > +
> > +	if (sunit > swidth)
> > +		return XFS_STRIPE_RET_SUNIT_TOO_LARGE;
> > +
> > +	if (sunit && (swidth % sunit))
> > +		return XFS_STRIPE_RET_SWIDTH_MISALIGN;
> > +
> > +	*sup = sunit;
> 
> ...especially since in the !sectorsize case we don't change it at all.

Yeah...

> 
> > +	*swp = swidth;
> > +	return XFS_STRIPE_RET_OK;
> > +}
> > +
> >  static void blkid_get_topology(
> >  	const char	*device,
> >  	int		*sunit,
> > @@ -229,6 +264,21 @@ static void blkid_get_topology(
> >  	 */
> >  	*sunit = *sunit >> 9;
> >  	*swidth = *swidth >> 9;
> > +	switch (xfs_validate_stripe_factors(0, sunit, swidth)) {
> > +	case XFS_STRIPE_RET_OK:
> > +		break;
> > +	case XFS_STRIPE_RET_PARTIAL_VALID:
> > +		fprintf(stderr,
> > +_("%s: Volume reports stripe unit of %d bytes and stripe width of %d bytes, ignoring.\n"),
> > +				progname, BBTOB(*sunit), BBTOB(*swidth));
> 
> Needs a "/* fallthrough */" comment here.

Ack.

> 
> > +	default:
> 
> Why don't we warn about receiving garbage geometry that produces
> MISALIGN or OVERFLOW?

Okay, I could add them in the next version...
Yet I still suspect my broken English works... :)

> 
> > +		/*
> > +		 * if firmware is broken, just give up and set both to zero,
> > +		 * we can't trust information from this device.
> > +		 */
> > +		*sunit = 0;
> > +		*swidth = 0;
> > +	}
> >  
> >  	if (blkid_topology_get_alignment_offset(tp) != 0) {
> >  		fprintf(stderr,
> > diff --git a/libfrog/topology.h b/libfrog/topology.h
> > index 6fde868a..e8be26b2 100644
> > --- a/libfrog/topology.h
> > +++ b/libfrog/topology.h
> > @@ -36,4 +36,19 @@ extern int
> >  check_overwrite(
> >  	const char	*device);
> >  
> > +enum xfs_stripe_retcode {
> > +	XFS_STRIPE_RET_OK = 0,
> > +	XFS_STRIPE_RET_SUNIT_MISALIGN,
> > +	XFS_STRIPE_RET_SWIDTH_OVERFLOW,
> > +	XFS_STRIPE_RET_PARTIAL_VALID,
> > +	XFS_STRIPE_RET_SUNIT_TOO_LARGE,
> > +	XFS_STRIPE_RET_SWIDTH_MISALIGN,
> > +};
> > +
> > +enum xfs_stripe_retcode
> > +xfs_validate_stripe_factors(
> > +	int	sectorsize,
> > +	int 	*sup,
> 
> Errant space between "int" and "*sup".

Sorry, copy again.

> 
> > +	int	*swp);
> > +
> >  #endif	/* __LIBFROG_TOPOLOGY_H__ */
> > diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> > index 2e6cd280..a3d6032c 100644
> > --- a/mkfs/xfs_mkfs.c
> > +++ b/mkfs/xfs_mkfs.c
> > @@ -2255,7 +2255,6 @@ calc_stripe_factors(
> >  	struct cli_params	*cli,
> >  	struct fs_topology	*ft)
> >  {
> > -	long long int	big_dswidth;
> >  	int		dsunit = 0;
> >  	int		dswidth = 0;
> >  	int		lsunit = 0;
> > @@ -2263,6 +2262,7 @@ calc_stripe_factors(
> >  	int		dsw = 0;
> >  	int		lsu = 0;
> >  	bool		use_dev = false;
> > +	int		error;
> >  
> >  	if (cli_opt_set(&dopts, D_SUNIT))
> >  		dsunit = cli->dsunit;
> > @@ -2289,31 +2289,40 @@ _("both data su and data sw options must be specified\n"));
> >  			usage();
> >  		}
> >  
> > -		if (dsu % cfg->sectorsize) {
> > +		dsunit = dsu;
> > +		dswidth = dsw;
> > +		error = xfs_validate_stripe_factors(cfg->sectorsize, &dsunit, &dswidth);
> 
> I thought this function returned an enum?

okay, will update in the next version.

> 
> > +		switch(error) {
> > +		case XFS_STRIPE_RET_SUNIT_MISALIGN:
> >  			fprintf(stderr,
> >  _("data su must be a multiple of the sector size (%d)\n"), cfg->sectorsize);
> >  			usage();
> > -		}
> > -
> > -		dsunit  = (int)BTOBBT(dsu);
> > -		big_dswidth = (long long int)dsunit * dsw;
> > -		if (big_dswidth > INT_MAX) {
> > +			break;
> > +		case XFS_STRIPE_RET_SWIDTH_OVERFLOW:
> >  			fprintf(stderr,
> > -_("data stripe width (%lld) is too large of a multiple of the data stripe unit (%d)\n"),
> > -				big_dswidth, dsunit);
> > +_("data stripe width (dsw %d) is too large of a multiple of the data stripe unit (%d)\n"),
> 
> Why change this message?

big_dswidth isn't defined here.
So I'm not sure if the original message can still be properly used here.
(I could leave it alone...)

> 
> > +				dsw, dsunit);
> >  			usage();
> > +			break;
> >  		}
> > -		dswidth = big_dswidth;
> > +	} else {
> > +		error = xfs_validate_stripe_factors(0, &dsunit, &dswidth);
> >  	}
> >  
> > -	if ((dsunit && !dswidth) || (!dsunit && dswidth) ||
> > -	    (dsunit && (dswidth % dsunit != 0))) {
> > +	if (error == XFS_STRIPE_RET_PARTIAL_VALID ||
> > +	    error == XFS_STRIPE_RET_SWIDTH_MISALIGN) {
> >  		fprintf(stderr,
> >  _("data stripe width (%d) must be a multiple of the data stripe unit (%d)\n"),
> >  			dswidth, dsunit);
> >  		usage();
> >  	}
> >  
> > +	if (error) {
> > +		fprintf(stderr,
> > +_("invalid data stripe unit (%d), width (%d)\n"), dsunit, dswidth);
> 
> Invalid how?  We know the exact reason, so we should say so.

Okay, let me think more about some cleaner way for these message.
I feel it could be a bit messy here.

Thanks£¬
Gao Xiang

> 
> --D
> 
> > +		usage();
> > +	}
> > +
> >  	/* If sunit & swidth were manually specified as 0, same as noalign */
> >  	if ((cli_opt_set(&dopts, D_SUNIT) || cli_opt_set(&dopts, D_SU)) &&
> >  	    !dsunit && !dswidth)
> > @@ -2328,18 +2337,9 @@ _("data stripe width (%d) must be a multiple of the data stripe unit (%d)\n"),
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
> > -- 
> > 2.18.1
> > 
> 

