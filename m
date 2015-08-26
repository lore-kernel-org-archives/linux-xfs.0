Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B40417F37
	for <xfs@oss.sgi.com>; Wed, 26 Aug 2015 13:44:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 856298F8035
	for <xfs@oss.sgi.com>; Wed, 26 Aug 2015 11:44:23 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id YcC4BwZ4ufgnO8Su for <xfs@oss.sgi.com>;
	Wed, 26 Aug 2015 11:44:18 -0700 (PDT)
Message-ID: <55DE08FF.10904@sandeen.net>
Date: Wed, 26 Aug 2015 13:44:15 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Performance impact of mkfs.xfs vs mkfs.xfs -f
References: <CABppvi6GdaTQgqpYJi6RhkpjP9ydTV8-2VV8LF9tHSN63XzWtA@mail.gmail.com>	<55DCE1CF.5030708@sandeen.net>	<CABppvi6W5_1GBrb8x1wOAq3X6yraTtt1UYEFE+dBzcXj3yTzrg@mail.gmail.com>	<20150825234300.GN714@dastard>
	<CABppvi7AYbqiskyrEp3As6RPyRz0pThoqVEcjX4736KV-wLkCA@mail.gmail.com>
In-Reply-To: <CABppvi7AYbqiskyrEp3As6RPyRz0pThoqVEcjX4736KV-wLkCA@mail.gmail.com>
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
To: Shrinand Javadekar <shrinand@maginatics.com>, Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 8/26/15 12:48 PM, Shrinand Javadekar wrote:
> Please see my responses inline. I am seeing this behavior again.
> 
> On Tue, Aug 25, 2015 at 4:43 PM, Dave Chinner <david@fromorbit.com> wrote:
>> On Tue, Aug 25, 2015 at 04:09:33PM -0700, Shrinand Javadekar wrote:
>>> I did this on 2 different setups.
>>
>> Details?
> 
> [Shri] On hardware box 1:
> 
> 1. # of disks: 23
> 2. Type: Rotational disks
> 3. Ran mkfs.xfs and mounted disks
> 4. Installed Swift
> 5. Ran benchmark

Details of "the benchmark?"  (buffered or direct?  IO sizes, file layout etc?)

> 6. Stopped Swift
> 7. unmounted disks
> 8. mkfs.xfs -f on all 23 disks
> 9. mounted disks
> 10. Installed Swift
> 11. Ran benchmark

<snip>

>>>> What version of xfsprogs are you using?
>>>
>>> # xfs_repair -V
>>> xfs_repair version 3.1.9
>>
>> That's pretty old.
> 
> [Shri] We're using xfs progs version 3.1.9 whereas the kernel is newer
> one: 3.16.0-38-generic. Does that matter?
> For e.g. one of my colleagues found that the formatting with crc
> enabled is only available in newer version of xfsprogs.

It's fine to use xfsprogs 3.1.9 with kenrel 3.16.  (In fact nothing
is going to be problematic, other than possibly running into unknown
features if one is too far out of sync with the other.  In that case,
you'd just get a hard stop on the unknown feature, not a cryptic
behavior...)

>>
>>>> What was the output of mkfs.xfs each time; did the geometry differ?
>>>
>>> I have the output of xfs_info /mount/point from the first experiment
>>> and that of mkfs.xfs -f. One difference I see is that reformatting
>>> adds projid32bit=0 for the inode section.
>>
>> xfs_info didn't get projid32bit status output until 3.2.0.
>>
>> Anyway, please post the output so we can see the differences for
>> ourselves. What we need is mkfs output in both cases, and xfs_info
>> output in both cases after mount.
> 
> Step 1: mkfs.xfs

<snip>

Ok, the mkfs output & xfs_info output is identical with and without
-f (as they should be).

What is your storage, i.e. what's behind
/dev/mapper/35000c50062e6a567-part2 ?  Is it thinly-provisioned, or
anything else interesting like that?  (thin provisioning probably
shouldn't matter, because in theory we discard the whole device
on mkfs anyway).  But is it possible that the first benchmark
primed the storage in some way?  To that end, what does:

1) mkfs.xfs, benchmark
2) benchmark

show?  is the 2nd one faster as well?

Or, possibly:

1) mkfs.xfs, benchmark
2) mkfs.xfs -f, benchmark
3) wipefs, mkfs.xfs, benchmark

That would leave old xfs superblocks in place for the 3rd test, and
not wiped by mkfs itself, but I can't imagine why that would matter.

(mkfs should reinitialize them anyway, I think the call to
zero_old_xfs_structures() is just so that an xfs_repair search for
backups won't find old unrelated signatures from a prior different
geometry...)

Right now I'm actually wondering more about your storage, I guess.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
