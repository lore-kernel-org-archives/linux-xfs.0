Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA25nFCd092559 for <xfs@oss.sgi.com>; Fri, 2 Nov 2012 00:49:15 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	5dnLm31vZxsMNqGU for <xfs@oss.sgi.com>;
	Thu, 01 Nov 2012 22:51:06 -0700 (PDT)
Date: Fri, 2 Nov 2012 16:51:02 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: status of userspace release
Message-ID: <20121102055102.GY29378@dastard>
References: <20121025151501.GV1377@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121025151501.GV1377@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: xfs@oss.sgi.com

On Thu, Oct 25, 2012 at 10:15:01AM -0500, Ben Myers wrote:
> Hi Folks,
> 
> We're working toward a userspace release this month.  There are several patches
> that need to go in first, including backing out the xfsdump format version bump
> from Eric, fixes for the makefiles from Mike, and the Polish language update
> for xfsdump from Jakub.  If anyone knows of something else we need, now is the
> time to flame about it.  I will take a look around for other important patches
> too.
> 
> This time I'm going to tag an -rc1 (probably later today or tomorrow).  We'll
> give everyone a few working days to do a final test and/or pipe up if we have
> missed something important.  Then if all goes well we'll cut the release next
> Tuesday.

I think that dump/restore need more work/testing. I've just been
running with whatever xfsdump I have had installed on my test
machines for some time. I think I was the 3.0.6 - whatever is in the
current debian unstable repository - or some version of 3.1.0 that I
built a while back.

I've already pointed Eric to the header checksum failures (forkoff
patch being needed), and that fixes the failures I've been seeing on
normal xfstests runs.

Running some large filesystem testing, however, I see more problems.
I'm using a 17TB filesytsem and the --largefs patch series. This
results in a futex hang in 059 like so:

