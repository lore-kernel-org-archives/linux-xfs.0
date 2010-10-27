Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9RAvWMe160256 for <xfs@oss.sgi.com>; Wed, 27 Oct 2010 05:57:32 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 03FAB129691
	for <xfs@oss.sgi.com>; Wed, 27 Oct 2010 03:58:48 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id 04k5rQUyNa7sJvgN for
	<xfs@oss.sgi.com>; Wed, 27 Oct 2010 03:58:48 -0700 (PDT)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: Pid: 8345, comm: rsync Not tainted 2.6.32.22intel #1
Date: Wed, 27 Oct 2010 12:58:45 +0200
References: <4CC67450.9020602@profihost.ag> <201010270124.44846@zmi.at>
	<20101027035548.GD32255@dastard>
In-Reply-To: <20101027035548.GD32255@dastard>
MIME-Version: 1.0
Message-Id: <201010271258.45965@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============8304332992934304760=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============8304332992934304760==
Content-Type: multipart/signed;
  boundary="nextPart1499292.5aOvbL1tFq";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart1499292.5aOvbL1tFq
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Mittwoch, 27. Oktober 2010 Dave Chinner wrote:
> I'd suggest that people learn how to tweak udev hotplug rules so
> that when the device is first created (i.e. during hotplug) the
> scheduler, queue depth and readahead are set automatically. That way
> you don't have to rely on devices being discovered before your script
> runs...
>=20
> Another benefit of doing it this way is that it is easy to set
> default rules for different types of devices based on regex matching
> e.g. different configs for "sd*" vs "dm*" vs "vd*" are trivial to
> set up.

Sounds very nice. But the script I use will still work when upgrading=20
the server from openSUSE 11.2 to 11.3, and is therefore the preferred=20
choice for me.

Also, I'd need to find information and learn how to tweak udev hotplug=20
rules. I want to implement this on about 30 VMs on 2 different hosts,=20
with 3 different release states of servers (openSUSE 11.1, 11.2 and=20
11.3). The chance is high that I'd need two or three different udev=20
tweaks for the different releases, so I don't see the benefit of udev=20
for me. I wrote the script in about the same time I wrote this mail.

That's always the problem between developers ("ah, cool new stuff") and=20
admins ("i need this on 500 servers with least possible work for me, and=20
it must still work after any updates/upgrades").

=2D-=20
mit freundlichen Gr=FCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services
http://proteger.at [gesprochen: Prot-e-schee]
Tel: 0660 / 415 65 31

****** Radiointerview zum Thema Spam ******
http://www.it-podcast.at/archiv.html#podcast-100716

// Wir haben im Moment zwei H=E4user zu verkaufen:
// http://zmi.at/langegg/
// http://zmi.at/haus2009/

--nextPart1499292.5aOvbL1tFq
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)

iEYEABECAAYFAkzIBeUACgkQzhSR9xwSCbQc+gCeP366DHo0e14mX5d17FK2+4P2
mQYAn1dhS1DcpYIw4kmoQ0/yCB/0S1/k
=fqKO
-----END PGP SIGNATURE-----

--nextPart1499292.5aOvbL1tFq--


--===============8304332992934304760==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8304332992934304760==--
