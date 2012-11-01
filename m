Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA1MUigB058625 for <xfs@oss.sgi.com>; Thu, 1 Nov 2012 17:30:44 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	bThBwj8dZDtNCaHT for <xfs@oss.sgi.com>;
	Thu, 01 Nov 2012 15:32:35 -0700 (PDT)
Date: Fri, 2 Nov 2012 09:32:33 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Hang in XFS reclaim on 3.7.0-rc3
Message-ID: <20121101223233.GR29378@dastard>
References: <CAPVoSvSM9=hictqwT2rzZA-fU_XSwd-_FRzW_J+HQYj7iohTWQ@mail.gmail.com>
	<20121029222613.GU29378@dastard> <20121101213010.GD9783@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121101213010.GD9783@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Torsten Kaiser <just.for.lkml@googlemail.com>, xfs@oss.sgi.com

On Thu, Nov 01, 2012 at 04:30:10PM -0500, Ben Myers wrote:
> Hi Dave,
> 
> On Tue, Oct 30, 2012 at 09:26:13AM +1100, Dave Chinner wrote:
> > On Mon, Oct 29, 2012 at 09:03:15PM +0100, Torsten Kaiser wrote:
> > > After experiencing a hang of all IO yesterday (
> > > http://marc.info/?l=linux-kernel&m=135142236520624&w=2 ), I turned on
> > > LOCKDEP after upgrading to -rc3.
> > > 
> > > I then tried to replicate the load that hung yesterday and got the
> > > following lockdep report, implicating XFS instead of by stacking swap
> > > onto dm-crypt and md.
> > > 
> > > [ 2844.971913]
> > > [ 2844.971920] =================================
> > > [ 2844.971921] [ INFO: inconsistent lock state ]
> > > [ 2844.971924] 3.7.0-rc3 #1 Not tainted
> > > [ 2844.971925] ---------------------------------
> > > [ 2844.971927] inconsistent {RECLAIM_FS-ON-W} -> {IN-RECLAIM_FS-W} usage.
> > > [ 2844.971929] kswapd0/725 [HC0[0]:SC0[0]:HE1:SE1] takes:
> > > [ 2844.971931] (&(&ip->i_lock)->mr_lock){++++?.}, at: [<ffffffff811e7ef4>] xfs_ilock+0x84/0xb0
> > > [ 2844.971941] {RECLAIM_FS-ON-W} state was registered at:
> > > [ 2844.971942]   [<ffffffff8108137e>] mark_held_locks+0x7e/0x130
> > > [ 2844.971947]   [<ffffffff81081a63>] lockdep_trace_alloc+0x63/0xc0
> > > [ 2844.971949]   [<ffffffff810e9dd5>] kmem_cache_alloc+0x35/0xe0
> > > [ 2844.971952]   [<ffffffff810dba31>] vm_map_ram+0x271/0x770
> > > [ 2844.971955]   [<ffffffff811e10a6>] _xfs_buf_map_pages+0x46/0xe0
.....
> > We shouldn't be mapping pages there. See if the patch below fixes
> > it.
> > 
> > Fundamentally, though, the lockdep warning has come about because
> > vm_map_ram is doing a GFP_KERNEL allocation when we need it to be
> > doing GFP_NOFS - we are within a transaction here, so memory reclaim
> > is not allowed to recurse back into the filesystem.
> > 
> > mm-folk: can we please get this vmalloc/gfp_flags passing API
> > fixed once and for all? This is the fourth time in the last month or
> > so that I've seen XFS bug reports with silent hangs and associated
> > lockdep output that implicate GFP_KERNEL allocations from vm_map_ram
> > in GFP_NOFS conditions as the potential cause....
> > 
> > xfs: don't vmap inode cluster buffers during free
> 
> Could you write up a little more background for the commit message?

Sure, that was just a test patch and often I don't bother putting a
detailed description in them until I know they fix the problem. My
current tree has:

xfs: don't vmap inode cluster buffers during free

Inode buffers do not need to be mapped as inodes are read or written
directly from/to the pages underlying the buffer. This fixes a
regression introduced by commit 611c994 ("xfs: make XBF_MAPPED the
default behaviour").

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
