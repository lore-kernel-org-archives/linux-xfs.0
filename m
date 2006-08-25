Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 25 Aug 2006 11:43:06 -0700 (PDT)
Received: from nz-out-0102.google.com (nz-out-0102.google.com [64.233.162.207])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k7PIgvDW006673
	for <xfs@oss.sgi.com>; Fri, 25 Aug 2006 11:42:58 -0700
Received: by nz-out-0102.google.com with SMTP id 40so697608nzk
        for <xfs@oss.sgi.com>; Fri, 25 Aug 2006 11:42:26 -0700 (PDT)
Message-ID: <3022c03a0608251024l5766b9cwa8884fdba881883e@mail.gmail.com>
Date: Fri, 25 Aug 2006 17:24:50 +0000
From: Luzbel <putabetis@gmail.com>
Subject: Aborting XFS copy - reason: Cannot allocate memory
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

I made a copy of my / partition with xfs_copy -d to a file on a XFS
filesystem. It worked without complains. Now, when I try to copy back
the data from the file to the partition I get:

root@slax:/mnt/hda3/luzbel/backup# xfs_copy -d archlinux.partition /dev/hda2
Error initializing wbuf 0
Aborting XFS copy - reason:  Cannot allocate memory
Check logfile "/var/tmp/xfs_copy.log.pn0zp0" for more details
root@slax:/mnt/hda3/luzbel/backup# cat /var/tmp/xfs_copy.log.pn0zp0
Error initializing wbuf 0
Aborting XFS copy - reason:  Cannot allocate memory
root@slax:/mnt/hda3/luzbel/backup#

Partition /dev/hda2 is unmount and /dev/hda3 is mounted, of course.

You got any idea on why this is happening? If you need me to provide
extra info, instruct me.

Thank you very much.
