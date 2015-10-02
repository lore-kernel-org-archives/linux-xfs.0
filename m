Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0015D7F55
	for <xfs@oss.sgi.com>; Thu,  1 Oct 2015 21:16:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 9736EAC004
	for <xfs@oss.sgi.com>; Thu,  1 Oct 2015 19:16:40 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	SO7lYeDc6Pez5vvd for <xfs@oss.sgi.com>;
	Thu, 01 Oct 2015 19:16:37 -0700 (PDT)
Date: Fri, 2 Oct 2015 12:16:34 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 02/12] libxfs: track largest metadata LSN in use via
	verifiers
Message-ID: <20151002021634.GJ3902@dastard>
References: <1441997742-37160-1-git-send-email-bfoster@redhat.com>
	<1441997742-37160-3-git-send-email-bfoster@redhat.com>
	<20150923034406.GR3902@dastard>
	<20150923131831.GB37210@bfoster.bfoster>
	<20150923223625.GR19114@dastard>
	<20151001203851.GA3349@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20151001203851.GA3349@bfoster.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Thu, Oct 01, 2015 at 04:38:51PM -0400, Brian Foster wrote:
> On Thu, Sep 24, 2015 at 08:36:25AM +1000, Dave Chinner wrote:
> > On Wed, Sep 23, 2015 at 09:18:31AM -0400, Brian Foster wrote:
> > > > This will have the same lock contention problems that the kernel
> > > > code would have had - my repair scalablity tests regularly reach
> > > > over 1GB/s of metadata being prefetched through tens of threads, so
> > > > this is going have a significant impact on performance in those
> > > > tests....
> ...
> > 
> > > I'll have to think about this some more and see what's effective. I'd
> > > also like to quantify the effect the current locking has on performance
> > > if possible. Can you provide a brief description of your typical repair
> > > test that you would expect this to hurt? E.g., a large fs, many AGs,
> > > populated with fs_mark and repaired with many threads..? Any special
> > > storage configuration? Thanks.
> > 
> > Just my usual 500TB fs_mark test...
> 
> Thanks for the test information and sample results. I wasn't able to get
> close enough to the base numbers you mentioned on IRC with the spinning
> rust storage I have available. Instead, I tried running something
> similar using a large ramdisk as a backing store. I have a 500T sparse
> file formatted with XFS and populated with ~25m inodes that uses roughly
> ~16GB of the backing store (leaving another 16GB of usable RAM for the
> server).

Keep in mind when doing this sort of testing that a ramdisk does not
perform like normal storage - it does synchronous IO via memcpy()
rather than async IO via DMA, and hence has a very different CPU
cache footprint, concurrency and latency profile to normal IO.

I'm not saying your numbers are invalid, just making sure that you
remember that ramdisks, while fast, may not give results that are
representative of normal storage behaviour...

> I run xfs_repair[1] against that 500TB fs and see spikes of throughput up
> over 2GB/s and get repair result reports like the following:

<snip>

> So I'm not seeing much difference here with the max lsn tracking as it
> is implemented in this series.

Yup, same here.  min/max spread between the 4.2.0 debian unstable
package and a locally built 4.2.0+lsn tracking is the same. Both
varied between 2m55s and 3m5s, all used roughly the same user and
system CPU.  So we'll commit it as is ;)

> Out of curiosity, I ran a v3.2.2
> xfs_repair binary that happened to be installed on this host, got a much
> faster result than even the current master, and via perf diff discovered
> that the biggest difference between the runs was actual CRC calculation.

I think you might have drawn the incorrect conclusion from the
profile data...

> Based on that, I ran the same crc=0 test against the current code with
> the following results:
> 
> Phase           Start           End             Duration
> Phase 1:        10/01 13:53:49  10/01 13:53:49
> Phase 2:        10/01 13:53:49  10/01 13:53:50  1 second
> Phase 3:        10/01 13:53:50  10/01 13:54:52  1 minute, 2 seconds
> Phase 4:        10/01 13:54:52  10/01 13:55:01  9 seconds
> Phase 5:        10/01 13:55:01  10/01 13:55:01
> Phase 6:        10/01 13:55:01  10/01 13:55:35  34 seconds
> Phase 7:        10/01 13:55:35  10/01 13:55:35
> 
> ... so that knocks off another 15s or so from the test. Note that the
> lsn lock is irrelevant in the crc=0 case as there are no metadata LSNs,
> thus no verification occurs.

My results:
			    fsmark creation
mkfs (4.2.0)		files/s (avg)	wall time	repair
defaults		203209		4m57s		2m55s-3m05s
-m crc=0		188837		5m06s		2m07s-2m10s

On first glance, I've just replicated your results. But the PCP
monitoring I run all the time tell a different story.  Both
xfs_repair runs are io bound during phase 3 and 4, but the crc=0 run
does a *lot less IO*.

The reason for this will be obvious when I tell you: inodes are 512
bytes when CRCs are enabled, 256 bytes when they aren't. Hence
there's twice as much metadata to be read when CRCs are enabled, and
when it is read at a fixed rate, it takes twice as long to read.

The trap here is that perf profiles tend to present
"percentage of CPU used by a function" rather than absolute CPU
consumed by the function across a test run. That's why you might
think that the CPU consumed by CRCs is responsible for the
difference in performance - it's the only really obvious difference
in the profile. What I think you'll find if you look deeper is that
the time spent in memcpy() deep in the ramdisk IO path has doubled
and that's where most of the additional time comes from.

Apples to apples comparison at the IO level on my test rig:

			    fsmark creation
mkfs			files/s (avg)	wall time	repair
defaults		203209		4m57s		2m55s-3m05s
-m crc=0		188837		5m06s		2m07s-2m10s
-m crc=0 -i size=512	194331		5m00s		3m00s-3m10s

Yup, when doing IO-equivalent testing, CRCs have no measurable
wall time impact on xfs_repair runtime.

Performance analysis is tricky stuff.... ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
