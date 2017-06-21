Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48076 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751893AbdFUVuE (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 21 Jun 2017 17:50:04 -0400
Subject: Re: [PATCH] fsr: fix uninitialized fs usage after timeout
References: <b4921f6d-01c7-09eb-641f-47f1be998e61@suse.com>
 <118e7672-680a-689d-6b74-7169a38b3d89@sandeen.net>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <07b82f1b-040f-b472-12f8-fa9eeaf9508f@suse.com>
Date: Wed, 21 Jun 2017 17:49:59 -0400
MIME-Version: 1.0
In-Reply-To: <118e7672-680a-689d-6b74-7169a38b3d89@sandeen.net>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="d26wQV4aq6FptPngna8um5e3cCpWcWuGL"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>, linux-xfs <linux-xfs@vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--d26wQV4aq6FptPngna8um5e3cCpWcWuGL
Content-Type: multipart/mixed; boundary="6WVJtPVJq4uuv7Hr5AFVLfrFvTOIKjSP8";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: Eric Sandeen <sandeen@sandeen.net>, linux-xfs <linux-xfs@vger.kernel.org>
Message-ID: <07b82f1b-040f-b472-12f8-fa9eeaf9508f@suse.com>
Subject: Re: [PATCH] fsr: fix uninitialized fs usage after timeout
References: <b4921f6d-01c7-09eb-641f-47f1be998e61@suse.com>
 <118e7672-680a-689d-6b74-7169a38b3d89@sandeen.net>
In-Reply-To: <118e7672-680a-689d-6b74-7169a38b3d89@sandeen.net>

--6WVJtPVJq4uuv7Hr5AFVLfrFvTOIKjSP8
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 6/21/17 3:28 PM, Eric Sandeen wrote:
> On 6/2/17 1:20 PM, Jeff Mahoney wrote:
>> In the main loop of fsrallfs, we exit when we've hit the timeout but
>> we increment fs before we get there.  If we're operating on the last
>> file system in the array, we'll hit an uninitialized fsdesc and
>> crash in fsrall_cleanup.
>=20
> Ugh, really - nobody should be using the defrag-the-world mode,
> but we ship it, so ...
>=20
>> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
>> ---
>>  fsr/xfs_fsr.c | 4 +---
>>  1 file changed, 1 insertion(+), 3 deletions(-)
>>
>> diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
>> index 517b75f0..e695c243 100644
>> --- a/fsr/xfs_fsr.c
>> +++ b/fsr/xfs_fsr.c
>> @@ -598,7 +598,7 @@ fsrallfs(char *mtab, int howlong, char *leftofffil=
e)
>>  	signal(SIGTERM, aborter);
>>
>>  	/* reorg for 'howlong' -- checked in 'fsrfs' */
>> -	while (endtime > time(0)) {
>> +	for (; endtime > time(0); fs->npass++, fs++) {
>>  		pid_t pid;
>>  		if (fs =3D=3D fsend)
>>  			fs =3D fsbase;
>> @@ -629,8 +629,6 @@ fsrallfs(char *mtab, int howlong, char *leftofffil=
e)
>>  			break;
>>  		}
>>  		startino =3D 0;  /* reset after the first time through */
>> -		fs->npass++;
>> -		fs++;
>>  	}
>>  	fsrall_cleanup(endtime <=3D time(0));
>>  }
>=20
> I hate to be that PITA maintainer who only wants to do it his way ;) bu=
t
> would this be any tidier?
>=20
> I'm just not that big a fan of "for(; ....)" loops.

Sure, this'll work just as well.

-Jeff

> diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
> index 517b75f..3a5f683 100644
> --- a/fsr/xfs_fsr.c
> +++ b/fsr/xfs_fsr.c
> @@ -600,12 +600,6 @@ fsrallfs(char *mtab, int howlong, char *leftofffil=
e)
>  	/* reorg for 'howlong' -- checked in 'fsrfs' */
>  	while (endtime > time(0)) {
>  		pid_t pid;
> -		if (fs =3D=3D fsend)
> -			fs =3D fsbase;
> -		if (fs->npass =3D=3D npasses) {
> -			fsrprintf(_("Completed all %d passes\n"), npasses);
> -			break;
> -		}
>  		if (npasses > 1 && !fs->npass)
>  			Mflag =3D 1;
>  		else
> @@ -631,6 +625,12 @@ fsrallfs(char *mtab, int howlong, char *leftofffil=
e)
>  		startino =3D 0;  /* reset after the first time through */
>  		fs->npass++;
>  		fs++;
> +		if (fs =3D=3D fsend)
> +			fs =3D fsbase;
> +		if (fs->npass =3D=3D npasses) {
> +			fsrprintf(_("Completed all %d passes\n"), npasses);
> +			break;
> +		}
>  	}
>  	fsrall_cleanup(endtime <=3D time(0));
>  }
>=20
>=20
>=20


--=20
Jeff Mahoney
SUSE Labs


--6WVJtPVJq4uuv7Hr5AFVLfrFvTOIKjSP8--

--d26wQV4aq6FptPngna8um5e3cCpWcWuGL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2

iQIVAwUBWUrqCB57S2MheeWyAQgPHBAAqZje0XuLxl9HoBHqlLXmsjiKTZmLmQNY
HpTyV4ZKgHaVLgBE0XR+oojU0U5WNKQ8XYB05HkRDpEpArGE54xQ0+FRHgxnDb8t
NMYH591mCJieDbblpIL4xdz7yYHG/L3nL2wpIPiqg2o91H3kpVWHLZhI/4WnBfPI
x9pMZ1Hhqrj1xB10FLHfezW/+MOPL2ii2PD55BkI4auSVe2xqzWuCxZhzCuapNQS
DHcRzUawno3aT7nT/NcJ1AitPYpVEtyB5N1kfg0rb0KUn+R/ONL+31ReQzKpITRu
cAeXqc1kU/rx/mJD9xHFi2LyHuJz3/Abm3YnQAMpWjIPRIVGFoIzdTzT/hlfwANh
pN8GqjlAuidjMA5eGPDp+V5/SXEeZrmO7U1AkBt7rPcH7P/QB7x0aDdbV2e4XxI6
h+5H0uKq182YzOCzCG+9IER43xRaahEeGIwtbRRp2MQpuKyupW9T/hll2CMGhsdv
OtZ4NE/7EW1gHJnE+YE0iDGkwMXzIzGnTwmGNlos3VuaO3yduRzyrDqXIK7WzKwq
LGoRjBRaXHif8QsRc6PBk/vUDG+moPNa3SyedO9EidHHAEsy8MR2tbuKbJ3ttB74
ypNSdqgdpdxjdYJUccpMDGwaIF4vOBtGPIAn3l6kww9OHmoW5r3wK6NDB4XFg/+N
E5wnjDRdwhA=
=vmLR
-----END PGP SIGNATURE-----

--d26wQV4aq6FptPngna8um5e3cCpWcWuGL--
