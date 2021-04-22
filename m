Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C16B9C433ED
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Apr 2021 03:12:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8D20B6142F
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Apr 2021 03:12:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229706AbhDVDNK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 21 Apr 2021 23:13:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:43822 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230319AbhDVDNJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 21 Apr 2021 23:13:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619061151;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=g941PIPgKYOiqckjdBJ/+SUBx0RPwobkxWQQSINFuK8=;
        b=iTJeN0/ResiV2T1JVIQceisSSUEXaqFoKE9FBKgMle/Zoh913OFOG/qSmKNNY3lzv+vrUX
        zup01Xc8dY8bfzpgvRG8Rd/ZT9m26EX9HiiodLfC4+gKJUMHATrcAL02o89R9xg2PkWIZs
        IoctpXkL/f0roGx0ma5iZtY53f0UsFA=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-196-fi5GqeByOrqszkUeMFhr5g-1; Wed, 21 Apr 2021 23:12:28 -0400
X-MC-Unique: fi5GqeByOrqszkUeMFhr5g-1
Received: by mail-pj1-f72.google.com with SMTP id p11-20020a17090ad30bb029014dcd9154e1so1332168pju.0
        for <linux-xfs@vger.kernel.org>; Wed, 21 Apr 2021 20:12:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=g941PIPgKYOiqckjdBJ/+SUBx0RPwobkxWQQSINFuK8=;
        b=M7nZ3ypLc6YkQ98xuyjZ0wnzjZDJDuDa7qAFVNy8jIkiUC+bvKJLqBUcUEy1hgYWXL
         WUMGdSRqRcDPL5ckBv0a3dO0YrEy1EzUz5kShVztwc3mK8gLcUccuNj7w0Ye6cxXvkHD
         bc9L9XFxaXYa03s07SZE7Ck7GAZlTeMAYc1N4Au7qRao1yjM45f78CQdk/X8pr919qoy
         o/rtW4qoHiUra7TJW3HD3tOsy2axZAIT7mNA7c7jLYqheWoQIYFhR+maZZqB5Gkjw/uv
         nXjC4j5FHbNd5fASdXzbj4eTZ6Uu8ir51ah4g9Ohaj2Ol4WKkCmG8U7yN+Sl97f8kr2g
         nS0A==
X-Gm-Message-State: AOAM530Q0aYPgsM0eVwNIx5u5re5ldAtTd+yPSZKJ3B8/fPF6FXnewfc
        B2o4jM0A/kp4TuxmX8Vill/ArmrSGC3SHCcxzyqUnsHhNx5F6Q8tefcrA+n7qwlzVGrmqKfisKg
        s6g+FcryfgD44LjRmCt7z
X-Received: by 2002:a17:90a:db49:: with SMTP id u9mr15477673pjx.209.1619061146965;
        Wed, 21 Apr 2021 20:12:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw6C7+FD+fOWxxB96VTFeqyr1sHrqyXXv03KEJTqsFIVXUix6V3zCttk+ApTZYTtCCr7bx58w==
X-Received: by 2002:a17:90a:db49:: with SMTP id u9mr15477652pjx.209.1619061146629;
        Wed, 21 Apr 2021 20:12:26 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id q25sm526161pfs.152.2021.04.21.20.12.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Apr 2021 20:12:26 -0700 (PDT)
Date:   Thu, 22 Apr 2021 11:12:15 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>,
        Zorro Lang <zlang@redhat.com>,
        Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH v2 1/2] xfs: don't use in-core per-cpu fdblocks for
 !lazysbcount
Message-ID: <20210422031215.GA3279839@xiangao.remote.csb>
References: <20210420110855.2961626-1-hsiangkao@redhat.com>
 <20210420212506.GW63242@dread.disaster.area>
 <20210420215443.GA3047037@xiangao.remote.csb>
 <20210421014526.GY63242@dread.disaster.area>
 <20210421030129.GA3095436@xiangao.remote.csb>
 <20210422014446.GZ63242@dread.disaster.area>
 <20210422020613.GB3264012@xiangao.remote.csb>
 <20210422030102.GA63242@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210422030102.GA63242@dread.disaster.area>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Apr 22, 2021 at 01:01:02PM +1000, Dave Chinner wrote:
