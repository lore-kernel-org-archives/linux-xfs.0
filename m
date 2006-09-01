Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 01 Sep 2006 00:38:10 -0700 (PDT)
Received: from deliver.uni-koblenz.de (deliver.uni-koblenz.de [141.26.64.15])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k817c1DW002417
	for <xfs@oss.sgi.com>; Fri, 1 Sep 2006 00:38:02 -0700
From: Rainer Krienke <krienke@uni-koblenz.de>
Subject: Re: XFS and 3.2TB Partition
Date: Fri, 1 Sep 2006 08:36:28 +0200
References: <44F714F2.7050502@gmail.com>
In-Reply-To: <44F714F2.7050502@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1420533.3OVRndO7eY";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200609010836.32331.krienke@uni-koblenz.de>
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Chris Hane <chrishane@gmail.com>, xfs@oss.sgi.com

--nextPart1420533.3OVRndO7eY
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Am Donnerstag, 31. August 2006 18:57 schrieben Sie:
> I am trying to create a 3.2TB partition on my Raid 5.  Is there a
> document that could help?
>
> I have a 3ware 9500 controller and 8 *500GB sata drives configured into
> a single RAID 5 array.
>

I have a Raid with about 5TB and no problems creating an xfs filesystem on =
it.=20
The system is Novell SLES10 with a 2.6.16.21 kernel.=20

At first there was a problem with the raid. The firmware of the raid device=
=20
needed an upgrade. Bevore the upgrade I had a maximum of 2TB.=20

In dmesg (or /var/log/boot.msg on SLES10) you should see something like thi=
s=20
message if the device (sdc here) is handled correctly:

<5>sdc : very big device. try to use READ CAPACITY(16).
<5>SCSI device sdc: 10156243968 512-byte hdwr sectors (5199997 MB)
<5>sdc: Write Protect is off
<7>sdc: Mode Sense: cb 00 00 08
<5>SCSI device sdc: drive cache: write back
<5>sdc : very big device. try to use READ CAPACITY(16).
<5>SCSI device sdc: 10156243968 512-byte hdwr sectors (5199997 MB)

Bevore the firmware update there was an error when trying to read the capac=
ity=20
via READ CAPACITY(16).=20=20

I created the partitiions using parted. fdisk did not work.

Have a nice day
Rainer
--=20
---------------------------------------------------------------------------
Rainer Krienke, Universitaet Koblenz, Rechenzentrum, Raum A022
Universitaetsstrasse 1, 56070 Koblenz, Tel: +49 261287 -1312, Fax: -1001312
Mail: krienke@uni-koblenz.de, Web: http://www.uni-koblenz.de/~krienke
Get my public PGP key: http://www.uni-koblenz.de/~krienke/mypgp.html
---------------------------------------------------------------------------

--nextPart1420533.3OVRndO7eY
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQBE99Twaldtjc/KDEoRAoshAKCx63Wqwb/s188EdqmGXyLJE79mRgCfbEpN
EoR1IWQ8ogyx+D6zmgoccag=
=0RXB
-----END PGP SIGNATURE-----

--nextPart1420533.3OVRndO7eY--
