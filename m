Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5952O7b044613 for <xfs@oss.sgi.com>; Wed, 9 Jun 2010 00:02:25 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EEA5B4824DD
	for <xfs@oss.sgi.com>; Fri, 30 Jul 2010 05:40:16 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id qIzVW50rethJ6SOJ for
	<xfs@oss.sgi.com>; Fri, 30 Jul 2010 05:40:16 -0700 (PDT)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: filesystem shrinks after using xfs_repair
Date: Fri, 30 Jul 2010 14:40:13 +0200
References: <20100726034545.GE655@dastard> <201007301223.12134@zmi.at>
	<20100730102943.GA24106@infradead.org>
In-Reply-To: <20100730102943.GA24106@infradead.org>
MIME-Version: 1.0
Message-Id: <201007301440.14195@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0558546752209016648=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Christoph Hellwig <hch@infradead.org>

--===============0558546752209016648==
Content-Type: multipart/signed;
  boundary="nextPart1995857.AVg1TNjj4R";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart1995857.AVg1TNjj4R
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Freitag, 30. Juli 2010 Christoph Hellwig wrote:
> On Fri, Jul 30, 2010 at 12:23:08PM +0200, Michael Monnerie wrote:
> > On Freitag, 30. Juli 2010 Christoph Hellwig wrote:
> > > Recent enough kernel work fine with filesystems that inode64 was
> > > used on even if it's not specified anymore.
> >
> > =20
> > Really? Since when exactly? That would be a nice feature. If we
> > can  define it clearly, I could put that on the FAQ.
>=20
> Linux 2.6.35 will be the first kernel with the bugfixes for this to
> work.

Hihi, *rofl*. That's what developers mean by "recent enough kernel": It=20
will be "in the next release to come". :-)

> > But how does it truncate the numbers >int32 and avoid collisions?
>=20
> It doesn't.  Existing inodes won't nessecarily fit into 32-bits, but
> no new inodes above it will be allocated.

OK, sounds simple. I wrote two new FAQ entries:

http://xfs.org/index.php/XFS_FAQ#Q:_What_is_the_inode64_mount_option_for.3F

Could "all who know better than me" please verify if the information is=20
correct?

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

--nextPart1995857.AVg1TNjj4R
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAkxSyC4ACgkQzhSR9xwSCbS1ngCdHiLDPnvYF3I74+dG3trleuSc
3nQAoJH/jWBXwXTds9OHDnrEuIVOmF7r
=BTn9
-----END PGP SIGNATURE-----

--nextPart1995857.AVg1TNjj4R--


--===============0558546752209016648==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0558546752209016648==--
