Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o626J8PL230623 for <xfs@oss.sgi.com>; Fri, 2 Jul 2010 01:19:08 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A0F87422FF4
	for <xfs@oss.sgi.com>; Thu,  1 Jul 2010 23:21:54 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id nFnkMhbB8j1JMMqo for
	<xfs@oss.sgi.com>; Thu, 01 Jul 2010 23:21:54 -0700 (PDT)
Received: from mailsrv.i.zmi.at (h081217106033.dyn.cm.kabsi.at [81.217.106.33])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv14.zmi.at (Postfix) with ESMTPSA id 96C14713
	for <xfs@oss.sgi.com>; Fri,  2 Jul 2010 08:21:52 +0200 (CEST)
Received: from saturn.localnet (saturn.i.zmi.at [10.72.27.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv.i.zmi.at (Postfix) with ESMTPSA id 368CF83C828
	for <xfs@oss.sgi.com>; Fri,  2 Jul 2010 08:21:20 +0200 (CEST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: rsync and corrupt inodes (was xfs_dump problem)
Date: Fri, 2 Jul 2010 08:21:51 +0200
References: <4C26A51F.8020909@tlinx.org> <201007011025.04391@zmi.at>
	<20100702024235.GX24712@dastard>
In-Reply-To: <20100702024235.GX24712@dastard>
MIME-Version: 1.0
Message-Id: <201007020821.51753@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3629103935550835051=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============3629103935550835051==
Content-Type: multipart/signed;
  boundary="nextPart2315799.QLypJZGByS";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart2315799.QLypJZGByS
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Freitag, 2. Juli 2010 Dave Chinner wrote:
> So it's the rsync daemon on saturn that is doing all the IO?

Yes.
=20
> > I rsynced today 3 times, twice with the openSUSE kernel and once
> > with 2.6.34, no problem. Sorry (or maybe "lucky me"?).
> >
> > > > 852c268f-cf1a-11de-b09b-806e6f6e6963.vhd* ??????????? ? ?    ?
> > > >       ?            ? 852c2690-cf1a-11de-b09b-806e6f6e6963.vhd
> > >
> > > On the source machine, can you get a list of the xattrs on the
> > > inode?
> >
> > How would I do that? "getfattr" on that file gives no return, does
> > that mean it doesn't have anything to say? I never do that things,
> > so there shouldn't be any attributes set.
>=20
> "getfattr -d"

Sorry, doesn't work:

# getfattr -d 852c2690-cf1a-11de-b09b-806e6f6e6963.vhd
getfattr: 852c2690-cf1a-11de-b09b-806e6f6e6963.vhd: Structure needs=20
cleaning

> The first character of the name is bad, everything after that -
> including the attribute value - is identical to that on other
> inodes.  What this implies is that we've overwritten the start of
> the attribute fork with something, and that looks exactly like the
> swap extents problems that we've fixed recently....
> >
> > Yes, xfs_fsdr was running. Disabled it now, and compiled and
> > changed to kernel 2.6.34 now. Hope that's OK ;-)
>=20
> Ok, so we have identified a potential cause. Either disabling fsr or
> upgrading to 2.6.34 should be sufficient to avoid the problem. If no
> problem show up now you are on 2.6.34, then I'd switch fsr back on
> and see if they show up again...

So far, so good. I'm on 2.6.34 now. Is there any chance for a fixed=20
version of xfs_repair, so that I can either get rid of the 4 broken=20
files (i.e. delete them), or repair the filesystem? ATM, xfs_repair=20
asserts on this filesystem.

=2D-=20
mit freundlichen Gr=FCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services
http://proteger.at [gesprochen: Prot-e-schee]
Tel: 0660 / 415 65 31

// Wir haben im Moment zwei H=E4user zu verkaufen:
// http://zmi.at/langegg/
// http://zmi.at/haus2009/

--nextPart2315799.QLypJZGByS
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAkwthX8ACgkQzhSR9xwSCbTPxACePFxEoLVdDzS+F2b/DvWFGPcO
peUAn0uXN0W83IIcEodlM/LrlJn0tzq0
=ilwR
-----END PGP SIGNATURE-----

--nextPart2315799.QLypJZGByS--


--===============3629103935550835051==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3629103935550835051==--
