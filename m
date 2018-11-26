Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pg1-f194.google.com ([209.85.215.194]:38779 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726253AbeK0E2i (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Nov 2018 23:28:38 -0500
Received: by mail-pg1-f194.google.com with SMTP id g189so6486557pgc.5
        for <linux-xfs@vger.kernel.org>; Mon, 26 Nov 2018 09:33:51 -0800 (PST)
Date: Mon, 26 Nov 2018 09:33:47 -0800
From: Omar Sandoval <osandov@osandov.com>
Subject: Re: [PATCH v3] xfs: cache minimum realtime summary level
Message-ID: <20181126173347.GB17512@vader>
References: <95c54025014c6d5d3944924b52637cdc2b50cf4e.1542137269.git.osandov@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <95c54025014c6d5d3944924b52637cdc2b50cf4e.1542137269.git.osandov@fb.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: kernel-team@fb.com

On Tue, Nov 13, 2018 at 11:28:59AM -0800, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
> 
> The realtime summary is a two-dimensional array on disk, effectively:
> 
> u32 rsum[log2(number of realtime extents) + 1][number of blocks in the bitmap]
> 
> rsum[log][bbno] is the number of extents of size 2**log which start in
> bitmap block bbno.
> 
> xfs_rtallocate_extent_near() uses xfs_rtany_summary() to check whether
> rsum[log][bbno] != 0 for any log level. However, the summary array is
> stored in row-major order (i.e., like an array in C), so all of these
> entries are not adjacent, but rather spread across the entire summary
> file. In the worst case (a full bitmap block), xfs_rtany_summary() has
> to check every level.
> 
> This means that on a moderately-used realtime device, an allocation will
> waste a lot of time finding, reading, and releasing buffers for the
> realtime summary. In particular, one of our storage services (which runs
> on servers with 8 very slow CPUs and 15 8 TB XFS realtime filesystems)
> spends almost 5% of its CPU cycles in xfs_rtbuf_get() and
> xfs_trans_brelse() called from xfs_rtany_summary().
> 
> One solution would be to also store the summary with the dimensions
> swapped. However, this would require a disk format change to a very old
> component of XFS.
> 
> Instead, we can cache the minimum size which contains any extents. We do
> so lazily; rather than guaranteeing that the cache contains the precise
> minimum, it always contains a loose lower bound which we tighten when we
> read or update a summary block. This only uses a few kilobytes of memory
> and is already serialized via the realtime bitmap and summary inode
> locks, so the cost is minimal. With this change, the same workload only
> spends 0.2% of its CPU cycles in the realtime allocator.
> 
> Signed-off-by: Omar Sandoval <osandov@fb.com>
> ---
> Based on Linus' master branch.
> 
> Changes from v2:
> - Allow the cache allocation to fail, in which case we just don't use it
> 
> Changes from v1:
> - Clarify comment in xfs_rtmount_inodes().
> - Use kmem_* instead of kvmalloc/kvfree
> 
>  fs/xfs/libxfs/xfs_rtbitmap.c |  6 ++++++
>  fs/xfs/xfs_mount.h           |  7 +++++++
>  fs/xfs/xfs_rtalloc.c         | 25 +++++++++++++++++++++----
>  3 files changed, 34 insertions(+), 4 deletions(-)

Ping.
