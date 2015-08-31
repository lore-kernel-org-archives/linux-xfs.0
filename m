Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C5C8729DF5
	for <xfs@oss.sgi.com>; Mon, 31 Aug 2015 07:40:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4E8EAAC005
	for <xfs@oss.sgi.com>; Mon, 31 Aug 2015 05:40:08 -0700 (PDT)
Received: from cobra.newdream.net (cobra.newdream.net [66.33.216.30]) by
	cuda.sgi.com with ESMTP id xCepLHiZrlan7CRa for
	<xfs@oss.sgi.com>; Mon, 31 Aug 2015 05:40:04 -0700 (PDT)
Date: Mon, 31 Aug 2015 05:40:04 -0700 (PDT)
From: Sage Weil <sage@newdream.net>
Subject: Re: [PATCH V2] xfs: timestamp updates cause excessive fdatasync log
	traffic
In-Reply-To: <20150831084814.GG26895@dastard>
Message-ID: <alpine.DEB.2.00.1508310529170.13116@cobra.newdream.net>
References: <1440724990-25073-1-git-send-email-david@fromorbit.com>
	<20150828043253.GB26895@dastard>
	<alpine.DEB.2.00.1508280804040.13116@cobra.newdream.net>
	<20150828220454.GC26895@dastard> <20150831022155.GE26895@dastard>
	<20150831084814.GG26895@dastard>
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
Cc: xfs@oss.sgi.com

On Mon, 31 Aug 2015, Dave Chinner wrote:
> On Mon, Aug 31, 2015 at 12:21:55PM +1000, Dave Chinner wrote:
> > On Sat, Aug 29, 2015 at 08:04:54AM +1000, Dave Chinner wrote:
> > > On Fri, Aug 28, 2015 at 08:11:20AM -0700, Sage Weil wrote:
> > > > Hi Dave,
> > > > 
> > > > On Fri, 28 Aug 2015, Dave Chinner wrote:
> > > > > 
> > > > > From: Dave Chinner <dchinner@redhat.com>
> > > > > 
> > > > > Sage Weil reported that a ceph test workload was writing to the
> > > > > log on every fdatasync during an overwrite workload. Event tracing
> > > > > showed that the only metadata modification being made was the
> > > > > timestamp updates during the write(2) syscall, but fdatasync(2)
> > > > > is supposed to ignore them. The key observation was that the
> > > > > transactions in the log all looked like this:
> > > [....]
> > > 
> > > > > ---
> > > > > Version 2:
> > > > > - include the hunk from fs/xfs/xfs_trans_inode.c that I missed
> > > > >   when committing the patch locally the first time.
> > > > 
> > > > I gave this a go on my machine but I'm still seeing the same symptom.  
> > > 
> > > OK, that implies the inode buffer has not been submitted for IO and
> > > so the inode is being held in "flushing" state for an extended
> > > period of time.
> > > 
> > > > I've gathered the trace, strace, and other useful bits at
> > > > 
> > > >    http://newdream.net/~sage/drop/rocksdb.2/
> > > > 
> > > > This is pretty easy to reproduce with the ceph_test_keyvaluedb binary 
> > > > (built on fedora 22), also in that dir:
> > > > 
> > > >    rm -rf kv_test_temp_dir/
> > > >    ./ceph_test_keyvaluedb --gtest_filter=KeyValueDB/KVTest.BenchCommit/1
> > > 
> > > I'll have a deeper look.
> > 
> > Ok, I was assuming this is a longer running test than it is - it
> > only takes about 2300ms to run on my test box. Hence the problem is
> > that the inode has never been flushed out, and so it's being
> > relogged in full on every fdatasync() operation. Another, similar
> > change is necessary to track the changes since the last time the
> > inode was flushed to the log.
> 
> This is more complex than I expected, and I ended up chasing down a
> rathole because performance is now *highly variable*.
> 
> Before making these changes, the performance was consistent at
> 2.3-2.6s for a test run on my test machine. It's on SSDs, with a 1GB
> BBWC in front of them, so there's minimal IO latency, and hence the
> average commit latency was around 2.5ms for the original (bad)
> fdatasync behaviour.
> 
> priming
> now doing small writes
> 1024 commits in 2.582939, avg latency 0.0025224
> [       OK ] KeyValueDB/KVTest.BenchCommit/1 (2600 ms)
> [----------] 1 test from KeyValueDB/KVTest (2600 ms total)
> 
> [----------] Global test environment tear-down
> [==========] 1 test from 1 test case ran. (2600 ms total)
> [  PASSED  ] 1 test.
> 
> 
> Now I see the test often complete in about 1.1s, or ~1.1ms per
> write/fdatasync operation. That's definitely an improvement,
> 
> priming
> now doing small writes
> 1024 commits in 1.133530, avg latency 0.00110696
> [       OK ] KeyValueDB/KVTest.BenchCommit/1 (1148 ms)
> [----------] 1 test from KeyValueDB/KVTest (1148 ms total)
> 
> [----------] Global test environment tear-down
> [==========] 1 test from 1 test case ran. (1149 ms total)
> [  PASSED  ] 1 test.
> 
> but every 4-5 test runs I'd see a test run that would take 8s to
> complete:
> 
> priming
> now doing small writes
> 1024 commits in 8.373202, avg latency 0.00817696
> [       OK ] KeyValueDB/KVTest.BenchCommit/1 (8429 ms)
> [----------] 1 test from KeyValueDB/KVTest (8430 ms total)
> 
> [----------] Global test environment tear-down
> [==========] 1 test from 1 test case ran. (8430 ms total)
> [  PASSED  ] 1 test.
> 
> This is completely reproducable, and very annoying as it doesn't
> happen without these fdatasync optimisation patches.

Note that rocksdb itself might be doing something nondeterministic too 
(like writing out 4mb sst files from the priming stage).  Though it sounds 
like that isn't (the only thing) happening here... and it certainly 
wouldn't account for 7 seconds.

> After taking a tangent to find a tracepoint regression that was
> getting in my way, I found that there was a significant pause
> between the inode locking calls within xfs_file_fsync and the inode
> locking calls on the buffered write. Roughly 8ms, in fact, on almost
> every call. After adding a couple more test trace points into the
> XFS fsync code, it turns out that a hardware cache flush is causing
> the delay. That is, because we aren't doing log writes that trigger
> cache flushes and FUA writes, we have to issue a
> blkdev_issue_flush() call from xfs_file_fsync and that is taking 8ms
> to complete.

This is where my understanding of block layer flushing really breaks down, 
but in both cases we're issues flush requests to the hardware, right? Is 
the difference that the log write is a FUA flush request with data, and 
blkdev_issue_flush() issues a flush request without associated data?

> IOWs, on my hardware, making fdatasync work correctly completely
> destroys workload determinism.  The full fsync adds 1ms to each
> operation, but it is constant and unchanging. The fdatasyncs fast
> most of the time, but every so often the cache flush blows
> performance all to hell and so over time (e.g. 100 test runs)
> fdatasync is little faster than using a full fsync.
> 
> So, that's the rat hole I've been down today - once again proving
> that Modern Storage Hardware Still Sucks.
> 
> Anyway, I'm going to do correctness testing now that I know the
> performance problems are hardware and not software.....

Thanks, Dave!  Sorry this snowballed...

sage

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
