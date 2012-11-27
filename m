Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qARMhuU1101517 for <xfs@oss.sgi.com>; Tue, 27 Nov 2012 16:43:56 -0600
Message-ID: <50B542B3.4030402@sgi.com>
Date: Tue, 27 Nov 2012 16:46:11 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 2/3] xfs: fix direct IO nested transaction deadlock.
References: <1353641065-14983-1-git-send-email-david@fromorbit.com>
	<1353641065-14983-3-git-send-email-david@fromorbit.com>
	<50B390CA.3010203@sgi.com> <20121126214541.GP32450@dastard>
In-Reply-To: <20121126214541.GP32450@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 11/26/12 15:45, Dave Chinner wrote:
>> but with a bit more filesystem traffic (I
>> used your filesystem, fsstress and added the rm/copies from bug 922
>> because I knew it stressed the log), we can easily (couple hours) hang
>
> Script, please.

I started with your filesystem, fsstress and added the programs from Bug 
922:

http://oss.sgi.com/bugzilla/attachment.cgi?id=304
http://oss.sgi.com/bugzilla/attachment.cgi?id=305

#!/bin/sh
perl ./copy.pl &
sleep 180
while true
  do
#   ./check -g auto
   /root/xfstests/ltp/fsstress -d /test2 -n 1000 -p 1000
  done

I ran it on 2 different x86_64 boxes and both hung in few hours.
I did a command line sync on one of the boxes and the test continued
but the disk utilization was low.

Today, I re-ran the test on both machines with the following line
commented out of copy.pl:

  system("sudo sh -c 'echo 3 > /proc/sys/vm/drop_caches'");

So far both machines are still running although one machine, that has
been running over night started a pattern of performing at 100% disk
utilization for 2 minutes and then nearly a minute of near 0%
utilization. Now the utilization is bouncing between 1% to 60% with no
apparent pattern - this looks like the utilization. Unfortunately, I
cannot core that machine.

> That's waiting on unwritten extent conversion, so is a different
> problem to the one that this patch fixes because there are no nested
> transactions with the bug fix in place.
>
>> I still believe we should continue to push the AIL when the last push
>> was not enough to satisfy the first waiter, but that is just a minor
>> optimization so we do not have to wait until the next sync.
>
> There's no indication that the push target is the problem because
> the AIL is empty i.e. the push has worked correctly.

Yeah, I know this is not the problem. It was an observation.

>
>> Now that Brian fixed the locking issue,
>
> Remind me again what that was?
>

http://oss.sgi.com/archives/xfs/2012-06/msg00134.html
check for stale inode before acquiring iflock on push

The AIL is empty, so we know that is working fine.

>> the current hangs happen because
>> the sync worker is responsible to force the writing of the CIL but the
>> sync worker needs log space for the dummy record.
>
> The sync worker is responsible for idling the log, not much else.
>

My mistake. The sync worker will only push the AIL. I am thinking of the 
xfsaild_push() will force the CIL if there is a pinned item - not 
appropriate if the AIL is empty. It is xfs_fs_sync_fs() can force the 
CIL as can other commands.

Side question:
  What keeps the CIL from consuming more than half the log space?

Here are the data structures. This is strange, normally hangs with
an empty AIL, the space could be accounted for in the remain grant
space and CIL.
	===============
AIL at ffff88034c798640:
struct xfs_ail {
   xa_mount = 0xffff88034fdd3000,
   xa_task = 0xffff88034fe364c0,
   xa_ail = {
     next = 0xffff88034c798650,
     prev = 0xffff88034c798650
   },
   xa_target = 0xd000004000,
   xa_target_prev = 0xd000004000,
   xa_cursors = {
     next = 0xffff88034c798670,
     prev = 0xffff88034c798670
   },
   xa_lock = {
   },
   xa_last_pushed_lsn = 0x0,
   xa_log_flush = 0x0,
   xa_buf_list = {
     next = 0xffff88034c798698,
     prev = 0xffff88034c798698
   },
   xa_empty = {
     lock = {
     },
     task_list = {
       next = 0xffff88034c7986b0,
       prev = 0xffff88034c7986b0
     }
   }
}
	=====================
