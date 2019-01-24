Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmailnode02.adl6.internode.on.net ([150.101.137.148]:53879
        "EHLO ipmailnode02.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725962AbfAXXby (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Jan 2019 18:31:54 -0500
Date: Fri, 25 Jan 2019 10:31:32 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [Bug 202349] Extreme desktop freezes during sustained write
 operations with XFS
Message-ID: <20190124233132.GO4205@dastard>
References: <bug-202349-201763@https.bugzilla.kernel.org/>
 <bug-202349-201763-yYLhiFGsy4@https.bugzilla.kernel.org/>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bug-202349-201763-yYLhiFGsy4@https.bugzilla.kernel.org/>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: bugzilla-daemon@bugzilla.kernel.org
Cc: linux-xfs@vger.kernel.org

On Thu, Jan 24, 2019 at 11:59:44AM +0000, bugzilla-daemon@bugzilla.kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=202349
> 
> --- Comment #6 from nfxjfg@googlemail.com ---
> In all the information below, the test disk was /dev/sdd, and was mounted on
> /mnt/tmp1/.

Ok, so you are generating largely page cache memory pressure and
some dirty inodes.

.....

> When the system freezes, even the mouse pointer can stop moving. As you can see
> in the dmesg excerpt below, Xorg got blocked. The script was run from a
> terminal emulator running on the X session. I'm fairly sure nothing other than
> the test script accessed the test disk/filesystem. Sometimes the script blocks
> for a while without freezing the system.

OK, this explains why I'm not seeing any measurable stalls at all
when running similar page cache pressure workloads - no GPU creating
memory pressure and triggering direct reclaim. And from that
perspective, this looks more like a bug in the ttm memory pool
allocator, not an XFS problem.

Yes, XFS is doing memory reclaim and is doing IO during reclaim, but
that's because it's the only thing that has reclaimable objects in
memory (due to your workload). While this may be undesirable, it is
necessary to work around other deficiencies in the memory reclaim
infrastructure and, as such, it is not a bug. We are working to try
to avoid this problem, but we haven't found a solution yet. It won't
prevent the desktop freeze under memory shortage" problem from
occurring, though.

i.e. the reason your desktop freezes is that this allocation
here:

> [588653.596794]  do_try_to_free_pages+0xb6/0x350
> [588653.596798]  try_to_free_pages+0xce/0x1b0
> [588653.596802]  __alloc_pages_slowpath+0x33d/0xc80
> [588653.596808]  __alloc_pages_nodemask+0x23f/0x260
> [588653.596820]  ttm_pool_populate+0x25e/0x480 [ttm]
> [588653.596825]  ? kmalloc_large_node+0x37/0x60
> [588653.596828]  ? __kmalloc_node+0x20e/0x2b0
> [588653.596836]  ttm_populate_and_map_pages+0x24/0x250 [ttm]
> [588653.596845]  ttm_tt_populate.part.9+0x1b/0x60 [ttm]
> [588653.596853]  ttm_tt_bind+0x42/0x60 [ttm]
> [588653.596861]  ttm_bo_handle_move_mem+0x258/0x4e0 [ttm]
> [588653.596939]  ? amdgpu_bo_subtract_pin_size+0x50/0x50 [amdgpu]
> [588653.596947]  ttm_bo_validate+0xe7/0x110 [ttm]
> [588653.596951]  ? preempt_count_sub+0x43/0x50
> [588653.596954]  ? _raw_write_unlock+0x12/0x30
> [588653.596974]  ? drm_pci_agp_destroy+0x4d/0x50 [drm]
> [588653.596983]  ttm_bo_init_reserved+0x347/0x390 [ttm]
> [588653.597059]  amdgpu_bo_do_create+0x19c/0x420 [amdgpu]
> [588653.597136]  ? amdgpu_bo_subtract_pin_size+0x50/0x50 [amdgpu]
> [588653.597213]  amdgpu_bo_create+0x30/0x200 [amdgpu]
> [588653.597291]  amdgpu_gem_object_create+0x8b/0x110 [amdgpu]
> [588653.597404]  amdgpu_gem_create_ioctl+0x1d0/0x290 [amdgpu]
> [588653.597417]  ? preempt_count_sub+0x43/0x50
> [588653.597421]  ? _raw_spin_unlock+0x12/0x30
> [588653.597499]  ? amdgpu_gem_object_close+0x1c0/0x1c0 [amdgpu]
> [588653.597521]  drm_ioctl_kernel+0x7f/0xd0 [drm]
> [588653.597545]  drm_ioctl+0x1e4/0x380 [drm]
> [588653.597625]  ? amdgpu_gem_object_close+0x1c0/0x1c0 [amdgpu]
> [588653.597631]  ? tlb_finish_mmu+0x1f/0x30
> [588653.597637]  ? preempt_count_sub+0x43/0x50
> [588653.597712]  amdgpu_drm_ioctl+0x49/0x80 [amdgpu]
> [588653.597720]  do_vfs_ioctl+0x8d/0x5d0

is a GFP_USER allocation. That is:

#define GFP_USER        (__GFP_RECLAIM | __GFP_IO | __GFP_FS | __GFP_HARDWALL)

__GFP_RECLAIM means direct reclaim is allowed, as is reclaim via
kswapd.

__GFP_FS means "reclaim from filesystem caches is allowed".

__GFP_IO means that it's allowed to do IO during reclaim.

__GFP_HARDWALL means the allocation is limited to the current
cpuset memory policy.

Basically, the ttm infrastructure has said to the allocator that it
is ok to block for as long as it takes for you to do whatever you
need to do to reclaim enough memory for the required allocation.

Given that your workload is creating only filesystem memory
pressure, that means that's where reclaim is directed. And given
that the allocation says "blocking is fine" and "reclaim from
filesystems", it's no surprise that the GPU operations are getting
stuck behind filesytem reclaim.

> Device            r/s     w/s     rMB/s     wMB/s   rrqm/s   wrqm/s  %rrqm 
> %wrqm r_await w_await aqu-sz rareq-sz wareq-sz  svctm  %util
> sdd              0.80  162.20      0.00    159.67     0.00     0.00   0.00  
> 0.00 1161.50  933.72 130.70     4.00  1008.02   6.13 100.00

Yup, there's a second long wait for any specific read or write IO to
complete here.

GPU operations are interactive, so they really need to have bound
response times. Using "block until required memory is available"
operations guarantees that whenever the system gets low on memory,
desktop interactivity will go to shit.....

In the meantime, it might be worth checking if you have:

CONFIG_BLK_WBT=y
CONFIG_BLK_WBT_MQ=y

active in your kernel. The block layer writeback throttle should
minimise the impact of bulk data writeback IO on metadata writeback
and read IO latency and so help minimise long blocking times for
metadata IO.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
