Return-Path: <SRS0=XuOj=AU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59CDAC433E0
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Jul 2020 02:32:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D73A20772
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Jul 2020 02:32:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726118AbgGICcu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Jul 2020 22:32:50 -0400
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:55348 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726117AbgGICcu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Jul 2020 22:32:50 -0400
Received: from dread.disaster.area (pa49-180-53-24.pa.nsw.optusnet.com.au [49.180.53.24])
        by mail110.syd.optusnet.com.au (Postfix) with ESMTPS id D6B3C10B283;
        Thu,  9 Jul 2020 12:32:47 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jtMMg-0002H2-96; Thu, 09 Jul 2020 12:32:46 +1000
Date:   Thu, 9 Jul 2020 12:32:46 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>
Subject: Re: [RFC PATCH 2/2] xfs: don't access AGI on unlinked inodes if it
 can
Message-ID: <20200709023246.GR2005@dread.disaster.area>
References: <20200707135741.487-1-hsiangkao@redhat.com>
 <20200707135741.487-3-hsiangkao@redhat.com>
 <20200708233311.GP2005@dread.disaster.area>
 <20200709005526.GC15249@xiangao.remote.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200709005526.GC15249@xiangao.remote.csb>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=QIgWuTDL c=1 sm=1 tr=0
        a=moVtWZxmCkf3aAMJKIb/8g==:117 a=moVtWZxmCkf3aAMJKIb/8g==:17
        a=kj9zAlcOel0A:10 a=_RQrkK6FrEwA:10 a=7-415B0cAAAA:8
        a=7oGh4da7UUqVrEBo9rYA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 09, 2020 at 08:55:26AM +0800, Gao Xiang wrote:
> On Thu, Jul 09, 2020 at 09:33:11AM +1000, Dave Chinner wrote:
> > On Tue, Jul 07, 2020 at 09:57:41PM +0800, Gao Xiang wrote:
> > > Currently, we use AGI buffer lock to protect in-memory linked list for
> > > unlinked inodes but since it's not necessary to modify AGI unless the
> > > head of the unlinked list is modified. So let's removing the AGI buffer
> > > modification dependency if possible, including 1) adding another per-AG
> > > dedicated lock to protect the whole list and 2) inserting unlinked
> > > inodes from tail.
> > > 
> > > For 2), the tail of bucket 0 is now recorded in perag for xfs_iunlink()
> > > to use. xfs_iunlink_remove() still support old multiple short bucket
> > > lists for recovery code.
> > 
> > I would split this into two separate patches. One to move to a perag
> > based locking strategy, another to change from head to tail
> > addition as they are largely independent algorithmic changes.
> 
> Yes, that is much better from the perspective of spilting patches and
> I thought that before. It seems that is like 2 steps but the proposed
> target solution is as a whole (in other words, 2 steps are code-related)
> and I'm not sure how large these code is sharable or can be inherited
> but rather than introduce some code in patch 2 and then remove immediately
> and turn into a new code in patch 3). I'm not sure how large logic could
> be sharable between these 2 dependent steps so I didn't do that.
> 
> I will spilt patches in the next RFC version to make a try.

Thanks!

[snip]


> > i.e. this:
> > 
> > xfs_iunlink()
> > {
> > 
> > 	get locks
> > 	do list insert
> > 	drop locks
> > }
> > 
> > Is better for understanding, maintenance and future modification
> > than:
> > 
> > xfs_iunlink()
> > {
> > 
> > 	get perag
> > 	lock perag
> > 	look at tail of list
> > 	if (empty) {
> > 		unlock perag
> > 		read/lock AGI
> > 		lock perag
> > 		look at tail of list
> > 		if (empty)
> > 			do head insert
> > 			goto out
> > 	}
> > 	do tail insert
> > out:
> > 	update inode/pag tails
> > 	unlock
> > 	drop perag
> > }
> > 
> > It's trivial for a reader to understand what the first version of
> > xfs_iunlink() is going to do without needing to understand the
> > intraccies of the locking strategies. However, it takes time and
> > effort to undestand exactly waht the second one is doing because
> > it's not clear where lock ends and list modifications start, nor
> > what the locking rules are for the different modifications that are
> > being made. Essentially, it goes back to the complex
> > locking-intertwined-with-modification-algorithm problem the current
> > TOT code has.
> > 
> > I'd much prefer to see something like this:
> > 
> > /*
> >  * Inode allocation in the O_TMPFILE path defines the AGI/unlinked
> >  * list lock order as being AGI->perag unlinked list lock. We are
> >  * inverting it here as the fast path tail addition does not need to
> >  * modify the AGI at all. Hence we only need the AGI lock if the
> >  * tail is empty, but if we fail to get it without blocking then we
> >  * need to fall back to the slower, correct lock order.
> >  */
> > xfs_iunlink_insert_lock()
> > {
> > 	get perag;
> > 	lock_perag();
> > 	if (!tail empty)
> > 		return;
> > 	if (trylock AGI)
> > 		return;
> 
> (adding some notes here, this patch doesn't use try lock here
>  finally but unlock perag and take AGI and relock and recheck tail_empty....
>  since the tail non-empty is rare...)

*nod*

My point was largely that this sort of thing is really obvious and
easy to optimise once the locking is cleanly separated. Adding a
trylock rather than drop/relock is another patch for the series :P

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
