Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D0B9C2B9F4
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Jun 2021 22:20:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E2E7961369
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Jun 2021 22:20:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229915AbhFQWWL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Jun 2021 18:22:11 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:57107 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229580AbhFQWWL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Jun 2021 18:22:11 -0400
Received: from dread.disaster.area (pa49-179-138-183.pa.nsw.optusnet.com.au [49.179.138.183])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id D1D0280BB33;
        Fri, 18 Jun 2021 08:20:00 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lu0Mi-00Dxgy-7G; Fri, 18 Jun 2021 08:20:00 +1000
Date:   Fri, 18 Jun 2021 08:20:00 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/8] xfs: attached iclog callbacks in
 xlog_cil_set_ctx_write_state()
Message-ID: <20210617222000.GF664593@dread.disaster.area>
References: <20210617082617.971602-1-david@fromorbit.com>
 <20210617082617.971602-8-david@fromorbit.com>
 <20210617205552.GA158209@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210617205552.GA158209@locust>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
        a=MnllW2CieawZLw/OcHE/Ng==:117 a=MnllW2CieawZLw/OcHE/Ng==:17
        a=kj9zAlcOel0A:10 a=r6YtysWOX24A:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=ykyE-Pm-j34tYLzwI9gA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 17, 2021 at 01:55:52PM -0700, Darrick J. Wong wrote:
> On Thu, Jun 17, 2021 at 06:26:16PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > We currently attach iclog callbacks for the CIL when the commit
> > iclog is returned from xlog_write. Because
> > xlog_state_get_iclog_space() always guarantees that the commit
> > record will fit in the iclog it returns, we can move this IO
> > callback setting to xlog_cil_set_ctx_write_state(), record the
> > commit iclog in the context and remove the need for the commit iclog
> > to be returned by xlog_write() altogether.
> > 
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/xfs_log.c      |  8 ++----
> >  fs/xfs/xfs_log_cil.c  | 65 +++++++++++++++++++++++++------------------
> >  fs/xfs/xfs_log_priv.h |  3 +-
> >  3 files changed, 42 insertions(+), 34 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> > index 1c214b395223..359246d54db7 100644
> > --- a/fs/xfs/xfs_log.c
> > +++ b/fs/xfs/xfs_log.c
> > @@ -871,7 +871,7 @@ xlog_write_unmount_record(
> >  	 */
> >  	if (log->l_targ != log->l_mp->m_ddev_targp)
> >  		blkdev_issue_flush(log->l_targ->bt_bdev);
> > -	return xlog_write(log, NULL, &lv_chain, ticket, NULL, reg.i_len);
> > +	return xlog_write(log, NULL, &lv_chain, ticket, reg.i_len);
> >  }
> >  
> >  /*
> > @@ -2386,7 +2386,6 @@ xlog_write(
> >  	struct xfs_cil_ctx	*ctx,
> >  	struct list_head	*lv_chain,
> >  	struct xlog_ticket	*ticket,
> > -	struct xlog_in_core	**commit_iclog,
> >  	uint32_t		len)
> >  {
> >  	struct xlog_in_core	*iclog = NULL;
> > @@ -2436,10 +2435,7 @@ xlog_write(
> >  	 */
> >  	spin_lock(&log->l_icloglock);
> >  	xlog_state_finish_copy(log, iclog, record_cnt, 0);
> > -	if (commit_iclog)
> > -		*commit_iclog = iclog;
> > -	else
> > -		error = xlog_state_release_iclog(log, iclog, ticket);
> > +	error = xlog_state_release_iclog(log, iclog, ticket);
> >  	spin_unlock(&log->l_icloglock);
> >  
> >  	return error;
> > diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> > index 2d8d904ffb78..87e30917ce2e 100644
> > --- a/fs/xfs/xfs_log_cil.c
> > +++ b/fs/xfs/xfs_log_cil.c
> > @@ -799,11 +799,34 @@ xlog_cil_set_ctx_write_state(
> >  
> >  	ASSERT(!ctx->commit_lsn);
> >  	spin_lock(&cil->xc_push_lock);
> > -	if (!ctx->start_lsn)
> > +	if (!ctx->start_lsn) {
> >  		ctx->start_lsn = lsn;
> > -	else
> > -		ctx->commit_lsn = lsn;
> > +		spin_unlock(&cil->xc_push_lock);
> > +		return;
> > +	}
> > +
> > +	/*
> > +	 * Take a reference to the iclog for the context so that we still hold
> > +	 * it when xlog_write is done and has released it. This means the
> > +	 * context controls when the iclog is released for IO.
> > +	 */
> > +	atomic_inc(&iclog->ic_refcnt);
> 
> Where do we drop this refcount?

In xlog_cil_push_work() where we call xlog_state_release_iclog().

> Is this the accounting adjustment that
> we have to make because xlog_write always decrements the iclog refcount
> now?

Yes.

> > +	ctx->commit_iclog = iclog;
> > +	ctx->commit_lsn = lsn;
> >  	spin_unlock(&cil->xc_push_lock);
> 
> I've noticed how the setting of ctx->commit_lsn has moved to before the
> point where we splice callback lists, only to move them back below in
> the next patch.  That has made it harder for me to understand this
> series.
> 
> I /think/ the goal of this patch is not really a functional change so
> much as a refactoring to make the cil context track the commit iclog
> directly and then smooth out some of the refcounting code, but the
> shuffling around of these variables makes me wonder if I'm missing some
> other subtlety.

The subtlety is that we can't issue the wakup on the commit_lsn
until after the callbacks are attached to the commit iclog. When we
set ctx->commit_lsn doesn't really matter - I'm trying to keep the
order of "callbacks attached before we issue the wakeup" so that
when the waiter is woken and then adds it's callbacks to the same
iclog they will be appended to the list after the first commit
record's callbacks and hence they get processed in the correct order
when journal IO completion runs the callbacks on that iclog.

This patch doesn't move the wakeup from after the xlog_write() call
completes, so the ordering of setting
ctx->commit_lsn and attaching the callbacks inside xlog_write()
doesn't really matter. In the next patch, the wakeups move inside
xlog_write()->xlog_cil_set_ctx_write_state(), and so now it has to
ensure that the ordering is correct.

I'll rework the patches so that this one sets up the order the next
patch requires rather than minimal change in this patch and reorder
in the next patch...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
