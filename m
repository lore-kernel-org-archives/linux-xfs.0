Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:44642 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754128AbeFUT0s (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 21 Jun 2018 15:26:48 -0400
Subject: Re: [PATCH] mkfs: fix divide-by-zero in align_ag_geometry
References: <20180621025520.9115-1-jeffm@suse.com>
 <20180621035749.GR19934@dastard>
 <85feed9e-c347-5559-59cc-9f4e035324e5@suse.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <342f7e6a-83f6-e887-b24f-b9a628f790e2@sandeen.net>
Date: Thu, 21 Jun 2018 14:26:45 -0500
MIME-Version: 1.0
In-Reply-To: <85feed9e-c347-5559-59cc-9f4e035324e5@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="KS5Ggq9Se9fY48ute53pby8qr2WSyFabg"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jeff Mahoney <jeffm@suse.com>, Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--KS5Ggq9Se9fY48ute53pby8qr2WSyFabg
Content-Type: multipart/mixed; boundary="LZRqFchAeqWNCeUMlavREO5ONAxc6KNie";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: Jeff Mahoney <jeffm@suse.com>, Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org
Message-ID: <342f7e6a-83f6-e887-b24f-b9a628f790e2@sandeen.net>
Subject: Re: [PATCH] mkfs: fix divide-by-zero in align_ag_geometry
References: <20180621025520.9115-1-jeffm@suse.com>
 <20180621035749.GR19934@dastard>
 <85feed9e-c347-5559-59cc-9f4e035324e5@suse.com>
In-Reply-To: <85feed9e-c347-5559-59cc-9f4e035324e5@suse.com>

--LZRqFchAeqWNCeUMlavREO5ONAxc6KNie
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 6/21/18 2:15 PM, Jeff Mahoney wrote:
> On 6/20/18 11:57 PM, Dave Chinner wrote:
>> On Wed, Jun 20, 2018 at 10:55:20PM -0400, jeffm@suse.com wrote:
>>> From: Jeff Mahoney <jeffm@suse.com>
>>>
>>> Commit 051b4e37f5e (mkfs: factor AG alignment) factored out the
>>> AG alignment code into a separate function.  It got rid of
>>> redundant checks for dswidth !=3D 0 but did too good a job since now
>>> it doesn't check at all.
>>
>> Of course they got removed - we've already validated the CLI input
>> and guaranteed that cfg->dswidth can only be zero iff cfg->dsunit is
>> zero in calc_stripe_factors().
>>
>> i.e. We do input validation of CLI paramters before anything else so
>> that later users (like align_ag_geometry()) can assume the
>> parameters they are using are valid. In this case, the assumption is
>> that either both dsunit and dswidth are zero or that both are
>> non-zero and dswidth an integer multple of dsunit.
>=20
> It's not coming from the CLI parameters.  It's coming from the topology=
=2E
>  The blkid topology stuff is returning 8k for minimal i/o and 0 for
> optimal.  Without a CLI config, we have dunit=3D0 in calc_stripe_factor=
s,
> which takes it from the device.  We set cfg->dsunit=3D16 and
> cfg->dswidth=3D0, and then head down to align_ag_geometry.
>=20
> The topology on this system looks like:
>=20
> ft =3D {dsunit =3D 16, dswidth =3D 0, rtswidth =3D 0, lsectorsize =3D 5=
12,
> psectorsize =3D 512}
>=20
> That matches with a few of the dm targets I see reported on this system=
=2E
>=20
> Since minimal io size isn't sector size, we don't clear it.  Talking
> with Eric, we should probably just extent that check in
> blkid_get_topology to cover that case since it's not like we can just
> reject what blkid gives us.
>=20
>>> When we hit the check to see if agsize
>>> is a multiple of stripe width: (cfg->agsize % cfg->dswidth), we crash=

>>> on a divide by zero.
>>
>> What CLI config did you use to hit this? I'd like to reproduce it so
>> I can see where calc_stripe_factors() is going wrong....
>=20
> It was just "mkfs.xfs <path-to-mpath-device>"

yeah, so in blkid_get_topology we have:

        /*
         * If the reported values are the same as the physical sector siz=
e
         * do not bother to report anything.  It will only cause warnings=

         * if people specify larger stripe units or widths manually.
         */
        if (*sunit =3D=3D *psectorsize || *swidth =3D=3D *psectorsize) {
                *sunit =3D 0;
                *swidth =3D 0;
        }

as a sanity check.  We should probably extend that (or add a similar test=
)
which sets both to zero if either is zero, for the same reason as the CLI=

validation does it.  Comments should explain why....

        /*
         * Ensure that if either sunit or stripe width is zero, the other=

         * is as well.  Having only one set is not valid stripe geometry.=

         */
        if (*sunit =3D=3D 0 || *swidth =3D=3D 0) {
                *sunit =3D 0;
                *swidth =3D 0;
        }

FWIW if I set=20

        *sunit =3D 8192;
        *swidth =3D 0;

manually in blkid_get_topology I do get the same floating point exception=
;
if that's what we get from libblkid for some weird device, we'd go boom.

-Eric


--LZRqFchAeqWNCeUMlavREO5ONAxc6KNie--

--KS5Ggq9Se9fY48ute53pby8qr2WSyFabg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAlsr+/YACgkQIK4WkuE9
3uBTvg/9HXnkBfCduDpTNQ3F22bOasrEdOfafy/EkERksCPl8sRS/T17OeZSCk5V
a9+D/lL7SUYO2NfdTkASQQ5zc2UcB0XNG5LIH/DPWR7qH9IHhmzakwWCd1aelVGe
BNd17n/fJuFB0ACNdTp9/fbP2jikix5dQK5kP1G5Y6pd8ZVEFaRe5EJ5hi7HnI+8
w9EZhkSBRrdSTMiyOaL3N1yPI399C2433kr7qe8uR8WFo9YMJedE2g4kGPF7fc3D
g1jX7czSTj1EcBH/cnOWF/MXu8qA/HiNtdU7+MP/IBEj/A2aytZwE6/if2reO0c4
hHKj3Dt7tfVGmOkeUwtNF6kcQSMG9DJ/geHb/KEL/3ioPa5b0OEgSPoZxnbAF6Ip
py5ommkzLPEcYQhWLbu2U5Q3HziRl93PzOxMHbhn0Ju26UWwMr5KMwmyAVcR/X2R
yS2KJ1zJPSfz69f1ZTwfEQ5GGJ4wzeESiC44CnO0KgJCk9G4HR1S37BIlgODoz4i
LQhjZnKTqwormp7ogewiPyMlVoTqss90y4bVb+YyYwO/xYaq8AMNxUxLH4dTS2ed
mBVcd6BPlxW+PWttVQ44b738C8x7kxsgmoevr6vzYJOJG/oJZOazbt6AmBWvsrW2
xgjEuv1ZHaqr+1W/wTrCE6lvDUhOIZSdYmhDpyHFJUX9csP/RgY=
=lUHK
-----END PGP SIGNATURE-----

--KS5Ggq9Se9fY48ute53pby8qr2WSyFabg--
