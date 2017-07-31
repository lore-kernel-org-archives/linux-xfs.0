Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail1.g1.pair.com ([66.39.3.162]:47904 "EHLO mail1.g1.pair.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751446AbdGaLRy (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 31 Jul 2017 07:17:54 -0400
Date: Mon, 31 Jul 2017 13:17:54 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: xfs seems performance lower when long time seq write into ssd
Message-ID: <20170731131754.73fac669@harpe.intellique.com>
In-Reply-To: <CA+jpiF7jK8m+a6LGKfj-CbfMEHqjsL5ZdagnzOAdRRwNxZg0oA@mail.gmail.com>
References: <CA+jpiF7jK8m+a6LGKfj-CbfMEHqjsL5ZdagnzOAdRRwNxZg0oA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/LoXmq39NI=OaM9qmWIKbdcm"; protocol="application/pgp-signature"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: =?UTF-8?B?546L5YuH?= <wang.yong@datatom.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>, xfs <xfs@oss.sgi.com>

--Sig_/LoXmq39NI=OaM9qmWIKbdcm
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Le Mon, 31 Jul 2017 16:51:29 +0800
=E7=8E=8B=E5=8B=87 <wang.yong@datatom.com> =C3=A9crivait:

> Hi All,
> Recently, I meet a  strange quetion. I have done seq write
> (blocksize=3D1m) into mount folders.
> If total bytes is small, the avg write rate is 370MBs (little files :
>  4MB * 256 * 60 )
> If total bytes is big, the avg write rate is 180MBs  (a lot of files :
>   4MB * 256 * 600)
> the raw ssd benchmark, seq write is 400MBs.
>=20
> Can anybody help to explain it?  argument is wrong, or something else.

There are several problems here:

First you didn't mention which version of xfsprogs you're using (try
"xfs_repair -V" for instance). You didn't say what your SSD is like
(make, model, size, flash type, interface, etc), either.

Second, you didn't tell the exact command lines you used in each of
your tests (small, big, and raw): "dd if=3D/dev/zero...", "iozone", etc?
and how you measured throughput: is it overall, mean throughput, as
reported by "dd" after the fact, or did you sample the performance at
some points during the test?

Third, SSD don't work like HDD. Particularly, you can't simply
oeverwrite on data blocks that are marked unused but still hold data;
you must erase them first. Worse, you write pages (typically 4K) but
erase much larger blocks (typically 128K or more).=20

So you can't benchmark an SSD properly by simply writing again and
again; you MUST use the "trim" command beforehand, to clean up blocks
that have been written but NOT actually erased. Else the SSD controller
will need to perform some "garbage collection" while writing, creating
slowdowns or even pauses.
Also notice that many SSD controllers perform on-the-fly compression.
That may greatly affect performance.

Let's say that your SSD is 1000 GB. You run 10 tests with a 60GB
data set. That fills in 600 GB of flash.

You erased the files, but *that doesn't necessarily clear the flash*. So
when you try writing 600 GB the next time, the SSD will use its
remaining 400 GB, then becomes very slow for the last 200GB because it
must clear up some space before each write...=20

--=20
------------------------------------------------------------------------
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
------------------------------------------------------------------------

--Sig_/LoXmq39NI=OaM9qmWIKbdcm
Content-Type: application/pgp-signature
Content-Description: Signature digitale OpenPGP

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAll/EeMACgkQX3jQXNUicVZR4gCgljwjDhutINy+GD2YjrhilPqN
/MQAn2U+qlHQRsyGI1wlUAtdG3fkAmih
=itTK
-----END PGP SIGNATURE-----

--Sig_/LoXmq39NI=OaM9qmWIKbdcm--
