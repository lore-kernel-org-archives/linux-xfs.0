Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 73DDB7FA3
	for <xfs@oss.sgi.com>; Tue, 10 Dec 2013 19:46:49 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 018ADAC011
	for <xfs@oss.sgi.com>; Tue, 10 Dec 2013 17:46:48 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	D0gjhEE90rxtuvE6 for <xfs@oss.sgi.com>;
	Tue, 10 Dec 2013 17:46:44 -0800 (PST)
Date: Wed, 11 Dec 2013 12:46:38 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Q: about xfs pre-allocation
Message-ID: <20131211014638.GG10988@dastard>
References: <52A75820.9090004@tlinx.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52A75820.9090004@tlinx.org>
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
To: LA Walsh <xfs@tlinx.org>
Cc: xfs-oss <xfs@oss.sgi.com>

On Tue, Dec 10, 2013 at 10:06:24AM -0800, LA Walsh wrote:
> 
> Could someone comment on my [mis-]understanding in regards to
> what the note below said that was posted by someone else
> to another list.  The pre-allocation behavior for XFS that the
> note describes doesn't jive w/what I thought happened and I
> was wondering if my brain was out of date or something (at
> least in regards to this topic! ;-)).  Names elided from
> Original Message, below for no great reason...

It's mostly wrong information.

Just a suggestion: take anything advice given about XFS on lists
other than this one with a grain of salt. There's lots of people out
there who *think* they know how XFS works, but there's very few who
actually know how XFS works.

> I thought file space pre-allocation ended when you closed the file??

In some cases, yes. In others, no. it depends on the workload and
what is optimal for minimising fragmentation for that workload.
If it wasn't removed, then oncthe file has been clean for 5 minutes
it gets removed by a background worker.

> But this note from the open-suse list indicates that, at least
> with ext2, a kernel thread removes this later.

ext2 does not use tail preallocationm, background kernel threads or
workqueues to do stuff in the background anymore. It uses
reservation windows to keep concurrent allocations apart. i.e. it
now uses the algorithm that the link talks about being designed for
ext3. :P

> I thought the FS-space allocator gave *preference* to having the
> next file start at least "filesize%('allocsize || 64K')" from
> the end of the previous, BUT, if needed it will allocate space
> from the end of the previous file (rounded to fs-blocksize) if
> space is really that tight.

It depends on the context. delayed allocation is where XFS does all
this stuff, and it is quite complex to get it to behave in a sane
manner.

> -------- Original Message --------
> 
> FFFF,
> 
> Modern filesystems use preallocation.
> 
> Per <http://ext2.sourceforge.net/2005-ols/paper-html/node6.html> ext2
> already had it by 2005.

Irix used tail preallocation like ext2 did with EFS back in the late
1980s. XFS improved on it in the 90s via delayed allocation, before
ext2 was even conceived. So using ext2 as an example of a filesystem
using tail preallaction when talking about what XFS does today is
kinda funny.... :P

> With XFS you can disable pre-allocation via the allocsize mount
> parameter.

Wrong. It only allows you to fix the pre-allocation size - it cannot
be turned off.

> (That parameter has been around many years. so yes 11.4
> has preallocation for XFS at a minimum and ext3/ext4 I think.)

It's probably been around longer than ext2....

> allocsize=size
> 
> Sets the buffered I/O end-of-file preallocation size when doing
> delayed allocation writeout (default size is 64KiB).

Wrong. The default behaviour is dynamic preallocation.

> Valid values for
> this option are page size (typically 4KiB) through to 1GiB, inclusive,
> in power-of-2 increments.
> 
> size = 0 disables preallocation and is probably smart on your
> distination backup disk.

No it doesn't - it's invalid.

# mount -o allocsize=0 /dev/vda /mnt/test
mount: wrong fs type, bad option, bad superblock on /dev/vda,
       missing codepage or helper program, or other error
       In some cases useful info is found in syslog - try
       dmesg | tail  or so
# dmesg |tail -3
[23843.767642] XFS (vda): Mounting Filesystem
[23843.835922] XFS (vda): Ending clean mount
[95648.513436] XFS (vda): invalid log iosize: 255 [not 12-30]
#

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
