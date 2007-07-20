Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 20 Jul 2007 09:22:06 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6KGM3bm000482
	for <xfs@oss.sgi.com>; Fri, 20 Jul 2007 09:22:04 -0700
Date: Fri, 20 Jul 2007 12:22:05 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Software RAID 5 - Two reads are faster than one on a SW RAID5?
In-Reply-To: <20070720155808.GA21547@csclub.uwaterloo.ca>
Message-ID: <Pine.LNX.4.64.0707201221310.508@p34.internal.lan>
References: <Pine.LNX.4.64.0707200952270.25069@p34.internal.lan>
 <20070720155808.GA21547@csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, apiszcz@solarrain.com



On Fri, 20 Jul 2007, Lennart Sorensen wrote:

> On Fri, Jul 20, 2007 at 09:58:50AM -0400, Justin Piszcz wrote:
>> I have a multi-core Q6600 CPU on a 10-disk Raptor RAID 5 running XFS.
>>
>> I just pulled down the Debian Etch 4.0 DVD ISO's, one for x86 and one for
>> x86_64, when I ran md5sum -c MD5SUMS, I see ~280-320MB/s.  When I ran the
>> second one I see upwards of what I should be seeing 500-520MB/s.
>>
>> NOTE:: These MD5 contain the 3 DVD ISO's for each platform, 6 total ISOs.
>>
>> I know md5sum is cpubound to a degree, do you think that is what is
>> happening here?  Each core can only sustain ~300MB/s and then with two of
>> four cores working, it can exceed that amount or is there some similarity
>> with RAID1 in linux compared to RAID5?
>>
>> With RAID1, if you use a single read thread, you will get 60-70MB/s read
>> on a dual raptor raid1.  If you use two(?) or three threads, it will read
>> from both disks and you will see 120-140MB/s.
>>
>> Is there some commonality with software RAID1 and RAID5 in Linux in this
>> regard?
>
> Could you just run top while doing md5sum and see how much cpu md5sum is
> using on the cpu it is on?  After all if it says 100% for the process,
> then yes it is cpu bound at 300MB/s, and if not then I guess there has
> to be another explanation.


   PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
   679 abc       23   0  4092  512  432 R   92  0.0   0:02.77 md5sum

$ /usr/bin/time md5sum debian-40r0-i386-DVD-1.iso
79f5bcbb36335e14142fc3578b1de96e  debian-40r0-i386-DVD-1.iso
10.69user 3.52system 0:14.47elapsed 98%CPU (0avgtext+0avgdata 0maxresident)k
0inputs+0outputs (1major+205minor)pagefaults 0swaps

Looks like it.

>
> It looks pretty likely, since I just tried running md5sum on a 130MB
> file here, and it takes 0.444s of user cpu time and 0.068s of system
> time to process, and I ran it multiple times so the file ended up cached
> in ram so disk speed isn't a concern, which I figure means my system
> runs md5sum at about 250MB/s.  This is on a single core Athlon 64 3500+
> (2.2GHz).  So if you have a slightly faster as you do with a 2.4GHz Core
> 2, then 300MB/s seems perfectly reasonable per core.  I don't quite know
> how md5 hashes work, but I really doubt they are something you are
> likely to be able to make threaded.
>
> --
> Len Sorensen
>
