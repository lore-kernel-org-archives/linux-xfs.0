Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04AD6C433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Mar 2021 00:56:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB444619F8
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Mar 2021 00:55:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235365AbhCYAz1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Mar 2021 20:55:27 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:23687 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232856AbhCYAy6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Mar 2021 20:54:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616633697;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6pVjQ8JkbywOJguIv1nNuU4PDu6NSNVUhvYa74vThJM=;
        b=RLbQAA9zvQUAJFskhCgFPZ8nkxKBnP0VzTKL4v2eqMjyaQqZARXB9jjqJB4pbwGYHzYuqo
        saLvBrrXdzfoHdJsLpbrQbBaXnmjj2jgxwZFEziC6gSA/73T61GI1FOGMXnxxhEDTeVcTr
        klV57l/ySQHhug5aTvtgF9hgJ2P0TIw=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-434-FWZTcxuIP7iMFHvausWecw-1; Wed, 24 Mar 2021 20:54:56 -0400
X-MC-Unique: FWZTcxuIP7iMFHvausWecw-1
Received: by mail-pg1-f197.google.com with SMTP id u12so2611290pgr.3
        for <linux-xfs@vger.kernel.org>; Wed, 24 Mar 2021 17:54:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=6pVjQ8JkbywOJguIv1nNuU4PDu6NSNVUhvYa74vThJM=;
        b=B1ULhu6U2ft6iFJ7smy2G/0ujSsk2EajLJaKvckmQ2AOCRvIarZPC/mhzXweRxG58i
         P79EpgoT38E3PSV0LnItUeAk7V3LkDAknGauR0eQDYKMzlZQP7ubLR0I7CCMeNWYXSS4
         V+ctB1dESSKn+A8ej427olWcAT01kNUACh0Pug3drA5yIcmdLyv3rowwSdAsHMelpG7E
         9gjRU46hklrM+cfDU64oaycdtpwx+CMv/N/Gcr3/SC28cQ9yC5JZO2qPl7TYI8XoNpcs
         A4e1ciEBRpuCD4lplqm8WZnLIalJgoRXj/4uhe+942NhmK5VoE0/GtIJR5hFF8Q8ZNgq
         8vmA==
X-Gm-Message-State: AOAM5331nVT0mBv6inMX/pGzEUS18OBTdOnrxDzbGpOJyaHrjhUtdRGf
        8F1CGqwrhThgdXfX8POd6sYSd+03fWcwnEhqjlEgnA9qClTZpJ71D/mBh4mZ76fvWNEAJ5SfPGP
        qJbhhd1Ld39OcRJ+a3cnR
X-Received: by 2002:a17:902:b7cb:b029:e4:55cd:ddf0 with SMTP id v11-20020a170902b7cbb02900e455cdddf0mr6319900plz.45.1616633694955;
        Wed, 24 Mar 2021 17:54:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyyAFMyTjH95mIrVEdhnvkykd/PVsB13C30NgFUziic6/FhCuns91sCFNHnMgiE/5tM5HPvBQ==
X-Received: by 2002:a17:902:b7cb:b029:e4:55cd:ddf0 with SMTP id v11-20020a170902b7cbb02900e455cdddf0mr6319872plz.45.1616633694671;
        Wed, 24 Mar 2021 17:54:54 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id x1sm3591363pje.40.2021.03.24.17.54.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Mar 2021 17:54:54 -0700 (PDT)
Date:   Thu, 25 Mar 2021 08:54:44 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@lst.de>,
        Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH v9 5/5] xfs: add error injection for per-AG resv failure
Message-ID: <20210325005444.GC2421109@xiangao.remote.csb>
References: <20210324010621.2244671-1-hsiangkao@redhat.com>
 <20210324010621.2244671-6-hsiangkao@redhat.com>
 <20210324171744.GT22100@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210324171744.GT22100@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 24, 2021 at 10:17:44AM -0700, Darrick J. Wong wrote:
