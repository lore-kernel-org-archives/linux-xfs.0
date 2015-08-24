Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E17517F37
	for <xfs@oss.sgi.com>; Mon, 24 Aug 2015 01:24:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C214C304032
	for <xfs@oss.sgi.com>; Sun, 23 Aug 2015 23:24:31 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	FHLrsWJMmGD4dzAJ for <xfs@oss.sgi.com>;
	Sun, 23 Aug 2015 23:24:28 -0700 (PDT)
Date: Mon, 24 Aug 2015 16:24:25 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH block/for-linus] writeback: fix syncing of I_DIRTY_TIME
	inodes
Message-ID: <20150824062425.GU3902@dastard>
References: <20150817200254.GG21075@mtj.duckdns.org>
	<20150818091603.GA12317@quack.suse.cz>
	<20150818174718.GA15739@mtj.duckdns.org>
	<20150818195439.GB15739@mtj.duckdns.org>
	<20150818215611.GD3902@dastard>
	<20150821102053.GL17933@dhcp-13-216.nay.redhat.com>
	<20150822003025.GS3902@dastard>
	<20150822044609.GM17933@dhcp-13-216.nay.redhat.com>
	<20150824011123.GA714@dastard>
	<20150824031816.GO17933@dhcp-13-216.nay.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150824031816.GO17933@dhcp-13-216.nay.redhat.com>
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
To: Eryu Guan <eguan@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, axboe@fb.com, linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.com>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com

On Mon, Aug 24, 2015 at 11:18:16AM +0800, Eryu Guan wrote:
> On Mon, Aug 24, 2015 at 11:11:23AM +1000, Dave Chinner wrote:
> > 
> > Eryu, can you change the way you run the event trace to be:
> > 
> > $ sudo trace-cmd <options> -o <outfile location> ./check <test options>
> > 
> > rather than running the trace as a background operation elsewhere?
> > Maybe that will give better results.
> 
> The results are here
> 
> http://128.199.137.77/writeback-v3/

OK, the trace is still missing a few events, but it's much more
complete, and contains the events that tell more of the story:

$ ls -li /mnt/scr
total 51196
15688955 -rw------- 1 root root 10481664 Aug 24 13:06 985
15688959 -rw------- 1 root root        0 Aug 24 13:06 989
15688961 -rw------- 1 root root        0 Aug 24 13:06 991
15688964 -rw------- 1 root root        0 Aug 24 13:06 994
15688966 -rw------- 1 root root        0 Aug 24 13:06 996
$


     Inode #              Size        block count      flushiter
   dec      hex       inode     log    inode   log      inode  log
15688955  0xef64fb  0x9ff000  0x9ff000 0x9ff  0xa00      1      0
15688959  0xef64ff      0        0     0xa00  0xa00      0      0
15688961  0xef6501      0        0     0xa00  0xa00      0      0
15688964  0xef6504      0        0     0xa00  0xa00      0      0
15688966  0xef6506      0        0     0xa00  0xa00      0      0


Ok, that tallies with the previous symptoms. However, the trace
tells us something different. the xfs_setfilesize events. here's the
last 12 xfs_setfilesize events delivered in the trace (trimmed for
brevity and focus):

ino 0xef64fa isize 0xa00000 disize 0x0 offset 0x0 count 10481664
ino 0xef64fa isize 0xa00000 disize 0x9ff000 offset 0x9ff000 count 409
ino 0xef64fb isize 0xa00000 disize 0x0 offset 0x0 count 10481664
ino 0xef64fb isize 0xa00000 disize 0x9ff000 offset 0x9ff000 count 4096
ino 0xef64ff isize 0xa00000 disize 0x0 offset 0x0 count 10481664
ino 0xef64ff isize 0xa00000 disize 0x9ff000 offset 0x9ff000 count 4096
ino 0xef6501 isize 0xa00000 disize 0x0 offset 0x0 count 10481664
ino 0xef6501 isize 0xa00000 disize 0x9ff000 offset 0x9ff000 count 4096
ino 0xef6504 isize 0xa00000 disize 0x0 offset 0x0 count 10481664
ino 0xef6504 isize 0xa00000 disize 0x9ff000 offset 0x9ff000 count 4096
ino 0xef6506 isize 0xa00000 disize 0x0 offset 0x0 count 10481664
ino 0xef6506 isize 0xa00000 disize 0x9ff000 offset 0x9ff000 count 4096

