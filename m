Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B98B57FCD
	for <xfs@oss.sgi.com>; Fri, 24 Jan 2014 01:56:38 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 97515304043
	for <xfs@oss.sgi.com>; Thu, 23 Jan 2014 23:56:35 -0800 (PST)
Received: from zmail.inovex.de (zmail.inovex.de [85.115.6.137]) by
	cuda.sgi.com with ESMTP id BRfEic7uF4Y8kj63 for
	<xfs@oss.sgi.com>; Thu, 23 Jan 2014 23:56:33 -0800 (PST)
Mime-Version: 1.0 (Mac OS X Mail 7.1 \(1827\))
Subject: Re: Weird XFS Corruption Error
From: Sascha Askani <saskani@inovex.de>
In-Reply-To: <20140122233141.GI27606@dastard>
Date: Fri, 24 Jan 2014 08:56:32 +0100
Message-Id: <FF1E62DE-5CFC-469B-BBF7-F5AB04AD4C0C@inovex.de>
References: <CDBC891F-BCF6-4B9B-ADDB-9E143973D188@inovex.de>
	<20140122233141.GI27606@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3137022429826763886=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com


--===============3137022429826763886==
Content-Type: multipart/signed; boundary="Apple-Mail=_C562A3D2-2CF8-4479-8A45-891CF2219301"; protocol="application/pgp-signature"; micalg=pgp-sha512


--Apple-Mail=_C562A3D2-2CF8-4479-8A45-891CF2219301
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=windows-1252

Hi Dave,=20

thanks for your reply and I=92m sorry for the delayed answer=85

Am 23.01.2014 um 00:31 schrieb Dave Chinner <david@fromorbit.com>:

> On Wed, Jan 22, 2014 at 05:09:10PM +0100, Sascha Askani wrote:
>=20
> So, an inode extent map btree block failed verification for some
> reason. Hmmm - there should have been 4 lines of hexdump output
> there as well. Can you post that as well? Or have you modified
> /proc/sys/fs/xfs/error_level to have a value of 0 so it is not
> emitted?
>=20

/proc/sys/fs/xfs/error_level is set to 3, sorry for not including this =
in my original post, the Hexdump is pretty =84boring=93 (or interesting, =
depending on your point of view):

[964197.435322] ffff881f8e59b000: 00 00 00 00 00 00 00 00 00 00 00 00 00 =
00 00 00  ................
[964197.862037] ffff881f8e59b010: 00 00 00 00 00 00 00 00 00 00 00 00 00 =
00 00 00  ................
[964198.288694] ffff881f8e59b020: 00 00 00 00 00 00 00 00 00 00 00 00 00 =
00 00 00  ................
[964198.712093] ffff881f8e59b030: 00 00 00 00 00 00 00 00 00 00 00 00 00 =
00 00 00  ................

> And not the disk address of the buffer? 0x1f0 - it's right near the
> start of the volume.
>=20
>=20
>> [964199.139324] XFS (dm-8): I/O Error Detected. Shutting down =
filesystem
>> [964199.139325] XFS (dm-8): Please umount the filesystem and rectify =
the problem(s)
>> [964212.367300] XFS (dm-8): xfs_log_force: error 5 returned.
>> [964242.477283] XFS (dm-8): xfs_log_force: error 5 returned.
>> ---------------------------------------------------------
>>=20
>> After that, I tried the following (in order):
>=20
> Do you have the output and log messages from these steps? That would
> be realy helpful in confirming any diagnosis.

Unfortunately, the output got lost due to a reboot, but basically =
xfs_repair scanned the whole volume after failing to find a primary =
superblock, emitting Millions of dots in the process.

>=20
>> 1. xfs_repair, which did not find the superblock and started scanning =
the LV, after finding the secondary superblock, it told me there=92s =
still something in the log, so I
>=20
> Oh, wow. Ok, if the primary superblock is gone, along with metadata
> in the first few blocks of the filesystem, then something has
> overwritten the start of the block device the filesystem is on.
>=20
>> 2. mounted the filesystem, which gave me a =84Structure needs =
cleaning=93 after a couple of seconds
>> 3. tried mounting again for good measure, same error =84Structure =
needs cleaning=93
>=20
> Right - the kernel can't read a valid superlock, either.

