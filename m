Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 18 Jul 2007 04:30:11 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6IBU6bm015700
	for <xfs@oss.sgi.com>; Wed, 18 Jul 2007 04:30:08 -0700
Date: Wed, 18 Jul 2007 07:20:32 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Software RAID5 Horrible Write Speed On 3ware Controller!!
In-Reply-To: <469DF6B1.7030000@mandriva.com>
Message-ID: <Pine.LNX.4.64.0707180720050.7659@p34.internal.lan>
References: <Pine.LNX.4.64.0707180614480.7659@p34.internal.lan>
 <469DF6B1.7030000@mandriva.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463747160-1464876308-1184757632=:7659"
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: =?ISO-8859-1?Q?Giuseppe_Ghib=F2?= <ghibo@mandriva.com>
Cc: linux-ide-arrays@lists.math.uh.edu, xfs@oss.sgi.com, linux-raid@vger.kernel.org, linux@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463747160-1464876308-1184757632=:7659
Content-Type: TEXT/PLAIN; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Wed, 18 Jul 2007, Giuseppe Ghib=F2 wrote:

> Justin Piszcz ha scritto:
>
>> I recently got a chance to test SW RAID5 using 750GB disks (10) in a RAI=
D5=20
>> on a 3ware card, model no: 9550SXU-12
>>=20
>> The bottom line is the controller is doing some weird caching with write=
s=20
>> on SW RAID5 which makes it not worth using.
>>=20
>> Recall, with SW RAID5 using regular SATA cards with (mind you) 10 raptor=
s:
>> write: 464MB/s
>> read: 627MB/s
>>=20
>> Yes, these drives are different, 7200RPM 750GB drives, but write should =
not=20
>> be 50-102MB/s as shown below.
>>=20
>> First, lets test RAW performance of these 10 drives:
>>=20
>> Create RAID 0 with 10 750GB Drives:
>> # mdadm /dev/md0 --create --level=3D0 -n 10 /dev/sd[bcdefghjik]1
>> mdadm: array /dev/md0 started.
>>=20
>> --> XFS: (xfs default options, no optimizations)
>> # dd if=3D/dev/zero of=3D10gb bs=3D1M count=3D10240
>> 10737418240 bytes (11 GB) copied, 22.459 seconds, 478 MB/s
>> # dd if=3D10gb of=3D/dev/zero bs=3D1M count=3D10240
>> 10737418240 bytes (11 GB) copied, 28.7843 seconds, 373 MB/s
>>=20
>> --> XFS: (xfs default options, enabled md-raid read optimizations)
>> # dd if=3D/dev/zero of=3D10gb bs=3D1M count=3D10240
>> 10737418240 bytes (11 GB) copied, 22.9623 seconds, 468 MB/s
>> # dd if=3D10gb of=3D/dev/zero bs=3D1M count=3D10240
>> 10737418240 bytes (11 GB) copied, 17.7328 seconds, 606 MB/s
>>=20
>> Software RAID 5 on a real HW raid controller over 10 750GB disks JBOD:
>>=20
>> UltraDense-AS-3ware-R5-9-disks,16G,50676,89,96019,34,46379,9,60267,99,50=
1098,56,248.5,0,16:100000:16/64,240,3,21959,84,1109,10,286,4,22923,91,544,6=
=20
>> UltraDense-AS-3ware-R5-9-disks,16G,49983,88,96902,37,47951,10,59002,99,5=
29121,60,210.3,0,16:100000:16/64,250,3,25506,98,1163,10,268,3,18003,71,772,=
8=20
>> UltraDense-AS-3ware-R5-9-disks,16G,49811,87,95759,35,48214,10,60153,99,5=
38559,61,276.8,0,16:100000:16/64,233,3,25514,97,1100,9,279,3,21398,84,839,9=
=20
>>=20
>> Write seems significantly impacted, where read is fine, the HW RAID=20
>> controller cache must be doing something strange:
>>=20
>> --> XFS SW RAID 5: (xfs noatime only, enabled md-raid read optimizations)
>> # dd if=3D/dev/zero of=3D10gb bs=3D1M count=3D10240
>> 10737418240 bytes (11 GB) copied, 105.178 seconds, 102 MB/s
>> # dd if=3D10gb of=3D/dev/zero bs=3D1M count=3D10240
>> 10737418240 bytes (11 GB) copied, 17.4893 seconds, 614 MB/s
>>=20
>> -----
>>=20
>> I am sure one of your questions is, well, why use SW RAID5 on the=20
>> controller?  Because SW RAID5 is usually much faster than HW RAID5, at=
=20
>> least in my tests:
>>=20
>> Ctl   Model        Ports   Drives   Units   NotOpt   RRate   VRate   BBU
>> ------------------------------------------------------------------------
>> c0    9550SXU-12   12      12       3       0        1       4       -
>>=20
>> Unit  UnitType  Status         %Cmpl  Stripe  Size(GB)  Cache  AVerify=
=20
>> IgnECC
>>=20
>> ------------------------------------------------------------------------=
------=20
>> u0    RAID-1    OK             -      -       698.481   ON     ON       =
OFF
>> u1    RAID-5    OK             -      64K     5587.85   ON     OFF      =
OFF
>> u2    SPARE     OK             -      -       698.629   -      OFF      -
>>=20
>> --> XFS:
>> # dd if=3D/dev/zero of=3D10gb bs=3D1M count=3D10240
>> 10737418240 bytes (11 GB) copied, 74.5648 seconds, 144 MB/s
>>=20
>> --> JFS:
>> # dd if=3D/dev/zero of=3D10gb bs=3D1M count=3D10240
>> 10737418240 bytes (11 GB) copied, 108.631 seconds, 98.8 MB/s
>>=20
>> The controller is set to performance, and this is nothing close to=20
>> performance.
>
> How much is your RAM size? Is the size you tried (10G) at
> least twice the size of the RAM seen by the OS? What
> are the values returned by hdparm -t /dev/sda (it test only raw reading
> speed)?
>
Total: 4GB of ram-- I am using the array for other things right now, did=20
not get a chance to run that.

>>=20
>> In RAID0, the controller is ok with the disks JBOD, but I cannot recomme=
nd=20
>> buying a controller (12,16,24 port) for Linux SW RAID 5.
>>=20
>> Its too bad that there are no regular > 4 port SATA PCI-e controllers ou=
t=20
>> there.
>>=20
>> Justin.
>>=20
>
> Indeed not exists for PCI-e but Oden has spotted this PCI-X card
> (which is around 97$), based on marvell chipset:
>
> http://www.supermicro.com/products/accessories/addon/AoC-SAT2-MV8.cfm
>
> which can be used on motherboard with PCI-X slot (the ASUS M2N32 WS=20
> Professional
> AM2, or the ASUS P5W64-WS-PRO, both are for consumer desktop and have 2 P=
CI-X=20
> slots) though probably if you have either one of that mobo you already ha=
ve=20
> at least 10 onboard SATA connectors.
Indeed, wish there was a PCI-e version!

>
> Bye
> Giuseppe.
>=

---1463747160-1464876308-1184757632=:7659--
