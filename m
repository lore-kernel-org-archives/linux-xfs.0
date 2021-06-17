Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB90CC2B9F4
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Jun 2021 22:49:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C2255613BA
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Jun 2021 22:49:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232759AbhFQWvY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Jun 2021 18:51:24 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:39554 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231911AbhFQWvY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Jun 2021 18:51:24 -0400
Received: from dread.disaster.area (pa49-179-138-183.pa.nsw.optusnet.com.au [49.179.138.183])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id AC60780B919;
        Fri, 18 Jun 2021 08:49:13 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lu0oy-00DyBl-VP; Fri, 18 Jun 2021 08:49:12 +1000
Date:   Fri, 18 Jun 2021 08:49:12 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 8/8] xfs: order CIL checkpoint start records
Message-ID: <20210617224912.GG664593@dread.disaster.area>
References: <20210617082617.971602-1-david@fromorbit.com>
 <20210617082617.971602-9-david@fromorbit.com>
 <20210617213143.GF158232@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210617213143.GF158232@locust>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0
        a=MnllW2CieawZLw/OcHE/Ng==:117 a=MnllW2CieawZLw/OcHE/Ng==:17
        a=kj9zAlcOel0A:10 a=r6YtysWOX24A:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=eTq6EyWNuXYNPzbsp4AA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 17, 2021 at 02:31:43PM -0700, Darrick J. Wong wrote:
> On Thu, Jun 17, 2021 at 06:26:17PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Because log recovery depends on strictly ordered start records as
> > well as strictly ordered commit records.
> > 
> > This is a zero day bug in the way XFS writes pipelined transactions
> > to the journal which is exposed by commit facd77e4e38b ("xfs: CIL
> > work is serialised, not pipelined") which re-introduces explicit
> > concurrent commits back into the on-disk journal.
> > 
> > The XFS journal commit code has never ordered start records and we
> > have relied on strict commit record ordering for correct recovery
> > ordering of concurrently written transactions. Unfortunately, root
> > cause analysis uncovered the fact that log recovery uses the LSN of
> > the start record for transaction commit processing. Hence the
> > commits are processed in strict orderi by recovery, but the LSNs
> 
> s/orderi/order/ ?
> 
> > associated with the commits can be out of order and so recovery may
> > stamp incorrect LSNs into objects and/or misorder intents in the AIL
> > for later processing. This can result in log recovery failures
> > and/or on disk corruption, sometimes silent.
> > 
> > Because this is a long standing log recovery issue, we can't just
> > fix log recovery and call it good.
> 
> Could there be production filesystems out there that have this
> mismatched ordering of start lsn and commit lsn?  This still leaves the
> mystery of crashed customer filesystems containing btree blocks where
> 128 bytes in the middle clearly contain contents that are don't match or
> duplicate the rest of the block, as though someone forgot to replay a
> buffer vector or something.

Modulo bugs in delayed logging, I doubt there's any delayed logging
filesystems out there that have the problem. Older, non-delayed
logging filesystems are almost certain to see it, but they have much
smaller transactions and only EFIs to deal with so the corruption
risk is much, much, much lower.

> What would a fix to log recovery entail?  Not skipping recovered items
> if the start/commit sequencing is not the same?  Or am I not
> understanding the problem correctly?

I've been going back and forth on this trying to come up with a sane
solution, but I haven't come up with anything practical.

We could use the commit record LSN for recovery, but we write start
record LSNs into on-disk metadata when we flush it to disk and that
forces checkpoints that need recovery to use the same LSN in the
metadata it recovers and writes back as we use for runtime
writeback. Hence we then get problems with recovered filesystems not
having the same on-disk state as they would if the metadata was
written back from in-memory. i.e. two pieces of metadata in the same
atomic transaction could have different LSNs stamped in them
depending on whether they were written back at runtime or recovered
by log recovery at mount time...

And then my head explodes trying to work out what happens when we
have overlapping checkpoints and partial metadata writeback and
different LSN values for recovery vs writeback and recovery retries
after a failed recovery and <BOOM>

However, given that there are runtime integrity issues with out of
order start LSNs (log head can overwrite the log tail - I can give
more detail if you want), the only way out of this I can see is to
ensure that the start records are properly ordered at runtime to
avoid all the potential runtime issues that exist.  This also has
the nice "side effect" of avoiding the log recovery LSN ordering
problem.

IOWs, I'm not looking at this as log recovery bug that needs fixing.
Yes, there is a log recovery issue there (and has been forever), but
the more I think on this, the more I'm concerned about the potential
runtime impacts on data integrity correctness and potential
head-tail journal overwrite corruption. 

> > +	ctx->commit_lsn = lsn;
> > +	wake_up_all(&cil->xc_commit_wait);
> > +	spin_unlock(&cil->xc_push_lock);
> >  }
> >  
> >  /*
> > @@ -834,10 +849,16 @@ xlog_cil_set_ctx_write_state(
> >   * relies on the context LSN being zero until the log write has guaranteed the
> >   * LSN that the log write will start at via xlog_state_get_iclog_space().
> >   */
> > +enum {
> > +	_START_RECORD,
> > +	_COMMIT_RECORD,
> > +};
> 
> Stupid nit: If this enum had a name you could skip the default clause
> below because the compiler would typecheck the usage for you.

OK.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
