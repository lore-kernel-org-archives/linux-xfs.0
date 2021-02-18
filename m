Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13B29C433E6
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 02:43:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DA5EF64E15
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 02:43:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229806AbhBRCnm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 17 Feb 2021 21:43:42 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:35499 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229803AbhBRCnl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 17 Feb 2021 21:43:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613616133;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XGH2fNCvGeQj+KR360UnueDimtSWrY7sM/x29Fa6DSw=;
        b=OM3Aq53sKMrlK27gaJp810VfM+aynchRGxpB+nh6WApFeYjSKwMIR+WDmLNO+e3XN0BR12
        BRplzKv8YAfO7+RGug7+zMIgAbKxm82jBeGsweXwBaQeAuIiBA+stwFTnIF772ptbcTaJG
        ZbzJ3rlgWdq/BSkwqonel4Alq4OgNMk=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-282-sKh8txFrN-ibFDx0kCZ8dA-1; Wed, 17 Feb 2021 21:42:12 -0500
X-MC-Unique: sKh8txFrN-ibFDx0kCZ8dA-1
Received: by mail-pg1-f197.google.com with SMTP id j5so476084pgi.14
        for <linux-xfs@vger.kernel.org>; Wed, 17 Feb 2021 18:42:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=XGH2fNCvGeQj+KR360UnueDimtSWrY7sM/x29Fa6DSw=;
        b=Cx/Y+pgLY4gFM6Zi8bu9yfBV+bJdyCkwF61I30zBNKfEDjHcuw5wdAL6Y09C+bTdIG
         YXyJqRSzVCttAA1Cc9hbVEf8Or05FAGrONu3mrE8Y+bmdk6QwfrRxJpX79GoYp6BJHZy
         HCVsNySX2U3KQT6d85I/vNeA3v8owVM63/3UY9fNrKybrTVndbHZch6c6iEkwV922ItI
         uIYSZuqeFQ2r9XlZ5L11gPC9t90kjwd9MRmjDkSdiIgTMMuc3oV+6tMzHkj6Ukn3tKz+
         go6++rffOHsujWgSOU54sQeNiw8UWRl+5iQR2nOabK6QUjpzhXXnVmgnBhEg+46at1am
         ymwQ==
X-Gm-Message-State: AOAM531IEHEaC9EA4Bt49PUsoaI2DYnJacp1Xsmg0eNHUhJ83UOuFg7E
        1YVjJeKsbsMCsxDinvXkPgpQi72AAMk/WbdSMhxiK5nCFork+r2yGrvHRlkZ6A/LTP+NkqW/PlJ
        fuGDq2et/FPPANGTulJ9V
X-Received: by 2002:a17:90a:a88e:: with SMTP id h14mr1867171pjq.59.1613616131203;
        Wed, 17 Feb 2021 18:42:11 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzkx0ibOoOehgI9wKeAyAzJWw3kZUM4XL8fpwlJckXFWymv/O/JEz2Tcu/ZqyVmqVULw96gsg==
X-Received: by 2002:a17:90a:a88e:: with SMTP id h14mr1867149pjq.59.1613616130935;
        Wed, 17 Feb 2021 18:42:10 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 184sm4056837pfc.176.2021.02.17.18.42.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Feb 2021 18:42:10 -0800 (PST)
Date:   Thu, 18 Feb 2021 10:41:59 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@redhat.com>,
        Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v6 3/3] mkfs: make use of xfs_validate_stripe_geometry()
Message-ID: <20210218024159.GA145146@xiangao.remote.csb>
References: <20201013040627.13932-1-hsiangkao@redhat.com>
 <20201013040627.13932-4-hsiangkao@redhat.com>
 <320d0635-2fbf-dd44-9f39-eaea48272bc7@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <320d0635-2fbf-dd44-9f39-eaea48272bc7@sandeen.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Eric,

On Mon, Feb 15, 2021 at 07:04:25PM -0600, Eric Sandeen wrote:
> On 10/12/20 11:06 PM, Gao Xiang wrote:
> > Check stripe numbers in calc_stripe_factors() by using
> > xfs_validate_stripe_geometry().
> > 
> > Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> 
> Hm, unless I have made a mistake, this seems to allow an invalid
> stripe specification.
> 
> Without this patch, this fails:
> 
> # mkfs/mkfs.xfs -f -d su=4097,sw=1 /dev/loop0
> data su must be a multiple of the sector size (512)
> 
> With the patch:
> 
> # mkfs/mkfs.xfs -f -d su=4097,sw=1 /dev/loop0
> meta-data=/dev/loop0             isize=512    agcount=8, agsize=32768 blks
>          =                       sectsz=512   attr=2, projid32bit=1
>          =                       crc=1        finobt=1, sparse=1, rmapbt=0
>          =                       reflink=1    bigtime=0
> data     =                       bsize=4096   blocks=262144, imaxpct=25
>          =                       sunit=1      swidth=1 blks
> naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
> log      =internal log           bsize=4096   blocks=2560, version=2
>          =                       sectsz=512   sunit=1 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> Discarding blocks...Done.
> 
> When you are back from holiday, can you check? No big rush.

