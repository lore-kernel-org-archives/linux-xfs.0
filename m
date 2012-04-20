Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3KIJoN7254337 for <xfs@oss.sgi.com>; Fri, 20 Apr 2012 13:19:50 -0500
Message-ID: <4F91A8C2.3050907@sgi.com>
Date: Fri, 20 Apr 2012 13:19:46 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 09/10] xfs: on-stack delayed write buffer lists
References: <20120327164400.967415009@bombadil.infradead.org>
	<20120327164646.975031281@bombadil.infradead.org>
In-Reply-To: <20120327164646.975031281@bombadil.infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On 03/27/12 11:44, Christoph Hellwig wrote:
> Queue delwri buffers on a local on-stack list instead of a per-buftarg one,
> and write back the buffers per-process instead of by waking up xfsbufd.
>
> This is now easily doable given that we have very few places left that write
> delwri buffers:
>
>   - log recovery:
> 	Only done at mount time, and already forcing out the buffers
> 	synchronously using xfs_flush_buftarg
>
>   - quotacheck:
> 	Same story.
>
>   - dquot reclaim:
> 	Writes out dirty dquots on the LRU under memory pressure.  We might
> 	want to look into doing more of this via xfsaild, but it's already
> 	more optimal than the synchronous inode reclaim that writes each
> 	buffer synchronously.
>
>   - xfsaild:
> 	This is the main beneficiary of the change.  By keeping a local list
> 	of buffers to write we reduce latency of writing out buffers, and
> 	more importably we can remove all the delwri list promotions which
> 	were hitting the buffer cache hard under sustained metadata loads.
>
> The implementation is very straight forward - xfs_buf_delwri_queue now gets
> a new list_head pointer that it adds the delwri buffers to, and all callers
> need to eventually submit the list using xfs_buf_delwi_submit or
> xfs_buf_delwi_submit_nowait.  Buffers that already are on a delwri list are
> skipped in xfs_buf_delwri_queue, assuming they already are on another delwri
> list.  The biggest change to pass down the buffer list was done to the AIL
> pushing. Now that we operate on buffers the trylock, push and pushbuf log
> item methods are merged into a single push routine, which tries to lock the
> item, and if possible add the buffer that needs writeback to the buffer list.
> This leads to much simpler code than the previous split but requires the
> individual IOP_PUSH instances to unlock and reacquire the AIL around calls
> to blocking routines.
>
> Given that xfsailds now also handles writing out buffers the conditions for
> log forcing and the sleep times needed some small changes.  The most
> important one is that we consider an AIL busy as long we still have buffers
> to push, and the other one is that we do increment the pushed LSN for
> buffers that are under flushing at this moment, but still count them towards
> the stuck items for restart purposes.  Without this we could hammer on stuck
> items without ever forcing the log and not make progress under heavy random
> delete workloads on fast flash storage devices.
>
> Signed-off-by: Christoph Hellwig<hch@lst.de>

Test 106 runs to completion with patch 06.

Patch 07 and 08 do not compile without patch 09.

Starting with patch 09, I get the following hang on every test 106:

ID: 27992  TASK: ffff8808310d00c0  CPU: 2   COMMAND: "mount"
  #0 [ffff880834237938] __schedule at ffffffff81417200
  #1 [ffff880834237a80] schedule at ffffffff81417574
  #2 [ffff880834237a90] schedule_timeout at ffffffff81415805
  #3 [ffff880834237b30] wait_for_common at ffffffff81416a67
  #4 [ffff880834237bc0] wait_for_completion at ffffffff81416bd8
  #5 [ffff880834237bd0] xfs_buf_iowait at ffffffffa04fc5a5 [xfs]
  #6 [ffff880834237c00] xfs_buf_delwri_submit at ffffffffa04fe4b9 [xfs]
  #7 [ffff880834237c40] xfs_qm_quotacheck at ffffffffa055cb2d [xfs]
  #8 [ffff880834237cc0] xfs_qm_mount_quotas at ffffffffa055cdf0 [xfs]
  #9 [ffff880834237cf0] xfs_mountfs at ffffffffa054c041 [xfs]
#10 [ffff880834237d40] xfs_fs_fill_super at ffffffffa050ca80 [xfs]
#11 [ffff880834237d70] mount_bdev at ffffffff81150c5c
#12 [ffff880834237de0] xfs_fs_mount at ffffffffa050ac00 [xfs]
#13 [ffff880834237df0] mount_fs at ffffffff811505f8
#14 [ffff880834237e40] vfs_kern_mount at ffffffff8116c070
#15 [ffff880834237e80] do_kern_mount at ffffffff8116c16e
#16 [ffff880834237ec0] do_mount at ffffffff8116d6f0
#17 [ffff880834237f20] sys_mount at ffffffff8116d7f3
#18 [ffff880834237f80] system_call_fastpath at ffffffff814203b9


The workers seem to be idle. For example the xfsaild:

PID: 27676  TASK: ffff880832880240  CPU: 3   COMMAND: "xfsaild/sda7"
  #0 [ffff880832933cb0] __schedule at ffffffff81417200
  #1 [ffff880832933df8] schedule at ffffffff81417574
  #2 [ffff880832933e08] schedule_timeout at ffffffff81415805
  #3 [ffff880832933ea8] xfsaild at ffffffffa0555935 [xfs]
  #4 [ffff880832933ee8] kthread at ffffffff8105dd6e
  #5 [ffff880832933f48] kernel_thread_helper at ffffffff814216a4


The hang is on the third quotacheck.

Should be easy to duplicate this.

--Mark Tinguely.


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