> On Wed, Mar 24, 2021 at 09:06:21AM +0800, Gao Xiang wrote:
> > per-AG resv failure after fixing up freespace is hard to test in an
> > effective way, so directly add an error injection path to observe
> > such error handling path works as expected.
> > 
> > Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> 
> Looks good to me; can you send the latest version of the xfs_growfs
> patches to the list to get the review started for 5.13?

Yeah, I saw your comments on the xfs_growfs. I didn't send out just because
it can still apply with no conflict. Will update manpage as well.

> 
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>

Thanks for the review.

Thanks,
Gao Xiang

> 
> --D
> 
> > ---
> >  fs/xfs/libxfs/xfs_ag_resv.c  | 6 +++++-
> >  fs/xfs/libxfs/xfs_errortag.h | 4 +++-
> >  fs/xfs/xfs_error.c           | 3 +++
> >  3 files changed, 11 insertions(+), 2 deletions(-)
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
> > index 6ca9084b6934..a23a52e643ad 100644
> > --- a/fs/xfs/libxfs/xfs_errortag.h
> > +++ b/fs/xfs/libxfs/xfs_errortag.h
> > @@ -58,7 +58,8 @@
> >  #define XFS_ERRTAG_BUF_IOERROR				35
> >  #define XFS_ERRTAG_REDUCE_MAX_IEXTENTS			36
> >  #define XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT		37
> > -#define XFS_ERRTAG_MAX					38
> > +#define XFS_ERRTAG_AG_RESV_FAIL				38
> > +#define XFS_ERRTAG_MAX					39
> >  
> >  /*
> >   * Random factors for above tags, 1 means always, 2 means 1/2 time, etc.
> > @@ -101,5 +102,6 @@
> >  #define XFS_RANDOM_BUF_IOERROR				XFS_RANDOM_DEFAULT
> >  #define XFS_RANDOM_REDUCE_MAX_IEXTENTS			1
> >  #define XFS_RANDOM_BMAP_ALLOC_MINLEN_EXTENT		1
> > +#define XFS_RANDOM_AG_RESV_FAIL				1
> >  
> >  #endif /* __XFS_ERRORTAG_H_ */
> > diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
> > index 185b4915b7bf..f70984f3174d 100644
> > --- a/fs/xfs/xfs_error.c
> > +++ b/fs/xfs/xfs_error.c
> > @@ -56,6 +56,7 @@ static unsigned int xfs_errortag_random_default[] = {
> >  	XFS_RANDOM_BUF_IOERROR,
> >  	XFS_RANDOM_REDUCE_MAX_IEXTENTS,
> >  	XFS_RANDOM_BMAP_ALLOC_MINLEN_EXTENT,
> > +	XFS_RANDOM_AG_RESV_FAIL,
> >  };
> >  
> >  struct xfs_errortag_attr {
> > @@ -168,6 +169,7 @@ XFS_ERRORTAG_ATTR_RW(iunlink_fallback,	XFS_ERRTAG_IUNLINK_FALLBACK);
> >  XFS_ERRORTAG_ATTR_RW(buf_ioerror,	XFS_ERRTAG_BUF_IOERROR);
> >  XFS_ERRORTAG_ATTR_RW(reduce_max_iextents,	XFS_ERRTAG_REDUCE_MAX_IEXTENTS);
> >  XFS_ERRORTAG_ATTR_RW(bmap_alloc_minlen_extent,	XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT);
> > +XFS_ERRORTAG_ATTR_RW(ag_resv_fail, XFS_ERRTAG_AG_RESV_FAIL);
> >  
> >  static struct attribute *xfs_errortag_attrs[] = {
> >  	XFS_ERRORTAG_ATTR_LIST(noerror),
> > @@ -208,6 +210,7 @@ static struct attribute *xfs_errortag_attrs[] = {
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

