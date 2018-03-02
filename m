Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:46308 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932131AbeCBVwa (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 2 Mar 2018 16:52:30 -0500
Subject: Re: [PATCH] xfs_io: fix operation time reporting
References: <20180301035645.32633-1-david@fromorbit.com>
 <f401cfc2-fdcd-15e7-4c1a-254bbe00c2fa@sandeen.net>
 <20180302214919.GP30854@dastard>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <afd87105-6d6b-0fad-9e8d-29ab760c6f3e@sandeen.net>
Date: Fri, 2 Mar 2018 15:52:29 -0600
MIME-Version: 1.0
In-Reply-To: <20180302214919.GP30854@dastard>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On 3/2/18 3:49 PM, Dave Chinner wrote:
> On Thu, Mar 01, 2018 at 10:00:52PM -0600, Eric Sandeen wrote:
>> On 2/28/18 9:56 PM, Dave Chinner wrote:
>>> From: Dave Chinner <dchinner@redhat.com>
>>>
>>> CUrrently the 100th/sec units always report zero, such as:
>>>
>>> 32 MiB, 8192 ops; 0:00:21.00 (1.476 MiB/sec and 377.9260 ops/sec)
>>>                           ^^
>>>
>>> This is incorrect. Fix the maths that is wrong by removing all the
>>> unnecesary floating point maths and just using basic integer
>>> division...
>>>
>>> Signed-Off-By: Dave Chinner <dchinner@redhat.com>
>>> ---
>>>  libxcmd/input.c | 16 ++++++++--------
>>>  1 file changed, 8 insertions(+), 8 deletions(-)
>>>
>>> diff --git a/libxcmd/input.c b/libxcmd/input.c
>>> index 441bb2fbbf34..6e7a8c9822ee 100644
>>> --- a/libxcmd/input.c
>>> +++ b/libxcmd/input.c
>>> @@ -154,9 +154,10 @@ tdiv(double value, struct timeval tv)
>>>  	return value / ((double)tv.tv_sec + ((double)tv.tv_usec / 1000000.0));
>>>  }
>>>  
>>> -#define HOURS(sec)	((sec) / (60 * 60))
>>> -#define MINUTES(sec)	(((sec) % (60 * 60)) / 60)
>>> -#define SECONDS(sec)	((sec) % 60)
>>> +#define HOURS(sec)		((sec) / (60 * 60))
>>> +#define MINUTES(sec)		(((sec) % (60 * 60)) / 60)
>>> +#define SECONDS(sec)		((sec) % 60)
>>> +#define USEC_TO_100THS(usec)	((usec) / 1000 / 10)
>>
>> I guess this works but I expected to convert "microseconds to 100ths"
>> via a conversion like:
>>
>> usec * 1sec/1000000usec * 100 hundredths/1sec
> 
> That's what the old code tried to do with floating point math and
> casts, but that didn't work.
> 
>> so just for readability I'd have expected:
>>
>> #define USEC_TO_100THS(usec)	((usec) / 1000000 * 100)
> 
> Welcome to Integer Math 101: Integer Division. You'll always get
> zero, because N / M = 0 when N < M.

hm, right.

>> or possibly just
>> #define USEC_TO_100THS(usec)	((usec) / 10000)
>>
>> ... I'm confused by your choice of orders of magnitude above even
>> though it works - it seems a bit random to divide it that way,
>> unless I'm missing something?
>>
>> (I had a physics teacher who drilled THINK UNITS BEFORE YOU THINK
>> NUMBERS" into my head an I still do) :)
> 
> Yeah, I did. I did us->ms first, then ms->100ths. i.e.:
> 
> 	milliseconds = usec / 1000
> 	hundreths = ms / 10.
> 
> This should be obvious to anyone who uses the metric system for
> units of measurement.

I see what you did there!

ok.

Well, whatever.  I can merge it as is if you like, and hope the
next person to read it is smarter than I am.  Shouldn't be hard.

-Eric
