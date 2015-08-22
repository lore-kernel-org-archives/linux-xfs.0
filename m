Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id CC6927FAD
	for <xfs@oss.sgi.com>; Fri, 21 Aug 2015 19:30:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9B72B8F804B
	for <xfs@oss.sgi.com>; Fri, 21 Aug 2015 17:30:30 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	nVDl8sd3uuf2y3sA for <xfs@oss.sgi.com>;
	Fri, 21 Aug 2015 17:30:27 -0700 (PDT)
Date: Sat, 22 Aug 2015 10:30:25 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH block/for-linus] writeback: fix syncing of I_DIRTY_TIME
	inodes
Message-ID: <20150822003025.GS3902@dastard>
References: <20150812101204.GE17933@dhcp-13-216.nay.redhat.com>
	<20150813004435.GN3902@dastard>
	<20150813224415.GG4496@mtj.duckdns.org>
	<20150814111408.GB8710@quack.suse.cz>
	<20150817200254.GG21075@mtj.duckdns.org>
	<20150818091603.GA12317@quack.suse.cz>
	<20150818174718.GA15739@mtj.duckdns.org>
	<20150818195439.GB15739@mtj.duckdns.org>
	<20150818215611.GD3902@dastard>
	<20150821102053.GL17933@dhcp-13-216.nay.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150821102053.GL17933@dhcp-13-216.nay.redhat.com>
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

On Fri, Aug 21, 2015 at 06:20:53PM +0800, Eryu Guan wrote:
> On Wed, Aug 19, 2015 at 07:56:11AM +1000, Dave Chinner wrote:
> > On Tue, Aug 18, 2015 at 12:54:39PM -0700, Tejun Heo wrote:
> [snip]
> > 
> > I'd suggest looking at some of the XFS tracepoints during the test:
> > 
> > tracepoint			trigger
> > xfs_file_buffered_write		once per write syscall
> > xfs_file_sync			once per fsync per inode
> > xfs_vm_writepage		every ->writepage call
> > xfs_setfilesize			every IO completion that updates inode size
> > 
> > And it's probably best to also include all the writeback
> > tracepoints, too, for context. That will tell you what inodes and
> > what part of them are getting written back and when....
> 
> I finally reproduced generic/048 with both xfs and writeback tracepoints
> enabled, please download the trace dat file and trace report file from
> 
> http://128.199.137.77/writeback/

OK, so only one inode the wrong size this time. The writeback
tracing is too verbose - it captures everything on the the backing
device so there's a huge amount of noise in the trace, and I can't
filter it easily because everything is recorded as "bdi 253:0" even
though we only want traces from "dev 253:6".

As such, there are lots of missing events in the trace again. We
do not need these writeback tracepoints:

	writeback_mark_inode_dirty
	writeback_dirty_inode_start
	writeback_dirty_inode
	writeback_dirty_page
	writeback_write_inode

And they are the ones causing most of the noise. This brings the
trace down from 7.1 million events to ~90,000 events and brings
the test behaviour right into focus. The inode that had the short
length:

    kworker/u8:1-1563  [002] 71028.844716: writeback_single_inode_start: bdi 253:0: ino=15688963 state=I_DIRTY_SYNC|I_DIRTY_DATASYNC|I_DIRTY_PAGES|I_SYNC dirtied_when=4356811543 age=18446744069352740 index=0 to_write=34816 wrote=0
    kworker/u8:1-1563  [002] 71028.844718: wbc_writepage:        bdi 253:0: towrt=34816 skip=0 mode=0 kupd=0 bgrd=0 reclm=0 cyclic=0 start=0x0 end=0x7fffffffffffffff
    kworker/u8:1-1563  [002] 71028.844740: xfs_writepage:        dev 253:6 ino 0xef6503 pgoff 0x0 size 0xa00000 offset 0 length 0 delalloc 1 unwritten 0
    kworker/u8:1-1563  [002] 71028.845740: wbc_writepage:        bdi 253:0: towrt=32257 skip=0 mode=0 kupd=0 bgrd=0 reclm=0 cyclic=0 start=0x0 end=0x7fffffffffffffff
    kworker/u8:1-1563  [002] 71028.845741: xfs_writepage:        dev 253:6 ino 0xef6503 pgoff 0x9ff000 size 0xa00000 offset 0 length 0 delalloc 1 unwritten 0
    kworker/u8:1-1563  [002] 71028.845788: writeback_single_inode: bdi 253:0: ino=15688963 state=I_SYNC dirtied_when=4356811543 age=18446744069352740 index=2559 to_write=34816 wrote=2560

And so we can see that writeback pushed all 2560 pages of the file
to disk.

However, because of all the noise, the xfs io completion events are
missing for this inode. I know that at least one of them occurred,
because their is this transaction in the log:

INODE: #regs: 3   ino: 0xef6503  flags: 0x5   dsize: 16
size 0x9ff000 nblocks 0xa00 extsize 0x0 nextents 0x1

It is, however, the last inode to be updated in the log before
the unmount record, and it is the only one that does not have a size
of 0xa00000 bytes. It has the right block count, but it it appears
that we haven't captured the final IO completion transaction. It was
most definitely not the last inode written by writeback; it was the
6th last, and that is ordered correctly given the file name was
"993", the 6th last file created by the test.

However, I see completions for the inode written before (0xef6502)
and after (0xef6504) but none for 0xef6503. Yet from the trace in
the log we know that at least one of them occurred, because there's
a transaction to say it happened.

As it is, there is an off-by-one in the page clustering mapping
check in XFS that is causing the last page of the inode to be issued
as a separate IO. That's not the cause of the problem however,
because we can see from the trace that the IO for the entire file
appears to be issued. What we don't see yet is what is happening on
the IO completion side, and hence why the sync code is not waiting
correctly for all the IO that was issued to be waited on properly.

Eryu, can you try again, this time manually specifying the writeback
tracepoints so you exclude the really noisy ones? You can also drop
the xfs_file_buffered_write and xfs_file_fsync tracepoints as well,
as we can see that the incoming side of the code is doing the right
thing....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
