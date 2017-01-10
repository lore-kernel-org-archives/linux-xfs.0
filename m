Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.gocept.net ([195.62.125.19]:46361 "EHLO mail.gocept.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753218AbdAJHH4 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 10 Jan 2017 02:07:56 -0500
Received: from localhost (localhost [127.0.0.1])
        by mail.gocept.net (Postfix) with ESMTP id 90C0914C0051
        for <linux-xfs@vger.kernel.org>; Tue, 10 Jan 2017 08:07:39 +0100 (CET)
Received: from mail.gocept.net ([127.0.0.1])
        by localhost (mail.gocept.net [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id lSyu8X_ih0_h for <linux-xfs@vger.kernel.org>;
        Tue, 10 Jan 2017 08:07:38 +0100 (CET)
Received: from [IPv6:2003:a:b60:f100:204e:8d33:713b:c3b5] (unknown [IPv6:2003:a:b60:f100:204e:8d33:713b:c3b5])
        (Authenticated sender: ct@flyingcircus.io)
        by mail.gocept.net (Postfix) with ESMTPSA
        for <linux-xfs@vger.kernel.org>; Tue, 10 Jan 2017 08:07:38 +0100 (CET)
From: Christian Theune <ct@flyingcircus.io>
Content-Type: multipart/signed;
 boundary="Apple-Mail=_C881D4E8-7202-49E6-A9C7-31617FBEA957";
 protocol="application/pgp-signature"; micalg=pgp-sha512
Mime-Version: 1.0 (Mac OS X Mail 10.2 \(3259\))
Subject: Reading about CoW architecture / Performance Limits
Message-Id: <BC894F29-47E7-47A3-93FB-3E4EEE1DCDD5@flyingcircus.io>
Date: Tue, 10 Jan 2017 08:07:39 +0100
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org


--Apple-Mail=_C881D4E8-7202-49E6-A9C7-31617FBEA957
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8

Hi,

as XFS is gaining CoW support I=E2=80=99d like to understand the =
implementation on a specific aspect: we=E2=80=99re using CoW for making =
disk image backups as image files in btrfs. This has proven prohibitive =
once the chain of CoW reflinks grows too long and everything becomes too =
fragmented. btrfs has improved in some places but the issue still =
persists.

We=E2=80=99re currently considering to move away from CoW filesystems =
for our use case and implement a higher level strategy. I now wonder =
whether XFS will have the same issue or whether the architecture is =
different in a significant way that will avoid prohibitive performance =
regressions on long CoW chains (think: hundreds to a few thousand).

I would appreciate a pointer where to look at - I=E2=80=99m a coder but =
following kernel code to understand architecture hasn=E2=80=99t been =
successful/efficient for me in the past =E2=80=A6

Kind regards,
Christian

--
Christian Theune =C2=B7 ct@flyingcircus.io =C2=B7 +49 345 219401 0
Flying Circus Internet Operations GmbH =C2=B7 http://flyingcircus.io
Forsterstra=C3=9Fe 29 =C2=B7 06112 Halle (Saale) =C2=B7 Deutschland
HR Stendal HRB 21169 =C2=B7 Gesch=C3=A4ftsf=C3=BChrer: Christian. =
Theune, Christian. Zagrodnick


--Apple-Mail=_C881D4E8-7202-49E6-A9C7-31617FBEA957
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - https://gpgtools.org

iQEcBAEBCgAGBQJYdIg7AAoJEKuh8lKpfGLO3x0H/Aqw8o4i9M9NBzBdSMsPiDuV
gGIRYPrC1E959zgtQh6uzD6mUpYQ/bP2cknsZXFuMICo/hSxmuIOWCixICyQVk5V
8h9h1Xtb6JfkKLFT9UyaCA3tqbiZEx6omSzQYYENb5u6oefh7cQyyvxUuBh8Pgzi
e2BfY57hvWQLSMRD4YroPlS2mlCliCHZxK9t9kw1Cgc2F3sG1QcYsnDb0NOgO8B1
huUb+9ndRN/TzrrAL8pwjr7M6t+K7t1RRa6f8KjI7AwePD3TO9/qvDBZpYYDqfSV
TzMGZqBex9S2OHEsP+2nhB0yS77UA3aR/OmwH68lDOdlUlE6MMAQMA0s6u17V4M=
=flib
-----END PGP SIGNATURE-----

--Apple-Mail=_C881D4E8-7202-49E6-A9C7-31617FBEA957--
