Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69D66C433E0
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Feb 2021 14:01:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3FA4564F53
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Feb 2021 14:01:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236567AbhBDOBO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 4 Feb 2021 09:01:14 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:50214 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236371AbhBDOAU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Feb 2021 09:00:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612447125;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=F06ppWlV3Nk73wznkHKKYOncPFzWQGiTMMT/1aA5v18=;
        b=I8upJx+S5fk8RCFBA48I2TAhiscb04CMgabk57ZvV4d8FoMVHWIv3KIkhuvHo3SINUSwn/
        vA01UL9E91LPIX87rcZm3ubing6HAbSEVOjONdN3LCHxsA2DkOqD552VOd45gKOeT5ffrl
        lq0hEq94i9AKOyrguLbUI0vwHMsTwO8=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-256-tzrSspNzPMyprPcdUau7eQ-1; Thu, 04 Feb 2021 08:58:43 -0500
X-MC-Unique: tzrSspNzPMyprPcdUau7eQ-1
Received: by mail-pg1-f200.google.com with SMTP id f4so2265970pgk.19
        for <linux-xfs@vger.kernel.org>; Thu, 04 Feb 2021 05:58:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=F06ppWlV3Nk73wznkHKKYOncPFzWQGiTMMT/1aA5v18=;
        b=g2iGa0Bps+X25PlXCiS1Z3mRC4Lz/D4hebh3hGorfvIlZhT5ihR+Toq8kwF7PEImR/
         2A6tFRAl1g+bRPoKdc5WiA6D2ofLC7MX09IwQqBakNtELTR6ogHVULFor8T+BfXDrHFg
         NjfJT8DXsSyuRnbbDnUG9qVRUD4o3t/+CaILDphy/oLQCVZjo/i4DldlWkX+fUcbgAjO
         /qjn0hEU8KFlysR9MF6dPD9Mgf0zldOzgnKz+Y8/iyRWg/VSt+Q3LgmksPjTPLFpacQz
         qrNOGiQ4jBGkKb4Bk8gcT9yqrxt90ZRSjCfbeBsbMphgYWia+sgixgK2mgAp8IBEWoUJ
         M/Yg==
X-Gm-Message-State: AOAM530GxBQ1tU2DhPhpAUhajRRZxx7uP8FhoIZV15FjFcJnPNqDwHY6
        GntrCdw6FgUKJVENEFOg830/6oJ4hFs71Ew/0W/ehiZeFe7Tbngkk4awGh6FLi0V2sj2Mnq1Aje
        USdTvMLuhryGYyvpV3Jq8
X-Received: by 2002:a62:6304:0:b029:1c0:d62d:d213 with SMTP id x4-20020a6263040000b02901c0d62dd213mr8282492pfb.79.1612447121962;
        Thu, 04 Feb 2021 05:58:41 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyB28koUsyyn8AIJKAApgso5mY7UVjGppXz+vbCms3SpgOySxiV9ysQ2nEZHMx2nxkEsOcdtA==
X-Received: by 2002:a62:6304:0:b029:1c0:d62d:d213 with SMTP id x4-20020a6263040000b02901c0d62dd213mr8282468pfb.79.1612447121594;
        Thu, 04 Feb 2021 05:58:41 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id y10sm6159122pff.197.2021.02.04.05.58.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Feb 2021 05:58:41 -0800 (PST)
Date:   Thu, 4 Feb 2021 21:58:30 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v6 6/7] xfs: support shrinking unused space in the last AG
Message-ID: <20210204135830.GD149518@xiangao.remote.csb>
References: <20210126125621.3846735-1-hsiangkao@redhat.com>
 <20210126125621.3846735-7-hsiangkao@redhat.com>
 <20210203142337.GB3647012@bfoster>
 <20210203145146.GA935062@xiangao.remote.csb>
 <20210203181211.GZ7193@magnolia>
 <20210203190217.GA20513@xiangao.remote.csb>
 <20210204123303.GA3716033@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210204123303.GA3716033@bfoster>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Brian,

On Thu, Feb 04, 2021 at 07:33:03AM -0500, Brian Foster wrote:
> On Thu, Feb 04, 2021 at 03:02:17AM +0800, Gao Xiang wrote:

....

