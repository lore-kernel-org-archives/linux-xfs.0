Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56113C433E0
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Feb 2021 00:41:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0ABAB64EC0
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Feb 2021 00:41:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229535AbhBSAl0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Feb 2021 19:41:26 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:49402 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229468AbhBSAl0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Feb 2021 19:41:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613695199;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XmEwdlyhExZOKAkloSeUNhYHfOnj7y/WXpQUFeMCEc0=;
        b=dF1TiJuNJgQ7AopEmKx7BnS2+lU5tRFnry5Q3+kKVLYsm1Fctq59O72E39rU4bOd06zmNE
        Z1kblU7khnVWG35PIi4WxROC7tr9Zks0/0/uih1a+cpNpzhqxTLiBQwceX/DLrsW1Enonu
        Iy8S6NoQtf9JU80Pxs8QOpgjkTZg5Y4=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-552-ypRH-kumMS-pmwAchEUTQw-1; Thu, 18 Feb 2021 19:39:55 -0500
X-MC-Unique: ypRH-kumMS-pmwAchEUTQw-1
Received: by mail-pf1-f198.google.com with SMTP id c186so2719179pfa.23
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:39:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=XmEwdlyhExZOKAkloSeUNhYHfOnj7y/WXpQUFeMCEc0=;
        b=c495x6KCielDPKk8ZvtBf7geAAFLxa1Tkqrkoa6tNotjLr0ziBg6x9S5dNWBZxIyWW
         XDFeuec42cKZiagXg6X3tjTDlhxGGTPGecLpcI4smDXeFLzYAKGIOYW+8iTeCb+VywiC
         artpCd27L6m78ko3V1gMWJz/12qjCbezeh4w5mZghQhJuT523Li1u5Qlo7NsIMrjTVYk
         NvL5KNRd2ZJON7le1At/4GJiHHlGJVQIcnBOEMIUafEUU96hxqYSWeLO1kYUJCTMt9Ae
         0qqoWt7egdo7FpcOZmp76DtTYEeVkfjQ02FXGCVZy7Ln6b6J5hDF5lv4xv0UsYr4bNEn
         qs2A==
X-Gm-Message-State: AOAM531ZRpjh9XJGVvuJTrMhE4SCE2FJf7I4m5uHVUfqNEFZpv26f9xf
        gsAJRwq/jzT45d33gNf78a4HkKM7IN4lHgS7LrmxTNKzTf8OGVIR+p+2YoG9A0cmeY8lWLZ7FYp
        G1EzttStiw3KdW6ue83w8
X-Received: by 2002:aa7:8d8e:0:b029:1d1:f9c9:cff6 with SMTP id i14-20020aa78d8e0000b02901d1f9c9cff6mr7082229pfr.31.1613695194253;
        Thu, 18 Feb 2021 16:39:54 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxqr5j3VGj5FrIOEmvi3pXOxh/J8PRrQjys+gcwv4hhhCNBQSLfu6PRQof/pQ3+3BjLBqwrXw==
X-Received: by 2002:aa7:8d8e:0:b029:1d1:f9c9:cff6 with SMTP id i14-20020aa78d8e0000b02901d1f9c9cff6mr7082205pfr.31.1613695193957;
        Thu, 18 Feb 2021 16:39:53 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id h10sm7611278pfq.97.2021.02.18.16.39.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Feb 2021 16:39:52 -0800 (PST)
Date:   Fri, 19 Feb 2021 08:39:42 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@redhat.com>,
        Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v6 3/3] mkfs: make use of xfs_validate_stripe_geometry()
Message-ID: <20210219003942.GA392963@xiangao.remote.csb>
References: <20201013040627.13932-1-hsiangkao@redhat.com>
 <20201013040627.13932-4-hsiangkao@redhat.com>
 <320d0635-2fbf-dd44-9f39-eaea48272bc7@sandeen.net>
 <20210218024159.GA145146@xiangao.remote.csb>
 <20210218052454.GA161514@xiangao.remote.csb>
 <1f63b1b7-71ec-2a03-1053-58a1abd0088a@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1f63b1b7-71ec-2a03-1053-58a1abd0088a@sandeen.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 18, 2021 at 10:38:17AM -0600, Eric Sandeen wrote:
