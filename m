Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A3C627F56
	for <xfs@oss.sgi.com>; Wed, 16 Apr 2014 19:40:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5CFD630408C
	for <xfs@oss.sgi.com>; Wed, 16 Apr 2014 17:40:06 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	wFnE8lDIjvjC1m1z for <xfs@oss.sgi.com>;
	Wed, 16 Apr 2014 17:40:00 -0700 (PDT)
Date: Thu, 17 Apr 2014 10:39:56 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] xfs: Nuke XFS_ERROR macro
Message-ID: <20140417003956.GS15995@dastard>
References: <534EC073.8090006@sandeen.net> <534EC282.7010905@sandeen.net>
	<20140416175117.GA23643@infradead.org>
	<534EC42D.1080704@sandeen.net> <534ED5E4.60903@sandeen.net>
	<20140416220807.GN15995@dastard>
	<20140416194444.50176f0f@gandalf.local.home>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140416194444.50176f0f@gandalf.local.home>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Christoph Hellwig <hch@infradead.org>, Eric Sandeen <sandeen@sandeen.net>, xfs-oss <xfs@oss.sgi.com>

On Wed, Apr 16, 2014 at 07:44:44PM -0400, Steven Rostedt wrote:
> On Thu, 17 Apr 2014 08:08:08 +1000
> Dave Chinner <david@fromorbit.com> wrote:
> =

>  =

> > > Here's the "best" I've come up with so far...
> > > =

> > > # for FUNCTION in `grep "t xfs_" /proc/kallsyms | awk '{print $3}'`; =
do echo "r:ret_$FUNCTION $FUNCTION \$retval" >> /sys/kernel/debug/tracing/k=
probe_events; done
> =

> BTW, it's usually better to do:
> =

> grep 't xfs_' /proc/kallsyms | awk '{print $3}' ; while read FUNCTION; do=
 ....

grep -i 't xfs' .....

> > > # for ENABLE in /sys/kernel/debug/tracing/events/kprobes/ret_xfs_*/en=
able; do echo 1 > $ENABLE; done
> > > =

> > > run a test that fails:
> > > =

> > > # dd if=3D/dev/zero of=3Dnewfile bs=3D513 oflag=3Ddirect
> > > dd: writing `newfile': Invalid argument
> > > =

> > > # for ENABLE in /sys/kernel/debug/tracing/events/kprobes/ret_xfs_*/en=
able; do echo 0 > $ENABLE; done
> > > =

> > > # cat /sys/kernel/debug/tracing/trace
> > > <snip>
> > >            <...>-63791 [000] d... 705435.568913: ret_xfs_vn_mknod: (x=
fs_vn_create+0x13/0x20 [xfs] <- xfs_vn_mknod) arg1=3D0
> > >            <...>-63791 [000] d... 705435.568913: ret_xfs_vn_create: (=
vfs_create+0xdb/0x100 <- xfs_vn_create) arg1=3D0
> > >            <...>-63791 [000] d... 705435.568918: ret_xfs_file_open: (=
do_dentry_open+0x24e/0x2e0 <- xfs_file_open) arg1=3D0
> > >            <...>-63791 [000] d... 705435.568934: ret_xfs_file_dio_aio=
_write: (xfs_file_aio_write+0x147/0x150 [xfs] <- xfs_file_dio_aio_write) ar=
g1=3Dffffffffffffffea
> > > =

> > > Hey look, it's "-22" in hex!  ;)
> > > =

> > > so it's possible, but bleah.
> > =

> > Steve, we want to be able to trap specific return codes from
> > functions. Say, for example, the first function that returns
> > EINVAL/-EINVAL in XFS under a given workload.
> > =

> > What's the most efficient way to do that with ftrace?
> > =

> > And can that be set up as a trigger so we can use it to dump a
> > snapshot of the last N events into the trace buffer or do other
> > interesting things with that event?
> =

> Well, after you do the above, you could also do a while loop to all
> those events and update the filter:
> =

> echo 'arg1 > 0xffffffffffffff00' > /debug/tracing/events/kprobes/filter
> =

> Which would trace only those functions that had an error code (assuming
> the error code is less than 256). You could also use the trigger files:
> =

> echo 'traceoff if arg1 > 0xffffffffffffff00' > /debug/tracing/events/kpro=
bes/*/trigger
> =

> The above wont actually work as is, you would need to do another while
> loop of trigger files and set them each individually.

so, basically a script that does:

#!/bin/bash

TRACEDIR=3D/sys/kernel/debug/tracing

grep -i 't xfs_' /proc/kallsyms | awk '{print $3}' ; while read F; do
	echo "r:ret_$F $F \$retval" >> $TRACEDIR/kprobe_events
done

for E in $TRACEDIR/events/kprobes/ret_xfs_*/enable; do
	echo 1 > $E
done;

echo 'arg1 > 0xffffffffffffff00' > $TRACEDIR/events/kprobes/filter

for T in $TRACEDIR/events/kprobes/ret_xfs_*/trigger; do
	echo 'traceoff if arg1 > 0xffffffffffffff00' > $T
done

And that gives:

# dd if=3D/dev/zero of=3D/mnt/scratch/newfile bs=3D513 oflag=3Ddirect
dd: error writing =BF/mnt/scratch/newfile=BF: Invalid argument
1+0 records in
0+0 records out
0 bytes (0 B) copied, 0.000259882 s, 0.0 kB/s
root@test4:~# cat /sys/kernel/debug/tracing/trace
# tracer: nop
#
# entries-in-buffer/entries-written: 1/1   #P:16
#
#                              _-----=3D> irqs-off
#                             / _----=3D> need-resched
#                            | / _---=3D> hardirq/softirq
#                            || / _--=3D> preempt-depth
#                            ||| /     delay
#           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
#              | |       |   ||||       |         |
           <...>-8073  [006] d... 145740.460546: ret_xfs_file_dio_aio_write=
: (xfs_file_aio_write+0x170/0x180 <- xfs_file_dio_aio_write) arg1=3D0xfffff=
fffffffffea

Which is precisely the detection that XFS_ERROR would have given us.
Ok, so I guess we can now add whatever need need to that trigger...

Basically, pass in teh XFs function names you want to trace, the
sets up teh events, whatever trigger beahviour you want, and
we're off to the races...

Cheers,

Dave.
-- =

Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