I'm back from holiday today. I think the problem is in
"if (dsu || dsw) {" it turns into "dsunit  = (int)BTOBBT(dsu);" anyway,
and then if (!libxfs_validate_stripe_geometry(NULL, BBTOB(dsunit),
					     BBTOB(dswidth), cfg->sectorsize, false))

so dsu isn't checked with sectorsize in advance before it turns into BB.

the fix seems simple though,
1) turn dsunit and dswidth into bytes rather than BB, but I have no idea the range of
   these 2 varibles, since I saw "if (big_dswidth > INT_MAX) {" but the big_dswidth
   was also in BB as well, if we turn these into bytes, and such range cannot be
   guarunteed...
2) recover the previous code snippet and check dsu in advance:
		if (dsu % cfg->sectorsize) {
			fprintf(stderr,
_("data su must be a multiple of the sector size (%d)\n"), cfg->sectorsize);
			usage();
		}

btw, do we have some range test about these variables? I could rearrange the code
snippet, but I'm not sure if it could introduce some new potential regression as well...

Thanks,
Gao Xiang

> 
> Thanks,
> -Eric
> 
> > ---
> >  libxfs/libxfs_api_defs.h |  1 +
> >  mkfs/xfs_mkfs.c          | 23 +++++++----------------
> >  2 files changed, 8 insertions(+), 16 deletions(-)
> > 
> > diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
> > index e7e42e93..306d0deb 100644
> > --- a/libxfs/libxfs_api_defs.h
> > +++ b/libxfs/libxfs_api_defs.h
> > @@ -188,6 +188,7 @@
> >  #define xfs_trans_roll_inode		libxfs_trans_roll_inode
> >  #define xfs_trans_roll			libxfs_trans_roll
> >  
> > +#define xfs_validate_stripe_geometry	libxfs_validate_stripe_geometry
> >  #define xfs_verify_agbno		libxfs_verify_agbno
> >  #define xfs_verify_agino		libxfs_verify_agino
> >  #define xfs_verify_cksum		libxfs_verify_cksum
> > diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> > index 8fe149d7..aec40c1f 100644
> > --- a/mkfs/xfs_mkfs.c
> > +++ b/mkfs/xfs_mkfs.c
> > @@ -2305,12 +2305,6 @@ _("both data su and data sw options must be specified\n"));
> >  			usage();
> >  		}
> >  
> > -		if (dsu % cfg->sectorsize) {
> > -			fprintf(stderr,
> > -_("data su must be a multiple of the sector size (%d)\n"), cfg->sectorsize);
> > -			usage();
> > -		}
> > -
> >  		dsunit  = (int)BTOBBT(dsu);
> >  		big_dswidth = (long long int)dsunit * dsw;
> >  		if (big_dswidth > INT_MAX) {
> > @@ -2322,13 +2316,9 @@ _("data stripe width (%lld) is too large of a multiple of the data stripe unit (
> >  		dswidth = big_dswidth;
> >  	}
> >  
> > -	if ((dsunit && !dswidth) || (!dsunit && dswidth) ||
> > -	    (dsunit && (dswidth % dsunit != 0))) {
> > -		fprintf(stderr,
> > -_("data stripe width (%d) must be a multiple of the data stripe unit (%d)\n"),
> > -			dswidth, dsunit);
> > +	if (!libxfs_validate_stripe_geometry(NULL, BBTOB(dsunit), BBTOB(dswidth),
> > +					     cfg->sectorsize, false))
> >  		usage();
> > -	}
> >  
> >  	/* If sunit & swidth were manually specified as 0, same as noalign */
> >  	if ((cli_opt_set(&dopts, D_SUNIT) || cli_opt_set(&dopts, D_SU)) &&
> > @@ -2344,11 +2334,12 @@ _("data stripe width (%d) must be a multiple of the data stripe unit (%d)\n"),
> >  
> >  	/* if no stripe config set, use the device default */
> >  	if (!dsunit) {
> > -		/* Ignore nonsense from device.  XXX add more validation */
> > -		if (ft->dsunit && ft->dswidth == 0) {
> > +		/* Ignore nonsense from device report. */
> > +		if (!libxfs_validate_stripe_geometry(NULL, BBTOB(ft->dsunit),
> > +				BBTOB(ft->dswidth), 0, true)) {
> >  			fprintf(stderr,
> > -_("%s: Volume reports stripe unit of %d bytes and stripe width of 0, ignoring.\n"),
> > -				progname, BBTOB(ft->dsunit));
> > +_("%s: Volume reports invalid stripe unit (%d) and stripe width (%d), ignoring.\n"),
> > +				progname, BBTOB(ft->dsunit), BBTOB(ft->dswidth));
> >  			ft->dsunit = 0;
> >  			ft->dswidth = 0;
> >  		} else {
> > 
> 

