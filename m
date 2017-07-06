Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail1.g1.pair.com ([66.39.3.162]:25291 "EHLO mail1.g1.pair.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750922AbdGFOtg (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 6 Jul 2017 10:49:36 -0400
Date: Thu, 6 Jul 2017 16:49:29 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: Weird xfs_repair error
Message-ID: <20170706164929.11dcd8ec@harpe.intellique.com>
In-Reply-To: <20170706134801.GA56732@bfoster.bfoster>
References: <20170706153020.0ad6dd47@harpe.intellique.com>
        <20170706134801.GA56732@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/16IpsO4Sho5xBQOoFE7FfNI"; protocol="application/pgp-signature"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: "'linux-xfs@vger.kernel.org'" <linux-xfs@vger.kernel.org>

--Sig_/16IpsO4Sho5xBQOoFE7FfNI
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Le Thu, 6 Jul 2017 09:48:05 -0400
Brian Foster <bfoster@redhat.com> =C3=A9crivait:

> >=20
> > I've run xfs_repair 4.9 on the xfs_mdrestored image. It dumps an
> > insane lot of errors (the output log is 65MB)  and ends with this
> > very strange message:
> >=20
> > disconnected inode 26417467, moving to lost+found
> > disconnected inode 26417468, moving to lost+found
> > disconnected inode 26417469, moving to lost+found
> > disconnected inode 26417470, moving to lost+found
> >=20
> > fatal error -- name create failed in lost+found (117), filesystem
> > may be out of space
> >=20
> > Even stranger, after mounting back the image, there is no lost+found
> > anywhere to be found! However the filesystem has lots of free space
> > and free inodes, how come?
> >  =20
>=20
> Did you originally run xfs_repair using the -n option? I'd guess not
> if it ultimately failed making a modification, but if so, something
> to be aware of is that it skips warning about a dirty log and
> potentially can report much more corruption than after a log recovery
> occurs. It might be worth running after an attempted log recovery.

I've mounted the FS first to clean up the log. I've also tried making a
bigger image, in case the hosting file was too small. No dice.
=20
> Otherwise, I'd be curious about the state of the fs after the above
> error. Does 'xfs_repair -n' continue to report errors?

You're onto something here. In fact each time I re-run xfs_repair, it
still spits out many errors and ends with the same line as I mentioned
previously.
However each run of xfs_repair generates fewer errors. The first log
was 65MB; the second 7.5, the third 3.8MB. I'll try running it again
and again to see how it ends...

> Also the above suggests that lost+found existed (in a corrupted state)
> prior to the initial repair attempt, yes? If so, it might be
> interesting to identify the inode # of lost+found to follow what
> xfs_repair does to that inode during the initial run (e.g., if
> lost+found is corrupted and is attempted to be used before it is
> fixed up or something of that nature).

OK I'll try to restore the dump again to check "lost+found". Maybe I
could remove it before running the repair, but that's unlikely...

--=20
------------------------------------------------------------------------
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
------------------------------------------------------------------------

--Sig_/16IpsO4Sho5xBQOoFE7FfNI
Content-Type: application/pgp-signature
Content-Description: Signature digitale OpenPGP

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlleTfkACgkQX3jQXNUicVaudQCfYU8icj4zxQsynpe1YlI+BPFV
r0QAni3qV/TvUpQXCUO7xLMl7yCr7Vg0
=Z9OL
-----END PGP SIGNATURE-----

--Sig_/16IpsO4Sho5xBQOoFE7FfNI--
