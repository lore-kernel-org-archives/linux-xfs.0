Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C1C907F78
	for <xfs@oss.sgi.com>; Thu,  9 Apr 2015 22:23:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3EF5DAC001
	for <xfs@oss.sgi.com>; Thu,  9 Apr 2015 20:23:20 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id kNmPj1p9MCy7yJMR (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 09 Apr 2015 20:23:18 -0700 (PDT)
Date: Fri, 10 Apr 2015 13:22:53 +1000
From: NeilBrown <neilb@suse.de>
Subject: Re: interesting MD-xfs bug
Message-ID: <20150410132253.644e3660@notabene.brown>
In-Reply-To: <20150410013156.GH15810@dastard>
References: <5526E8E9.3030805@gmail.com> <20150409221846.GG13731@dastard>
	<5526FB2A.8060704@gmail.com> <20150409225322.GH13731@dastard>
	<20150409231035.GI13731@dastard>
	<20150410093652.73204748@notabene.brown>
	<20150410013156.GH15810@dastard>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1938170578502426331=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, xfs <xfs@oss.sgi.com>, Joe Landman <joe.landman@gmail.com>

--===============1938170578502426331==
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/02vtdpu3HfV619wvKnY.7Pi"; protocol="application/pgp-signature"

--Sig_/02vtdpu3HfV619wvKnY.7Pi
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 10 Apr 2015 11:31:57 +1000 Dave Chinner <david@fromorbit.com> wrote:

> On Fri, Apr 10, 2015 at 09:36:52AM +1000, NeilBrown wrote:
> > On Fri, 10 Apr 2015 09:10:35 +1000 Dave Chinner <david@fromorbit.com> w=
rote:
> >=20
> > > On Fri, Apr 10, 2015 at 08:53:22AM +1000, Dave Chinner wrote:
> > > > On Thu, Apr 09, 2015 at 06:20:26PM -0400, Joe Landman wrote:
> > > > >=20
> > > > >=20
> > > > > On 04/09/2015 06:18 PM, Dave Chinner wrote:
> > > > > >On Thu, Apr 09, 2015 at 05:02:33PM -0400, Joe Landman wrote:
> > > > > >>If I build an MD raid0 with a non power of 2 chunk size, it app=
ears
> > > > > >>that I can mkfs.xfs a file system, but it doesn't show up in bl=
kid
> > > > > >>and is not mountable.  Yet, using a power of 2 chunk size, this=
 does
> > > > > >>work correctly.   This is kernel 3.18.9.
> > > > > >>
> > > > >=20
> > > > > [...]
> > > > >=20
> > > > > >That looks more like a blkid or udev problem. try using blkid -p=
 so
> > > > > >that it doesn't look up the cache but directly probes devices for
> > > > > >the signatures. strace might tell you a bit more, too. And if the
> > > > > >filesystem mounts, then it definitely isn't an XFS problem ;)
> > > > >=20
> > > > > Thats the thing, it didn't mount, even when I used the device name
> > > > > directly.
> > > >=20
> > > > Ok, that's interesting. Let me see if I can reproduce it locally. If
> > > > you don't hear otherwise, tracing would still be useful. Thanks for
> > > > the bug report, Joe.
> > >=20
> > > No luck - md doesn't allow the device to be activated on 4.0-rc7:
> > >=20
> > > $ sudo mdadm --version
> > > mdadm - v3.3.2 - 21st August 2014
> > > $ uname -a
> > > Linux test4 4.0.0-rc7-dgc+ #882 SMP Fri Apr 10 08:50:52 AEST 2015 x86=
_64 GNU/Linux
> > > $ sudo wipefs -a /dev/vd[ab]
> > > /dev/vda: 4 bytes were erased at offset 0x00001000 (linux_raid_member=
): fc 4e 2b a9
> > > /dev/vdb: 4 bytes were erased at offset 0x00001000 (linux_raid_member=
): fc 4e 2b a9
> > > $ sudo mdadm --create /dev/md20 --level=3D0 --metadata=3D1.2 --chunk=
=3D1152 --auto=3Dyes --raid-disks=3D2 /dev/vd[ab]
> >=20
> > Weird.  Works for me.
> > Any messages in 'dmesg' ??
> > How big are /dev/vd[ab]??
>=20
> vda is 5GB, vdb is 20GB
>=20
> dmesg:
>=20
> [  125.131340] md: bind<vda>
> [  125.134547] md: bind<vdb>
> [  125.139669] md: personality for level 0 is not loaded!
> [  125.141302] md: md20 stopped.
> [  125.141986] md: unbind<vdb>
> [  125.160100] md: export_rdev(vdb)
> [  125.161751] md: unbind<vda>
> [  125.180126] md: export_rdev(vda)
>=20
> Oh, curious. Going from 4.0-rc4 to 4.0-rc7, and make oldconfig
> has resulted in:
>=20
> # CONFIG_MD_RAID0 is not set
>=20
> Ok, so with that fixed, it's still horribly broken.
>=20
> RAID 0 on different sized devices should result in a device that is
> twice the size of the smallest devices:
>=20
> $ sudo mdadm --create /dev/md20 --level=3Draid0 --metadata=3D1.2 --chunk=
=3D1024 --auto=3Dyes --raid-disks=3D2 /dev/vd[ab]
> mdadm: array /dev/md20 started.
> $ cat /proc/mdstat
> Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [raid4]=
=20
> md20 : active raid0 vdb[1] vda[0]
>       26206208 blocks super 1.2 1024k chunks
>      =20
> unused devices: <none>
> $ grep "md\|vd[ab]" /proc/partitions=20
>  253        0    5242880 vda
>  253       16   20971520 vdb
>    9       20   26206208 md20
> $
>=20
> Oh, "RAID0" is not actually RAID 0 - that's the size I'd expect from
> a linear mapping. Half way through writing that block device, the IO
> stats change in an obvious way:
>=20
> Device:         r/s     w/s    rMB/s    wMB/s
> vda            0.00  144.00     0.00    48.00
> vdb            0.00  145.20     0.00    48.40
> md20           0.00  290.40     0.00    96.80
>=20
> Device:         r/s     w/s    rMB/s    wMB/s
> vda            0.00   56.40     0.00    18.80
> vdb            0.00  229.20     0.00    76.40
> md20           0.00  285.20     0.00    95.10
>=20
> Device:         r/s     w/s    rMB/s    wMB/s
> vda            0.00    0.00     0.00     0.00
> vdb            0.00  290.40     0.00    96.80
> md20           0.00  290.80     0.00    96.90
>=20
> So it's actually a stripe for the first 10GB, then some kind of
> concatenated mapping of the remainder of the single device. That's
> not what I expected, but it's also clearly not the problem.
>=20
> Anyway, change the stripe size to 1152:
>=20
> sudo mdadm --stop /dev/md20
> mdadm: stopped /dev/md20
> $ sudo wipefs -a /dev/vd[ab]
> /dev/vda: 4 bytes were erased at offset 0x00001000 (linux_raid_member): f=
c 4e 2b a9
> /dev/vdb: 4 bytes were erased at offset 0x00001000 (linux_raid_member): f=
c 4e 2b a9
> $ sudo mdadm --create /dev/md20 --level=3Draid0 --metadata=3D1.2 --chunk=
=3D1152 --auto=3Dyes --raid-disks=3D2 /dev/vd[ab]
> mdadm: array /dev/md20 started.
> $ sudo xfs_io -fd -c "pwrite -b 4m 0 25g" /dev/md20
> wrote 26831355904/26843545600 bytes at offset 0
> 24.989 GiB, 6398 ops; 0:00:16.00 (1.530 GiB/sec and 391.8556 ops/sec)
> $
>=20
> Wait, what? Neil, did you put a flux capacitor in MD? :P=20
>=20
> The underlying drive is only capable of 100MB/s - 25GB of sequential
> direct IO does not complete in 16 seconds on such a drive. But
> there's also a 1GB BBWC in front of the physical drives (HW RAID1),
> but even so, this write rate could only occur if every write is
> hitting the BBWC. And so it is:
>=20
> $ sudo xfs_io -fd -c "pwrite -b 4m 0 25g" /dev/md20 & iostat -d -m 1
> ...
> Device:            tps    MB_read/s    MB_wrtn/s    MB_read    MB_wrtn
> vda            4214.00         0.00      1516.99          0       1516
> vdb               0.00         0.00         0.00          0          0
> md20           4223.00         0.00      1520.00          0       1520
>=20
> Device:            tps    MB_read/s    MB_wrtn/s    MB_read    MB_wrtn
> vda            2986.00         0.00      1075.01          0       1075
> vdb            1174.00         0.00       422.88          0        422
> md20           4154.00         0.00      1496.00          0       1496
>=20
> Device:            tps    MB_read/s    MB_wrtn/s    MB_read    MB_wrtn
> vda               0.00         0.00         0.00          0          0
> vdb            4376.00         0.00      1575.12          0       1575
> md20           4378.00         0.00      1576.00          0       1576
>=20
> Device:            tps    MB_read/s    MB_wrtn/s    MB_read    MB_wrtn
> vda            2682.00         0.00       965.74          0        965
> vdb            1650.00         0.00       594.00          0        594
> md20           4334.00         0.00      1560.00          0       1560
>=20
> Device:            tps    MB_read/s    MB_wrtn/s    MB_read    MB_wrtn
> vda            4518.00         0.00      1626.26          0       1626
> vdb             138.00         0.00        49.50          0         49
> md20           4656.00         0.00      1676.00          0       1676
>=20
> Device:            tps    MB_read/s    MB_wrtn/s    MB_read    MB_wrtn
> vda               0.00         0.00         0.00          0          0
> vdb            4214.00         0.00      1517.48          0       1517
> md20           4210.00         0.00      1516.00          0       1516
> .....
>=20
> Note how it is cycling from one drive to the other with about a 2s
> period?
>=20
> Yup, blocktrace on /dev/vda shows it is, indeed, hitting the BBWC
> because the block mapping is clearly broken:
>=20
> 253,0    4        1     0.000000000  6972  Q  WS 8192 + 1008 [xfs_io]
> 253,0    4        5     0.000068012  6972  Q  WS 8192 + 1008 [xfs_io]
> 253,0    4        9     0.000093266  6972  Q  WS 8192 + 288 [xfs_io]
> 253,0    4       13     0.000129722  6972  Q  WS 8193 + 1008 [xfs_io]
> 253,0    4       17     0.000176872  6972  Q  WS 8193 + 1008 [xfs_io]
> 253,0    4       21     0.000205566  6972  Q  WS 8193 + 288 [xfs_io]
> 253,0    4       25     0.000240846  6972  Q  WS 8194 + 1008 [xfs_io]
> 253,0    4       29     0.000284990  6972  Q  WS 8194 + 1008 [xfs_io]
> 253,0    4       33     0.000313276  6972  Q  WS 8194 + 288 [xfs_io]
> 253,0    4       37     0.000352330  6972  Q  WS 8195 + 1008 [xfs_io]
> 253,0    4       41     0.000374272  6972  Q  WS 8195 + 272 [xfs_io]
> 253,0    4       56     0.001215857  6972  Q  WS 8195 + 1008 [xfs_io]
> 253,0    4       60     0.001252697  6972  Q  WS 8195 + 16 [xfs_io]
> 253,0    4       64     0.001284517  6972  Q  WS 8196 + 1008 [xfs_io]
> 253,0    4       68     0.001326130  6972  Q  WS 8196 + 1008 [xfs_io]
> 253,0    4       72     0.001355050  6972  Q  WS 8196 + 288 [xfs_io]
> 253,0    4       76     0.001393777  6972  Q  WS 8197 + 1008 [xfs_io]
> 253,0    4       80     0.001439547  6972  Q  WS 8197 + 1008 [xfs_io]
> 253,0    4       84     0.001466097  6972  Q  WS 8197 + 288 [xfs_io]
> 253,0    4       88     0.001501267  6972  Q  WS 8198 + 1008 [xfs_io]
> 253,0    4       92     0.001545863  6972  Q  WS 8198 + 1008 [xfs_io]
> 253,0    4       96     0.001571500  6972  Q  WS 8198 + 288 [xfs_io]
> 253,0    4      100     0.001584620  6972  Q  WS 8199 + 256 [xfs_io]
> 253,0    4      116     0.002730034  6972  Q  WS 8199 + 1008 [xfs_io]
> 253,0    4      120     0.002792351  6972  Q  WS 8199 + 1008 [xfs_io]
> 253,0    4      124     0.002810937  6972  Q  WS 8199 + 32 [xfs_io]
> 253,0    4      128     0.002842047  6972  Q  WS 8200 + 1008 [xfs_io]
> 253,0    4      132     0.002889087  6972  Q  WS 8200 + 1008 [xfs_io]
> 253,0    4      136     0.002916894  6972  Q  WS 8200 + 288 [xfs_io]
> 253,0    4      140     0.002952334  6972  Q  WS 8201 + 1008 [xfs_io]
> 253,0    4      144     0.002996101  6972  Q  WS 8201 + 1008 [xfs_io]
> 253,0    4      148     0.003022401  6972  Q  WS 8201 + 288 [xfs_io]
>=20
>=20
> Multiple IOs to teh same sector, then the sector increments by 1 and
> we get more IOs to the same sector offset. After about a second the
> mapping shifts IO to the other block device as it slowly increments
> the sector, and that's why we see that cycling behaviour.
>=20
> IOWs, something is going wrong with the MD block mapping when the
> RAID chunk size is not a power of 2....
>=20
> Over to you, Neil....

That's .... not good.  Not good at all.

This should help. It seems that non-power-of-2 chunksizes aren't widely use=
d.

Thanks,
NeilBrown


From: NeilBrown <neilb@suse.de>
Date: Fri, 10 Apr 2015 13:19:04 +1000
Subject: [PATCH] md/raid0: fix bug with chunksize not a power of 2.

Since commit 20d0189b1012a37d2533a87fb451f7852f2418d1
in v3.14-rc1 RAID0 has performed incorrect calculations
when the chunksize is not a power of 2.

This happens because "sector_div()" modifies its first argument, but
this wasn't taken into account in the patch.

So restore that first arg before re-using the variable.

Reported-by: Joe Landman <joe.landman@gmail.com>
Reported-by: Dave Chinner <david@fromorbit.com>
Fixes: 20d0189b1012a37d2533a87fb451f7852f2418d1
Cc: stable@vger.kernel.org (3.14 and later).
Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index e074813da6c0..2cb59a641cd2 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -315,7 +315,7 @@ static struct strip_zone *find_zone(struct r0conf *conf,
=20
 /*
  * remaps the bio to the target device. we separate two flows.
- * power 2 flow and a general flow for the sake of perfromance
+ * power 2 flow and a general flow for the sake of performance
 */
 static struct md_rdev *map_sector(struct mddev *mddev, struct strip_zone *=
zone,
 				sector_t sector, sector_t *sector_offset)
@@ -530,6 +530,7 @@ static void raid0_make_request(struct mddev *mddev, str=
uct bio *bio)
 			split =3D bio;
 		}
=20
+		sector =3D bio->bi_iter.bi_sector;
 		zone =3D find_zone(mddev->private, &sector);
 		tmp_dev =3D map_sector(mddev, zone, sector, &sector);
 		split->bi_bdev =3D tmp_dev->bdev;

--Sig_/02vtdpu3HfV619wvKnY.7Pi
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVSdCEjnsnt1WYoG5AQKT+Q/+PzWsahElSH2BEtSp+Ztqa9S1xzz8R4HO
9Z9pPCd00+tSwUV/Nhmu1dqzsOZGhg2VZ0g4WgCWJDZSEd2s3gjz2bqURYRK8Sci
PfitzsoNYt71Ep9eKVG+uLiQKEqVDhXO0qzp9heKThNdCkzNnxCgnEYHtDkAU1H3
SxON3xJ3vBJGNMYjC0NFTbmxasjGXzop2qDGdNHg0fZSVjlceX/NuqBkdrSpLS2r
4cSlG9wS2KTuCXDwmfvd3WmOMJu8JulxoYFX2zTCzKgdJwz2bjesI+Ap8xFk0YSQ
zxqrn1mRxJzudIcD5WV3GLrlRppQoSnFLN0T3AEHDsk4Nxiw604kNMol7juhlD/l
I2OTMYv5xU3pzODSQ6pyZGegCuinl+mf/jFaiwhEuKS5KNNkV+962/cSj8gaca3e
XSmQK36ZTJNIIJfwfUu0wTI7H3p/qBb/wGkHO+gf/TrXIzA+hbKrUjsQvqnIECN6
g/O2+TCXaE3f1NIggmjp63JkL59BHUOwr2PQ9MaD9Il6DhzeH8ssmUWGdLpT5KCU
YsQLxHQLv2e64keJDA19fBBo8e5UW70NWUN2/kqydB3A6NZeF0qnRFSCpJlxvBVh
dqnCglD13d8TOzyhn54VAmBaqSFK++aIVl0Ql4vumJBwikplKbKlXhTryvnH4yWt
ZfqHdKOowp8=
=S7VJ
-----END PGP SIGNATURE-----

--Sig_/02vtdpu3HfV619wvKnY.7Pi--


--===============1938170578502426331==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1938170578502426331==--
