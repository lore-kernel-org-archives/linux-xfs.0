Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3740C433C1
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Mar 2021 01:16:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 80E88619AD
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Mar 2021 01:16:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231409AbhCWBQ1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 22 Mar 2021 21:16:27 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:31617 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231370AbhCWBPz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 Mar 2021 21:15:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616462152;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/NLZkgKRpa257gQeKUDvNyopRt2jPcMdIHXK0Evusqg=;
        b=RdKnStIBvhXg/rTGJw4jUPXBeZWAHNks15vfw7qWHiH5giyzd5enD0XQmM6lfBQ8fhvtFn
        9CLRI1wphTJO0vrCoei1ewugJ41Kz0+F3gjvHxac6xMF0B9+t2IrpmD/SGhJfje9qhHj+/
        /psblS5yMSbnsK6VVRbUH6VSIZkCdNU=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-544-_DmDEPtrNjGE_f9zmIyASw-1; Mon, 22 Mar 2021 21:15:50 -0400
X-MC-Unique: _DmDEPtrNjGE_f9zmIyASw-1
Received: by mail-pj1-f71.google.com with SMTP id e15so579732pjg.6
        for <linux-xfs@vger.kernel.org>; Mon, 22 Mar 2021 18:15:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=/NLZkgKRpa257gQeKUDvNyopRt2jPcMdIHXK0Evusqg=;
        b=cwkm1jXk7oKuhiARVKT+CVfBgYJW6yCIIHgL5JjwU2IKfg73kf55tXvUVO7llIWqlc
         KfcdSctLLZkLzLYwGYx73hLW2NgJeyOSfiEzNTdmKLiW+POgYNU5HiEYr82fOtVdLgsj
         LTMQhWx87qv05w5zhSNZbw8I2DsELeBArqSSDSUHHHLjL2weOGEvH4b2vPTgyeBsYi/I
         Cr1inFZix1MjqBUF7RyvE8snEqbFbTA9SQknrBApbSbeWdYCCqsh9RanxL/IMFTBC4vf
         TtmoUfcioWzWt7U2f67/HSaNaFHBTtEe19h4rNIyl9/aguQ4ddEz2Oek8RcLRJAw7t7O
         SsHA==
X-Gm-Message-State: AOAM533bCMyIb6GwUikJ0Kqy8h4CMODJrfbR2URJG2IwG1Wa0OsVINKA
        m0bzZ3ZujEmSkCsuhLMAQFtwwEvy+dRVzW+icbmX1InRWj/kgnMJu+T19PUsJYfHciO1PP6CbnE
        Tv1bG8U2DDm5+FeL6nCmI
X-Received: by 2002:a62:27c7:0:b029:204:7b11:3222 with SMTP id n190-20020a6227c70000b02902047b113222mr2031577pfn.34.1616462149747;
        Mon, 22 Mar 2021 18:15:49 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzLLLd8WtSPYwtbhBf68g/JrygwTwUZQ5uFC9P0daFKuQGHpIig4YBe9piuQb8nvWLEixvUZw==
X-Received: by 2002:a62:27c7:0:b029:204:7b11:3222 with SMTP id n190-20020a6227c70000b02902047b113222mr2031552pfn.34.1616462149407;
        Mon, 22 Mar 2021 18:15:49 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 143sm15386027pfx.144.2021.03.22.18.15.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 18:15:49 -0700 (PDT)
Date:   Tue, 23 Mar 2021 09:15:38 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@lst.de>,
        Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH v8 4/5] xfs: support shrinking unused space in the last AG
Message-ID: <20210323011538.GA2088959@xiangao.remote.csb>
References: <20210305025703.3069469-1-hsiangkao@redhat.com>
 <20210305025703.3069469-5-hsiangkao@redhat.com>
 <YFh/4A/9OPzHJ2pi@bfoster>
 <20210322120722.GC2000812@xiangao.remote.csb>
 <YFiNATNnkFNAM7MR@bfoster>
 <20210322123652.GB2007006@xiangao.remote.csb>
 <YFiQ5zkOiDHx5YzY@bfoster>
 <20210322125028.GC2007006@xiangao.remote.csb>
 <20210322164255.GE22100@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210322164255.GE22100@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 22, 2021 at 09:42:55AM -0700, Darrick J. Wong wrote:
