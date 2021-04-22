Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C020C433B4
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Apr 2021 15:58:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F412C613DE
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Apr 2021 15:58:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236459AbhDVP7b (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 22 Apr 2021 11:59:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:50162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237450AbhDVP72 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 22 Apr 2021 11:59:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7391D613DE;
        Thu, 22 Apr 2021 15:58:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619107133;
        bh=3xeONTrceZ98lzKwDrcp4Ch+BxGa07s4P5X6t7OPTgY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=l5NyNyd66z2zyUCFanNsDswTpyrT6bJKFTmOBZZkbDms8/sjswUAHRY+j4apdcQDP
         7oSYq6Lik+z73iPFQ8hfevY/a4Qrn/OXeRG2fSnfMKoVk4O2RM1mYIailBmatCoJEz
         MQy2f0C9g8ruVIdmzJXq7EECTVIh8xRhGGOG/DBUOzKryjnfOJX5noJgTrpj3Zbpxi
         8fDaHJ9eSJOxAdOHE+mQ4PckgA0CEaKPlSN9vCOo7eiY6mzcrQo0KPBVl+qX+7ggnA
         Wdy0mxRWV8yOmAc/dVFqcvsfIS1XViFtW8EO4tfx+HSL3QqHo1+eWo8mB/fQdpMxa3
         thtAwjxnV9dng==
Date:   Thu, 22 Apr 2021 08:58:52 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org,
        Zorro Lang <zlang@redhat.com>,
        Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH v2 1/2] xfs: don't use in-core per-cpu fdblocks for
 !lazysbcount
Message-ID: <20210422155852.GW3122264@magnolia>
References: <20210420110855.2961626-1-hsiangkao@redhat.com>
 <20210420212506.GW63242@dread.disaster.area>
 <20210420215443.GA3047037@xiangao.remote.csb>
 <20210421014526.GY63242@dread.disaster.area>
 <20210421030129.GA3095436@xiangao.remote.csb>
 <20210422014446.GZ63242@dread.disaster.area>
 <20210422020613.GB3264012@xiangao.remote.csb>
 <20210422030102.GA63242@dread.disaster.area>
 <20210422031215.GA3279839@xiangao.remote.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210422031215.GA3279839@xiangao.remote.csb>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Apr 22, 2021 at 11:12:15AM +0800, Gao Xiang wrote:
