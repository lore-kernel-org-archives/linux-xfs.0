Return-Path: <SRS0=TABv=4U=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	TVD_PH_BODY_ACCOUNTS_PRE,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1516C3F2C6
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Mar 2020 21:47:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6FDF820728
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Mar 2020 21:47:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727604AbgCCVre (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 3 Mar 2020 16:47:34 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:45496 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725932AbgCCVrd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Mar 2020 16:47:33 -0500
Received: from dread.disaster.area (pa49-195-202-68.pa.nsw.optusnet.com.au [49.195.202.68])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 3F6FA7E9B8A;
        Wed,  4 Mar 2020 08:47:31 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1j9FNy-00049j-9N; Wed, 04 Mar 2020 08:47:30 +1100
Date:   Wed, 4 Mar 2020 08:47:30 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [RFC v5 PATCH 3/9] xfs: automatic relogging reservation
 management
Message-ID: <20200303214730.GT10776@dread.disaster.area>
References: <20200227134321.7238-1-bfoster@redhat.com>
 <20200227134321.7238-4-bfoster@redhat.com>
 <20200302030750.GH10776@dread.disaster.area>
 <20200302180650.GB10946@bfoster>
 <20200302232529.GN10776@dread.disaster.area>
 <20200303040735.GR10776@dread.disaster.area>
 <20200303151217.GD15955@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200303151217.GD15955@bfoster>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=LYdCFQXi c=1 sm=1 tr=0
        a=mqTaRPt+QsUAtUurwE173Q==:117 a=mqTaRPt+QsUAtUurwE173Q==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=SS2py6AdgQ4A:10
        a=7-415B0cAAAA:8 a=20KFwNOVAAAA:8 a=I-K_dEfyqTnWpEyiHyoA:9
        a=RGEjUDZEfLFsW5et:21 a=PeXB71-jQBIpSQNx:21 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 03, 2020 at 10:12:17AM -0500, Brian Foster wrote:
> On Tue, Mar 03, 2020 at 03:07:35PM +1100, Dave Chinner wrote:
> > On Tue, Mar 03, 2020 at 10:25:29AM +1100, Dave Chinner wrote:
> > > On Mon, Mar 02, 2020 at 01:06:50PM -0500, Brian Foster wrote:
> > > OK, XLOG_TIC_INITED is redundant, and should be removed. And
> > > xfs_log_done() needs to be split into two, one for releasing the
> > > ticket, one for completing the xlog_write() call. Compile tested
> > > only patch below for you :P
> > 
> > And now with sample patch.
> > 
> > -Dave.
> > -- 
> > Dave Chinner
> > david@fromorbit.com
> > 
> > xfs: kill XLOG_TIC_INITED
> > 
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Delayed logging made this redundant as we never directly write
> > transactions to the log anymore. Hence we no longer make multiple
> > xlog_write() calls for a transaction as we format individual items
> > in a transaction, and hence don't need to keep track of whether we
> > should be writing a start record for every xlog_write call.
> > 
> 
> FWIW the commit log could use a bit more context, perhaps from your
> previous description, about the original semantics of _INITED flag.
> E.g., it's always been rather vague to me, probably because it seems to
> be a remnant of some no longer fully in place functionality.

Yup, it was a quick "here's what it looks like" patch.

> 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/xfs_log.c      | 79 ++++++++++++++++++---------------------------------
> >  fs/xfs/xfs_log.h      |  4 ---
> >  fs/xfs/xfs_log_cil.c  | 13 +++++----
> >  fs/xfs/xfs_log_priv.h | 18 ++++++------
> >  fs/xfs/xfs_trans.c    | 24 ++++++++--------
> >  5 files changed, 55 insertions(+), 83 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> > index f6006d94a581..a45f3eefee39 100644
> > --- a/fs/xfs/xfs_log.c
> > +++ b/fs/xfs/xfs_log.c
> > @@ -496,8 +496,8 @@ xfs_log_reserve(
> >   * This routine is called when a user of a log manager ticket is done with
> >   * the reservation.  If the ticket was ever used, then a commit record for
> >   * the associated transaction is written out as a log operation header with
> > - * no data.  The flag XLOG_TIC_INITED is set when the first write occurs with
> > - * a given ticket.  If the ticket was one with a permanent reservation, then
> > + * no data. 
> 
> 	      ^ trailing whitespace

Forgot to <ctrl-j> to join the lines back together :P

> 
> > + * If the ticket was one with a permanent reservation, then
> >   * a few operations are done differently.  Permanent reservation tickets by
> >   * default don't release the reservation.  They just commit the current
> >   * transaction with the belief that the reservation is still needed.  A flag
> > @@ -506,49 +506,38 @@ xfs_log_reserve(
> >   * the inited state again.  By doing this, a start record will be written
> >   * out when the next write occurs.
> >   */
> > -xfs_lsn_t
> > -xfs_log_done(
> > -	struct xfs_mount	*mp,
> > +int
> > +xlog_write_done(
> > +	struct xlog		*log,
> >  	struct xlog_ticket	*ticket,
> >  	struct xlog_in_core	**iclog,
> > -	bool			regrant)
> > +	xfs_lsn_t		*lsn)
> >  {
> > -	struct xlog		*log = mp->m_log;
> > -	xfs_lsn_t		lsn = 0;
> > -
> > -	if (XLOG_FORCED_SHUTDOWN(log) ||
> > -	    /*
> > -	     * If nothing was ever written, don't write out commit record.
> > -	     * If we get an error, just continue and give back the log ticket.
> > -	     */
> > -	    (((ticket->t_flags & XLOG_TIC_INITED) == 0) &&
> > -	     (xlog_commit_record(log, ticket, iclog, &lsn)))) {
> > -		lsn = (xfs_lsn_t) -1;
> > -		regrant = false;
> > -	}
> > +	if (XLOG_FORCED_SHUTDOWN(log))
> > +		return -EIO;
> >  
> > +	return xlog_commit_record(log, ticket, iclog, lsn);
> > +}
> >  
> > +/*
> > + * Release or regrant the ticket reservation now the transaction is done with
> > + * it depending on caller context. Rolling transactions need the ticket
> > + * regranted, otherwise we release it completely.
> > + */
> > +void
> > +xlog_ticket_done(
> > +	struct xlog		*log,
> > +	struct xlog_ticket	*ticket,
> > +	bool			regrant)
> > +{
> >  	if (!regrant) {
> >  		trace_xfs_log_done_nonperm(log, ticket);
> > -
> > -		/*
> > -		 * Release ticket if not permanent reservation or a specific
> > -		 * request has been made to release a permanent reservation.
> > -		 */
> >  		xlog_ungrant_log_space(log, ticket);
> >  	} else {
> >  		trace_xfs_log_done_perm(log, ticket);
> > -
> >  		xlog_regrant_reserve_log_space(log, ticket);
> > -		/* If this ticket was a permanent reservation and we aren't
> > -		 * trying to release it, reset the inited flags; so next time
> > -		 * we write, a start record will be written out.
> > -		 */
> > -		ticket->t_flags |= XLOG_TIC_INITED;
> >  	}
> > -
> >  	xfs_log_ticket_put(ticket);
> > -	return lsn;
> >  }
> 
> In general it would be nicer to split off as much refactoring as
> possible into separate patches, even though it's not yet clear to me
> what granularity is possible with this patch...

Yeah, there's heaps mor cleanups that can be done as a result of
this - e.g. xlog_write_done() and xlog_commit_record() should be
merged. The one caller of xlog_write() that does not provide a
commit_iclog variable shoudl do that call xlog_commit_record()
itself, then xlog_write() can just assume that always returns the
last iclog, etc....


> >  static bool
> > @@ -2148,8 +2137,9 @@ xlog_print_trans(
> >  }
> >  
> >  /*
> > - * Calculate the potential space needed by the log vector.  Each region gets
> > - * its own xlog_op_header_t and may need to be double word aligned.
> > + * Calculate the potential space needed by the log vector.  We always write a
> > + * start record, and each region gets its own xlog_op_header_t and may need to
> > + * be double word aligned.
> >   */
> >  static int
> >  xlog_write_calc_vec_length(
> > @@ -2157,14 +2147,10 @@ xlog_write_calc_vec_length(
> >  	struct xfs_log_vec	*log_vector)
> >  {
> >  	struct xfs_log_vec	*lv;
> > -	int			headers = 0;
> > +	int			headers = 1;
> >  	int			len = 0;
> >  	int			i;
> >  
> > -	/* acct for start rec of xact */
> > -	if (ticket->t_flags & XLOG_TIC_INITED)
> > -		headers++;
> > -
> >  	for (lv = log_vector; lv; lv = lv->lv_next) {
> >  		/* we don't write ordered log vectors */
> >  		if (lv->lv_buf_len == XFS_LOG_VEC_ORDERED)
> > @@ -2195,17 +2181,11 @@ xlog_write_start_rec(
> >  	struct xlog_op_header	*ophdr,
> >  	struct xlog_ticket	*ticket)
> >  {
> > -	if (!(ticket->t_flags & XLOG_TIC_INITED))
> > -		return 0;
> > -
> >  	ophdr->oh_tid	= cpu_to_be32(ticket->t_tid);
> >  	ophdr->oh_clientid = ticket->t_clientid;
> >  	ophdr->oh_len = 0;
> >  	ophdr->oh_flags = XLOG_START_TRANS;
> >  	ophdr->oh_res2 = 0;
> > -
> > -	ticket->t_flags &= ~XLOG_TIC_INITED;
> > -
> >  	return sizeof(struct xlog_op_header);
> >  }
> 
> The header comment to this function refers to the "inited" state.

Missed that...

> Also note that there's a similar reference in
> xfs_log_write_unmount_record(), but that instance sets ->t_flags to zero
> so might be fine outside of the stale comment.

More cleanups!

> > @@ -2410,12 +2390,10 @@ xlog_write(
> >  	len = xlog_write_calc_vec_length(ticket, log_vector);
> >  
> >  	/*
> > -	 * Region headers and bytes are already accounted for.
> > -	 * We only need to take into account start records and
> > -	 * split regions in this function.
> > +	 * Region headers and bytes are already accounted for.  We only need to
> > +	 * take into account start records and split regions in this function.
> >  	 */
> > -	if (ticket->t_flags & XLOG_TIC_INITED)
> > -		ticket->t_curr_res -= sizeof(xlog_op_header_t);
> > +	ticket->t_curr_res -= sizeof(xlog_op_header_t);
> >  
> 
> So AFAICT the CIL allocates a ticket and up to this point only mucks
> around with the reservation value. That means _INITED is still in place
> once we get to xlog_write(). xlog_write() immediately calls
> xlog_write_calc_vec_length() and makes the ->t_curr_res adjustment
> before touching ->t_flags, so those bits all seems fine.
> 
> We then get into the log vector loops, where it looks like we call
> xlog_write_start_rec() for each log vector region and rely on the
> _INITED flag to only write a start record once per associated ticket.
> Unless I'm missing something, this looks like it would change behavior
> to perhaps write a start record per-region..? Note that this might not
> preclude the broader change to kill off _INITED since we're using the
> same ticket throughout the call, but some initial refactoring might be
> required to remove this dependency first.

Ah, yes, well spotted.

I need to move the call to xlog_write_start_rec() outside
the loop - it only needs to be written once per ticket, and we only
ever supply one ticket to xlog_write() now, and it is never reused
to call back into xlog_write again for the same transaction context.

I did say "compile tested only " :)

> > diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> > index b192c5a9f9fd..6965d164ff45 100644
> > --- a/fs/xfs/xfs_log_priv.h
> > +++ b/fs/xfs/xfs_log_priv.h
> > @@ -53,11 +53,9 @@ enum xlog_iclog_state {
> >  /*
> >   * Flags to log ticket
> >   */
> > -#define XLOG_TIC_INITED		0x1	/* has been initialized */
> >  #define XLOG_TIC_PERM_RESERV	0x2	/* permanent reservation */
> 
> These values don't end up on disk, right? If not, it might be worth
> resetting the _PERM_RESERV value to 1. Otherwise the rest looks like
> mostly straightforward refactoring. 

*nod*

-Dave.
-- 
Dave Chinner
david@fromorbit.com
