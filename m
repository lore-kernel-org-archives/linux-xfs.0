Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4BF5B7F58
	for <xfs@oss.sgi.com>; Wed, 16 Apr 2014 17:08:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id EF39DAC002
	for <xfs@oss.sgi.com>; Wed, 16 Apr 2014 15:08:29 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	ifbLXK2rbAEcYBAx for <xfs@oss.sgi.com>;
	Wed, 16 Apr 2014 15:08:24 -0700 (PDT)
Date: Thu, 17 Apr 2014 08:08:08 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] xfs: Nuke XFS_ERROR macro
Message-ID: <20140416220807.GN15995@dastard>
References: <534EC073.8090006@sandeen.net> <534EC282.7010905@sandeen.net>
	<20140416175117.GA23643@infradead.org>
	<534EC42D.1080704@sandeen.net> <534ED5E4.60903@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <534ED5E4.60903@sandeen.net>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Christoph Hellwig <hch@infradead.org>, Steven Rostedt <rostedt@goodmis.org>, xfs-oss <xfs@oss.sgi.com>

[ cc the tracing expert ]

On Wed, Apr 16, 2014 at 02:11:32PM -0500, Eric Sandeen wrote:
> On 4/16/14, 12:55 PM, Eric Sandeen wrote:
> > On 4/16/14, 12:51 PM, Christoph Hellwig wrote:
> >> On Wed, Apr 16, 2014 at 12:48:50PM -0500, Eric Sandeen wrote:
> >>> XFS_ERROR was designed long ago to trap return values,
> >>> but it's not runtime configurable, it's not consistently used,
> >>> and we can do the same thing today with systemtap, using
> >>> something like:
> >>>
> >>> probe module("xfs").function("xfs_*").return { if (@defined($return) && $return == VALUE) { ... } }
> >>
> >> Gives me a version just using ftrace, or at least a kprobes based module
> >> that we can merged in the kernel tree and this would be fine for me.
> >>
> >> Requiring a massive blob of questionable out of tree module code and a
> >> compiler is an absolute no-go.
> > 
> > Ok, fair point.
> >  
> >> NAK for now.
> > 
> > Even if we don't have a replacement, I have yet to find anyone who has
> > ever used it...
> > 
> > Anyway, I'll look into options besides systemtap.
> 
> Here's the "best" I've come up with so far...
> 
> # for FUNCTION in `grep "t xfs_" /proc/kallsyms | awk '{print $3}'`; do echo "r:ret_$FUNCTION $FUNCTION \$retval" >> /sys/kernel/debug/tracing/kprobe_events; done
> 
> # for ENABLE in /sys/kernel/debug/tracing/events/kprobes/ret_xfs_*/enable; do echo 1 > $ENABLE; done
> 
> run a test that fails:
> 
> # dd if=/dev/zero of=newfile bs=513 oflag=direct
> dd: writing `newfile': Invalid argument
> 
> # for ENABLE in /sys/kernel/debug/tracing/events/kprobes/ret_xfs_*/enable; do echo 0 > $ENABLE; done
> 
> # cat /sys/kernel/debug/tracing/trace
> <snip>
>            <...>-63791 [000] d... 705435.568913: ret_xfs_vn_mknod: (xfs_vn_create+0x13/0x20 [xfs] <- xfs_vn_mknod) arg1=0
>            <...>-63791 [000] d... 705435.568913: ret_xfs_vn_create: (vfs_create+0xdb/0x100 <- xfs_vn_create) arg1=0
>            <...>-63791 [000] d... 705435.568918: ret_xfs_file_open: (do_dentry_open+0x24e/0x2e0 <- xfs_file_open) arg1=0
>            <...>-63791 [000] d... 705435.568934: ret_xfs_file_dio_aio_write: (xfs_file_aio_write+0x147/0x150 [xfs] <- xfs_file_dio_aio_write) arg1=ffffffffffffffea
> 
> Hey look, it's "-22" in hex!  ;)
> 
> so it's possible, but bleah.

Steve, we want to be able to trap specific return codes from
functions. Say, for example, the first function that returns
EINVAL/-EINVAL in XFS under a given workload.

What's the most efficient way to do that with ftrace?

And can that be set up as a trigger so we can use it to dump a
snapshot of the last N events into the trace buffer or do other
interesting things with that event?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
