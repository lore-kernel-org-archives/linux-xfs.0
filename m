Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:30580 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751444AbdECPxz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 3 May 2017 11:53:55 -0400
Date: Wed, 3 May 2017 08:53:35 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: xlog_write: reservation ran out
Message-ID: <20170503155335.GF5973@birch.djwong.org>
References: <CAF1ivSZeYhnzh6CPZViYUNFXdm33hhTA_CzP7V745QociEEnKg@mail.gmail.com>
 <CAF1ivSbjdixqDo663wvAEkzRk-ctOX+y5UYxq4UdPA-=JVufyw@mail.gmail.com>
 <CAF1ivSbEfhTYxcBx1dafK9TD3VdeXbJrNMzWJmXY8kyU0ibkUw@mail.gmail.com>
 <8accf9d5-b2e4-c82e-fa47-3c5bc2ea35b1@kernel.org>
 <20170501131222.GA2109@bfoster.bfoster>
 <70def595-91a9-970a-d227-547055da5bb5@kernel.org>
 <20170502235152.GN12369@dastard>
 <20170503141030.GA11549@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170503141030.GA11549@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Dave Chinner <david@fromorbit.com>, Ming Lin <mlin@kernel.org>, Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, Ceph Development <ceph-devel@vger.kernel.org>, "LIU, Fei" <james.liu@alibaba-inc.com>, xiongwei.jiang@alibaba-inc.com, boqian.zy@alibaba-inc.com, sheng.qiu@alibaba-inc.com, Sage Weil <sweil@redhat.com>

