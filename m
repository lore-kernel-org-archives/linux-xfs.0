Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 11B9C7F51
	for <xfs@oss.sgi.com>; Wed, 14 Aug 2013 10:16:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D5F25304051
	for <xfs@oss.sgi.com>; Wed, 14 Aug 2013 08:16:43 -0700 (PDT)
Received: from mx1.vr-web.de (mx0.vr-web.de [195.200.35.198]) by cuda.sgi.com
	with ESMTP id okvMdnR6jjZiOUw7 for <xfs@oss.sgi.com>;
	Wed, 14 Aug 2013 08:16:41 -0700 (PDT)
Message-ID: <520B9F3E.6030805@allmail.net>
Date: Wed, 14 Aug 2013 17:16:14 +0200
From: Michael Maier <m1278468@allmail.net>
MIME-Version: 1.0
Subject: Re: Failure growing xfs with linux 3.10.5
References: <52073905.8010608@allmail.net> <5207D9C4.7020102@sandeen.net>
	<5209126F.5020204@allmail.net> <20130813005414.GT12779@dastard>
	<520A48C4.6060801@allmail.net> <20130814054332.GA12779@dastard>
In-Reply-To: <20130814054332.GA12779@dastard>
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
> On Tue, Aug 13, 2013 at 04:55:00PM +0200, Michael Maier wrote:
>> Dave Chinner wrote:
>>> On Mon, Aug 12, 2013 at 06:50:55PM +0200, Michael Maier wrote:
>>>> Meanwhile, I faced another problem on another xfs-file system with linux
>>>> 3.10.5 which I never saw before. During writing a few bytes to disc, I
>>>> got "disc full" and the writing failed.
>>>>
>>>> At the same time, df reported 69G of free space! I ran xfs_repair -n and
>>>> got:
>>>>
>>>>
>>>> xfs_repair -n /dev/mapper/raid0-daten2
>>>> Phase 1 - find and verify superblock...
>>>> Phase 2 - using internal log
>>>>         - scan filesystem freespace and inode maps...
>>>> sb_ifree 591, counted 492
>>>> ^^^^^^^^^^^^^^^^^^^^^^^^^
>>>> What does this mean? How can I get rid of it w/o loosing data? This file
>>>> system was created a few days ago and never resized.
>>>
>>> Superblock inode counting is lazy - it can get out of sync in after
>>> an unclean shutdown, but generally mounting a dirty filesystem will
>>> result in it being recalculated rather than trusted to be correct.
>>> So there's nothing to worry about here.
>>
>> When will it be self healed?
> 
> that depends on whether there's actually a problem. Like I said in
> the part you snipped off - if you ran xfs_repair -n on filesystem
> that needs log recovery that accounting difference is expected.

I know, that option -n doesn't do anything. It was intended, because
xfs_repair destroyed a lot of data when applied at the other problem I
have _and_ it repaired nothing at the same time! The other problem isn't
fixed at all although xfs_repair was used w/o -n.

That's why am I asking if a real xfs_repair will fix this problem in
this case _w/o_ loosing any data.

> 
>> I still can see it today after 4 remounts!
> 
> See what?

The problem
sb_ifree 591, counted 492
^^^^^^^^^^^^^^^^^^^^^^^^^

>> This is strange and I can't use the free space, which I need! How can it
>> be forced to be repaired w/o data loss?
> 
> The above is complaining about a free inode count mismatch, not a
> problem about free space being wrong. What problem are you actually
> having?

The application, which wanted to write a few bytes gets a "disk full"
error although df -h reports 69GB of free space.


Thanks,
regards,
Michael

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
