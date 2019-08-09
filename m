Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:37826 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732796AbfHIBfP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 8 Aug 2019 21:35:15 -0400
Date: Fri, 9 Aug 2019 11:34:03 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] direct-io: use GFP_NOIO to avoid deadlock
Message-ID: <20190809013403.GY7777@dread.disaster.area>
References: <alpine.LRH.2.02.1908080540240.15519@file01.intranet.prod.int.rdu2.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1908080540240.15519@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, "Darrick J. Wong" <darrick.wong@oracle.com>, Mike Snitzer <msnitzer@redhat.com>, junxiao.bi@oracle.com, dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>, honglei.wang@oracle.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org

On Thu, Aug 08, 2019 at 05:50:10AM -0400, Mikulas Patocka wrote:
> A deadlock with this stacktrace was observed.
> 
> The obvious problem here is that in the call chain 
> xfs_vm_direct_IO->__blockdev_direct_IO->do_blockdev_direct_IO->kmem_cache_alloc 
> we do a GFP_KERNEL allocation while we are in a filesystem driver and in a 
> block device driver.
> 
> This patch changes the direct-io code to use GFP_NOIO.
> 
> PID: 474    TASK: ffff8813e11f4600  CPU: 10  COMMAND: "kswapd0"
>    #0 [ffff8813dedfb938] __schedule at ffffffff8173f405
>    #1 [ffff8813dedfb990] schedule at ffffffff8173fa27
>    #2 [ffff8813dedfb9b0] schedule_timeout at ffffffff81742fec
>    #3 [ffff8813dedfba60] io_schedule_timeout at ffffffff8173f186
>    #4 [ffff8813dedfbaa0] bit_wait_io at ffffffff8174034f
>    #5 [ffff8813dedfbac0] __wait_on_bit at ffffffff8173fec8
>    #6 [ffff8813dedfbb10] out_of_line_wait_on_bit at ffffffff8173ff81
>    #7 [ffff8813dedfbb90] __make_buffer_clean at ffffffffa038736f [dm_bufio]
>    #8 [ffff8813dedfbbb0] __try_evict_buffer at ffffffffa0387bb8 [dm_bufio]
>    #9 [ffff8813dedfbbd0] dm_bufio_shrink_scan at ffffffffa0387cc3 [dm_bufio]
>   #10 [ffff8813dedfbc40] shrink_slab at ffffffff811a87ce
>   #11 [ffff8813dedfbd30] shrink_zone at ffffffff811ad778
>   #12 [ffff8813dedfbdc0] kswapd at ffffffff811ae92f
>   #13 [ffff8813dedfbec0] kthread at ffffffff810a8428
>   #14 [ffff8813dedfbf50] ret_from_fork at ffffffff81745242
> 
>   PID: 14127  TASK: ffff881455749c00  CPU: 11  COMMAND: "loop1"
>    #0 [ffff88272f5af228] __schedule at ffffffff8173f405
>    #1 [ffff88272f5af280] schedule at ffffffff8173fa27
>    #2 [ffff88272f5af2a0] schedule_preempt_disabled at ffffffff8173fd5e
>    #3 [ffff88272f5af2b0] __mutex_lock_slowpath at ffffffff81741fb5
>    #4 [ffff88272f5af330] mutex_lock at ffffffff81742133
>    #5 [ffff88272f5af350] dm_bufio_shrink_count at ffffffffa03865f9 [dm_bufio]
>    #6 [ffff88272f5af380] shrink_slab at ffffffff811a86bd
>    #7 [ffff88272f5af470] shrink_zone at ffffffff811ad778
>    #8 [ffff88272f5af500] do_try_to_free_pages at ffffffff811adb34
>    #9 [ffff88272f5af590] try_to_free_pages at ffffffff811adef8
>   #10 [ffff88272f5af610] __alloc_pages_nodemask at ffffffff811a09c3
>   #11 [ffff88272f5af710] alloc_pages_current at ffffffff811e8b71
>   #12 [ffff88272f5af760] new_slab at ffffffff811f4523
>   #13 [ffff88272f5af7b0] __slab_alloc at ffffffff8173a1b5
>   #14 [ffff88272f5af880] kmem_cache_alloc at ffffffff811f484b
>   #15 [ffff88272f5af8d0] do_blockdev_direct_IO at ffffffff812535b3
>   #16 [ffff88272f5afb00] __blockdev_direct_IO at ffffffff81255dc3
>   #17 [ffff88272f5afb30] xfs_vm_direct_IO at ffffffffa01fe3fc [xfs]
>   #18 [ffff88272f5afb90] generic_file_read_iter at ffffffff81198994

Um, what kernel is this? XFS stopped using __blockdev_direct_IO some
time around 4.8 or 4.9, IIRC. Perhaps it would be best to reproduce
problems on a TOT kernel first?

And, FWIW, there's an argument to be made here that the underlying
bug is dm_bufio_shrink_scan() blocking kswapd by waiting on IO
completions while holding a mutex that other IO-level reclaim
contexts require to make progress.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
