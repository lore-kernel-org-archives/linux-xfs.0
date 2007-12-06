Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 05 Dec 2007 16:02:15 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lB6025YB003564
	for <xfs@oss.sgi.com>; Wed, 5 Dec 2007 16:02:09 -0800
Message-ID: <47573C8A.1060902@sgi.com>
Date: Thu, 06 Dec 2007 11:04:26 +1100
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: [Patch] xfs_lowbit64 broken on ia32
References: <D59801BCA402F5418C040937230AF7E0755AF5@mtv-amer002e--3.americas.sgi.com>
In-Reply-To: <D59801BCA402F5418C040937230AF7E0755AF5@mtv-amer002e--3.americas.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Alex Elder <aelder@sgi.com>
Cc: David Chinner <dgc@sgi.com>, Lachlan Mcllroy <lachlan@sgi.com>, xfs-oss <xfs@oss.sgi.com>, xfs-dev <xfs-dev@sgi.com>

Alex Elder wrote:
> David Chinner wrote:
> . . .
>>>> Index: 2.6.x-xfs-new/fs/xfs/xfs_bit.h
>>>> ===================================================================
>>>> --- 2.6.x-xfs-new.orig/fs/xfs/xfs_bit.h	2007-11-02 
>>>> 13:44:45.000000000 +1100
>>>> +++ 2.6.x-xfs-new/fs/xfs/xfs_bit.h	2007-12-03 
>> 14:43:33.169851481 +1100
>>>> @@ -68,8 +68,8 @@ static inline int xfs_lowbit32(__uint32_
>>>> /* Get low bit set out of 64-bit argument, -1 if none set */
>>>> static inline int xfs_lowbit64(__uint64_t v)
>>>> {
>>>> -	unsigned long	t = v;
>>>> -	return (v) ? find_first_bit(&t, 64) : -1;
>>>> +	unsigned long long	t = v;
>>> Why create a local copy?  Why not just pass v into find_first_bit()?
>> Because I thought that taking the address of a function parameter
>> was a big no-no because the result is undefined (i.e. platform and
>> compiler dependent)?
> 
> I've never heard of this, and it's incorrect--at least with respect
> to standard C.  (But that's not to say in practice some compiler
> does it wrong.)  Unless it's a real (details known) problem you
> shouldn't try to work around it.
> 
> 					-Alex
> 
I've never heard of that either.
(Then again, I didn't know until recently that they changed C
  to allow "flexible array members" in C99
  http://tigcc.ticalc.org/doc/gnuexts.html#SEC75)

--Tim
