Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1AED37F67
	for <xfs@oss.sgi.com>; Thu, 20 Aug 2015 18:05:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0B2AB8F8065
	for <xfs@oss.sgi.com>; Thu, 20 Aug 2015 16:04:56 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	txrV8JAyTH0aZroj for <xfs@oss.sgi.com>;
	Thu, 20 Aug 2015 16:04:54 -0700 (PDT)
Date: Fri, 21 Aug 2015 09:04:51 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH block/for-linus] writeback: fix syncing of I_DIRTY_TIME
	inodes
Message-ID: <20150820230451.GT714@dastard>
References: <20150814111408.GB8710@quack.suse.cz>
	<20150817200254.GG21075@mtj.duckdns.org>
	<20150818091603.GA12317@quack.suse.cz>
	<20150818174718.GA15739@mtj.duckdns.org>
	<20150818195439.GB15739@mtj.duckdns.org>
	<20150818215611.GD3902@dastard>
	<20150820061224.GG17933@dhcp-13-216.nay.redhat.com>
	<20150820143626.GI17933@dhcp-13-216.nay.redhat.com>
	<20150820143735.GJ17933@dhcp-13-216.nay.redhat.com>
	<20150820165537.GA2044@mtj.duckdns.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150820165537.GA2044@mtj.duckdns.org>
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
To: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Jan Kara <jack@suse.cz>, Eryu Guan <eguan@redhat.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, axboe@fb.com, Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org, kernel-team@fb.com

On Thu, Aug 20, 2015 at 09:55:37AM -0700, Tejun Heo wrote:
> Hello, Eryu.  Thanks a lot for the trace.
> 
> So, this is from the end of the trace from the failed test.
> 
> ...
>     kworker/u8:1-1563  [002] 22016.987530: xfs_writepage:        dev 253:6 ino 0xef64fe pgoff 0x9ff000 size 0xa00000 offset 0 length 0 delalloc 1 unwritten 0
>      kworker/2:1-49    [002] 22017.373595: xfs_setfilesize:      dev 253:6 ino 0xef6504 isize 0xa00000 disize 0x0 offset 0x0 count 10481664
> ...
> 
> Maybe I'm misunderstanding the code but all xfs_writepage() calls are
> from unbound workqueues - the writeback workers - while
> xfs_setfilesize() are from bound workqueues, so I wondered why that
> was and looked at the code and the setsize functions are run off of a
> separate work item which is queued from the end_bio callback and I
> can't tell who would be waiting for them.  Dave, what am I missing?

xfs_setfilesize runs transactions, so it can't be run from IO
completion context as it needs to block (i.e. on log space or inode
locks). It also can't block log IO completion, nor metadata Io
completion, as only log IO completion can free log space, and the
inode lock might be waiting on metadata buffer IO completion (e.g.
during delayed allocation). Hence we have multiple IO completion
workqueues to keep these things separated and deadlock free. i.e.
they all get punted to a workqueue where they are then processed in
a context that can block safely.

>     kworker/u8:1-1563  [002] 22016.987530: xfs_writepage:        dev 253:6 ino 0xef64fe pgoff 0x9ff000 size 0xa00000 offset 0 length 0 delalloc 1 unwritten 0

There will be one of these per page that is submitted to XFS. There
won't be one per page, because XFS clusters writes itself. This
trace is telling us that the page at offset 0x9ff000 was submitted,
the in-memory size of the inode at this time is 0xa00000 (i.e. this
is the last dirty page in memory) and that the it is a delayed
allocation extent (i.e. hasn't been written before).

>      kworker/2:1-49    [002] 22017.373595: xfs_setfilesize:      dev 253:6 ino 0xef6504 isize 0xa00000 disize 0x0 offset 0x0 count 10481664

There will be one of these per IO completion that extents the inode
size. This one tells us the in-memory inode size is 0xa00000, the
current on-disk inode size is 0, and the IO being completed spans
the offsets 0 to 10481664 (0x9ff000). Which means it does not
include the page submitted by the above trace, and after the setsize
transaction, isize=0xa00000 and disize=0x9ff000.

Note that these two traces are from different inodes - you need to
match traces from "ino 0xef6504" with other traces from the same
inode.

Also, note that the trace is not complete - there are many, many
missing trace events in the output....

What is interesting from the trace is that all the file size updates
have this pattern:

    kworker/2:1-49    [002] 22017.377918: xfs_setfilesize:      dev 253:6 ino 0xef64fd isize 0xa00000 disize 0x0 offset 0x0 count 10481664
    kworker/2:1-49    [002] 22017.378438: xfs_setfilesize:	dev 253:6 ino 0xef64fd isize 0xa00000 disize 0x9ff000 offset 0x9ff000 count 4096

There are two IOs being done - one for everything but the last page,
and one for the last page. This is either a result of the writeback
context limiting the number of pages per writeback slice, or the
page clustering that XFS does in xfs_vm_writepage() not quite
getting everything right (maybe an off-by-one?).

However, this doesn't appear to be a contributing factor. The 9
files that have the wrong file size at the end of the test match up
exactly with the last 9 writepage submissions and IO completions;
they happen after all the IO completions occur for all the good
files.

This implies that the sync is either not submitting all the inodes
for IO correctly or it is not waiting for all the inodes it
submitted to be marked clean. We really need the writeback control
tracepoints in the output to determine exactly what the sync was
doing when it submitted these last inodes for writeback....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