Yeah, the last 9 transactions corresponding to these events are not
in the log.  Which means, most likely, that they occurred after
->sync_fs forced the log out. THe next thing that happens is the fs
is shut down, and that's preventing the dirty log from being written
to disk.

Eryu, this can be confirmed by add the xfs_log_force event to the
trace.

What I can't see in the traces is where sync is doing a blocking
sync pass on the fileystem. The wbc control structure being passed
to XFS is:

wbc_writepage:        bdi 253:0: towrt=45569 skip=0 mode=0 kupd=0 bgrd=0 reclm=0 cyclic=0 start=0x0 end=0x7fffffffffffffff

Which is not coming from sync_inodes_sb() as the sync mode is
incorrect (i.e. not WB_SYNC_ALL). It looks to me that writeback is
coming from a generic bdi flusher command rather than a directed
superblock sync. i.e. through wakeup_flusher_threads() which sets:

        work->sync_mode = WB_SYNC_NONE;
        work->nr_pages  = nr_pages;
        work->range_cyclic = range_cyclic;
        work->reason    = reason;
        work->auto_free = 1;

as the reason is "sync":

            sync-18849  writeback_queue:      bdi 253:0: sb_dev 0:0 nr_pages=308986 sync_mode=0 kupdate=0 range_cyclic=0 background=0 reason=sync
            sync-18849  writeback_queue:      bdi 253:0: sb_dev 253:1 nr_pages=9223372036854775807 sync_mode=1 kupdate=0 range_cyclic=0 background=0 reason=sync
....
    kworker/u8:1-1563   writeback_exec:       bdi 253:0: sb_dev 0:0 nr_pages=308986 sync_mode=0 kupdate=0 range_cyclic=0 background=0 reason=sync
    kworker/u8:1-1563   writeback_start:      bdi 253:0: sb_dev 0:0 nr_pages=308986 sync_mode=0 kupdate=0 range_cyclic=0 background=0 reason=sync

The next writeback_queue/writeback_exec tracepoint pair are:

....
     kworker/2:1-17163  xfs_setfilesize:      dev 253:6 ino 0xef6506 isize 0xa00000 disize 0x0 offset 0x0 count 10481664
     kworker/2:1-17163  xfs_setfilesize:      dev 253:6 ino 0xef6506 isize 0xa00000 disize 0x9ff000 offset 0x9ff000 count 4096
            sync-18849  wbc_writepage:        bdi 253:0: towrt=9223372036854775798 skip=0 mode=1 kupd=0 bgrd=0 reclm=0 cyclic=0 start=0x0 end=0x7fffffffffffffff
            sync-18849  wbc_writepage:        bdi 253:0: towrt=9223372036854775797 skip=0 mode=1 kupd=0 bgrd=0 reclm=0 cyclic=0 start=0x0 end=0x7fffffffffffffff
            sync-18849  wbc_writepage:        bdi 253:0: towrt=9223372036854775796 skip=0 mode=1 kupd=0 bgrd=0 reclm=0 cyclic=0 start=0x0 end=0x7fffffffffffffff
            sync-18849  wbc_writepage:        bdi 253:0: towrt=9223372036854775795 skip=0 mode=1 kupd=0 bgrd=0 reclm=0 cyclic=0 start=0x0 end=0x7fffffffffffffff
          umount-18852  writeback_queue:      bdi 253:0: sb_dev 253:6 nr_pages=22059 sync_mode=0 kupdate=0 range_cyclic=0 background=0 reason=sync
    kworker/u8:1-1563   writeback_exec:       bdi 253:0: sb_dev 253:6 nr_pages=22059 sync_mode=0 kupdate=0 range_cyclic=0 background=0 reason=sync
....

which shows unmount being the next writeback event queued and
executed after the IO completions have come in (that missed the
log). What is missing is the specific queue/exec events for
sync_sb_inodes() from the sync code for each filesystem.

Anyway, Eryum long and short of it is that you don't need to worry
about testing all the different combinations - we now know that the
completion events are occurring, so let's focus on whether the sync
code is not waiting for them correctly. Can you trace the following
events:

	xfs_log_force
	xfs_setfilesize
	writeback_queue
	writeback_exec
	writeback_start
	writeback_queue_io
	writeback_written
	writeback_pages_written

basically I'm trying to see if we've got all the BDI events as we'd
expect then to be queued and run for sync, and when the ->sync_fs
call occurs during the sync process before shutdown and unmount...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
