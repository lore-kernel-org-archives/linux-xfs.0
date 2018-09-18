Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:57430 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726371AbeIRHqY (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 18 Sep 2018 03:46:24 -0400
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id C30504A2
        for <linux-xfs@vger.kernel.org>; Mon, 17 Sep 2018 21:15:36 -0500 (CDT)
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs libxfs-4.19-sync branch pushed
Message-ID: <d461e927-5b07-c72b-9dac-c82a4336a272@sandeen.net>
Date: Mon, 17 Sep 2018 21:16:10 -0500
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="tCWY8TyY6bITzh5TsGMugncGgAnDtAnuO"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--tCWY8TyY6bITzh5TsGMugncGgAnDtAnuO
Content-Type: multipart/mixed; boundary="DWkmkdONr5rLowI2dPe1n8PVKdDNm8r6I";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: linux-xfs <linux-xfs@vger.kernel.org>
Message-ID: <d461e927-5b07-c72b-9dac-c82a4336a272@sandeen.net>
Subject: [ANNOUNCE] xfsprogs libxfs-4.19-sync branch pushed

--DWkmkdONr5rLowI2dPe1n8PVKdDNm8r6I
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi all -

Sorry for the delay, but a preliminary libxfs-4.19-sync branch has
been pushed up to the xfsprogs repository on kernel.org.  The=20
top commit is

The head of the libxfs-4.19-sync branch is commit:

b53f016 xfs: fix a null pointer dereference in xfs_bmap_extents_to_btree

This passed basic sanity checks, now I'll go see what all differs
in Darrick's tree that he did similar work in ~1 month ago...

Assuming it doesn't have any brown paper bags, I'd suggest basing any
xfsprogs-4.19 patches on this branch now.

Thanks,
-Eric


--DWkmkdONr5rLowI2dPe1n8PVKdDNm8r6I--

--tCWY8TyY6bITzh5TsGMugncGgAnDtAnuO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAlugX+sACgkQIK4WkuE9
3uDXjQ//ZuH1PiP5H1fF0Q9vnVDvaiIWxJmWUIhEjgKJUNi6ok9zbmJJ4rgBWR+h
+2j6R/FkB6KiCvK0Pi036VuAlIqyv2fvHDVTZbr1SodnfpT/pbiZZw94s0J/8ArR
9Pva3oG3CyRRktC/QEpjiGqA9jiPzICFnFPPV6cTRI2euvDdmNWeGVIId4AaZ34C
eGuaiUBy6ew6kNapBmi3KBo7pXyjr9gpMHOV7otQ351R8LbVZZv/gHLCMDyFl4cm
LQfEmqNCvaN1iG8HZGVRiXKZ0LGyFli+zegd/Hd85gyWDlCdYYVg/y2k9iwibK80
ktAndAOC6s+eoN5uCkU6YW1WE241tfWimAMuArhjlzu5s/UDRW6v+MmvBQAwL2zS
UlyeHoNTcFUq6wKbEJEn3KVg1mEgQZE+sz75gVYMapQsU1obedboJU6HDrZWBJAR
BGSnUI+ykcyBikObz8XRUUzCXKVB3rK5V+jK+skrw9iGUyJNzBvHJifoMitnZTtM
fl1qVMVOq+4HOZoOoRSr8AgYnaJnj2Q7BO7aXmXd0UKYrNlprfW8qMpW7XE9H5gR
L4Hlcyh/lHZsrxYkfC/GS5WkZFss7E/NkrEgmOWXoguSeFqplQQOk3R4Ep2Dw9wX
Zul2ykBQgi4LII/S6NXkk+BgP1svOAvfM7zUVIuB2eQN97j2f6o=
=G7F+
-----END PGP SIGNATURE-----

--tCWY8TyY6bITzh5TsGMugncGgAnDtAnuO--
