Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-21.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B8C7C433ED
	for <linux-xfs@archiver.kernel.org>; Sat, 17 Apr 2021 00:19:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 218CD60E0C
	for <linux-xfs@archiver.kernel.org>; Sat, 17 Apr 2021 00:19:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234965AbhDQAUI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 16 Apr 2021 20:20:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:38872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231997AbhDQAUI (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 16 Apr 2021 20:20:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E34FB6115B;
        Sat, 17 Apr 2021 00:19:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618618783;
        bh=0HhjDgIS0VpZOi1MtoI2f23YCX6st/xc9UsK1k02a2U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mGyFIjz8QCyjFqqrUGj3du4h90d7VUfnEv+LR9Kx8sEFhef0S+ukeNUk9NXxLQtXv
         7HmJKZHlNyuuTC8KEaHXTBZ6Ihi+/O6J3b9iBxQfQmWl0Ax4Aw46MIuV3u0CzPalJp
         cNasyWk784pcFPw1V3iXL9EmigRCFQYbDxCgsdc9tOXiK6jF1+mWaJeL4rao7yJ9vT
         +QhSEHL6OlzIa5WDiiJUJYsu4O0+0XUWkVyxDTXNfvpIA4vkib2GImaHU3Ud3twb9w
         I7l6d4vMoUmGd1ObIju+nIn75SzVVKNS432EqMQVnF43YxRnud6L5Fg6otNO+VU0BF
         CU06wCBbutbQA==
Date:   Fri, 16 Apr 2021 17:19:41 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     linux-xfs@vger.kernel.org, Zorro Lang <zlang@redhat.com>
Subject: Re: [PATCH] xfs: don't use in-core per-cpu fdblocks for !lazysbcount
Message-ID: <20210417001941.GC3122276@magnolia>
References: <20210416091023.2143162-1-hsiangkao@redhat.com>
 <20210416160013.GB3122264@magnolia>
 <20210416211320.GB2224153@xiangao.remote.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210416211320.GB2224153@xiangao.remote.csb>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Apr 17, 2021 at 05:13:20AM +0800, Gao Xiang wrote:
> Hi Darrick,
> 
> On Fri, Apr 16, 2021 at 09:00:13AM -0700, Darrick J. Wong wrote:
> > On Fri, Apr 16, 2021 at 05:10:23PM +0800, Gao Xiang wrote:
> > > There are many paths which could trigger xfs_log_sb(), e.g.
> > >   xfs_bmap_add_attrfork()
> > >     -> xfs_log_sb()
> > > , which overrided on-disk fdblocks by in-core per-CPU fdblocks.
> > > 
> > > However, for !lazysbcount cases, on-disk fdblocks is actually updated
> > > by xfs_trans_apply_sb_deltas(), and generally it isn't equal to
> > > in-core fdblocks due to xfs_reserve_block() or whatever, see the
> > > comment in xfs_unmountfs().
> > > 
> > > It could be observed by the following steps reported by Zorro [1]:
> > > 
> > > 1. mkfs.xfs -f -l lazy-count=0 -m crc=0 $dev
> > > 2. mount $dev $mnt
> > > 3. fsstress -d $mnt -p 100 -n 1000 (maybe need more or less io load)
> > > 4. umount $mnt
> > > 5. xfs_repair -n $dev
> > > 
> > > yet due to commit f46e5a174655("xfs: fold sbcount quiesce logging
> > > into log covering"), xfs_sync_sb() will be triggered even !lazysbcount
> > > but xfs_log_need_covered() case when xfs_unmountfs(), so hard to
> > > reproduce on kernel 5.12+.
> > 
> > Um, I can't understand this(?), possibly because I can't get to RHBZ and
> > therefore have very little context to start from. :(
> 
> Very sorry about that.. I realized it doesn't access at all without some
> permission after sending out the patch. :(

To be fair, I don't think it's part of the standard training that even
the public bugzilla bugs aren't visible to certain least-favored
nations. ;)

> > 
> > Are you saying that because the f46e commit removed the xfs_sync_sb
> > calls from unmountfs for !lazysb filesystems, we no longer log the
> > summary counters at unmount?  Which means that we no longer write the
> > incore percpu fdblocks count to disk at unmount after we've torn down
> > all the incore space reservations (when sb_fdblocks == m_fdblocks)?
> 
> Er.. I think that is by reverse, before commit f46e, we no longer logged
> the summary counters at unmount, due to 
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/fs/xfs/xfs_mount.c?h=v5.11#n1177
>   xfs_unmountfs
>     -> xfs_log_sbcount
>       -> !xfs_sb_version_haslazysbcount
>         -> return 0 (xfs_sync_sb bypassed).
> 
> So the only time we update the ondisk fdblocks was during transactions,
> but xfs_log_sb() corrupted this (due to no summary counters logging at
> unmount).

*OH* ok, so this isn't a fix for a regression in Brian's log covering
refactoring series that went into 5.12; this is a fix for a years old
bug that may very well have been there since the introduction of ...
delayed allocation?  I guess?

At least that makes the justification easier -- in !lazysbcount mode, we
must only update the primary super's fdblocks counter to reflect
whatever update we made to the ondisk metadata, which means that we have
to use mp->m_sb.sb_fdblocks.

(Whereas in lazysbcount mode where we only update the sb counters as
part of cleanly unmounting the log after purging all the incore
reservations and therefore can use m_fdblocks...)

> 
> After f46e, it became
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/fs/xfs/xfs_log.c?h=v5.12-rc2#n982
>   xfs_unmountfs
>     -> xfs_log_unmount
>       -> xfs_log_clean
>         -> xfs_log_cover
> 
> So if xfs_log_need_covered(mp) == true and
> !xfs_sb_version_haslazysbcount(&mp->m_sb),
> xfs_sync_sb() will be triggered to cover the log, So
> it's hard to reproduce on the current kernel (at least on my side.)

Ah

> But I have no idea xfs_log_need_covered(mp) is always true at that time,
> and the patchset seems a bit large and (possibly) hard to backport...

I wouldn't backport that to a stable series. :)

> > So that means that for !lazysb fses, the only time we log the sb
> > counters is during transactions, and when we do log the counters we
> > actually log the wrong value, since the incore reservations should never
> > escape to disk?  Hence the fix below?
> 
> Yes
> 
> > 
> > And then by extension, is the reason that nobody noticed before is that
> > we always used to log the correct value at unmount, so fses with clean
> > logs always have the correct value, and fses with dirty logs will
> > recompute fdblocks after log recovery by summing the AGF free blocks
> > counts?
> 
> Nope, prior to 5.12-rc1, I think it was broken for a very long time...

Yeah, I got that backwards. :(

> > 
> > (Or possibly nobody uses !lazysb filesystems anymore?)
> > 
> 
> Zorro found this days ago on rhel 8 kernel (4.18, maybe he's doing
> some new testcases to cover this), and I think it was broken for much
> much long time (I don't know which version it was broken first), maybe
> it has little impact since it's just a freespace block counter.

Wrong counters mean wrong ENOSPC decisions...

> So I think it should be backported to many stable kernel versions (?)
> But I have no idea when it was broken...
> 
> > I /think/ the code change looks ok, but as you might surmise from the
> > large quantity of questions, I'm not ready to RVB this yet.  The commit
> > message seems like a good place to answer those questions.
> > 
> > > After this patch, I've seen no strange so far on older kernels
> > > for the testcase above without lazysbcount.
> > > 
> > > [1] https://bugzilla.redhat.com/show_bug.cgi?id=1949515
> > 
> > This strangely <cough> doesn't seem to be accessible to the public at
> > large, since <cough> someone at RedHat decided to block all Oracle IPs
> > <cough>.
> 
> <cough> will get rid of it the next time...
> 
> Thanks,
> Gao Xiang
> 
> > 
> > --D
> > 
> > > 
> > > Reported-by: Zorro Lang <zlang@redhat.com>
> > > Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> > > ---
> > >  fs/xfs/libxfs/xfs_sb.c | 8 +++++++-
> > >  1 file changed, 7 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> > > index 60e6d255e5e2..423dada3f64c 100644
> > > --- a/fs/xfs/libxfs/xfs_sb.c
> > > +++ b/fs/xfs/libxfs/xfs_sb.c
> > > @@ -928,7 +928,13 @@ xfs_log_sb(
> > >  
> > >  	mp->m_sb.sb_icount = percpu_counter_sum(&mp->m_icount);
> > >  	mp->m_sb.sb_ifree = percpu_counter_sum(&mp->m_ifree);
> > > -	mp->m_sb.sb_fdblocks = percpu_counter_sum(&mp->m_fdblocks);
> > > +	if (!xfs_sb_version_haslazysbcount(&mp->m_sb)) {
> > > +		struct xfs_dsb	*dsb = bp->b_addr;
> > > +
> > > +		mp->m_sb.sb_fdblocks = be64_to_cpu(dsb->sb_fdblocks);

Hmm... is this really needed?  I thought in !lazysbcount mode,
xfs_trans_apply_sb_deltas updates the ondisk super buffer directly.
So aren't all three of these updates unnecessary?

--D

> > > +	} else {
> > > +		mp->m_sb.sb_fdblocks = percpu_counter_sum(&mp->m_fdblocks);
> > > +	}
> > >  
> > >  	xfs_sb_to_disk(bp->b_addr, &mp->m_sb);
> > >  	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_SB_BUF);
> > > -- 
> > > 2.27.0
> > > 
> > 
> 
