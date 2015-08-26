Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 07EB07F37
	for <xfs@oss.sgi.com>; Wed, 26 Aug 2015 12:10:47 -0500 (CDT)
Message-ID: <55DDF312.1050402@sgi.com>
Date: Wed, 26 Aug 2015 12:10:42 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfsdump: prevent segfault in cb_add_inogrp
References: <20150924193241.975348815@gulag1.americas.sgi.com>
	<55DDEC60.4040509@sandeen.net>
In-Reply-To: <55DDEC60.4040509@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On 08/26/2015 11:42 AM, Eric Sandeen wrote:
> On 8/26/15 9:33 AM, rjohnston@sgi.com wrote:
>> The call to memset will segfault because the offset for the first
>> parameter is done twice. We are using pointer math to do the
>> calculation.
>> The first time is when calculating oldsize, the size of i2gseg_t
>> is accounted for.
>> 	oldsize = (numsegs - SEGPERHNK) * sizeof(i2gseg_t);
>> Then in the call to memset, oldsize is again multiplied by the size
>> of i2gmap_t.
>> 	memset(inomap.i2gmap + oldsize, ...)
>> 	
>> i2gmap holds the used inodes in each chunk. When there are 2^31 chunk
>> entries, it could describe 2^31 (1 inode/chunk)- 2^40 (64 inodes/chunk).
>>
>> With 100s of millions of inodes there are enough entries to wrap the
>> 32 bit variable oldsize.
>>
>> Switching to use array index notation instead of calculating the
>> pointer address twice ;) would resolve this issue. The unneeded
>> local variable oldsize can be removed as well.
>
> Ok, this doesn't explain the type change for numsegs, does it?
Nope that was a typo, as it is an array index I meant to change it from
a signed int (intgen_t) to an unsigned (uint32_t).
>
> Can you walk me through why that's needed?  At what point would
> numsegs = inomap.hnkmaplen * SEGPERHNK; overflow?

>
> Thanks,
> -Eric
>
>> ---
>>   dump/inomap.c |    8 ++------
>>   1 file changed, 2 insertions(+), 6 deletions(-)
>>
>> Index: b/dump/inomap.c
>> ===================================================================
>> --- a/dump/inomap.c
>> +++ b/dump/inomap.c
>> @@ -1125,8 +1125,7 @@ cb_add_inogrp( void *arg1, intgen_t fsfd
>>   		lastsegp->segoff = 0;
>>
>>   		if (lastsegp->hnkoff == inomap.hnkmaplen) {
>> -			intgen_t numsegs;
>> -			intgen_t oldsize;
>> +			int64_t numsegs;

>>
>>   			inomap.hnkmaplen++;
>>   			inomap.hnkmap = (hnk_t *)
>> @@ -1140,10 +1139,7 @@ cb_add_inogrp( void *arg1, intgen_t fsfd
>>   				return -1;
>>
>>   			/* zero the new portion of the i2gmap */
>> -			oldsize = (numsegs - SEGPERHNK) * sizeof(i2gseg_t);
>> -
>> -			memset(inomap.i2gmap + oldsize,
>> -			       0,
>> +			memset(&inomap.i2gmap[numsegs - SEGPERHNK], 0,
>>   			       SEGPERHNK * sizeof(i2gseg_t));
>>   		}
>>
>>
>> _______________________________________________
>> xfs mailing list
>> xfs@oss.sgi.com
>> http://oss.sgi.com/mailman/listinfo/xfs
>>
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
