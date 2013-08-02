Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5574A7F52
	for <xfs@oss.sgi.com>; Fri,  2 Aug 2013 18:00:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3A558304070
	for <xfs@oss.sgi.com>; Fri,  2 Aug 2013 16:00:15 -0700 (PDT)
Received: from mail-ob0-f182.google.com (mail-ob0-f182.google.com
	[209.85.214.182]) by cuda.sgi.com with ESMTP id
	DKmro35LiQMWESET (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 02 Aug 2013 16:00:14 -0700 (PDT)
Received: by mail-ob0-f182.google.com with SMTP id wo10so2257639obc.13
	for <xfs@oss.sgi.com>; Fri, 02 Aug 2013 16:00:13 -0700 (PDT)
Subject: Re: Performance decrease over time
Mime-Version: 1.0 (Apple Message framework v1085)
From: aurfalien <aurfalien@gmail.com>
In-Reply-To: <20130802223007.GY13468@dastard>
Date: Fri, 2 Aug 2013 16:00:09 -0700
Message-Id: <E83C0048-3E7D-4F8E-8FD8-0ECC89F83424@gmail.com>
References: <20130801202108.GA355@x4> <20130802022518.GZ7118@dastard>
	<51FB6A4C.5040103@hardwarefreak.com>
	<20130802223007.GY13468@dastard>
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
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>, Stan Hoeppner <stan@hardwarefreak.com>, xfs@oss.sgi.com


On Aug 2, 2013, at 3:30 PM, Dave Chinner wrote:

> On Fri, Aug 02, 2013 at 03:14:04AM -0500, Stan Hoeppner wrote:
>> On 8/1/2013 9:25 PM, Dave Chinner wrote:
>> ...
>> 
>>> So really, the numbers only reflect a difference in layout of the
>>> files being tested. And using small direct IO means that the
>>> filesystem will tend to fill small free spaces close to the
>>> inode first, and so will fragment the file based on the locality of
>>> fragmented free space to the owner inode. In the case of the new
>>> filesystem, there is only large, contiguous free space near the
>>> inode....
>> ...
>>>> What can be
>>>> done (as a user) to mitigate this effect? 
>>> 
>>> Buy faster disks ;)
>>> 
>>> Seriously, all filesystems age and get significantly slower as they
>>> get used. XFS is not really designed for single spindles - it's
>>> algorithms are designed to spread data out over the entire device
>>> and so be able to make use of many, many spindles that make up the
>>> device. The behaviour it has works extremely well for this sort of
>>> large scale scenario, but it's close to the worst case aging
>>> behaviour for a single, very slow spindle like you are using.  Hence
>>> once the filesystem is over the "we have pristine, contiguous
>>> freespace" hump on your hardware, it's all downhill and there's not
>>> much you can do about it....
>> 
>> Wouldn't the inode32 allocator yield somewhat better results with this
>> direct IO workload?
> 
> What direct IO workload? Oh, you mean the IOZone test? 
> 
> What's the point of trying to optimise IOzone throughput? it matters
> nothing to Marcus - he's just using it to demonstrate a point that
> free space is not as contiguous as it once was...
> 
> As it is, inode32 will do nothing to speed up performance on a
> single spindle - it spreads all files out across the entire disk, so
> locality between the inode and the data is guaranteed to be worse
> than an aged inode64 filesystem. inode32 intentionally spreads data
> across the disk without caring about access locality so the average
> seek from inode read to data read is half the spindle. That's why
> inode64 is so much faster than inode32 on general workloads - the
> seek between inode and data is closer to the track-to-track seek
> time than the average seek time.

Totally concur 100%.

In fact I've either obsoleted or made local 32 bit apps as we run most everything off a NAS type setup using XFS.

The benies of inode64 in our env were just too much to side line, especially with our older SATA 2 disks in use.

In fact, for slower disks, I'd say inode64 is a must.  But I'm talking several in a RAID config as I don't do single disk XFS.

- aurf
_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
