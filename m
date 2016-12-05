Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw0-f176.google.com ([209.85.161.176]:35133 "EHLO
        mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751075AbcLEBWm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 4 Dec 2016 20:22:42 -0500
Received: by mail-yw0-f176.google.com with SMTP id i145so246935624ywg.2
        for <linux-xfs@vger.kernel.org>; Sun, 04 Dec 2016 17:22:41 -0800 (PST)
Content-Type: text/plain; charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 10.1 \(3251\))
Subject: Re: XFS: possible memory allocation deadlock in kmem_alloc on
 glusterfs setup
From: Cyril Peponnet <cyril.peponnet@nuagenetworks.net>
In-Reply-To: <20161204235059.GO31101@dastard>
Date: Sun, 4 Dec 2016 17:14:51 -0800
Content-Transfer-Encoding: quoted-printable
Message-Id: <A9F9389E-0CD8-4A85-BA08-C5503B781679@nuagenetworks.net>
References: <E861E5C1-D1C2-4368-8BFC-505533C9A3A3@nuagenetworks.net>
 <20161204214950.GL31101@dastard>
 <9B23CFED-4AFC-46FC-8E35-AD85B11FEA02@nuagenetworks.net>
 <20161204224604.GN31101@dastard>
 <D3BB642A-1CBB-47CB-89AA-E99837228F35@nuagenetworks.net>
 <20161204235059.GO31101@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org


> On Dec 4, 2016, at 3:50 PM, Dave Chinner <david@fromorbit.com> wrote:
>=20
> On Sun, Dec 04, 2016 at 03:24:50PM -0800, Cyril Peponnet wrote:
>>> On Dec 4, 2016, at 2:46 PM, Dave Chinner <david@fromorbit.com>
>>> Which used LVM snapshots to take snapshots of the entire brick.
>>> I don't see any LVM in your config, so I'm not sure what
>>> snapshot implementation you are using here. What are you using
>>> to take the snapshots of your VM image files? Are you actually
>>> using the qemu qcow2 snapshot functionality rather than anything
>>> native to gluster?
>>>=20
>>=20
>> Yes sorry it was not clear enough, qemu-img snapshots no native
>> snapshots.
>=20
> Ok, so that's a fragmentation problem in it's own right. both
> internal qcow2 fragmentation and file fragmentation.
>=20
>>> Also, can you attach the 'xfs_bmap -vp' output of some of these
>>> image files and their snapshots?
>>=20
>> A snapshot:
>> =
https://gist.github.com/CyrilPeponnet/8108c74b9e8fd1d9edbf239b2872378d
>> (let me know if you need more basically there is around 600 live
>> snapshots sitting here).
>=20
> 1200 extents, mostly small, almost entirely adjacent. Typical qcow2
> file fragmentation pattern. That's not going to cause your memory
> allocation problems - can you find one that has hundreds of
> thousands of extents?

I found one with 10799109 :/ 576GB in size (I need to find why this one =
is so big this is not normal=E2=80=A6)=E2=80=A6 Could it lead to the =
issue? I mean could one file cause the deadlock of the entire FS?

>=20
>>>=20
>>> 56GB of cached file data. If you're getting high order
>>> allocation failures (which I suspect is the problem) then this
>>> is a memory fragmentation problem more than anything.
>>>=20
>>>> ----------------------------------------------------------------
>>>> DG/VD TYPE  State Access Consist Cache Cac sCC     Size Name
>>>> ----------------------------------------------------------------
>>>> 0/0   RAID0 Optl  RW     Yes     RAWBC -   ON  7.275 TB scratch
>>>> ----------------------------------------------------------------
>>>>=20
>>>> Cac=3DCacheCade|Rec=3DRecovery|OfLn=3DOffLine|Pdgd=3DPartially
>>>> Degraded|dgrd=3DDegraded Optl=3DOptimal|RO=3DRead Only|RW=3DRead
>>>> Write|HD=3DHidden|B=3DBlocked|Consist=3DConsistent| R=3DRead Ahead
>>>> Always|NR=3DNo Read Ahead|WB=3DWriteBack| AWB=3DAlways
>>>> WriteBack|WT=3DWriteThrough|C=3DCached IO|D=3DDirect =
IO|sCC=3DScheduled
>>>=20
>>> IIRC, AWB means that if the cache goes into degraded/offline
>>> mode, you=E2=80=99re vulnerable to corruption/loss on power
>>> failure=E2=80=A6
>>=20
>> Yes we have BBU + redundant PSU to address that.
>=20
> BBU fails, data center loses power, corruption/data loss still
> occurs. Not my problem, though.
>=20
> Cheers,
>=20
> Dave.
> --=20
> Dave Chinner
> david@fromorbit.com