> > > 
> > > Long question:
> > > 
> > > The reason why we use (nb - dblocks) is because growfs is an all or
> > > nothing operation -- either we succeed in writing new empty AGs and
> > > inflating the (former) last AG of the fs, or we don't do anything at
> > > all.  We don't allow partial growing; if we did, then delta would be
> > > relevant here.  I think we get away with not needing to run transactions
> > > for each AG because those new AGs are inaccessible until we commit the
> > > new agcount/dblocks, right?
> > > 
> > > In your design for the fs shrinker, do you anticipate being able to
> > > eliminate all the eligible AGs in a single transaction?  Or do you
> > > envision only tackling one AG at a time?  And can we be partially
> > > successful with a shrink?  e.g. we succeed at eliminating the last AG,
> > > but then the one before that isn't empty and so we bail out, but by that
> > > point we did actually make the fs a little bit smaller.
> > 
> > Thanks for your question. I'm about to sleep, I might try to answer
> > your question here.
> > 
> > As for my current experiement / understanding, I think eliminating all
> > the empty AGs + shrinking the tail AG in a single transaction is possible,
> > that is what I'm done for now;
> >  1) check the rest AGs are empty (from the nagcount AG to the oagcount - 1
> >     AG) and mark them all inactive (AGs freezed);
> >  2) consume an extent from the (nagcount - 1) AG;
> >  3) decrease the number of agcount from oagcount to nagcount.
> > 
> > Both 2) and 3) can be done in the same transaction, and after 1) the state
> > of such empty AGs is fixed as well. So on-disk fs and runtime states are
> > all in atomic.
> > 
> > > 
> > > There's this comment at the bottom of xfs_growfs_data() that says that
> > > we can return error codes if the secondary sb update fails, even if the
> > > new size is already live.  This convinces me that it's always been the
> > > case that callers of the growfs ioctl are supposed to re-query the fs
> > > geometry afterwards to find out if the fs size changed, even if the
> > > ioctl itself returns an error... which implies that partial grow/shrink
> > > are a possibility.
> > > 
> > 
> > I didn't realize that possibility but if my understanding is correct
> > the above process is described as above so no need to use incremental
> > shrinking by its design. But it also support incremental shrinking if
> > users try to use the ioctl for multiple times.
> > 
> 
> This was one of the things I wondered about on an earlier versions of
> this work; whether we wanted to shrink to be deliberately incremental or
> not. I suspect that somewhat applies to even this version without AG
> truncation because technically we could allocate as much as possible out
> of end of the last AG and shrink by that amount. My initial thought was
> that if the implementation is going to be opportunistic (i.e., we
> provide no help to actually free up targeted space), perhaps an
> incremental implementation is a useful means to allow the operation to
> make progress. E.g., run a shrink, observe it didn't fully complete,
> shuffle around some files, repeat, etc. 
> 
> IIRC, one of the downsides of that sort of approach is any use case
> where the goal is an underlying storage device resize. I suppose an
> underlying device resize could also be opportunistic, but it seems more
> likely to me that use case would prefer an all or nothing approach,
> particularly if associated userspace tools don't really know how to
> handle a partially successful fs shrink. Do we have any idea how other
> tools/fs' behave in this regard (I thought ext4 supported shrink)? FWIW,
> it also seems potentially annoying to ask for a largish shrink only for
> the tool to hand back something relatively tiny.
> 
> Based on your design description, it occurs to me that perhaps the ideal
> outcome is an implementation that supports a fully atomic all-or-nothing
> shrink (assuming this is reasonably possible), but supports an optional
> incremental mode specified by the interface. IOW, if we have the ability
> to perform all-or-nothing, then it _seems_ like a minor interface
> enhancement to support incremental on top of that as opposed to the
> other way around. Therefore, perhaps that should be the initial goal
> until shown to be too complex or otherwise problematic..?
> 

I cannot say too much of this, yet my current observation is that
shrinking tail empty AG [+ empty AGs (optional)] in one transaction
is practical (I don't see any barrier so far [1]). I'm implementing
an atomic all-or-nothing truncation and userspace can utilize it to
implement in all-or-nothing way (I saw Dave's spaceman work before) or
incremental way (by using binary search approach and multiple ioctls)...
In principle, supporting the ioctl with the extra partial shrinking
feature is practial as well (but additional work might need to be
done). And also, I'm not sure it's user-friendly since most end-users
might want an all-or-nothing shrinking (at least in the fs truncation
step) result.

btw, afaik (my limited understanding), Ext4 shrinking is an offline
approach so it's somewhat easier to implement (no need to consider
any runtime impact), which is also considered as an all-or-nothing
truncation as well (Although it also supports -M to shrink the
filesystem to the minimum size, I think it can be implemented by
multiple all-or-nothing shrink ioctls...)

Thanks,
Gao Xiang

[1] it's somewhat outdated yet I'd like to finish this tail AG patchset
first
https://git.kernel.org/pub/scm/linux/kernel/git/xiang/linux.git/log/?h=xfs/shrink2

> Brian
>

