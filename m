Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:52474 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934797AbdI0COH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 26 Sep 2017 22:14:07 -0400
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 35D4274D070
        for <linux-xfs@vger.kernel.org>; Tue, 26 Sep 2017 21:13:50 -0500 (CDT)
Subject: [ANNOUNCE] xfsprogs v4.13.1 released!
From: Eric Sandeen <sandeen@sandeen.net>
References: <9a968cc5-4dcf-400c-4132-9b2b4f24a1d8@sandeen.net>
Message-ID: <08149044-1056-3bd3-629b-22a54aba1882@sandeen.net>
Date: Tue, 26 Sep 2017 21:14:00 -0500
MIME-Version: 1.0
In-Reply-To: <9a968cc5-4dcf-400c-4132-9b2b4f24a1d8@sandeen.net>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="OVxLd4EA6GIEuht7PrBR8iwoghHVkXt3i"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--OVxLd4EA6GIEuht7PrBR8iwoghHVkXt3i
Content-Type: multipart/mixed; boundary="wcDstWhhaHWSLpnAPaiwWURawEMU6iCSW";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: linux-xfs <linux-xfs@vger.kernel.org>
Message-ID: <08149044-1056-3bd3-629b-22a54aba1882@sandeen.net>
Subject: [ANNOUNCE] xfsprogs v4.13.1 released!
References: <9a968cc5-4dcf-400c-4132-9b2b4f24a1d8@sandeen.net>
In-Reply-To: <9a968cc5-4dcf-400c-4132-9b2b4f24a1d8@sandeen.net>

--wcDstWhhaHWSLpnAPaiwWURawEMU6iCSW
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi folks,

The xfsprogs repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated to v4.13.1, "Special Brown Paper Bag Edition!"

This fixes an array overrun in mkfs that I inexplicably missed
in the gcc warning, but dchinner didn't - thanks Dave.

The new head of the master branch is commit:

d4a3633 xfsprogs: Release v4.13.1

New Commits:

Darrick J. Wong (1):
      [efe5121] mkfs: don't overflow the subopts array

Eric Sandeen (1):
      [d4a3633] xfsprogs: Release v4.13.1


Code Diffstat:

 VERSION          |  2 +-
 configure.ac     |  2 +-
 debian/changelog | 10 ++++++++--
 doc/CHANGES      |  3 +++
 mkfs/xfs_mkfs.c  |  2 +-
 5 files changed, 14 insertions(+), 5 deletions(-)


--wcDstWhhaHWSLpnAPaiwWURawEMU6iCSW--

--OVxLd4EA6GIEuht7PrBR8iwoghHVkXt3i
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2
Comment: GPGTools - http://gpgtools.org

iQIcBAEBCAAGBQJZywluAAoJECCuFpLhPd7gwbUQAI7fPcY8FGifP6kbrat3PEh/
SeD6ElctsPJW2oMkHcYP1/7yPUjS17R7NzST4C3EsBDdA9QNE9f+OaDc879SG0cs
fhn/yegbDS/SkPgjhRtJ1To4Bi8mGmXY3B2E5xrqitye7ZAcw4RjWL/3BiESGTHP
zdsZpiCUlxxWzwJkdpiZun8SVdunmCT6JqUw+AG5CR3QaR+X4bocm4NgTFyHHIGe
ZVpUPsdU1RcYi11eOTq+MCRqVWec48OedD2n184lR7nCzP/9VEGzfSAtoBScEbx2
UXeXZdzUM0dvJ8+0zu1NPrSZ+2fJVV8YhmXBE2eAVejuniaM5vHcP+gCqs0WqfR5
Cgbjxlg0SRy4Ia85pGwhjzXgUKVK0SpHUaePKbAqPgnN1rOxHy74flC43s0y/w89
noFhL3cHi1gtPFmMb3O22328bzxDJJZt+6PLKhaW4HsHj5JMqOS+JmsVloyEdBez
XJ0lvroAfMrBO5HqjHchFXDOkoakru+SLUUSukPPsGrZpTjLxoIx+3YT9r+KtI05
+AXmmqBOPoK/DjuL9hBYeMC5TzZOMJBGxx4XiH5siQlCXk60m6YP9LPwe7WFUCu4
QVUx8Fg812S7FHSrH/xRFR1ruxnCeG8Vw/ikVVFTzsdRHubqXupLMfcX62rhmpFi
VkeI0BOyZzV+W24huZQz
=fIul
-----END PGP SIGNATURE-----

--OVxLd4EA6GIEuht7PrBR8iwoghHVkXt3i--
