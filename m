Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:55180 "EHLO smtp.gentoo.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726236AbfHLWSP (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 12 Aug 2019 18:18:15 -0400
Received: from [IPv6:2001:4dd6:f35f:0:149a:6c9b:d6bb:ae22] (2001-4dd6-f35f-0-149a-6c9b-d6bb-ae22.ipv6dyn.netcologne.de [IPv6:2001:4dd6:f35f:0:149a:6c9b:d6bb:ae22])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: whissi)
        by smtp.gentoo.org (Postfix) with ESMTPSA id EBF693499D3
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 22:18:12 +0000 (UTC)
Subject: Re: xfsprogs-5.2.0 FTBFS: ../libxfs/.libs/libxfs.so: undefined
 reference to `xfs_ag_geom_health'
References: <c4b1b7db-bf73-9b96-b418-5a639e7decdc@gentoo.org>
 <20190811225307.GF7777@dread.disaster.area>
 <ebcf887f-81fc-9080-67c9-63946316f3e0@gentoo.org>
 <20190812002306.GH7777@dread.disaster.area>
 <df65ea4f-18af-4fab-e59d-29fa8440489c@gentoo.org>
 <20190812031123.GA6129@dread.disaster.area>
 <20190812043046.GB6129@dread.disaster.area>
 <09ad7dd5-c2cd-aaaa-82d5-0f3a18eb4062@gentoo.org>
 <20190812214449.GC6129@dread.disaster.area>
From: Thomas Deutschmann <whissi@gentoo.org>
Message-ID: <ddabd271-2820-85f3-4393-99deb5a0eaef@gentoo.org>
Date: Tue, 13 Aug 2019 00:18:04 +0200
MIME-Version: 1.0
In-Reply-To: <20190812214449.GC6129@dread.disaster.area>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="UTZSbqglDWAnfBPMK4K99WazVQh27ucyD"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--UTZSbqglDWAnfBPMK4K99WazVQh27ucyD
Content-Type: multipart/mixed; boundary="PnNaWkmD9W2sV5kMZ4wMbuu8puE7b6vj9";
 protected-headers="v1"
From: Thomas Deutschmann <whissi@gentoo.org>
To: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Message-ID: <ddabd271-2820-85f3-4393-99deb5a0eaef@gentoo.org>
Subject: Re: xfsprogs-5.2.0 FTBFS: ../libxfs/.libs/libxfs.so: undefined
 reference to `xfs_ag_geom_health'
References: <c4b1b7db-bf73-9b96-b418-5a639e7decdc@gentoo.org>
 <20190811225307.GF7777@dread.disaster.area>
 <ebcf887f-81fc-9080-67c9-63946316f3e0@gentoo.org>
 <20190812002306.GH7777@dread.disaster.area>
 <df65ea4f-18af-4fab-e59d-29fa8440489c@gentoo.org>
 <20190812031123.GA6129@dread.disaster.area>
 <20190812043046.GB6129@dread.disaster.area>
 <09ad7dd5-c2cd-aaaa-82d5-0f3a18eb4062@gentoo.org>
 <20190812214449.GC6129@dread.disaster.area>
In-Reply-To: <20190812214449.GC6129@dread.disaster.area>

--PnNaWkmD9W2sV5kMZ4wMbuu8puE7b6vj9
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 2019-08-12 23:44, Dave Chinner wrote:
>> That's not the correct way to reproduce. It's really important to
>> _export_ the variable to trigger the problem and _this_ is a problem i=
n
>> xfsprogs' build system.
> Which means you are overriding the LDFLAGS set by configure when
> you _run make_, not just telling configure to use those LDFLAGS.
>=20
> That's why _make_ is getting screwed up - it is doing exactly what
> you are telling it to do, and that is to overrides every occurrence
> of LDFLAGS with your exported options rather than using the correct
> set configure calculated and specified.
>=20
> Exporting your CFLAGS and LDFLAGS is the wrong thing to doing
> - they should only ever be passed to the configure invocation and
> not remain to pollute the build environment after you've run
> configure.

I disagree with the conclusion. LDFLAGS in build environment shouldn't
cause any problems, especially when you are using a build system:

Normally, configure will get the value and the Makefiles will use the
value _from_ configure... but using configure _and_ reading _and adding_
values from environment _in addition_ seems to be wrong.

So you either use a build system or you don't.


--=20
Regards,
Thomas Deutschmann / Gentoo Linux Developer
C4DD 695F A713 8F24 2AA1 5638 5849 7EE5 1D5D 74A5


--PnNaWkmD9W2sV5kMZ4wMbuu8puE7b6vj9--

--UTZSbqglDWAnfBPMK4K99WazVQh27ucyD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQGTBAEBCgB9FiEEExKRzo+LDXJgXHuURObr3Jv2BVkFAl1R5ZxfFIAAAAAALgAo
aXNzdWVyLWZwckBub3RhdGlvbnMub3BlbnBncC5maWZ0aGhvcnNlbWFuLm5ldDEz
MTI5MUNFOEY4QjBENzI2MDVDN0I5NDQ0RTZFQkRDOUJGNjA1NTkACgkQRObr3Jv2
BVkfMQf/ZEYEMA5LNrFWEKVgQZranFfpot3FnxkghViJ4pafxFxtdWK5a/tcnlQZ
YCSeuDsmvMphqi2BCFFUoPOCwGCSeIK6m6o+cjVGi9uoaOXmgNsaN1nEW2EeCvdh
Ys0F9TOdSvWLpurdkosphVty3qmaaqRTI8CUJr/t/pQbp8xiUytrLPYs9HEUNk38
d4CmeyO0WTZbGewEJGmk9u1p8ZtH/BHV6tk96WFgjrPDHr5krd6ZlxUdV20rjH+e
SHKBTm7NrZoBuaO6jTz9yf5CuNN96A0nVJ92O5KaGKeDIgGXKf37cyz/nf6L/N5+
9+i+3Bu6vqWDHigB4FQ4kmbgSJp6mw==
=UsY9
-----END PGP SIGNATURE-----

--UTZSbqglDWAnfBPMK4K99WazVQh27ucyD--
