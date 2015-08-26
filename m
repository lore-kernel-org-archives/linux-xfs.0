Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 3737C7F37
	for <xfs@oss.sgi.com>; Wed, 26 Aug 2015 17:27:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 05E9B8F8037
	for <xfs@oss.sgi.com>; Wed, 26 Aug 2015 15:27:38 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id yoFKbWmtIyeCsLqV for <xfs@oss.sgi.com>;
	Wed, 26 Aug 2015 15:27:36 -0700 (PDT)
Message-ID: <55DE3D58.5090706@sandeen.net>
Date: Wed, 26 Aug 2015 17:27:36 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH V2] xfsdump: prevent segfault in cb_add_inogrp
References: <20150924193241.975348815@gulag1.americas.sgi.com>	<55EDF3BA.60409@sgi.com>	<20150826213746.GC3902@dastard>
	<55DE3651.5030803@sgi.com> <55DE3B7B.8010608@sandeen.net>
In-Reply-To: <55DE3B7B.8010608@sandeen.net>
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
To: Rich Johnston <rjohnston@sgi.com>, Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 8/26/15 5:19 PM, Eric Sandeen wrote:
> On 8/26/15 4:57 PM, Rich Johnston wrote:
>> Dave,
>>
>> On 08/26/2015 04:37 PM, Dave Chinner wrote:
>>> On Wed, Aug 26, 2015 at 12:36:42PM -0500, rjohnston@sgi.com wrote:
>>>> The call to memset will segfault because the offset for the first
>>>> parameter is done twice. We are using pointer math to do the
>>>> calculation.
>>>> The first time is when calculating oldsize, the size of i2gseg_t
>>>> is accounted for.
>>>>     oldsize = (numsegs - SEGPERHNK) * sizeof(i2gseg_t);
>>>> Then in the call to memset, oldsize is again multiplied by the size
>>>> of i2gmap_t.
>>>>     memset(inomap.i2gmap + oldsize, ...)
>>>>     
>>>> i2gmap holds the used inodes in each chunk. When there are 2^31 chunk
>>>> entries, it could describe 2^31 (1 inode/chunk)- 2^40 (64 inodes/chunk).
>>>>
>>>> With 100s of millions of inodes there are enough entries to wrap the
>>>> 32 bit variable oldsize.
>>>>
>>>> Switching to use array index notation instead of calculating the
>>>> pointer address twice ;) would resolve this issue. The unneeded
>>>> local variable oldsize can be removed as well.
>>>>
>> Per your other comment I will add a bounds check after calculating numsegs:
>>     if (numsegs < 0)
>>         return -1;
> 
> probably fine, but probably not really necessary.
> 
> numsegs = inomap.hnkmaplen * SEGPERHNK;
> 
> hnkmaplen initializes as:
> 
> inomap.hnkmaplen = (igrpcnt + SEGPERHNK - 1) / SEGPERHNK;
> 
> From my prior email, if I was right,
> 
>> so I guess that means that if we have more than 2^31 inode groups,
>> i.e. 2^31 * 256 = 500 billion inodes, (int) igrpcnt could overflow.
> 
> so unless you have > 500 billion inodes, it's not going to be a problem...

sorry, then * SEGPERHNK (511), so overflow around 1 billion inodes.

Yeah, ok, closer to a possibility, maybe worth being defensive after
all.  :)

thanks,
-Eric

> I'd just focus on the single problem at hand (extending a pointer
> to an array by number of bytes, not number of elements) and leave it
> at that.
> 
> -Eric
> 
>> The description above will change to:
>>
>> Adding a bounds check (numsegs < 0) and switching to use array
>> index notation instead of calculating the pointer address twice ;)
>> would resolve this issue. The unneeded local variable oldsize
>> can be removed as well.
>>
>>>> numsegs is used to calculate an array index, change it from a
>>>> signed int (intgen_t) to an unsigned (uint32_t).
>>>
>> I will remove the above description and leave it as is (intgen_t)
>>> Description does not match code:
>>>
>>>> -            intgen_t numsegs;
>>>> -            intgen_t oldsize;
>>>> +            int32_t numsegs;
>>>
>>> It's still a signed int here. And, really, just a plain old "int" is
>>> fine here.
>>>
>>> Cheers,
>>>
>>> Dave.
>>>
>>
>> _______________________________________________
>> xfs mailing list
>> xfs@oss.sgi.com
>> http://oss.sgi.com/mailman/listinfo/xfs
>>
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
