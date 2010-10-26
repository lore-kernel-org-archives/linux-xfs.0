Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9QNtqog115744 for <xfs@oss.sgi.com>; Tue, 26 Oct 2010 18:55:52 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AE28F128144
	for <xfs@oss.sgi.com>; Tue, 26 Oct 2010 16:57:06 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id YEl6gMRmrYmHL08m for
	<xfs@oss.sgi.com>; Tue, 26 Oct 2010 16:57:06 -0700 (PDT)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: XFS Performance on NetApp
Date: Wed, 27 Oct 2010 01:57:03 +0200
References: <201010270033.35894@zmi.at> <20101026231007.GA32255@dastard>
In-Reply-To: <20101026231007.GA32255@dastard>
MIME-Version: 1.0
Message-Id: <201010270157.04276@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2207989752152233796=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com, Dave Chinner <david@fromorbit.com>

--===============2207989752152233796==
Content-Type: multipart/signed;
  boundary="nextPart3601255.z1EFAu9d68";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart3601255.z1EFAu9d68
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Mittwoch, 27. Oktober 2010 Dave Chinner wrote:
> However, options that
> reduce filesystem fragmentation (e.g. allocsize) still have value in
> keeping the amount of metadata and ptotential seeks down...

Yes, but for NetApp: maybe. With this whole deduplication thingy, I=20
wonder if even such a simple assumption is true. And then some people=20
make a snapshot every hour, whichmeans your log will wander around on=20
the storage anyway. So it's best to "just use it".

Another thing just crosses my mind: on a thin provisioned system, would=20
the TRIM command be useful? Do such storages recognise this command? It=20
would be very clever, I think. Let's say you run xfs_fsr, that would=20
allow the upper layer to relaim unused space. Would that be the storage=20
or XenServer/VMware which needs to understand this command?

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

--nextPart3601255.z1EFAu9d68
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)

iEYEABECAAYFAkzHatAACgkQzhSR9xwSCbTEyACg61exbXmVAk8+xLYSklyFHLxv
UDMAoO454ogHg6p6Udfq6/7bj+HtFByB
=Ik9u
-----END PGP SIGNATURE-----

--nextPart3601255.z1EFAu9d68--


--===============2207989752152233796==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2207989752152233796==--
