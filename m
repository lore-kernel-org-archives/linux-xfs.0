Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 23D4F29DFB
	for <xfs@oss.sgi.com>; Tue, 13 Aug 2013 09:55:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 07527304043
	for <xfs@oss.sgi.com>; Tue, 13 Aug 2013 07:55:28 -0700 (PDT)
Received: from mx1.vr-web.de (mx0.vr-web.de [195.200.35.198]) by cuda.sgi.com
	with ESMTP id DEEmFmrkXXlkNuq4 for <xfs@oss.sgi.com>;
	Tue, 13 Aug 2013 07:55:27 -0700 (PDT)
Message-ID: <520A48C4.6060801@allmail.net>
Date: Tue, 13 Aug 2013 16:55:00 +0200
From: Michael Maier <m1278468@allmail.net>
MIME-Version: 1.0
Subject: Re: Failure growing xfs with linux 3.10.5
References: <52073905.8010608@allmail.net> <5207D9C4.7020102@sandeen.net>
	<5209126F.5020204@allmail.net> <20130813005414.GT12779@dastard>
In-Reply-To: <20130813005414.GT12779@dastard>
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
> On Mon, Aug 12, 2013 at 06:50:55PM +0200, Michael Maier wrote:
>> Meanwhile, I faced another problem on another xfs-file system with linux
>> 3.10.5 which I never saw before. During writing a few bytes to disc, I
>> got "disc full" and the writing failed.
>>
>> At the same time, df reported 69G of free space! I ran xfs_repair -n and
>> got:
>>
>>
>> xfs_repair -n /dev/mapper/raid0-daten2
>> Phase 1 - find and verify superblock...
>> Phase 2 - using internal log
>>         - scan filesystem freespace and inode maps...
>> sb_ifree 591, counted 492
>> ^^^^^^^^^^^^^^^^^^^^^^^^^
>> What does this mean? How can I get rid of it w/o loosing data? This file
>> system was created a few days ago and never resized.
> 
> Superblock inode counting is lazy - it can get out of sync in after
> an unclean shutdown, but generally mounting a dirty filesystem will
> result in it being recalculated rather than trusted to be correct.
> So there's nothing to worry about here.

When will it be self healed? I still can see it today after 4 remounts!
This is strange and I can't use the free space, which I need! How can it
be forced to be repaired w/o data loss?


Thanks,
kind regards,
Michael

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
