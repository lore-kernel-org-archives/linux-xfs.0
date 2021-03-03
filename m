Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BBD4C4332B
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Mar 2021 00:18:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 510FF64E90
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Mar 2021 00:18:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355043AbhCDASU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 3 Mar 2021 19:18:20 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:25091 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1354901AbhCDANl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 3 Mar 2021 19:13:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614816732;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YkyS/VB3DSroU6AdagV60D+uv9C89k/Xx/3+w2O513A=;
        b=gA1P1UT9h1hc051UJOZuxe5iOP4OK+TjStKa+iDZqcf3vo0ovfMD2Jq6wxGcj14QmoPUMs
        Bynm6Uo2/62En2itmvT62iZzELhHbOzOFBhPyPobiDha7cKAptnOXIuDJc94wBkEC6P9YG
        sJWLYURq+wrbSF2s55uwXaUSIQEi5cI=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-161-m8LjQ1rtN92d_Ivp7oRi0Q-1; Wed, 03 Mar 2021 18:11:35 -0500
X-MC-Unique: m8LjQ1rtN92d_Ivp7oRi0Q-1
Received: by mail-pf1-f197.google.com with SMTP id u188so16759532pfu.23
        for <linux-xfs@vger.kernel.org>; Wed, 03 Mar 2021 15:11:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=YkyS/VB3DSroU6AdagV60D+uv9C89k/Xx/3+w2O513A=;
        b=GLKY7lScytD4U2XaNsynfi75MObUIF0dhAFY2ufI1nCfwXb0GUtiVWQ5JMwIjdlwyU
         sesCktcQ+GzMwvOdVWcD2o/waCxQsCENb7AwDE2Oky+hBBAyI76/Ym6jabfST6dxBlrp
         109Px3SznrxoSXkhNfIbotoW7Oy3htpnsuNH/yCrPLFNwM67eGcr62ZxZgh2LFkAmZZY
         CF3Mq43UnuUKOIISD4j6NjMx+/KA5POFiUkSC6HQiODxYwz6OQ19F27mUFfdmBzPgZU2
         DTt7PT0mwauRlerXdfQXKIwdRo+QNuxa3O/Yxlj3qwZBEG6KQpdis1KhBAj1VV0Zb9xX
         wMdw==
X-Gm-Message-State: AOAM533d5wWhnn6SB820QExjB2GLBTCK9DQOzW3u8hyGmx5L7FmWge8Q
        F7z/ob7WLCWh0ZNIljrXOT76wGoiDx0vquFWHomG4tDFzJqc3mLp3qJK8tIeOXq9TZWpaFqFXST
        sHaEE9HLVKjFmMK634BE6
X-Received: by 2002:a17:902:edc2:b029:e4:3738:9b23 with SMTP id q2-20020a170902edc2b02900e437389b23mr1191419plk.37.1614813094842;
        Wed, 03 Mar 2021 15:11:34 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyW0fiAUtbq0ofv2cQ+RzGO5A5D+alEZHORVQqw0DwmZnUs4UeejoKQyPxpM/GvG5ijliY2/A==
X-Received: by 2002:a17:902:edc2:b029:e4:3738:9b23 with SMTP id q2-20020a170902edc2b02900e437389b23mr1191389plk.37.1614813094473;
        Wed, 03 Mar 2021 15:11:34 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id fs9sm7749075pjb.40.2021.03.03.15.11.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Mar 2021 15:11:34 -0800 (PST)
Date:   Thu, 4 Mar 2021 07:11:23 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@lst.de>,
        Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH v7 5/5] xfs: add error injection for per-AG resv failure
Message-ID: <20210303231123.GB2843084@xiangao.remote.csb>
References: <20210302024816.2525095-1-hsiangkao@redhat.com>
 <20210302024816.2525095-6-hsiangkao@redhat.com>
 <20210303183042.GD3419940@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210303183042.GD3419940@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Darrick,

