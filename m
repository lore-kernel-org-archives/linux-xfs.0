Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:35382 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935400AbdGTUV6 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 20 Jul 2017 16:21:58 -0400
Subject: Re: Collecting aged XFS profiles
References: <F180D8D4-633B-4CC5-8D70-5CAC36233513@cs.cmu.edu>
 <CAAxjCEzevLnmxyVRME1-kT867KjH2rtOdspv7nF6TOfLUDD+xA@mail.gmail.com>
 <20170717234814.GK17762@dastard>
 <CAAxjCEzP=bf5S12J8rTn7EyJK_MeM=t1JSa7pBzZyXK=9TrjQQ@mail.gmail.com>
 <bcb651de-75bf-97a6-7ed8-c083d2a440e5@sandeen.net>
 <CAAxjCEzZ2Q0wL=nhGVHVtK3M5Ws3MQdrUNKm3jJKO+1y-wxTkw@mail.gmail.com>
 <cb16e0b4-2ef2-cdef-e0e3-cf04abd3d4c6@sandeen.net>
 <CAAxjCEwjU+gMszjCWWpv8Vpc+Cx+_b0v9Vvi81d+HC8uy=FGuA@mail.gmail.com>
 <e632fff1-e72a-7b51-1431-aa0903dec5b4@sandeen.net>
 <CAAxjCEzCgKi_r8XY-xOQ2iKKa8RmRPjL9WRXQBi9zzNXa_9WKw@mail.gmail.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <fe347f30-ace2-089e-3137-864c83396951@sandeen.net>
Date: Thu, 20 Jul 2017 15:21:57 -0500
MIME-Version: 1.0
In-Reply-To: <CAAxjCEzCgKi_r8XY-xOQ2iKKa8RmRPjL9WRXQBi9zzNXa_9WKw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Stefan Ring <stefanrin@gmail.com>
Cc: linux-xfs@vger.kernel.org



On 07/20/2017 03:15 PM, Stefan Ring wrote:
> On Thu, Jul 20, 2017 at 4:27 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
>> On 07/20/2017 02:52 AM, Stefan Ring wrote:
>>> On Thu, Jul 20, 2017 at 12:00 AM, Eric Sandeen <sandeen@sandeen.net> wrote:
>>>> ok, that shoulda worked... I wonder how to debug this, if you can't
>>>> legally share the problematic image with me to investigate...
>>>>
>>>> I put a lot of effort into selectively zeroing out unused portions
>>>> of metablocks a couple years back, I am surprised that this much remains.
>>>>
>>>> I wonder if something regressed ...
>>>
>>> I will try if I can find out which code paths lead to the content
>>> being dumped out.
>>
>> Perhaps you could send xfs_info output and offsets of the "safe" strings,
>> and maybe look at block or sector boundaries of the blocks containing
>> those "safe" strings to identify magic numbers which would identify
>> the metadata types ...
>>
> 
> Ok,
> 
> I'm using the for-next branch now (0602fbe880) and inserted something
> like this so I can set a breakpoint on my_break.

Thanks, I'll dig into this a bit.  I thought we had an xfstest that looked
for this sort of leaked string problem, but now I'm not finding it... something
to fix, I guess.

-Eric
