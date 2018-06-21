Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57949 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933521AbeFUVcC (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 21 Jun 2018 17:32:02 -0400
Subject: Re: [PATCH] mkfs: fix divide-by-zero in align_ag_geometry
References: <20180621025520.9115-1-jeffm@suse.com>
 <20180621035749.GR19934@dastard>
 <85feed9e-c347-5559-59cc-9f4e035324e5@suse.com>
 <342f7e6a-83f6-e887-b24f-b9a628f790e2@sandeen.net>
 <20180621194936.GS19934@dastard>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <919ce2d0-b560-3fe6-f16c-503f57e3157c@suse.com>
Date: Thu, 21 Jun 2018 17:31:58 -0400
MIME-Version: 1.0
In-Reply-To: <20180621194936.GS19934@dastard>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="p0XDbWFVOloch1Gj6nTcrkunPFgNAmTAe"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>, Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--p0XDbWFVOloch1Gj6nTcrkunPFgNAmTAe
Content-Type: multipart/mixed; boundary="DC43YZvhsHhDuGXfg2gcQzu9TRWYgl4q6";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: Dave Chinner <david@fromorbit.com>, Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org
Message-ID: <919ce2d0-b560-3fe6-f16c-503f57e3157c@suse.com>
Subject: Re: [PATCH] mkfs: fix divide-by-zero in align_ag_geometry
References: <20180621025520.9115-1-jeffm@suse.com>
 <20180621035749.GR19934@dastard>
 <85feed9e-c347-5559-59cc-9f4e035324e5@suse.com>
 <342f7e6a-83f6-e887-b24f-b9a628f790e2@sandeen.net>
 <20180621194936.GS19934@dastard>
In-Reply-To: <20180621194936.GS19934@dastard>

--DC43YZvhsHhDuGXfg2gcQzu9TRWYgl4q6
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 6/21/18 3:49 PM, Dave Chinner wrote:
> On Thu, Jun 21, 2018 at 02:26:45PM -0500, Eric Sandeen wrote:
>> On 6/21/18 2:15 PM, Jeff Mahoney wrote:
>>> On 6/20/18 11:57 PM, Dave Chinner wrote:
>>>> On Wed, Jun 20, 2018 at 10:55:20PM -0400, jeffm@suse.com wrote:
>>>>> From: Jeff Mahoney <jeffm@suse.com>
>>>>>
>>>>> Commit 051b4e37f5e (mkfs: factor AG alignment) factored out the
>>>>> AG alignment code into a separate function.  It got rid of
>>>>> redundant checks for dswidth !=3D 0 but did too good a job since no=
w
>>>>> it doesn't check at all.
>>>>
>>>> Of course they got removed - we've already validated the CLI input
>>>> and guaranteed that cfg->dswidth can only be zero iff cfg->dsunit is=

>>>> zero in calc_stripe_factors().
>>>>
>>>> i.e. We do input validation of CLI paramters before anything else so=

>>>> that later users (like align_ag_geometry()) can assume the
>>>> parameters they are using are valid. In this case, the assumption is=

>>>> that either both dsunit and dswidth are zero or that both are
>>>> non-zero and dswidth an integer multple of dsunit.
>>>
>>> It's not coming from the CLI parameters.  It's coming from the topolo=
gy.
>>>  The blkid topology stuff is returning 8k for minimal i/o and 0 for
>>> optimal.  Without a CLI config, we have dunit=3D0 in calc_stripe_fact=
ors,
>>> which takes it from the device.  We set cfg->dsunit=3D16 and
>>> cfg->dswidth=3D0, and then head down to align_ag_geometry.
>>>
>>> The topology on this system looks like:
>>>
>>> ft =3D {dsunit =3D 16, dswidth =3D 0, rtswidth =3D 0, lsectorsize =3D=
 512,
>>>
>>> psectorsize =3D 512}
>>> That matches with a few of the dm targets I see reported on this syst=
em.
>=20
> Exactly what kind of dm device does that - we've never had anyone
> report this before? Also, if it's a dm device, shouldn't it
> also be fixed to output a sane set of IO characteristics in /sys?

It's multipath, so it just follows the stacking rules.  The underlying
SCSI devices report the same numbers.  The optimal io number is
documented as being optional, at least for the kernel, so we need to
handle it being 0 anyway.  I'm not sure if the device specifying a
minimum i/o size larger than the sector size and also not specifying an
optimal i/o size is valid SCSI.  I'll ask for more information since now
I'm also curious.

-Jeff


--=20
Jeff Mahoney
SUSE Labs


--DC43YZvhsHhDuGXfg2gcQzu9TRWYgl4q6--

--p0XDbWFVOloch1Gj6nTcrkunPFgNAmTAe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE8wzgbmZ74SnKPwtDHntLYyF55bIFAlssGU4ACgkQHntLYyF5
5bLMXQ/+PHrf/3oFnV9PsPTZCdXhzyNKm1jL2gRAzWeRQbfJ0k1VQfNXbH2eLan4
087as3TgnJNCtGpAT3s136AL/WrWvUztVQ7cQIi3EfBxZzSQKW0ClZCiw0xPkIo3
RxHU7rs5i8aW8r1+fwY4Qvv2H7O8OmQdoa6YbF5docguuNyMbTnyOeHwqNQXUwsT
SUytMZKaGqDLY66aJldtJphQqdbMF1aviYYQP+zuEw6YpnilG016V5DmHBeJJyP2
RtwCH8f0Od9p4HLasJfQovDE2B+ytbbd1lwHKAmgxU/0qVy77wmovlb3p3WhJpQm
XlU7/InoLG4dcSllVcINTxIrIpeuBv5KaxDaqU8h77vaB39AB5sTujVgFaWQenhU
xWRjSpK4n3oM+KeD6gn8XpH+txacHKYlp1FbrGgHmxSr7w7fHcyb6uG6xv2mbkRs
X4VNYknwPd2gJoyWkqTocw5O9/m0NiRCAtVVPyu8pqzgZC4aZBazNnCyZf9zP/4E
FGwd5cYI4LcyFaqYd/sJVf0XSv7r3V00NImzhnnsOLZscFCQurHqGr2KyJfiPwHi
nZcFMODHv0lWvosW6IVzN2Unv4GS3SSD82I5Y9YxXhKS95JThYMfU12Eitm3tCWf
iD7aBoFRWl9QNGYSZyijkmw7SHviciOrM/4+15MO0tM3umnMPeY=
=XTXP
-----END PGP SIGNATURE-----

--p0XDbWFVOloch1Gj6nTcrkunPFgNAmTAe--
