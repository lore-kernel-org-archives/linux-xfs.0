Return-Path: <SRS0=NnDK=6T=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C67BC47247
	for <linux-xfs@archiver.kernel.org>; Tue,  5 May 2020 05:10:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 43394206E6
	for <linux-xfs@archiver.kernel.org>; Tue,  5 May 2020 05:10:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725830AbgEEFKe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 5 May 2020 01:10:34 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:53248 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725320AbgEEFKe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 May 2020 01:10:34 -0400
Received: from dread.disaster.area (pa49-195-157-175.pa.nsw.optusnet.com.au [49.195.157.175])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id BC84858C1BA;
        Tue,  5 May 2020 15:10:30 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jVpqf-0002XC-Sq; Tue, 05 May 2020 15:10:29 +1000
Date:   Tue, 5 May 2020 15:10:29 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: proper replay of deferred ops queued during log
 recovery
Message-ID: <20200505051029.GN2040@dread.disaster.area>
References: <158864121286.184729.5959003885146573075.stgit@magnolia>
 <158864121900.184729.15751838615488460497.stgit@magnolia>
 <20200505023305.GM2040@dread.disaster.area>
 <20200505030651.GE5716@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200505030651.GE5716@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=ONQRW0k9raierNYdzxQi9Q==:117 a=ONQRW0k9raierNYdzxQi9Q==:17
        a=kj9zAlcOel0A:10 a=sTwFKg_x9MkA:10 a=yPCof4ZbAAAA:8 a=7-415B0cAAAA:8
        a=qp17tjg0sL84z0HGF9gA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 04, 2020 at 08:06:51PM -0700, Darrick J. Wong wrote:
> On Tue, May 05, 2020 at 12:33:05PM +1000, Dave Chinner wrote:
> > On Mon, May 04, 2020 at 06:13:39PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > 
> > > When we replay unfinished intent items that have been recovered from the
> > > log, it's possible that the replay will cause the creation of more
> > > deferred work items.  As outlined in commit 509955823cc9c ("xfs: log
> > > recovery should replay deferred ops in order"), later work items have an
> > > implicit ordering dependency on earlier work items.  Therefore, recovery
> > > must replay the items (both recovered and created) in the same order
> > > that they would have been during normal operation.
> > > 
> > > For log recovery, we enforce this ordering by using an empty transaction
> > > to collect deferred ops that get created in the process of recovering a
> > > log intent item to prevent them from being committed before the rest of
> > > the recovered intent items.  After we finish committing all the
> > > recovered log items, we allocate a transaction with an enormous block
> > > reservation, splice our huge list of created deferred ops into that
> > > transaction, and commit it, thereby finishing all those ops.
> > > 
> > > This is /really/ hokey -- it's the one place in XFS where we allow
> > > nested transactions; the splicing of the defer ops list is is inelegant
> > > and has to be done twice per recovery function; and the broken way we
> > > handle inode pointers and block reservations cause subtle use-after-free
> > > and allocator problems that will be fixed by this patch and the two
> > > patches after it.
> > > 
> > > Therefore, replace the hokey empty transaction with a structure designed
> > > to capture each chain of deferred ops that are created as part of
> > > recovering a single unfinished log intent.  Finally, refactor the loop
> > > that replays those chains to do so using one transaction per chain.
> > > 
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > FWIW, I don't like the "freezer" based naming here. It's too easily
> > confused with freezing and thawing the filesystem....
> > 
> > I know, "delayed deferred ops" isn't much better, but at least it
> > won't get confused with existing unrelated functionality.
> 
> xfs_defer_{freeze,thaw} -> xfs_defer_{capture,relink} ?

Yeah, capture seems appropriate, maybe relink -> continue? i.e.
capture the remaining defer_ops to be run, then continue running
them?

/me shrugs and thinks "naming is hard"....

> > I've barely looked at the code, so no real comments on that yet,
> > but I did notice this:
> > 
> > > @@ -2495,35 +2515,59 @@ xlog_recover_process_data(
> > >  /* Take all the collected deferred ops and finish them in order. */
> > >  static int
> > >  xlog_finish_defer_ops(
> > > -	struct xfs_trans	*parent_tp)
> > > +	struct xfs_mount	*mp,
> > > +	struct list_head	*dfops_freezers)
> > >  {
> > > -	struct xfs_mount	*mp = parent_tp->t_mountp;
> > > +	struct xfs_defer_freezer *dff, *next;
> > >  	struct xfs_trans	*tp;
> > >  	int64_t			freeblks;
> > >  	uint			resblks;
> > ....
> > > +		resblks = min_t(int64_t, UINT_MAX, freeblks);
> > > +		resblks = (resblks * 15) >> 4;
> > 
> > Can overflow when freeblks > (UINT_MAX / 15).
> 
> D'oh.  Ugh, I hate this whole fugly hack.
> 
> TBH I've been thinking that perhaps the freezer function should be
> capturing the unused transaction block reservation when we capture the
> dfops chain from the transaction.

Exactly what problem is this hack supposed to avoid? having the
filesystem ENOSPC before all the deferops have been completed?

if so, can that even happen? Because the fact that the intents are
in the log means that when they were started there was enough space
in the fs for them to run, so ENOSPC should not be an issue, right?

> When we set up the second transaction, we then set t_blk_res to the
> captured block reservation.  So long as the recovery function is smart
> enough to set up sufficient reservation we should avoid hitting ENOSPC,
> right?

I'm not sure ENOSPC is really a problem for recovery of deferred ops
given the above...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