[ 4770.007858] xfsrestore      S ffff88021fc52d40  5504  3926   3487 0x00000000
[ 4770.007858]  ffff880212ea9c68 0000000000000082 ffff880207830140 ffff880212ea9fd8
[ 4770.007858]  ffff880212ea9fd8 ffff880212ea9fd8 ffff880216cec2c0 ffff880207830140
[ 4770.007858]  ffff880212ea9d08 ffff880212ea9d58 ffff880207830140 0000000000000000
[ 4770.007858] Call Trace:
[ 4770.007858]  [<ffffffff81b8a009>] schedule+0x29/0x70
[ 4770.007858]  [<ffffffff810db089>] futex_wait_queue_me+0xc9/0x100
[ 4770.007858]  [<ffffffff810db809>] futex_wait+0x189/0x290
[ 4770.007858]  [<ffffffff8113acf7>] ? __free_pages+0x47/0x70
[ 4770.007858]  [<ffffffff810dd41c>] do_futex+0x11c/0xa80
[ 4770.007858]  [<ffffffff810abbd5>] ? hrtimer_try_to_cancel+0x55/0x110
[ 4770.007858]  [<ffffffff810abcb2>] ? hrtimer_cancel+0x22/0x30
[ 4770.007858]  [<ffffffff81b88f44>] ? do_nanosleep+0xa4/0xd0
[ 4770.007858]  [<ffffffff810dde0d>] sys_futex+0x8d/0x1b0
[ 4770.007858]  [<ffffffff810ab6e0>] ? update_rmtp+0x80/0x80
[ 4770.007858]  [<ffffffff81b93a99>] system_call_fastpath+0x16/0x1b
[ 4770.007858] xfsrestore      S ffff88021fc52d40  5656  3927   3487 0x00000000
[ 4770.007858]  ffff880208f29c68 0000000000000082 ffff880208f84180 ffff880208f29fd8
[ 4770.007858]  ffff880208f29fd8 ffff880208f29fd8 ffff880216cec2c0 ffff880208f84180
[ 4770.007858]  ffff880208f29d08 ffff880208f29d58 ffff880208f84180 0000000000000000
[ 4770.007858] Call Trace:
[ 4770.007858]  [<ffffffff81b8a009>] schedule+0x29/0x70
[ 4770.007858]  [<ffffffff810db089>] futex_wait_queue_me+0xc9/0x100
[ 4770.007858]  [<ffffffff810db809>] futex_wait+0x189/0x290
[ 4770.007858]  [<ffffffff810dd41c>] do_futex+0x11c/0xa80
[ 4770.007858]  [<ffffffff810abbd5>] ? hrtimer_try_to_cancel+0x55/0x110
[ 4770.007858]  [<ffffffff810abcb2>] ? hrtimer_cancel+0x22/0x30
[ 4770.007858]  [<ffffffff81b88f44>] ? do_nanosleep+0xa4/0xd0
[ 4770.007858]  [<ffffffff810dde0d>] sys_futex+0x8d/0x1b0
[ 4770.007858]  [<ffffffff810ab6e0>] ? update_rmtp+0x80/0x80
[ 4770.007858]  [<ffffffff81b93a99>] system_call_fastpath+0x16/0x1b
[ 4770.007858] xfsrestore      S ffff88021fc92d40  5848  3928   3487 0x00000000
[ 4770.007858]  ffff880212d0dc68 0000000000000082 ffff880208e76240 ffff880212d0dfd8
[ 4770.007858]  ffff880212d0dfd8 ffff880212d0dfd8 ffff880216cf2300 ffff880208e76240
[ 4770.007858]  ffff880212d0dd08 ffff880212d0dd58 ffff880208e76240 0000000000000000
[ 4770.007858] Call Trace:
[ 4770.007858]  [<ffffffff81b8a009>] schedule+0x29/0x70
[ 4770.007858]  [<ffffffff810db089>] futex_wait_queue_me+0xc9/0x100
[ 4770.007858]  [<ffffffff810db809>] futex_wait+0x189/0x290
[ 4770.007858]  [<ffffffff810dd41c>] do_futex+0x11c/0xa80
[ 4770.007858]  [<ffffffff810abbd5>] ? hrtimer_try_to_cancel+0x55/0x110
[ 4770.007858]  [<ffffffff810abcb2>] ? hrtimer_cancel+0x22/0x30
[ 4770.007858]  [<ffffffff81b88f44>] ? do_nanosleep+0xa4/0xd0
[ 4770.007858]  [<ffffffff810dde0d>] sys_futex+0x8d/0x1b0
[ 4770.007858]  [<ffffffff810ab6e0>] ? update_rmtp+0x80/0x80
[ 4770.007858]  [<ffffffff81b93a99>] system_call_fastpath+0x16/0x1b

I can't reliably reproduce it at this point, but there does appear
to be some kind of locking problem in the multistream support.

Speaking of which, most large filesystems dump/restore tests are
failing because of this output:

026 20s ... - output mismatch (see 026.out.bad)
--- 026.out     2012-10-05 11:37:51.000000000 +1000
+++ 026.out.bad 2012-11-02 16:20:17.000000000 +1100
@@ -20,6 +20,7 @@
 xfsdump: media file size NUM bytes
 xfsdump: dump size (non-dir files) : NUM bytes
 xfsdump: dump complete: SECS seconds elapsed
+xfsdump:   stream 0 DUMP_FILE OK (success)
 xfsdump: Dump Status: SUCCESS
 Restoring from file...
 xfsrestore  -f DUMP_FILE  -L stress_026 RESTORE_DIR
@@ -32,6 +33,7 @@
 xfsrestore: directory post-processing
 xfsrestore: restoring non-directory files
 xfsrestore: restore complete: SECS seconds elapsed
+xfsrestore:   stream 0 DUMP_FILE OK (success)
 xfsrestore: Restore Status: SUCCESS
 Comparing dump directory with restore directory
 Files DUMP_DIR/big and RESTORE_DIR/DUMP_SUBDIR/big are identical

Which looks like output from the multistream code. Why it is
emitting this for large filesystem testing and not for small
filesystems, I'm not sure yet. 

In fact, with --largefs, I see this for the dump group:

Failures: 026 028 046 047 056 059 060 061 063 064 065 066 266 281
282 283
Failed 16 of 19 tests

And this for the normal sized (10GB) scratch device:

Passed all 18 tests

So there's something funky going on here....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
