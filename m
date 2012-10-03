Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q939GjSr169563 for <xfs@oss.sgi.com>; Wed, 3 Oct 2012 04:16:45 -0500
Received: from mescalin.tbi.univie.ac.at (mescalin.tbi.univie.ac.at
	[131.130.44.61]) by cuda.sgi.com with ESMTP id nghdhEx6UJy28xdP
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 03 Oct 2012 02:18:08 -0700 (PDT)
Received: from h082218137050.host.wavenet.at ([82.218.137.50]:49706
	helo=BD-MacBook.local) by mescalin.tbi.univie.ac.at with esmtpsa
	(TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32) (Exim 4.71)
	(envelope-from <hawk@tbi.univie.ac.at>) id 1TJL5i-0003ny-BB
	for xfs@oss.sgi.com; Wed, 03 Oct 2012 11:18:06 +0200
Message-ID: <506C02CB.50009@tbi.univie.ac.at>
Date: Wed, 03 Oct 2012 11:18:03 +0200
From: Richard Neuboeck <hawk@tbi.univie.ac.at>
MIME-Version: 1.0
Subject: Re: xfs mount fails 'can't read superblock'
References: <50583590.7060702@tbi.univie.ac.at>
	<20120918205508.GA31501@dastard>
	<505D85CF.9070701@tbi.univie.ac.at>
In-Reply-To: <505D85CF.9070701@tbi.univie.ac.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3224024720211611761=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--===============3224024720211611761==
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigBB4BEB546989F0A8E9FAAF2F"

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigBB4BEB546989F0A8E9FAAF2F
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi,

just in case someone stumbles over this thread in search for help. I
found a solution.

I upgraded the host machine from Ubuntu lucid to Ubuntu precise and
expected the same mounting behavior like in the virtual machine running
'precise'. However on the host no error message showed up.

Long story short after some test on the virtual machine configuration
(libvirt, qemu/kvm) it turned out to be the 'caching=3Dnone' option. Afte=
r
changing this to <driver name=3D'qemu' type=3D'raw' cache=3D'default'/>
everything works.

Richard

On 9/22/12 11:33 AM, Richard Neuboeck wrote:
> Hi Dave,
>=20
> thanks for your help! You are absolutely right.
>=20
> On 9/18/12 10:55 PM, Dave Chinner wrote:
>> On Tue, Sep 18, 2012 at 10:49:20AM +0200, Richard Neuboeck wrote:
>>> I've a XFS related problem that boggles my find and I couldn't find a=

>>> solution yet.
>>>
>>> I've got a virtual machine (huddle) that gets a ~66TB logical volume
>>> from the host handed as (virtio) block device (/dev/vdb). For ease of=

>>> maintenance I didn't partition the device but formatted it directly w=
ith
>>> xfs. The system at the time of formatting was Ubuntu Lucid 64bit.
>>
>> virtio configuration? (i.e. cache=3Dnone?)
>=20
> Yes. Virtio and cache=3Dnone.
>=20
>>> A few days ago I upgraded the virtual machine to Ubuntu LTS 'precise'=
,
>>> Kernel 3.2, and got the following error while trying to mount the dev=
ice:
>>
>> Upgraded from what?
>=20
> Ubtunu Lucid.
>=20
>>> root@huddle:~# mount /dev/vdb /mnt/storage
>>> mount: /dev/vdb: can't read superblock
>>>
>>> dmesg shows some more info:
>>> root@huddle:~# dmesg | tail
>>> [  672.774206] end_request: I/O error, dev vdb, sector 0
>>> [  672.774393] XFS (vdb): SB buffer read failed
>>>
>>> At first I thought the block device had some error and checked the
>>> virtual machine configuration and host system.
>>>
>>> From the host system (Ubuntu lucid 64bit, Kernel 2.6) I can still mou=
nt
>>> the xfs formatted device without problems. I also ran xfs_repair -n t=
hat
>>> didn't show any problem.
>>
>> So the filesystem is accesible via direct IO from the host. What's
>> the xfs_info output once it is mounted?
>=20
> xfs_info on the host system shows a 4K sector size:
>=20
> root@wirt2:~# xfs_info /mnt/temp/
> meta-data=3D/dev/mapper/storage-huddle isize=3D256    agcount=3D66,
> agsize=3D268435455 blks
>          =3D                       sectsz=3D4096  attr=3D2
> data     =3D                       bsize=3D4096   blocks=3D17572571136,=
 imaxpct=3D5
