Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22CF3C47092
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Jun 2021 00:27:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 04E4E61028
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Jun 2021 00:27:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229567AbhFCA3f (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 2 Jun 2021 20:29:35 -0400
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:54049 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229617AbhFCA3f (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 2 Jun 2021 20:29:35 -0400
Received: from dread.disaster.area (pa49-179-138-183.pa.nsw.optusnet.com.au [49.179.138.183])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id 5DCBA1B0140;
        Thu,  3 Jun 2021 10:27:34 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lobCv-008I4k-SB; Thu, 03 Jun 2021 10:27:33 +1000
Date:   Thu, 3 Jun 2021 10:27:33 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 34/39] xfs: convert CIL to unordered per cpu lists
Message-ID: <20210603002733.GA664593@dread.disaster.area>
References: <20210519121317.585244-1-david@fromorbit.com>
 <20210519121317.585244-35-david@fromorbit.com>
 <20210527190318.GL2402049@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210527190318.GL2402049@locust>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0
        a=MnllW2CieawZLw/OcHE/Ng==:117 a=MnllW2CieawZLw/OcHE/Ng==:17
        a=kj9zAlcOel0A:10 a=r6YtysWOX24A:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8
        a=7-415B0cAAAA:8 a=lc9aHQRKoKGNp8n7gWMA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 27, 2021 at 12:03:18PM -0700, Darrick J. Wong wrote:
> On Wed, May 19, 2021 at 10:13:12PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > So that we can remove the cil_lock which is a global serialisation
> > point. We've already got ordering sorted, so all we need to do is
> > treat the CIL list like the busy extent list and reconstruct it
> > before the push starts.
> > 
> > This is what we're trying to avoid:
> > 
> >  -   75.35%     1.83%  [kernel]            [k] xfs_log_commit_cil
> >     - 46.35% xfs_log_commit_cil
> >        - 41.54% _raw_spin_lock
> >           - 67.30% do_raw_spin_lock
> >                66.96% __pv_queued_spin_lock_slowpath
> > 
> > Which happens on a 32p system when running a 32-way 'rm -rf'
> > workload. After this patch:
> > 
> > -   20.90%     3.23%  [kernel]               [k] xfs_log_commit_cil
> >    - 17.67% xfs_log_commit_cil
> >       - 6.51% xfs_log_ticket_ungrant
> >            1.40% xfs_log_space_wake
> >         2.32% memcpy_erms
> >       - 2.18% xfs_buf_item_committing
> >          - 2.12% xfs_buf_item_release
> >             - 1.03% xfs_buf_unlock
> >                  0.96% up
> >               0.72% xfs_buf_rele
> >         1.33% xfs_inode_item_format
> >         1.19% down_read
> >         0.91% up_read
> >         0.76% xfs_buf_item_format
> >       - 0.68% kmem_alloc_large
> >          - 0.67% kmem_alloc
> >               0.64% __kmalloc
> >         0.50% xfs_buf_item_size
> > 
> > It kinda looks like the workload is running out of log space all
> > the time. But all the spinlock contention is gone and the
> > transaction commit rate has gone from 800k/s to 1.3M/s so the amount
> > of real work being done has gone up a *lot*.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/xfs_log_cil.c  | 69 +++++++++++++++++++------------------------
> >  fs/xfs/xfs_log_priv.h |  3 +-
> >  2 files changed, 31 insertions(+), 41 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> > index ca6e411e388e..287dc7d0d508 100644
> > --- a/fs/xfs/xfs_log_cil.c
> > +++ b/fs/xfs/xfs_log_cil.c
> > @@ -72,6 +72,7 @@ xlog_cil_ctx_alloc(void)
> >  	ctx = kmem_zalloc(sizeof(*ctx), KM_NOFS);
> >  	INIT_LIST_HEAD(&ctx->committing);
> >  	INIT_LIST_HEAD(&ctx->busy_extents);
> > +	INIT_LIST_HEAD(&ctx->log_items);
> 
> I see you moved the log item list to the cil ctx for benefit of
> _pcp_dead, correct?

Largely, yes. It also helps to have the item push list rooted in the
structure that holds all of the push specific state (i.e. the CIL
ctx) once we detatch that from the CIL itself.

> If so, then this isn't especially different from the last version.

*nod*

> Yay for shortening lock critical sections,
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>

Ta.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
