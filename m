Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:56103 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752054AbcJJMoY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Oct 2016 08:44:24 -0400
Received: from dave by dastard with local (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1btZwK-0006XI-Jh
        for linux-xfs@vger.kernel.org; Mon, 10 Oct 2016 23:44:20 +1100
Date: Mon, 10 Oct 2016 23:44:20 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfs: for-next branch updated to 6f97077ff6ef
Message-ID: <20161010124420.GB23194@dastard>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="HcAYCG3uE/tztfnV"
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org


--HcAYCG3uE/tztfnV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi folks,

The for-next branch of the xfs kernel repository at

git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git

has just been updated with a few reflink fixes from Darrick.

-Dave

The new head of the for-next branch is commit:

6f97077ff6ef xfs: rework refcount cow recovery error handling

New Commits:

Darrick J. Wong (7):
      [63646fc58d66] xfs: check inode reflink flag before calling reflink f=
unctions
      [024adf487022] xfs: reduce stack usage of _reflink_clear_inode_flag
      [97a1b87ea7b2] xfs: remove isize check from unshare operation
      [93fed47013b3] xfs: fix label inaccuracies
      [9780643cde26] xfs: fix error initialization
      [1987fd743415] xfs: clear reflink flag if setting realtime flag
      [6f97077ff6ef] xfs: rework refcount cow recovery error handling


Code Diffstat:

 fs/xfs/libxfs/xfs_refcount.c | 20 +++++++--------
 fs/xfs/xfs_file.c            |  8 +++---
 fs/xfs/xfs_ioctl.c           |  4 +--
 fs/xfs/xfs_reflink.c         | 64 ++++++++++++++++++----------------------=
-------
 fs/xfs/xfs_super.c           | 12 +++++----
 5 files changed, 47 insertions(+), 61 deletions(-)
--=20
Dave Chinner
david@fromorbit.com

--HcAYCG3uE/tztfnV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJX+40kAAoJEK3oKUf0dfodZLoQANBp+3WX33hCpsOReFvDc/bq
FwGXdA5QvxQMpVcf08NNA3YIwMvq7HRByCcIafMr/XmEmKP+nli9l6fnLEi18t3v
4NEfAwzpD266/1LwrO7HPih+cgIoS0Zrh0gy4/HbnbnDsqB+riR4JoGu8lY4gMVP
hbqLstAwF5Mipfqs0iIXUZWVlIcMMvAl2DcifgzyDkmapnWIf1MtunmSHU4eQq9I
8EMBeT5YzsiUQFyRZo1EyZIrZJ797kYrQaEDxwpw1bq0Uf+quTh94SRz3o+eW0es
7tjI54gZfoWy1OIrtXGrxCFfyjbPmDOG43h21IzWNFvlGKEwefdRQZXpa5Iu7yTU
Mq2/KYXipMd9PxCGGcZ4HrKywH1HeiF9hXt99eX0YhcDp1BDYHEO0ev8Jce4NypR
uDnj9blqMExnXhKl1Pnqnw5fFeYYfhz35cgXj2HOElABQA7gd12vq9kaWQK0jyKa
ve2quVGuncqV8/eGBVKCORHvoICPtBcsF+CNpH/Tdhvi6JHgLX9ICD68MYw48vJ9
+p9mKz3GB0lZvkUs9xAAqbIO5Owsf3XArTGW0RIzpZWKsh9tUE7gOkiSySxUzVWZ
kl06x8MMUm6sM9tln0qWJbpZGlRqJDUL765+gtKB8xksko2H5k6Y77P+LkmqbzWu
1ca6qa0NspNYhYfRyp3y
=BKxp
-----END PGP SIGNATURE-----

--HcAYCG3uE/tztfnV--
