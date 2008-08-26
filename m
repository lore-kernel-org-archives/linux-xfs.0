Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 26 Aug 2008 05:52:35 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m7QCq43r004188
	for <xfs@oss.sgi.com>; Tue, 26 Aug 2008 05:52:04 -0700
Received: from wf-out-1314.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BA244FC0502
	for <xfs@oss.sgi.com>; Tue, 26 Aug 2008 05:53:24 -0700 (PDT)
Received: from wf-out-1314.google.com (wf-out-1314.google.com [209.85.200.168]) by cuda.sgi.com with ESMTP id c7dlrG3DXc9mKQca for <xfs@oss.sgi.com>; Tue, 26 Aug 2008 05:53:24 -0700 (PDT)
Received: by wf-out-1314.google.com with SMTP id 26so2090556wfd.32
        for <xfs@oss.sgi.com>; Tue, 26 Aug 2008 05:53:23 -0700 (PDT)
Message-ID: <50ed5c760808260553i7def5e93qb0bcb4d2206a4a38@mail.gmail.com>
Date: Tue, 26 Aug 2008 14:53:23 +0200
From: "=?ISO-8859-2?Q?S=B3awomir_Nowakowski?=" <nailman23@gmail.com>
Subject: Re: XFS issue under 2.6.25.13 kernel
In-Reply-To: <20080826014133.GS5706@disturbed>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Disposition: inline
References: <50ed5c760808220303p37e03e8dge5b868a572374e0b@mail.gmail.com>
	 <20080823010524.GM5706@disturbed>
	 <50ed5c760808250408o44aeaf07me262eab8da8340ba@mail.gmail.com>
	 <20080826014133.GS5706@disturbed>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: =?ISO-8859-2?Q?S=B3awomir_Nowakowski?= <nailman23@gmail.com>, xfs@oss.sgi.com

2008/8/26 Dave Chinner <david@fromorbit.com>:
> On Mon, Aug 25, 2008 at 01:08:29PM +0200, S³awomir Nowakowski wrote:
>> 2008/8/23 Dave Chinner <david@fromorbit.com>:
>> Next we have created some files:
>> -one big file called "bigfile" and size of 5109497856 bytes
>> -two small text files called: "file1" and "file2"
>>
>> At this stage it looked as follows:
> ....
>> Filesystem           1K-blocks      Used Available Use% Mounted on
>> /dev/sda3              4993984   4989916      4068 100% /mnt/z
>>
>> Then we have run system with 2.6.25.13 kernel and checked how it looks:
> .....
>> Filesystem           1K-blocks      Used Available Use% Mounted on
>> /dev/sda3              4993984   4993984         0 100% /mnt/z
>>
>> As it shown in case of 2.6.25.13 kernel system reports no free space,
>> but under 2.6.17.13 kernel there is 4068kB of free space.
>>
>> At this stage when editing file  file1 with i.e. mcedit and trying to
>> write changes, the system cuts this file to 0 bytes!
>
> Oh, look, yet another editor that doesn't safely handle ENOSPC and
> trashes files when it can't overwrite them. That's not an XFS
> problem - I suggest raising a bug against the editor....
>
>> >> Is it known issue and/or does solution or workaround exists?
>> >
>> > $ sudo xfs_io -x -c 'resblks 0' <file in filesystem>
>> >
>> > will remove the reservation. This means your filesystem can shutdown
>> > or lose data at ENOSPC in certain circumstances....
>>
>> A question: does using the command:
>>
>> $ sudo xfs_io -x -c 'resblks 0' <file in filesystem>
>>
>> for 2.6.25.13 kernel gives higher risk of losing data then in case of
>> 2.6.17.13 kernel.
>
> Hard to say. If you don't run to ENOSPC then there is no difference.
> If you do run to ENOSPC then I think that there is a slightly higher
> risk of tripping problems on 2.6.25.x because of other ENOSPC fixes
> that have been included since 2.6.17.13. This really is a safety net
> in that it allows the system to continue without problems in
> conditions where it would have previously done a bad thing...
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>

Dear Dave,

Can you please take a look at the following outputs of some commands
run under 2.6.17.17 and 2.6.25.13 kernels?

Here is a situation on 2.6.17.13 kernel:

xfs_io -x -c 'statfs' /mnt/point

fd.path = "/mnt/sda"
statfs.f_bsize = 4096
statfs.f_blocks = 487416
statfs.f_bavail = 6
statfs.f_files = 160
statfs.f_ffree = 154
geom.bsize = 4096
geom.agcount = 8
geom.agblocks = 61247
geom.datablocks = 489976
geom.rtblocks = 0
geom.rtextents = 0
geom.rtextsize = 1
geom.sunit = 0
geom.swidth = 0
counts.freedata = 6
counts.freertx = 0
counts.freeino = 58
counts.allocino = 64

xfs_io -x -c 'resblks' /mnt/point

reserved blocks = 0
available reserved blocks = 0

xfs_info /mnt/point

meta-data=/dev/sda4              isize=256    agcount=8, agsize=61247 blks
         =                       sectsz=512   attr=0
data     =                       bsize=4096   blocks=489976, imaxpct=25
         =                       sunit=0      swidth=0 blks, unwritten=1
naming   =version 2              bsize=4096
log      =internal               bsize=4096   blocks=2560, version=1
         =                       sectsz=512   sunit=0 blks, lazy-count=0
realtime =none                   extsz=4096   blocks=0, rtextents=0

But under 2.6.25.13 kernel the situation looks different:

xfs_io -x -c 'statfs' /mnt/point:

fd.path = "/mnt/-sda4"
statfs.f_bsize = 4096
statfs.f_blocks = 487416
statfs.f_bavail = 30
statfs.f_files = 544
statfs.f_ffree = 538
geom.bsize = 4096
geom.agcount = 8
geom.agblocks = 61247
geom.datablocks = 489976
geom.rtblocks = 0
geom.rtextents = 0
geom.rtextsize = 1
geom.sunit = 0
geom.swidth = 0
counts.freedata = 30
counts.freertx = 0
counts.freeino = 58
counts.allocino = 64

xfs_io -x -c 'resblks' /mnt/point:

reserved blocks = 18446744073709551586
available reserved blocks = 18446744073709551586

xfs_info /mnt/point

meta-data=/dev/sda4              isize=256    agcount=8, agsize=61247 blks
         =                       sectsz=512   attr=0
data     =                       bsize=4096   blocks=489976, imaxpct=25
         =                       sunit=0      swidth=0 blks, unwritten=1
naming   =version 2              bsize=4096
log      =internal               bsize=4096   blocks=2560, version=1
         =                       sectsz=512   sunit=0 blks
realtime =none                   extsz=4096   blocks=0, rtextents=0

As you can easy see statfs.f_bavail, statfs.f_files, statfs.f_ffree
and counts.freedata values are different.
Can you explain why?

Also after applying your solution "xfs_io -x -c 'resblks 0' <file in
filesystem>" the command

xfs_io -x -c 'resblks' /mnt/point gives output:

reserved blocks = 0
available reserved blocks = 18446744073709551586

Is it OK?

Another question is if you know some advices for tuning of XFS file
systems that will contain maximum 10 files?

Thank you very much for your help!
I really appreciate it.
