Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8M9Vx4j063873 for <xfs@oss.sgi.com>; Sat, 22 Sep 2012 04:32:00 -0500
Received: from mescalin.tbi.univie.ac.at (mescalin.tbi.univie.ac.at
	[131.130.44.61]) by cuda.sgi.com with ESMTP id LcfMVypBkIWNK8Ky
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 22 Sep 2012 02:33:13 -0700 (PDT)
Message-ID: <505D85CF.9070701@tbi.univie.ac.at>
Date: Sat, 22 Sep 2012 11:33:03 +0200
From: Richard Neuboeck <hawk@tbi.univie.ac.at>
MIME-Version: 1.0
Subject: Re: xfs mount fails 'can't read superblock'
References: <50583590.7060702@tbi.univie.ac.at>
	<20120918205508.GA31501@dastard>
In-Reply-To: <20120918205508.GA31501@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1745204723883485070=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--===============1745204723883485070==
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigE0B170903D3D0C8C6F21481C"

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigE0B170903D3D0C8C6F21481C
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Dave,

thanks for your help! You are absolutely right.

On 9/18/12 10:55 PM, Dave Chinner wrote:
> On Tue, Sep 18, 2012 at 10:49:20AM +0200, Richard Neuboeck wrote:
>> I've a XFS related problem that boggles my find and I couldn't find a
>> solution yet.
>>
>> I've got a virtual machine (huddle) that gets a ~66TB logical volume
>> from the host handed as (virtio) block device (/dev/vdb). For ease of
>> maintenance I didn't partition the device but formatted it directly wi=
th
>> xfs. The system at the time of formatting was Ubuntu Lucid 64bit.
>=20
> virtio configuration? (i.e. cache=3Dnone?)

Yes. Virtio and cache=3Dnone.

>> A few days ago I upgraded the virtual machine to Ubuntu LTS 'precise',=

>> Kernel 3.2, and got the following error while trying to mount the devi=
ce:
>=20
> Upgraded from what?

Ubtunu Lucid.

>> root@huddle:~# mount /dev/vdb /mnt/storage
>> mount: /dev/vdb: can't read superblock
>>
>> dmesg shows some more info:
>> root@huddle:~# dmesg | tail
>> [  672.774206] end_request: I/O error, dev vdb, sector 0
>> [  672.774393] XFS (vdb): SB buffer read failed
>>
>> At first I thought the block device had some error and checked the
>> virtual machine configuration and host system.
>>
>> From the host system (Ubuntu lucid 64bit, Kernel 2.6) I can still moun=
t
>> the xfs formatted device without problems. I also ran xfs_repair -n th=
at
>> didn't show any problem.
>=20
> So the filesystem is accesible via direct IO from the host. What's
> the xfs_info output once it is mounted?

xfs_info on the host system shows a 4K sector size:

root@wirt2:~# xfs_info /mnt/temp/
meta-data=3D/dev/mapper/storage-huddle isize=3D256    agcount=3D66,
agsize=3D268435455 blks
         =3D                       sectsz=3D4096  attr=3D2
data     =3D                       bsize=3D4096   blocks=3D17572571136, i=
maxpct=3D5
         =3D                       sunit=3D0      swidth=3D0 blks
naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0
log      =3Dinternal               bsize=3D4096   blocks=3D521728, versio=
n=3D2
         =3D                       sectsz=3D4096  sunit=3D1 blks, lazy-co=
unt=3D1
realtime =3Dnone                   extsz=3D4096   blocks=3D0, rtextents=3D=
0

>> I tried to hand the virual machine a different ext4 formated block
>> device (also without partition and preformatted). This didn't yield an=
y
>> mount problems.
>>
>> The Ubuntu 'precise' machine has an older kernel (2.6.32-42) too.
>> Booting this kernel the xfs formatted block device gets mounted withou=
t
>> error.
>=20
> The newer kernel has a different buffer cache implementation, so
> sector sized IO (such as superblocks) is cached and issued
> differently.
>=20
>> The curious part is that it is still possible to mount the volume unde=
r
>> Kernel 3.2 without error using the loop option:
>>
>> root@huddle:~# mount -v -t xfs -o loop /dev/vdb /mnt/storage/
>=20
> Turns all IO into pagecache based IO, so 4k aligned. Will avoid any
> sector size mismatch issues.
>=20
>> Trying xfs_repair also brings up the I/O Error unless I use it with th=
e
>> -f option under Kernel 3.2.
>=20
> -f can turn direct IO into buffered IO is there is a sector size
> mismatch between the filesystem and the underlying storage.
>=20
>> Obviously the problem is Kernel 3.2 related. I'm not sure if I'm at th=
e
>> right place in the XFS Mailinglist but thought it would make a good
>> starting point since I couldn't find anything related in bugzilla or t=
he
>> web in general and the problem didn't show up using ext4 (so may not b=
e
>> a generic kernel problem).
>=20
> Sounds like a sector size based problem to me - direct Io does
> sector aligned and sized IO, buffered IO does page sized IO. So my
> initial thought is that you've got a 512 byte sector filesystem on a
> 4k sector device....
>=20
>> Running any kernel, blkid still identifies the device correctly as xfs=

>> volume:
>> root@huddle:~# blkid /dev/vdb
>> /dev/vdb: UUID=3D"5adcd575-d3f2-48c3-81de-104f125b275e" TYPE=3D"xfs"
>=20
> Buffered IO, again.

I verified it with a 512B sector loop back device which works fine with
xfs (or whatever the file system choice is).

I can only nod my head in shame. Though I know this may be the wrong
mailinglist for my problem I have absolutely no idea how to proceed.
Googling didn't reveal the holy grail yet. Is there a way to realign the
filesystem (without loosing the data on it)?

Thanks!
Richard

> Cheers,
>=20
> Dave.
>=20


--------------enigE0B170903D3D0C8C6F21481C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.18 (Darwin)
Comment: Using GnuPG with Mozilla - http://www.enigmail.net/

iEYEARECAAYFAlBdhdEACgkQnGohgOrO9GENvwCghxHlIFjOOf+RdXlnBYnwEKCU
8lQAoPCMNJuINRZtkoBUbr48p6X2HIq3
=nMNy
-----END PGP SIGNATURE-----

--------------enigE0B170903D3D0C8C6F21481C--


--===============1745204723883485070==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1745204723883485070==--
