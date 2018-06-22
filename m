Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48506 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934101AbeFVBkW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 21 Jun 2018 21:40:22 -0400
Subject: Re: [PATCH] mkfs: fix divide-by-zero in align_ag_geometry
References: <20180621025520.9115-1-jeffm@suse.com>
 <20180621035749.GR19934@dastard>
 <85feed9e-c347-5559-59cc-9f4e035324e5@suse.com>
 <342f7e6a-83f6-e887-b24f-b9a628f790e2@sandeen.net>
 <20180621194936.GS19934@dastard>
 <919ce2d0-b560-3fe6-f16c-503f57e3157c@suse.com>
 <20180621223644.GW19934@dastard>
 <1c60e3f5-3d2f-d739-cc1d-e23919f6c585@sandeen.net>
 <c78886ab-c334-a96f-795e-ea1985a1a8f3@sandeen.net>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <a7e3aaf1-09f8-00bb-f4cb-a4ea48d50935@suse.com>
Date: Thu, 21 Jun 2018 21:40:17 -0400
MIME-Version: 1.0
In-Reply-To: <c78886ab-c334-a96f-795e-ea1985a1a8f3@sandeen.net>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="vCeDW5eqCzGjjD1HE9zKroPi28morARLg"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>, Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--vCeDW5eqCzGjjD1HE9zKroPi28morARLg
Content-Type: multipart/mixed; boundary="IqitgNAjhST0N6rsamBVK6Naz10FQvQQn";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: Eric Sandeen <sandeen@sandeen.net>, Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org
Message-ID: <a7e3aaf1-09f8-00bb-f4cb-a4ea48d50935@suse.com>
Subject: Re: [PATCH] mkfs: fix divide-by-zero in align_ag_geometry
References: <20180621025520.9115-1-jeffm@suse.com>
 <20180621035749.GR19934@dastard>
 <85feed9e-c347-5559-59cc-9f4e035324e5@suse.com>
 <342f7e6a-83f6-e887-b24f-b9a628f790e2@sandeen.net>
 <20180621194936.GS19934@dastard>
 <919ce2d0-b560-3fe6-f16c-503f57e3157c@suse.com>
 <20180621223644.GW19934@dastard>
 <1c60e3f5-3d2f-d739-cc1d-e23919f6c585@sandeen.net>
 <c78886ab-c334-a96f-795e-ea1985a1a8f3@sandeen.net>
In-Reply-To: <c78886ab-c334-a96f-795e-ea1985a1a8f3@sandeen.net>

--IqitgNAjhST0N6rsamBVK6Naz10FQvQQn
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 6/21/18 9:34 PM, Eric Sandeen wrote:
> On 6/21/18 6:16 PM, Eric Sandeen wrote:
>>> Ah, so it came from the hardware? In that case, we probably
>>> shouldn't zero sunit when blkid reports this whacky case. i.e. I
>>> think we should set swidth =3D sunit so that we retain allocation
>>> alignment to the minimum IO size the device specified.
>> Hrmph.
>>
>> yeah, I'd really like to see=20
>>
>> # blockdev --getiomin --getioopt --getss --getpbsz
>>
>> for all the devices in the stack, I guess...
>=20
> Ok, so Jeff shared the lsblk output with me; the underlying
> device and the mpath device are both:
>=20
> MIN-IO OPT-IO PHY-SEC LOG-SEC
> 8192      0     512     512
>=20
> so logical/physical 512, with minimum io 8192 and optimal io 0.
> On further inspection Jeff says this may be because an optimal
> size is reported as greater than the maximum size, so we get 0
> due to the inconsistency.

For this device, the user reported the following sg_vpd -a output:
  Optimal transfer length granularity: 16 blocks
   -- This is what gets exported as minimum_io_size
  Maximum transfer length: 32768 blocks
  Optimal transfer length: 65535 blocks

The SCSI layer checks to see if the optimal blocks value is larger than
what the device reports as its max and whether it's larger than 65535 or
smaller than page size, and refuses to set the optimal io size so it
defaults to 0.  Given the values above, that has to be what's happening
here.

> Ok, well, I guess I see your point that we should probably set
> sunit=3Dswidth=3D8192 here.  I was thinking that conflicted with
> how we process it on the commandline but no, it doesn't; if you're
> going to manually specify you can't set one to 0 and not the other,
> but we have to make the best of what the hardware tells us.
>=20
> So we could do:
>=20
>         /*
>          * Some odd hardware sets minimum IO but not optimal; assume
>          * minimal is the smallest preferred IO size, and set optimal
> 	 * to the same value, i.e. a stripe of 1 disk.
>          */
>         if (*sunit && *swidth =3D=3D 0)
>                 *swidth =3D *sunit;
>=20
> But it's clearly buggy hardware.  How are we to know which values=20
> are accurate and which are not?  It still may be better to just set
> to no stripe geometry if we've gotten nonsense from libblockdev,
> if the device wants better performance it needs to have rational
> firmware... trying to 2nd guess bad values is just a crapshoot.
> I guess we could issue a warning ...

I think the sane defaults + warning is the way to go here too.

-Jeff


--=20
Jeff Mahoney
SUSE Labs


--IqitgNAjhST0N6rsamBVK6Naz10FQvQQn--

--vCeDW5eqCzGjjD1HE9zKroPi28morARLg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE8wzgbmZ74SnKPwtDHntLYyF55bIFAlssU4EACgkQHntLYyF5
5bK09w//TiWfnjxpZeBZgrp8PZVfSPDzLnUdoAuwkU/cF8G9DAV4hAkMoBfl39Eg
+kzNMXd5CTICwmg2GcpurJwuOYX1s3NLMHr84U+lQdvUYNxFCV5N1GHF0pov212Q
R8umoDhohrzRqIGnaKeWkjlweOwne8Zfb5vRiwtWuAR2JUUlWp34GswX+03bHL+W
+8OrrdlWfv53FOXU2bs1JblmId8IIIl3yRtoPDjkp9zSDLnke/iz2F+T7DGITdr0
AG3l/drmDQzr9s2h8nuBmIszps4ZK27YnluCdxaWvvTH4YguacNhOtLiRHnMimXv
2bGW2Ru66aNRpN3vNnUUHV/9lGQBI/DvRV5mHKe7YiJgfjJ8RJjA0fGgETSf/8+3
UmhOYuLR1KVlISfmKmnrD3KmqsO4IrEyyhaySyM8c3ytwJlqaNC55nNeqDI2qVtl
jrZdSNkZ9p9i9PfRXPhDzb/gyp/OC/nLvszyby8zEXTTGld55PAM1vMtphTQV1MD
jFfhAaCz6ehftV1d/kGza1OA8LnL3ZgDLRhpdaOeUX1A6KgNmSJqJUNwaFQ5dvIP
VCxiN9RSdUgPEvKmZ10/WD1uY2yWjYRoimFzQXoarG6XD42+YZdkrShPkQZv417F
iaw1sGbI4DvxoNGjyFiysmQnWNdiVQLFEiTDmMlOgv5OpRRZMVI=
=3hkq
-----END PGP SIGNATURE-----

--vCeDW5eqCzGjjD1HE9zKroPi28morARLg--
