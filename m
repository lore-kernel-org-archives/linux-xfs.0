Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B33A87F37
	for <xfs@oss.sgi.com>; Mon, 24 Aug 2015 04:20:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9228C304032
	for <xfs@oss.sgi.com>; Mon, 24 Aug 2015 02:20:07 -0700 (PDT)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) by cuda.sgi.com with
	ESMTP id SiXnEEj1urlZqP0G (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 24 Aug 2015 02:20:04 -0700 (PDT)
Date: Mon, 24 Aug 2015 11:19:59 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH block/for-linus] writeback: fix syncing of I_DIRTY_TIME
	inodes
Message-ID: <20150824091959.GA2936@quack.suse.cz>
References: <20150818091603.GA12317@quack.suse.cz>
	<20150818174718.GA15739@mtj.duckdns.org>
	<20150818195439.GB15739@mtj.duckdns.org>
	<20150818215611.GD3902@dastard>
	<20150821102053.GL17933@dhcp-13-216.nay.redhat.com>
	<20150822003025.GS3902@dastard>
	<20150822044609.GM17933@dhcp-13-216.nay.redhat.com>
	<20150824011123.GA714@dastard>
	<20150824031816.GO17933@dhcp-13-216.nay.redhat.com>
	<20150824062425.GU3902@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150824062425.GU3902@dastard>
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
Cc: Jens Axboe <axboe@kernel.dk>, Jan Kara <jack@suse.cz>, Eryu Guan <eguan@redhat.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, axboe@fb.com, linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.com>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com

On Mon 24-08-15 16:24:25, Dave Chinner wrote:
> On Mon, Aug 24, 2015 at 11:18:16AM +0800, Eryu Guan wrote:
> > On Mon, Aug 24, 2015 at 11:11:23AM +1000, Dave Chinner wrote:
> > > 
> > > Eryu, can you change the way you run the event trace to be:
> > > 
> > > $ sudo trace-cmd <options> -o <outfile location> ./check <test options>
> > > 
> > > rather than running the trace as a background operation elsewhere?
> > > Maybe that will give better results.
> > 
> > The results are here
> > 
> > http://128.199.137.77/writeback-v3/

<snip>

> What I can't see in the traces is where sync is doing a blocking
> sync pass on the fileystem. The wbc control structure being passed
> to XFS is:
> 
> wbc_writepage:        bdi 253:0: towrt=45569 skip=0 mode=0 kupd=0 bgrd=0 reclm=0 cyclic=0 start=0x0 end=0x7fffffffffffffff
> 
> Which is not coming from sync_inodes_sb() as the sync mode is
> incorrect (i.e. not WB_SYNC_ALL). It looks to me that writeback is
> coming from a generic bdi flusher command rather than a directed
> superblock sync. i.e. through wakeup_flusher_threads() which sets:
> 
>         work->sync_mode = WB_SYNC_NONE;
>         work->nr_pages  = nr_pages;
>         work->range_cyclic = range_cyclic;
>         work->reason    = reason;
>         work->auto_free = 1;
> 
> as the reason is "sync":
> 
>             sync-18849  writeback_queue:      bdi 253:0: sb_dev 0:0 nr_pages=308986 sync_mode=0 kupdate=0 range_cyclic=0 background=0 reason=sync
>             sync-18849  writeback_queue:      bdi 253:0: sb_dev 253:1 nr_pages=9223372036854775807 sync_mode=1 kupdate=0 range_cyclic=0 background=0 reason=sync
> ....
>     kworker/u8:1-1563   writeback_exec:       bdi 253:0: sb_dev 0:0 nr_pages=308986 sync_mode=0 kupdate=0 range_cyclic=0 background=0 reason=sync
>     kworker/u8:1-1563   writeback_start:      bdi 253:0: sb_dev 0:0 nr_pages=308986 sync_mode=0 kupdate=0 range_cyclic=0 background=0 reason=sync
> 
> The next writeback_queue/writeback_exec tracepoint pair are:
> 
> ....
>      kworker/2:1-17163  xfs_setfilesize:      dev 253:6 ino 0xef6506 isize 0xa00000 disize 0x0 offset 0x0 count 10481664
>      kworker/2:1-17163  xfs_setfilesize:      dev 253:6 ino 0xef6506 isize 0xa00000 disize 0x9ff000 offset 0x9ff000 count 4096
>             sync-18849  wbc_writepage:        bdi 253:0: towrt=9223372036854775798 skip=0 mode=1 kupd=0 bgrd=0 reclm=0 cyclic=0 start=0x0 end=0x7fffffffffffffff
>             sync-18849  wbc_writepage:        bdi 253:0: towrt=9223372036854775797 skip=0 mode=1 kupd=0 bgrd=0 reclm=0 cyclic=0 start=0x0 end=0x7fffffffffffffff
>             sync-18849  wbc_writepage:        bdi 253:0: towrt=9223372036854775796 skip=0 mode=1 kupd=0 bgrd=0 reclm=0 cyclic=0 start=0x0 end=0x7fffffffffffffff
>             sync-18849  wbc_writepage:        bdi 253:0: towrt=9223372036854775795 skip=0 mode=1 kupd=0 bgrd=0 reclm=0 cyclic=0 start=0x0 end=0x7fffffffffffffff
>           umount-18852  writeback_queue:      bdi 253:0: sb_dev 253:6 nr_pages=22059 sync_mode=0 kupdate=0 range_cyclic=0 background=0 reason=sync
>     kworker/u8:1-1563   writeback_exec:       bdi 253:0: sb_dev 253:6 nr_pages=22059 sync_mode=0 kupdate=0 range_cyclic=0 background=0 reason=sync
> ....
> 
> which shows unmount being the next writeback event queued and
> executed after the IO completions have come in (that missed the
> log). What is missing is the specific queue/exec events for
> sync_sb_inodes() from the sync code for each filesystem.

Bah, I see the problem and indeed it was introduced by commit e79729123f639
"writeback: don't issue wb_writeback_work if clean". The problem is that
we bail out of sync_inodes_sb() if there is no dirty IO. Which is wrong
because we have to wait for any outstanding IO (i.e. call wait_sb_inodes())
regardless of dirty state! And that also explains why Tejun's patch fixes
the problem because it backs out the change to the exit condition in
sync_inodes_sb().

So Tejun's patch from this thread is indeed fixing the real problem but the
comment in sync_inodes_sb() should be fixed to mention wait_sb_inodes()
must be called in all cases... Tejun, will you fixup the comment please?

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
