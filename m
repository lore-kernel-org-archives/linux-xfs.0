Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0H9KVaT145345 for <xfs@oss.sgi.com>; Tue, 17 Jan 2012 03:20:32 -0600
Received: from mailsrv14.zmi.at (mailsrv14.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id D8sFHCzcml8IR0jX for
	<xfs@oss.sgi.com>; Tue, 17 Jan 2012 01:20:02 -0800 (PST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: Optimal XFS formatting options?
Date: Tue, 17 Jan 2012 10:19:55 +0100
References: <33140169.post@talk.nabble.com> <20120116231121.GB6922@dastard>
	<4F14EBAF.10808@hardwarefreak.com>
In-Reply-To: <4F14EBAF.10808@hardwarefreak.com>
MIME-Version: 1.0
Message-Id: <201201171019.58714@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7634520130694998979=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com, stan@hardwarefreak.com

--===============7634520130694998979==
Content-Type: multipart/signed;
  boundary="nextPart4061187.mfvmjNA2CY";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart4061187.mfvmjNA2CY
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Dienstag, 17. Januar 2012 Stan Hoeppner wrote:
> Thanks for the correction/reminder Dave.  So in this case the first
> sector of the first partition would need to reside at LBA1280 in this
> array (655360 byte stripe width, 1280 sectors/stripe), as the
> partition table itself is going to occupy some sectors at the
> beginning of the first stripe.  By creating the partition at LBA1280
> we make sure the first sector of the XFS filesystem is aligned with
> the first sector of the 2nd stripe.

There's one big problem with that: Many people will sooner or later=20
expand and existing array. If you add one drive, all your nice stripe=20
width alignment becomes bogus, and suddenly your performance will drop.

There's no real way out of that, but three solutions come to my mind:
=2D backup before expand/restore after expand with new alignment
=2D leave existing data, just change mount options so after expansion at=20
least new files are going to be aligned to the new stripe width.=20
=2D expand array by factors of two. So if you have 10 data drives, add 10=20
data drives. But that creates other problems (probability of single=20
drive failure + time to recover a single broken disk)

=2D-=20
mit freundlichen Gr=FCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services: Prot=E9ger
http://proteger.at [gesprochen: Prot-e-schee]
Tel: +43 660 / 415 6531

--nextPart4061187.mfvmjNA2CY
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)

iEYEABECAAYFAk8VPT4ACgkQzhSR9xwSCbSXEgCginyCR7hgWneYeCg/WCD9gXqy
t98An3RiC9v6mpT+VnS49fsMWvdvgvt4
=HdGk
-----END PGP SIGNATURE-----

--nextPart4061187.mfvmjNA2CY--


--===============7634520130694998979==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7634520130694998979==--
