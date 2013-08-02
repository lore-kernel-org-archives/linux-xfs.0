Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1EAEB7F37
	for <xfs@oss.sgi.com>; Fri,  2 Aug 2013 03:14:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E809B8F8037
	for <xfs@oss.sgi.com>; Fri,  2 Aug 2013 01:14:04 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id PpK3dsuA37X8qbsz
	for <xfs@oss.sgi.com>; Fri, 02 Aug 2013 01:14:04 -0700 (PDT)
Message-ID: <51FB6A4C.5040103@hardwarefreak.com>
Date: Fri, 02 Aug 2013 03:14:04 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: Performance decrease over time
References: <20130801202108.GA355@x4> <20130802022518.GZ7118@dastard>
In-Reply-To: <20130802022518.GZ7118@dastard>
Reply-To: stan@hardwarefreak.com
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
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>, xfs@oss.sgi.com

On 8/1/2013 9:25 PM, Dave Chinner wrote:
...

> So really, the numbers only reflect a difference in layout of the
> files being tested. And using small direct IO means that the
> filesystem will tend to fill small free spaces close to the
> inode first, and so will fragment the file based on the locality of
> fragmented free space to the owner inode. In the case of the new
> filesystem, there is only large, contiguous free space near the
> inode....
...
>> What can be
>> done (as a user) to mitigate this effect? 
> 
> Buy faster disks ;)
> 
> Seriously, all filesystems age and get significantly slower as they
> get used. XFS is not really designed for single spindles - it's
> algorithms are designed to spread data out over the entire device
> and so be able to make use of many, many spindles that make up the
> device. The behaviour it has works extremely well for this sort of
> large scale scenario, but it's close to the worst case aging
> behaviour for a single, very slow spindle like you are using.  Hence
> once the filesystem is over the "we have pristine, contiguous
> freespace" hump on your hardware, it's all downhill and there's not
> much you can do about it....

Wouldn't the inode32 allocator yield somewhat better results with this
direct IO workload?  With Markus' single slow spindle?  It shouldn't
fragment free space quite as badly in the first place, nor suffer from
trying to use many small fragments surrounding the inode as in the case
above.

Whether or not inode32 would be beneficial to his real workload(s) I
don't know.  I tend to think it might make at least a small positive
difference.  However, given that XFS is trying to get away from inode32
altogether I can see why you wouldn't mention it, even if it might yield
some improvement in this case.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
