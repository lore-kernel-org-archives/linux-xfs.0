Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8A2T0WV126998 for <xfs@oss.sgi.com>; Thu, 9 Sep 2010 21:29:00 -0500
Received: from smtp.sauce.co.nz (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 79E845FC0F
	for <xfs@oss.sgi.com>; Thu,  9 Sep 2010 19:29:44 -0700 (PDT)
Received: from smtp.sauce.co.nz (smtp.sauce.co.nz [210.48.49.72]) by
	cuda.sgi.com with ESMTP id peddGy36wKUWzqDG for
	<xfs@oss.sgi.com>; Thu, 09 Sep 2010 19:29:44 -0700 (PDT)
Message-ID: <4C899816.6030506@sauce.co.nz>
Date: Fri, 10 Sep 2010 14:29:42 +1200
From: Richard Scobie <richard@sauce.co.nz>
MIME-Version: 1.0
Subject: Re: XFS over LVM over md RAID
References: <4C89668E.6010800@sauce.co.nz> <20100910013026.GA24409@dastard>
In-Reply-To: <20100910013026.GA24409@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="windows-1252"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Hi Dave,

Dave Chinner wrote:
> On Fri, Sep 10, 2010 at 10:58:22AM +1200, Richard Scobie wrote:
>> Using the latest, stable versions of LVM2 and xfsprogs and the
>> 2.6.35.4 kernel, I am setting up lvm on a 16 drive, 256k chunk md
>> RAID6, which has been used to date with XFS directly on the RAID.
>>
>> mkfs.xfs directly on the RAID gives:
>>
>> meta-data=3D/dev/md8               isize=3D256    agcount=3D32,
>> agsize=3D106814656 blks
>>           =3D                       sectsz=3D4096  attr=3D2
>> data     =3D                       bsize=3D4096   blocks=3D3418068864, i=
maxpct=3D5
>>           =3D                       sunit=3D64     swidth=3D896 blks
>> naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0
>>
>> which gives the correct sunit and swidth values for the array.
>>
>> Creating an lv which uses the entire array and mkfs.xfs on that, gives:
>>
>> meta-data=3D/dev/vg_local/Storage  isize=3D256    agcount=3D13,
>> agsize=3D268435455 blks
>>           =3D                       sectsz=3D512   attr=3D2
>> data     =3D                       bsize=3D4096   blocks=3D3418067968, i=
maxpct=3D5
>>           =3D                       sunit=3D0      swidth=3D0 blks
>> naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0
>
> Hmmm - it's treating MD very differently to the LVM volume -
> different numbers of AGs, different sunit/swdith. Did you
> build xfsprogs yourself? Is it linked against libblkid or libdisk?

I should clarify - the first set was created with xfsprogs 3.0.0 and =

second was done with xfsprogs 3.1.3, so I wondered if the default ag =

count had changed.

Given a 12TB array, would I be better using 32?

I did build 3.1.3. Is libblkid preferable?  I note it is defaulted off =

in configure and I used the default configuration.

l appear to have e2fsprogs and devel packages installed (Fedora 11), for =

libblkid, but when I enable and try to build, it fails:

     [CC]     xfs_mkfs.o
xfs_mkfs.c: In function =91check_overwrite=92:
xfs_mkfs.c:298: error: =91blkid_probe=92 undeclared (first use in this func=
tion)
xfs_mkfs.c:298: error: (Each undeclared identifier is reported only once
xfs_mkfs.c:298: error: for each function it appears in.)
xfs_mkfs.c:298: error: expected =91;=92 before =91pr=92
xfs_mkfs.c:321: error: =91pr=92 undeclared (first use in this function)
xfs_mkfs.c:321: warning: implicit declaration of function =

=91blkid_new_probe_from_filename=92
xfs_mkfs.c:325: warning: implicit declaration of function =

=91blkid_probe_enable_partitions=92
xfs_mkfs.c:329: warning: implicit declaration of function =

=91blkid_do_fullprobe=92
xfs_mkfs.c:345: warning: implicit declaration of function =

=91blkid_probe_lookup_value=92
xfs_mkfs.c:362: warning: implicit declaration of function =91blkid_free_pro=
be=92
xfs_mkfs.c: In function =91blkid_get_topology=92:
xfs_mkfs.c:372: error: =91blkid_topology=92 undeclared (first use in this =

function)
xfs_mkfs.c:372: error: expected =91;=92 before =91tp=92
xfs_mkfs.c:373: error: =91blkid_probe=92 undeclared (first use in this func=
tion)
xfs_mkfs.c:373: error: expected =91;=92 before =91pr=92
xfs_mkfs.c:381: error: =91pr=92 undeclared (first use in this function)
xfs_mkfs.c:385: error: =91tp=92 undeclared (first use in this function)
xfs_mkfs.c:385: warning: implicit declaration of function =

=91blkid_probe_get_topology=92
xfs_mkfs.c:397: warning: implicit declaration of function =

=91blkid_topology_get_minimum_io_size=92
xfs_mkfs.c:400: warning: implicit declaration of function =

=91blkid_topology_get_optimal_io_size=92
xfs_mkfs.c:403: warning: implicit declaration of function =

=91blkid_probe_get_sectorsize=92
xfs_mkfs.c:406: warning: implicit declaration of function =

=91blkid_topology_get_alignment_offset=92
gmake[2]: *** [xfs_mkfs.o] Error 1
gmake[1]: *** [mkfs] Error 2
make: *** [default] Error 2


> Or it might be that LVM is not exporting the characteristic of the
> underlying volume. Can you check if there are different parameter
> values exported by the two devices in /sys/block/<dev>/queue?

They look the same.

>> Limited testing using dd and bonnie++ shows no difference in write
>> performance whether I use sunit=3D64/swidth=3D896 or sunit=3D0/swidth=3D=
0 on
>> the lv.
>
> These benchmarks won't realy show any difference on an empty
> filesystem. It will have an impact on how the filesystems age and
> how well aligned the IO will be to the underlying device under more
> complex workloads...

I figured I'd go with the geometry specified.

Regards,

Richard

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
