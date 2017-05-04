Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34884 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752933AbdEDLvO (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 4 May 2017 07:51:14 -0400
Date: Thu, 4 May 2017 07:51:02 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: xlog_write: reservation ran out
Message-ID: <20170504115102.GA3248@bfoster.bfoster>
References: <CAF1ivSZeYhnzh6CPZViYUNFXdm33hhTA_CzP7V745QociEEnKg@mail.gmail.com>
 <CAF1ivSbjdixqDo663wvAEkzRk-ctOX+y5UYxq4UdPA-=JVufyw@mail.gmail.com>
 <CAF1ivSbEfhTYxcBx1dafK9TD3VdeXbJrNMzWJmXY8kyU0ibkUw@mail.gmail.com>
 <8accf9d5-b2e4-c82e-fa47-3c5bc2ea35b1@kernel.org>
 <20170501131222.GA2109@bfoster.bfoster>
 <70def595-91a9-970a-d227-547055da5bb5@kernel.org>
 <20170502235152.GN12369@dastard>
 <20170503141030.GA11549@bfoster.bfoster>
 <20170504003435.GC17542@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170504003435.GC17542@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Ming Lin <mlin@kernel.org>, Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, Ceph Development <ceph-devel@vger.kernel.org>, "LIU, Fei" <james.liu@alibaba-inc.com>, xiongwei.jiang@alibaba-inc.com, boqian.zy@alibaba-inc.com, sheng.qiu@alibaba-inc.com, Sage Weil <sweil@redhat.com>

On Thu, May 04, 2017 at 10:34:35AM +1000, Dave Chinner wrote:
> On Wed, May 03, 2017 at 10:10:32AM -0400, Brian Foster wrote:
> > On Wed, May 03, 2017 at 09:51:52AM +1000, Dave Chinner wrote:
> > > On Mon, May 01, 2017 at 10:41:06AM -0700, Ming Lin wrote:
> > > > On 5/1/2017 6:12 AM, Brian Foster wrote:
> > > > > On Sun, Apr 30, 2017 at 11:10:15PM -0700, Ming Lin wrote:
> > > > >>
> > > > >> On 4/28/2017 1:56 PM, Ming Lin wrote:
> > > > >>> I'm new to xfs code.
> > > > >>>
> > > > >>> Search  XFS_TRANS_INACTIVE and the usage is like below,
> > > > >>>
> > > > >>> xfs_trans_alloc(mp, XFS_TRANS_INACTIVE);
> > > > >>> xfs_trans_reserve(tp, &M_RES(mp)->tr_itruncate, 0, 0);
> > > > >>>
> > > > >>> xfs_trans_alloc(mp, XFS_TRANS_INACTIVE);
> > > > >>> xfs_trans_reserve(tp, &M_RES(mp)->tr_ifree, XFS_IFREE_SPACE_RES(mp), 0);
> > > > >>>
> > > > >>> seems tr_remove is not related.
> > > > >>> I'll just try to enlarge the reservation for tr_itruncate and tr_ifree.
> > > > >>
> > > > >> Now things are a little bit more clear. I tried below debug patch.
> > > > >> The t_decrease[] array was used to track where the space was used.
> > > > >>
> > > > >>  fs/xfs/libxfs/xfs_trans_resv.c |  4 ++--
> > > > >>  fs/xfs/xfs_log.c               | 23 ++++++++++++++++++++---
> > > > >>  fs/xfs/xfs_log_cil.c           |  8 ++++++++
> > > > >>  fs/xfs/xfs_log_priv.h          |  3 +++
> > > > >>  fs/xfs/xfs_super.c             |  1 +
> > > > >>  5 files changed, 34 insertions(+), 5 deletions(-)
> > > > >>
> > > > > ...
> > > > >>  277 static void
> > > > >>  278 xlog_cil_insert_items(
> > > > >>  279         struct xlog             *log,
> > > > >>  280         struct xfs_trans        *tp)
> > > > >>  281 {
> > > > >>
> > > > >> ....
> > > > >>
> > > > >>  340         /* do we need space for more log record headers? */
> > > > >>  341         iclog_space = log->l_iclog_size - log->l_iclog_hsize;
> > > > >>  342         if (len > 0 && (ctx->space_used / iclog_space !=
> > > > >>  343                                 (ctx->space_used + len) / iclog_space)) {
> > > > >>  344                 int hdrs;
> > > > >>  345
> > > > >>  346                 hdrs = (len + iclog_space - 1) / iclog_space;
> > > > >>  347                 /* need to take into account split region headers, too */
> > > > >>  348                 hdrs *= log->l_iclog_hsize + sizeof(struct xlog_op_header);
> > > > >>  349                 ctx->ticket->t_unit_res += hdrs;
> > > > >>  350                 ctx->ticket->t_curr_res += hdrs;
> > > > >>  351                 tp->t_ticket->t_curr_res -= hdrs;
> > > > >>  352                 tp->t_ticket->t_decrease[6] = hdrs;
> > > > >>  353                 ASSERT(tp->t_ticket->t_curr_res >= len);
> > > > >>  354         }
> > > > >>  355         tp->t_ticket->t_curr_res -= len;
> > > > >>  356         tp->t_ticket->t_decrease[7] = len;
> > > > >>  357         ctx->space_used += len;
> > > > >>  358
> > > > >>  359         spin_unlock(&cil->xc_cil_lock);
> > > > >>  360 }
> > > > >>
> > > > >> Any idea why it used so many reservation space here?
> > > > >>
> > > > > 
> > > > > Nothing really rings a bell for me atm. Perhaps others might have ideas.
> > > > > That does appear to be a sizable overrun, as opposed to a few bytes that
> > > > > could more likely be attributed to rounding, header accounting issues or
> > > > > something of that nature.
> > > > 
> > > > FYI, here are some numbers.
> > > > 
> > > > The original "unit res" is 83024. I made it x2 larger, so now it's 166048
> > > > "unit res" - "current res" = the reservation space already used
> > > > 
> > > > XFS (nvme10n1p1): xlog_write: reservation summary:
> > > >   trans type  = INACTIVE (3)
> > > >   unit res    = 166048 bytes
> > > >   current res = 77088 bytes
> > > >   total reg   = 0 bytes (o/flow = 0 bytes)
> > > >   ophdrs      = 0 (ophdr space = 0 bytes)
> > > >   ophdr + reg = 0 bytes
> > > >   num regions = 0
> > > 
> > > So the problem here is that the ticket summary is being printed
> > > after everything useful has been removed from the ticket and moved
> > > to the CIL. i.e. for more useful debug, this overrun condition
> > > needs to be checked between the xlog_cil_insert_format_items() call
> > > and moving the items off the transaction in xfs_log_commit_cil().
> > > 
> > > That way xlog_print_tic_res() will actually tell us how many regions
> > > are being logged and give us a much better idea of the scope of
> > > changes logged in the transaction that lead to the overrun.
> > > 
> > 
> > Hmm.. interesting idea, but I'm not sure that just moving the ticket
> > summary prior to the CIL insertion tells us much. For one, this is a
> > transaction ticket and afaict the region count bits are only really used
> > for a CIL ticket, unless I'm missing something..?
> 
> Seems like it - I was talking about dumping the logged regions in the
> transaction log items, not the formatted log vectors passed to
> xlog_write() from the CIL.
> 

Ok. I wasn't suggesting the latter, fwiw. Just pointing out that afaict,
moving xlog_print_tic_res() without making further enhancements looked
like it would just change the "current res" value that ends up printed.

> We've got the log items and their vectors still attached to the
> transaction pointer after the call to xlog_cil_insert_format_items()
> (i.e. on the tp->t_items list), and we know what the formatted
> length is going to be and so we can directly check for overrun
> before doing anything else. i.e. something like:
> 

Indeed...

> ....
> 	xlog_cil_insert_format_items(log, tp, &len, &diff_iovecs);
> 
> 	/* account for space used by new iovec headers  */
> 	len += diff_iovecs * sizeof(xlog_op_header_t);
> 
> 	/* trivial overrun check */
> 	if (tp->t_ticket->t_curr_res - len < 0) {
> 		/* factor printing into helper */
> 
> 		xfs_warn("transaction reservation overrun <transaction info>")
> 		/* dump transaction/ticket info */
> 
> 		list_for_each_entry(lidp, &tp->t_items, lid_trans) {
> 			struct xfs_log_item     *lip = lidp->lid_item;
> 			struct xfs_log_iovec	*lv = lip->li_lv;
> 
> 			/* dump log item info */
> 			xfs_warn("Log item type, flags, ...");
> 
> 			/* dump lv array info */
> 
> 			/* dump formatted log vector regions */
> 			for (i = 0; i < lv->lv_niovecs; i++) {
> 				/* dump individual lv info */
> 				/* dump first 32 bytes */
> 			}
> 		}
> 	}
> 

Seems reasonable. I suppose if we do the check at this level rather than
in the caller, we could move the CIL insert code to the last step before
we drop ->xc_cil_lock and have an accurate account of the reservation
pulled off the transaction. E.g.:

{
	...
	tp->t_ticket->t_curr_res -= len;
	ctx->space_used += len;

	/* dump tp on overrun prior to item removal */
	if (tp->t_ticket->t_curr_res < 0)
		xlog_print_tic(tp)

	/* reposition to CIL ... */
	list_for_each_entry(lidp, &tp->t_items, lid_trans) {
		...
		list_move_tail(...);
	}
	spin_unlock(&cil->xc_cil_lock);
}

... where xlog_print_tic() can call xlog_print_tic_res() and then dump
the t_items list as above.

> > IOWs, it seems to me
> > that if we had such pre-CIL format overrun detection, we'd probably want
> > to add new code to dump information about what is attached to the
> > transaction so we can analyze what was logged against the actual
> > reservation.
> 
> Yes, that's exactly what I'm suggesting needs to be done.
> 

Ok, I'll play around with it. Thanks for the clarification.

Brian

> Keep in mind this is what xlog_print_tic_res() did prior to the
> introduction of delayed logging. i.e. I broke the detailed region
> logging of transaction overruns 7 years ago when changing it to
> provide detailed logging of CIL ticket reservation overruns, and
> this is the first time since then that we've needed transaction
> overrun debugging...
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
