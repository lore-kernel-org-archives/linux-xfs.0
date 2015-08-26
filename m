Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D15797F37
	for <xfs@oss.sgi.com>; Wed, 26 Aug 2015 12:48:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5B332AC005
	for <xfs@oss.sgi.com>; Wed, 26 Aug 2015 10:48:57 -0700 (PDT)
Received: from mail-la0-f46.google.com (mail-la0-f46.google.com
	[209.85.215.46]) by cuda.sgi.com with ESMTP id 0PzgK0yYMAnUmJma
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 26 Aug 2015 10:48:53 -0700 (PDT)
Received: by labia3 with SMTP id ia3so60249797lab.3
	for <xfs@oss.sgi.com>; Wed, 26 Aug 2015 10:48:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150825234300.GN714@dastard>
References: <CABppvi6GdaTQgqpYJi6RhkpjP9ydTV8-2VV8LF9tHSN63XzWtA@mail.gmail.com>
	<55DCE1CF.5030708@sandeen.net>
	<CABppvi6W5_1GBrb8x1wOAq3X6yraTtt1UYEFE+dBzcXj3yTzrg@mail.gmail.com>
	<20150825234300.GN714@dastard>
Date: Wed, 26 Aug 2015 10:48:52 -0700
Message-ID: <CABppvi7AYbqiskyrEp3As6RPyRz0pThoqVEcjX4736KV-wLkCA@mail.gmail.com>
Subject: Re: Performance impact of mkfs.xfs vs mkfs.xfs -f
From: Shrinand Javadekar <shrinand@maginatics.com>
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

Please see my responses inline. I am seeing this behavior again.

On Tue, Aug 25, 2015 at 4:43 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Tue, Aug 25, 2015 at 04:09:33PM -0700, Shrinand Javadekar wrote:
>> I did this on 2 different setups.
>
> Details?

[Shri] On hardware box 1:

1. # of disks: 23
2. Type: Rotational disks
3. Ran mkfs.xfs and mounted disks
4. Installed Swift
5. Ran benchmark
6. Stopped Swift
7. unmounted disks
8. mkfs.xfs -f on all 23 disks
9. mounted disks
10. Installed Swift
11. Ran benchmark

Benchmark #s are as  reported earlier.

The same steps mentioned above were performed on hardware box #2.

>
>> Formatted the new disks with mkfs.xfs. Ran the workload.
>> Reformatted the disks with mkfs.xfs -f. Ran the workload.
>>
>> >
>> >> Any ideas why this might be happening?
>> >
>> > With the paucity of information you've provided, nope!
>>
>> Apologies. What more information can I provide?
>
> http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F

[Shri] I mentioned this in my first email. Here's the information:
http://oss.sgi.com/archives/xfs/2015-06/msg00108.html

>
>> > What version of xfsprogs are you using?
>>
>> # xfs_repair -V
>> xfs_repair version 3.1.9
>
> That's pretty old.

[Shri] We're using xfs progs version 3.1.9 whereas the kernel is newer
one: 3.16.0-38-generic. Does that matter?
For e.g. one of my colleagues found that the formatting with crc
enabled is only available in newer version of xfsprogs.

>
>> > What was the output of mkfs.xfs each time; did the geometry differ?
>>
>> I have the output of xfs_info /mount/point from the first experiment
>> and that of mkfs.xfs -f. One difference I see is that reformatting
>> adds projid32bit=0 for the inode section.
>
> xfs_info didn't get projid32bit status output until 3.2.0.
>
> Anyway, please post the output so we can see the differences for
> ourselves. What we need is mkfs output in both cases, and xfs_info
> output in both cases after mount.

Step 1: mkfs.xfs

Good formatting: http://pastie.org/private/new2zmwvdqvgm7h7coc4g
else:
meta-data=/dev/mapper/35000c50062e6a567-part2 isize=256    agcount=4,
agsize=183141504 blks
         =                       sectsz=512   attr=2, projid32bit=0
data     =                       bsize=4096   blocks=732566016, imaxpct=5
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal log           bsize=4096   blocks=357698, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

Step 2: xfs_info

meta-data=/dev/mapper/35000c50062e6a567-part2 isize=256    agcount=4,
agsize=183141504 blks
         =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=732566016, imaxpct=5
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal               bsize=4096   blocks=357698, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

Step 3: Ran the benchmark (each run of 20GB)

Bandwidth (KB/s): 62294.9
Bandwidth (KB/s): 34407.7
Bandwidth (KB/s): 26949.8

Step 4: mkfs.xfs -f

Good formatting: http://pastie.org/private/bmzfateuuneddwg1zgymq
else:
meta-data=/dev/mapper/35000c50062e6a567-part2 isize=256    agcount=4,
agsize=183141504 blks
         =                       sectsz=512   attr=2, projid32bit=0
data     =                       bsize=4096   blocks=732566016, imaxpct=5
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal log           bsize=4096   blocks=357698, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

Step 5: xfs_info

meta-data=/dev/mapper/35000c50062e6a567-part2 isize=256    agcount=4,
agsize=183141504 blks
         =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=732566016, imaxpct=5
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal               bsize=4096   blocks=357698, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

Step 6: Ran the same Benchmark (each run of 20GB):

Bandwidth (KB/s): 97061.6
Bandwidth (KB/s): 42811.7
Bandwidth (KB/s): 32111.7

-Shri

>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
