Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q155GltK007943 for <xfs@oss.sgi.com>; Sat, 4 Feb 2012 23:16:47 -0600
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id wR3ZQstBT20szy3T
	for <xfs@oss.sgi.com>; Sat, 04 Feb 2012 21:16:46 -0800 (PST)
Message-ID: <4F2E10C1.3040200@hardwarefreak.com>
Date: Sat, 04 Feb 2012 23:16:49 -0600
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: Performance problem - reads slower than writes
References: <20120130220019.GA45782@nsrc.org> <20120131020508.GF9090@dastard>
	<20120131103126.GA46170@nsrc.org>
	<20120131145205.GA6607@infradead.org>
	<20120203115434.GA649@nsrc.org>
	<4F2C38BE.2010002@hardwarefreak.com>
	<20120203221015.GA2675@nsrc.org>
	<4F2D016C.9020406@hardwarefreak.com>
	<20120204112436.GA3167@nsrc.org>
	<4F2D2953.2020906@hardwarefreak.com>
	<20120204200417.GA3362@nsrc.org>
In-Reply-To: <20120204200417.GA3362@nsrc.org>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Brian Candler <B.Candler@pobox.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On 2/4/2012 2:04 PM, Brian Candler wrote:
> On Sat, Feb 04, 2012 at 06:49:23AM -0600, Stan Hoeppner wrote:
>> Apparently you've read of a different GlusterFS.  The one I know of is
>> for aggregating multiple storage hosts into a cloud storage resource.
>> It is not designed to replace striping or concatenation of disks within
>> a single host.
> 
> Sure it can. A gluster volume consists of "bricks". Each brick is served by
> a glusterd process listening on a different TCP port. Those bricks can be on
> the same server or on different servers.

That's some interesting flexibility.  I'd never heard of the "intranode"
Gluster setup.  All the example ocnfigs I'd seen showed md/hardware RAID
with EXT4 atop, then EXT4 exported through Gluster.

>> Even if what you describe can be done with Gluster, the performance will
>> likely be significantly less than a properly setup mdraid or hardware
>> raid.  Again, if it can be done, I'd test it head-to-head against RAID.
> 
> I'd expect similar throughput but higher latency. Given that I'm using low
> RPM drives which already have high latency, I'm hoping the additional
> latency will be insignificant.  Anyway, I'll know more once I've done the
> measurements.

As they say, there's more than one way to skin a cat.

>> I've never been a fan of parity RAID, let alone double parity RAID.
> 
> I'm with you on that one.

When you lose a disk in this setup, how do you rebuild the replacement
drive?  Do you simply format it and then move 3TB of data across GbE
from other Gluster nodes?  Even if the disk is only 1/3rd full, such a
restore seems like an expensive and time consuming operation.  I'm
thinking RAID has a significant advantage here.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
