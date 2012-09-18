Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8I8mG1X029166 for <xfs@oss.sgi.com>; Tue, 18 Sep 2012 03:48:16 -0500
Received: from mescalin.tbi.univie.ac.at (mescalin.tbi.univie.ac.at
	[131.130.44.61]) by cuda.sgi.com with ESMTP id O8f3KDLU1io2X6kN
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 18 Sep 2012 01:49:25 -0700 (PDT)
Received: from h082218137050.host.wavenet.at ([82.218.137.50]:59615
	helo=BD-MacBook.local) by mescalin.tbi.univie.ac.at with esmtpsa
	(TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32) (Exim 4.71)
	(envelope-from <hawk@tbi.univie.ac.at>) id 1TDtUf-0001n6-Tb
	for xfs@oss.sgi.com; Tue, 18 Sep 2012 10:49:24 +0200
Message-ID: <50583590.7060702@tbi.univie.ac.at>
Date: Tue, 18 Sep 2012 10:49:20 +0200
From: Richard Neuboeck <hawk@tbi.univie.ac.at>
MIME-Version: 1.0
Subject: xfs mount fails 'can't read superblock'
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3049703918064033394=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--===============3049703918064033394==
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig970F8637FCEB805773DF9AA0"

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig970F8637FCEB805773DF9AA0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi XFS gurus,

I've a XFS related problem that boggles my find and I couldn't find a
solution yet.

I've got a virtual machine (huddle) that gets a ~66TB logical volume
from the host handed as (virtio) block device (/dev/vdb). For ease of
maintenance I didn't partition the device but formatted it directly with
xfs. The system at the time of formatting was Ubuntu Lucid 64bit.

A few days ago I upgraded the virtual machine to Ubuntu LTS 'precise',
Kernel 3.2, and got the following error while trying to mount the device:=


root@huddle:~# mount /dev/vdb /mnt/storage
mount: /dev/vdb: can't read superblock

dmesg shows some more info:
root@huddle:~# dmesg | tail
[  672.774206] end_request: I/O error, dev vdb, sector 0
[  672.774393] XFS (vdb): SB buffer read failed

At first I thought the block device had some error and checked the
virtual machine configuration and host system.

=46rom the host system (Ubuntu lucid 64bit, Kernel 2.6) I can still mount=

the xfs formatted device without problems. I also ran xfs_repair -n that
didn't show any problem.

I tried to hand the virual machine a different ext4 formated block
device (also without partition and preformatted). This didn't yield any
mount problems.

The Ubuntu 'precise' machine has an older kernel (2.6.32-42) too.
Booting this kernel the xfs formatted block device gets mounted without
error.

The curious part is that it is still possible to mount the volume under
Kernel 3.2 without error using the loop option:

root@huddle:~# mount -v -t xfs -o loop /dev/vdb /mnt/storage/

Trying xfs_repair also brings up the I/O Error unless I use it with the
-f option under Kernel 3.2.

Obviously the problem is Kernel 3.2 related. I'm not sure if I'm at the
right place in the XFS Mailinglist but thought it would make a good
starting point since I couldn't find anything related in bugzilla or the
web in general and the problem didn't show up using ext4 (so may not be
a generic kernel problem).

Any suggestion for a solution (without partitioning the device) would be
greatly appreciated since the use of the loop back device doesn't
support quotas and I guess brings a performance penalty as well (but I
haven't tested it yet).

Here is some more information about the virtual machine:

It's using Ubuntu LTS 'precise' 64bit
root@huddle:~# uname -a
Linux huddle 3.2.0-30-generic #48-Ubuntu SMP Fri Aug 24 16:52:48 UTC
2012 x86_64 x86_64 x86_64 GNU/Linux

The XFS tools are the following version, though using kernel 2.6.32 the
same tools work without problem.
root@huddle:~# xfs_repair -V
xfs_repair version 3.1.7

That's how the logical volume from the host looks inside the virtual
machine:
root@huddle:~# ls -l /dev/vdb
brw-rw---- 1 root disk 253, 16 Sep 17 19:36 /dev/vdb

Running any kernel, blkid still identifies the device correctly as xfs
volume:
root@huddle:~# blkid /dev/vdb
/dev/vdb: UUID=3D"5adcd575-d3f2-48c3-81de-104f125b275e" TYPE=3D"xfs"

Thanks in advance.
Richard

--=20
---------------------------------------------------------------------
    Systemadministration
[a] Department for Theoretical Chemistry
    University of Vienna
    Waehringer Strasse 17/3/304, 1090 Wien, Austria
[p] +43 664 920 32 95
[m] hawk@tbi.univie.ac.at
[w] http://www.tbi.univie.ac.at/~hawk
---------------------------------------------------------------------












--------------enig970F8637FCEB805773DF9AA0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.18 (Darwin)
Comment: Using GnuPG with Mozilla - http://www.enigmail.net/

iEYEARECAAYFAlBYNZAACgkQnGohgOrO9GFA1ACfYJlUZoxrxZOPN1KudYcKHzqN
btIAoKdUk+spDW8L1eF4EYWVPUuBmzcW
=O+hY
-----END PGP SIGNATURE-----

--------------enig970F8637FCEB805773DF9AA0--


--===============3049703918064033394==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3049703918064033394==--
