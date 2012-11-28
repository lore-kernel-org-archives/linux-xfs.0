Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAS0BwQK113817 for <xfs@oss.sgi.com>; Tue, 27 Nov 2012 18:11:58 -0600
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	0oNYSjg2LYrnsyWL for <xfs@oss.sgi.com>;
	Tue, 27 Nov 2012 16:14:13 -0800 (PST)
Date: Wed, 28 Nov 2012 11:14:11 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/3] xfs: fix direct IO nested transaction deadlock.
Message-ID: <20121128001411.GP6434@dastard>
References: <1353641065-14983-1-git-send-email-david@fromorbit.com>
	<1353641065-14983-3-git-send-email-david@fromorbit.com>
	<50B390CA.3010203@sgi.com> <20121126214541.GP32450@dastard>
	<50B542B3.4030402@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <50B542B3.4030402@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

On Tue, Nov 27, 2012 at 04:46:11PM -0600, Mark Tinguely wrote:
> On 11/26/12 15:45, Dave Chinner wrote:
> >>but with a bit more filesystem traffic (I
> >>used your filesystem, fsstress and added the rm/copies from bug 922
> >>because I knew it stressed the log), we can easily (couple hours) hang
> >
> >Script, please.
> 
> I started with your filesystem, fsstress and added the programs from
> Bug 922:
> 
> http://oss.sgi.com/bugzilla/attachment.cgi?id=304
> http://oss.sgi.com/bugzilla/attachment.cgi?id=305
> 
> #!/bin/sh
> perl ./copy.pl &
> sleep 180
> while true
>  do
> #   ./check -g auto
>   /root/xfstests/ltp/fsstress -d /test2 -n 1000 -p 1000
>  done

Ok, I'll try it.

> >>the current hangs happen because
> >>the sync worker is responsible to force the writing of the CIL but the
> >>sync worker needs log space for the dummy record.
> >
> >The sync worker is responsible for idling the log, not much else.
> >
> 
> My mistake. The sync worker will only push the AIL. I am thinking of
> the xfsaild_push() will force the CIL if there is a pinned item -
> not appropriate if the AIL is empty. It is xfs_fs_sync_fs() can
> force the CIL as can other commands.
> 
> Side question:
>  What keeps the CIL from consuming more than half the log space?

See the comments in xfs_log_priv.h above these two lines:

#define XLOG_CIL_SPACE_LIMIT(log)       (log->l_logsize >> 3)
#define XLOG_CIL_HARD_SPACE_LIMIT(log)  (3 * (log->l_logsize >> 4))

> Here are the data structures. This is strange, normally hangs with
> an empty AIL, the space could be accounted for in the remain grant
> space and CIL.
> 	===============
> AIL at ffff88034c798640:
> struct xfs_ail {
....
>   xa_target = 0xd000004000,
>   xa_target_prev = 0xd000004000,
....
>   xa_last_pushed_lsn = 0x0,
>   xa_log_flush = 0x0,
....
> 	=====================
> xlog at ffff88034ec0a400
> struct xlog {
....
>   l_logsize = 0xa00000,

Which means the log is 10485760 bytes in size
...
>   l_curr_cycle = 0xd0,
>   l_prev_cycle = 0xd0,
>   l_curr_block = 0x4200,
>   l_prev_block = 0x4000,
>   l_last_sync_lsn = {
>     counter = 0xd000004000
>   },
>   l_tail_lsn = {
>     counter = 0xd000004000
>   },
>   l_reserve_head = {
>     lock = {
>     },
>     waiters = {
>       next = 0xffff8802ba98fe30,
>       prev = 0xffff8802b7c312b0
>     },
>     grant = {
>       counter = 0xd1006656f0
>     }
>   },
> 
> 0x800000-0x6656F0 == 1681680 reserve space left

BTW, when I ask for the full structure, I'd like to see the full
structure so that as i walk through the code I can refer back to the
structure to see that the values are what I think they should be...

> 		=====================
> Top waiter ticket at ffff8802ba98fe30
> struct xlog_ticket {
....
>   t_curr_res = 0xa8b6c,
>   t_unit_res = 0xa8b6c,
>   t_ocnt = 0x3,
>   t_cnt = 0x3,
>   t_clientid = 0x69,
>   t_flags = 0x3,
> 
>  wants 0xa8b6c * 3 == 2073156 bytes.

And that is close to 20% of the log size but not an invalid size.

The question is "what is holding all the grant space"? That's why I
need the whole struct xlog output - I suspect that there are
permanent transactions waiting on the write head and so can't move
forward and hence can't release grant space.


> 	=====================
> CIL at ffff88034c159ec0
> 
> struct xfs_cil {
.....
>   xc_current_sequence = 0x1de0,
.....
>   xc_push_seq = 0x1ddf
> }

Which indicates that there is an active sequence that hasn't been
pushed.

> 	=====================
> struct xfs_cil_ctx {
....
>   space_used = 0x3d30,     <- only 15664 bytes

So very little.

> The ticket held by the CIL CTX at ffff8802b80c0e30:
> struct xlog_ticket {
....
>   t_unit_res = 0x82034, <- 532532 bytes

Which means it has already stolen 532532 bytes from the existing
committed transactions in the CIL. This is accounted as used space
in the log as it is stolen from committed transactions that reserved
the space in the first place. 

However, this is such a small log, I'm wondering whether this
overhead is the source of the issue. It can't be freed up by pushing
on the AIL, and at 5% of the log space it increases the CIL
background push threshold by close to 50% (i.e. from 12.5% of the
log space used to 17.5%). And it's larger than the difference
between the reserve grant head and the ticket reservation size.

I think I need to reproduce this locally to be able to debug it...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
