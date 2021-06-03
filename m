Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33446C47083
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Jun 2021 00:16:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 14FDD613E9
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Jun 2021 00:16:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229692AbhFCASJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 2 Jun 2021 20:18:09 -0400
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:49515 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229541AbhFCASI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 2 Jun 2021 20:18:08 -0400
Received: from dread.disaster.area (pa49-179-138-183.pa.nsw.optusnet.com.au [49.179.138.183])
        by mail110.syd.optusnet.com.au (Postfix) with ESMTPS id 8947510B5EB;
        Thu,  3 Jun 2021 10:16:23 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lob26-008Hqc-44; Thu, 03 Jun 2021 10:16:22 +1000
Date:   Thu, 3 Jun 2021 10:16:22 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 33/39] xfs: Add order IDs to log items in CIL
Message-ID: <20210603001622.GZ664593@dread.disaster.area>
References: <20210519121317.585244-1-david@fromorbit.com>
 <20210519121317.585244-34-david@fromorbit.com>
 <20210527190023.GK2402049@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210527190023.GK2402049@locust>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0
        a=MnllW2CieawZLw/OcHE/Ng==:117 a=MnllW2CieawZLw/OcHE/Ng==:17
        a=kj9zAlcOel0A:10 a=r6YtysWOX24A:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8
        a=7-415B0cAAAA:8 a=bpl8c13QDN9QBctwINIA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 27, 2021 at 12:00:23PM -0700, Darrick J. Wong wrote:
> On Wed, May 19, 2021 at 10:13:11PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Before we split the ordered CIL up into per cpu lists, we need a
> > mechanism to track the order of the items in the CIL. We need to do
> > this because there are rules around the order in which related items
> > must physically appear in the log even inside a single checkpoint
> > transaction.
> > 
> > An example of this is intents - an intent must appear in the log
> > before it's intent done record so taht log recovery can cancel the
> 
> s/taht/that/
> 
> > intent correctly. If we have these two records misordered in the
> > CIL, then they will not be recovered correctly by journal replay.
> > 
> > We also will not be able to move items to the tail of
> > the CIL list when they are relogged, hence the log items will need
> > some mechanism to allow the correct log item order to be recreated
> > before we write log items to the hournal.
> > 
> > Hence we need to have a mechanism for recording global order of
> > transactions in the log items  so that we can recover that order
> > from un-ordered per-cpu lists.
> > 
> > Do this with a simple monotonic increasing commit counter in the CIL
> > context. Each log item in the transaction gets stamped with the
> > current commit order ID before it is added to the CIL. If the item
> > is already in the CIL, leave it where it is instead of moving it to
> > the tail of the list and instead sort the list before we start the
> > push work.
> > 
> > XXX: list_sort() under the cil_ctx_lock held exclusive starts
> > hurting that >16 threads. Front end commits are waiting on the push
> > to switch contexts much longer. The item order id should likely be
> > moved into the logvecs when they are detacted from the items, then
> > the sort can be done on the logvec after the cil_ctx_lock has been
> > released. logvecs will need to use a list_head for this rather than
> > a single linked list like they do now....
> 
> ...which I guess happens in patch 35 now?

Right. I'll just remove this from the commit message.

> > @@ -780,6 +780,26 @@ xlog_cil_build_trans_hdr(
> >  	tic->t_curr_res -= lvhdr->lv_bytes;
> >  }
> >  
> > +/*
> > + * CIL item reordering compare function. We want to order in ascending ID order,
> > + * but we want to leave items with the same ID in the order they were added to
> 
> When do we have items with the same id?

All the items in a single transaction have the same id. The order id
increments before we tag all the items in the transaction and insert
them into the CIL.

> I guess that happens if we have multiple transactions adding items to
> the cil at the same time?  I guess that's not a big deal since each of
> those threads will hold a disjoint set of locks, so even if the order
> ids are the same for a bunch of items, they're never going to be
> touching the same AG/inode/metadata object, right?
>
> If that's correct, then:
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>


While true, it's not the way this works so I won't immediately
accept your RVB. The reason for not changing the ordering within a
single transaction is actually intent logging.  i.e. this:

> > + * the list. This is important for operations like reflink where we log 4 order
> > + * dependent intents in a single transaction when we overwrite an existing
> > + * shared extent with a new shared extent. i.e. BUI(unmap), CUI(drop),
> > + * CUI (inc), BUI(remap)...

There's a specific order of operations that recovery must run these
intents in, and so if we re-order them here in the CIL they'll be
out of order in the log and recovery will replay the intents in the
wrong order. Replaying the intents in the wrong order results in
corruption warnings and assert failures during log recovery, hence
the constraint of not re-ordering items within the same transaction.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
