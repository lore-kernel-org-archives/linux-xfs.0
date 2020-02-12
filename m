Return-Path: <SRS0=V0Y3=4A=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0DE3C2BA83
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Feb 2020 15:26:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9ED4D21569
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Feb 2020 15:26:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728094AbgBLP0U (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 Feb 2020 10:26:20 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:56300 "EHLO smtp.gentoo.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727519AbgBLP0T (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 12 Feb 2020 10:26:19 -0500
Received: from [IPv6:2001:4dd4:2014:0:9098:2ad9:e5a1:caf4] (2001-4dd4-2014-0-9098-2ad9-e5a1-caf4.ipv6dyn.netcologne.de [IPv6:2001:4dd4:2014:0:9098:2ad9:e5a1:caf4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: whissi)
        by smtp.gentoo.org (Postfix) with ESMTPSA id 84F3934EBF8
        for <linux-xfs@vger.kernel.org>; Wed, 12 Feb 2020 15:26:17 +0000 (UTC)
To:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
From:   Thomas Deutschmann <whissi@gentoo.org>
Subject: xfsdump: Building inventory: gcc: fatal error: no input files
Organization: Gentoo Foundation, Inc
Message-ID: <ab3571df-40c1-dad8-800f-48c1a64355fe@gentoo.org>
Date:   Wed, 12 Feb 2020 16:26:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="mzdFUbvqHZqxYBG93esVEXhNl0U1Flp7t"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--mzdFUbvqHZqxYBG93esVEXhNl0U1Flp7t
Content-Type: multipart/mixed; boundary="PFBGnmpRXzJ0YOBntYIsB0SsvvRYfefQV"

--PFBGnmpRXzJ0YOBntYIsB0SsvvRYfefQV
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi,

not sure if anybody has noticed yet but when building xfsdump, there
seems to be a non-fatal build error:

> Building inventory
>     [LTDEP]
> gcc: fatal error: no input files
> compilation terminated.

With remake I see

> ~/sys-fs/xfsdump-3.1.9/work/xfsdump-3.1.9/inventory $ remake --trace=3D=
read
> Reading makefile 'Makefile'...
> Reading makefile '../include/builddefs' (search path) (no ~ expansion).=
=2E.
> Reading makefile '../include/buildmacros' (search path) (no ~ expansion=
)...
> Reading makefile '../include/buildrules' (search path) (no ~ expansion)=
=2E..
> Reading makefile '../include/builddefs' (search path) (no ~ expansion).=
=2E.
> Reading makefile '.ltdep' (search path) (don't care) (no ~ expansion)..=
=2E
>     [LTDEP]
> x86_64-pc-linux-gnu-gcc -MM -O2 -pipe -march=3Divybridge -mtune=3Divybr=
idge -mno-xsaveopt -Wno-error=3Dclobbered -Wno-error=3Dformat-overflow -W=
no-error=3Dunused-function -Wno-error=3Dimplicit-function-declaration -Wn=
o-error=3Dmaybe-uninitialized -frecord-gcc-switches -D_GNU_SOURCE  -O2 -p=
ipe -march=3Divybridge -mtune=3Divybridge -mno-xsaveopt -Wno-error=3Dclob=
bered -Wno-error=3Dformat-overflow -Wno-error=3Dunused-function -Wno-erro=
r=3Dimplicit-function-declaration -Wno-error=3Dmaybe-uninitialized -freco=
rd-gcc-switches -DNDEBUG -DVERSION=3D\"3.1.9\" -DLOCALEDIR=3D\"/usr/share=
/locale\" -DPACKAGE=3D\"xfsdump\" -I../include -DENABLE_GETTEXT -D_GNU_SO=
URCE -D_FILE_OFFSET_BITS=3D64 -funsigned-char -fno-strict-aliasing -Wall =
   | /bin/sed -e 's,^\([^:]*\)\.o,\1.lo,' > .ltdep
> x86_64-pc-linux-gnu-gcc: fatal error: no input files
> compilation terminated.
> Reading makefile 'Makefile'...
> Reading makefile '../include/builddefs' (search path) (no ~ expansion).=
=2E.
> Reading makefile '../include/buildmacros' (search path) (no ~ expansion=
)...
> Reading makefile '../include/buildrules' (search path) (no ~ expansion)=
=2E..
> Reading makefile '../include/builddefs' (search path) (no ~ expansion).=
=2E.
> Reading makefile '.ltdep' (search path) (don't care) (no ~ expansion)..=
=2E
> remake: Nothing to be done for 'default'.

Seen in xfsdump-3.1.6-3.1.9.

Not just in Gentoo, it's also present in Debian, see
https://buildd.debian.org/status/fetch.php?pkg=3Dxfsdump&arch=3Damd64&ver=
=3D3.1.6%2Bnmu2%2Bb2&stamp=3D1526577413&raw=3D0


--=20
Regards,
Thomas Deutschmann / Gentoo Linux Developer
C4DD 695F A713 8F24 2AA1 5638 5849 7EE5 1D5D 74A5


--PFBGnmpRXzJ0YOBntYIsB0SsvvRYfefQV--

--mzdFUbvqHZqxYBG93esVEXhNl0U1Flp7t
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQGTBAEBCgB9FiEEExKRzo+LDXJgXHuURObr3Jv2BVkFAl5EGRNfFIAAAAAALgAo
aXNzdWVyLWZwckBub3RhdGlvbnMub3BlbnBncC5maWZ0aGhvcnNlbWFuLm5ldDEz
MTI5MUNFOEY4QjBENzI2MDVDN0I5NDQ0RTZFQkRDOUJGNjA1NTkACgkQRObr3Jv2
BVmcGwf9FmsLbfvyouzfbhSHC3RA3EYqaPofD/I4QrA2tnqBMEt9ZITRLXoWmS0d
loY2R5YiiW65eY5FjeUeHzyvsAPHoQzzOTU4ff2DL6qEJfJCHOdJwjK0qW3tDCZZ
bmgS4qHWJnwGNNWj5tU5nntLHif+h95WGgqSanVIsx9lhDfgYbKKDnYHJ18iGQ3q
rNDiNqzmUCsk+X6wnEGjqjCFatQW4826HfytYahV4VHMUFkJsgPmX2UrHo/cSyeG
25tCuFS2J8vX7nZW3q8474lGnk4Jt8zqrquMTxLNKXj5WTWpg/lyQMc8t1BQ0iTz
xS/1I4x6b8c6mYNa2nrNhkV+Pka1sw==
=wRCx
-----END PGP SIGNATURE-----

--mzdFUbvqHZqxYBG93esVEXhNl0U1Flp7t--
