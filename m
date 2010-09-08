Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o88DcEva037415 for <xfs@oss.sgi.com>; Wed, 8 Sep 2010 08:38:15 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5DD0757747
	for <xfs@oss.sgi.com>; Wed,  8 Sep 2010 06:38:56 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id g8jZ1JJNXzxsAclz for
	<xfs@oss.sgi.com>; Wed, 08 Sep 2010 06:38:56 -0700 (PDT)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: xfs mount/create options (was: XFS status update for August 2010)
Date: Wed, 8 Sep 2010 15:38:53 +0200
References: <20100902145959.GA27887@infradead.org> <201009080738.58483@zmi.at>
	<20100908105858.GZ705@dastard>
In-Reply-To: <20100908105858.GZ705@dastard>
MIME-Version: 1.0
Message-Id: <201009081538.54488@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2273862374771308728=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============2273862374771308728==
Content-Type: multipart/signed;
  boundary="nextPart5864391.rKMXcvHLKq";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart5864391.rKMXcvHLKq
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Mittwoch, 8. September 2010 Dave Chinner wrote:
> >  On machines with 32MiB or more 32k is the default, but most
> >  machines these days have multi-gigabytes of RAM, so at least for
> >  RAM>1GiB that could be made default.
>=20
> That is definitely not true. XFS is widely used in the embedded NAS
> space, where memory is very limited and might be configured with
> many filesystems.  32k is the default because those sorts of machines
> can't afford to burn 2MB RAM per filesystem just in log buffers.
>
> Also, you can go and search the archives or git history as to why we
> don't tune the logbsize based on physical memory size anymore, too.

OK, then the man page should be updated to reflect this "newer logic".=20
I've got the information directly from there.
=20
> You're getting the wrong information there. largeio affects the
> output of the optimal IO size reported by stat(2). 'stat -f" does
> a statfs(2) call. Try 'stat /disk/db/<file> --format %o'....

Ah, that's better, thank you :-)
=20
> >  And while I am at it: Why does "mount" not provide the su=3D/sw=3D
> >   options that we can use to create a filesystem? Would make life
> >   easier, as it's much easier to read su=3D64k,sw=3D7 than
> >   sunit=3D128,swidth=3D896.
>=20
> You should never, ever need to use the mount options.

=2E.except when a disk is added to the RAID, or it's RAID level gets=20
changed. Then sw=3D7 becomes sw=3D8 or so - or better said: would become, a=
s=20
then you must use the (I call it strange, error prone) semantics of=20
sunit/swidth.
=20
> >  When I defined su/sw on mkfs, is it enough, or would I always have
> > to specify sunit/swidth with every mount too?
>=20
> Yes, no. mkfs.xfs stores sunit/swidth on disk in the superblock.

So when I add a disk, I must only once mount with the new sunit/swidth,=20
and that is stored? That's nice.

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

--nextPart5864391.rKMXcvHLKq
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAkyHke4ACgkQzhSR9xwSCbRfYwCgrkZ8hMLUdv6mkSFYlXGOsarO
MqMAn2MuLuW7YhmrN6K0ir3uDvfPF0VS
=NbC5
-----END PGP SIGNATURE-----

--nextPart5864391.rKMXcvHLKq--


--===============2273862374771308728==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2273862374771308728==--
