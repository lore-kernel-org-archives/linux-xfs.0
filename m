Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:57346 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728933AbfEUQLh (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 21 May 2019 12:11:37 -0400
Received: from Liberator-6.local (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 0BDED325F
        for <linux-xfs@vger.kernel.org>; Tue, 21 May 2019 11:11:32 -0500 (CDT)
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs for-next updated to 5539639
Message-ID: <47a8553f-576b-a45b-18b8-be600e0e6c5f@sandeen.net>
Date: Tue, 21 May 2019 11:11:35 -0500
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="POoZA4fFMmLiCDa4EqY8tZwfzG3qZhsDq"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--POoZA4fFMmLiCDa4EqY8tZwfzG3qZhsDq
Content-Type: multipart/mixed; boundary="w4Tw49lgYRsQU628B0gg5si52F0utWIIg";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: linux-xfs <linux-xfs@vger.kernel.org>
Message-ID: <47a8553f-576b-a45b-18b8-be600e0e6c5f@sandeen.net>
Subject: [ANNOUNCE] xfsprogs for-next updated to 5539639

--w4Tw49lgYRsQU628B0gg5si52F0utWIIg
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi folks,

The for-next branch of the xfsprogs repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated.

Patches often get missed, so please check if your outstanding
patches were in this update. If they have not been in this update,
please resubmit them to linux-xfs@vger.kernel.org so they can be
picked up in the next update.

The new head of the for-next branch is commit:

5539639 libxfs: share kernel's xfs_trans_inode.c

New Commits:

Christoph Hellwig (1):
      [15b8fe6] libxfs: factor common xfs_trans_bjoin code

Dave Chinner (1):
      [fb34b2d] xfs: factor log item initialisation

Eric Sandeen (5):
      [bc603ef] libxfs: Remove XACT_DEBUG #ifdefs
      [cebe02e] libxfs: rename bli_format to avoid confusion with bli_for=
mats
      [31355f9] libxfs: fix argument to xfs_trans_add_item
      [b192e77] libxfs: create current_time helper and sync xfs_trans_ich=
gtime
      [5539639] libxfs: share kernel's xfs_trans_inode.c


Code Diffstat:

 include/xfs_inode.h      |  14 ++++
 include/xfs_trace.h      |  13 +++
 include/xfs_trans.h      |   5 +-
 libxfs/Makefile          |   1 +
 libxfs/libxfs_priv.h     |  10 +++
 libxfs/logitem.c         |  14 ++--
 libxfs/trans.c           | 209 +++++++++++++++--------------------------=
------
 libxfs/util.c            |  39 ++++-----
 libxfs/xfs_trans_inode.c | 155 +++++++++++++++++++++++++++++++++++
 9 files changed, 283 insertions(+), 177 deletions(-)
 create mode 100644 libxfs/xfs_trans_inode.c


--w4Tw49lgYRsQU628B0gg5si52F0utWIIg--

--POoZA4fFMmLiCDa4EqY8tZwfzG3qZhsDq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAlzkIzcACgkQIK4WkuE9
3uAPZg/+NUF+c9saNklPkmiU9U1oNpvkirpQSMtiRB24Nh6u0u3Q7xSj7JnVDvLC
DerYrbYeZbOv802LzSiI1XRFBROo83AjWhq6EcYyfBpplk3ubYUQQRFZVJNieIlt
9Zq1PDaFct3DCvmjlEoi6tpXyxi5rd/YVyUSgzwjilOXkEawkh58reDZuopcCM8L
9u0h4c+CT5279IWJS+SN9A+WKB+1BJHSx9aopv3xgCxIDof8E+y/s+U5+G+JvqkH
fWjhwpNqib+3vUkMMDswjlrZcpQVecq7WqNVfFgXixyTKjS4EB7+jOWqldnlSVGQ
4tnbpEBpE+45wP5UL9o//Rcard6wmUIzWnCJ5JbvPWEMXNvhNp2cSm1bvJkWQ2kc
MIIeRjLx+aP4QNjUlHehq7mYnnknprfxCiqS/fZ7NXv/B7CMnBULgNnnL3XbpIGV
dt5NpE3jvD6LK5IawXjnsZIMZxdoH4CEHmlY/2xOvKhk58AYibQiEQ4R4COQz/4s
wcMCuYRPGFP8sJk60Irjow+VyuA85AfeNd987008W+dw4/A4Ph6Xr1WfQoAkHTem
NFZe7bDMWzzmJouIsrArI6qnC9qwuaCbrx+Hpqd+xEBBw+3A3ogZgKvpQ852DADf
OJiGfc13ntAHxBYDbwZXcN5/XmLVjAlKPpxF0e767ErERthfzAs=
=8x76
-----END PGP SIGNATURE-----

--POoZA4fFMmLiCDa4EqY8tZwfzG3qZhsDq--
