Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46390 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727721AbeGSVye (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 19 Jul 2018 17:54:34 -0400
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
Message-ID: <4f4fdc17-918c-6293-21e1-97cc7a5fdd6b@suse.com>
Date: Thu, 19 Jul 2018 17:09:36 -0400
MIME-Version: 1.0
In-Reply-To: <c78886ab-c334-a96f-795e-ea1985a1a8f3@sandeen.net>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="B3WjqmbuWGzRvM4R7DWbtQCZzVeY5VDks"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>, Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--B3WjqmbuWGzRvM4R7DWbtQCZzVeY5VDks
Content-Type: multipart/mixed; boundary="MCMtHBz7qr6MwjcLC0PEyIUpn4Oxths8E";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: Eric Sandeen <sandeen@sandeen.net>, Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org
Message-ID: <4f4fdc17-918c-6293-21e1-97cc7a5fdd6b@suse.com>
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

--MCMtHBz7qr6MwjcLC0PEyIUpn4Oxths8E
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
>=20
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

Getting back to this after some time off.  I agree we should warn, but
if we warn, we need to do it when we have more context.  Otherwise we'll
warn even when the user specifies stripe parameters, which just looks
sloppy.  I have an updated patch that puts it in calc_stripe_factors and
only issues the warning if we will consume those values.

-Jeff

--=20
Jeff Mahoney
SUSE Labs


--MCMtHBz7qr6MwjcLC0PEyIUpn4Oxths8E--

--B3WjqmbuWGzRvM4R7DWbtQCZzVeY5VDks
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE8wzgbmZ74SnKPwtDHntLYyF55bIFAltQ/hEACgkQHntLYyF5
5bJp4hAAnDPWvt4Cfoub1oaxTdkZ7d2YlGij6jzHsAolBZsK5bOdTysebK5DcqNt
UMnJFFlO/jSz00mFQbGBAieTm5IBpn5OxoOvNuBtKdyKD1V57rbvwvlbH1bY3HIo
r1xl5bv662L7DJj8010O4O/acgGBJQIVRwKYvEoukEE7NRgvFPkFzJG7KgAFkwyG
w8PYymkyyaDzwBtIZY1mAzTIqGmo3t84PlIvU5JuUGCWMGHJQnIpuhp51613AygW
wDQmCKQt5epzj1nv5cuZznuzSy3R4VlF3h+kq3m5SExrg0CsRNUZ6AOwZV56232P
VQM9Ojwu3OcizQxCWTiaZui+0Z0W82E7wKzFOwxMq3Xqdem6pBhAaqWdVoJr6E/1
oI6Lf4l1ynaSkealyrypUsMgn76T/VOBlK9bTa+NhDzEnJ2lIwAR91fpZDX6Cyww
fRslQNmV7TbgNom95P/SFCUE1HNaxSdnqv72Ycqw1X0RahZj/XN7Ap2EhJDCwXxl
70DkAWRwaw9BXEsENRBAkKEoPg3vnIkM4B+qlxZWECekN5DDA4XsoTquoOI7aBLe
ct/uZKhtBbgWL6VHyVya0WeI9BgXzroxyqt1AJfTDQ/O8tduZ5LnL+DQEhS9Av+5
6zRPjYu4XNDUHRBEZhJ/RFLTOnNlEHyaFcRi74STD0f1kwPjNBk=
=bmRL
-----END PGP SIGNATURE-----

--B3WjqmbuWGzRvM4R7DWbtQCZzVeY5VDks--
