Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:42098 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752767AbeBEPtn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 5 Feb 2018 10:49:43 -0500
Subject: Re: xfs_scrub: call for testing
References: <e0ada9ef-aafb-5179-2729-447d67bd6265@sandeen.net>
 <20180205161049.7e22aa09@harpe.intellique.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <61166e99-1195-1192-d229-f7e01f1d52da@sandeen.net>
Date: Mon, 5 Feb 2018 09:49:41 -0600
MIME-Version: 1.0
In-Reply-To: <20180205161049.7e22aa09@harpe.intellique.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="odiiDyHbiqRQxTSmZ6Fhq31c342Iuo2if"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Emmanuel Florac <eflorac@intellique.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--odiiDyHbiqRQxTSmZ6Fhq31c342Iuo2if
Content-Type: multipart/mixed; boundary="Y8MU5lWOgLFEnCwDlZilwGnH8Cgp8f7oJ";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: Emmanuel Florac <eflorac@intellique.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>
Message-ID: <61166e99-1195-1192-d229-f7e01f1d52da@sandeen.net>
Subject: Re: xfs_scrub: call for testing
References: <e0ada9ef-aafb-5179-2729-447d67bd6265@sandeen.net>
 <20180205161049.7e22aa09@harpe.intellique.com>
In-Reply-To: <20180205161049.7e22aa09@harpe.intellique.com>

--Y8MU5lWOgLFEnCwDlZilwGnH8Cgp8f7oJ
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 2/5/18 9:10 AM, Emmanuel Florac wrote:
> Le Fri, 2 Feb 2018 15:36:33 -0600
> Eric Sandeen <sandeen@sandeen.net> =C3=A9crivait:
>=20
>> I'd really value feedback on scrub as it stand at this point -
>> Is the documentation clear?  Is the output correct?  Do the
>> tool's arguments make sense?  Does it segfault?  Does it
>> find real errors?  Does it crash your kernel? Does it
>> eat your data?
>=20
> Wouldn't it be better to remove the parts about repairing the
> filesystem in the documentation? The man page states that it *can't*
> repair the filesystem, but nonetheless explains under which
> circumstances it *won't* be able to repair (in some theoretical future
> version with repair capabilities, I suppose). Ditto with the -n and -y
> option, I suppose they're both basically noop at the moment? That's
> quite unclear what it actually does.

I'll take another look at the manpage.  The userspace tool today /can/
do some degree of optimization or repair if the kernel supports it,
so I was reluctant to suggest removing all such language.

So, "-n" is not a no-op, it's a check-only ("scrub") pass vs. the default=

no-argument action of "optimizing," or the extra -y action which would re=
pair.
If that's not all clear, I'd appreciate suggestions to clean it up.

> Regarding FITRIM for flash storage, I think most people refers to it as=

> "TRIM", not the ioctl name FITRIM. Using "TRIM" would probably be more
> understandable IMO.

Fair point, thanks.

> Because I'm such a funny boy, I just wanted to see what happens when
> running xfs_scrub on an unsupported kernel. On both a 4.14.x and a
> 3.18.x it seems about right:
>=20
> root@bareos16:~# ./xfs_scrub /mnt/raid/
> EXPERIMENTAL xfs_scrub program in use! Use at your own risk!
> Error: /mnt/raid: Kernel metadata scrubbing facility is not available.
> Info: /mnt/raid: Scrub aborted after phase 1.
> /mnt/raid: 2 errors found.

Yup.  TBH I'm not a fan of listing "your kernel can't scrub" as
"errors found."  I think we should find a way around that.

> I don't have any system running 4.15 to test its effects, but I'll do
> as soon as possible.

Cool, thanks.

-Eric


--Y8MU5lWOgLFEnCwDlZilwGnH8Cgp8f7oJ--

--odiiDyHbiqRQxTSmZ6Fhq31c342Iuo2if
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAlp4fRUACgkQIK4WkuE9
3uAnpA//Z7clisdWpDrWOFohvNmUzpCVfpBc5kwSPccBYk8/d3v1v4x1Ep03nJW6
0/AwKTX4n/ZAN61PoHoK1eP1vkRpxaazGBy1QrOdPpqkVlrKFUx2vC+1pbFt+12S
DtIvrWbbG94UD2Kp+DsFiBDdQmiP/MUWo1k3yyoS4ODkPqP2rzSC1Zbh9dmoul6o
pwFJ58MlbezWfSr0W062YsO1LCll61ymnvecTyLQUPn+3cKOyDtPdoYcyY1eN7NS
6zd8eJAFEvBdK32jXIVtT3Imz3UeURdaRtJW8vHEGOvrn7FfWy7R9lAmLbEgDRmX
BIhUeOebFYc0G/+kQRBF7bSnaKg1Evdo/2CQ6jmmTx1orDJ+trHJtzykx8Gf3l50
UX+Qxdjf2vHgI04vpW49nrB//yqrgej1EU38CZihpvihtapP6wUfBXmsQ/tGkN78
4IU4nWLTj1b/iymb0oENMLkUmVH6zy1AtbUnbQiSbUKuOQa2FNuzByic5VxNlXbT
EzI1yyrksb5WJcye2K1wXkcLJNm1W0tUO2erjbUlHxnsYWX+4hGCDArGlfmNoHD/
81ZB/3T7UFnnU+VUDzz8yKV9FR2CjFwXrBoaMmcxMeTclYnOPBXaR9urNInRYgHE
kgtHqZLKkSxkYpo2IJ9HqzDbwSu6LILBsEniDOMqDkcv9/NUWCQ=
=5B8I
-----END PGP SIGNATURE-----

--odiiDyHbiqRQxTSmZ6Fhq31c342Iuo2if--