On Wed, Mar 03, 2021 at 10:30:42AM -0800, Darrick J. Wong wrote:
> On Tue, Mar 02, 2021 at 10:48:16AM +0800, Gao Xiang wrote:
> > per-AG resv failure after fixing up freespace is hard to test in an
> > effective way, so directly add an error injection path to observe
> > such error handling path works as expected.
> > 
> > Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> > ---
> >  fs/xfs/libxfs/xfs_ag_resv.c  | 6 +++++-
> >  fs/xfs/libxfs/xfs_errortag.h | 4 +++-
> >  fs/xfs/xfs_error.c           | 2 ++
> >  3 files changed, 10 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_ag_resv.c b/fs/xfs/libxfs/xfs_ag_resv.c
> > index fdfe6dc0d307..6c5f8d10589c 100644
> > --- a/fs/xfs/libxfs/xfs_ag_resv.c
> > +++ b/fs/xfs/libxfs/xfs_ag_resv.c
> > @@ -211,7 +211,11 @@ __xfs_ag_resv_init(
> >  		ASSERT(0);
> >  		return -EINVAL;
> >  	}
> > -	error = xfs_mod_fdblocks(mp, -(int64_t)hidden_space, true);
> > +
> > +	if (XFS_TEST_ERROR(false, mp, XFS_ERRTAG_AG_RESV_FAIL))
> > +		error = -ENOSPC;
> > +	else
> > +		error = xfs_mod_fdblocks(mp, -(int64_t)hidden_space, true);
> >  	if (error) {
> >  		trace_xfs_ag_resv_init_error(pag->pag_mount, pag->pag_agno,
> >  				error, _RET_IP_);
> > diff --git a/fs/xfs/libxfs/xfs_errortag.h b/fs/xfs/libxfs/xfs_errortag.h
> > index 6ca9084b6934..b433ef735217 100644
> > --- a/fs/xfs/libxfs/xfs_errortag.h
> > +++ b/fs/xfs/libxfs/xfs_errortag.h
> > @@ -40,6 +40,7 @@
> >  #define XFS_ERRTAG_REFCOUNT_FINISH_ONE			25
> >  #define XFS_ERRTAG_BMAP_FINISH_ONE			26
> >  #define XFS_ERRTAG_AG_RESV_CRITICAL			27
> > +
> 
> Extra space?
> 
> >  /*
> >   * DEBUG mode instrumentation to test and/or trigger delayed allocation
> >   * block killing in the event of failed writes. When enabled, all
> > @@ -58,7 +59,8 @@
> >  #define XFS_ERRTAG_BUF_IOERROR				35
> >  #define XFS_ERRTAG_REDUCE_MAX_IEXTENTS			36
> >  #define XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT		37
> > -#define XFS_ERRTAG_MAX					38
> > +#define XFS_ERRTAG_AG_RESV_FAIL				38
> > +#define XFS_ERRTAG_MAX					39
> >  
> >  /*
> >   * Random factors for above tags, 1 means always, 2 means 1/2 time, etc.
> 
> This needs to define XFS_RANDOM_AG_RESV_FAIL and put it in
> xfs_errortag_random_default in xfs_error.c to avoid running off the end
> of the array.
> 
> Also... that _default array /really/ needs to have a BUILD_BUG_ON
> somewhere to scream loudly if it isn't XFS_ERRTAG_MAX elements long.

I've sent out v7.1 of this patch attached to this version,
https://lore.kernel.org/linux-xfs/20210303000202.2671220-1-hsiangkao@redhat.com/

Yes, I received a 0day CI report of this, would you mind
take a look at the fix above instead?

Thanks,
Ga oXiang

> 
> --D
> 
> > diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
> > index 185b4915b7bf..5192a7063d95 100644
> > --- a/fs/xfs/xfs_error.c
> > +++ b/fs/xfs/xfs_error.c
> > @@ -168,6 +168,7 @@ XFS_ERRORTAG_ATTR_RW(iunlink_fallback,	XFS_ERRTAG_IUNLINK_FALLBACK);
> >  XFS_ERRORTAG_ATTR_RW(buf_ioerror,	XFS_ERRTAG_BUF_IOERROR);
> >  XFS_ERRORTAG_ATTR_RW(reduce_max_iextents,	XFS_ERRTAG_REDUCE_MAX_IEXTENTS);
> >  XFS_ERRORTAG_ATTR_RW(bmap_alloc_minlen_extent,	XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT);
> > +XFS_ERRORTAG_ATTR_RW(ag_resv_fail, XFS_ERRTAG_AG_RESV_FAIL);
> >  
> >  static struct attribute *xfs_errortag_attrs[] = {
> >  	XFS_ERRORTAG_ATTR_LIST(noerror),
> > @@ -208,6 +209,7 @@ static struct attribute *xfs_errortag_attrs[] = {
> >  	XFS_ERRORTAG_ATTR_LIST(buf_ioerror),
> >  	XFS_ERRORTAG_ATTR_LIST(reduce_max_iextents),
> >  	XFS_ERRORTAG_ATTR_LIST(bmap_alloc_minlen_extent),
> > +	XFS_ERRORTAG_ATTR_LIST(ag_resv_fail),
> >  	NULL,
> >  };
> >  
> > -- 
> > 2.27.0
> > 
> 