> On Mon, Mar 22, 2021 at 08:50:28PM +0800, Gao Xiang wrote:
> > On Mon, Mar 22, 2021 at 08:43:19AM -0400, Brian Foster wrote:
> > > On Mon, Mar 22, 2021 at 08:36:52PM +0800, Gao Xiang wrote:
> > > > On Mon, Mar 22, 2021 at 08:26:41AM -0400, Brian Foster wrote:
> > > > > On Mon, Mar 22, 2021 at 08:07:22PM +0800, Gao Xiang wrote:
> > > > > > On Mon, Mar 22, 2021 at 07:30:40AM -0400, Brian Foster wrote:
> > > > > > > On Fri, Mar 05, 2021 at 10:57:02AM +0800, Gao Xiang wrote:
> > > > > > > > As the first step of shrinking, this attempts to enable shrinking
> > > > > > > > unused space in the last allocation group by fixing up freespace
> > > > > > > > btree, agi, agf and adjusting super block and use a helper
> > > > > > > > xfs_ag_shrink_space() to fixup the last AG.
> > > > > > > > 
> > > > > > > > This can be all done in one transaction for now, so I think no
> > > > > > > > additional protection is needed.
> > > > > > > > 
> > > > > > > > Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> > > > > > > > Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> > > > > > > > ---
> > > > > > > >  fs/xfs/xfs_fsops.c | 88 ++++++++++++++++++++++++++++------------------
> > > > > > > >  fs/xfs/xfs_trans.c |  1 -
> > > > > > > >  2 files changed, 53 insertions(+), 36 deletions(-)
> > > > > > > > 
> > > > > > > > diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> > > > > > > > index fc9e799b2ae3..71cba61a451c 100644
> > > > > > > > --- a/fs/xfs/xfs_fsops.c
> > > > > > > > +++ b/fs/xfs/xfs_fsops.c
> > > > > ...
> > > > > > > > @@ -115,10 +120,15 @@ xfs_growfs_data_private(
> > > > > > > >  	if (nb_mod && nb_mod < XFS_MIN_AG_BLOCKS) {
> > > > > > > >  		nagcount--;
> > > > > > > >  		nb = (xfs_rfsblock_t)nagcount * mp->m_sb.sb_agblocks;
> > > > > > > > -		if (nb < mp->m_sb.sb_dblocks)
> > > > > > > > -			return -EINVAL;
> > > > > > > >  	}
> > > > > > > >  	delta = nb - mp->m_sb.sb_dblocks;
> > > > > > > > +	/*
> > > > > > > > +	 * XFS doesn't really support single-AG filesystems, so do not
> > > > > > > > +	 * permit callers to remove the filesystem's second and last AG.
> > > > > > > > +	 */
> > > > > > > > +	if (delta < 0 && nagcount < 2)
> > > > > > > > +		return -EINVAL;
> > > > > > > > +
> > > > > > > 
> > > > > > > What if the filesystem is already single AG? Unless I'm missing
> > > > > > > something, we already have a check a bit further down that prevents
> > > > > > > removal of AGs in the first place.
> > > > > > 
> > > > > > I think it tends to forbid (return -EINVAL) shrinking the filesystem with
> > > > > > a single AG only? Am I missing something?
> > > > > > 
> > > > > 
> > > > > My assumption was this check means one can't shrink a filesystem that is
> > > > > already agcount == 1. The comment refers to preventing shrink from
> > > > > causing an agcount == 1 fs. What is the intent?
> 
> Both of those things.
> 
> > > > 
> > > > I think it means the latter -- preventing shrink from causing an agcount == 1
> > > > fs. since nagcount (new agcount) <= 1?
> > > > 
> > > 
> > > Right, so that leads to my question... does this check also fail a
> > > shrink on an fs that is already agcount == 1? If so, why? I know
> > > technically it's not a supported configuration, but mkfs allows it.
> > 
> > Ah, I'm not sure if Darrick would like to forbid agcount == 1 shrinking
> > functionitity completely, see the previous comment:
> > https://lore.kernel.org/r/20201014160633.GD9832@magnolia/
> > 
> > (please ignore the modification at that time, since it was buggy...)
> 
> Given the confusion I propose a new comment:
> 
> 	/*
> 	 * Reject filesystems with a single AG because they are not
> 	 * supported, and reject a shrink operation that would cause a
> 	 * filesystem to become unsupported.
> 	 */
> 	if (delta < 0 && nagcount < 2)
> 		return -EINVAL;
> 

ok, will update this comment. thanks for your suggestion!

Thanks,
Gao Xiang

> --D

