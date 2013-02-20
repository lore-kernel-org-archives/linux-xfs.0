Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0D2B47F4E
	for <xfs@oss.sgi.com>; Wed, 20 Feb 2013 07:15:25 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id F1C5C8F8049
	for <xfs@oss.sgi.com>; Wed, 20 Feb 2013 05:15:21 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 9gONEixVawDeJW1m for
	<xfs@oss.sgi.com>; Wed, 20 Feb 2013 05:15:21 -0800 (PST)
Message-ID: <5124CD01.1050602@redhat.com>
Date: Wed, 20 Feb 2013 08:17:53 -0500
From: Brian Foster <bfoster@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH v3 3/7] xfs: cap prealloc size to free space before shift
References: <1361291851-24714-1-git-send-email-bfoster@redhat.com>
	<1361291851-24714-4-git-send-email-bfoster@redhat.com>
	<20130219214842.GG10731@dastard> <5123FCB7.9050309@redhat.com>
	<20130219231954.GI10731@dastard>
In-Reply-To: <20130219231954.GI10731@dastard>
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
Cc: xfs@oss.sgi.com

On 02/19/2013 06:19 PM, Dave Chinner wrote:
> On Tue, Feb 19, 2013 at 05:29:11PM -0500, Brian Foster wrote:
>> On 02/19/2013 04:48 PM, Dave Chinner wrote:
>>> On Tue, Feb 19, 2013 at 11:37:27AM -0500, Brian Foster wrote:
...
>> Tracking back to that discussion...
>>
>> http://oss.sgi.com/archives/xfs/2013-01/msg00392.html
>>
>> ... my understanding is that at the moment, the condition addressed by
>> the previous change is not relevant to quota since we have no
>> flush/retry cycle (e.g., we just fail early). The intended follow up set
>> to this (eofblocks scan, retry) would introduce such a cycle. What I'm
>> wondering is if we'll need something similar longer term within the
>> quota throttling code.
> 
> There is a retry cycle for EDQUOT - we simply turn off preallocation
> and try again. So, if we ask for all the free blocks in the
> quota....
> 
>>
>> In particular, is the "metadata overhead" referred to in your original
>> explanation accounted against an associated quota,
> 
> ... this *may* trigger an EDQUOT and turn off preallocation.
> 

Good point. I guess I was more thinking about the severity of the
effective "sync write" mode caused by the flush and retry cycle, as
opposed to the loss of prealloc and hit of the retry. The eofblocks scan
shouldn't be as heavy weight as a flush, but that kind of cycle is
undesirable nonetheless.

>> such that it still
>> isn't enough to simply start the prealloc capped at the quota free space
>> limit? If so, perhaps as part of that set I'll need to modify this code
>> to carry a minimum 'qfreesp' through each of the quotas and add that to
>> the squashing loop...
> 
> Probably.
> 
> i.e. it doesn't matter alloc_blocks is over freesp or dquot limits
> at the end of the prealloc size calculation. If it is, we just keep
> squashing it by >>= 4 until it is under all relevant thresholds...
> 

Yeah, that's pretty much what I was thinking. I'll plan to include that
as part of the follow on work that introduces the eofblocks scan. Thanks.

Brian

> Cheers,
> 
> Dave.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
