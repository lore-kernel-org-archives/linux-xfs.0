Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35576 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388097AbeGTS5y (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 20 Jul 2018 14:57:54 -0400
Subject: Re: [PATCH] mkfs: avoid divide-by-zero when hardware reports optimal
 i/o size as 0
References: <6f62dbc6-f516-e8b5-1f08-6be227a61219@suse.com>
 <20180720155529.qw7nthesfu6xu7ie@odin.usersys.redhat.com>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <c175f758-bfa3-67d3-4c2d-74642b272aec@suse.com>
Date: Fri, 20 Jul 2018 14:08:22 -0400
MIME-Version: 1.0
In-Reply-To: <20180720155529.qw7nthesfu6xu7ie@odin.usersys.redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Am8ou5nD9A8Z8dMyxCljGt8kdJVwnxkms"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, Eric Sandeen <sandeen@sandeen.net>, Dave Chinner <david@fromorbit.com>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Am8ou5nD9A8Z8dMyxCljGt8kdJVwnxkms
Content-Type: multipart/mixed; boundary="SNg92pM3eeGjGecvwSpwSfaWth1GoRdbW";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
 Eric Sandeen <sandeen@sandeen.net>, Dave Chinner <david@fromorbit.com>
Message-ID: <c175f758-bfa3-67d3-4c2d-74642b272aec@suse.com>
Subject: Re: [PATCH] mkfs: avoid divide-by-zero when hardware reports optimal
 i/o size as 0
References: <6f62dbc6-f516-e8b5-1f08-6be227a61219@suse.com>
 <20180720155529.qw7nthesfu6xu7ie@odin.usersys.redhat.com>
In-Reply-To: <20180720155529.qw7nthesfu6xu7ie@odin.usersys.redhat.com>

--SNg92pM3eeGjGecvwSpwSfaWth1GoRdbW
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 7/20/18 11:55 AM, Carlos Maiolino wrote:
> On Thu, Jul 19, 2018 at 05:23:22PM -0400, Jeff Mahoney wrote:
>> Commit 051b4e37f5e (mkfs: factor AG alignment) factored out the
>> AG alignment code into a separate function.  It got rid of
>> redundant checks for dswidth !=3D 0 since calc_stripe_factors was
>> supposed to guarantee that if dsunit is non-zero dswidth will be
>> as well.  Unfortunately, there's hardware out there that reports its
>> optimal i/o size as larger than the maximum i/o size, which the kernel=

>> treats as broken and zeros out the optimal i/o size.  We'll accept
>> the multi-sector dsunit but have a zero dswidth and hit a divide-by-ze=
ro
>> in align_ag_geometry.
>>
>> To resolve this we can check the topology before consuming it, default=

>> to using the stripe unit as the stripe width, and warn the user about =
it.
>>
>=20
> I wonder if this shouldn't go into blkid_get_topology since something i=
s wrong
> with the information reported by the storage.
> And require a force_overwrite to continue, at this point, something loo=
ks quite
> wrong in the storage, and I think this is the last 'resource' a sysadmi=
n will
> have to notice this before making the FS, and start using it, so, maybe=
 requiring
> force_overwrite would bring more attention.

We discussed that initially here:
https://patchwork.kernel.org/patch/10479083/

I worked that up and what ends up happening is that, since we don't have
any context for how the topology will be used, if at all, we print the
error every time.  If the user specified stripe parameters manually, the
topology won't be used.  They won't care if it's broken and certainly
don't need to force it.

Lastly, this wasn't encountered in the real world on some weird discount
hardware.  It's a pretty big product from a major storage vendor.  I've
advised them to fix their firmware but we still need to get users
rolling again.  Warning about a potential suboptimal result is enough,
IMO.  It's not an emergency situation that will result in a completely
broken file system.

-Jeff

>> Fixes: 051b4e37f5e (mkfs: factor AG alignment)
>> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
>> ---
>>  mkfs/xfs_mkfs.c | 6 ++++++
>>  1 file changed, 6 insertions(+)
>>
>> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
>> index a135e06e..35542e57 100644
>> --- a/mkfs/xfs_mkfs.c
>> +++ b/mkfs/xfs_mkfs.c
>> @@ -2295,6 +2295,12 @@ _("data stripe width (%d) must be a multiple of=
 the data stripe unit (%d)\n"),
>>  	if (!dsunit) {
>>  		dsunit =3D ft->dsunit;
>>  		dswidth =3D ft->dswidth;
>> +		if (dsunit && dswidth =3D=3D 0) {
>> +			fprintf(stderr,
>> +_("%s: Volume reports stripe unit of %d bytes but stripe width of 0. =
 Using stripe width of %d bytes, which may not be optimal.\n"),
>> +				progname, dsunit << 9, dsunit << 9);
>> +			dswidth =3D dsunit;
>> +		}
>>  		use_dev =3D true;
>>  	} else {
>>  		/* check and warn is alignment is sub-optimal */
>> --=20
>> 2.16.4
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-xfs" i=
n
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--=20
Jeff Mahoney
SUSE Labs


--SNg92pM3eeGjGecvwSpwSfaWth1GoRdbW--

--Am8ou5nD9A8Z8dMyxCljGt8kdJVwnxkms
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE8wzgbmZ74SnKPwtDHntLYyF55bIFAltSJRYACgkQHntLYyF5
5bIh5hAAmfXDy/WqrWDWeownOiCbq5C9TniopCvf+FmC7gIm+Qn+bZ12Y/IfLgNF
nHXWanzlc6Se5zjk8jdyzK2crE2rP6QB2SzL9PFFOwjd9v0165Jnad2EuY/Ujxnm
ITMIgZGYvsmszy4jmb3NkiGKiLL0vAqVqj9sbJNJcSzAdKGx1+84VoGZzN2QTw0H
r0S2V/O+VwmUmm0j3yB3u10x5mX6qbUxeLwlBL70Mvz/qaXLVdehiFWBGqw31/PK
utrVREC1gk+oC33n8nUyBvK7cx1WLSGA8sU0eGM6JQ5xRJsxXkFr94ksb7XwznlC
f5AzzVa9nany3SVzCB893sIXBrgVemaWV0wXOItX3TcEKHtd6GmDvk7AYbzYScW+
VX8H19kOk8jgrN8xx9cLWC6mvHnJAWE5niP/GMPHwnA+xYZH4VzmXlnStNTiFixO
tJCP3N7bG3PMqIo/ynsD3CCmtlbP0tfFRRfj+JWFp11qcfZe9WUXvTjUlCwop5ZO
wtv6jUfZRY7OXf+UOT48Zubj30AbUzVV7RRMlRGyckZfP/s/gXyc+H+4k/kDbwgK
G0PJNit/Ag9VJ9AKTtRCQD/tYEQiLyqhgjNFle0MinoFjFfOXUvt7hCgJE9Ji5R1
aKGOaF0fLIFtaxpH6WAqXrjdKbLa52qHPyqPfQWAxVNKo7oPsxg=
=tTmH
-----END PGP SIGNATURE-----

--Am8ou5nD9A8Z8dMyxCljGt8kdJVwnxkms--
