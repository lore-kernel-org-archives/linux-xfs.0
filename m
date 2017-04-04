Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:34610 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753641AbdDDRhL (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 4 Apr 2017 13:37:11 -0400
Subject: Re: "interesting" crash : 3.18.44, huge xfs, nfs
References: <20170404150202.6c7d032c@harpe.intellique.com>
 <20170404192411.650fb403@harpe.intellique.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <95e14081-0f1c-7458-cca2-1f33d6662037@sandeen.net>
Date: Tue, 4 Apr 2017 12:36:57 -0500
MIME-Version: 1.0
In-Reply-To: <20170404192411.650fb403@harpe.intellique.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="7mCrpG2ERaftxghKqnC0k1K1hpOQqE5k4"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Emmanuel Florac <eflorac@intellique.com>, linux-xfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--7mCrpG2ERaftxghKqnC0k1K1hpOQqE5k4
Content-Type: multipart/mixed; boundary="O0osGPseKBrpv8cB2urOCjRXC1B5ENpoB";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: Emmanuel Florac <eflorac@intellique.com>, linux-xfs@vger.kernel.org
Message-ID: <95e14081-0f1c-7458-cca2-1f33d6662037@sandeen.net>
Subject: Re: "interesting" crash : 3.18.44, huge xfs, nfs
References: <20170404150202.6c7d032c@harpe.intellique.com>
 <20170404192411.650fb403@harpe.intellique.com>
In-Reply-To: <20170404192411.650fb403@harpe.intellique.com>

--O0osGPseKBrpv8cB2urOCjRXC1B5ENpoB
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 4/4/17 12:24 PM, Emmanuel Florac wrote:
> Le Tue, 4 Apr 2017 15:02:02 +0200
> Emmanuel Florac <eflorac@intellique.com> =C3=A9crivait:
>=20
>> Hi,=20
>> here is an interesting crash dump. I've never seen this function
>> called before : "Fixing recursive fault but reboot is needed!"
>>
>> The system is frozen and must be hard rebooted. The filesystem is
>> humongous: about 400 TB.
>> Running is plain vanilla 3.18.44 (should upgrade...). I wonder if the
>> bug is still present though?=20
>>
>> Context: this is a file server. There was a power failure yesterday,
>> so there's probably some corruption hidden somewhere triggering the
>> crash.

and using filestreams, apparently?

>=20
> The machine goes on crashing on disk access... xfs_repair 4.9 is
> running now, and after that we'll reboot with a current kernel
> (4.4.59). Any advice?

Yep, go back in time & get an xfs_metadump before you repair it.  :(

Please do at least capture repair output.

-Eric

> The latest crash trace was still xfs related apparently:



--O0osGPseKBrpv8cB2urOCjRXC1B5ENpoB--

--7mCrpG2ERaftxghKqnC0k1K1hpOQqE5k4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2
Comment: GPGTools - http://gpgtools.org

iQIcBAEBCAAGBQJY49nGAAoJECCuFpLhPd7gozAP/1zYNm9w6EUpjf9JUh+7dt+K
Zck+o+65+oR1MTn5LMQOEj38myZLeKlbjRfglghbzxI3ZmuhrhK8NdyG1oFJr/wd
XhMYY6AfNwDWjGXY8JtefEb053EtFWMM/5BZKeQHfh6A6m5UczEEALJ0JpokVlMG
mRr9daBWC1E7CmEBEj4dYcUMo/YFlmndaZ/KEGBk/RXUrHMbBYTQ/WyukkiM1oAL
dr4h4uB1mRQirA3hKZ+BoRW9GAX4iEfetqIP4X0OUHJk/dhJaST6l2SH0KDtoHy4
gY4gpohNcNYRsObkkSsYjgME7kgOOZcvvrAhSrkWB/WqqNO7mIwhB1R+Lq5qfu3e
pK/JIyMMKCN3PloMpsZ7pjRIEmPigntnQ2K8MMHoofQHxIs78t4C9IbCicUlh8wW
A710jE4sXemulQe3kwHMac1Pw/YIjbW9qUHPqHw13AQ3AnpzwPMUF9JySyb30Kz9
OpypnoOCHWjbYBM+8PP2ToC6/QbMYe0qiqSt1RXmJaQNkWwKxPKh3UTMPr+V4pdA
E+DxrVqDlAS/v5vzq1aDJBXVKe9yXMdOX9Qs24ngs2vo/VNPghe2/+74tcWr/1+N
JLi2N3vqGkZyfvaiJFFaTv6CWVepq3VdveqmrWGAANUDfKY8e0lU9DMpvozBsy10
GRG0n7r8MRqQ765ebxl1
=MpIm
-----END PGP SIGNATURE-----

--7mCrpG2ERaftxghKqnC0k1K1hpOQqE5k4--
