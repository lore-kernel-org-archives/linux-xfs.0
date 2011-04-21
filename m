Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3LBB5d2154060 for <xfs@oss.sgi.com>; Thu, 21 Apr 2011 06:11:05 -0500
Received: from rcsinet10.oracle.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9C3883FEF87
	for <xfs@oss.sgi.com>; Thu, 21 Apr 2011 04:11:09 -0700 (PDT)
Received: from rcsinet10.oracle.com (rcsinet10.oracle.com [148.87.113.121]) by
	cuda.sgi.com with ESMTP id 4vCemqAcxrOkLmGz for
	<xfs@oss.sgi.com>; Thu, 21 Apr 2011 04:11:09 -0700 (PDT)
From: Chris Mason <chris.mason@oracle.com>
Subject: Re: buffered writeback torture program
In-reply-to: <20110420220626.GL29872@redhat.com>
References: <1303322378-sup-1722@think> <20110420220626.GL29872@redhat.com>
Date: Thu, 21 Apr 2011 07:09:11 -0400
Message-Id: <1303383609-sup-2330@think>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, axboe <axboe@kernel.dk>, linux-ext4 <linux-ext4@vger.kernel.org>, jack <jack@suse.cz>, xfs <xfs@oss.sgi.com>

Excerpts from Vivek Goyal's message of 2011-04-20 18:06:26 -0400:
> On Wed, Apr 20, 2011 at 02:23:29PM -0400, Chris Mason wrote:
> > Hi everyone,
> > 
> > I dug out my old fsync latency tester to make sure Jens' new plugging
> > code hadn't caused regressions.  This started off as a program Ted wrote
> > during the firefox dark times, and I added some more code to saturate
> > spindles with random IO.
> > 
> > The basic idea is:
> > 
> > 1) make a nice big sequential 8GB file
> > 2) fork a process doing random buffered writes inside that file
> > 3) overwrite a second 4K file in a loop, doing fsyncs as you go.
> > 
> > The test program times how long each write and fsync take in step three.
> > The idea is that if we have problems with concurrent buffered writes and
> > fsyncs, then all of our fsyncs will get stuck behind the random IO
> > writeback and our latencies will be high.
> > 
> > For a while, xfs, btrfs and ext4 did really well at this test.  Our
> > fsync latencies were very small and we all sent down synchronous IO that
> > the elevator dispatched straight to the drive.
> > 
> > Things have changed though, both xfs and ext4 have grown code to do
> > dramatically more IO than write_cache_pages has asked for (I'm pretty
> > sure I told everyone this was a good idea at the time).  When doing
> > sequential writes, this is a great idea.  When doing random IO, it leads
> > to unbound stalls in balance_dirty_pages.
> > 
> > Here's an example run on xfs:
> > 
> > # fsync-tester
> > setting up random write file
> > done setting up random write file
> > starting fsync run
> > starting random io!
> > write time 0.0009s fsync time: 2.0142s
> > write time 128.9305s fsync time: 2.6046s
> > run done 2 fsyncs total, killing random writer
> > 
> > In this case the 128s spent in write was on a single 4K overwrite on a
> > 4K file.
> 
> Chris, You seem to be doing 1MB (32768*32) writes on fsync file instead of 4K.
> I changed the size to 4K still not much difference though.

Whoops, I had that change made locally but didn't get it copied out.

> 
> Once the program has exited because of high write time, i restarted it and
> this time I don't see high write times.

I see this for some of my runs as well.

> 
> First run
> ---------
> # ./a.out 
> setting up random write file
> done setting up random write file
> starting fsync run
> starting random io!
> write time: 0.0006s fsync time: 0.3400s
> write time: 63.3270s fsync time: 0.3760s
> run done 2 fsyncs total, killing random writer
> 
> Second run
> ----------
> # ./a.out 
> starting fsync run
> starting random io!
> write time: 0.0006s fsync time: 0.5359s
> write time: 0.0007s fsync time: 0.3559s
> write time: 0.0009s fsync time: 0.3113s
> write time: 0.0008s fsync time: 0.4336s
> write time: 0.0009s fsync time: 0.3780s
> write time: 0.0008s fsync time: 0.3114s
> write time: 0.0009s fsync time: 0.3225s
> write time: 0.0009s fsync time: 0.3891s
> write time: 0.0009s fsync time: 0.4336s
> write time: 0.0009s fsync time: 0.4225s
> write time: 0.0009s fsync time: 0.4114s
> write time: 0.0007s fsync time: 0.4004s
> 
> Not sure why would that happen.
> 
> I am wondering why pwrite/fsync process was throttled. It did not have any
> pages in page cache and it shouldn't have hit the task dirty limits. Does that
> mean per task dirty limit logic does not work or I am completely missing
> the root cause of the problem.

I haven't traced it to see.  This test box only has 1GB of ram, so the
dirty ratios can be very tight.

-chris

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
