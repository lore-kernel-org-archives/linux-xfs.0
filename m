Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A25C229DF8
	for <xfs@oss.sgi.com>; Sat,  8 Jun 2013 22:37:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 75BE2304032
	for <xfs@oss.sgi.com>; Sat,  8 Jun 2013 20:37:50 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	mCvOsvF062xhc0zo for <xfs@oss.sgi.com>;
	Sat, 08 Jun 2013 20:37:48 -0700 (PDT)
Date: Sun, 9 Jun 2013 13:37:44 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: 3.10-rc4 stalls during mmap writes
Message-ID: <20130609033744.GA29376@dastard>
References: <20130607193712.GD2995@sbohrermbp13-local.rgmadvisors.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130607193712.GD2995@sbohrermbp13-local.rgmadvisors.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Shawn Bohrer <sbohrer@rgmadvisors.com>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Fri, Jun 07, 2013 at 02:37:12PM -0500, Shawn Bohrer wrote:
> I've started testing the 3.10 kernel, previously I was on 3.4, and I'm
> encounting some fairly large stalls in my memory mapped writes in the
> range of .01 to 1s.  I've managed to capture two of these stalls so
> far and both looked like the following:
> 
> 1) Writing process writes to a new page and blocks on xfs_ilock:
> 
>     <...>-21567 [009]  9435.453069: sched_switch:     prev_comm=tick_receiver_m prev_pid=21567 prev_prio=79 prev_state=D ==> next_comm=swapper/9 next_pid=0 next_prio=120
>     <...>-21567 [009]  9435.453072: kernel_stack:     <stack trace>
> => schedule (ffffffff814ca379)
> => rwsem_down_write_failed (ffffffff814cb095)
> => call_rwsem_down_write_failed (ffffffff81275053)
> => xfs_ilock (ffffffff8120b25c)
> => xfs_vn_update_time (ffffffff811cf3d3)
> => update_time (ffffffff81158dd3)
> => file_update_time (ffffffff81158f0c)
> => block_page_mkwrite (ffffffff81171d23)
> => xfs_vm_page_mkwrite (ffffffff811c5375)
> => do_wp_page (ffffffff8110c27f)
> => handle_pte_fault (ffffffff8110dd24)
> => handle_mm_fault (ffffffff8110f430)
> => __do_page_fault (ffffffff814cef72)
> => do_page_fault (ffffffff814cf2e7)
> => page_fault (ffffffff814cbab2)

Changing C/MTIME on the inode. Needs a lock, the update is
transactional.

> 
> 2) kworker calls xfs_iunlock and wakes up my process:
> 
>    kworker/u50:1-403   [013]  9436.027354: sched_wakeup:     comm=tick_receiver_m pid=21567 prio=79 success=1 target_cpu=009
>    kworker/u50:1-403   [013]  9436.027359: kernel_stack:     <stack trace>
> => ttwu_do_activate.constprop.34 (ffffffff8106c556)
> => try_to_wake_up (ffffffff8106e996)
> => wake_up_process (ffffffff8106ea87)
> => __rwsem_do_wake (ffffffff8126e531)
> => rwsem_wake (ffffffff8126e62a)
> => call_rwsem_wake (ffffffff81275077)
> => xfs_iunlock (ffffffff8120b55c)
> => xfs_iomap_write_allocate (ffffffff811ce4e7)
> => xfs_map_blocks (ffffffff811bf145)
> => xfs_vm_writepage (ffffffff811bfbc2)

And allocation during writeback is holding the lock on that inode
as it's already in a transaction.

> So I guess my question is does anyone know why I'm now seeing these
> stalls with 3.10?

Because we made all metadata updates in XFS fully transactional in
3.4:

commit 8a9c9980f24f6d86e0ec0150ed35fba45d0c9f88
Author: Christoph Hellwig <hch@infradead.org>
Date:   Wed Feb 29 09:53:52 2012 +0000

    xfs: log timestamp updates
    
    Timestamps on regular files are the last metadata that XFS does not update
    transactionally.  Now that we use the delaylog mode exclusively and made
    the log scode scale extremly well there is no need to bypass that code for
    timestamp updates.  Logging all updates allows to drop a lot of code, and
    will allow for further performance improvements later on.
    
    Note that this patch drops optimized handling of fdatasync - it will be
    added back in a separate commit.
    
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Christoph Hellwig <hch@lst.de>
    Reviewed-by: Mark Tinguely <tinguely@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>
$ git describe --contains 8a9c998
v3.4-rc1~55^2~23

IOWs, you're just lucky you haven't noticed it on 3.4....

> Are there any suggestions for how to eliminate them?

Nope. You're stuck with it - there's far more places in the page
fault path where you can get stuck on the same lock for the same
reason - e.g. during block mapping for the newly added pagecache
page...

Hint: mmap() does not provide -deterministic- low latency access to
mapped pages - it is only "mostly low latency". mmap() has exactly
the same worst case page fault latencies as the equivalent write()
syscall. e.g., dirty too many pages and mmap() write page faults
can be throttled, just like a write() syscall....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
