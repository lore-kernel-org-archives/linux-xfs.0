Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:35847 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389026AbfHHA1W (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Aug 2019 20:27:22 -0400
Date: Thu, 8 Aug 2019 10:26:11 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] [Regression, v5.0] mm: boosted kswapd reclaim b0rks
 system cache balance
Message-ID: <20190808002611.GT7777@dread.disaster.area>
References: <20190807091858.2857-1-david@fromorbit.com>
 <20190807093056.GS11812@dhcp22.suse.cz>
 <20190807150316.GL2708@suse.de>
 <20190807205615.GI2739@techsingularity.net>
 <20190807223241.GO7777@dread.disaster.area>
 <20190807234815.GJ2739@techsingularity.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190807234815.GJ2739@techsingularity.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@kernel.org>, linux-mm@kvack.org, linux-xfs@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>

On Thu, Aug 08, 2019 at 12:48:15AM +0100, Mel Gorman wrote:
> On Thu, Aug 08, 2019 at 08:32:41AM +1000, Dave Chinner wrote:
> > On Wed, Aug 07, 2019 at 09:56:15PM +0100, Mel Gorman wrote:
> > > On Wed, Aug 07, 2019 at 04:03:16PM +0100, Mel Gorman wrote:
> > > > <SNIP>
> > > >
> > > > On that basis, it may justify ripping out the may_shrinkslab logic
> > > > everywhere. The downside is that some microbenchmarks will notice.
> > > > Specifically IO benchmarks that fill memory and reread (particularly
> > > > rereading the metadata via any inode operation) may show reduced
> > > > results. Such benchmarks can be strongly affected by whether the inode
> > > > information is still memory resident and watermark boosting reduces
> > > > the changes the data is still resident in memory. Technically still a
> > > > regression but a tunable one.
> > > > 
> > > > Hence the following "it builds" patch that has zero supporting data on
> > > > whether it's a good idea or not.
> > > > 
> > > 
> > > This is a more complete version of the same patch that summaries the
> > > problem and includes data from my own testing
> > ....
> > > A fsmark benchmark configuration was constructed similar to
> > > what Dave reported and is codified by the mmtest configuration
> > > config-io-fsmark-small-file-stream.  It was evaluated on a 1-socket machine
> > > to avoid dealing with NUMA-related issues and the timing of reclaim. The
> > > storage was an SSD Samsung Evo and a fresh XFS filesystem was used for
> > > the test data.
> > 
> > Have you run fstrim on that drive recently? I'm running these tests
> > on a 960 EVO ssd, and when I started looking at shrinkers 3 weeks
> > ago I had all sorts of whacky performance problems and inconsistent
> > results. Turned out there were all sorts of random long IO latencies
> > occurring (in the hundreds of milliseconds) because the drive was
> > constantly running garbage collection to free up space. As a result
> > it was both blocking on GC and thermal throttling under these fsmark
> > workloads.
> > 
> 
> No, I was under the impression that making a new filesystem typically
> trimmed it as well. Maybe that's just some filesystems (e.g. ext4) or
> just completely wrong.

Depends. IIRC, some have turned that off by default because of the
amount of poor implementations that take minutes to trim a whole
device. XFS discards by default, but that doesn't mean it actually
gets done. e.g. it might be on a block device that does not support
or pass down discard requests.

FWIW, I run these in a VM on a sparse filesystem image (500TB) held
in a file on the host XFS filesystem and:

$ cat /sys/block/vdc/queue/discard_max_bytes 
0

Discard requests don't pass down through the virtio block device
(nor do I really want them to). Hence I have to punch the image file
and fstrim on the host side before launching the VM that runs the
tests...

> > then ran
> > fstrim on it to tell the drive all the space is free. Drive temps
> > dropped 30C immediately, and all of the whacky performance anomolies
> > went away. I now fstrim the drive in my vm startup scripts before
> > each test run, and it's giving consistent results again.
> > 
> 
> I'll replicate that if making a new filesystem is not guaranteed to
> trim. It'll muck up historical data but that happens to me every so
> often anyway.

mkfs.xfs should be doing it if you're directly on top of the SSD.
Just wanted to check seeing as I've recently been bitten by this.

> > That looks a lot better. Patch looks reasonable, though I'm
> > interested to know what impact it has on tests you ran in the
> > original commit for the boosting.
> > 
> 
> I'll find out soon enough but I'm leaning on the side that kswapd reclaim
> should be predictable and that even if there are some performance problems
> as a result of it, there will be others that see a gain. It'll be a case
> of "no matter what way you jump, someone shouts" but kswapd having spiky
> unpredictable behaviour is a recipe for "sometimes my machine is crap
> and I've no idea why".

Yeah, and that's precisely the motiviation for getting XFS inode
reclaim to avoid blocking altogether and relying on memory reclaim
to back off when appropriate. I expect there will be other problems
I find with reclaim backoff and blance as a kick the tyres more...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
