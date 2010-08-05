Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o756PQDI069772 for <xfs@oss.sgi.com>; Thu, 5 Aug 2010 01:25:26 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B12F41BEF9E8
	for <xfs@oss.sgi.com>; Wed,  4 Aug 2010 23:25:45 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail15.adl6.internode.on.net
	[150.101.137.100]) by cuda.sgi.com with ESMTP id
	hmxEl1Ab8w1YSnZp for <xfs@oss.sgi.com>;
	Wed, 04 Aug 2010 23:25:45 -0700 (PDT)
Date: Thu, 5 Aug 2010 16:25:41 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS hung on 2.6.33.3 kernel
Message-ID: <20100805062541.GC26402@dastard>
References: <AANLkTilX3l8TbUztLStj_u9OqOZnBrsNQxmeV4DuBmYJ@mail.gmail.com>
	<20100718012033.GA18888@dastard>
	<AANLkTikEv75KRyRTs4awmG894NSKMnBkJNJPYsypMdWf@mail.gmail.com>
	<20100718235036.GC32635@dastard>
	<AANLkTi=EzePfBRdEFQo2BRtKy=464Ci6zPG=UyYJiwNp@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <AANLkTi=EzePfBRdEFQo2BRtKy=464Ci6zPG=UyYJiwNp@mail.gmail.com>
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
To: Ilia Mirkin <imirkin@alum.mit.edu>
Cc: xfs@oss.sgi.com

On Tue, Aug 03, 2010 at 06:30:36PM -0400, Ilia Mirkin wrote:
> On Sun, Jul 18, 2010 at 7:50 PM, Dave Chinner <david@fromorbit.com> wrote:
> > On Sat, Jul 17, 2010 at 09:35:33PM -0400, Ilia Mirkin wrote:
> >> On Sat, Jul 17, 2010 at 9:20 PM, Dave Chinner <david@fromorbit.com> wrote:
> >> > On Sat, Jul 17, 2010 at 12:01:11AM -0400, Ilia Mirkin wrote:
> >> > I can't find a thread that holds the XFS inode lock that everything
> >> > is waiting on. I think it is the ILOCK, but none of the threads in
> >> > this trace should be holding it where they are blocked. IOWs, the
> >> > output does not give me enough information to get to the root cause.
> >>
> >> In case this happens again, was there something more useful I could
> >> have collected? Should I have grabbed all task states?
> >
> > All the task states, including the running tasks, is probably a good
....
> > Though I suspect the only way to get to the bottom of it will
> > be to work out a reproducable test case....
> 
> I felt a little bothered by this issue, so I dug in a little further.
> I basically created a sample mysql, tar, and it seemed that having
> memory pressure helped, so I created an allocator as well.

[snip test case]

Nice work.

I think I see the problem, and it's not something that
can be easily fixed. The test-tar process is blocked in
xfs_ilock_map_shared() trying to get the ip->i_lock in exclusive
mode.

You have a couple of IO's waiting to complete in the xfsdatad's
waiting to get the ip->i_Ilock in exclusive mode in a non-blocking
fashiion:

schedule_timeout
schedule_timeout_uninterruptible
xfs_end_io
worker_thread
kthread
kernel_thread_helper

There are test-mysqld processes stuck doing page cache invalidation,
waiting for IO completion to occur (which can't occur because of the
above stuck IOs). These hold the ip->i_iolock in shared mode.

2882, 2887

io_schedule
sync_page
lock_page
invalidate_inode_pages2_range
generic_file_direct_write
xfs_write
xfs_file_aio_write
do_sync_write
vfs_write
sys_write

There's a couple of test-mysqld processes stuck on the
inode->i_mutex here:

2883, 2884, 2886, 2888, 2889, 2891

__mutex_lock_common
mutex_lock_nested
generic_file_llseek
vfs_llseek
sys_lseek

and here:

2890, 2892

__mutex_lock_common
mutex_lock_nested
xfs_write
xfs_file_aio_write
do_sync_write
vfs_write
sys_write

There's a test-mysqld process stuck waiting for either
the ip->i_iolock or ip->i_ilock in exclusive mode:

2885: xfs_write+0x2cc/0x793

rwsem_down_failed_common
rwsem_down_write_failed
call_rwsem_down_write_failed
xfs_ilock
xfs_write
xfs_file_aio_write
do_sync_write
vfs_write
sys_write

And then there is the test-tar process, which is blocked on the
ip->i_ilock trying to get it in _shared_ mode, holding the ip->i_iolock
in shared mode

2897

rwsem_down_failed_common
rwsem_down_read_failed
call_rwsem_down_read_failed
xfs_ilock
xfs_ilock_map_shared
xfs_iomap
__xfs_get_blocks
xfs_get_blocks
do_mpage_readpage
mpage_readpages
xfs_vm_readpages
__do_page_cache_readahead
ra_submit
ondemand_readahead
page_cache_sync_readahead
generic_file_aio_read
xfs_read
xfs_file_aio_read
do_sync_read
vfs_read
sys_read

And a sync process stuck waiting for io completion (no locks held)

xfs_ioend_wait
xfs_sync_inode_data
xfs_inode_ag_walk
xfs_inode_ag_iterator
xfs_sync_data
xfs_quiesce_data
xfs_fs_sync_fs
sync_quota_sb
__sync_filesystem
sync_filesystems
sys_sync

So in summary, we have:

 1) xfsdatad sleeping for a clock tick because it can't get the
   ip->i_lock(EXCL) without blocking
 2) 2882, 2887 waiting for IO completion, holding ip->i_iolock(SHARED)
   (blocked behind #1))
 3) 2885 waiting on an ip->i_iolock(EXCL), holding the i_mutex and
   blocked behind #2) and #5)
 4) 2883, 2884, 2886, 2888, 2889, 2891, 2890, 2892 waiting on
   i_mutex, blocked behind #3)
 5) 2897 doing buffered read, holding ip->i_iolock(SHARED),
  waiting on ip->i_lock(SHARED)

So, this leaves me with the question - what is holding the
ip->i_ilock()? Everything is blocked waiting for it and there are no
reported holders, either through stack trace analysis or from the
lockdep lock holder report.

I said this previously:

>> > I can't find a thread that holds the XFS inode lock that everything
>> > is waiting on. I think it is the ILOCK, but none of the threads in
>> > this trace should be holding it where they are blocked. IOWs, the
>> > output does not give me enough information to get to the root cause.

And my conclusion is the same from this analysis - I cannot see why
everything has stopped waiting on an ILOCK that nobody should hold
and lockdep is saying that nobody does actually hold.

I'm starting to suspect memory corruption or something similar that
is corrupting the inode lock state, but I don't hold much hope of
tracking down something like that if it takes hours to reproduce.

Ilia, while I try to think of the next step to take, can you try
a couple of things to see if the hang can be caused faster? Maybe
trying these different initial conditions:

	- use a smaller test file
	- allocate the file with worst case fragmentation by
	  writing it backwards in synchronous 4k blocks before
	  running the test
	- preallocating the test file with fallocate()

Also, it woul dbe interesting to find out if a newer kernel also
hangs in a similar manner, say 2.6.35?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
