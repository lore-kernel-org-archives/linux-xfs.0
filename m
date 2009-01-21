Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n0L43jov012915 for <xfs@oss.sgi.com>; Tue, 20 Jan 2009 22:03:45 -0600
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 70EA7A4E9E
	for <xfs@oss.sgi.com>; Tue, 20 Jan 2009 20:03:43 -0800 (PST)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net
	[203.16.214.146]) by cuda.sgi.com with ESMTP id
	FxuK7GFakScLDC5P for <xfs@oss.sgi.com>;
	Tue, 20 Jan 2009 20:03:43 -0800 (PST)
Date: Wed, 21 Jan 2009 15:03:39 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Corrupted XFS log replay oops. (was Re: Warning and BUG with
	btrfs and corrupted image)
Message-ID: <20090121040339.GJ10158@disturbed>
References: <20090113142147.GE16333@alice>
	<1231857643.29164.28.camel@think.oraclecorp.com>
	<20090113144307.GF16333@alice> <20090118174035.GG1944@ucw.cz>
	<20090120063150.GC5854@alice> <20090120101119.GB10158@disturbed>
	<20090120101503.GC17377@alice> <20090120125944.GC10158@disturbed>
	<20090120173455.GC21339@alice> <20090121035703.GH10158@disturbed>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090121035703.GH10158@disturbed>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Eric Sesterhenn <snakebyte@gmx.de>, Pavel Machek <pavel@suse.cz>, Chris Mason <chris.mason@oracle.com>, linux-kernel@vger.kernel.org, nickpiggin@yahoo.com.au, xfs@oss.sgi.com

[really cc nick]

On Wed, Jan 21, 2009 at 02:57:03PM +1100, Dave Chinner wrote:
> [drop btrfs list from this thread]
> 
> On Tue, Jan 20, 2009 at 06:34:55PM +0100, Eric Sesterhenn wrote:
> > * Dave Chinner (david@fromorbit.com) wrote:
> > > Sure I am.  It would be good if you could start testing XFS along
> > > with all the other filesystems and report anything you find.
> > 
> > Ok, i wont report stuff with only xfs-internal backtraces from
> > xfs_error_report() or are they interesting to you?
> 
> If it catches the corruption and shuts down then that's a valid
> response to corruption. Mostly they are not interesting.
> 
> > This occurs during mount, box is dead afterwards
> > Image can be found here :
> > http://www.cccmz.de/~snakebyte/xfs.11.img.bz2
> > I see this every ~10 images, which makes further testing hard :)
> 
> For future bugs, can you start a new thread on xfs@oss.sgi.com
> for each report?
> 
> > [  235.250167] ------------[ cut here ]------------
> > [  235.250354] kernel BUG at mm/vmalloc.c:164!
> > [  235.250478] invalid opcode: 0000 [#1] PREEMPT DEBUG_PAGEALLOC
> > [  235.250869] last sysfs file: /sys/block/ram9/range
> > [  235.250998] Modules linked in:
> > [  235.251037] 
> > [  235.251037] Pid: 5352, comm: mount Not tainted
> > (2.6.29-rc2-00021-gd84d31c #216) System Name
> > [  235.251037] EIP: 0060:[<c0182af1>] EFLAGS: 00010246 CPU: 0
> > [  235.251037] EIP is at vmap_page_range+0x19/0x112
> > [  235.251037] EAX: d1000000 EBX: d1000000 ECX: 00000163 EDX: d1000000
> > [  235.251037] ESI: 00000003 EDI: d1000000 EBP: cbbd2c08 ESP: cbbd2be8
> > [  235.251037]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
> > [  235.251037] Process mount (pid: 5352, ti=cbbd2000 task=cbb85b00
> > task.ti=cbbd2000)
> > [  235.251037] Stack:
> > [  235.251037]  00000246 cbb85b00 00000163 c01414cf cbbd2c0c d1000000
> > 00000003 cba0f810
> > [  235.251037]  cbbd2c40 c018367c c848e280 00100000 00000000 c848e280
> > 00000000 00000014
> > [  235.251037]  d1000000 cba0f944 00000000 c848e160 00000000 c848e160
> > cbbd2c54 c03b2e1e
> > [  235.251037] Call Trace:
> > [  235.251037]  [<c01414cf>] ? trace_hardirqs_on+0xb/0xd
> > [  235.251037]  [<c018367c>] ? vm_map_ram+0x36e/0x38a
> > [  235.251037]  [<c03b2e1e>] ? _xfs_buf_map_pages+0x42/0x6d
> > [  235.251037]  [<c03b3773>] ? xfs_buf_get_noaddr+0xbc/0x11f
> > [  235.251037]  [<c03a2406>] ? xlog_get_bp+0x5a/0x5d
> > [  235.251037]  [<c03a28fa>] ? xlog_find_verify_log_record+0x26/0x208
> > [  235.251037]  [<c03a3521>] ? xlog_find_zeroed+0x1d6/0x214
> > [  235.251037]  [<c03a3584>] ? xlog_find_head+0x25/0x358
> .....
> 
> Ok, that's crashing in the new vmap code. It might take a couple
> of days before I get a chance to look at this, but I've cc'd Nick Piggin
> in case he has a chance to look at it before that. It's probably
> an XFS bug, anyway.
> 
> Cheers,
> 
> Dave.
> 
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
