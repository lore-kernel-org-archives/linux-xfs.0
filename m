Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail1.g1.pair.com ([66.39.3.162]:53455 "EHLO mail1.g1.pair.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751115AbdHAOEL (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 1 Aug 2017 10:04:11 -0400
Date: Tue, 1 Aug 2017 16:04:12 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: metadata I/O error: block 0x575b6d70,("xfs_trans_read_buf_map")
 error 4 numblks 16
Message-ID: <20170801160412.1ee5be5b@harpe.intellique.com>
In-Reply-To: <b29b31a1-edb9-47f4-a641-11ecfc289c99@profihost.ag>
References: <e4606e43-468e-431c-1663-6b167cc5648b@profihost.ag>
        <20170801153548.15cf74ef@harpe.intellique.com>
        <b29b31a1-edb9-47f4-a641-11ecfc289c99@profihost.ag>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/k25T4yGzPOfrDYseqxkAtHx"; protocol="application/pgp-signature"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Cc: linux-xfs@vger.kernel.org

--Sig_/k25T4yGzPOfrDYseqxkAtHx
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Le Tue, 1 Aug 2017 15:50:20 +0200
Stefan Priebe - Profihost AG <s.priebe@profihost.ag> =C3=A9crivait:

> Hello Emmanuel,
>=20
> yes there are bcache patches already applied:
> 0002-bcache-bch_writeback_thread-is-not-freezable.patch
> 0003-bcache-bch_allocator_thread-is-not-freezable.patch
> 0001-bcache-partition-support-add-16-minors-per-bcacheN-d.patch
> 0044-bcache-Remove-deprecated-create_workqueue.patch
> 0045-bcache-Remove-redundant-parameter-for-cache_alloc.patch
> 0046-bcache-update-document-info.patch
> 0047-bcache-Remove-redundant-block_size-assignment.patch
> 0048-bcache-register_bcache-call-blkdev_put-when-cache_al.patch
> 0049-bcache-pr_err-more-meaningful-error-message-when-nr_.patch
> 0071-bcache-switch-to-using-blk_queue_write_cache.patch
> 0092-bcache-use-op_is_write-instead-of-checking-for-REQ_W.patch
> 0110-bcache-use-bio-op-accessors.patch
> 0253-bcache-use-op_is_sync-to-check-for-synchronous-reque.patch
> 0344-bcache-debug-avoid-accessing-.bi_io_vec-directly.patch
> 0002-bcache-fix-calling-ida_simple_remove-with-incorrect-minor.patch
> 0001-bcache-force-trigger-gc.patch
> 0001-bcache-only-recovery-I-O-error-for-writethrough-mode.patch

Good.
=20
> There is no trace involved as there is no kernel bug triggered. That's
> the whole output.

Too bad :/ What are the underlying devices? No error at all at the
kernel level? No IO error? Is bcache configured write-back or
write-through?

--=20
------------------------------------------------------------------------
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
------------------------------------------------------------------------

--Sig_/k25T4yGzPOfrDYseqxkAtHx
Content-Type: application/pgp-signature
Content-Description: Signature digitale OpenPGP

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlmAilwACgkQX3jQXNUicVaxbQCg2/H4fJfkMYQLPd9e7nxYLM3/
2/oAn0D1/SwqmsCgRcfudP7Ra4/O7/7R
=+Jl8
-----END PGP SIGNATURE-----

--Sig_/k25T4yGzPOfrDYseqxkAtHx--