xlog at ffff88034ec0a400
struct xlog {
   l_mp = 0xffff88034fdd3000,
   l_ailp = 0xffff88034c798640,
   l_cilp = 0xffff88034c159ec0,
   l_xbuf = 0xffff880349e94c80,
   l_targ = 0xffff88034f78a8c0,
   l_work = {
     work = {
       data = {
         counter = 0x0
       },
       entry = {
         next = 0xffff88034ec0a430,
         prev = 0xffff88034ec0a430
       },
       func = 0xffffffffa0525e60 <_xfs_log_force+624>
     },
     timer = {
       entry = {
         next = 0x0,
         prev = 0xdead000000200200
       },
       expires = 0x10024c0d0,
       base = 0xffffffff81cb9e42,
       function = 0xffffffff8105a410 <delayed_work_timer_fn>,
       data = 0xffff88034ec0a428,
       slack = 0xffffffff,
       start_pid = 0xffffffff,
       start_site = 0x0,
       start_comm = 
"\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000"
     },
     cpu = 0x1000
   },
   l_flags = 0x10,
   l_quotaoffs_flag = 0x0,
   l_buf_cancel_table = 0x0,
   l_iclog_hsize = 0x1000,
   l_iclog_heads = 0x8,
   l_sectBBsize = 0x1,
   l_iclog_size = 0x40000,
   l_iclog_size_log = 0x12,
   l_iclog_bufs = 0x8,
   l_logBBstart = 0x4001200,
   l_logsize = 0xa00000,
   l_logBBsize = 0x5000,
   l_flush_wait = {
     lock = {
     },
     task_list = {
       next = 0xffff88034ec0a508,
       prev = 0xffff88034ec0a508
     }
   },
   l_covered_state = 0x1,
   l_iclog = 0xffff88034fd64b80,
   l_icloglock = {

   },
   l_curr_cycle = 0xd0,
   l_prev_cycle = 0xd0,
   l_curr_block = 0x4200,
   l_prev_block = 0x4000,
   l_last_sync_lsn = {
     counter = 0xd000004000
   },
   l_tail_lsn = {
     counter = 0xd000004000
   },
   l_reserve_head = {
     lock = {
     },
     waiters = {
       next = 0xffff8802ba98fe30,
       prev = 0xffff8802b7c312b0
     },
     grant = {
       counter = 0xd1006656f0
     }
   },

0x800000-0x6656F0 == 1681680 reserve space left
		=====================
Top waiter ticket at ffff8802ba98fe30
struct xlog_ticket {
   t_queue = {
     next = 0xffff8802b7f1d140,
     prev = 0xffff88034ec0a5c8
   },
   t_task = 0xffff8802bac3a3c0,
   t_tid = 0x5d1c97b2,
   t_ref = {
     counter = 0x1
   },
   t_curr_res = 0xa8b6c,
   t_unit_res = 0xa8b6c,
   t_ocnt = 0x3,
   t_cnt = 0x3,
   t_clientid = 0x69,
   t_flags = 0x3,

  wants 0xa8b6c * 3 == 2073156 bytes.

	=====================
CIL at ffff88034c159ec0

struct xfs_cil {
   xc_log = 0xffff88034ec0a400,
   xc_cil = {
     next = 0xffff8802b8001808,
     prev = 0xffff8802b82d79c8
   },
   xc_cil_lock = {
   },
   xc_ctx = 0xffff88035159b7c0,
   xc_ctx_lock = {
     count = 0x0,
     wait_lock = {
     },
     wait_list = {
       next = 0xffff88034c159ef8,
       prev = 0xffff88034c159ef8
     }
   },
   xc_committing = {
     next = 0xffff88034c159f08,
     prev = 0xffff88034c159f08
   },
   xc_commit_wait = {
     lock = {
     },
     task_list = {
       next = 0xffff88034c159f20,
       prev = 0xffff88034c159f20
     }
   },
   xc_current_sequence = 0x1de0,
   xc_push_work = {
     data = {
       counter = 0x200200
     },
     entry = {
       next = 0xffff88034c159f40,
       prev = 0xffff88034c159f40
     },
     func = 0xffffffffa0527bd0 <xlog_cil_push+688>
   },
   xc_push_seq = 0x1ddf
}

	=====================
struct xfs_cil_ctx {
   cil = 0xffff88034c159ec0,
   sequence = 0x1de0,
   start_lsn = 0x0,
   commit_lsn = 0x0,
   ticket = 0xffff8802b80c0e30,
   nvecs = 0xa9,
   space_used = 0x3d30,     <- only 15664 bytes
   busy_extents = {
     next = 0xffff880333ae2f98,
     prev = 0xffff880333ae2f98
   },
   lv_chain = 0x0,
   log_cb = {
     cb_next = 0x0,
     cb_func = 0,
     cb_arg = 0x0
   },
   committing = {
     next = 0xffff88035159b820,
     prev = 0xffff88035159b820
   }
}
The ticket held by the CIL CTX at ffff8802b80c0e30:
struct xlog_ticket {
   t_queue = {
     next = 0xffff8802b80c0e30,
     prev = 0xffff8802b80c0e30
   },
   t_task = 0xffff88034fe364c0,
   t_tid = 0x79652e47,
   t_ref = {
     counter = 0x1
   },
   t_curr_res = 0x82034,
   t_unit_res = 0x82034, <- 532532 bytes
   t_ocnt = 0x1,
   t_cnt = 0x1,
   t_clientid = 0x69,
   t_flags = 0x1,
   t_trans_type = 0x2a,
   t_res_num = 0x0,
   t_res_num_ophdrs = 0x0,
   t_res_arr_sum = 0x0,
   t_res_o_flow = 0x0,

The xfs_log_item in the CIL have li_seq numbers from 0x1de0 to 0x1dbc.
0x1de0 is the xc_current_sequence of the CIL.

All the  xlog_in_core entries' state are XLOG_STATE_ACTIVE.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