On Wed, May 03, 2017 at 10:10:32AM -0400, Brian Foster wrote:
> On Wed, May 03, 2017 at 09:51:52AM +1000, Dave Chinner wrote:
> > On Mon, May 01, 2017 at 10:41:06AM -0700, Ming Lin wrote:
> > > On 5/1/2017 6:12 AM, Brian Foster wrote:
> > > > On Sun, Apr 30, 2017 at 11:10:15PM -0700, Ming Lin wrote:
> > > >>
> > > >> On 4/28/2017 1:56 PM, Ming Lin wrote:
> > > >>> I'm new to xfs code.
> > > >>>
> > > >>> Search  XFS_TRANS_INACTIVE and the usage is like below,
> > > >>>
> > > >>> xfs_trans_alloc(mp, XFS_TRANS_INACTIVE);
> > > >>> xfs_trans_reserve(tp, &M_RES(mp)->tr_itruncate, 0, 0);
> > > >>>
> > > >>> xfs_trans_alloc(mp, XFS_TRANS_INACTIVE);
> > > >>> xfs_trans_reserve(tp, &M_RES(mp)->tr_ifree, XFS_IFREE_SPACE_RES(mp), 0);
> > > >>>
> > > >>> seems tr_remove is not related.
> > > >>> I'll just try to enlarge the reservation for tr_itruncate and tr_ifree.
> > > >>
> > > >> Now things are a little bit more clear. I tried below debug patch.
> > > >> The t_decrease[] array was used to track where the space was used.
> > > >>
> > > >>  fs/xfs/libxfs/xfs_trans_resv.c |  4 ++--
> > > >>  fs/xfs/xfs_log.c               | 23 ++++++++++++++++++++---
> > > >>  fs/xfs/xfs_log_cil.c           |  8 ++++++++
> > > >>  fs/xfs/xfs_log_priv.h          |  3 +++
> > > >>  fs/xfs/xfs_super.c             |  1 +
> > > >>  5 files changed, 34 insertions(+), 5 deletions(-)
> > > >>
> > > > ...
> > > >>  277 static void
> > > >>  278 xlog_cil_insert_items(
> > > >>  279         struct xlog             *log,
> > > >>  280         struct xfs_trans        *tp)
> > > >>  281 {
> > > >>
> > > >> ....
> > > >>
> > > >>  340         /* do we need space for more log record headers? */
> > > >>  341         iclog_space = log->l_iclog_size - log->l_iclog_hsize;
> > > >>  342         if (len > 0 && (ctx->space_used / iclog_space !=
> > > >>  343                                 (ctx->space_used + len) / iclog_space)) {
> > > >>  344                 int hdrs;
> > > >>  345
> > > >>  346                 hdrs = (len + iclog_space - 1) / iclog_space;
> > > >>  347                 /* need to take into account split region headers, too */
> > > >>  348                 hdrs *= log->l_iclog_hsize + sizeof(struct xlog_op_header);
> > > >>  349                 ctx->ticket->t_unit_res += hdrs;
> > > >>  350                 ctx->ticket->t_curr_res += hdrs;
> > > >>  351                 tp->t_ticket->t_curr_res -= hdrs;
> > > >>  352                 tp->t_ticket->t_decrease[6] = hdrs;
> > > >>  353                 ASSERT(tp->t_ticket->t_curr_res >= len);
> > > >>  354         }
> > > >>  355         tp->t_ticket->t_curr_res -= len;
> > > >>  356         tp->t_ticket->t_decrease[7] = len;
> > > >>  357         ctx->space_used += len;
> > > >>  358
> > > >>  359         spin_unlock(&cil->xc_cil_lock);
> > > >>  360 }
> > > >>
> > > >> Any idea why it used so many reservation space here?
> > > >>
> > > > 
> > > > Nothing really rings a bell for me atm. Perhaps others might have ideas.
> > > > That does appear to be a sizable overrun, as opposed to a few bytes that
> > > > could more likely be attributed to rounding, header accounting issues or
> > > > something of that nature.
> > > 
> > > FYI, here are some numbers.
> > > 
> > > The original "unit res" is 83024. I made it x2 larger, so now it's 166048
> > > "unit res" - "current res" = the reservation space already used
> > > 
> > > XFS (nvme10n1p1): xlog_write: reservation summary:
> > >   trans type  = INACTIVE (3)
> > >   unit res    = 166048 bytes
> > >   current res = 77088 bytes
> > >   total reg   = 0 bytes (o/flow = 0 bytes)
> > >   ophdrs      = 0 (ophdr space = 0 bytes)
> > >   ophdr + reg = 0 bytes
> > >   num regions = 0
> > 
> > So the problem here is that the ticket summary is being printed
> > after everything useful has been removed from the ticket and moved
> > to the CIL. i.e. for more useful debug, this overrun condition
> > needs to be checked between the xlog_cil_insert_format_items() call
> > and moving the items off the transaction in xfs_log_commit_cil().
> > 
> > That way xlog_print_tic_res() will actually tell us how many regions
> > are being logged and give us a much better idea of the scope of
> > changes logged in the transaction that lead to the overrun.
> > 
> 
> Hmm.. interesting idea, but I'm not sure that just moving the ticket
> summary prior to the CIL insertion tells us much. For one, this is a
> transaction ticket and afaict the region count bits are only really used
> for a CIL ticket, unless I'm missing something..? IOWs, it seems to me
> that if we had such pre-CIL format overrun detection, we'd probably want
> to add new code to dump information about what is attached to the
> transaction so we can analyze what was logged against the actual
> reservation.
> 
> Assuming we add such code, we'd still need to actually detect the
> overrun before doing the insert, which is currently where we calculate
> the consumed transaction reservation (i.e., in the ->iop_format()
> callouts). I guess we could look into refactoring that, though I fear
> that would get ugly rather quickly. I'm also not sure how deterministic
> we can be given some of the additional drains on the transaction ticket
> reservation from xlog_cil_insert_items(). Perhaps we could assume worst
> case in that regard?
> 
> I note that shadow buffer allocation already processes the size of each
> item. I wonder if we could just use that to perform a semi-lazy
> pre-insert check to see if we've already blown the reservation before
> the CIL has started to process the tp (leaving the post-insert check in
> place, as well). For example, update xlog_cil_alloc_shadow_bufs() to
> return a total 'nbytes' from the dirty tp items and use that value in

Seems useful to be able to detect potential overruns and to dump the
current list of log items via ftrace or something so that we can capture
exactly what was going on when an overflow happened.

> the caller. Hmm, thinking more about it, I suppose we could just add
> another similar helper since we'd presumably want to process the list of
> items again if the reservation is overrun. Thoughts?

Process them again how?  I think I'm missing something here; are you
saying that we could (try to) get more reservation if allocating the
shadow buffer shows that we've run over?

--D

> 
> Brian
> 
> > -Dave.
> > -- 
> > Dave Chinner
> > david@fromorbit.com
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
