Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:19869 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750815AbdEBXv6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 May 2017 19:51:58 -0400
Date: Wed, 3 May 2017 09:51:52 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xlog_write: reservation ran out
Message-ID: <20170502235152.GN12369@dastard>
References: <CAF1ivSZeYhnzh6CPZViYUNFXdm33hhTA_CzP7V745QociEEnKg@mail.gmail.com>
 <CAF1ivSbjdixqDo663wvAEkzRk-ctOX+y5UYxq4UdPA-=JVufyw@mail.gmail.com>
 <CAF1ivSbEfhTYxcBx1dafK9TD3VdeXbJrNMzWJmXY8kyU0ibkUw@mail.gmail.com>
 <8accf9d5-b2e4-c82e-fa47-3c5bc2ea35b1@kernel.org>
 <20170501131222.GA2109@bfoster.bfoster>
 <70def595-91a9-970a-d227-547055da5bb5@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <70def595-91a9-970a-d227-547055da5bb5@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ming Lin <mlin@kernel.org>
Cc: Brian Foster <bfoster@redhat.com>, Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, Ceph Development <ceph-devel@vger.kernel.org>, "LIU, Fei" <james.liu@alibaba-inc.com>, xiongwei.jiang@alibaba-inc.com, boqian.zy@alibaba-inc.com, sheng.qiu@alibaba-inc.com, Sage Weil <sweil@redhat.com>

On Mon, May 01, 2017 at 10:41:06AM -0700, Ming Lin wrote:
> On 5/1/2017 6:12 AM, Brian Foster wrote:
> > On Sun, Apr 30, 2017 at 11:10:15PM -0700, Ming Lin wrote:
> >>
> >> On 4/28/2017 1:56 PM, Ming Lin wrote:
> >>> I'm new to xfs code.
> >>>
> >>> Search  XFS_TRANS_INACTIVE and the usage is like below,
> >>>
> >>> xfs_trans_alloc(mp, XFS_TRANS_INACTIVE);
> >>> xfs_trans_reserve(tp, &M_RES(mp)->tr_itruncate, 0, 0);
> >>>
> >>> xfs_trans_alloc(mp, XFS_TRANS_INACTIVE);
> >>> xfs_trans_reserve(tp, &M_RES(mp)->tr_ifree, XFS_IFREE_SPACE_RES(mp), 0);
> >>>
> >>> seems tr_remove is not related.
> >>> I'll just try to enlarge the reservation for tr_itruncate and tr_ifree.
> >>
> >> Now things are a little bit more clear. I tried below debug patch.
> >> The t_decrease[] array was used to track where the space was used.
> >>
> >>  fs/xfs/libxfs/xfs_trans_resv.c |  4 ++--
> >>  fs/xfs/xfs_log.c               | 23 ++++++++++++++++++++---
> >>  fs/xfs/xfs_log_cil.c           |  8 ++++++++
> >>  fs/xfs/xfs_log_priv.h          |  3 +++
> >>  fs/xfs/xfs_super.c             |  1 +
> >>  5 files changed, 34 insertions(+), 5 deletions(-)
> >>
> > ...
> >>  277 static void
> >>  278 xlog_cil_insert_items(
> >>  279         struct xlog             *log,
> >>  280         struct xfs_trans        *tp)
> >>  281 {
> >>
> >> ....
> >>
> >>  340         /* do we need space for more log record headers? */
> >>  341         iclog_space = log->l_iclog_size - log->l_iclog_hsize;
> >>  342         if (len > 0 && (ctx->space_used / iclog_space !=
> >>  343                                 (ctx->space_used + len) / iclog_space)) {
> >>  344                 int hdrs;
> >>  345
> >>  346                 hdrs = (len + iclog_space - 1) / iclog_space;
> >>  347                 /* need to take into account split region headers, too */
> >>  348                 hdrs *= log->l_iclog_hsize + sizeof(struct xlog_op_header);
> >>  349                 ctx->ticket->t_unit_res += hdrs;
> >>  350                 ctx->ticket->t_curr_res += hdrs;
> >>  351                 tp->t_ticket->t_curr_res -= hdrs;
> >>  352                 tp->t_ticket->t_decrease[6] = hdrs;
> >>  353                 ASSERT(tp->t_ticket->t_curr_res >= len);
> >>  354         }
> >>  355         tp->t_ticket->t_curr_res -= len;
> >>  356         tp->t_ticket->t_decrease[7] = len;
> >>  357         ctx->space_used += len;
> >>  358
> >>  359         spin_unlock(&cil->xc_cil_lock);
> >>  360 }
> >>
> >> Any idea why it used so many reservation space here?
> >>
> > 
> > Nothing really rings a bell for me atm. Perhaps others might have ideas.
> > That does appear to be a sizable overrun, as opposed to a few bytes that
> > could more likely be attributed to rounding, header accounting issues or
> > something of that nature.
> 
> FYI, here are some numbers.
> 
> The original "unit res" is 83024. I made it x2 larger, so now it's 166048
> "unit res" - "current res" = the reservation space already used
> 
> XFS (nvme10n1p1): xlog_write: reservation summary:
>   trans type  = INACTIVE (3)
>   unit res    = 166048 bytes
>   current res = 77088 bytes
>   total reg   = 0 bytes (o/flow = 0 bytes)
>   ophdrs      = 0 (ophdr space = 0 bytes)
>   ophdr + reg = 0 bytes
>   num regions = 0

So the problem here is that the ticket summary is being printed
after everything useful has been removed from the ticket and moved
to the CIL. i.e. for more useful debug, this overrun condition
needs to be checked between the xlog_cil_insert_format_items() call
and moving the items off the transaction in xfs_log_commit_cil().

That way xlog_print_tic_res() will actually tell us how many regions
are being logged and give us a much better idea of the scope of
changes logged in the transaction that lead to the overrun.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
