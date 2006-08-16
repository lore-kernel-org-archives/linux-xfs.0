Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 16 Aug 2006 01:32:53 -0700 (PDT)
Received: from smtp3.adl2.internode.on.net (smtp3.adl2.internode.on.net [203.16.214.203])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k7G8WIDW029162
	for <xfs@oss.sgi.com>; Wed, 16 Aug 2006 01:32:22 -0700
Subject: Re: review: fsblock zero - don't panic
From: Stewart Smith <stewart@flamingspork.com>
In-Reply-To: <20060816142800.D2762042@wobbly.melbourne.sgi.com>
References: <20060810155851.C2591606@wobbly.melbourne.sgi.com>
	 <20060811032626.GF50254148@melbourne.sgi.com>
	 <20060816142800.D2762042@wobbly.melbourne.sgi.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-x5YZkhxpKDkuvfYjaknR"
Date: Wed, 16 Aug 2006 15:23:33 +0800
Message-Id: <1155713014.7103.345.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Nathan Scott <nathans@sgi.com>
Cc: David Chinner <dgc@sgi.com>, xfs@oss.sgi.com

--=-x5YZkhxpKDkuvfYjaknR
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2006-08-16 at 14:28 +1000, Nathan Scott wrote:
> On Fri, Aug 11, 2006 at 01:26:26PM +1000, David Chinner wrote:
> > ...
> > Looks OK.
>=20
> Thanks mate.
>=20
> > ...
> > If you are hinting this branch to be unlikely, then we should also
> > check the start block first before checking the io_flags.  We only
> > need to check the io_flags if we are actually accessing block zero.
>=20
> I've rolled this into a new version.  I also got prodded to still
> provide an option to panic on detecting this, for debugging - so I
> rewrote this to report through the panic_mask mechanism, which now
> gives us the option to optionally panic if need be... could you do
> a second pass over this for me?
>=20
> cheers.
>=20
> --=20
> Nathan
>=20
>=20
> Index: xfs-linux/xfs_bmap.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- xfs-linux.orig/xfs_bmap.c	2006-08-15 15:22:53.198187750 +1000
> +++ xfs-linux/xfs_bmap.c	2006-08-16 12:40:49.669518000 +1000
> @@ -3705,7 +3705,7 @@ STATIC xfs_bmbt_rec_t *=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20
>  xfs_bmap_search_extents(
>  	xfs_inode_t     *ip,            /* incore inode pointer */
>  	xfs_fileoff_t   bno,            /* block number searched for */
> -	int             whichfork,      /* data or attr fork */
> +	int             fork,      	/* data or attr fork */
>  	int             *eofp,          /* out: end of file found */
>  	xfs_extnum_t    *lastxp,        /* out: last extent index */
>  	xfs_bmbt_irec_t *gotp,          /* out: extent entry found */
> @@ -3713,25 +3713,28 @@ xfs_bmap_search_extents(
>  {
>  	xfs_ifork_t	*ifp;		/* inode fork pointer */
>  	xfs_bmbt_rec_t  *ep;            /* extent record pointer */
> -	int		rt;		/* realtime flag    */
>=20=20
>  	XFS_STATS_INC(xs_look_exlist);
> -	ifp =3D XFS_IFORK_PTR(ip, whichfork);
> +	ifp =3D XFS_IFORK_PTR(ip, fork);
>=20=20
>  	ep =3D xfs_bmap_search_multi_extents(ifp, bno, eofp, lastxp, gotp, prev=
p);
>=20=20
> -	rt =3D (whichfork =3D=3D XFS_DATA_FORK) && XFS_IS_REALTIME_INODE(ip);
> -	if (unlikely(!rt && !gotp->br_startblock && (*lastxp !=3D NULLEXTNUM)))=
 {
> -                cmn_err(CE_PANIC,"Access to block zero: fs: <%s> inode: =
%lld "
> -			"start_block : %llx start_off : %llx blkcnt : %llx "
> -			"extent-state : %x \n",
> -			(ip->i_mount)->m_fsname, (long long)ip->i_ino,
> +	if (unlikely(!(gotp->br_startblock) && (*lastxp !=3D NULLEXTNUM) &&
> +		     !(XFS_IS_REALTIME_INODE(ip) && fork =3D=3D XFS_DATA_FORK))) {
> +		xfs_cmn_err(XFS_PTAG_FSBLOCK_ZERO, CE_ALERT, ip->i_mount,
> +				"Access to block zero in inode %llu "
> +				"start_block: %llx start_off: %llx "
> +				"blkcnt: %llx extent-state: %x lastx: %x\n",
> +			(unsigned long long)ip->i_ino,
>  			(unsigned long long)gotp->br_startblock,
>  			(unsigned long long)gotp->br_startoff,
>  			(unsigned long long)gotp->br_blockcount,
> -			gotp->br_state);
> -        }
> -        return ep;
> +			gotp->br_state, *lastxp);
> +		*lastxp =3D NULLEXTNUM;
> +		*eofp =3D 1;
> +		return NULL;
> +	}
> +	return ep;
>  }
>=20=20
>=20
> Index: xfs-linux/xfs_iomap.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- xfs-linux.orig/xfs_iomap.c	2006-08-15 15:22:53.238190250 +1000
> +++ xfs-linux/xfs_iomap.c	2006-08-16 12:40:41.385000250 +1000
> @@ -536,23 +536,27 @@ xfs_iomap_write_direct(
>  	 * Copy any maps to caller's array and return any error.
>  	 */
>  	if (nimaps =3D=3D 0) {
> -		error =3D (ENOSPC);
> +		error =3D ENOSPC;
>  		goto error_out;
>  	}
>=20=20
> -	*ret_imap =3D imap;
> -	*nmaps =3D 1;
> -	if ( !(io->io_flags & XFS_IOCORE_RT)  && !ret_imap->br_startblock) {
> -                cmn_err(CE_PANIC,"Access to block zero:  fs <%s> inode: =
%lld "
> -                        "start_block : %llx start_off : %llx blkcnt : %l=
lx "
> -                        "extent-state : %x \n",
> -                        (ip->i_mount)->m_fsname,
> -                        (long long)ip->i_ino,
> -                        (unsigned long long)ret_imap->br_startblock,
> +	if (unlikely(!ret_imap->br_startblock &&
> +		     !(io->io_flags & XFS_IOCORE_RT))) {
> +		xfs_cmn_err(XFS_PTAG_FSBLOCK_ZERO, CE_ALERT, ip->i_mount,
> +				"Access to block zero in inode %llu "
> +				"start_block: %llx start_off: %llx "
> +				"blkcnt: %llx extent-state: %x\n",
> +			(unsigned long long)ip->i_ino,
> +			(unsigned long long)ret_imap->br_startblock,
>  			(unsigned long long)ret_imap->br_startoff,
> -                        (unsigned long long)ret_imap->br_blockcount,
> +			(unsigned long long)ret_imap->br_blockcount,
>  			ret_imap->br_state);
> -        }
> +		error =3D EFSCORRUPTED;

should this be XFS_ERROR(EFSCORRUPTED) ?

perhaps change to use it for consistency if the conversion is done in
error_out?

> +		goto error_out;

--=20
Stewart Smith (stewart@flamingspork.com)
http://www.flamingspork.com/


--=-x5YZkhxpKDkuvfYjaknR
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2.2 (GNU/Linux)

iD8DBQBE4sf1KglWCUL+FDoRApckAKCwCMnUW9PrdewglII6gxG2Uw5rxACgxk19
n0kdK0AVSOJ+ybuIhwKBcg4=
=OZFW
-----END PGP SIGNATURE-----

--=-x5YZkhxpKDkuvfYjaknR--
