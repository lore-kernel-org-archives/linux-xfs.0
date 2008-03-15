Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 14 Mar 2008 21:23:49 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2F4Nepb021006
	for <xfs@oss.sgi.com>; Fri, 14 Mar 2008 21:23:41 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BF9316A39E3
	for <xfs@oss.sgi.com>; Fri, 14 Mar 2008 21:24:12 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id BqzSLg4XzK0Tnbrc for <xfs@oss.sgi.com>; Fri, 14 Mar 2008 21:24:12 -0700 (PDT)
Message-ID: <47DB4F4F.8030407@sandeen.net>
Date: Fri, 14 Mar 2008 23:23:43 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] fix dir2 shortform structures on ARM old ABI
References: <47DB4181.7040603@sandeen.net> <20080315041722.GA25621@josefsipek.net>
In-Reply-To: <20080315041722.GA25621@josefsipek.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Josef 'Jeff' Sipek <jeffpc@josefsipek.net>
Cc: xfs-oss <xfs@oss.sgi.com>

Josef 'Jeff' Sipek wrote:
> On Fri, Mar 14, 2008 at 10:24:49PM -0500, Eric Sandeen wrote:
>> This should fix the longstanding issues with xfs and old ABI
>> arm boxes, which lead to various asserts and xfs shutdowns,
>> and for which an (incorrect) patch has been floating around
>> for years.  (Said patch made ARM internally consistent, but
>> altered the normal xfs on-disk format such that it looked
>> corrupted on other architectures):
>> http://lists.arm.linux.org.uk/lurker/message/20040311.002034.5ecf21a2.html
> ...
>> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
>>
>> ---
>>
>> Index: linux-2.6.24/fs/xfs/linux-2.6/xfs_linux.h
>> ===================================================================
>> --- linux-2.6.24.orig/fs/xfs/linux-2.6/xfs_linux.h
>> +++ linux-2.6.24/fs/xfs/linux-2.6/xfs_linux.h
>> @@ -300,4 +300,11 @@ static inline __uint64_t howmany_64(__ui
>>  	return x;
>>  }
>>  
>> +/* ARM old ABI has some weird alignment/padding */
>> +#if defined(__arm__) && !defined(__ARM_EABI__)
>> +#define __arch_pack __attribute__((packed))
>> +#else
>> +#define __arch_pack
>> +#endif
> 
> Shouldn't this be unconditional? Just because it ends up being ok on x86
> doesn't mean that it won't break some time later on...(do we want another
> bad_features2 incident?)

I think that packing structures when they don't need to be can actually
be harmful, efficiency-wise.  I read a nice explanation of this....
which I can't find now.

-Eric
