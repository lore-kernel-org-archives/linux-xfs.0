Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o876JSv5226840 for <xfs@oss.sgi.com>; Tue, 7 Sep 2010 01:19:28 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E66D851CDD
	for <xfs@oss.sgi.com>; Mon,  6 Sep 2010 23:20:10 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id SbF4s3gTLfGXm68d for
	<xfs@oss.sgi.com>; Mon, 06 Sep 2010 23:20:10 -0700 (PDT)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: LWN.net article: creating 1 billion files -> XFS looses
Date: Tue, 7 Sep 2010 08:20:07 +0200
References: <201008191312.49346@zmi.at> <201009070058.40849@zmi.at>
	<20100907033134.GF7362@dastard>
In-Reply-To: <20100907033134.GF7362@dastard>
MIME-Version: 1.0
Message-Id: <201009070820.08354@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6595833540866127195=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============6595833540866127195==
Content-Type: multipart/signed;
  boundary="nextPart3132910.7nYA6y3itN";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart3132910.7nYA6y3itN
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Dienstag, 7. September 2010 Dave Chinner wrote:
> # mkfs.xfs -n size=3D64k
> (-n =3D naming =3D directories. -d =3D data !=3D directories)

Thank you, Dave. Do I interpret that parameter right:

When a new directory is created, per default it would occupy only 4KB,=20
with -n size=3D64k would be reserved. As the directory fills, space within=
=20
that block will be used, so in the default case after 4KB (how many=20
inodes would that be roughly? 256 Bytes/Inode, so 16 entries?) XFS would=20
reserve the next block, but in your case 256 entries would fit.

That would keep dir fragmentation lower, and with todays disks, take a=20
minimal more space, so it sounds very good to use that option.=20
Especially with RAIDs, where stripes usually are 64KB or bigger. Or=20
would the waste of space be so big that it could hurt?

Last question: Is there a way to set that option on a given XFS?

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

--nextPart3132910.7nYA6y3itN
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAkyF2ZgACgkQzhSR9xwSCbTzXwCgvGu2cg/KOKHFexiuhfJ2qBeO
aPoAoL41lQDcSOIk3a1o4ToHESnvG2BA
=1cqC
-----END PGP SIGNATURE-----

--nextPart3132910.7nYA6y3itN--


--===============6595833540866127195==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6595833540866127195==--
