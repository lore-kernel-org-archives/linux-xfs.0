Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:52319 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752906AbcKQA1f (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Nov 2016 19:27:35 -0500
Date: Wed, 16 Nov 2016 19:27:27 -0500
From: Chris Mason <clm@fb.com>
Subject: Re: [PATCH RFC] xfs: drop SYNC_WAIT from xfs_reclaim_inodes_ag
 during slab reclaim
Message-ID: <20161117002726.GA4811@clm-mbp.masoncoding.com>
References: <20161018020324.GA23194@dastard>
 <20161114005951.GB2127@clm-mbp.thefacebook.com>
 <20161114072708.GN28922@dastard>
 <1f19925d-6ba8-9bde-b3a8-0bdade80f564@fb.com>
 <20161114235801.GO28922@dastard>
 <20161115055416.GP28922@dastard>
 <77e23f2d-04f6-beb1-4515-6513a82b0686@fb.com>
 <20161116013009.GQ28922@dastard>
 <20161116030344.GA7746@clm-mbp.masoncoding.com>
 <20161116233136.GA19783@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Disposition: inline
In-Reply-To: <20161116233136.GA19783@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Nov 17, 2016 at 10:31:36AM +1100, Dave Chinner wrote:
>On Tue, Nov 15, 2016 at 10:03:52PM -0500, Chris Mason wrote:
>> On Wed, Nov 16, 2016 at 12:30:09PM +1100, Dave Chinner wrote:
>> >On Tue, Nov 15, 2016 at 02:00:47PM -0500, Chris Mason wrote:
>> >>On 11/15/2016 12:54 AM, Dave Chinner wrote:
>> >>>On Tue, Nov 15, 2016 at 10:58:01AM +1100, Dave Chinner wrote:
>> >>>>On Mon, Nov 14, 2016 at 03:56:14PM -0500, Chris Mason wrote:
>> >>>There have been 1.2 million inodes reclaimed from the cache, but
>> >>>there have only been 20,000 dirty inode buffer writes. Yes, that's
>> >>>written 440,000 dirty inodes - the inode write clustering is
>> >>>capturing about 22 inodes per write - but the inode writeback load
>> >>>is minimal at about 10 IO/s. XFS inode reclaim is not blocking
>> >>>significantly on dirty inodes.
>> >>
>> >>I think our machines are different enough that we're not seeing the
>> >>same problems.  Or at least we're seeing different sides of the
>> >>problem.
>> >>
>> >>We have 130GB of ram and on average about 300-500MB of XFS slab,
>> >>total across all 15 filesystems.  Your inodes are small and cuddly,
>> >>and I'd rather have more than less.  I see more with simoop than we
>> >>see in prod, but either way its a reasonable percentage of system
>> >>ram considering the horrible things being done.
>> >
>> >So I'm running on 16GB RAM and have 100-150MB of XFS slab.
>> >Percentage wise, the inode cache is a larger portion of memory than
>> >in your machines. I can increase the number of files to increase it
>> >further, but I don't think that will change anything.
>>
>> I think the way to see what I'm seeing would be to drop the number
>> of IO threads (-T) and bump both -m and -M.  Basically less inode
>> working set and more memory working set.
>
>If I increase m/M by any non-trivial amount, the test OOMs within a
>couple of minutes of starting even after cutting the number of IO
>threads in half. I've managed to increase -m by 10% without OOM -
>I'll keep trying to increase this part of the load as much as I
>can as I refine the patchset I have.

Gotcha.  -m is long lasting, allocated once at the start of the run and 
stays around for ever.  It basically soaks up ram.  -M is allocated once 
per work loop, and it should be where the stalls really hit.  I'll peel 
off a flash machine tomorrow and find a command line that matches my 
results so far.

What kind of flash are you using?  I can choose between modern nvme or 
something more crusty.

>> With simoop, du is supposed to do IO.  It's crazy to expect to be
>> able to scan all the inodes on a huge FS (or 15 of them) and keep it
>> all in cache along with everything else hadoop does.  I completely
>> agree there are cases where having the working set in ram is valid,
>> just simoop isn't one ;)
>
>Sure, I was just pointing out that even simoop was seeing signficant
>changes in cache residency as a result of this change....

Yeah, one of the problems with simoop is it should actually go faster if 
we empty all the caches every time.  It only needs enough dirty pages
pages around for efficient IO.   I should add a 
page-reuse-after-N-seconds mode so that it notices if some jerk tries a 
patch that tosses all the pages.  It won't make it any less effective 
for pretending to be hadoop, and it'll catch some mistakes I'm likely to 
make.

>
>> >That's what removing the blocking from the shrinker causes the
>> >overall work rate to go down - it results in the cache not
>> >maintaining a working set of inodes and so increases the IO load and
>> >that then slows everything down.
>>
>> At least on my machines, it made the overall work rate go up.  Both
>> simoop and prod are 10-15% faster.
>
>Ok, I'll see if I can tune the workload here to behave more like
>this....

What direction do you have in mind for your current patches?  Many tiers 
have shadows where we can put experimental code without feeling bad if 
machines crash or data is lost.  I'm happy to line up tests if you want 
data from specific workloads.

-chris

