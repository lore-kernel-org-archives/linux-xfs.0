Return-Path: <SRS0=Vfs/=DQ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB021C433DF
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Oct 2020 00:59:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4273222256
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Oct 2020 00:59:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HeG0ljh/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728369AbgJIA7E (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 8 Oct 2020 20:59:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:47030 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725979AbgJIA7E (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 8 Oct 2020 20:59:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602205143;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SNTKbAwp5qTXEvqOnY/Hph748vIGlRYFeDBvP4IyTP4=;
        b=HeG0ljh//D8G++SSIPOPw0kcethJrcwbEK0wdMfMw1un+F1SkSqkQ6NVfjgccuRNqwt7Rl
        SwTBNGHdaDbeew+NNFJyhUX1Kqz6QtM9CfhdLoYlzmRhGhtrA5z2qwiNxMir8jky0x5mWI
        pGRv+19ljecL6zM6kaUQIROppbeUS6U=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-32-TCjwpoiDOha7TSeD-LgAtw-1; Thu, 08 Oct 2020 20:58:59 -0400
X-MC-Unique: TCjwpoiDOha7TSeD-LgAtw-1
Received: by mail-pf1-f199.google.com with SMTP id w78so4504512pfc.15
        for <linux-xfs@vger.kernel.org>; Thu, 08 Oct 2020 17:58:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=SNTKbAwp5qTXEvqOnY/Hph748vIGlRYFeDBvP4IyTP4=;
        b=bge2l5uL+uWk05uZiFTJ05Zpx+HZidQ9pj+0RUdOe0EIOpmjXCm0ztN8Gq5sVDVAeN
         JgnAcLYAfkSz8Ii+FLsBTUB0+AQtprv1km4MHDw1agdjajSZlIC9H1dJ2Eiz3TgZtdrv
         Caul7hxvG1OVeZdM0tlyD+4w91BQlwIlRjomtVODj3aK+RTuSHYhTY5vhk51B1PfrGAg
         vEpw2U1cs5/42H+gQjTathny/Bfh2W8kQWqUch6xyUOLjnxjste6gWf2KsFwkrCMw2Zj
         wsqXFrNClKE2/lasSj9CfPjE+1imK2ft8DsgYx3U0+i1eWkBqFbS75CGUazosIzDirlQ
         42gg==
X-Gm-Message-State: AOAM530kMyfw+hDLFXoonNVeTGQncG36OcYFsJUT92yx4GUeM/I23z7v
        l9XJh9fWAAmwxSFRBrdC/zWdlWphKbDjc6qMkouYwyy55xFGP0IsGvaWfZwY2QNVAE91AvTde9d
        9xxcfH1KqgLXOSQUn9lJv
X-Received: by 2002:a63:ac56:: with SMTP id z22mr1332750pgn.156.1602205138442;
        Thu, 08 Oct 2020 17:58:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJygUw2bU7UASWSGE7ao1YyxtoVHGPU5KmtuvELxid8CG2/ZConQxwz/TPh5O9FVB/pGRWg/1A==
X-Received: by 2002:a63:ac56:: with SMTP id z22mr1332733pgn.156.1602205138228;
        Thu, 08 Oct 2020 17:58:58 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id t6sm8559713pfl.50.2020.10.08.17.58.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 17:58:57 -0700 (PDT)
Date:   Fri, 9 Oct 2020 08:58:47 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Gao Xiang <hsiangkao@aol.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Eric Sandeen <sandeen@redhat.com>,
        Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v4 3/3] xfsprogs: make use of
 xfs_validate_stripe_factors()
Message-ID: <20201009005847.GB10631@xiangao.remote.csb>
References: <20201007140402.14295-1-hsiangkao@aol.com>
 <20201007140402.14295-4-hsiangkao@aol.com>
 <20201007223044.GI6540@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201007223044.GI6540@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 07, 2020 at 03:30:44PM -0700, Darrick J. Wong wrote:
> On Wed, Oct 07, 2020 at 10:04:02PM +0800, Gao Xiang wrote:
> > From: Gao Xiang <hsiangkao@redhat.com>
> > 
> > Check stripe numbers in calc_stripe_factors() by
> > using xfs_validate_stripe_factors().
> > 
> > Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> > ---
> >  mkfs/xfs_mkfs.c | 23 +++++++----------------
> >  1 file changed, 7 insertions(+), 16 deletions(-)
> > 
> > diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> > index 2e6cd280e388..b7f8f98147eb 100644
> > --- a/mkfs/xfs_mkfs.c
> > +++ b/mkfs/xfs_mkfs.c
> > @@ -2289,12 +2289,6 @@ _("both data su and data sw options must be specified\n"));
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
> > @@ -2306,13 +2300,9 @@ _("data stripe width (%lld) is too large of a multiple of the data stripe unit (
> >  		dswidth = big_dswidth;
> >  	}
> >  
> > -	if ((dsunit && !dswidth) || (!dsunit && dswidth) ||
> > -	    (dsunit && (dswidth % dsunit != 0))) {
> > -		fprintf(stderr,
> > -_("data stripe width (%d) must be a multiple of the data stripe unit (%d)\n"),
> > -			dswidth, dsunit);
> > +	if (!xfs_validate_stripe_factors(NULL, BBTOB(dsunit), BBTOB(dswidth),
> 
> if (!libxfs_validate_stripe_factors(...))
> 
> Unless we get rid of the weird libxfs macro thing, you're supposed to
> use prefixes in userspace.

I vaguely remembered Christoph sent out a patch intending to get
rid of xfsprogs libxfs_ prefix months ago, so I assumed there was
no need to introduce any new libxfs_ userspace API wrappers anymore.

But yeah, will add such libxfs_ marco wrapper in the next version.

Thanks,
Gao Xiang

> 
> --D

