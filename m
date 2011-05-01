Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p417wJGW163639 for <xfs@oss.sgi.com>; Sun, 1 May 2011 02:58:19 -0500
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E6B271571DB5
	for <xfs@oss.sgi.com>; Sun,  1 May 2011 01:01:52 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	O2tyFgjSjfAuIFWB for <xfs@oss.sgi.com>;
	Sun, 01 May 2011 01:01:52 -0700 (PDT)
Date: Sun, 1 May 2011 18:01:49 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: 2.6.39-rc4+: oom-killer busy killing tasks
Message-ID: <20110501080149.GD13542@dastard>
References: <alpine.DEB.2.01.1104242245090.18728@trent.utfs.org>
	<alpine.DEB.2.01.1104250015480.18728@trent.utfs.org>
	<20110427022655.GE12436@dastard>
	<alpine.DEB.2.01.1104270042510.18728@trent.utfs.org>
	<20110427102824.GI12436@dastard>
	<alpine.DEB.2.01.1104281008320.18728@trent.utfs.org>
	<20110428233751.GR12436@dastard>
	<alpine.DEB.2.01.1104291250480.18728@trent.utfs.org>
	<20110429201701.GA13166@x4.trippels.de>
	<alpine.DEB.2.01.1104291710340.18728@trent.utfs.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.01.1104291710340.18728@trent.utfs.org>
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
To: Christian Kujau <lists@nerdbynature.de>
Cc: minchan.kim@gmail.com, LKML <linux-kernel@vger.kernel.org>, Markus Trippelsdorf <markus@trippelsdorf.de>, xfs@oss.sgi.com

On Fri, Apr 29, 2011 at 05:17:53PM -0700, Christian Kujau wrote:
> On Fri, 29 Apr 2011 at 22:17, Markus Trippelsdorf wrote:
> > I could be the hrtimer bug again. Would you try to reproduce the issue
> > with this patch applied?
> > http://git.us.kernel.org/?p=linux/kernel/git/tip/linux-2.6-tip.git;a=commit;h=ce31332d3c77532d6ea97ddcb475a2b02dd358b4
> 
> With that patch applied, the OOm killer still kicks in, this time the OOM 
> messages were written to the syslog agian:
> 
>    http://nerdbynature.de/bits/2.6.39-rc4/oom/
>    (The -9 files are the current ones)
> 
> Also, this time xfs did not show up in the backtrace:
> 
> ssh invoked oom-killer: gfp_mask=0x44d0, order=2, oom_adj=0, oom_score_adj=0
> Call Trace:
> [c22bfae0] [c0009d30] show_stack+0x70/0x1bc (unreliable)
> [c22bfb20] [c009cd3c] T.545+0x74/0x1d0
> [c22bfb70] [c009cf6c] T.543+0xd4/0x2a0
> [c22bfbb0] [c009d3b4] out_of_memory+0x27c/0x360
> [c22bfc00] [c00a199c] __alloc_pages_nodemask+0x6f8/0x708
> [c22bfca0] [c00a19c8] __get_free_pages+0x1c/0x44
> [c22bfcb0] [c00d283c] __kmalloc_track_caller+0x1c0/0x1dc
> [c22bfcd0] [c036ff1c] __alloc_skb+0x74/0x140
> [c22bfd00] [c0369b08] sock_alloc_send_pskb+0x23c/0x37c
> [c22bfd70] [c03e8974] unix_stream_sendmsg+0x354/0x478
> [c22bfde0] [c0364118] sock_aio_write+0x170/0x180
> [c22bfe50] [c00d580c] do_sync_write+0xb8/0x144
> [c22bfef0] [c00d68d0] vfs_write+0x1b8/0x1c0
> [c22bff10] [c00d6a10] sys_write+0x58/0xc8
> [c22bff40] [c00127d4] ret_from_syscall+0x0/0x38
> --- Exception: c01 at 0x2044cc14

Doesn't need to have XFS in the stack trace - the inode cache is
consuming all of low memory.

Indeed, I wonder if that is the problem - this is a highmem
configuration where there is 450MB of highmem free, and very little
lowmem free which is considered "all unreclaimable". The lowmem
zone:

Apr 29 15:59:10 alice kernel: [ 3834.754358] DMA free:64704kB
min:3532kB low:4412kB high:5296kB active_anon:0kB inactive_anon:0kB
active_file:132kB inactive_file:168kB unevictable:0kB
isolated(anon):0kB isolated(file):0kB present:780288kB mlocked:0kB
dirty:0kB writeback:0kB mapped:8kB shmem:0kB
slab_reclaimable:639680kB slab_unreclaimable:41652kB
kernel_stack:1128kB pagetables:1788kB unstable:0kB bounce:0kB
writeback_tmp:0kB pages_scanned:516 all_unreclaimable? yes

I really don't know why the xfs inode cache is not being trimmed. I
really, really need to know if the XFS inode cache shrinker is
getting blocked or not running - do you have those sysrq-w traces
when near OOM I asked for a while back?

It may be that the zone reclaim is simply fubar because slab cache
reclaim is proportional to the number of pages scanned on the LRU.
With most of the cached pages in the highmem zone, the lowmem zone
scan only scanned 516 pages. I can't see it freeing many inodes
(there's >600,000 of them in memory) based on such a low page scan
number.

Maybe you should tweak /proc/sys/vm/vfs_cache_pressure to make it
reclaim vfs structures more rapidly. It might help, but I'm starting
to think that this problem is actually a VM zone reclaim balance
problem, not an XFS problem as such....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