>          =3D                       sunit=3D0      swidth=3D0 blks
> naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0
> log      =3Dinternal               bsize=3D4096   blocks=3D521728, vers=
ion=3D2
>          =3D                       sectsz=3D4096  sunit=3D1 blks, lazy-=
count=3D1
> realtime =3Dnone                   extsz=3D4096   blocks=3D0, rtextents=
=3D0
>=20
>>> I tried to hand the virual machine a different ext4 formated block
>>> device (also without partition and preformatted). This didn't yield a=
ny
>>> mount problems.
>>>
>>> The Ubuntu 'precise' machine has an older kernel (2.6.32-42) too.
>>> Booting this kernel the xfs formatted block device gets mounted witho=
ut
>>> error.
>>
>> The newer kernel has a different buffer cache implementation, so
>> sector sized IO (such as superblocks) is cached and issued
>> differently.
>>
>>> The curious part is that it is still possible to mount the volume und=
er
>>> Kernel 3.2 without error using the loop option:
>>>
>>> root@huddle:~# mount -v -t xfs -o loop /dev/vdb /mnt/storage/
>>
>> Turns all IO into pagecache based IO, so 4k aligned. Will avoid any
>> sector size mismatch issues.
>>
>>> Trying xfs_repair also brings up the I/O Error unless I use it with t=
he
>>> -f option under Kernel 3.2.
>>
>> -f can turn direct IO into buffered IO is there is a sector size
>> mismatch between the filesystem and the underlying storage.
>>
>>> Obviously the problem is Kernel 3.2 related. I'm not sure if I'm at t=
he
>>> right place in the XFS Mailinglist but thought it would make a good
>>> starting point since I couldn't find anything related in bugzilla or =
the
>>> web in general and the problem didn't show up using ext4 (so may not =
be
>>> a generic kernel problem).
>>
>> Sounds like a sector size based problem to me - direct Io does
>> sector aligned and sized IO, buffered IO does page sized IO. So my
>> initial thought is that you've got a 512 byte sector filesystem on a
>> 4k sector device....
>>
>>> Running any kernel, blkid still identifies the device correctly as xf=
s
>>> volume:
>>> root@huddle:~# blkid /dev/vdb
>>> /dev/vdb: UUID=3D"5adcd575-d3f2-48c3-81de-104f125b275e" TYPE=3D"xfs"
>>
>> Buffered IO, again.
>=20
> I verified it with a 512B sector loop back device which works fine with=

> xfs (or whatever the file system choice is).
>=20
> I can only nod my head in shame. Though I know this may be the wrong
> mailinglist for my problem I have absolutely no idea how to proceed.
> Googling didn't reveal the holy grail yet. Is there a way to realign th=
e
> filesystem (without loosing the data on it)?
>=20
> Thanks!
> Richard
>=20
>> Cheers,
>>
>> Dave.
>>
>>
>>
>> _______________________________________________
>> xfs mailing list
>> xfs@oss.sgi.com
>> http://oss.sgi.com/mailman/listinfo/xfs


--------------enigBB4BEB546989F0A8E9FAAF2F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.18 (Darwin)
Comment: Using GnuPG with Mozilla - http://www.enigmail.net/

iEYEARECAAYFAlBsAssACgkQnGohgOrO9GHnXQCgxoMjM/HEbkUEzd4GoPHVTByu
k+oAoOWOxG9grrWSSE1KbIRgtCV4hUq6
=rTEw
-----END PGP SIGNATURE-----

--------------enigBB4BEB546989F0A8E9FAAF2F--


--===============3224024720211611761==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3224024720211611761==--
