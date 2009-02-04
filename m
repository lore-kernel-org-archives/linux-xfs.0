Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n14GIv1P161251 for <xfs@oss.sgi.com>; Wed, 4 Feb 2009 10:18:58 -0600
Received: from mailsrv1.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DCFFEE7420
	for <xfs@oss.sgi.com>; Wed,  4 Feb 2009 08:18:17 -0800 (PST)
Received: from mailsrv1.zmi.at (mailsrv1.zmi.at [212.69.162.198]) by
	cuda.sgi.com with ESMTP id 8Q1MpqN5n1HjQzss for
	<xfs@oss.sgi.com>; Wed, 04 Feb 2009 08:18:17 -0800 (PST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: xfs_force_shutdown after Raid crash
Date: Wed, 4 Feb 2009 17:18:15 +0100
References: <498376CF.8020806@renderforce.de>
	<20090204122241.GL24173@disturbed>
	<20090204153322.GC15454@theco.de>
In-Reply-To: <20090204153322.GC15454@theco.de>
MIME-Version: 1.0
Message-Id: <200902041718.15836@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2947369965573529837=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: ralf@theco.de, xfs@oss.sgi.com

--===============2947369965573529837==
Content-Type: multipart/signed;
  boundary="nextPart7276097.jXn00mXb1W";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart7276097.jXn00mXb1W
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Mittwoch 04 Februar 2009 Ralf Liebenow wrote:
> Should Battery backed RAID controllers not always set their discs
> cache off ?
>
> As I see it (in case of a power failure):
>   - the discs are connectet to the main power, so if there is a power
>     failure they're offline at that moment in time and their (write)
> cache will be gone in that instance of time too

Normally a server is on a UPS, and that should report when there's a=20
power outage so the server has enough time to gracefully shut down.=20
Still, there can be other events such as:
=2D power supply error. Even with redundant PS, an outage can exist
=2D human error (coffee into the server, someone unplugging the cable=20
between UPS and server,...)
=2D and of course mainboard/cpu/ram total crashes
so you are basically never safe.

>   - if a RAID controller does not turn off the disks write cache, the
> controller cannot know if previous writes have made it to the disk.

The controller could keep in-transfer blocks in it's cache, waiting for=20
a confirm from the disk that the blocks are on the media, and only=20
afterwards remove it from cache. I don't know if controllers do that=20
actually. I'll ask Areca support on that.

> good RAID Controller would also use its cache to re-organise the disc
> writes to minimize seek times doing somthing like intelligent command
> queuing. This would also mean, that any order of writes to a disk
> could have been changed by the controller. This would ultimately
> break any filesystem which does not explicitly fsyncing consistent
> checkpoints to the disk, which would make battery backed RAID Systems
> pretty useless ... would it ?
>
>     So .. a battery backed RAID controller should default to "no disk
> write cache" should it ? Otherwise why should anyone want to use such
> expensive controllers ... it just does not make sense to have a
> battery backed cache on the controller, when things get inconsistent
> at a power outage ... It wouldn't have any purpuse ... I hope
> developers of battery backed RAID controllers are aware of that
> implication ...

Yes, imagine you have a RAID with 8 hard disks each having 32MB cache...=20
up to 256MB data lost, with a very big chance of having filesystem=20
metadata in cache, as that's written very often...
I'll be back on that once I have an official answer from Areca.

mfg zmi
=2D-=20
// Michael Monnerie, Ing.BSc    -----      http://it-management.at
// Tel: 0660 / 415 65 31                      .network.your.ideas.
// PGP Key:         "curl -s http://zmi.at/zmi.asc | gpg --import"
// Fingerprint: AC19 F9D5 36ED CD8A EF38  500E CE14 91F7 1C12 09B4
// Keyserver: wwwkeys.eu.pgp.net                  Key-ID: 1C1209B4


--nextPart7276097.jXn00mXb1W
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkmJv8cACgkQzhSR9xwSCbQB1gCglAMlVDsw8/hVRFZpfSKy4OY8
wCsAoK7Mefh8SVecgc8gFHE/dVXkDBwB
=UJPK
-----END PGP SIGNATURE-----

--nextPart7276097.jXn00mXb1W--


--===============2947369965573529837==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2947369965573529837==--
