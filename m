Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 15 Jan 2007 15:48:20 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l0FNmBqw000467
	for <xfs@oss.sgi.com>; Mon, 15 Jan 2007 15:48:14 -0800
Date: Tue, 16 Jan 2007 10:47:10 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: Review: fix block reservation to work with per-cpu counters
Message-ID: <20070115234710.GI44411608@melbourne.sgi.com>
References: <45ABF2AA.2010209@bycast.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45ABF2AA.2010209@bycast.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Kevin Jamieson <kjamieson@bycast.com>
Cc: xfs@oss.sgi.com, chatz@sgi.com

On Mon, Jan 15, 2007 at 01:31:22PM -0800, Kevin Jamieson wrote:
> This fails to build on non-SMP systems:
> 
>  CC [M]  fs/xfs/xfs_fsops.o
> fs/xfs/xfs_fsops.c: In function 'xfs_fs_counts':
> fs/xfs/xfs_fsops.c:463: warning: implicit declaration of function 
> 'xfs_icsb_sync_counters_flags'
> fs/xfs/xfs_fsops.c:463: error: 'XFS_ICSB_LAZY_COUNT' undeclared (first use 
> in this function)
> fs/xfs/xfs_fsops.c:463: error: (Each undeclared identifier is reported only 
> once
> fs/xfs/xfs_fsops.c:463: error: for each function it appears in.)
> fs/xfs/xfs_fsops.c: In function 'xfs_reserve_blocks':
> fs/xfs/xfs_fsops.c:525: error: 'XFS_ICSB_SB_LOCKED' undeclared (first use 
> in this function)
> make[1]: *** [fs/xfs/xfs_fsops.o] Error 1
> make: *** [fs/xfs/xfs.ko] Error 2
> 
> 
> The define for not HAVE_PERCPU_SB needs to be changed:

Sorry about that - my fault. This fix looks good - I'll try to find some
time to check this in (I'm at LCA right now and have limited net
access).

Chatz, maybe you could check this in?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
