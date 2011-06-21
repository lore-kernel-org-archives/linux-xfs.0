Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5L7Lrsj235762 for <xfs@oss.sgi.com>; Tue, 21 Jun 2011 02:21:53 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 85CA217325B2
	for <xfs@oss.sgi.com>; Tue, 21 Jun 2011 00:21:51 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id ofaOn51pSKGDN2W1 for
	<xfs@oss.sgi.com>; Tue, 21 Jun 2011 00:21:51 -0700 (PDT)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: [PATCH] xfs: improve sync behaviour in face of aggressive dirtying
Date: Tue, 21 Jun 2011 09:21:46 +0200
References: <20110617131401.GC2141@infradead.org>
	<20110620081802.GA27111@infradead.org>
	<20110621003343.GJ32466@dastard>
In-Reply-To: <20110621003343.GJ32466@dastard>
MIME-Version: 1.0
Message-Id: <201106210921.48657@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0428868406972460159=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Christoph Hellwig <hch@infradead.org>, Wu Fengguang <fengguang.wu@intel.com>

--===============0428868406972460159==
Content-Type: multipart/signed;
  boundary="nextPart1333210.oW9QmaPcvD";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart1333210.oW9QmaPcvD
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Dienstag, 21. Juni 2011 Dave Chinner wrote:
> > The minor one is that we always flush all work items and not just
> > those on the filesystem to be flushed.  This might become an issue
> > for lager systems, or when we apply a similar scheme to fsync,
> > which has the same underlying issue.
>=20
> For sync, I don't think it matters if we flush a few extra IO
> completions on a busy system.

Couldn't that be bad on a system with mixed fast/slow storage (say 15k=20
SAS and 7.2k SATA), where on the busy fast SAS lots of syncs occur and=20
lead to extra I/O on the SATA disks? Especially if there are 16 SAS=20
disks in an array with RAID-0 against 4 SATA disks in RAID-6, to say the=20
worst. If the SATAs are already heavy used (say >=3D50%), those extra=20
writes could bring them to their knees.

I'm not sure how often syncs occur though, maybe that's why Dave says it=20
shouldn't matter? AFAIK, databases generate heavy syncs though.

=2D-=20
mit freundlichen Gr=FCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services: Prot=E9ger
http://proteger.at [gesprochen: Prot-e-schee]
Tel: +43 660 / 415 6531

// Haus zu verkaufen: http://zmi.at/langegg/

--nextPart1333210.oW9QmaPcvD
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)

iEYEABECAAYFAk4ARowACgkQzhSR9xwSCbQdJQCbBZ0KRaCOLmj3RJzxFlDb2s0P
uGgAniNek6eSNccaJzI1gky+P5yLRB1S
=VZNj
-----END PGP SIGNATURE-----

--nextPart1333210.oW9QmaPcvD--


--===============0428868406972460159==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0428868406972460159==--
