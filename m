Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0KFqEMT112326 for <xfs@oss.sgi.com>; Fri, 20 Jan 2012 09:52:14 -0600
Received: from mailsrv14.zmi.at (mailsrv14.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id j2EnDRaKPoChbG1P for
	<xfs@oss.sgi.com>; Fri, 20 Jan 2012 07:52:12 -0800 (PST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: Optimal XFS formatting options?
Date: Fri, 20 Jan 2012 16:52:09 +0100
References: <33140169.post@talk.nabble.com> <201201171019.58714@zmi.at>
	<4F155CC2.3050201@hardwarefreak.com>
In-Reply-To: <4F155CC2.3050201@hardwarefreak.com>
MIME-Version: 1.0
Message-Id: <201201201652.10193@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7248278291656162684=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com, stan@hardwarefreak.com

--===============7248278291656162684==
Content-Type: multipart/signed;
  boundary="nextPart1834396.bf9Uqbn0vH";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart1834396.bf9Uqbn0vH
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Dienstag, 17. Januar 2012 Stan Hoeppner wrote:
> So to be clear, your issue with the above isn't with my partition
> alignment math WRT the OP's P2000 array, but is with using XFS stripe
> alignment in general, correct?

Yes. I just wanted to document this as people often expand RAIDs and=20
forget to apply the changes to stripe width.
=20
> There is one really simple way around this issue you describe: don't
> add drives to an existing array.  Simply create another array with
> new disks, create a new aligned XFS on the array, and mount the
> filesystem in an appropriate location.  There is no 11th Commandment
> stating one must have a single massive XFS atop all of one's disks.
> ;)
>=20
> There is little to no application software today that can't be
> configured to store its data files across multiple directories.  So
> there's no need to box oneself into the corner you describe above.

It's a management burden to do that. I've learned that systems usually=20
are strictly structured in their configuration, so it's often better to=20
extend a RAID and to keep the config, as this is cheaper in the end. At=20
least for the salaries of good admins here in Europe ;-)

=2D-=20
mit freundlichen Gr=FCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services: Prot=E9ger
http://proteger.at [gesprochen: Prot-e-schee]
Tel: +43 660 / 415 6531

--nextPart1834396.bf9Uqbn0vH
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)

iEYEABECAAYFAk8ZjaoACgkQzhSR9xwSCbTVYwCgvfEi9+fDC1y8CX2TistG5dTL
DZkAoK4heJks7Vp8lakMhrP/C6q1758C
=NrjW
-----END PGP SIGNATURE-----

--nextPart1834396.bf9Uqbn0vH--


--===============7248278291656162684==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7248278291656162684==--
