Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:38806 "EHLO
        ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751159AbdEEDQe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 May 2017 23:16:34 -0400
Date: Fri, 5 May 2017 13:16:29 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xlog_write: reservation ran out
Message-ID: <20170505031629.GE17542@dastard>
References: <CAF1ivSZeYhnzh6CPZViYUNFXdm33hhTA_CzP7V745QociEEnKg@mail.gmail.com>
 <CAF1ivSbjdixqDo663wvAEkzRk-ctOX+y5UYxq4UdPA-=JVufyw@mail.gmail.com>
 <CAF1ivSbEfhTYxcBx1dafK9TD3VdeXbJrNMzWJmXY8kyU0ibkUw@mail.gmail.com>
 <8accf9d5-b2e4-c82e-fa47-3c5bc2ea35b1@kernel.org>
 <20170501131222.GA2109@bfoster.bfoster>
 <70def595-91a9-970a-d227-547055da5bb5@kernel.org>
 <20170502235152.GN12369@dastard>
 <20170503141030.GA11549@bfoster.bfoster>
 <20170504003435.GC17542@dastard>
 <20170504115102.GA3248@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170504115102.GA3248@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Ming Lin <mlin@kernel.org>, Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, Ceph Development <ceph-devel@vger.kernel.org>, "LIU, Fei" <james.liu@alibaba-inc.com>, xiongwei.jiang@alibaba-inc.com, boqian.zy@alibaba-inc.com, sheng.qiu@alibaba-inc.com, Sage Weil <sweil@redhat.com>

On Thu, May 04, 2017 at 07:51:02AM -0400, Brian Foster wrote:
> Seems reasonable. I suppose if we do the check at this level rather than
> in the caller, we could move the CIL insert code to the last step before
> we drop ->xc_cil_lock and have an accurate account of the reservation
> pulled off the transaction. E.g.:
> 
> {
> 	...
> 	tp->t_ticket->t_curr_res -= len;
> 	ctx->space_used += len;
> 
> 	/* dump tp on overrun prior to item removal */
> 	if (tp->t_ticket->t_curr_res < 0)
> 		xlog_print_tic(tp)
> 
> 	/* reposition to CIL ... */
> 	list_for_each_entry(lidp, &tp->t_items, lid_trans) {
> 		...
> 		list_move_tail(...);
> 	}
> 	spin_unlock(&cil->xc_cil_lock);
> }
> 
> ... where xlog_print_tic() can call xlog_print_tic_res() and then dump
> the t_items list as above.

We shouldn't call xlog_print_tic_res() while holding a spinlock
because it calls xfs_force_shutdown().  So I think all the overrun
checks and prints need to be outside the xc_cil_lock.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
