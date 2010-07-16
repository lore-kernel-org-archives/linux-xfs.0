Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6GEbjYp007001 for <xfs@oss.sgi.com>; Fri, 16 Jul 2010 09:37:45 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 099511E2A8D6
	for <xfs@oss.sgi.com>; Fri, 16 Jul 2010 07:40:41 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id wjvzfsSSQIc6GEz2 for
	<xfs@oss.sgi.com>; Fri, 16 Jul 2010 07:40:41 -0700 (PDT)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: rsync and corrupt inodes (was xfs_dump problem)
Date: Fri, 16 Jul 2010 16:40:39 +0200
References: <201007152258.15631@zmi.at> <20100715225713.GK30737@dastard>
In-Reply-To: <20100715225713.GK30737@dastard>
MIME-Version: 1.0
Message-Id: <201007161640.39721@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0924428613325035276=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============0924428613325035276==
Content-Type: multipart/signed;
  boundary="nextPart12320493.1VWxg053zJ";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart12320493.1VWxg053zJ
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Freitag, 16. Juli 2010 Dave Chinner wrote:
> > CFLAGS=3D-march=3Dathlon64-sse3 ./configure --prefix=3D/usr

> Drop the CFLAGS and see what happens when you just use a generic
> arch target.

I investigated this a bit more, and I'm sure that CFLAGS get completely=20
ignored. I even set all variables with "GCC" in config.status to random=20
content, and it compiles. Then I found that the one in include/builddefs=20
gets always set to this:
GCCFLAGS =3D -funsigned-char -fno-strict-aliasing -Wall

So I changed it manually:
GCCFLAGS =3D -march=3Dathlon64-sse3 -g -Os -funsigned-char -fno-strict-
aliasing -Wall
and now the resulting binary is different. I guess that should not be=20
happening? I'm used to setting "CFLAGS=3D" during configure to have=20
smaller bins, and CFLAGS normally get passed through during compile, but=20
not with xfsprogs. Not that it's very important, but maybe worth a fix?

=2D-=20
mit freundlichen Gr=FCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services
http://proteger.at [gesprochen: Prot-e-schee]
Tel: 0660 / 415 65 31

// Wir haben im Moment zwei H=E4user zu verkaufen:
// http://zmi.at/langegg/
// http://zmi.at/haus2009/

--nextPart12320493.1VWxg053zJ
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAkxAb2cACgkQzhSR9xwSCbRO9gCdEmiTCIZxE0ErSOhuBo5V/zX7
mSwAoIWGFzAL0K1D84o+3yYwgpFCYw0Y
=AR2F
-----END PGP SIGNATURE-----

--nextPart12320493.1VWxg053zJ--


--===============0924428613325035276==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0924428613325035276==--
