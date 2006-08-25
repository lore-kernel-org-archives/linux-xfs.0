Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 25 Aug 2006 14:22:54 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k7PLMlDW018574
	for <xfs@oss.sgi.com>; Fri, 25 Aug 2006 14:22:48 -0700
Message-ID: <44EF6A08.8000200@thebarn.com>
Date: Fri, 25 Aug 2006 16:22:16 -0500
From: Russell Cattelan <cattelan@thebarn.com>
MIME-Version: 1.0
Subject: Re: Aborting XFS copy - reason: Cannot allocate memory
References: <3022c03a0608251024l5766b9cwa8884fdba881883e@mail.gmail.com>
In-Reply-To: <3022c03a0608251024l5766b9cwa8884fdba881883e@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Luzbel <putabetis@gmail.com>, xfs@oss.sgi.com

Luzbel wrote:
> I made a copy of my / partition with xfs_copy -d to a file on a XFS
> filesystem. It worked without complains. Now, when I try to copy back
> the data from the file to the partition I get:
>
> root@slax:/mnt/hda3/luzbel/backup# xfs_copy -d archlinux.partition 
> /dev/hda2
> Error initializing wbuf 0
> Aborting XFS copy - reason:  Cannot allocate memory
> Check logfile "/var/tmp/xfs_copy.log.pn0zp0" for more details
> root@slax:/mnt/hda3/luzbel/backup# cat /var/tmp/xfs_copy.log.pn0zp0
> Error initializing wbuf 0
> Aborting XFS copy - reason:  Cannot allocate memory
> root@slax:/mnt/hda3/luzbel/backup#
>
> Partition /dev/hda2 is unmount and /dev/hda3 is mounted, of course.
>
> You got any idea on why this is happening? If you need me to provide
> extra info, instruct me.
>
> Thank you very much.
>
run xfs_check or xfs_repair -n on your copy just to make sure the file
is good.

maybe run strace or gdb on xfs_copy and figure out exactly how much space
xfs_copy is trying to allocate.
