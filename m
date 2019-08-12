Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ozlabs.org ([203.11.71.1]:32927 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726200AbfHLVpL (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 12 Aug 2019 17:45:11 -0400
Date: Tue, 13 Aug 2019 07:45:06 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: linux-next: Fixes tag needs some work in the xfs tree
Message-ID: <20190813074506.3e2ee2c8@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/qZu7HnNcDMRIIYz=EyaSqZg";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, David Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Cc: Linux Next Mailing List <linux-next@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

--Sig_/qZu7HnNcDMRIIYz=EyaSqZg
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

In commit

  294fc7a4c8ec ("fs: xfs: xfs_log: Don't use KM_MAYFAIL at xfs_log_reserve(=
).")

Fixes tag

  Fixes: eb01c9cd87 ("[XFS] Remove the xlog_ticket allocator")

has these problem(s):

  - SHA1 should be at least 12 digits long
    This can be fixed for the future by setting core.abbrev to 12 (or
    more) or (for git v2.11 or later) just making sure it is not set
    (or set to "auto").

--=20
Cheers,
Stephen Rothwell

--Sig_/qZu7HnNcDMRIIYz=EyaSqZg
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl1R3eIACgkQAVBC80lX
0GyQdggAiIZNkT1bXZlEiouHqcI/6K+Q5IiKQfem6//MqILuFjBaM62fwggQEtJ8
fblLTbCyJUYMO1TBrSir0FDBUU5Gs+xGpMS+Xt+wnCZzBBru80135pr+gIL/izxt
CtYYFR0fdUeG4soHg7gb0ZBSaYoSuMP12CD0IQjsQwQDaYL5aoWsFBBk1btUo89y
aUuWAFyIWiYOdUow9vZ8jVrtW+K4YDE2ejP2QkGyE//nxES00E08AScWtWIgFwCA
ZMWXRdgw9bd87XklAGOfyas86xVgVG6MJVrYiAdub+Xr0CJA7jUh8/vMH8TEWgrL
xPmns2M3UtU5y4FeH14QOYVjNEs1cg==
=VlG8
-----END PGP SIGNATURE-----

--Sig_/qZu7HnNcDMRIIYz=EyaSqZg--
