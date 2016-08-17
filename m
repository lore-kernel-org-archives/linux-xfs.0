Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id AB1907CA0
	for <xfs@oss.sgi.com>; Wed, 17 Aug 2016 12:26:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2F076AC044
	for <xfs@oss.sgi.com>; Wed, 17 Aug 2016 10:26:29 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id mXL2KyEZEqVaiipK for <xfs@oss.sgi.com>;
	Wed, 17 Aug 2016 10:26:27 -0700 (PDT)
Received: from [10.0.0.4] (liberator [10.0.0.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 44E204420
	for <xfs@oss.sgi.com>; Wed, 17 Aug 2016 12:26:27 -0500 (CDT)
Subject: Re: XFS on top of LVM span in AWS. Stripe or are AG's good enough?
References: <CY1PR04MB20100FE6C3039717BD27825AAC120@CY1PR04MB2010.namprd04.prod.outlook.com>
	<20160816005931.GD19025@dastard>
	<CY1PR04MB20106F50E177A61934986A92AC130@CY1PR04MB2010.namprd04.prod.outlook.com>
	<6ec8fbba-27ff-7386-e72a-d9f8e81f9252@sandeen.net>
	<CY1PR04MB201082A9ACE83B23FE701409AC140@CY1PR04MB2010.namprd04.prod.outlook.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <4bcdb01b-8920-c88c-a607-20a56688f6d2@sandeen.net>
Date: Wed, 17 Aug 2016 12:26:26 -0500
MIME-Version: 1.0
In-Reply-To: <CY1PR04MB201082A9ACE83B23FE701409AC140@CY1PR04MB2010.namprd04.prod.outlook.com>
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
To: xfs@oss.sgi.com

On 8/17/16 11:23 AM, Jeff Gibson wrote:
> Thanks for the great info guys.
> 
> Sorry to beat a dead horse here.  Just to be absolutely clear-
> 
>>> I guess what I'm trying to ask is - will XFS *indirectly* compensate
>>> if one subvolume is busier?  For example, if writes to a "slow"
>>> subvolume and resident AGs take longer to complete, will XFS tend to
>>> prefer to use other less-busy AGs more often (with the exception of
>>> locality) for writes?  What is the basic algorithm for determining
>>> where new data is written?  In load-balancer terms, does it
>>> round-robin, pick the least busy, etc?
>>  
>> xfs has no notion of fast vs slow regions.  See above for the basic
>> algorithm; it's round-robin for new directories, keep inodes and blocks
>> near their parent if possible.  

> So if one EBS LVM subvolume has subpar performance it will basically
> slow down writes to the whole XFS volume.  XFS doesn't have any
> notion of a queue per AG or any other mechanism for compensating
> uneven performance of AGs.

It will slow down writes to blocks in that block device.
If those blocks gate other IO (i.e. core metadata structures, maybe
the log), then it could conceivably have an fs-wide impact.

i.e. -

If file "foo" has 100 blocks allocated in a slow-responding volume,
writing to those 100 blocks would only slow down that write.

If the log is allocated in a slow-responding volume and a workload
is log-bound, then it could have an fs-wide impact.

Again, xfs has no fast/slow notion.  There is no compensation.
IO queues are below the filesystem; there is no IO queue per AG.
 
>> There are a few other smaller-granularity
>> heuristics related to stripe geometry as well.

> Oh, cool.  Since I'm considering stripe vs. linear for the LVM volume, I'd be very interested in what these are.

Simply things like allocating files on stripe boundaries if possible.

So if you have a 64k stripe, it would try (IIRC) to allocate files
(at least larger files, not remembering details for sure) on 64k
boundaries.

If you're keen to look at code, m_dalign is the stripe unit for the
fs. You'll find things like:

                /*
                 * Round up the allocation request to a stripe unit
                 * (m_dalign) boundary if the file size is >= stripe unit
                 * size, and we are allocating past the allocation eof.
                 *
                 * If mounted with the "-o swalloc" option the alignment is
                 * increased from the strip unit size to the stripe width.
                 */

or for inode allocation:

                /*
                 * Set the alignment for the allocation.
                 * If stripe alignment is turned on then align at stripe unit
                 * boundary.
                 * If the cluster size is smaller than a filesystem block
                 * then we're doing I/O for inodes in filesystem block size
                 * pieces, so don't need alignment anyway.
                 */

-Eric
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