> On Thu, Apr 22, 2021 at 01:01:02PM +1000, Dave Chinner wrote:
> > On Thu, Apr 22, 2021 at 10:06:13AM +0800, Gao Xiang wrote:
> > > Hi Dave,
> > > 
> > > On Thu, Apr 22, 2021 at 11:44:46AM +1000, Dave Chinner wrote:
> > > > On Wed, Apr 21, 2021 at 11:01:29AM +0800, Gao Xiang wrote:
> > > > > On Wed, Apr 21, 2021 at 11:45:26AM +1000, Dave Chinner wrote:
> > > > > > On Wed, Apr 21, 2021 at 05:54:43AM +0800, Gao Xiang wrote:
> > > > > > #1 is bad because there are cases where we want to write the
> > > > > > counters even for !lazysbcount filesystems (e.g. mkfs, repair, etc).
> > > > > > 
> > > > > > #2 is essentially a hack around the fact that mp->m_sb is not kept
> > > > > > up to date in the in-memory superblock for !lazysbcount filesystems.
> > > > > > 
> > > > > > #3 keeps the in-memory superblock up to date for !lazysbcount case
> > > > > > so they are coherent with the on-disk values and hence we only need
> > > > > > to update the in-memory superblock counts for lazysbcount
> > > > > > filesystems before calling xfs_sb_to_disk().
> > > > > > 
> > > > > > #3 is my preferred solution.
> > > > > > 
> > > > > > > That will indeed cause more modification, I'm not quite sure if it's
> > > > > > > quite ok honestly. But if you assume that's more clear, I could submit
> > > > > > > an alternative instead later.
> > > > > > 
> > > > > > I think the version you posted doesn't fix the entire problem. It
> > > > > > merely slaps a band-aid over the symptom that is being seen, and
> > > > > > doesn't address all the non-coherent data that can be written to the
> > > > > > superblock here.
> > > > > 
> > > > > As I explained on IRC as well, I think for !lazysbcount cases, fdblocks,
> > > > > icount and ifree are protected by sb buffer lock. and the only users of
> > > > > these three are:
> > > > >  1) xfs_trans_apply_sb_deltas()
> > > > >  2) xfs_log_sb()
> > > > 
> > > > That's just a happy accident and not intentional in any way. Just
> > > > fixing the case that occurs while holding the sb buffer lock doesn't
> > > > actually fix the underlying problem, it just uses this as a bandaid.
> > > 
> > > I think for !lazysbcases, sb buffer lock is only a reliable lock that
> > > can be relied on for serialzing (since we need to make sure each sb
> > > write matches the corresponding fdblocks, ifree, icount. So sb buffer
> > > needs be locked every time. So so need to recalc on dirty log.)
> > > > 
> > > > > 
> > > > > So I've seen no need to update sb_icount, sb_ifree in that way (I mean
> > > > > my v2, although I agree it's a bit hacky.) only sb_fdblocks matters.
> > > > > 
> > > > > But the reason why this patch exist is only to backport to old stable
> > > > > kernels, since after [PATCH v2 2/2], we can get rid of all of
> > > > > !lazysbcount cases upstream.
> > > > > 
> > > > > But if we'd like to do more e.g. by taking m_sb_lock, I've seen the
> > > > > xfs codebase quite varies these years. and I modified some version
> > > > > like http://paste.debian.net/1194481/
> > > > 
> > > > I said on IRC that this is what xfs_trans_unreserve_and_mod_sb() is
> > > > for. For !lazysbcount filesystems the transaction will be marked
> > > > dirty (i.e XFS_TRANS_SB_DIRTY is set) and so we'll always run the
> > > > slow path that takes the m_sb_lock and updates mp->m_sb. 
> > > > 
> > > > It's faster for me to explain this by patch than any other way. See
> > > > below.
> > > 
> > > I know what you mean, but there exists 3 things:
> > >  1) we be64_add_cpu() on-disk fdblocks, ifree, icount at
> > >     xfs_trans_apply_sb_deltas(), and then do the same bahavior in
> > >     xfs_trans_unreserve_and_mod_sb() for in-memory counters again.
> > >     that is (somewhat) fragile.
> > 
> > That's exactly how the superblock updates have been done since the
> > mid 1990s. It's the way it was intended to work:
> > 
> > - xfs_trans_apply_sb_deltas() applies the changes to the on
> >   disk superblock
> > - xfs_trans_unreserve_and_mod_sb() applies the changes to the
> >   in-memory superblock.
> > 
> > All my patch does is follow the long established separation of
> > update responsibilities. It is actually returning the code to the
> > behaviour we had before lazy superblock counters were introduced.
> > 
> > >  2) m_sb_lock behaves no effect at this. This lock between
> > >     xfs_log_sb() and xfs_trans_unreserve_and_mod_sb() is still
> > >     sb buffer lock for !lazysbcount cases.
> > 
> > The m_sb_lock doesn't need to have any effect on this. It's to
> > prevent concurrent updates of the in-core superblock, not to prevent
> > access to the superblock buffer.
> > 
> > i.e. the superblock buffer lock protects against concurrent updates
> > of the superblock buffer, and hence while progating and logging
> > changes to the superblock buffer we have to have the superblock
> > buffer locked.
> > 
> > >  3) in-memory sb counters are serialized by some spinlock now,
> > 
> > No, they are not. Lazysbcount does not set XFS_TRANS_SB_DIRTY
> > for pure ifree/icount/fdblock updates, so it never runs the code
> > I modified in xfs_trans_unreserve_and_mod_sb() unless some other
> > part of the superblock is changed.
> > 
> > For !lazysbcount, we always run this path because XFS_TRANS_SB_DIRTY
> > is always set.
> > 
> > >     so I'm not sure sb per-CPU counters behave for lazysbcount
> > >     cases, are these used for better performance?
> > 
> > It does not change behaviour of anything at all, execpt the counter
> > values for !lazysbcount filesystems are now always kept correctly up
> > to date.
> > 
> > > >  	xfs_sb_to_disk(bp->b_addr, &mp->m_sb);
> > > >  	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_SB_BUF);
> > > > diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> > > > index bcc978011869..438e41931b55 100644
> > > > --- a/fs/xfs/xfs_trans.c
> > > > +++ b/fs/xfs/xfs_trans.c
> > > > @@ -629,6 +629,9 @@ xfs_trans_unreserve_and_mod_sb(
> > > >  
> > > >  	/* apply remaining deltas */
> > > >  	spin_lock(&mp->m_sb_lock);
> > > > +	mp->m_sb.sb_fdblocks += blkdelta;
> > > 
> > > not sure that is quite equal to blkdelta, since (I think) we might need
> > > to apply t_res_fdblocks_delta for !lazysbcount cases but not lazysbcount
> > > cases, but I'm not quite sure, just saw the comment above
> > > xfs_trans_unreserve_and_mod_sb() and the implementation of
> > > xfs_trans_apply_sb_deltas().
> > 
> > Yes, I forgot about the special delayed allocation space accounting.
> > We'll have to add that, too, so it becomes:
> > 
> > +	mp->m_sb.sb_fdblocks += blkdelta + tp->t_res_fdblocks_delta;
> > +	mp->m_sb.sb_icount += idelta;
> > +	mp->m_sb.sb_ifree += ifreedelta;
> > 
> > But this doesn't change the structure of the patch in any way.
> 
> Anyway, I think this'd be absolutely fine to fix this issue as well,
> so:
> 
> Reviewed-by: Gao Xiang <hsiangkao@redhat.com>
> 
> (Although I still insist on my v2 [just my own thought] since in-memory
>  sb counters are totally unused/reserved compared with on-disk sb counters
>  for sb_fdblocks and per-CPU sb counters for sb_ifree / sb_icount for
>  the whole !lazysbcount cases, maybe adding some comments is better.
>  But I'm also fine if the patch goes like this ;) )

Does this patch (+ other fixes) fix the problem?  If Zorro says it's ok,
please send this as a formal patch submission so it isn't buried in a
thread.

--D

> Thanks,
> Gao Xiang
> 
> > 
> > CHeers,
> > 
> > Dave.
> > -- 
> > Dave Chinner
> > david@fromorbit.com
> > 
> 
