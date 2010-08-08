Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o787kead242465 for <xfs@oss.sgi.com>; Sun, 8 Aug 2010 02:46:40 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2D7B0D76721
	for <xfs@oss.sgi.com>; Sun,  8 Aug 2010 00:47:00 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id kADZHkndxDaxO9K7 for
	<xfs@oss.sgi.com>; Sun, 08 Aug 2010 00:47:00 -0700 (PDT)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: How to track down abysmal performance ata - raid1 - crypto -
	vg/lv - xfs
Date: Sun, 8 Aug 2010 09:46:53 +0200
References: <20100804085039.GA11671@infradead.org>
	<4C5A774D.6000400@hardwarefreak.com>
	<20100807101349.GD7362@dastard>
In-Reply-To: <20100807101349.GD7362@dastard>
MIME-Version: 1.0
Message-Id: <201008080946.57635@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3497980372135725310=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============3497980372135725310==
Content-Type: multipart/signed;
  boundary="nextPart4150250.H0cggjMXBm";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart4150250.H0cggjMXBm
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Samstag, 7. August 2010 Dave Chinner wrote:
> > Are you referring to /sys/block/sdx/queue/read_ahead_kb?  I'm
> > pretty sure this works below the FS level and below the partition
> > level.  This read_ahead works at the block device level.  At least
> > for individual or JBOD.
>=20
> That number is used to initialise the default readahead value for
> any file descriptor opened on the filesystem. readahead is tracked
> per-fd at the page cache level, so is effectively at the filesystem
> level, not the block device.
>=20
> > Are you saying this setting gets ignored by the kernel if/when
> > mdadm, LVM, and/or crypto are used?
>=20
> Only the value from the block device the filesystem sits on is used.
> i.e. if you are using /dev/md0, then the filesystem uses the value
> from /sys/block/md0/queue/read_ahead_kb and ignores all the ones set
> on the /dev/sdX devices that make up /dev/md0.
=20
That would be a wonderful piece of documentation belonging to=20
Documentation/sysctl/fs.txt or vm.txt, and /sbin/sysctl should not only=20
change /proc/sys values, but also /sys entries.

Such performance knobs are very poorly documented, but would be an=20
important bit for administrators to tune systems for their needs. This=20
is something that's really missing in Linux.


=2D-=20
mit freundlichen Gr=FCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services
http://proteger.at [gesprochen: Prot-e-schee]
Tel: 0660 / 415 65 31

****** Aktuelles Radiointerview! ******
http://www.it-podcast.at/aktuelle-sendung.html

// Wir haben im Moment zwei H=E4user zu verkaufen:
// http://zmi.at/langegg/
// http://zmi.at/haus2009/

--nextPart4150250.H0cggjMXBm
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAkxeYPEACgkQzhSR9xwSCbTtcACg2gg83JJO+lbH3KLkgJ4fDXlU
DdIAnAkrxrZk2tQe3iQ1GfstSe1GxLez
=7Hw6
-----END PGP SIGNATURE-----

--nextPart4150250.H0cggjMXBm--


--===============3497980372135725310==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3497980372135725310==--
