Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 22 Jul 2007 15:37:23 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l6MMbHbm004401
	for <xfs@oss.sgi.com>; Sun, 22 Jul 2007 15:37:20 -0700
Date: Mon, 23 Jul 2007 08:37:11 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: XFS internal error when making hard link on full fs.
Message-ID: <20070722223707.GQ12413810@sgi.com>
References: <46A02551.8040409@adelphia.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46A02551.8040409@adelphia.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Michael Morrison <mliam@adelphia.net>
Cc: xfs@oss.sgi.com

On Thu, Jul 19, 2007 at 08:00:33PM -0700, Michael Morrison wrote:
> Got the following when I tried to make a hard link on a full filesystem:
> I'm running Linux kernel 2.6.18.  I'm  unable to try a newer kernel at
> the present time.
> The application was properly given ENOSPC in errno when the link call
> failed.

*nod*

That problem. If only I could reproduce it....

> Filesystem "md0": XFS internal error xfs_trans_cancel at line 1138 of
> file fs/xfs/xfs_trans.c.  Caller 0xc02d53a5
>  [<c02cb987>] xfs_trans_cancel+0x108/0x14f
>  [<c02d53a5>] xfs_link+0x40f/0x585
>  [<c02d53a5>] xfs_link+0x40f/0x585
>  [<c04937ab>] _spin_unlock+0xd/0x21
>  [<c02e19d5>] xfs_vn_link+0x64/0xd3
>  [<c0181b66>] mntput_no_expire+0x1c/0x75
>  [<c017de95>] __d_lookup+0x8f/0x13b
>  [<c016e2b2>] vfs_stat+0x1f/0x23
>  [<c0172788>] cached_lookup+0x23/0x85
>  [<c01725de>] permission+0x85/0xaa
>  [<c0175e24>] vfs_link+0xc7/0x183
>  [<c0176008>] sys_linkat+0x128/0x14a
>  [<c0176059>] sys_link+0x2f/0x33
>  [<c0102ecd>] sysenter_past_esp+0x56/0x79
> xfs_force_shutdown(md0,0x8) called from line 1139 of file
> fs/xfs/xfs_trans.c.  Return address = 0xc02cb9ad
> Filesystem "md0": Corruption of in-memory data detected.  Shutting down
> filesystem: md0
> Please umount the filesystem, and rectify the problem(s)

Yeah, it shut down due to cancelling a dirty transaction. Basically,
we've seen that we are at ENOSPC and tried to do a link without a
space reservation. We call xfs_dir_canenter() to determine if this
is possible or not. If it is possible, we then call xfs_dir_createname()
to create the entry. At that point, if we try to do an allocation we'll
get ENOSPC and the transaction will be dirty. It then gets cancelled and
we shutdown.

The problem is that for some reason we are needing to do an allocation
that the check function is not picking up. xfs_create() has a similar
problem and I haven't been able to get to the bottom of the problem
yet as no-one can reproduce this easily.

> Unmounting the fs and running xfs_check did not produce any output.  The
> filesystem seems happy after mounting it again.

That's normal - it's an in-core error and not something on disk.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
