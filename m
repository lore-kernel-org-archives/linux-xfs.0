Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42637 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753972AbeFUTPl (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 21 Jun 2018 15:15:41 -0400
Subject: Re: [PATCH] mkfs: fix divide-by-zero in align_ag_geometry
References: <20180621025520.9115-1-jeffm@suse.com>
 <20180621035749.GR19934@dastard>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <85feed9e-c347-5559-59cc-9f4e035324e5@suse.com>
Date: Thu, 21 Jun 2018 15:15:37 -0400
MIME-Version: 1.0
In-Reply-To: <20180621035749.GR19934@dastard>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="NWZX1sQNPeYvVLrhGJiDwFp6KdEaNpKCh"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, Eric Sandeen <sandeen@sandeen.net>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--NWZX1sQNPeYvVLrhGJiDwFp6KdEaNpKCh
Content-Type: multipart/mixed; boundary="EieRYKqKZhCVWESapPV5yCSZyjMAb7Bqd";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, Eric Sandeen <sandeen@sandeen.net>
Message-ID: <85feed9e-c347-5559-59cc-9f4e035324e5@suse.com>
Subject: Re: [PATCH] mkfs: fix divide-by-zero in align_ag_geometry
References: <20180621025520.9115-1-jeffm@suse.com>
 <20180621035749.GR19934@dastard>
In-Reply-To: <20180621035749.GR19934@dastard>

--EieRYKqKZhCVWESapPV5yCSZyjMAb7Bqd
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 6/20/18 11:57 PM, Dave Chinner wrote:
> On Wed, Jun 20, 2018 at 10:55:20PM -0400, jeffm@suse.com wrote:
>> From: Jeff Mahoney <jeffm@suse.com>
>>
>> Commit 051b4e37f5e (mkfs: factor AG alignment) factored out the
>> AG alignment code into a separate function.  It got rid of
>> redundant checks for dswidth !=3D 0 but did too good a job since now
>> it doesn't check at all.
>=20
> Of course they got removed - we've already validated the CLI input
> and guaranteed that cfg->dswidth can only be zero iff cfg->dsunit is
> zero in calc_stripe_factors().
>=20
> i.e. We do input validation of CLI paramters before anything else so
> that later users (like align_ag_geometry()) can assume the
> parameters they are using are valid. In this case, the assumption is
> that either both dsunit and dswidth are zero or that both are
> non-zero and dswidth an integer multple of dsunit.

It's not coming from the CLI parameters.  It's coming from the topology.
 The blkid topology stuff is returning 8k for minimal i/o and 0 for
optimal.  Without a CLI config, we have dunit=3D0 in calc_stripe_factors,=

which takes it from the device.  We set cfg->dsunit=3D16 and
cfg->dswidth=3D0, and then head down to align_ag_geometry.

The topology on this system looks like:

ft =3D {dsunit =3D 16, dswidth =3D 0, rtswidth =3D 0, lsectorsize =3D 512=
,
psectorsize =3D 512}

That matches with a few of the dm targets I see reported on this system.

Since minimal io size isn't sector size, we don't clear it.  Talking
with Eric, we should probably just extent that check in
blkid_get_topology to cover that case since it's not like we can just
reject what blkid gives us.

>> When we hit the check to see if agsize
>> is a multiple of stripe width: (cfg->agsize % cfg->dswidth), we crash
>> on a divide by zero.
>=20
> What CLI config did you use to hit this? I'd like to reproduce it so
> I can see where calc_stripe_factors() is going wrong....

It was just "mkfs.xfs <path-to-mpath-device>"

-Jeff

--=20
Jeff Mahoney
SUSE Labs


--EieRYKqKZhCVWESapPV5yCSZyjMAb7Bqd--

--NWZX1sQNPeYvVLrhGJiDwFp6KdEaNpKCh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE8wzgbmZ74SnKPwtDHntLYyF55bIFAlsr+VkACgkQHntLYyF5
5bLoHQ//SiZrPOKtB8pabl3tU4f/lDotRBoiMBIf0d9P//+iZ/uRbyhk2jilc5iF
cppn/pt1qCYm3i/JBoAW3JoEcF79DbJYk+oVH+1kqPV+tK/DhwzuO2ObCDm/Lusx
Jkeot/9FDotiLj+L7MxtrFc5+Tj8YFE48a5OUbttDtLNvy2jJqm2JTW6TLvN/r5+
3pfAekkRitSn55YT0h5x84FLFArd3Pzr09CCopBjgnUgOuypAwItGLLWgibiN7Ek
YJfFgivdX7MZ5B1NPwkP0GQVcsVDQhK7tWTOz8vuQHNIgOP7nQGIII4Aw8ejx7G8
2wz6ljlE9gqt9BLtlvE87lP+Pj+gscQhcGXJJZIQ6ZVXMLD0pdMpgQgC8autkf14
LSZ4ms/my5uon+5ED00CHaLdsch6CdYgN8dbfq5tFgGku5qa2J4wo0Q2XDtj76Ts
DrzjmaV3SfVLrGQWrf3q6rOPgK4BeZL9x9bQVU9/uTRBDBGrjnZgBit85gNeY8Ke
iIZYsXWVGrI1gp8WHnk4PuCFU4gQnbLt9bamL37B+/nP6L7+q94j+hJ2OWizAMT+
OmXFIh8itpRDpmQBCHOzZw2whftJLtal0a1915olSRKkyevxplhxbYKWcle4xKCF
kahkMETs163+SKgc4BJJ9DpmrAREmKkUPANFp1ou5p/ZMCv33Fs=
=PkRK
-----END PGP SIGNATURE-----

--NWZX1sQNPeYvVLrhGJiDwFp6KdEaNpKCh--
