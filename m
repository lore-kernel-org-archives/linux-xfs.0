Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p67FrnX0181241 for <xfs@oss.sgi.com>; Thu, 7 Jul 2011 10:53:50 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3CA951E56371
	for <xfs@oss.sgi.com>; Thu,  7 Jul 2011 08:53:48 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id la4S9JVYIaYVx7G5 for <xfs@oss.sgi.com>;
	Thu, 07 Jul 2011 08:53:48 -0700 (PDT)
Message-ID: <4E15D68C.6060801@sandeen.net>
Date: Thu, 07 Jul 2011 10:53:48 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Recovering XFS Partition of Type FAT16
References: <CAP7pH7uVASQQ60PSBmKWonaOMPJP5fTthheFzjxgdHp5DUBuOw@mail.gmail.com>	<20110704124906.GY561@dastard>
	<CAP7pH7v3oEp6XSxZTz6=RXKSvjLjFAN-ytSQ0Xka80DME+ZHrw@mail.gmail.com>
In-Reply-To: <CAP7pH7v3oEp6XSxZTz6=RXKSvjLjFAN-ytSQ0Xka80DME+ZHrw@mail.gmail.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Volkan YAZICI <volkan.yazici@gmail.com>
Cc: xfs@oss.sgi.com

On 7/7/11 6:32 AM, Volkan YAZICI wrote:
> On Mon, Jul 4, 2011 at 3:49 PM, Dave Chinner <david@fromorbit.com> wrote:
>> On Mon, Jul 04, 2011 at 10:23:55AM +0000, Volkan YAZICI wrote:
>>> I have an XFS partition, which is
>>>
>>> 1) Mistakenly quick formatted as FAT16.
>>> 2) At first, I couldn't see in "fdisk -l" that it is set to FAT16,
>>> instead of Linux. Hence, tried to fix it with xfs_recover. xfs_recover
>>> returned 0, and mount operation succeeded; but mounted fs size
>>> appeared as 20GB (despite it is 350GB) and almost every file was
>>> missing.
>>> 3) Later, I set the type of /dev/sda1 (the only partition in /dev/sda)
>>> to Linux, re-run xfs_recover, but nothing changed: Same fs size (20GB)
>>> and same missing files.
>>
>> What is this xfs_recover tool you speak of? I've never heard of it,
>> I can't find any direct links to it in google (only forum posts from
>> years ago about how great it is) so I have no idea what you've done to
>> your filesystem...
> 
> Sorry, I was writing that mail from a friend's computer, and
> mistakenly typed xfs_recover, instead of xfs_repair.
> 
>> That looks like a newly made 20GB XFS filesystem, not the result of
>> repairing a 350GB filesystem...
> 
> Since I formatted it as FAT16 first, it truncated the fs to 20GB. Then
> calling xfs_repair caused the whole XFS partition appear as of size
> 20GB.

It sounds like something changed your partition table as well as your
filesystem.  Putting the partition table back in place first probably
would have been the better first step, in retrospect.

I can't tell for sure, though, what you've done (did you reparition?
mkfs?  with which tools?  what was the xfs_repair output?) so I'm not
sure what to tell you at this point.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
