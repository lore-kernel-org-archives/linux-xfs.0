Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 22 Aug 2008 18:10:18 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m7N1AFfc032007
	for <xfs@oss.sgi.com>; Fri, 22 Aug 2008 18:10:15 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 26025FAA9F1
	for <xfs@oss.sgi.com>; Fri, 22 Aug 2008 18:11:36 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id MTOI1P5cG8wS2lIW for <xfs@oss.sgi.com>; Fri, 22 Aug 2008 18:11:36 -0700 (PDT)
Date: Sat, 23 Aug 2008 11:05:24 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS issue under 2.6.25.13 kernel
Message-ID: <20080823010524.GM5706@disturbed>
References: <50ed5c760808220303p37e03e8dge5b868a572374e0b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <50ed5c760808220303p37e03e8dge5b868a572374e0b@mail.gmail.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: =?utf-8?B?U8WCYXdvbWly?= Nowakowski <nailman23@gmail.com>
Cc: xfs@oss.sgi.com

On Fri, Aug 22, 2008 at 12:03:40PM +0200, Sławomir Nowakowski wrote:
> Dear All,
> 
> We have a problem with implementing xfs file system for Linux. The problem
> appears after mounting xfs file system on 2.6.25.13 kernel that is created on
> 2.6.17.13 kernel.
> 
> File system is created on logical volume in the following way:
> 
> lvcreate -L 4G volume1 -n test
> mkfs.xfs /dev/volume1/test
> mount /dev/volume1/test /mnt/x
> 
> After mounting it on 2.6.17.13 kernel "df -B 1" output looks like this:
> 
> /dev/volume1/test    4284481536    147456 4284334080   1% /mnt/x
> 
> but in case of 2.6.25.13 kernel:
> 
> /dev/volume1/test    4284481536   4489216 4279992320   1% /mnt/x
> 
> The same happens in case of 2.6.26.3 kernel.

Yeah, we reserved 4MB of space for unreserved delayed metadata
allocations to allow transactions to succeed when at ENOSPC. That
reservation is accounted as 'used space' to prevent it being used by
data.

> As it is shown after mounting the volume in newer kernel size of file system
> is visible smaller. The problem appears when on this volume exists one big
> file, occupying all available space. After trying to mount it under newer
> kernel, the file is cut because available free space is smaller.

What is on disk will not change - the reservation is purely an
in-memory construct. i.e. if the file already exists then it
won't change on upgrade. Can you show how the file changes just
by booting a different kernel (e.g. ls -l output, md5sums, etc).

> Is it known issue and/or does solution or workaround exists?

$ sudo xfs_io -x -c 'resblks 0' <file in filesystem>

will remove the reservation. This means your filesystem can shutdown
or lose data at ENOSPC in certain circumstances....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
