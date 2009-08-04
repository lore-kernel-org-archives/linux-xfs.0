Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n74ImZIS187068 for <xfs@oss.sgi.com>; Tue, 4 Aug 2009 13:48:35 -0500
Received: from mx.ugf.br (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C17D93A5CB9
	for <xfs@oss.sgi.com>; Tue,  4 Aug 2009 11:49:24 -0700 (PDT)
Received: from mx.ugf.br (mx.ugf.br [200.222.48.3]) by cuda.sgi.com with ESMTP
	id bdNReDUql5oxqQp8 for <xfs@oss.sgi.com>;
	Tue, 04 Aug 2009 11:49:24 -0700 (PDT)
Subject: Re: [PATCH 1/1] XFS: __xfs_get_blocks check pointer to the target
	device
From: Ramon de Carvalho Valle <ramon@risesecurity.org>
In-Reply-To: <4A786110.8090404@sandeen.net>
References: <1249329808.7686.26.camel@logos>
	<20090803214929.GB3167@infradead.org> <1249351241.7513.18.camel@logos>
	<4A786110.8090404@sandeen.net>
Date: Tue, 04 Aug 2009 15:50:13 -0300
Message-Id: <1249411813.7576.17.camel@logos>
Mime-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5053226483812086133=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org, mszeredi@novell.com, hch@lst.de, xfs@oss.sgi.com


--===============5053226483812086133==
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-2OKvWfLJGpVRn2+Y06z5"


--=-2OKvWfLJGpVRn2+Y06z5
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-08-04 at 11:25 -0500, Eric Sandeen wrote:
> Ramon de Carvalho Valle wrote:
> > On Mon, 2009-08-03 at 17:49 -0400, Christoph Hellwig wrote:
> >> On Mon, Aug 03, 2009 at 05:03:28PM -0300, Ramon de Carvalho Valle wrot=
e:
> >>> The __xfs_get_blocks function does not check if the pointer to the ta=
rget
> >>> device is valid before dereferencing it.
> >> It should never be zero.  It's set by xfs_imap_to_bmap to either
> >> mp->m_ddev_targp which is always allocated, or to mp->m_rtdev_targp
> >> which is always allocated if we have a realtime device, and
> >> XFS_IS_REALTIME_INODE should only be true in that case.
> >>
> >=20
> > While testing XFS code with a modified version of fsfuzzer on SLES 10
> > SP3 (Kernel 2.6.16.60-0.49.3.ramon-ppc64), I came across the following
> > Oops:
>=20
> ...
>=20
> ahah, useful information that would have been great in the original
> patch submission.  :)

Sorry about that. :)

>=20
> > I added a printk() line just before the:
> >=20
> > 	bh_result->b_bdev =3D iomap.iomap_target->bt_bdev;
> >=20
> > and as we can see iomap.iomap_target is NULL.
> >=20
> > My guess is that the XFS_DIFLAG_REALTIME flag is being set incorrectly
> > on the xfs inode structure, setting iomapp->iomap_target to the wrong
> > device pointer (probably NULL).
> >=20
> > I don't know if this is the best place to add a check, neither if
> > returning -XFS_ERROR(EIO) is correct at this point. Maybe doing:
> >=20
> > 	if (iomap.iomap_target && omap.iomap_flags & IOMAP_REALTIME)
> > 		bh_result->b_bdev =3D iomap.iomap_target->bt_bdev;
> >=20
> > would be a better solution.
>=20
> Can you test hch's patch w/ your fuzzed image?

I tested it on my SLES 10 SP3 (Kernel 2.6.16.60-0.49.3.ramon-ppc64) and
it successfully fixed the NULL pointer dereference.

I did some small modifications to the patch to xfs error print the flags
value and fixed the xfs error report tags. I am submitting the Christoph
patch again.

Thanks Christoph and Eric.

-Ramon

>=20
> Thanks,
> -Eric

--=-2OKvWfLJGpVRn2+Y06z5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkp4gtYACgkQGIS0iEuhp4MQjwCbBY9YPI9Ixv4fF+s4yAAwER5J
358AoNqZ35XrOJM66lgjlVplQoHk4lX6
=DoAY
-----END PGP SIGNATURE-----

--=-2OKvWfLJGpVRn2+Y06z5--


--===============5053226483812086133==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5053226483812086133==--
