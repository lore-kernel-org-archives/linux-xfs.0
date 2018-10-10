Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:54126 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727360AbeJKDDV (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 10 Oct 2018 23:03:21 -0400
Received: from Liberator-5.local (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 67A49B5B
        for <linux-xfs@vger.kernel.org>; Wed, 10 Oct 2018 14:39:28 -0500 (CDT)
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs for-next updated to 2937043
Message-ID: <0ddd5f1d-933d-aa35-7f36-ca701abe34e4@sandeen.net>
Date: Wed, 10 Oct 2018 14:39:40 -0500
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="wTPZArpZnoMLyPbqEVfdW2abqNMHGXDeX"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--wTPZArpZnoMLyPbqEVfdW2abqNMHGXDeX
Content-Type: multipart/mixed; boundary="eC1EOq6G7YRwgBNAgiIHBq1al5DGKDbNg";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: linux-xfs <linux-xfs@vger.kernel.org>
Message-ID: <0ddd5f1d-933d-aa35-7f36-ca701abe34e4@sandeen.net>
Subject: [ANNOUNCE] xfsprogs for-next updated to 2937043

--eC1EOq6G7YRwgBNAgiIHBq1al5DGKDbNg
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi folks,

The xfsprogs repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated.

Patches often get missed, so please check if your outstanding
patches were in this update. If they have not been in this update,
please resubmit them to linux-xfs@vger.kernel.org so they can be
picked up in the next update.

The new head of the for-next branch is commit:

2937043 xfs_scrub_all: fix systemd escaping again

New Commits:

Darrick J. Wong (1):
      [2937043] xfs_scrub_all: fix systemd escaping again

Dave Chinner (2):
      [9060cb3] xfsprogs: document changes for 4.19.0-rc0
      [b9df750] xfsprogs: remove unused functions


Code Diffstat:

 debian/changelog       |  7 ++++++
 doc/CHANGES            |  7 ++++++
 libxfs/rdwr.c          |  8 -------
 libxfs/util.c          | 63 --------------------------------------------=
------
 repair/btree.c         | 23 ------------------
 scrub/xfs_scrub_all.in |  9 ++++++--
 6 files changed, 21 insertions(+), 96 deletions(-)


--eC1EOq6G7YRwgBNAgiIHBq1al5DGKDbNg--

--wTPZArpZnoMLyPbqEVfdW2abqNMHGXDeX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAlu+VXwACgkQIK4WkuE9
3uCr9RAAmt0Wraw3DPo21zBhnhX5Mts7VhfXJtlCIT2zhEsNar44Pf1jztFZ/YsC
c/eVbqoUfSxGU1ha9+NycYSeKIxW2a8vUx+uv3mYqpjwjuvzoJ++YJN0b4yoCFD6
CHj0aQhdsQVGZEu7g+l3AEyvH216yumqJJR8hMU4zVYjzt2BWrvUWPQA5FMypnU1
AVUvFVVFyUJl0yg5YHLSIrYv+ni1KgkPFHWaYZH3/7s9qFIRxH9vF085SVNAEops
XNblxFxs59xTXO4pcZcK6lpkkMkBNhVwJJeteorwg5gRAgTfFVN00QV4J5Zfd/4Z
AYI/7yWPIUmwSNQC4mDj6f+GbEX2FbDHHOXw28TcewXwBqHFk5RuZRm5e/wH0jGz
YPG2DGrupfKvLMJJAjc5x2053irpK+9fMvfGPFFCKAO/bsufBYQVI3a7VWOB5VKt
22G4Casz4p+jnTiIn8sdexp55zw7Aqjktd/XERF2AKERdkyT3pt13bmZEDHfytFR
XdKYJqXgNufY18tUT9C/YGI+og35ZfUhMxweXk9uSC1IxNSYBqJ2wE0jedqLV0nG
wKQGkAseU9jepOlunSTiI11dULIXmdA2wXDMGWCMIGN14/VtVXJqC5yzUWl9Xkqm
8DuACzdt4wbf0oVF409LuC6zMY52bX6xzor/ZPix9LWSjKLbh6Q=
=nptj
-----END PGP SIGNATURE-----

--wTPZArpZnoMLyPbqEVfdW2abqNMHGXDeX--
