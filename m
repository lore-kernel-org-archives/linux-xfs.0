Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q14CnNdT212806 for <xfs@oss.sgi.com>; Sat, 4 Feb 2012 06:49:23 -0600
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id mjuVf3vGjiLY1jQb
	for <xfs@oss.sgi.com>; Sat, 04 Feb 2012 04:49:21 -0800 (PST)
Message-ID: <4F2D2953.2020906@hardwarefreak.com>
Date: Sat, 04 Feb 2012 06:49:23 -0600
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
In-Reply-To: <20120204112436.GA3167@nsrc.org>
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

On 2/4/2012 5:24 AM, Brian Candler wrote:
> On Sat, Feb 04, 2012 at 03:59:08AM -0600, Stan Hoeppner wrote:
>> Will you be using mdraid or hardware RAID across those 24 spindles?
> 
> Gluster is the front-runner at the moment. Each file sits on a single
> spindle, and there is a separate filesystem per spindle, so I think the
> parallel processing will work much better this way. This does mean double
> the disks to get data replication though.

Apparently you've read of a different GlusterFS.  The one I know of is
for aggregating multiple storage hosts into a cloud storage resource.
It is not designed to replace striping or concatenation of disks within
a single host.

Even if what you describe can be done with Gluster, the performance will
likely be significantly less than a properly setup mdraid or hardware
raid.  Again, if it can be done, I'd test it head-to-head against RAID.

> I did some testing of RAID6 mdraid (12 disks with with 1MB stripe size) and
> it sucked.  However I need to re-test it now that I know about inode64.
> We do have a requirement for archival storage and that might use RAID6.

I've never been a fan of parity RAID, let alone double parity RAID.
SATA drives are so cheap (or were until the flooding in Thailand) that
it's really hard to justify RAID6 over RAID10 or a layered stripe over
mirror, given the many advantages of RAID10 and negligible
disadvantages.  The RAID6 dead drive rebuild time, and performance
degradation during the rebuild, on a production system with real users,
is enough justification to go RAID10, where that drive rebuild will take
many many hours less, if not days less, and degrade performance only mildly.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
