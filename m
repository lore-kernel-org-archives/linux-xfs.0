Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4JB2RFe123783 for <xfs@oss.sgi.com>; Wed, 19 May 2010 06:02:28 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 110A235994F
	for <xfs@oss.sgi.com>; Wed, 19 May 2010 04:04:44 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id EV84sd4SCl6yMaXs for
	<xfs@oss.sgi.com>; Wed, 19 May 2010 04:04:44 -0700 (PDT)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: rsync from xfs to nfs+xfs and ACL problems
Date: Wed, 19 May 2010 13:04:37 +0200
References: <201005181350.15308@zmi.at> <20100518123304.GH2150@dastard>
In-Reply-To: <20100518123304.GH2150@dastard>
MIME-Version: 1.0
Message-Id: <201005191304.42314@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6058617221505877770=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============6058617221505877770==
Content-Type: multipart/signed;
  boundary="nextPart1795516.piKT4rThn2";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart1795516.piKT4rThn2
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Dienstag, 18. Mai 2010 Dave Chinner wrote:
> NFSv3 doesn't support ACLs, IIRC.

Thank you for the hint. I remounted with nfs4 now:
type nfs4 (rw,noatime,nodiratime,rsize=3D65536,wsize=3D65536,tcp,intr,acl)

And now I get this on "rsync -aPvHAX":

rsync: chown "somedir/Cen731n.afm" failed: Invalid argument (22)
rsync: chown "somedir/Teil2" failed: Invalid argument (22)
rsync: rsync_xal_set:=20
lsetxattr("somedir/Teil2/IMAGE.CCD","trusted.SGI_ACL_FILE") failed:=20
Operation not supported (95)

I changed again and defined an rsync module on the target, making a=20
direct rsync and no more shown errors. Still, what is causing the tons=20
of errors when rsyncing to nfs+xfs, no matter if nfs3 or nfs4? I looked=20
manually at some files and it seems everything was copied well, despite=20
the errors.

Could inode64 be a problem here?

=2D-=20
mit freundlichen Gr=FCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services
http://proteger.at [gesprochen: Prot-e-schee]
Tel: 0660 / 415 65 31

// Wir haben im Moment zwei H=E4user zu verkaufen:
// http://zmi.at/langegg/
// http://zmi.at/haus2009/

--nextPart1795516.piKT4rThn2
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAkvzxcoACgkQzhSR9xwSCbQJ2QCgykEjbJPDt7dHhvwY9HmcwHQy
Az8An3PiSjCv/Qq7L+qNo46cfwwg87Jp
=rQQD
-----END PGP SIGNATURE-----

--nextPart1795516.piKT4rThn2--


--===============6058617221505877770==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6058617221505877770==--
