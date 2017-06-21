Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:56526 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750827AbdFUUdR (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 21 Jun 2017 16:33:17 -0400
Subject: Re: [PATCH 02/12] libxcmd: add cvt{int, long} to convert strings to
 int and long
References: <149755894900.3625.8076720525369136771.stgit@birch.djwong.org>
 <149755896133.3625.13813626356334626083.stgit@birch.djwong.org>
 <6c0086a3-d1db-baa0-f0a4-be1c6d2cebe7@sandeen.net>
 <20170621202951.GM4733@birch.djwong.org>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <9309853e-b9c0-e9a3-7821-78803d33f0d6@sandeen.net>
Date: Wed, 21 Jun 2017 15:33:16 -0500
MIME-Version: 1.0
In-Reply-To: <20170621202951.GM4733@birch.djwong.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: sandeen@redhat.com, linux-xfs@vger.kernel.org

On 6/21/17 3:29 PM, Darrick J. Wong wrote:
> On Wed, Jun 21, 2017 at 03:16:37PM -0500, Eric Sandeen wrote:

...

>>> --- a/libxcmd/input.c
>>> +++ b/libxcmd/input.c
>>> @@ -149,6 +149,140 @@ numlen(
>>>  	return len == 0 ? 1 : len;
>>>  }
>>>  
>>> +/*
>>> + * Convert string to int64_t, set errno if the conversion fails or
>>> + * doesn't fit.  Does not allow unit specifiers.  Sets errno to zero
>>> + * prior to conversion.
>>> + */
>>> +int64_t
>>> +cvt_s64(
>>> +	char		*s,
>>> +	int		base)
>>> +{
>>> +	long long	i;
>>> +	char		*sp;
>>> +	int		c;
>>
>> unused var c
>>
>>> +
>>> +	errno = 0;
>>> +	i = strtoll(s, &sp, base);
>>> +	if (*sp == '\0' && sp != s)
>>> +		return i;
>>> +bad:
>>
>> label bad: defined but not used
> 
> Fixed.  Sorry about the stupidity. :(

no problem, things like this make me feel better :D

> 
>>> +	errno = -ERANGE;
>>> +	return INT64_MIN;
>>
>> Hm, doesn't strtoll return LLONG_MIN or LLONG_MAX for underflows
>> and overflows?  Do you really want to return MIN even if this /overflowed/?
>> (Maybe it doesn't matter, gut its a bit of a departure from strtoll semantics)
> 
> True, it's a departure from the usual semantics.  The intent is to call
> the function this way:
> 
> long foo = cvt_s64(...);
> if (errno) {
> 	fprintf(stderr, "N|_|MB3Rz ARE HARDZ!!1!\n");
> 	exit(5);
> }
> 
> So at least in theory it wouldn't matter what we actually set foo to.

well, that was my next question.  ;)

But setting it to one extreme value leaves me wondering why you'd not set it
to the other extreme.  *shrug*  Not that big a deal, just a thing that made me
go "hmmmm"

-Eric
