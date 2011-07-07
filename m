Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p67K0C8Z190781 for <xfs@oss.sgi.com>; Thu, 7 Jul 2011 15:00:12 -0500
Received: from mail-fx0-f47.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B1B7B5310C
	for <xfs@oss.sgi.com>; Thu,  7 Jul 2011 13:00:11 -0700 (PDT)
Received: from mail-fx0-f47.google.com (mail-fx0-f47.google.com
	[209.85.161.47]) by cuda.sgi.com with ESMTP id 9rJXihJ3am6umwL8
	for <xfs@oss.sgi.com>; Thu, 07 Jul 2011 13:00:11 -0700 (PDT)
Received: by fxg11 with SMTP id 11so1604988fxg.6
	for <xfs@oss.sgi.com>; Thu, 07 Jul 2011 13:00:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E15D68C.6060801@sandeen.net>
References: <CAP7pH7uVASQQ60PSBmKWonaOMPJP5fTthheFzjxgdHp5DUBuOw@mail.gmail.com>
	<20110704124906.GY561@dastard>
	<CAP7pH7v3oEp6XSxZTz6=RXKSvjLjFAN-ytSQ0Xka80DME+ZHrw@mail.gmail.com>
	<4E15D68C.6060801@sandeen.net>
Date: Thu, 7 Jul 2011 22:57:22 +0300
Message-ID: <CAP7pH7tt0UyKLVMbvR1FNP_4c_aP5Y_2gAADxG8=xL6fF_xMCg@mail.gmail.com>
Subject: Re: Recovering XFS Partition of Type FAT16
From: Volkan YAZICI <volkan.yazici@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On Thu, Jul 7, 2011 at 6:53 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
> It sounds like something changed your partition table as well as your
> filesystem. =A0Putting the partition table back in place first probably
> would have been the better first step, in retrospect.
>
> I can't tell for sure, though, what you've done (did you reparition?
> mkfs? =A0with which tools? =A0what was the xfs_repair output?) so I'm not
> sure what to tell you at this point.

I was struggling to boot an ISO image from a USB disk, hence I suspect
that I had probably set the type of the host machine partition
(/dev/sda1) to FAT16 with fdisk, instead of USB disk partition
(/dev/sdb1). Then in the next boot, Linux doesn't come up and
complained about XFS issues. Hence I rebooted the machine and repaired
the fs with xfs_repair. This time partition is mounted properly but a
significant portion of the disk content is missing. Then in the fdisk
-l output I realized that /dev/sda1 is set to FAT16. (Isn't it strange
that I can xfs_repair and mount a partition of type FAT16?) Later I
set the type of /dev/sda1 to Linux, but nothing changed. I called
xfs_repair again and tried mounting again, no luck: same fs size
(20GB), same missing contents.

For the xfs_repair output... Honestly, I don't remember and I don't
think I can reproduce the situation.


Best.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
