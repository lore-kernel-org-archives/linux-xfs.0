Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw0-f182.google.com ([209.85.161.182]:35938 "EHLO
        mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751227AbcLDXYx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 4 Dec 2016 18:24:53 -0500
Received: by mail-yw0-f182.google.com with SMTP id a10so244985768ywa.3
        for <linux-xfs@vger.kernel.org>; Sun, 04 Dec 2016 15:24:53 -0800 (PST)
Content-Type: text/plain; charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 10.1 \(3251\))
Subject: Re: XFS: possible memory allocation deadlock in kmem_alloc on
 glusterfs setup
From: Cyril Peponnet <cyril.peponnet@nuagenetworks.net>
In-Reply-To: <20161204224604.GN31101@dastard>
Date: Sun, 4 Dec 2016 15:24:50 -0800
Content-Transfer-Encoding: quoted-printable
Message-Id: <D3BB642A-1CBB-47CB-89AA-E99837228F35@nuagenetworks.net>
References: <E861E5C1-D1C2-4368-8BFC-505533C9A3A3@nuagenetworks.net>
 <20161204214950.GL31101@dastard>
 <9B23CFED-4AFC-46FC-8E35-AD85B11FEA02@nuagenetworks.net>
 <20161204224604.GN31101@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org


> On Dec 4, 2016, at 2:46 PM, Dave Chinner <david@fromorbit.com> wrote:
>=20
> On Sun, Dec 04, 2016 at 02:07:18PM -0800, Cyril Peponnet wrote:
>> Hi here is the details. The issue is on the scratch RAID array
>> (used to store kvm snapshots). The other raid array is fine (no
>> snapshot storage).
>=20
> How do you know that? There's no indication which filesystem is
> generating the warnings=E2=80=A6.

Because on the hypervisors I have both mount points and only the one =
that access to scratch array was hanging when the deadlock occurs.

>=20
> FWIW, the only gluster snapshot proposal that I was aware of
> was this one:
>=20
> https://lists.gnu.org/archive/html/gluster-devel/2013-08/msg00004.html
>=20
> Which used LVM snapshots to take snapshots of the entire brick. I
> don't see any LVM in your config, so I'm not sure what snapshot
> implementation you are using here. What are you using to take the
> snapshots of your VM image files? Are you actually using the
> qemu qcow2 snapshot functionality rather than anything native to
> gluster?
>=20

Yes sorry it was not clear enough, qemu-img snapshots no native =
snapshots.

> Also, can you attach the 'xfs_bmap -vp' output of some of these
> image files and their snapshots?

A snapshot: =
https://gist.github.com/CyrilPeponnet/8108c74b9e8fd1d9edbf239b2872378d =
(let me know if you need more basically there is around 600 live =
snapshots sitting here).


>=20
>> MemTotal:       65699268 kB
>=20
> 64GB RAM...
>=20
>> MemFree:         2058304 kB
>> MemAvailable:   62753028 kB
>> Buffers:              12 kB
>> Cached:         57664044 kB
>=20
> 56GB of cached file data. If you're getting high order allocation
> failures (which I suspect is the problem) then this is a memory
> fragmentation problem more than anything.
>=20
>> ----------------------------------------------------------------
>> DG/VD TYPE  State Access Consist Cache Cac sCC     Size Name
>> ----------------------------------------------------------------
>> 0/0   RAID0 Optl  RW     Yes     RAWBC -   ON  7.275 TB scratch
>> ----------------------------------------------------------------
>>=20
>> Cac=3DCacheCade|Rec=3DRecovery|OfLn=3DOffLine|Pdgd=3DPartially =
Degraded|dgrd=3DDegraded
>> Optl=3DOptimal|RO=3DRead Only|RW=3DRead =
Write|HD=3DHidden|B=3DBlocked|Consist=3DConsistent|
>> R=3DRead Ahead Always|NR=3DNo Read Ahead|WB=3DWriteBack|
>> AWB=3DAlways WriteBack|WT=3DWriteThrough|C=3DCached IO|D=3DDirect =
IO|sCC=3DScheduled
>=20
> IIRC, AWB means that if the cache goes into degraded/offline mode,
> you=E2=80=99re vulnerable to corruption/loss on power failure=E2=80=A6

Yes we have BBU + redundant PSU to address that.

>=20
>> xfs_info /export/raid/scratch/
>> meta-data=3D/dev/sdb               isize=3D256    agcount=3D32, =
agsize=3D61030368 blks
>>         =3D                       sectsz=3D512   attr=3D2, =
projid32bit=3D1
>>         =3D                       crc=3D0
>> data     =3D                       bsize=3D4096   blocks=3D1952971776, =
imaxpct=3D5
>>         =3D                       sunit=3D32     swidth=3D128 blks
>> naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0 =
ftype=3D0
>> log      =3Dinternal               bsize=3D4096   blocks=3D521728, =
version=3D2
>>         =3D                       sectsz=3D512   sunit=3D32 blks, =
lazy-count=3D1
>> realtime =3Dnone                   extsz=3D4096   blocks=3D0, =
rtextents=3D0
>=20
> Nothing unusual there.
>=20
>> Nothing relevant in dmesg except several occurences of the following.
>>=20
>> [7649583.386283] XFS: possible memory allocation deadlock in =
kmem_alloc (mode:0x250)
>> [7649585.370830] XFS: possible memory allocation deadlock in =
kmem_alloc (mode:0x250)
>> [7649587.241290] XFS: possible memory allocation deadlock in =
kmem_alloc (mode:0x250)
>> [7649589.243881] XFS: possible memory allocation deadlock in =
kmem_alloc (mode:0x250)
>=20
> Ah, the kernel is old enough it doesn't have the added reporting to
> tell us what the process and size of the allocation being requested
> is.
>=20
> Hmm - it's an xfs_err() call, thet means we should be able to get a
> stack trace out of the kernel if we turn the error level up to 11.
>=20
> # echo 11 > /proc/sys/fs/xfs/error_level
>=20
> And wait for it to happena again. that should give a stack trace
> telling us where the issue is.

It=E2=80=99s done I will post it as soon as the issue occurs again.

Thanks Dave.

>=20
> Cheers,
>=20
> Dave.
> --=20
> Dave Chinner
> david@fromorbit.com