> On 2/17/21 11:24 PM, Gao Xiang wrote:
> 

...

> since we have this check already in xfs_validate_stripe_geometry, it seems best to
> keep using it there, and not copy it ... which I think you accomplish below.
> 
> >> btw, do we have some range test about these variables? I could rearrange the code
> >> snippet, but I'm not sure if it could introduce some new potential regression as well...
> >>
> >> Thanks,
> >> Gao Xiang
> > 
> > Or how about applying the following incremental patch, although the maximum dswidth
> > would be smaller I think, but considering libxfs_validate_stripe_geometry() accepts
> > dswidth in 64-bit bytes as well. I think that would be fine. Does that make sense?
> > 
> > I've confirmed "# mkfs/mkfs.xfs -f -d su=4097,sw=1 /dev/loop0" now report:
> > stripe unit (4097) must be a multiple of the sector size (512)
> > 
> > and xfs/191-input-validation passes now...
> > 
> > diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> > index f152d5c7..80405790 100644
> > --- a/mkfs/xfs_mkfs.c
> > +++ b/mkfs/xfs_mkfs.c
> > @@ -2361,20 +2361,24 @@ _("both data su and data sw options must be specified\n"));
> >  			usage();
> >  		}
> 
> Just thinking through this... I think this is the right idea.
> 
> > -		dsunit  = (int)BTOBBT(dsu);
> > -		big_dswidth = (long long int)dsunit * dsw;
> > +		big_dswidth = (long long int)dsu * dsw;
> 
> dsu is in bytes; this would mean big_dswidth is now also in bytes...
> the original goal here, I think, is to not overflow the 32-bit superblock value
> for dswidth.

Yeah, agreed. Thanks for catching this.

> 
> >  		if (big_dswidth > INT_MAX) {
> >  			fprintf(stderr,
> >  _("data stripe width (%lld) is too large of a multiple of the data stripe unit (%d)\n"),
> >  				big_dswidth, dsunit);
> 
> so this used to test big_dswidth in BB (sectors); but now it tests in bytes.
> 
> Perhaps this should change to check and report sectors again:
> 
>   		if (BTOBBT(big_dswidth) > INT_MAX) {
>   			fprintf(stderr,
>   _("data stripe width (%lld) is too large of a multiple of the data stripe unit (%d)\n"),
>   				BTOBBT(big_dswidth), dsunit);
> 
> I think the goal is to not overflow the 32-bit on-disk values, which would be
> easy to do with "dsw" specified as a /multiplier/ of "dsu"
> 
> So I think that if we keep range checking the value in BB units, it will be
> OK.
> 
> >  			usage();
> >  		}
> > -		dswidth = big_dswidth;
> > -	}
> >  
> > -	if (!libxfs_validate_stripe_geometry(NULL, BBTOB(dsunit), BBTOB(dswidth),
> > -					     cfg->sectorsize, false))
> > +		if (!libxfs_validate_stripe_geometry(NULL, dsu, big_dswidth,
> > +						     cfg->sectorsize, false))
> > +			usage();
> > +
> > +		dsunit = BTOBBT(dsu);
> > +		dswidth = BTOBBT(big_dswidth);
> > +	} else if (!libxfs_validate_stripe_geometry(NULL, BBTOB(dsunit),
> > +			BBTOB(dswidth), cfg->sectorsize, false)) {
> >  		usage();
> > +	}
> Otherwise this looks reasonable to me; now it's basically:
> 
> 1) If we got geometry in bytes, validate them directly
> 2) If we got geometry in BB, convert to bytes, and validate
> 3) If we got no geometry, validate the device-reported defaults
> 

Ok, let me send the next version.

Thanks,
Gao Xiang

> Thanks,
> -Eric
> 
> >  	/* If sunit & swidth were manually specified as 0, same as noalign */
> >  	if ((cli_opt_set(&dopts, D_SUNIT) || cli_opt_set(&dopts, D_SU)) &&
> > 
> 

