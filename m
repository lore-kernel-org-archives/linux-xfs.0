Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA1LSOJS055218 for <xfs@oss.sgi.com>; Thu, 1 Nov 2012 16:28:24 -0500
Date: Thu, 1 Nov 2012 16:30:10 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: Hang in XFS reclaim on 3.7.0-rc3
Message-ID: <20121101213010.GD9783@sgi.com>
References: <CAPVoSvSM9=hictqwT2rzZA-fU_XSwd-_FRzW_J+HQYj7iohTWQ@mail.gmail.com>
	<20121029222613.GU29378@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121029222613.GU29378@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Torsten Kaiser <just.for.lkml@googlemail.com>, xfs@oss.sgi.com

Hi Dave,

On Tue, Oct 30, 2012 at 09:26:13AM +1100, Dave Chinner wrote:
> On Mon, Oct 29, 2012 at 09:03:15PM +0100, Torsten Kaiser wrote:
> > After experiencing a hang of all IO yesterday (
> > http://marc.info/?l=linux-kernel&m=135142236520624&w=2 ), I turned on
> > LOCKDEP after upgrading to -rc3.
> > 
> > I then tried to replicate the load that hung yesterday and got the
> > following lockdep report, implicating XFS instead of by stacking swap
> > onto dm-crypt and md.
> > 
> > [ 2844.971913]
> > [ 2844.971920] =================================
> > [ 2844.971921] [ INFO: inconsistent lock state ]
> > [ 2844.971924] 3.7.0-rc3 #1 Not tainted
> > [ 2844.971925] ---------------------------------
> > [ 2844.971927] inconsistent {RECLAIM_FS-ON-W} -> {IN-RECLAIM_FS-W} usage.
> > [ 2844.971929] kswapd0/725 [HC0[0]:SC0[0]:HE1:SE1] takes:
> > [ 2844.971931] (&(&ip->i_lock)->mr_lock){++++?.}, at: [<ffffffff811e7ef4>] xfs_ilock+0x84/0xb0
> > [ 2844.971941] {RECLAIM_FS-ON-W} state was registered at:
> > [ 2844.971942]   [<ffffffff8108137e>] mark_held_locks+0x7e/0x130
> > [ 2844.971947]   [<ffffffff81081a63>] lockdep_trace_alloc+0x63/0xc0
> > [ 2844.971949]   [<ffffffff810e9dd5>] kmem_cache_alloc+0x35/0xe0
> > [ 2844.971952]   [<ffffffff810dba31>] vm_map_ram+0x271/0x770
> > [ 2844.971955]   [<ffffffff811e10a6>] _xfs_buf_map_pages+0x46/0xe0
> > [ 2844.971959]   [<ffffffff811e1fba>] xfs_buf_get_map+0x8a/0x130
> > [ 2844.971961]   [<ffffffff81233849>] xfs_trans_get_buf_map+0xa9/0xd0
> > [ 2844.971964]   [<ffffffff8121e339>] xfs_ifree_cluster+0x129/0x670
> > [ 2844.971967]   [<ffffffff8121f959>] xfs_ifree+0xe9/0xf0
> > [ 2844.971969]   [<ffffffff811f4abf>] xfs_inactive+0x2af/0x480
> > [ 2844.971972]   [<ffffffff811efb90>] xfs_fs_evict_inode+0x70/0x80
> > [ 2844.971974]   [<ffffffff8110cb8f>] evict+0xaf/0x1b0
> > [ 2844.971977]   [<ffffffff8110cd95>] iput+0x105/0x210
> > [ 2844.971979]   [<ffffffff811070d0>] dentry_iput+0xa0/0xe0
> > [ 2844.971981]   [<ffffffff81108310>] dput+0x150/0x280
> > [ 2844.971983]   [<ffffffff811020fb>] sys_renameat+0x21b/0x290
> > [ 2844.971986]   [<ffffffff81102186>] sys_rename+0x16/0x20
> > [ 2844.971988]   [<ffffffff816b2292>] system_call_fastpath+0x16/0x1b
> 
> We shouldn't be mapping pages there. See if the patch below fixes
> it.
> 
> Fundamentally, though, the lockdep warning has come about because
> vm_map_ram is doing a GFP_KERNEL allocation when we need it to be
> doing GFP_NOFS - we are within a transaction here, so memory reclaim
> is not allowed to recurse back into the filesystem.
> 
> mm-folk: can we please get this vmalloc/gfp_flags passing API
> fixed once and for all? This is the fourth time in the last month or
> so that I've seen XFS bug reports with silent hangs and associated
> lockdep output that implicate GFP_KERNEL allocations from vm_map_ram
> in GFP_NOFS conditions as the potential cause....
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
> xfs: don't vmap inode cluster buffers during free

Could you write up a little more background for the commit message?

Regards,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
