Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58984 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751885AbdKTSNm (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 20 Nov 2017 13:13:42 -0500
Subject: Re: [PATCH 2/2] xfs_io: stat: treat statfs.f_flags as optional
References: <20171117195457.16218-1-jeffm@suse.com>
 <20171117195457.16218-2-jeffm@suse.com>
 <eb6a3a1c-3d0b-e266-b2af-cde661b65b7a@sandeen.net>
 <b6e0865f-5528-c7c9-9663-1a14e660c243@sandeen.net>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <671af24c-77d7-7826-5067-8349a5835170@suse.com>
Date: Mon, 20 Nov 2017 13:13:38 -0500
MIME-Version: 1.0
In-Reply-To: <b6e0865f-5528-c7c9-9663-1a14e660c243@sandeen.net>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="xHx3x4DP2FqTTWBwUiVQwfSk6GkSjVme8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--xHx3x4DP2FqTTWBwUiVQwfSk6GkSjVme8
Content-Type: multipart/mixed; boundary="mVhTwfuPw83u07A9UOGmlqBm4jJrpLgRa";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org
Message-ID: <671af24c-77d7-7826-5067-8349a5835170@suse.com>
Subject: Re: [PATCH 2/2] xfs_io: stat: treat statfs.f_flags as optional
References: <20171117195457.16218-1-jeffm@suse.com>
 <20171117195457.16218-2-jeffm@suse.com>
 <eb6a3a1c-3d0b-e266-b2af-cde661b65b7a@sandeen.net>
 <b6e0865f-5528-c7c9-9663-1a14e660c243@sandeen.net>
In-Reply-To: <b6e0865f-5528-c7c9-9663-1a14e660c243@sandeen.net>

--mVhTwfuPw83u07A9UOGmlqBm4jJrpLgRa
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 11/20/17 1:10 PM, Eric Sandeen wrote:
>=20
>=20
> On 11/20/17 11:54 AM, Eric Sandeen wrote:
>>
>>
>> On 11/17/17 1:54 PM, jeffm@suse.com wrote:
>>> From: Jeff Mahoney <jeffm@suse.com>
>>>
>>> Kernels prior to 2.6.36 didn't contain statfs.f_flags.  Distros with
>>> initial releases with kernels prior to this may not have updated
>>> headers with this member.
>>
>> You all are brave ;)
>>
>> Reviewed-by: Eric Sandeen <sandeen@redhat.com>
>=20
> Oops, but not tested-by!  This also needs:
>=20
> diff --git a/io/Makefile b/io/Makefile
> index 050d6bd..6725936 100644
> --- a/io/Makefile
> +++ b/io/Makefile
> @@ -110,6 +110,10 @@ ifeq ($(PKG_PLATFORM),linux)
>  CFILES +=3D fsmap.c
>  endif
> =20
> +ifeq ($(HAVE_STATFS_FLAGS),yes)
> +LCFLAGS +=3D -DHAVE_STATFS_FLAGS
> +endif
> +
>  default: depend $(LTCOMMAND)
> =20
>  include $(BUILDRULES)
>=20
>=20
> but I can add it on the way in.

Ah, right.  My build tests all succeeded because it was just skipping
f_flags.

Thanks,

-Jeff

--=20
Jeff Mahoney
SUSE Labs


--mVhTwfuPw83u07A9UOGmlqBm4jJrpLgRa--

--xHx3x4DP2FqTTWBwUiVQwfSk6GkSjVme8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJDBAEBCAAtFiEE8wzgbmZ74SnKPwtDHntLYyF55bIFAloTG1IPHGplZmZtQHN1
c2UuY29tAAoJEB57S2MheeWyyHwP/1oSRZXCto3hHuY14yyxi+vu2Eiprn75JJ/5
2gNW79CisxwrbIk9dpXYEmEc5fzuT2FVAJKd4BwsZTYODffoPCBpzQuW8+mXL4yH
hKao0hAn32YOjwempsROHp4DmjwR+Bwr6vSbWU9T1ww3FAadX3ClBX+A5N2eUo5V
zonR7KsjCCfgI2USeplXvAe9ZZ1k/MYWCk3wgQJKxX721OsvMurVoUaVBgTw0NXo
hwof+ym6hNTDQLc7Qi43m0UX8vs3qTbXCnEicSjw51ifNP9P/sJCl9TdZa1cRa6j
DzvqOl7ChSKRdPrJPBBXqpo8idvu3dPRaOUhXML0bzYbjyO2ScDFXd6bR056+Aed
gmofUWM5ftGpuhnGcISoMnQWtKj1WAgv7ITOwrac1DatR40v9HkGuJBnJFp/8SQb
6GHyRC+3moA9xAKJQCsmggH2IrZ2k1Ue6ZpWVTKS2Jggn3HWkHzHyoz0ry/SSAdW
Janr7vXt21QBp01YC3prwKYdjeKTpJDbavx2ye/f35KuQmoTIX37mfRD1LYipn+g
kVcCJF5DxNUBpKGVjOxDXKkyitpLP9dBYEi5tmUZ9jo3+6Qu+8h76kScVAjfhugT
+oe5+S4A5CM4pQLZl/K1CoDIFO6w722TFGID9WNrew7TXRMY8DNG9O7sGJ7iaZGo
Y1h7GsU3
=ex2q
-----END PGP SIGNATURE-----

--xHx3x4DP2FqTTWBwUiVQwfSk6GkSjVme8--
