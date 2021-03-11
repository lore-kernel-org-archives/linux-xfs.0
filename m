Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AC7BC433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Mar 2021 04:34:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C7F0164FA7
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Mar 2021 04:34:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231146AbhCKEeQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 10 Mar 2021 23:34:16 -0500
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:44474 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230462AbhCKEeB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 Mar 2021 23:34:01 -0500
Received: from dread.disaster.area (pa49-181-239-12.pa.nsw.optusnet.com.au [49.181.239.12])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id B6AD7D6C;
        Thu, 11 Mar 2021 15:33:59 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lKD1L-0019Xw-6s; Thu, 11 Mar 2021 15:33:59 +1100
Date:   Thu, 11 Mar 2021 15:33:59 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 29/45] xfs:_introduce xlog_write_partial()
Message-ID: <20210311043359.GO74031@dread.disaster.area>
References: <20210305051143.182133-1-david@fromorbit.com>
 <20210305051143.182133-30-david@fromorbit.com>
 <20210309025932.GQ3419940@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210309025932.GQ3419940@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0 cx=a_idp_d
        a=gO82wUwQTSpaJfP49aMSow==:117 a=gO82wUwQTSpaJfP49aMSow==:17
        a=kj9zAlcOel0A:10 a=dESyimp9J3IA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=VpnQg93VVPwUGaG2zgMA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 08, 2021 at 06:59:32PM -0800, Darrick J. Wong wrote:
> On Fri, Mar 05, 2021 at 04:11:27PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Handle writing of a logvec chain into an iclog that doesn't have
> > enough space to fit it all. The iclog has already been changed to
> > WANT_SYNC by xlog_get_iclog_space(), so the entire remaining space
> > in the iclog is exclusively owned by this logvec chain.
> > 
> > The difference between the single and partial cases is that
> > we end up with partial iovec writes in the iclog and have to split
> > a log vec regions across two iclogs. The state handling for this is
> > currently awful and so we're building up the pieces needed to
> > handle this more cleanly one at a time.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/xfs_log.c | 525 ++++++++++++++++++++++-------------------------
> >  1 file changed, 251 insertions(+), 274 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> > index 590c1e6db475..10916b99bf0f 100644
> > --- a/fs/xfs/xfs_log.c
> > +++ b/fs/xfs/xfs_log.c
> > @@ -2099,166 +2099,250 @@ xlog_print_trans(
> >  	}
> >  }
> >  
> > -static xlog_op_header_t *
> > -xlog_write_setup_ophdr(
> > -	struct xlog_op_header	*ophdr,
> > -	struct xlog_ticket	*ticket)
> > -{
> > -	ophdr->oh_clientid = XFS_TRANSACTION;
> > -	ophdr->oh_res2 = 0;
> > -	ophdr->oh_flags = 0;
> > -	return ophdr;
> > -}
> > -
> >  /*
> > - * Set up the parameters of the region copy into the log. This has
> > - * to handle region write split across multiple log buffers - this
> > - * state is kept external to this function so that this code can
> > - * be written in an obvious, self documenting manner.
> > + * Write whole log vectors into a single iclog which is guaranteed to have
> > + * either sufficient space for the entire log vector chain to be written or
> > + * exclusive access to the remaining space in the iclog.
> > + *
> > + * Return the number of iovecs and data written into the iclog, as well as
> > + * a pointer to the logvec that doesn't fit in the log (or NULL if we hit the
> > + * end of the chain.
> >   */
> > -static int
> > -xlog_write_setup_copy(
> > +static struct xfs_log_vec *
> > +xlog_write_single(
> 
> Ouch.  Could you fix the previous patch to move this new function a
> little higher in the file (like above xlog_write_setup_ophdr) so that it
> doesn't get shredded like this?

Not possible because xlog_write_setup_ophdr() is removed by this
patch. I can't help it if the diffs are unreadable - I can't really
control what git is doing here...

> > @@ -2930,7 +2906,7 @@ xlog_state_get_iclog_space(
> >  	 * xlog_write() algorithm assumes that at least 2 xlog_op_header_t's
> >  	 * can fit into remaining data section.
> >  	 */
> > -	if (iclog->ic_size - iclog->ic_offset < 2*sizeof(xlog_op_header_t)) {
> > +	if (iclog->ic_size - iclog->ic_offset < 3*sizeof(xlog_op_header_t)) {
> 
> Why does this change to 3?  Does the comment need amending?

Ah, that was to do with the avoiding the need to split the start
record/transaction header of across two iclogs. That was because the
partial copy loop didn't have special handling for start records
and so that log vector had to be wholly handled by the
xlog_write_single() loop to set the iclog flush flags.

However, with all the changes since then that have added explicit
pre-flushes before the start record is formatted and the lifting of
the iclog flush flags to the callers, we've removed all
the special optype handling in xlog_write(). Hence we no longer need
to guarantee the start record is handled by the single path, it now
can be handled by this partial path just fine. So I can revert this
hunk.

Did I mention that this code was full of all sorts of subtle corner
cases? :/

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
