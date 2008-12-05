Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB54lQDU012240 for <xfs@oss.sgi.com>; Thu, 4 Dec 2008 22:47:26 -0600
Message-ID: <49387CDE.2030904@sgi.com>
Date: Fri, 05 Dec 2008 11:59:10 +1100
From: Lachlan McIlroy <lachlan@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] Fix off by one error in page_region_mask()
References: <49378B60.1060603@sgi.com> <4937FAED.7060503@sandeen.net>
In-Reply-To: <4937FAED.7060503@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

Eric Sandeen wrote:
> Lachlan McIlroy wrote:
>> final is calculated to be the last bit to set (ie inclusive) but when we
>> do the mask shifting final really needs to be first bit not to set.
>>
>> For example if first and final are both bit 0 (ie only first bit to be set)
>> then mask is completely shifted and becomes all zeroes.
>>
>> Or if first is 0 and final is 63 then the mask is shifted one bit when it
>> shouldn't be shifted at all.
> 
> Lachlan, what's the end result of this bug?  What's the broken behavior?

There was no observed bug - well nothing I can tie directly to this code.
I found this by inspection while investigating the page bitmap stuff.
We have a problem with ia64 going to 64K page size with filesystems that
use a filesystem sector size of 512 bytes - we don't have the granularity
we need in the bitmap.

I suppose it is possible this bug could indicate a page region is not up
to date when it actually is and we might re-read something from disk and
overwrite the more up to date in-memory version.

> 
> Thanks,
> -Eric
> 
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
>>
> 
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
