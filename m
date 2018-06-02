Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ozlabs.org ([203.11.71.1]:40877 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750991AbeFBBdb (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 1 Jun 2018 21:33:31 -0400
Date: Sat, 2 Jun 2018 11:33:12 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: manual merge of the nvdimm tree with the xfs tree
Message-ID: <20180602113312.55667641@canb.auug.org.au>
In-Reply-To: <20180602005948.GH7825@magnolia>
References: <20180601185846.1c5b7d0a@canb.auug.org.au>
        <20180602005948.GH7825@magnolia>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/sr=3AYeLDjRXYPvJh5U_ts0"; protocol="application/pgp-signature"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Dan Williams <dan.j.williams@intel.com>, David Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, Linux-Next Mailing List <linux-next@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Dave Jiang <dave.jiang@intel.com>

--Sig_/sr=3AYeLDjRXYPvJh5U_ts0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Darrick,

On Fri, 1 Jun 2018 17:59:48 -0700 "Darrick J. Wong" <darrick.wong@oracle.co=
m> wrote:
>
> > + 	if (!dax_enabled) {
> >  -		pr_debug("VFS (%s): error: dax support not enabled\n",
> >  -				sb->s_id);
> >  +		pr_debug("%s: error: dax support not enabled\n",
> >  +				bdevname(bdev, buf));
> > - 		return false;
> > + 		return -EOPNOTSUPP; =20
>=20
> Hang on a sec, the changes in the xfs tree make this function return a
> boolean (true for dax-is-supported, false for dax-not-supported), but
> this change partially reverts the boolean return values.

OK, weird, that is what I though I had done.  Thanks for pointing it
out (I guess it was getting late :-().

> >   	}
> > -=20
> > - 	return true;
> > + 	return 0; =20
>=20
> The merge should retain the 'return false' above and the 'return true'
> here... or possibly just return dax_enabled:
>=20
> if (!dax_enabled) {
> 	pr_debug(...);
> 	pr_debug(...);
> }
>=20
> return dax_enabled;

OK, I have fixed up my merge resolution.  The end of that function will
now look like this:

	if (IS_ENABLED(CONFIG_FS_DAX_LIMITED) && pfn_t_special(pfn)) {
		/*
		 * An arch that has enabled the pmem api should also
		 * have its drivers support pfn_t_devmap()
		 *
		 * This is a developer warning and should not trigger in
		 * production. dax_flush() will crash since it depends
		 * on being able to do (page_address(pfn_to_page())).
		 */
		WARN_ON(IS_ENABLED(CONFIG_ARCH_HAS_PMEM_API));
		dax_enabled =3D true;
	} else if (pfn_t_devmap(pfn)) {
		struct dev_pagemap *pgmap;

		pgmap =3D get_dev_pagemap(pfn_t_to_pfn(pfn), NULL);
		if (pgmap && pgmap->type =3D=3D MEMORY_DEVICE_FS_DAX)
			dax_enabled =3D true;
		put_dev_pagemap(pgmap);
	}

	if (!dax_enabled)
		pr_debug("%s: error: dax support not enabled\n",
				bdevname(bdev, buf));

	return dax_enabled;
}
EXPORT_SYMBOL_GPL(__bdev_dax_supported);

--=20
Cheers,
Stephen Rothwell

--Sig_/sr=3AYeLDjRXYPvJh5U_ts0
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAlsR89gACgkQAVBC80lX
0GyA2Qf/ZX3JXduaYkrCSj80K7ImW47ZFBitmDJVce5TMwTDCdYvkJvWRccKKYn/
/UMxxAD6M2OhvrX/D1Z/x603r4gQo3vDED2GHYZodVDWnCeyy25Wy4BuZotYumop
xWpN/QLBu4C+uy51WGaWOUDWQvPk48MisHjE9B2L5tVdNqmxwehen//RT3SH/ekh
RTh08MGr2wbkhBHJ2+xUtLKfIZKXfdZpaxd9SHCZdd3VlB8OxXl7dDrAoI9RI0Ei
LXj4u5f3fD0m6g6ouJjpFtfMliVOmUuLBlH5fflrzOE2x3ARKafbVfa/LpwGkXhU
wYjTedmU9zxLsGPC5SnFhljoMTFRzw==
=8N8b
-----END PGP SIGNATURE-----

--Sig_/sr=3AYeLDjRXYPvJh5U_ts0--
