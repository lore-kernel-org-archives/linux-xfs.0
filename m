Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n75DJmic245515 for <xfs@oss.sgi.com>; Wed, 5 Aug 2009 08:19:49 -0500
Received: from mx.ugf.br (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0D8A4AF9913
	for <xfs@oss.sgi.com>; Wed,  5 Aug 2009 06:30:04 -0700 (PDT)
Received: from mx.ugf.br (mx.ugf.br [200.222.48.3]) by cuda.sgi.com with ESMTP
	id wwGdiMGr41OhofGF for <xfs@oss.sgi.com>;
	Wed, 05 Aug 2009 06:30:04 -0700 (PDT)
Subject: Re: [PATCH 1/1] XFS: xfs_iformat realtime device target pointer check
From: Ramon de Carvalho Valle <ramon@risesecurity.org>
In-Reply-To: <4A790762.3010207@sandeen.net>
References: <1249329808.7686.26.camel@logos>
	<20090803214929.GB3167@infradead.org> <1249351241.7513.18.camel@logos>
	<4A786110.8090404@sandeen.net> <1249411898.7576.19.camel@logos>
	<4A7887CE.2060300@sandeen.net> <1249444550.7372.23.camel@logos>
	<4A790762.3010207@sandeen.net>
Date: Wed, 05 Aug 2009 10:21:26 -0300
Message-Id: <1249478486.7725.9.camel@logos>
Mime-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============9121441324045265360=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org, mszeredi@novell.com, hch@lst.de, xfs@oss.sgi.com


--===============9121441324045265360==
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-eGupLCjjG8bKSXdvQf7+"


--=-eGupLCjjG8bKSXdvQf7+
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-08-04 at 23:15 -0500, Eric Sandeen wrote:
> Ramon de Carvalho Valle wrote:
> > On Tue, 2009-08-04 at 14:11 -0500, Eric Sandeen wrote:
> >> Ramon de Carvalho Valle wrote:
> >>> The xfs_iformat function does not check if the realtime device target=
 pointer
> >>> is valid when the XFS_DIFLAG_REALTIME flag is set on the ondisk inode
> >>> structure.
> >>>
> >>> Signed-off-by: Christoph Hellwig <hch@infradead.org>
> >>> Signed-off-by: Ramon de Carvalho Valle <ramon@risesecurity.org>
> >>> Cc: stable <stable@kernel.org>
> >>> ---
> >>>  fs/xfs/xfs_inode.c |   23 +++++++++++++++++------
> >>>  1 files changed, 17 insertions(+), 6 deletions(-)
> >>>
> >>> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> >>> index 1f22d65..37d3ee5 100644
> >>> --- a/fs/xfs/xfs_inode.c
> >>> +++ b/fs/xfs/xfs_inode.c
> >>> @@ -343,13 +343,24 @@ xfs_iformat(
> >>>  		return XFS_ERROR(EFSCORRUPTED);
> >>>  	}
> >>> =20
> >>> +	if (unlikely((ip->i_d.di_flags & XFS_DIFLAG_REALTIME) &&
> >>> +			!ip->i_mount->m_rtdev_targp)) {
> >>> +		xfs_fs_repair_cmn_err(CE_WARN, ip->i_mount,
> >>> +			"corrupt dinode %Lu, flags =3D 0x%x.",
> >>> +			(unsigned long long)ip->i_ino,
> >>> +			ip->i_d.di_flags);
> >>> +		XFS_CORRUPTION_ERROR("xfs_iformat(3)", XFS_ERRLEVEL_LOW,
> >>> +				     ip->i_mount, dip);
> >> I think I'd rather not change all the corruption text tag ordering;
> >> it'll make it harder to track down any common occurrences of
> >> "xfs_iformat(X)" corruption in the future if they get renumbered now.
> >>
> >> I'd either make this xfs_iformat(2.1) ;) or just leave it as Christoph
> >> had.  "realtime" is a lot more informative than "3" anyway.
> >=20
> > I don't think this is a bad decision, because the corruption errors can
> > be easily identified by the output of xfs_fs_repair_cmn_err and the
> > source line. I think this is a reasonable change that will keep the cod=
e
> > clean and consistent.
>=20
> Until you wind up looking at a problem from some old kernel, or modified
> vendor kernel, and you realize that now you really don't know which
> error "xfs_iformat(6)" is anymore, and you either have to go digging
> through trees that aren't handy, or you just give up and don't bother to
> help because now it's too much of a pain.  ;)
>=20
> But I can leave it up to the folks @ sgi, I can see both sides of the
> argument, and I won't care too much either way.

Yes, whatever they decide should be ok. Thanks for your feedback Eric.

-Ramon

>=20
> Thanks,
> -Eric
>=20
> > -Ramon
> >=20
> >> -Eric
>=20
>=20

--=-eGupLCjjG8bKSXdvQf7+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkp5h1MACgkQGIS0iEuhp4PkPQCeNz6PGoKQQLEGheuHGjo03ayM
MJYAnAmZcitfm1B+5IPpHFGQqxEtvEkO
=4xfc
-----END PGP SIGNATURE-----

--=-eGupLCjjG8bKSXdvQf7+--


--===============9121441324045265360==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============9121441324045265360==--
