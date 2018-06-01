Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ozlabs.org ([203.11.71.1]:49699 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750724AbeFAI7G (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 1 Jun 2018 04:59:06 -0400
Date: Fri, 1 Jun 2018 18:58:46 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: linux-next: manual merge of the nvdimm tree with the xfs tree
Message-ID: <20180601185846.1c5b7d0a@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/nO66g8gdPLsiZHK6IX858ml"; protocol="application/pgp-signature"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dan Williams <dan.j.williams@intel.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, David Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Cc: Linux-Next Mailing List <linux-next@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Dave Jiang <dave.jiang@intel.com>

--Sig_/nO66g8gdPLsiZHK6IX858ml
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Dan,

Today's linux-next merge of the nvdimm tree got a conflict in:

  drivers/dax/super.c

between commits:

  ba23cba9b3bd ("fs: allow per-device dax status checking for filesystems")
  80660f20252d ("dax: change bdev_dax_supported() to support boolean return=
s")

from the xfs tree and commit:

  e76384884344 ("mm: introduce MEMORY_DEVICE_FS_DAX and CONFIG_DEV_PAGEMAP_=
OPS")

from the nvdimm tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

--=20
Cheers,
Stephen Rothwell
diff --cc drivers/dax/super.c
index 1d7bd96511f0,88672b6f6252..000000000000
--- a/drivers/dax/super.c
+++ b/drivers/dax/super.c
@@@ -80,11 -80,13 +80,12 @@@ EXPORT_SYMBOL_GPL(fs_dax_get_by_bdev)
   * This is a library function for filesystems to check if the block device
   * can be mounted with dax option.
   *
 - * Return: negative errno if unsupported, 0 if supported.
 + * Return: true if supported, false if unsupported
   */
 -int __bdev_dax_supported(struct super_block *sb, int blocksize)
 +bool __bdev_dax_supported(struct block_device *bdev, int blocksize)
  {
 -	struct block_device *bdev =3D sb->s_bdev;
  	struct dax_device *dax_dev;
+ 	bool dax_enabled =3D false;
  	pgoff_t pgoff;
  	int err, id;
  	void *kaddr;
@@@ -134,15 -135,22 +135,22 @@@
  		 * on being able to do (page_address(pfn_to_page())).
  		 */
  		WARN_ON(IS_ENABLED(CONFIG_ARCH_HAS_PMEM_API));
+ 		dax_enabled =3D true;
  	} else if (pfn_t_devmap(pfn)) {
- 		/* pass */;
- 	} else {
+ 		struct dev_pagemap *pgmap;
+=20
+ 		pgmap =3D get_dev_pagemap(pfn_t_to_pfn(pfn), NULL);
+ 		if (pgmap && pgmap->type =3D=3D MEMORY_DEVICE_FS_DAX)
+ 			dax_enabled =3D true;
+ 		put_dev_pagemap(pgmap);
+ 	}
+=20
+ 	if (!dax_enabled) {
 -		pr_debug("VFS (%s): error: dax support not enabled\n",
 -				sb->s_id);
 +		pr_debug("%s: error: dax support not enabled\n",
 +				bdevname(bdev, buf));
- 		return false;
+ 		return -EOPNOTSUPP;
  	}
-=20
- 	return true;
+ 	return 0;
  }
  EXPORT_SYMBOL_GPL(__bdev_dax_supported);
  #endif

--Sig_/nO66g8gdPLsiZHK6IX858ml
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEyBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAlsRCsYACgkQAVBC80lX
0GyFOAf2K+fI2g6HeikpCglpE1Sy2lLveEtJwmDWERcgWp2uTChs2ayL2EM/lsEy
IYtX0eF5hHP+w2M3T3vPtxFR4unKa8ushPRBOkv4enZB1LxbUq4WmRBOGuBBJ9sg
4EnxdyikLdQ0Ko7++qdtTEsiQ9HoPAvmArmeEH2ixDsDkSsB7vddaqoUtSTZwoQA
WdgaW6CdZGUhRwxV60aiJlC+43V9LGSljEqdTyK3u8nh4xkLlOSqiMhPnzsGcfih
aYXP8wj0XXYlQmIdcKDQ5vrOUtdw6aMejtAVVGXmGlFty55ez4aEtXQON+5x29gZ
vue3ERWlIfRrup6E5xNuzO1eUd43
=jYhb
-----END PGP SIGNATURE-----

--Sig_/nO66g8gdPLsiZHK6IX858ml--
