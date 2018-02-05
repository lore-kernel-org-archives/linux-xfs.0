Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail1.g1.pair.com ([66.39.3.162]:59221 "EHLO mail1.g1.pair.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753017AbeBEPKr (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 5 Feb 2018 10:10:47 -0500
Date: Mon, 5 Feb 2018 16:10:49 +0100
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: xfs_scrub: call for testing
Message-ID: <20180205161049.7e22aa09@harpe.intellique.com>
In-Reply-To: <e0ada9ef-aafb-5179-2729-447d67bd6265@sandeen.net>
References: <e0ada9ef-aafb-5179-2729-447d67bd6265@sandeen.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/+6plJK5jh1m6GAfvCkCIR7y"; protocol="application/pgp-signature"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

--Sig_/+6plJK5jh1m6GAfvCkCIR7y
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Le Fri, 2 Feb 2018 15:36:33 -0600
Eric Sandeen <sandeen@sandeen.net> =C3=A9crivait:

> I'd really value feedback on scrub as it stand at this point -
> Is the documentation clear?  Is the output correct?  Do the
> tool's arguments make sense?  Does it segfault?  Does it
> find real errors?  Does it crash your kernel? Does it
> eat your data?

Wouldn't it be better to remove the parts about repairing the
filesystem in the documentation? The man page states that it *can't*
repair the filesystem, but nonetheless explains under which
circumstances it *won't* be able to repair (in some theoretical future
version with repair capabilities, I suppose). Ditto with the -n and -y
option, I suppose they're both basically noop at the moment? That's
quite unclear what it actually does.

Regarding FITRIM for flash storage, I think most people refers to it as
"TRIM", not the ioctl name FITRIM. Using "TRIM" would probably be more
understandable IMO.

Because I'm such a funny boy, I just wanted to see what happens when
running xfs_scrub on an unsupported kernel. On both a 4.14.x and a
3.18.x it seems about right:

root@bareos16:~# ./xfs_scrub /mnt/raid/
EXPERIMENTAL xfs_scrub program in use! Use at your own risk!
Error: /mnt/raid: Kernel metadata scrubbing facility is not available.
Info: /mnt/raid: Scrub aborted after phase 1.
/mnt/raid: 2 errors found.

I don't have any system running 4.15 to test its effects, but I'll do
as soon as possible.

--=20
------------------------------------------------------------------------
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
------------------------------------------------------------------------

--Sig_/+6plJK5jh1m6GAfvCkCIR7y
Content-Type: application/pgp-signature
Content-Description: Signature digitale OpenPGP

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlp4c/oACgkQX3jQXNUicVarbgCfQqFH5yAI8Xzk22pkpPVwQBow
Vf4AoMXZ5/wH2BSi4om1sw41XncUmvxo
=jBpS
-----END PGP SIGNATURE-----

--Sig_/+6plJK5jh1m6GAfvCkCIR7y--
