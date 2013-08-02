Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5514C7F52
	for <xfs@oss.sgi.com>; Fri,  2 Aug 2013 17:30:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C225DAC006
	for <xfs@oss.sgi.com>; Fri,  2 Aug 2013 15:30:13 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	jzfBJ0EL9XJW5wx1 for <xfs@oss.sgi.com>;
	Fri, 02 Aug 2013 15:30:11 -0700 (PDT)
Date: Sat, 3 Aug 2013 08:30:07 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Performance decrease over time
Message-ID: <20130802223007.GY13468@dastard>
References: <20130801202108.GA355@x4> <20130802022518.GZ7118@dastard>
	<51FB6A4C.5040103@hardwarefreak.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <51FB6A4C.5040103@hardwarefreak.com>
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
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>, xfs@oss.sgi.com

On Fri, Aug 02, 2013 at 03:14:04AM -0500, Stan Hoeppner wrote:
> On 8/1/2013 9:25 PM, Dave Chinner wrote:
> ...
> 
> > So really, the numbers only reflect a difference in layout of the
> > files being tested. And using small direct IO means that the
> > filesystem will tend to fill small free spaces close to the
> > inode first, and so will fragment the file based on the locality of
> > fragmented free space to the owner inode. In the case of the new
> > filesystem, there is only large, contiguous free space near the
> > inode....
> ...
> >> What can be
> >> done (as a user) to mitigate this effect? 
> > 
> > Buy faster disks ;)
> > 
> > Seriously, all filesystems age and get significantly slower as they
> > get used. XFS is not really designed for single spindles - it's
> > algorithms are designed to spread data out over the entire device
> > and so be able to make use of many, many spindles that make up the
> > device. The behaviour it has works extremely well for this sort of
> > large scale scenario, but it's close to the worst case aging
> > behaviour for a single, very slow spindle like you are using.  Hence
> > once the filesystem is over the "we have pristine, contiguous
> > freespace" hump on your hardware, it's all downhill and there's not
> > much you can do about it....
> 
> Wouldn't the inode32 allocator yield somewhat better results with this
> direct IO workload?

What direct IO workload? Oh, you mean the IOZone test? 

What's the point of trying to optimise IOzone throughput? it matters
nothing to Marcus - he's just using it to demonstrate a point that
free space is not as contiguous as it once was...

As it is, inode32 will do nothing to speed up performance on a
single spindle - it spreads all files out across the entire disk, so
locality between the inode and the data is guaranteed to be worse
than an aged inode64 filesystem. inode32 intentionally spreads data
across the disk without caring about access locality so the average
seek from inode read to data read is half the spindle. That's why
inode64 is so much faster than inode32 on general workloads - the
seek between inode and data is closer to the track-to-track seek
time than the average seek time.

> With Markus' single slow spindle?  It shouldn't
> fragment free space quite as badly in the first place, nor suffer from
> trying to use many small fragments surrounding the inode as in the case
> above.

inode32 fragments free space just as badly as inode64, if not worse,
because it is guaranteed to intermingle data of different temporal
stability in the same localities, rather than clustering different
datasets around individual directory inodes...

> Whether or not inode32 would be beneficial to his real workload(s) I
> don't know.  I tend to think it might make at least a small positive
> difference.  However, given that XFS is trying to get away from inode32
> altogether I can see why you wouldn't mention it, even if it might yield
> some improvement in this case.

I didn't mention it because as a baseline for the data Macus is
storing (source trees, doing compilations, etc) inode32 starts off
much slower than inode64 and degrades just as much or more over
time....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
