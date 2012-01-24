Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0O78SLK218614 for <xfs@oss.sgi.com>; Tue, 24 Jan 2012 01:08:28 -0600
Received: from mail-ee0-f53.google.com (mail-ee0-f53.google.com
	[74.125.83.53]) by cuda.sgi.com with ESMTP id Xd1y5CMH1wJ7dSuh
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 23 Jan 2012 23:08:26 -0800 (PST)
Received: by eeke51 with SMTP id e51so2054010eek.26
	for <xfs@oss.sgi.com>; Mon, 23 Jan 2012 23:08:24 -0800 (PST)
Subject: Re: How to fix bad superblock or xfs_repair: error - read only 0 of
	512 bytes
Mime-Version: 1.0 (Apple Message framework v1251.1)
From: Christian Kildau <lists@unixhosts.org>
In-Reply-To: <4F1E3BD0.7080604@sandeen.net>
Date: Tue, 24 Jan 2012 08:08:20 +0100
Message-Id: <F1F87F14-90F2-4A62-85F4-5A70822F91EE@unixhosts.org>
References: <CALx8gnT9tdPRGfVR0puoSVYz_MDDs4FtWtodST5x29GDnL3A_w@mail.gmail.com>
	<20120123043117.GH15102@dastard>
	<92CDAC52-1BA1-43A8-8470-0E2DCD916610@unixhosts.org>
	<4F1E3BD0.7080604@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On Jan 24, 2012, at 6:04 AM, Eric Sandeen wrote:

> On 1/23/12 3:23 AM, Christian Kildau wrote:
>> On Jan 23, 2012, at 5:31 AM, Dave Chinner wrote:
>> =

>>> On Sat, Jan 21, 2012 at 11:29:15AM +0100, Christian Kildau wrote:
>>>> Sorry if this message appears twice!
>>>> =

> =

> Argh.  ;)
> =

>>>> =

>>>> Hello,
>>>> =

>>>> I'm having some very serious issues with XFS after upgrading from a
>>>> Linux Distro running Ubuntu 2.6.32 to 3.2.
>>>> =

>>>> It seems like my filesystems are damaged after attaching them to a
>>>> Linux 3.2 server. I am also no longer able to mount the hdd on the old
>>>> server that is still running 2.6.32!
>>> =

>>> I take it that you are using external storage of some kind? Can you
>>> describe it?
>> =

>> This hdd is connected via e-sata, but it doesn't make any difference if =
I directly connect it internally via sata.
>> Also it doesn't make any difference if I connect it back to the 'old' se=
rver
>> =

>>> =

>>>> (I created the xfs filesystem on the entire hdd, not on a partition,
>>>> so /dev/sdd is not a typo)
> =

> I wonder if your installer helpfully scribbled something on it since it
> had no partitions (which should be safe, but there are dumb apps out ther=
e).

This is a new system. I connected the hdd waaay after the installation. So =
the installer has never seen it. ;)

> =

>>>> $ sudo mount -t xfs /dev/sdd /media/
>>>> mount: /dev/sdd: can't read superblock
>>>> (dmesg)
>>>> [236659.912663] attempt to access beyond end of device
>>>> [236659.912667] sdd: rw=3D32, want=3D2930277168, limit=3D2930275055
>>>> [236659.912670] XFS (sdd): last sector read failed
>>> =

>>> So XFS has asked to read 2113 sectors beyond the size of the device
>>> that the kernel is reporting. What is the output of
>>> /proc/partitions?
>> =

>> $ grep sdd /proc/partitions =

>>   8       64 1465137527 sdd
> =

> so 1465137527*1024 =3D 1500300827648 bytes
> =

> From the strace repair is trying to read at:
> =

> pread(4, "", 512, 1500301909504)        =3D 0
> =

> which is about 1 meg past the end of the device.

That's weird! Any chance left I can fix this?


> =

>>> =

>>>> $ sudo xfs_check /dev/sdd
>>>> xfs_check: error - read only 0 of 512 bytes
>>>> =

>>>> $ sudo xfs_repair /dev/sdd
>>>> Phase 1 - find and verify superblock...
>>>> xfs_repair: error - read only 0 of 512 bytes
>>> =

>>> So both buffered and direct IO to the first block in the block
>>> device are failing. I'd say your problems have nothing to do with
>>> XFS. However, can you strace them and find out what the error that
>>> is occuring actually is?
>> =

>> Strace is giving me:
>> wait4(-1, xfs_check: /dev/sdd is not a valid XFS filesystem (unexpected =
SB magic number 0x00000000)
> =

> now that is something else=85

Yes, sorry. that was my fault. Wrong hdd. see my other message for the corr=
ect straces.

> =

>> xfs_check: WARNING - filesystem uses v1 dirs,limited functionality provi=
ded.
>> xfs_check: read failed: Invalid argument
>> cache_node_purge: refcount was 1, not zero (node=3D0x21ecef0)
>> xfs_check: cannot read root inode (22)
>> bad superblock magic number 0, giving up
> =

> those are different failures than first reported....
> =

> xfs_db -c "sb 0" -c "p" /dev/sdd still might be interesting.
> =


xfs_db: error - read only 0 of 512 bytes
magicnum =3D 0x58465342
blocksize =3D 4096
dblocks =3D 366284646
rblocks =3D 0
rextents =3D 0
uuid =3D 65b7d940-6577-4384-b7ba-f051300f2d56
logstart =3D 268435460
rootino =3D 128
rbmino =3D 129
rsumino =3D 130
rextsize =3D 1
agblocks =3D 91571162
agcount =3D 4
rbmblocks =3D 0
logblocks =3D 32768
versionnum =3D 0xb4a4
sectsize =3D 512
inodesize =3D 256
inopblock =3D 16
fname =3D "\000\000\000\000\000\000\000\000\000\000\000\000"
blocklog =3D 12
sectlog =3D 9
inodelog =3D 8
inopblog =3D 4
agblklog =3D 27
rextslog =3D 0
inprogress =3D 0
imax_pct =3D 5
icount =3D 5184
ifree =3D 16
fdblocks =3D 54646459
frextents =3D 0
uquotino =3D 0
gquotino =3D 0
qflags =3D 0
flags =3D 0
shared_vn =3D 0
inoalignmt =3D 2
unit =3D 0
width =3D 0
dirblklog =3D 0
logsectlog =3D 0
logsectsize =3D 0
logsunit =3D 1
features2 =3D 0x8
bad_features2 =3D 0x8

I don't get anything useful from that information ;)


Thanks in advance!
Chris
_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
