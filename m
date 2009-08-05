Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n75GXFH6255106 for <xfs@oss.sgi.com>; Wed, 5 Aug 2009 11:33:15 -0500
Received: from mx.ugf.br (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 538831458CCC
	for <xfs@oss.sgi.com>; Wed,  5 Aug 2009 09:34:05 -0700 (PDT)
Received: from mx.ugf.br (mx.ugf.br [200.222.48.3]) by cuda.sgi.com with ESMTP
	id HN9Gg761ZUa3Y1B1 for <xfs@oss.sgi.com>;
	Wed, 05 Aug 2009 09:34:05 -0700 (PDT)
Subject: Re: [PATCH 1/1] XFS: xfs_iformat realtime device target pointer check
From: Ramon de Carvalho Valle <ramon@risesecurity.org>
In-Reply-To: <20090805151750.GA16080@infradead.org>
References: <1249329808.7686.26.camel@logos>
	<20090803214929.GB3167@infradead.org> <1249351241.7513.18.camel@logos>
	<4A786110.8090404@sandeen.net> <1249411898.7576.19.camel@logos>
	<20090805151750.GA16080@infradead.org>
Date: Wed, 05 Aug 2009 13:34:02 -0300
Message-Id: <1249490042.7725.16.camel@logos>
Mime-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5725980013531975461=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com, hch@lst.de, Eric Sandeen <sandeen@sandeen.net>, linux-kernel@vger.kernel.org, mszeredi@novell.com


--===============5725980013531975461==
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-xqidu5ctlIFo7+IpVFyG"


--=-xqidu5ctlIFo7+IpVFyG
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-08-05 at 11:17 -0400, Christoph Hellwig wrote:
> On Tue, Aug 04, 2009 at 03:51:38PM -0300, Ramon de Carvalho Valle wrote:
> > The xfs_iformat function does not check if the realtime device target p=
ointer
> > is valid when the XFS_DIFLAG_REALTIME flag is set on the ondisk inode
> > structure.
>=20
> Same as Eric I don't think there's much of a point renumbering the error
> cases.  Instead I'll do another patch with a couple of cleanups in this
> function replacing all the numbers with short alphabetic tags.

Great. Thanks.

>=20
> I don't really see the point of printing the flags either, if we have
> this bit flipped it's pretty clear that we had random corruption of this
> dinode.
>=20

Printing the flags is just for debugging purposes and it keeps the code
consistent with the other calls to xfs_fs_repair_cmn_err.

-Ramon

--=-xqidu5ctlIFo7+IpVFyG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkp5tHcACgkQGIS0iEuhp4O3PQCeP/9dDXY3tVUkWpuijgipepol
B5UAoJ7U1BRRR/vDmVy/0RUO8n7YItMF
=g7j/
-----END PGP SIGNATURE-----

--=-xqidu5ctlIFo7+IpVFyG--


--===============5725980013531975461==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5725980013531975461==--
