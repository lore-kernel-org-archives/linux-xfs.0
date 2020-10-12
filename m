Return-Path: <SRS0=uuBg=DT=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 645E2C43457
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Oct 2020 14:08:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2588F2076E
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Oct 2020 14:08:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hVyUQvCA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731893AbgJLOIx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 12 Oct 2020 10:08:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34183 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390248AbgJLOHb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Oct 2020 10:07:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602511649;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rqaICKTMYHplEce4o1umZlPUUvfKhCEo8iR0IQqtdSQ=;
        b=hVyUQvCAi1YdXWma1EXrlHIRniNEqffdc/LyAKl8DZ2cUJeD/QY0FK2Hz8zG5v9/Bp1IJI
        i+/kR5dmqoPLR/Vox5EaBZEz63CF2ZhksRm46V7ExaMmcOEJ4s/nKXpHqN09LstJpIGA1j
        VcJasZqI8kWzpwYDxLxIldeqVJCabf0=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-357-Ew2v9jYLOeCXnp162-dwaQ-1; Mon, 12 Oct 2020 10:07:27 -0400
X-MC-Unique: Ew2v9jYLOeCXnp162-dwaQ-1
Received: by mail-pf1-f197.google.com with SMTP id x24so12623533pfi.18
        for <linux-xfs@vger.kernel.org>; Mon, 12 Oct 2020 07:07:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=rqaICKTMYHplEce4o1umZlPUUvfKhCEo8iR0IQqtdSQ=;
        b=jRgj8IBqObBzqU02wm595LQMkZxYEiuxVlUyHjUlyhwt2Nxk5ApA9dy0tYRTzTmG7k
         vxlQFLAk0hV49NWFY8ToLbrSimB+/wJv3K+L2vIfKU2hQLkMDo9Rh+zcv2SWe1DefNL3
         EbmOaw7kyODWlJbWUx3U6KMsYwNHvwNlxapg9umOlSVDk++w+0zNSUUbRDrd16dSjgoq
         7YnISRROWQ7INNPoH1O/is1/SF7xkQn+o4i9oK+U9uoEtD2JzAV5YpAp6IZ74Pj3YCPB
         T/O14YOFRqIkmrAbDAFYyc9GpQ324o64eg9xRDFmQJuEYTEGZ73wPkUn2rUJnEKIXW4b
         gHPg==
X-Gm-Message-State: AOAM530xVCm2qkG3UH0h3nUuTjiEIYCyyJ36EydmmDhkiZUHRConOVQM
        +J/KmAGRcOOwFHfmtGuFuoD8AIoo8LgjZMzsjljJ1lP1UpdLQZ57+Fr096FFlM0okS4Nrlmo5nL
        77WcXrcxemeSnmJaPLBwo
X-Received: by 2002:a05:6a00:84c:b029:152:870d:5b81 with SMTP id q12-20020a056a00084cb0290152870d5b81mr23455114pfk.25.1602511646177;
        Mon, 12 Oct 2020 07:07:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzMOiYhENOXE5Ks+JdKNL2Al0NDV7YOohfq/WQtnso/KScfkVBlp1RxefLkDnVQqDVIGqm8KA==
X-Received: by 2002:a05:6a00:84c:b029:152:870d:5b81 with SMTP id q12-20020a056a00084cb0290152870d5b81mr23455086pfk.25.1602511645890;
        Mon, 12 Oct 2020 07:07:25 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id y10sm20652035pff.119.2020.10.12.07.07.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2020 07:07:25 -0700 (PDT)
Date:   Mon, 12 Oct 2020 22:07:15 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eric Sandeen <sandeen@redhat.com>,
        Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v5 3/3] mkfs: make use of xfs_validate_stripe_factors()
Message-ID: <20201012140715.GB614@xiangao.remote.csb>
References: <20201009052421.3328-1-hsiangkao@redhat.com>
 <20201009052421.3328-4-hsiangkao@redhat.com>
 <20201012130651.GE917726@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201012130651.GE917726@bfoster>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Brian,

On Mon, Oct 12, 2020 at 09:06:51AM -0400, Brian Foster wrote:
> On Fri, Oct 09, 2020 at 01:24:21PM +0800, Gao Xiang wrote:
> > Check stripe numbers in calc_stripe_factors() by using
> > xfs_validate_stripe_factors().
> > 
> > Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> > ---
> >  libxfs/libxfs_api_defs.h |  1 +
> >  mkfs/xfs_mkfs.c          | 23 +++++++----------------
> >  2 files changed, 8 insertions(+), 16 deletions(-)
> > 
> ...
> > @@ -2344,11 +2334,12 @@ _("data stripe width (%d) must be a multiple of the data stripe unit (%d)\n"),
> >  
> >  	/* if no stripe config set, use the device default */
> >  	if (!dsunit) {
> > -		/* Ignore nonsense from device.  XXX add more validation */
> > -		if (ft->dsunit && ft->dswidth == 0) {
> > +		/* Ignore nonsense from device report. */
> > +		if (!libxfs_validate_stripe_factors(NULL, BBTOB(ft->dsunit),
> > +						    BBTOB(ft->dswidth), 0)) {
> 
> The logic seems fine and from the previous comment it sounds like we're
> lacking validation in this particular scenario, but do we want to print
> more error noise from the validation helper in scenarios where failure
> is not a fatal error?

Yeah, If I understand correctly, I think that is an open question here,
so I think you suggested that we could silence for this case by passing
a "bool silent" argument? or some better idea for this?

Thanks,
Gao Xiang

> 
> Brian
> 
> >  			fprintf(stderr,
> > -_("%s: Volume reports stripe unit of %d bytes and stripe width of 0, ignoring.\n"),
> > -				progname, BBTOB(ft->dsunit));
> > +_("%s: Volume reports invalid stripe unit (%d) and stripe width (%d), ignoring.\n"),
> > +				progname, BBTOB(ft->dsunit), BBTOB(ft->dswidth));
> >  			ft->dsunit = 0;
> >  			ft->dswidth = 0;
> >  		} else {
> > -- 
> > 2.18.1
> > 
> 

