Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB85Fijl001626 for <xfs@oss.sgi.com>; Sun, 7 Dec 2008 23:15:44 -0600
Message-ID: <493CAD9E.4000304@sgi.com>
Date: Mon, 08 Dec 2008 16:16:14 +1100
From: Lachlan McIlroy <lachlan@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] Fix off by one error in page_region_mask()
References: <49378B60.1060603@sgi.com> <493CA59C.302@sgi.com>
In-Reply-To: <493CA59C.302@sgi.com>
Reply-To: lachlan@sgi.com
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Timothy Shimmin <tes@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

Timothy Shimmin wrote:
> Lachlan McIlroy wrote:
>> final is calculated to be the last bit to set (ie inclusive) but when we
>> do the mask shifting final really needs to be first bit not to set.
>>
>> For example if first and final are both bit 0 (ie only first bit to be set)
>> then mask is completely shifted and becomes all zeroes.
>>
>> Or if first is 0 and final is 63 then the mask is shifted one bit when it
>> shouldn't be shifted at all.
>>
>> --- xfs-fix.orig/fs/xfs/linux-2.6/xfs_buf.c
>> +++ xfs-fix/fs/xfs/linux-2.6/xfs_buf.c
>> @@ -129,15 +129,17 @@ page_region_mask(
>>   	int		first, final;
>>
>>   	first = BTOPR(offset);
>> -	final = BTOPRT(offset + length - 1);
>> -	first = min(first, final);
>> +	final = BTOPRT(offset + length);
>> +
>> +	if (first >= final)
>> +		return 0UL;
>>
>>   	mask = ~0UL;
>>   	mask <<= BITS_PER_LONG - (final - first);
>>   	mask >>= BITS_PER_LONG - (final);
>>
>>   	ASSERT(offset + length <= PAGE_CACHE_SIZE);
>> -	ASSERT((final - first) < BITS_PER_LONG && (final - first) >= 0);
>> +	ASSERT((final - first) <= BITS_PER_LONG && (final - first) > 0);
>>
>>   	return mask;
>>   }
>>
>> _______________________________________________
>> xfs mailing list
>> xfs@oss.sgi.com
>> http://oss.sgi.com/mailman/listinfo/xfs
> 
> Gee, I always find these tricky to get right.
> I tend to like a userspace version and input various ranges,
> such as extremes like you did, and verify it is working.
> 
> I kind of like first and final to be inclusive of the range to be set
> (not so keen on making final to be first bit not to set -
> name doesn't seem so good then).
Using an inclusive final means we have to add 1 every time we use it - which
we could forget to do and maybe that was how this bug got introduced.

I would prefer a starting bit and a bit count but I was trying to limit
changes to a minimum.

We can change the name of final if you like.

> And if one needs to know the size of the range to use (final - first + 1)
> and for 0..final => size = final-0+1 = final+1.
> 
> And the thing about min(first, final) and (first >= final),
> is interesting - I would have thought final would be expected to be >=
> to the first ??
It wasn't the case with the old scheme.

If we have a 64KB page size then each bit is 1024 bytes and if we read the
second sector of a page:

first = BTOPR(512) = (512+1023)/1024 = 1
final = BTOPRT(512 + 512 - 1) = (1023/1024) = 0

So the off by one error creates a special case that we need to handle.
This shouldn't happen (first > final) if we remove the magic subtract 1
business:

final = BTOPRT(512 + 512) = (1024/1024) = 1

But should anyone pass in bad values that are not sector aligned this
assumption wont hold so be defensive and leave the > check in.  If we
know that the resultant mask should be all zeroes then bail early and
don't stuff around bit shifting a mask for nothing.

> 
> Okay, the other thing that interests me is the use of both BTOPR and BTOPRT
> for given offsets.
> BTOPR is the typical howmany() implementation, where if you go over
> a multiple-boundaries worth then you need another multiple.
> I would expect it to have values starting from 1.
> So I was thinking typically of BTOPR for sizes and BTOPRT for 0-based offsets.
> e.g. given multiple, 512
> BTOPR  1..512 => 1, 513..1024 => 2
> BTOPRT 0..511 => 0, 512..1023 => 1
These macros are used to round the boundaries inwards.  BTOPR rounds
up and BTOPRT rounds down.  We cannot flag partial regions as up to
date because we could expose bad data.  Actually if we have to round
then we've got a problem because if we have regions that are active
but not marked up to date we risk re-reading them and overwriting
in-memory changes.

> 
> So I find the code a bit hard to follow then.
> 
> --Tim
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
