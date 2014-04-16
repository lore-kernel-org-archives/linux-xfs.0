Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 890E27F55
	for <xfs@oss.sgi.com>; Wed, 16 Apr 2014 18:44:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 04E44AC002
	for <xfs@oss.sgi.com>; Wed, 16 Apr 2014 16:44:47 -0700 (PDT)
Received: from cdptpa-oedge-vip.email.rr.com
	(cdptpa-outbound-snat.email.rr.com [107.14.166.232]) by
	cuda.sgi.com with ESMTP id VWYxpqJt2YhJtyv1 for
	<xfs@oss.sgi.com>; Wed, 16 Apr 2014 16:44:46 -0700 (PDT)
Date: Wed, 16 Apr 2014 19:44:44 -0400
From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 2/2] xfs: Nuke XFS_ERROR macro
Message-ID: <20140416194444.50176f0f@gandalf.local.home>
In-Reply-To: <20140416220807.GN15995@dastard>
References: <534EC073.8090006@sandeen.net> <534EC282.7010905@sandeen.net>
	<20140416175117.GA23643@infradead.org>
	<534EC42D.1080704@sandeen.net> <534ED5E4.60903@sandeen.net>
	<20140416220807.GN15995@dastard>
MIME-Version: 1.0
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
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, Eric Sandeen <sandeen@sandeen.net>, xfs-oss <xfs@oss.sgi.com>

On Thu, 17 Apr 2014 08:08:08 +1000
Dave Chinner <david@fromorbit.com> wrote:

 
> > Here's the "best" I've come up with so far...
> > 
> > # for FUNCTION in `grep "t xfs_" /proc/kallsyms | awk '{print $3}'`; do echo "r:ret_$FUNCTION $FUNCTION \$retval" >> /sys/kernel/debug/tracing/kprobe_events; done

BTW, it's usually better to do:

grep 't xfs_' /proc/kallsyms | awk '{print $3}' ; while read FUNCTION; do ....

> > 
> > # for ENABLE in /sys/kernel/debug/tracing/events/kprobes/ret_xfs_*/enable; do echo 1 > $ENABLE; done
> > 
> > run a test that fails:
> > 
> > # dd if=/dev/zero of=newfile bs=513 oflag=direct
> > dd: writing `newfile': Invalid argument
> > 
> > # for ENABLE in /sys/kernel/debug/tracing/events/kprobes/ret_xfs_*/enable; do echo 0 > $ENABLE; done
> > 
> > # cat /sys/kernel/debug/tracing/trace
> > <snip>
> >            <...>-63791 [000] d... 705435.568913: ret_xfs_vn_mknod: (xfs_vn_create+0x13/0x20 [xfs] <- xfs_vn_mknod) arg1=0
> >            <...>-63791 [000] d... 705435.568913: ret_xfs_vn_create: (vfs_create+0xdb/0x100 <- xfs_vn_create) arg1=0
> >            <...>-63791 [000] d... 705435.568918: ret_xfs_file_open: (do_dentry_open+0x24e/0x2e0 <- xfs_file_open) arg1=0
> >            <...>-63791 [000] d... 705435.568934: ret_xfs_file_dio_aio_write: (xfs_file_aio_write+0x147/0x150 [xfs] <- xfs_file_dio_aio_write) arg1=ffffffffffffffea
> > 
> > Hey look, it's "-22" in hex!  ;)
> > 
> > so it's possible, but bleah.
> 
> Steve, we want to be able to trap specific return codes from
> functions. Say, for example, the first function that returns
> EINVAL/-EINVAL in XFS under a given workload.
> 
> What's the most efficient way to do that with ftrace?
> 
> And can that be set up as a trigger so we can use it to dump a
> snapshot of the last N events into the trace buffer or do other
> interesting things with that event?

Well, after you do the above, you could also do a while loop to all
those events and update the filter:

echo 'arg1 > 0xffffffffffffff00' > /debug/tracing/events/kprobes/filter

Which would trace only those functions that had an error code (assuming
the error code is less than 256). You could also use the trigger files:

echo 'traceoff if arg1 > 0xffffffffffffff00' > /debug/tracing/events/kprobes/*/trigger

The above wont actually work as is, you would need to do another while
loop of trigger files and set them each individually.

-- Steve



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
