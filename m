Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 25 Aug 2008 04:07:11 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m7PB78mq000588
	for <xfs@oss.sgi.com>; Mon, 25 Aug 2008 04:07:08 -0700
Received: from wf-out-1314.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E8685FB10CA
	for <xfs@oss.sgi.com>; Mon, 25 Aug 2008 04:08:30 -0700 (PDT)
Received: from wf-out-1314.google.com (wf-out-1314.google.com [209.85.200.168]) by cuda.sgi.com with ESMTP id 36kOpZz17RqIeNvC for <xfs@oss.sgi.com>; Mon, 25 Aug 2008 04:08:30 -0700 (PDT)
Received: by wf-out-1314.google.com with SMTP id 26so1600820wfd.32
        for <xfs@oss.sgi.com>; Mon, 25 Aug 2008 04:08:29 -0700 (PDT)
Message-ID: <50ed5c760808250408o44aeaf07me262eab8da8340ba@mail.gmail.com>
Date: Mon, 25 Aug 2008 13:08:29 +0200
From: "=?ISO-8859-2?Q?S=B3awomir_Nowakowski?=" <nailman23@gmail.com>
Subject: Re: XFS issue under 2.6.25.13 kernel
In-Reply-To: <20080823010524.GM5706@disturbed>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Disposition: inline
References: <50ed5c760808220303p37e03e8dge5b868a572374e0b@mail.gmail.com>
	 <20080823010524.GM5706@disturbed>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: =?ISO-8859-2?Q?S=B3awomir_Nowakowski?= <nailman23@gmail.com>, xfs@oss.sgi.com

2008/8/23 Dave Chinner <david@fromorbit.com>:
> On Fri, Aug 22, 2008 at 12:03:40PM +0200, S³awomir Nowakowski wrote:
>> Dear All,
>>
>> We have a problem with implementing xfs file system for Linux. The problem
>> appears after mounting xfs file system on 2.6.25.13 kernel that is created on
>> 2.6.17.13 kernel.
>>
>> File system is created on logical volume in the following way:
>>
>> lvcreate -L 4G volume1 -n test
>> mkfs.xfs /dev/volume1/test
>> mount /dev/volume1/test /mnt/x
>>
>> After mounting it on 2.6.17.13 kernel "df -B 1" output looks like this:
>>
>> /dev/volume1/test    4284481536    147456 4284334080   1% /mnt/x
>>
>> but in case of 2.6.25.13 kernel:
>>
>> /dev/volume1/test    4284481536   4489216 4279992320   1% /mnt/x
>>
>> The same happens in case of 2.6.26.3 kernel.
>
> Yeah, we reserved 4MB of space for unreserved delayed metadata
> allocations to allow transactions to succeed when at ENOSPC. That
> reservation is accounted as 'used space' to prevent it being used by
> data.
>

Thank you for information.


>> As it is shown after mounting the volume in newer kernel size of file system
>> is visible smaller. The problem appears when on this volume exists one big
>> file, occupying all available space. After trying to mount it under newer
>> kernel, the file is cut because available free space is smaller.
>
> What is on disk will not change - the reservation is purely an
> in-memory construct. i.e. if the file already exists then it
> won't change on upgrade. Can you show how the file changes just
> by booting a different kernel (e.g. ls -l output, md5sums, etc).
>

For tests we have used two kernels: 2.6.17.13 and 2.6.25.13
We have created following partition map:

Disk /dev/sda: 500.1 GB, 500107862016 bytes
255 heads, 63 sectors/track, 60801 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

   Device Boot      Start         End      Blocks   Id  System
/dev/sda1               1         123      987966   83  Linux
/dev/sda2             124         155      257040   83  Linux
/dev/sda3             156         778     5004247+  83  Linux

Next under kernel 2.6.17.1e we have created XFS partition onto sda3:

# mkfs.xfs /dev/sda3

and have mounted it:

# mount /dev/sda3 /mnt/z

Next we have created some files:
-one big file called "bigfile" and size of 5109497856 bytes
-two small text files called: "file1" and "file2"

At this stage it looked as follows:

root@localhost:~# ls -la /mnt/z; df
total 4989773
drwxr-xr-x   2 root root         44 Aug 25 09:35 .
drwxr-xr-x  25 root root       1024 Aug 25 08:30 ..
-rw-r--r--   1 root root 5109497856 Aug 25 08:33 bigfile
-rw-r--r--   1 root root      15132 May 30 15:04 file1
-rw-------   1 root root       7537 Aug  7 15:32 file2

Filesystem           1K-blocks      Used Available Use% Mounted on
/dev/sda3              4993984   4989916      4068 100% /mnt/z

Then we have run system with 2.6.25.13 kernel and checked how it looks:

root@localhost:~# ls -la /mnt/z; df
total 4989773
drwxr-xr-x   2 root root         44 Aug 25 09:35 .
drwxr-xr-x  25 root root       1024 Aug 25 08:30 ..
-rw-r--r--   1 root root 5109497856 Aug 25 08:33 bigfile
-rw-r--r--   1 root root      15132 May 30 15:04 file1
-rw-------   1 root root       7537 Aug  7 15:32 file2

Filesystem           1K-blocks      Used Available Use% Mounted on
/dev/sda3              4993984   4993984         0 100% /mnt/z

As it shown in case of 2.6.25.13 kernel system reports no free space,
but under 2.6.17.13 kernel there is 4068kB of free space.

At this stage when editing file  file1 with i.e. mcedit and trying to
write changes, the system cuts this file to 0 bytes!

The same situation does not happen when we use:

cat file2 >> file1

In this case the system connects two files properly.

>> Is it known issue and/or does solution or workaround exists?
>
> $ sudo xfs_io -x -c 'resblks 0' <file in filesystem>
>
> will remove the reservation. This means your filesystem can shutdown
> or lose data at ENOSPC in certain circumstances....

A question: does using the command:

$ sudo xfs_io -x -c 'resblks 0' <file in filesystem>

for 2.6.25.13 kernel gives higher risk of losing data then in case of
2.6.17.13 kernel.

>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>

Thank you very much for your help

Roland
nailman23@gmail.com
