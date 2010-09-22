Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8MKe7wD082962 for <xfs@oss.sgi.com>; Wed, 22 Sep 2010 15:40:07 -0500
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5C48B1847369
	for <xfs@oss.sgi.com>; Wed, 22 Sep 2010 13:41:01 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id sNGQNF4EzKPWqO5z
	for <xfs@oss.sgi.com>; Wed, 22 Sep 2010 13:41:01 -0700 (PDT)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id 9E3FE6C0CC
	for <xfs@oss.sgi.com>; Wed, 22 Sep 2010 15:41:00 -0500 (CDT)
Message-ID: <4C9A69DC.8020606@hardwarefreak.com>
Date: Wed, 22 Sep 2010 15:41:00 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: Question regarding performance on big files.
References: <4C979439.7070906@opencubetech.com>	<4C97BA74.5030304@hardwarefreak.com>
	<4C99D9EB.20800@opencubetech.com>
In-Reply-To: <4C99D9EB.20800@opencubetech.com>
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
To: xfs@oss.sgi.com

Mathieu AVILA put forth on 9/22/2010 5:26 AM:

> I have run my test again with default parameters for mkfs.
> I still have this issue. For 20 seconds, the writes are either stalled,
> or very slow.
> I have run "vmstat" at the same time than "dd", and it appears that the
> block device continues to receive write requests, while "dd" is blocked
> in the kernel.
> With blktrace, I can see that during this period of time, the block
> receives a lot of small write requests throughout the volume ranging
> from the start till the point where the file has stopped writing. During
> the other periods of time, the volume is written normally, starting at
> offset 0 and filling the disk continuously.

What happens with "dd if=3D/dev/zero of=3D/DATA/big oflag=3Ddirect"?  You s=
aid
the copy is hanging in the kernel.  Maybe a buffer cache issue?

What fstab mount options are you using for this filesystem?

> Could this be an effect of tree rebalancing for extents management (both
> inode of big file and free space trees) ? Can it be a hardware problem ?
> Have you ever seen that issue before ?

WRT tree rebalancing, that's beyond my knowledge level and someone else
will need to jump into this thread.  If it's a hardware problem you
should be seeing something in dmesg or the kernel log, or both.  If
you're not seeing controller or device errors it's probably not a
hardware problem.  Have you tried this same test with only one of those
two 500GB drives, no mdraid stripe?  That would eliminate any possible
issues with your mdraid implementation.  Speaking of which, could you
please share your mdraid parameters for this stripe set?  That could be
a factor as well.

-- =

Stan


> -- =

> Mathieu Avila
> =

> =

> Le 20/09/2010 21:48, Stan Hoeppner a =E9crit :
>> Mathieu AVILA put forth on 9/20/2010 12:04 PM:
>>>   Hello XFS team,
>>>
>>> I have run into trouble with XFS, but excuse me if this question has
>>> been asked a dozens times.
>>>
>>> I'm am filling a very big file on a XFS filesystem on Linux that stands
>>> on a software RAID 0. Performance are very good until I get 2 "holes"
>>> during which my write stalls for a few seconds.
>>> Mkfs parameters:
>>> mkxfs.xfs -b size 4096 -s size 4096 -d agcount=3D2 -i size=3D2048
>>> The RAID0 is done a 2 SATA disks of 500 GB each.
>> What happens when you make the filesystem using defaults?
>>
>> mkfs.xfs /dev/[device]
>>
>> Not sure if it is related to your issue, but your manual agcount setting
>> seems really low.  agcount greatly affects parallelism.  With a manual
>> setting of 2, you're dictating serial read/write stream behavior to/from
>> each drive.  This is not good.
>>
>> I have a server with a single 500GB SATA drive with two XFS filesystem
>> partitions for data, each of 100GB, and a 35GB EXT partition for the /
>> filesystem.  Over half the drive space is unallocated.  Yet each XFS
>> filesystem has 4 default allocation groups.  If I were to create two
>> more 100GB filesystems, I'd end up with 16 AGs for 400GB worth of XFS
>> filesystems on a single 500GB drive.
>>
>> meta-data=3D/dev/sda6    isize=3D256    agcount=3D4, agsize=3D6103694 bl=
ks
>>           =3D             sectsz=3D512   attr=3D2
>> data     =3D             bsize=3D4096   blocks=3D24414775, imaxpct=3D25
>>           =3D             sunit=3D0      swidth=3D0 blks
>> naming   =3Dversion 2    bsize=3D4096
>> log      =3Dinternal     bsize=3D4096   blocks=3D11921, version=3D2
>>           =3D             sectsz=3D512   sunit=3D0 blks, lazy-count=3D0
>> realtime =3Dnone         extsz=3D4096   blocks=3D0, rtextents=3D0
>>
>> My suggestion would be to create the filesystem using default values and
>> see what you get.  2.6.18 is rather old, and I don't know if XFS picks
>> up the mdraid config and uses that info accordingly.  Newer versions of
>> XFS do this automatically and correctly, so you don't need to manually
>> specify anything with mkfs.xfs.
>>
>> If default mkfs values still yield issues/problems, remake the
>> filesystem specifying '-d sw=3D2' and retest.
>>
>> You specified '-b size=3D4096'.  This is the default for block size so
>> there's no need to specify it.
>>
>> You specified '-s size=3D4096'.  This needs to match the sector size of
>> the underlying physical disk, which is 512 bytes in your case.  This may
>> be part of your problem as well.
>>
>> You specified '-d agcount=3D2'.  From man mkfs.xfs:
>>
>> "The data section of the filesystem is divided into _value_ allocation
>> groups (default value is scaled automatically based on the underlying
>> device size)."
>>
>> My guess is that mkfs.xfs with no manual agcount forced would yield
>> something like 32-40 allocations groups on your RAID0 1TB XFS
>> filesystem.  Theoretically, this should boost your performance 16-20
>> times over your current agcount setting of 2 allocation groups.  In
>> reality the boost won't be nearly that great, but your performance
>> should be greatly improved nonetheless.
>>
> =

> =


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
