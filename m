Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02B4BC2B9F4
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Jun 2021 22:18:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CCF8061004
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Jun 2021 22:18:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231684AbhFQWUg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Jun 2021 18:20:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:57114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231565AbhFQWUf (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 17 Jun 2021 18:20:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5581B61369;
        Thu, 17 Jun 2021 22:18:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623968307;
        bh=pM8QrVjrv/SUtdj05dftvehBYIrvnpdY5afd7pIrhYU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sf3vB7Q8yPieIKLsq6KJAwAlLn6uJVkG5Rueue1H+fzVAXP+l6+zSC17MHXOwqPgq
         NeC0bZzzSdF3tWQsVv8X5OtZDm/NaIF/OI5YsyvPUiFIDLVi/dLdUnu4wU5F7oQ1xT
         BCNuBRTit0hPe2rXFBaaA/5Ed7SxnQnGfDBd1Q50i8GtEVrRK5wIqWBdFRePgwBuB0
         4vJGif8DitNKhs3ib57DNWRIVVCuqdSca165l0j4s5/2YdjZhdXjz/sACh9IVNeK09
         TFpjt8gw/X3WGiQqmsjKYmxwTiMUbrAf47GGO6brULjiukE6eScSSsv0WCxhmCBLwk
         dpzD1y6xs+nUQ==
Date:   Thu, 17 Jun 2021 15:18:26 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/8] xfs: pass a CIL context to xlog_write()
Message-ID: <20210617221826.GB158209@locust>
References: <20210617082617.971602-1-david@fromorbit.com>
 <20210617082617.971602-5-david@fromorbit.com>
 <20210617202402.GX158209@locust>
 <20210617220337.GD664593@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210617220337.GD664593@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jun 18, 2021 at 08:03:37AM +1000, Dave Chinner wrote:
> On Thu, Jun 17, 2021 at 01:24:02PM -0700, Darrick J. Wong wrote:
> > On Thu, Jun 17, 2021 at 06:26:13PM +1000, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > Pass the CIL context to xlog_write() rather than a pointer to a LSN
> > > variable. Only the CIL checkpoint calls to xlog_write() need to know
> > > about the start LSN of the writes, so rework xlog_write to directly
> > > write the LSNs into the CIL context structure.
> > > 
> > > This removes the commit_lsn variable from xlog_cil_push_work(), so
> > > now we only have to issue the commit record ordering wakeup from
> > > there.
> > > 
> > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > > ---
> > >  fs/xfs/xfs_log.c      | 22 +++++++++++++++++-----
> > >  fs/xfs/xfs_log_cil.c  | 19 ++++++++-----------
> > >  fs/xfs/xfs_log_priv.h |  4 ++--
> > >  3 files changed, 27 insertions(+), 18 deletions(-)
> > > 
> > > diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> > > index cf661c155786..fc0e43c57683 100644
> > > --- a/fs/xfs/xfs_log.c
> > > +++ b/fs/xfs/xfs_log.c
> > > @@ -871,7 +871,7 @@ xlog_write_unmount_record(
> > >  	 */
> > >  	if (log->l_targ != log->l_mp->m_ddev_targp)
> > >  		blkdev_issue_flush(log->l_targ->bt_bdev);
> > > -	return xlog_write(log, &lv_chain, ticket, NULL, NULL, reg.i_len);
> > > +	return xlog_write(log, NULL, &lv_chain, ticket, NULL, reg.i_len);
> > >  }
> > >  
> > >  /*
> > > @@ -2383,9 +2383,9 @@ xlog_write_partial(
> > >  int
> > >  xlog_write(
> > >  	struct xlog		*log,
> > > +	struct xfs_cil_ctx	*ctx,
> > >  	struct list_head	*lv_chain,
> > >  	struct xlog_ticket	*ticket,
> > > -	xfs_lsn_t		*start_lsn,
> > >  	struct xlog_in_core	**commit_iclog,
> > >  	uint32_t		len)
> > >  {
> > > @@ -2408,9 +2408,21 @@ xlog_write(
> > >  	if (error)
> > >  		return error;
> > >  
> > > -	/* start_lsn is the LSN of the first iclog written to. */
> > > -	if (start_lsn)
> > > -		*start_lsn = be64_to_cpu(iclog->ic_header.h_lsn);
> > > +	/*
> > > +	 * If we have a CIL context, record the LSN of the iclog we were just
> > > +	 * granted space to start writing into. If the context doesn't have
> > > +	 * a start_lsn recorded, then this iclog will contain the start record
> > > +	 * for the checkpoint. Otherwise this write contains the commit record
> > > +	 * for the checkpoint.
> > > +	 */
> > > +	if (ctx) {
> > > +		spin_lock(&ctx->cil->xc_push_lock);
> > > +		if (!ctx->start_lsn)
> > > +			ctx->start_lsn = be64_to_cpu(iclog->ic_header.h_lsn);
> > > +		else
> > > +			ctx->commit_lsn = be64_to_cpu(iclog->ic_header.h_lsn);
> > > +		spin_unlock(&ctx->cil->xc_push_lock);
> > 
> > This cycling of the push lock when setting start_lsn is new.  What are
> > we protecting against here by taking the lock?
> 
> Later in the series it will be the ordering wakeup when we set the
> start_lsn. The ordering ends with both start_lsn and commit_lsn
> being treated the same way w.r.t. wakeups, so I just started it off
> the same way here.

Ah, right, I see that now that I've gotten to patch 8.

> > Also, just to check my assumptions: why do we take the push lock when
> > setting commit_lsn?  Is that to synchronize with the xc_committing loop
> > that looks for contexts that need pushing?
> 
> Yes - the spinlock provides the memory barriers for access to the
> variable. I could use WRITE_ONCE/READ_ONCE here for this specific patch,
> but the lock is necessary for compound operations in upcoming
> patches so it didn't make any sense to use _ONCE macros here only to
> remove them again later.

Nah, I'd leave it, especially since it's already a little strange that
the place where we set ctx->commit_lsn bounces around relative to the
callback list splicing...

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
