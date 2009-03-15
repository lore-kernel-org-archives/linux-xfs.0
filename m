Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2FMLBmE042296 for <xfs@oss.sgi.com>; Sun, 15 Mar 2009 17:21:31 -0500
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8B0781C448AE
	for <xfs@oss.sgi.com>; Sun, 15 Mar 2009 15:20:48 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net
	[203.16.214.145]) by cuda.sgi.com with ESMTP id
	mlO7bf1sMpNR8IfF for <xfs@oss.sgi.com>;
	Sun, 15 Mar 2009 15:20:48 -0700 (PDT)
Date: Mon, 16 Mar 2009 09:19:21 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS lock warning, 2.6.29-rc8
Message-ID: <20090315221921.GY26138@disturbed>
References: <200903151459.01320.denys@visp.net.lb>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <200903151459.01320.denys@visp.net.lb>
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
To: Denys Fedoryschenko <denys@visp.net.lb>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

[ changed cc to xfs@oss.sgi.com. linux-xfs@vger.kernel.org does not
exist. ]

On Sun, Mar 15, 2009 at 02:59:01PM +0200, Denys Fedoryschenko wrote:
> hi
> 
> Here is what i got suddently. But seems everything is working.
> If any other information required, please let me know.

Known issue.

> [39993.560234] the existing dependency chain (in reverse order) is:
> [39993.560236]
> [39993.560236] -> #1 (&mm->mmap_sem){----}:
> [39993.560240]        [<ffffffff8105b9fc>] __lock_acquire+0x12b0/0x161a
> [39993.560244]        [<ffffffff8105bdbb>] lock_acquire+0x55/0x71
> [39993.560247]        [<ffffffff813fc2a5>] down_read+0x34/0x41
> [39993.560252]        [<ffffffff813ffbfe>] do_page_fault+0x3fa/0x848
> [39993.560256]        [<ffffffff813fda2f>] page_fault+0x1f/0x30
> [39993.560258]        [<ffffffff8107e13d>] generic_file_aio_read+0x35f/0x5da
> [39993.560268]        [<ffffffff811650d8>] xfs_read+0x17d/0x1f5
> [39993.560272]        [<ffffffff81161646>] xfs_file_aio_read+0x5f/0x61
> [39993.560275]        [<ffffffff810a88ff>] do_sync_read+0xe7/0x12d
> [39993.560284]        [<ffffffff810a928c>] vfs_read+0xab/0x134
> [39993.560287]        [<ffffffff810a93d9>] sys_read+0x47/0x6f
> [39993.560289]        [<ffffffff8100c0db>] system_call_fastpath+0x16/0x1b
> [39993.560293]        [<ffffffffffffffff>] 0xffffffffffffffff
> [39993.560302]
> [39993.560302] -> #0 (&(&ip->i_iolock)->mr_lock){----}:
> [39993.560306]        [<ffffffff8105b6cb>] __lock_acquire+0xf7f/0x161a
> [39993.560309]        [<ffffffff8105bdbb>] lock_acquire+0x55/0x71
> [39993.560312]        [<ffffffff8104ebde>] down_write_nested+0x37/0x46
> [39993.560316]        [<ffffffff811426aa>] xfs_ilock+0x27/0x79
> [39993.560318]        [<ffffffff8115b40e>] xfs_inactive+0x14d/0x411
> [39993.560322]        [<ffffffff8116552f>] xfs_fs_clear_inode+0x83/0x85
> [39993.560325]        [<ffffffff810ba8f7>] clear_inode+0x8a/0xe3
> [39993.560329]        [<ffffffff810bb044>] generic_delete_inode+0xf8/0x173
> [39993.560332]        [<ffffffff810bb0d6>] generic_drop_inode+0x17/0x1d5
> [39993.560335]        [<ffffffff810ba1c7>] iput+0x61/0x65
> [39993.560338]        [<ffffffff810b7554>] dentry_iput+0xa9/0xc1
> [39993.560341]        [<ffffffff810b7651>] d_kill+0x40/0x60
> [39993.560344]        [<ffffffff810b942d>] dput+0x141/0x14e
> [39993.560347]        [<ffffffff810a9a85>] __fput+0x173/0x198
> [39993.560350]        [<ffffffff810a9ac2>] fput+0x18/0x1a
> [39993.560353]        [<ffffffff8109411e>] remove_vma+0x3e/0x63
> [39993.560355]        [<ffffffff8109503c>] do_munmap+0x2e9/0x30b
> [39993.560358]        [<ffffffff8109509e>] sys_munmap+0x40/0x59
> [39993.560361]        [<ffffffff8100c0db>] system_call_fastpath+0x16/0x1b
> [39993.560363]        [<ffffffffffffffff>] 0xffffffffffffffff

This is a VM problem where it calls fput() with the mmap_sem() held
in remove_vma(). It makes the incorrect assumption that filesystems
will never use the same lock in the IO path and the inode release path.

This can deadlock if you are really unlucky.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