> On Thu, Apr 22, 2021 at 10:06:13AM +0800, Gao Xiang wrote:
> > Hi Dave,
> > 
> > On Thu, Apr 22, 2021 at 11:44:46AM +1000, Dave Chinner wrote:
> > > On Wed, Apr 21, 2021 at 11:01:29AM +0800, Gao Xiang wrote:
> > > > On Wed, Apr 21, 2021 at 11:45:26AM +1000, Dave Chinner wrote:
> > > > > On Wed, Apr 21, 2021 at 05:54:43AM +0800, Gao Xiang wrote:
> > > > > #1 is bad because there are cases where we want to write the
> > > > > counters even for !lazysbcount filesystems (e.g. mkfs, repair, etc).
> > > > > 
> > > > > #2 is essentially a hack around the fact that mp->m_sb is not kept
> > > > > up to date in the in-memory superblock for !lazysbcount filesystems.
> > > > > 
> > > > > #3 keeps the in-memory superblock up to date for !lazysbcount case
> > > > > so they are coherent with the on-disk values and hence we only need
> > > > > to update the in-memory superblock counts for lazysbcount
> > > > > filesystems before calling xfs_sb_to_disk().
> > > > > 
> > > > > #3 is my preferred solution.
> > > > > 
> > > > > > That will indeed cause more modification, I'm not quite sure if it's
> > > > > > quite ok honestly. But if you assume that's more clear, I could submit
> > > > > > an alternative instead later.
> > > > > 
> > > > > I think the version you posted doesn't fix the entire problem. It
> > > > > merely slaps a band-aid over the symptom that is being seen, and
> > > > > doesn't address all the non-coherent data that can be written to the
> > > > > superblock here.
> > > > 
> > > > As I explained on IRC as well, I think for !lazysbcount cases, fdblocks,
> > > > icount and ifree are protected by sb buffer lock. and the only users of
> > > > these three are:
> > > >  1) xfs_trans_apply_sb_deltas()
> > > >  2) xfs_log_sb()
> > > 
> > > That's just a happy accident and not intentional in any way. Just
> > > fixing the case that occurs while holding the sb buffer lock doesn't
> > > actually fix the underlying problem, it just uses this as a bandaid.
> > 
> > I think for !lazysbcases, sb buffer lock is only a reliable lock that
> > can be relied on for serialzing (since we need to make sure each sb
> > write matches the corresponding fdblocks, ifree, icount. So sb buffer
> > needs be locked every time. So so need to recalc on dirty log.)
> > > 
> > > > 
> > > > So I've seen no need to update sb_icount, sb_ifree in that way (I mean
> > > > my v2, although I agree it's a bit hacky.) only sb_fdblocks matters.
> > > > 
> > > > But the reason why this patch exist is only to backport to old stable
> > > > kernels, since after [PATCH v2 2/2], we can get rid of all of
> > > > !lazysbcount cases upstream.
> > > > 
> > > > But if we'd like to do more e.g. by taking m_sb_lock, I've seen the
> > > > xfs codebase quite varies these years. and I modified some version
> > > > like http://paste.debian.net/1194481/
> > > 
> > > I said on IRC that this is what xfs_trans_unreserve_and_mod_sb() is
> > > for. For !lazysbcount filesystems the transaction will be marked
> > > dirty (i.e XFS_TRANS_SB_DIRTY is set) and so we'll always run the
> > > slow path that takes the m_sb_lock and updates mp->m_sb. 
> > > 
> > > It's faster for me to explain this by patch than any other way. See
> > > below.
> > 
> > I know what you mean, but there exists 3 things:
> >  1) we be64_add_cpu() on-disk fdblocks, ifree, icount at
> >     xfs_trans_apply_sb_deltas(), and then do the same bahavior in
> >     xfs_trans_unreserve_and_mod_sb() for in-memory counters again.
> >     that is (somewhat) fragile.
> 
> That's exactly how the superblock updates have been done since the
> mid 1990s. It's the way it was intended to work:
> 
> - xfs_trans_apply_sb_deltas() applies the changes to the on
>   disk superblock
> - xfs_trans_unreserve_and_mod_sb() applies the changes to the
>   in-memory superblock.
> 
> All my patch does is follow the long established separation of
> update responsibilities. It is actually returning the code to the
> behaviour we had before lazy superblock counters were introduced.
> 
> >  2) m_sb_lock behaves no effect at this. This lock between
> >     xfs_log_sb() and xfs_trans_unreserve_and_mod_sb() is still
> >     sb buffer lock for !lazysbcount cases.
> 
> The m_sb_lock doesn't need to have any effect on this. It's to
> prevent concurrent updates of the in-core superblock, not to prevent
> access to the superblock buffer.
> 
> i.e. the superblock buffer lock protects against concurrent updates
> of the superblock buffer, and hence while progating and logging
> changes to the superblock buffer we have to have the superblock
> buffer locked.
> 
> >  3) in-memory sb counters are serialized by some spinlock now,
> 
> No, they are not. Lazysbcount does not set XFS_TRANS_SB_DIRTY
> for pure ifree/icount/fdblock updates, so it never runs the code
> I modified in xfs_trans_unreserve_and_mod_sb() unless some other
> part of the superblock is changed.
> 
> For !lazysbcount, we always run this path because XFS_TRANS_SB_DIRTY
> is always set.
> 
> >     so I'm not sure sb per-CPU counters behave for lazysbcount
> >     cases, are these used for better performance?
> 
> It does not change behaviour of anything at all, execpt the counter
> values for !lazysbcount filesystems are now always kept correctly up
> to date.
> 
> > >  	xfs_sb_to_disk(bp->b_addr, &mp->m_sb);
> > >  	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_SB_BUF);
> > > diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> > > index bcc978011869..438e41931b55 100644
> > > --- a/fs/xfs/xfs_trans.c
> > > +++ b/fs/xfs/xfs_trans.c
> > > @@ -629,6 +629,9 @@ xfs_trans_unreserve_and_mod_sb(
> > >  
> > >  	/* apply remaining deltas */
> > >  	spin_lock(&mp->m_sb_lock);
> > > +	mp->m_sb.sb_fdblocks += blkdelta;
> > 
> > not sure that is quite equal to blkdelta, since (I think) we might need
> > to apply t_res_fdblocks_delta for !lazysbcount cases but not lazysbcount
> > cases, but I'm not quite sure, just saw the comment above
> > xfs_trans_unreserve_and_mod_sb() and the implementation of
> > xfs_trans_apply_sb_deltas().
> 
> Yes, I forgot about the special delayed allocation space accounting.
> We'll have to add that, too, so it becomes:
> 
> +	mp->m_sb.sb_fdblocks += blkdelta + tp->t_res_fdblocks_delta;
> +	mp->m_sb.sb_icount += idelta;
> +	mp->m_sb.sb_ifree += ifreedelta;
> 
> But this doesn't change the structure of the patch in any way.

Anyway, I think this'd be absolutely fine to fix this issue as well,
so:

Reviewed-by: Gao Xiang <hsiangkao@redhat.com>

(Although I still insist on my v2 [just my own thought] since in-memory
 sb counters are totally unused/reserved compared with on-disk sb counters
 for sb_fdblocks and per-CPU sb counters for sb_ifree / sb_icount for
 the whole !lazysbcount cases, maybe adding some comments is better.
 But I'm also fine if the patch goes like this ;) )

Thanks,
Gao Xiang

> 
> CHeers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

