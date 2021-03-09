Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DDB1C433E6
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Mar 2021 18:45:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F12E365230
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Mar 2021 18:45:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230465AbhCISpN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 9 Mar 2021 13:45:13 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:36711 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230035AbhCISo6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Mar 2021 13:44:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615315498;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XpFphCdxJcz5kV2o60+9GJjenQQjyIAdDRU4V2Uq99A=;
        b=JU6wJwvMu7Z9qotYjglrYu4F2zXBts7a2BNK8Cv+/pat3/6L5M1XgjeZrgrjVJ4giybl3r
        52SEdhVOujHOV8P82ePsQojRKZo1baFkqKwEs/QM6Q2cOypngPV9NkFhDh3DTBN2WAKtE8
        VZI4aZygMKaNRyY/cN8tlbzd8Msvj0M=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-290-4CJta0T1P7OGYiN57fLRew-1; Tue, 09 Mar 2021 13:44:57 -0500
X-MC-Unique: 4CJta0T1P7OGYiN57fLRew-1
Received: by mail-pl1-f198.google.com with SMTP id m12so2911144pll.9
        for <linux-xfs@vger.kernel.org>; Tue, 09 Mar 2021 10:44:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=XpFphCdxJcz5kV2o60+9GJjenQQjyIAdDRU4V2Uq99A=;
        b=p54xnPJCGkDkiALA3AgxkVBiufmsfG7spajQcWcRCnZF3xylEK2m8KLdrT6qG9r5Zt
         B5textQNHTH0IylyAjXFyloxA/6F660ejURuX9/XHPVjh1WeABOqjtca6hU0jYBcQBxR
         aj/cbgBRu63Xcq1cLt4h6E1KLpXfaBg5H75plK0Ikx4PeO0wy+TGD4RAGwZcxhTxChGK
         LrUUmbhcQxP0+/4SxYP8t9U1EQ8iQ8IjVtDJTITlClmLYtwbg7eEA6p/DRU+qA6oi+85
         yqM4lNCw8XqLpH0rcO4Dlv67jNftHhujWcl2GbBi6IXfc8u6DWcnGD8ce+Mue6J55wLd
         N5hA==
X-Gm-Message-State: AOAM532CCbOAR0EVFvqPI9REsqcXt5CtIMcm4I1gilVzegXEBlfx1guS
        qxz9NexSw6FJrPvvWo3IFS3/BwuLX1T6AphQw8el1+Abb9yq1GSnQ+ybBFUF/DJugqHi48KtKqj
        plUZJGjcVBPcVlza9rb9D
X-Received: by 2002:a17:902:9f94:b029:e3:287f:9a3a with SMTP id g20-20020a1709029f94b02900e3287f9a3amr26089892plq.46.1615315494746;
        Tue, 09 Mar 2021 10:44:54 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxmIuOTGn/jJ1M8D6donszfiP6zS/r+dOnRew9oYYxWY2lp50Z5BXidcDeN+iIS2dJRhP89Ig==
X-Received: by 2002:a17:902:9f94:b029:e3:287f:9a3a with SMTP id g20-20020a1709029f94b02900e3287f9a3amr26089873plq.46.1615315494483;
        Tue, 09 Mar 2021 10:44:54 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id u2sm3830828pjy.14.2021.03.09.10.44.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Mar 2021 10:44:54 -0800 (PST)
Date:   Wed, 10 Mar 2021 02:44:43 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@lst.de>,
        Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH v8 5/5] xfs: add error injection for per-AG resv failure
Message-ID: <20210309184443.GC3537842@xiangao.remote.csb>
References: <20210305025703.3069469-1-hsiangkao@redhat.com>
 <20210305025703.3069469-6-hsiangkao@redhat.com>
 <20210309180503.GX3419940@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210309180503.GX3419940@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 09, 2021 at 10:05:03AM -0800, Darrick J. Wong wrote:
> On Fri, Mar 05, 2021 at 10:57:03AM +0800, Gao Xiang wrote:
> > per-AG resv failure after fixing up freespace is hard to test in an
> > effective way, so directly add an error injection path to observe
> > such error handling path works as expected.
> > 
> > Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
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
> 
> Could you please add the BUILD_BUG_ON somewhere in xfs_error.c to make
> sure that the length of xfs_errortag_random_default matches
> XFS_ERRTAG_MAX?  I inquired about that in the v7 series review, but that
> seems not to have been addressed?

Ah, sorry, I didn't get the point. I've sent out a seperate patch
to address this, please kindly check:
https://lore.kernel.org/r/20210309184205.18675-1-hsiangkao@aol.com

Thanks,
Gao Xiang

> 
> --D
> 
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

