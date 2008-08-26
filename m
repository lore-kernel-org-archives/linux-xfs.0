Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 25 Aug 2008 18:40:18 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m7Q1eG5w011497
	for <xfs@oss.sgi.com>; Mon, 25 Aug 2008 18:40:16 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 11E823CD3C9
	for <xfs@oss.sgi.com>; Mon, 25 Aug 2008 18:41:38 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id EYBOOwfciBtJt642 for <xfs@oss.sgi.com>; Mon, 25 Aug 2008 18:41:38 -0700 (PDT)
Date: Tue, 26 Aug 2008 11:41:33 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS issue under 2.6.25.13 kernel
Message-ID: <20080826014133.GS5706@disturbed>
References: <50ed5c760808220303p37e03e8dge5b868a572374e0b@mail.gmail.com> <20080823010524.GM5706@disturbed> <50ed5c760808250408o44aeaf07me262eab8da8340ba@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <50ed5c760808250408o44aeaf07me262eab8da8340ba@mail.gmail.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: =?utf-8?B?U8WCYXdvbWly?= Nowakowski <nailman23@gmail.com>
Cc: xfs@oss.sgi.com

On Mon, Aug 25, 2008 at 01:08:29PM +0200, Sławomir Nowakowski wrote:
> 2008/8/23 Dave Chinner <david@fromorbit.com>:
> Next we have created some files:
> -one big file called "bigfile" and size of 5109497856 bytes
> -two small text files called: "file1" and "file2"
> 
> At this stage it looked as follows:
....
> Filesystem           1K-blocks      Used Available Use% Mounted on
> /dev/sda3              4993984   4989916      4068 100% /mnt/z
> 
> Then we have run system with 2.6.25.13 kernel and checked how it looks:
.....
> Filesystem           1K-blocks      Used Available Use% Mounted on
> /dev/sda3              4993984   4993984         0 100% /mnt/z
> 
> As it shown in case of 2.6.25.13 kernel system reports no free space,
> but under 2.6.17.13 kernel there is 4068kB of free space.
> 
> At this stage when editing file  file1 with i.e. mcedit and trying to
> write changes, the system cuts this file to 0 bytes!

Oh, look, yet another editor that doesn't safely handle ENOSPC and
trashes files when it can't overwrite them. That's not an XFS
problem - I suggest raising a bug against the editor....

> >> Is it known issue and/or does solution or workaround exists?
> >
> > $ sudo xfs_io -x -c 'resblks 0' <file in filesystem>
> >
> > will remove the reservation. This means your filesystem can shutdown
> > or lose data at ENOSPC in certain circumstances....
> 
> A question: does using the command:
> 
> $ sudo xfs_io -x -c 'resblks 0' <file in filesystem>
> 
> for 2.6.25.13 kernel gives higher risk of losing data then in case of
> 2.6.17.13 kernel.

Hard to say. If you don't run to ENOSPC then there is no difference.
If you do run to ENOSPC then I think that there is a slightly higher
risk of tripping problems on 2.6.25.x because of other ENOSPC fixes
that have been included since 2.6.17.13. This really is a safety net
in that it allows the system to continue without problems in
conditions where it would have previously done a bad thing...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
