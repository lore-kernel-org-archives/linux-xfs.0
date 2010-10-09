Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o99Lr0We165821 for <xfs@oss.sgi.com>; Sat, 9 Oct 2010 16:53:01 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 455B1D77EF
	for <xfs@oss.sgi.com>; Sat,  9 Oct 2010 14:54:04 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id LKI2kKdvbk5RhnTL for
	<xfs@oss.sgi.com>; Sat, 09 Oct 2010 14:54:04 -0700 (PDT)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: broken XFS filesystem not to be repaired by xfs_repair 3.1.2
Date: Sat, 9 Oct 2010 23:54:00 +0200
References: <201009010226.46771@zmi.at> <20100902015207.GT705@dastard>
In-Reply-To: <20100902015207.GT705@dastard>
MIME-Version: 1.0
Message-Id: <201010092354.01217@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7755628070125585591=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============7755628070125585591==
Content-Type: multipart/signed;
  boundary="nextPart2579170.sVYENIVcKK";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart2579170.sVYENIVcKK
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Donnerstag, 2. September 2010 Dave Chinner wrote:
> On Wed, Sep 01, 2010 at 02:26:46AM +0200, Michael Monnerie wrote:
> > http://zmi.at/x/big.xfs.metadump.bz2
> >=20
> > After I did the big "rm -r" on that 4TB volume, 4 subdirs with a
> > file in each are still left even after 20 "xfsrepair;mount;rm
> > -r;umount" cycles. So I dare to say it can't be repaired here.
>=20
> Ok, so those inodes have corrupted data/attribute forks - I'd say
> they are victims of the xfs_fsr swapext problems with dynamic
> attribute forks.
>=20
> I'll use the image to write a fix for repair to detect and correct
> the problem.

Hi Dave, could you find something?


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

--nextPart2579170.sVYENIVcKK
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)

iEYEABECAAYFAkyw5HkACgkQzhSR9xwSCbR88ACgubga4iCwYd0W5LReCRXUcxt6
RNgAniEv7OHs2LMmJOGcUYAN05cB5LhV
=AQI0
-----END PGP SIGNATURE-----

--nextPart2579170.sVYENIVcKK--


--===============7755628070125585591==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7755628070125585591==--
