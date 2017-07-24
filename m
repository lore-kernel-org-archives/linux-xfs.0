Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail1.g1.pair.com ([66.39.3.162]:16101 "EHLO mail1.g1.pair.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751827AbdGXO1Z (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 24 Jul 2017 10:27:25 -0400
Date: Mon, 24 Jul 2017 16:27:28 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: Weird xfs_repair error
Message-ID: <20170724162728.2a77797a@harpe.intellique.com>
In-Reply-To: <20170717171129.GA57771@bfoster.bfoster>
References: <20170706153020.0ad6dd47@harpe.intellique.com>
        <20170706232803.GF17762@dastard>
        <20170707135009.68c22182@harpe.intellique.com>
        <20170707153633.GG4103@magnolia>
        <20170711152340.4cd5dff9@harpe.intellique.com>
        <20170717171129.GA57771@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/tNlR9snWEW0nLW/fQ=shNGe"; protocol="application/pgp-signature"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>, "'linux-xfs@vger.kernel.org'" <linux-xfs@vger.kernel.org>

--Sig_/tNlR9snWEW0nLW/fQ=shNGe
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Le Mon, 17 Jul 2017 13:11:29 -0400
Brian Foster <bfoster@redhat.com> =C3=A9crivait:

> On Tue, Jul 11, 2017 at 03:23:52PM +0200, Emmanuel Florac wrote:
> > Le Fri, 7 Jul 2017 08:36:33 -0700
> > "Darrick J. Wong" <darrick.wong@oracle.com> =C3=A9crivait:
> >  =20
> > > > fatal error -- name create failed in lost+found (28), filesystem
> > > > may be out of space   =20
> > >=20
> > > Would be helpful to have a metadump of this goobered-up lost+found
> > > fs...
> > >  =20
> >=20
> > The metadump is here for anyone who would like to have a look:
> >=20
> > http://update2.intellique.com/pub/bign.metadump.xz
> >=20
> > The filesystem is about 115 TiB.
> >  =20
>=20
> Thanks for posting this. The first thing to note is that this
> filesystem is severely corrupted.

This I have determined myself through the fact that many runs of
xfs_repair (and different versions of it, v4.7, 4.9, 4.11...) can't get
it into a stable (i.e. that won't crash while trying to access it)
state.

> Nonetheless, I've been playing
> around with trying to get the latest for-next xfs_repair to run
> through this fs (via gdb) and have definitely hit a few issues:
>=20
> - xfs_sb_verify() was changed to use bp->b_maps[0].bm_bn rather than
>   bp->b_bn in libxfs commit 85428dd23f ("xfs: fix superblock
> inprogress check"). b_maps isn't allocated if the buffer was
> initialized with libxfs_initbuf() (rather than libxfs_initbuf_map()).
> This causes a sigsegv here, though only if I disable -O2 optimization
> for some reason that I haven't dug into yet.
> - libxfs commit 0268fdc3fe ("xfs: remove xfs_trans_get_block_res")
>   replaced the use of xfs_trans_get_block_res() in
>   xfs_bmbt_alloc_block() which causes the -ENOSPC error. The previous
>   function was hardcoded to return 1 such that this would never occur.
> - The recently added directory sf format verifier (xfs_iformat_fork()
> -> xfs_dir2_sf_verify()) seems to cause a premature repair failure in
> at least one case.
>=20
> I was able to eventually get repair to complete with some quick hacks
> to bypass those issues. I did have to run repair two or three times
> to get the fs to a clean state. The fs mounts and otherwise appears
> clean to xfs_repair, but it's not clear to me how usable the
> resulting fs really is (repair is for fs consistency after all, not
> necessarily data recovery). Note that lost+found appears to be loaded
> with 18T of data across almost 2 million inodes. :/

Thank you for your efforts, the loaded lost+found matches my own
results, however some of the files there have been present for possibly
years. In fact this filesystem has crashed several times in the past
years but always went back online at some point, until... now.

So what could I do, at least to be able to mount it and copy everything
elsewhere before mkfs'ing it all again? Do you have an xfs_repair
binary at hand that I could use, or should I dig into the latest
source?

--=20
------------------------------------------------------------------------
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
------------------------------------------------------------------------

--Sig_/tNlR9snWEW0nLW/fQ=shNGe
Content-Type: application/pgp-signature
Content-Description: Signature digitale OpenPGP

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAll2A9AACgkQX3jQXNUicVaF7gCcDbcAAtSjl7aZMlWyWj9l2vRa
Zh8AoN1x3cUKpzzJlVGbQ+DKFpAekJz0
=XWSq
-----END PGP SIGNATURE-----

--Sig_/tNlR9snWEW0nLW/fQ=shNGe--
