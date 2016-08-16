Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5A3B07CA0
	for <xfs@oss.sgi.com>; Tue, 16 Aug 2016 12:37:35 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 24D8C304048
	for <xfs@oss.sgi.com>; Tue, 16 Aug 2016 10:37:34 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id fLk47N9Il1cS5y4y for <xfs@oss.sgi.com>;
	Tue, 16 Aug 2016 10:37:32 -0700 (PDT)
Received: from [10.0.0.4] (liberator [10.0.0.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id D54C24423
	for <xfs@oss.sgi.com>; Tue, 16 Aug 2016 12:37:31 -0500 (CDT)
Subject: Re: XFS on top of LVM span in AWS. Stripe or are AG's good enough?
References: <CY1PR04MB20100FE6C3039717BD27825AAC120@CY1PR04MB2010.namprd04.prod.outlook.com>
	<20160816005931.GD19025@dastard>
	<CY1PR04MB20106F50E177A61934986A92AC130@CY1PR04MB2010.namprd04.prod.outlook.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <6ec8fbba-27ff-7386-e72a-d9f8e81f9252@sandeen.net>
Date: Tue, 16 Aug 2016 12:37:31 -0500
MIME-Version: 1.0
In-Reply-To: <CY1PR04MB20106F50E177A61934986A92AC130@CY1PR04MB2010.namprd04.prod.outlook.com>
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

On 8/16/16 12:05 PM, Jeff Gibson wrote:
>> On Mon, Aug 15, 2016 at 11:36:14PM +0000, Jeff Gibson wrote:

...

>> Define "run". AGs can allocate/free blocks in parallel.
> By run I meant read/write data to/from the AGs.
> 
>> If IO does
>> not require allocation, then AGs play no part in the IO path.
> Can you explain this a bit please? From my understanding data is
> written and read from space inside of AGs, so I don't see how it
> couldn't be part of the IO path. Or do you simply mean reads just use
> inodes and don't care about the AGs?

I think Dave just means that IO to already-allocated blocks simply
addresses the block and goes.  There is no AG locking or concurrency or
anything else that comes into play w.r.t. the specific AG the block
under IO happens to live in.

>>> In a
>>> non-striped volume, if some of the AGs are temporarily slower to
>>> respond than others due to one of the underlying volumes being
>>> slow, will XFS prefer the quicker responding AGs
>>
>> No, it does not.
>>
>>> or is I/O always
>>> evenly distributed?
>>
>> No, it is not.
>>
>>> If XFS prefers the more responsive AG's it
>>> seems to me that it would be better NOT to stripe the underlying
>>> disk since all AG's that are distributed in a stripe will
>>> continuously hit all component volumes, including the slow volume
>>> (unless if XFS compensates for this?)
>>
>> I think you have the wrong idea about what allocation groups do.

> I'm reading the XFS File System Structure doc on xfs.org. It says,
> "XFS filesystems are divided into a number of equally sized chunks
> called Allocation Groups. Each AG can almost be thought of as an
> individual filesystem." so that's where most of my assumptions are
> coming from.

Well, the above quote is correct, but it doesn't say anything about
IO time, latency, responsiveness, or anything like that.  Each AG
does indeed include its own structures to track allocation, but that's
unrelated to any notion of "fast" or "slow."

>> They are for maintaining allocation concurrency and locality of
>> related objects on disk - they have no influence on where IO is
>> directed based on IO load or response time.

> I understand that XFS has locality as far as trying to write files to
> the same AG as the parent directory. Are there other cases?

In general, new directories go to a new AG.  Inodes within that directory
tend to stay in the same AG as their parent, and data blocks associated
with those inodes tend to stay nearby as well.  That's the high-level
goal, but of course fragmented freespace and near-full conditions can
cause that to not remain true.

> I get that it's probably not measuring the responsiveness of each AG.

It is *definitely* not measuring the responsiveness of each AG :)

> I guess what I'm trying to ask is - will XFS *indirectly* compensate
> if one subvolume is busier?  For example, if writes to a "slow"
> subvolume and resident AGs take longer to complete, will XFS tend to
> prefer to use other less-busy AGs more often (with the exception of
> locality) for writes?  What is the basic algorithm for determining
> where new data is written?  In load-balancer terms, does it
> round-robin, pick the least busy, etc?

xfs has no notion of fast vs slow regions.  See above for the basic
algorithm; it's round-robin for new directories, keep inodes and blocks
near their parent if possible.  There are a few other smaller-granularity
heuristics related to stripe geometry as well.

-Eric

> Thank you very much!
> JG
>     
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
