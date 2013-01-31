Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E19E67F4E
	for <xfs@oss.sgi.com>; Thu, 31 Jan 2013 14:23:41 -0600 (CST)
Message-ID: <510AD2E2.1020309@sgi.com>
Date: Thu, 31 Jan 2013 14:24:02 -0600
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 1/3] xfs: add agskip=value mount option
References: <20130129153914.801475275@sgi.com>
	<20130129153914.976867239@sgi.com>
	<20130130010430.GE7255@disturbed.disaster>
	<20130130233203.GP27055@sgi.com>
	<20130131061321.GI32297@disturbed.disaster>
In-Reply-To: <20130131061321.GI32297@disturbed.disaster>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Ben Myers <bpm@sgi.com>, xfs@oss.sgi.com

Hey Dave,

On 01/31/2013 12:13 AM, Dave Chinner wrote:
> On Wed, Jan 30, 2013 at 05:32:03PM -0600, Ben Myers wrote:
>> Hey Dave,
>>
>> On Wed, Jan 30, 2013 at 12:04:30PM +1100, Dave Chinner wrote:
>>> On Tue, Jan 29, 2013 at 09:39:15AM -0600, rjohnston@sgi.com wrote:
>>>> The agskip mount option specifies  the allocation group, (AG) for a new
>>>> file, relative to the start of the last created file. agskip has the
>>>> opposite effect of the rotorstep  system tunable  parameter.   Each
>>>> new  file  to  be placed in the location lastAG + agskipValue,
>>>> where lastAG is the allocation group of the last created file.
>>>>
>>>> For example, agskip=3 means each new file will be  allocated  three  AGs  away
>>>> from the starting AG of the most recently created file.
>>>
>>> Overall, I'm wondering if this is the right way to approach this
>>> problem.
>>
>> We'll have to make sure we all understand the problem we're trying to solve
>> with this before going too far.
>
> I'm in no doubt about what it is for - I know the exact history of
> this patch and exactly what problems it was designed to solve
> because....
>
>>> It only really works correctly (in terms of distribution of
>>> files/metadata) for fixed volume sizes (i.e. homogenous layouts) -
>>> the common case where a skip is useful is after growing a filesystem
>>> onto a new volume. It's rare that the new volume is the same as the
>>> existing volumes, so it's hard to set a skip value that reliably
>>> alternates between old and new volumes.
>>
>> Based upon what I've read so far on the internal bug when this was introduced,
>> this is more about being able to utilize all allocation groups in a filesystem
>> with many concats.
>
> ... I was still at SGI when that bug was raised and the ag_skip
> patch was written for the "Enhanced XFS" module in the NAS product
> SGI was selling at the time. It was written as a quick stopgap by
> the NAS product engineers to counter the problems being seen on that
> product due to the nature of the "concat of stripes" storage
> configuration that product used.
>
> It was never was proposed as an upstream solution because I NACKed
> it internally.  Indeed, at the time I was already well down the path
> of fixing the problem in XFS in a much more capable way. i.e.  this
> stuff:
>

I did not see any references to the patchset you referenced below when I 
was  working on submitting this patchset. Thanks for pointing it out.

> http://oss.sgi.com/archives/xfs/2009-02/msg00250.html

The patchset (pluggable allocation policies) above looks very promising 
and I would like to port it to top of tree and use it instead of my 
agskip proposal.  Are there any changes to this patchset we should 
discuss before I start.

Thanks
--Rich

> http://oss.sgi.com/archives/xfs/2009-02/msg00253.html
>
> And that was planned to replace the agskip hack in the next NAS
> product release. Unfortunately, once I left SGI nobody picked up the
> work I was doing and "Enhanced XFS" turned into a zombie.  Indeed,
> agskip was posted back here in 2009 as part of the same code dump as
> the above patches when the XFS group in Melbourne was let go:
>
> http://oss.sgi.com/archives/xfs/2009-02/msg00252.html
>
> There's a bit of history to this patch ;)
>
>> It's not so much related to balance after growing a
>> filesystem (which is another interesting problem).  The info should be added to
>> this series and be reposted.
>
> Actually, that was one of the problems the patch solved on the NAS
> product. It was a secondary problem as growing wasn't a common
> operation, but it was definitely a concern....
>
>>> We talked about this allocation distribution problem last march when
>>> we met at LSF, and I thought we agreed that pushing
>>> agskip/agrotorstep mount options upstream was not the way we were
>>> going to solve this problem after I outlined how I planned to solve
>>> this problem.
>>
>> If we can come up with something better, that's great.  But AFAICT the problem
>> still needs to be addressed.  This is just one way to do it.
>
> I'm not saynig that it doesn't need to be addressed. I'm just saying
> the sam ething I said 5 years ago: there's no point pushing it into
> mainline when far more comprehensive solution is just around the
> corner....
>
> Cheers,
>
> Dave.
>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
