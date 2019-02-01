Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:53680 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726737AbfBAR4z (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 1 Feb 2019 12:56:55 -0500
Received: from Liberator-6.local (erlite [10.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id BB0AF2A9E
        for <linux-xfs@vger.kernel.org>; Fri,  1 Feb 2019 11:55:37 -0600 (CST)
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs for-next updated to 2cd8d66
Message-ID: <38562fac-273c-552e-9910-5190e294e8ee@sandeen.net>
Date: Fri, 1 Feb 2019 11:56:52 -0600
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="7KTlSdbtCTzNxpo8VtHyax8YVhp3MnXli"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--7KTlSdbtCTzNxpo8VtHyax8YVhp3MnXli
Content-Type: multipart/mixed; boundary="xBDTFwOkJTfLtHrO3FTJyX9mdV8AYN3aO";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: linux-xfs <linux-xfs@vger.kernel.org>
Message-ID: <38562fac-273c-552e-9910-5190e294e8ee@sandeen.net>
Subject: [ANNOUNCE] xfsprogs for-next updated to 2cd8d66

--xBDTFwOkJTfLtHrO3FTJyX9mdV8AYN3aO
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi folks,

The xfsprogs repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated.

This just fixes my thinko in the last push.  Thanks for spotting
it, Darrick.

The new head of the for-next branch is commit:

2cd8d66 xfs_repair: fix incorrect return value in namecheck()

New Commits:

Eric Sandeen (1):
      [2cd8d66] xfs_repair: fix incorrect return value in namecheck()


Code Diffstat:

 repair/da_util.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


--xBDTFwOkJTfLtHrO3FTJyX9mdV8AYN3aO--

--7KTlSdbtCTzNxpo8VtHyax8YVhp3MnXli
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAlxUiGUACgkQIK4WkuE9
3uCjPhAAlmsxmm5n68MBWkureMlZtfcc8vvUPoQKdsmkEeJ8qxINmAzmDTbs4wV/
oEU7TSmq3PnALu1f02MqchEAq0R+a7Ac7yAGajPBnDGB1yVQ05cuZHF8HtRXSNeF
XEJQCbk3hghHzYp8To6Kwj2LiEzwkiv2q3lh1tYyFeWk7h2HoghOd5qxrPhPHV8k
/AuJAGvdUGlRTJcyAvlPSmPU4VNm7vc9PFvz3624RNkdC2P3Wk2nmZ368HAntKH7
RkwvVBNkFIl/WbPY2faXNOS0eWgzqjL0UrRJKrTOfa2z8Q9eCJUAeCR02nCvZshK
oVXEKdhrpKPpwBuyY74SqAxV49AMhPVfOZB/2HazMS5ZH0Cpdq5iUDb28iO/J2bi
W01NfW+8BF/vjhMHWMgzrHI36difs5/2zBZ4Zx1hi0QXFmgf40QcCuuprZEl/Pfo
wZDDX7CpOVkCwbFTQxserMZjDxWldUlNN1V0AJ42/yJNWtp9LrfU0gcU1lSlx8dd
Nqb0OreqB+hx7VVDBRzT7WzGSlHJTlODn7cMFsD8Si/O0YrED//tBSs08+2Yjtlu
TH0ouc5huv9IqYducJJyO9A1wBe8xrqqfVK9uuRXAE5a9Hm8Q0PzYEuUPj/sLQq2
hrarkaa0ldbHPQsUJcH7DKxHDqyqIqN1Gz6OkywlxFVp9k4sBMA=
=58g7
-----END PGP SIGNATURE-----

--7KTlSdbtCTzNxpo8VtHyax8YVhp3MnXli--
