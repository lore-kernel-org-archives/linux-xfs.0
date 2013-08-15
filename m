Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C353B7F50
	for <xfs@oss.sgi.com>; Thu, 15 Aug 2013 13:15:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A41C38F8073
	for <xfs@oss.sgi.com>; Thu, 15 Aug 2013 11:15:04 -0700 (PDT)
Received: from mx1.vr-web.de (mx0.vr-web.de [195.200.35.198]) by cuda.sgi.com
	with ESMTP id fMdMzP1gv0xSRPE6 for <xfs@oss.sgi.com>;
	Thu, 15 Aug 2013 11:15:03 -0700 (PDT)
Message-ID: <520D1A8F.6080602@allmail.net>
Date: Thu, 15 Aug 2013 20:14:39 +0200
From: Michael Maier <m1278468@allmail.net>
MIME-Version: 1.0
Subject: Re: Failure growing xfs with linux 3.10.5
References: <52073905.8010608@allmail.net> <5207D9C4.7020102@sandeen.net>
	<5209126F.5020204@allmail.net> <20130813005414.GT12779@dastard>
	<520A48C4.6060801@allmail.net> <20130814054332.GA12779@dastard>
	<520B9F3E.6030805@allmail.net> <20130815005809.GL6023@dastard>
In-Reply-To: <20130815005809.GL6023@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

Dave Chinner wrote:
> On Wed, Aug 14, 2013 at 05:16:14PM +0200, Michael Maier wrote:
>> Dave Chinner wrote:
>>> On Tue, Aug 13, 2013 at 04:55:00PM +0200, Michael Maier wrote:
>>>> Dave Chinner wrote:
>>>>> On Mon, Aug 12, 2013 at 06:50:55PM +0200, Michael Maier wrote:
>>>>>> Meanwhile, I faced another problem on another xfs-file system with linux
>>>>>> 3.10.5 which I never saw before. During writing a few bytes to disc, I
>>>>>> got "disc full" and the writing failed.
>>>>>>
>>>>>> At the same time, df reported 69G of free space! I ran xfs_repair -n and
>>>>>> got:
>>>>>>
>>>>>>
>>>>>> xfs_repair -n /dev/mapper/raid0-daten2
>>>>>> Phase 1 - find and verify superblock...
>>>>>> Phase 2 - using internal log
>>>>>>         - scan filesystem freespace and inode maps...
>>>>>> sb_ifree 591, counted 492
>>>>>> ^^^^^^^^^^^^^^^^^^^^^^^^^
>>>>>> What does this mean? How can I get rid of it w/o loosing data? This file
>>>>>> system was created a few days ago and never resized.
>>>>>
>>>>> Superblock inode counting is lazy - it can get out of sync in after
>>>>> an unclean shutdown, but generally mounting a dirty filesystem will
>>>>> result in it being recalculated rather than trusted to be correct.
>>>>> So there's nothing to worry about here.
>>>>
>>>> When will it be self healed?
>>>
>>> that depends on whether there's actually a problem. Like I said in
>>> the part you snipped off - if you ran xfs_repair -n on filesystem
>>> that needs log recovery that accounting difference is expected.
>>
>> I know, that option -n doesn't do anything. It was intended, because
>> xfs_repair destroyed a lot of data when applied at the other problem I
>> have _and_ it repaired nothing at the same time!
> 
> xfs_repair will remove files it cannot repair because their metadata
> is are too corrupted to repair or cannot be repaired safely. That's
> always been the case for any filesystem repair tool - all they
> guarantee is that the filesystem will be consistent after they are
> run. Repairing a corrupted filesystem almost always results in some
> form of data loss occurring....
> 
> If there is nothing wrong with the filesystem except the accouting
> is wrong, then it will fix the accounting problem in phase 5 when
> run without the -n parameter.

Ok, it's fixed now (w/ the git xfs_repair). Thanks for clarification.
I'm sorry, but I was a little bit scared because of the other problem
:-( I faced.

>>>> This is strange and I can't use the free space, which I need! How can it
>>>> be forced to be repaired w/o data loss?
>>>
>>> The above is complaining about a free inode count mismatch, not a
>>> problem about free space being wrong. What problem are you actually
>>> having?
>>
>> The application, which wanted to write a few bytes gets a "disk full"
>> error although df -h reports 69GB of free space.
> 
> That's not necessarily a corruption, though, and most likely isn't
> related to the accounting issue xfs_repair is reporting. Indeed,
> this is typically a sign of being unable to allocate an inode
> because there is insufficient contiguous free space in the
> filesystem to allocate a new inode chunk. What does your free space
> histogram look like?
> 
> # xfs_db -r -c "freesp -s" <dev>

Unfortunately, this isn't possible any more, because meanwhile I removed
a lot of data, therefore the actual data doesn't hit the situation I
faced a few days ago. Sorry. Should it happen again, I will for sure
remember your mail!


Thanks,
Michael

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