Just seen this messages in the log which were emitted when trying to =
mount the FS:

[964606.038733] XFS (dm-8): metadata I/O error: block 0x200 =
("xlog_recover_do..(read#2)") error 117 numblks 16
[964606.515048] XFS (dm-8): log mount/recovery failed: error 117
[964606.515386] XFS (dm-8): log mount failed

>=20
>> 4. xfs_repair -L which repaired everything, and effectively cleaned =
my Filesystem in the process.
>=20
> Recreating the primary superblock from the backup superblocks
>=20
>> 5. mount the filesystem to find it empty.
>=20
> Because the root inode was lost, along with AGI 0 and so all
> the inodes in the first AG were completely lost as all the redundant
> information that is used to find them was trashed.

Yes, and since at the time of the error, there were only 2 Files, 1 =
Directory and 2 Hardlinks on the fs, so it=92s kind of probable that =
everything is lost.

>=20
>> Since then, I=92m desperately trying to reproduce the problem,
>> but unfortunately to no avail. Can somebody give some insight on
>> the errors I encountered. I have previously operated 4,5PB worth
>> of XFS Filesystems for 3 years and never got an error similar to
>> this.
>=20
> This doesn't look like an XFS problem. This looks like something
> overwrote the start of the block device underneath the XFS
> filesystem. I've seen this happen before with faulty SSDs, I've also
> seen it when someone issued a discard to the wrong location on a
> block device (you didn't run fstrim on the block device, did you?),
> and I've seen faulty RAID controllers cause similar issues. So right
> now I'd be looking at logs and so on for hardware/storage issues
> that occurred in the past couple of days as potential causes.

No, we did not perform any kind of trimming on the device, also, there =
are no =84discard=93 options set anywhere (mount-options, lvm.conf,=85). =
We have a pretty active MariaDB-Slave running on the same Controller =
Logical Drive / LVM VG and no errors on the other filesystems so far; =
also, mylvmbackup does not seem to have any problems.=20

Thanks for your insights so far, if you need any more information, I=92d =
be happy to provide it if possible.

Best regards,

Sascha=20

--Apple-Mail=_C562A3D2-2CF8-4479-8A45-891CF2219301
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQGcBAEBCgAGBQJS4hywAAoJEPgp1oARaIvkfSsL/3ju7gnc+WqlBmM4gyElRnyu
q1zTsWgVdXbrpAj1VavKTk/unCAYqOSBokUgcaPZ75C2oPSGUZKKNkctmjtcmRYl
fCIwVHl18DEKZTUFXib7UFqwgsCwt0iXiolz90zgaR3fGbfPxvQ6bJN9BSApmbvS
CKTVHk55RU6Iw6ugHFDKSRouTaIOgVeFQeGI8Jm4QH9pUD9ai50V9JcNEuQPVEdP
vrAFzC7xI40fX1TArxTDJ4WBt8ilgqVUJt7v5kSG6Gkg97r51FcRS8oe5X6meE9z
CVtFigBTIOGpO+TBcIk1Ex2f0pYuCwrsWsSDtQVnbdal/HgrfDnWM70/9hWuNeS2
gZPkZERw0/ga3auTqtfc/036hh4R9aXYHClIxrasbQ0VFAw8H3OKyyQ07sgvIYhL
cEaf98aJaKgZaFMBHJnZjR8g5ItayIXlfK6akxWTKsrSX8HKHwyyzn08k1NKFPvc
i612vURlh5wEDV9E1SGcq6gMnvqdXvAKSIpm6S8e/g==
=X4UJ
-----END PGP SIGNATURE-----

--Apple-Mail=_C562A3D2-2CF8-4479-8A45-891CF2219301--


--===============3137022429826763886==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3137022429826763886==--
