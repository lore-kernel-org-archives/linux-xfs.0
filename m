Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4B76629DFC
	for <xfs@oss.sgi.com>; Thu, 16 Apr 2015 07:55:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0F63E304039
	for <xfs@oss.sgi.com>; Thu, 16 Apr 2015 05:55:49 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	FuaaZUkd4UZ0gCXe for <xfs@oss.sgi.com>;
	Thu, 16 Apr 2015 05:55:47 -0700 (PDT)
Received: from dave by dastard with local (Exim 4.80)
	(envelope-from <david@fromorbit.com>) id 1YijKP-0006Di-UH
	for xfs@oss.sgi.com; Thu, 16 Apr 2015 22:55:33 +1000
Date: Thu, 16 Apr 2015 22:55:33 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfs: for-next branch updated to 542c311
Message-ID: <20150416125533.GD21261@dastard>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4067482440117467704=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--===============4067482440117467704==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="X1bOJ3K7DJ5YkBrT"
Content-Disposition: inline


--X1bOJ3K7DJ5YkBrT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi folks,

The for-next branch of the xfs kernel repository at

git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git

has just been updated.

The new head of the for-next branch is commit:

542c311 Merge branch 'xfs-dio-extend-fix' into for-next

New Commits:

Dave Chinner (9):
      [a719370] xfs: factor DIO write mapping from get_blocks
      [1fdca9c] xfs: move DIO mapping size calculation
      [d5cc2e3] xfs: DIO needs an ioend for writes
      [6dfa1b6] xfs: handle DIO overwrite EOF update completion correctly
      [a06c277] xfs: DIO writes within EOF don't need an ioend
      [b9d5984] xfs: DIO write completion size updates race
      [40c63fb] xfs: direct IO EOF zeroing needs to drain AIO
      [0cefb29] xfs: using generic_file_direct_write() is unnecessary
      [542c311] Merge branch 'xfs-dio-extend-fix' into for-next


Code Diffstat:

 fs/xfs/xfs_aops.c  | 270 +++++++++++++++++++++++++++++++++++++------------=
----
 fs/xfs/xfs_file.c  |  46 ++++++++-
 fs/xfs/xfs_trace.h |   5 +
 3 files changed, 239 insertions(+), 82 deletions(-)
--=20
Dave Chinner
david@fromorbit.com

--X1bOJ3K7DJ5YkBrT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJVL7FFAAoJEK3oKUf0dfod9xoP/j89hOpYybbv2yccHfWd75H2
wc3lRjki2O/NO7Oa4xf9V6ZUahcp7Zif6m1+1D12kETSvfsMIfzNmj9Ouc748eqp
cHE8A/zDVcESO+JZTaFNLXnwdPT2LQVlj8C2JplbCu+Mjldsl+bhUBPw0JoUEBMG
8ptV2UTYGh0Y3cEvUbXix0vfFbvK0nSJfM6GuJarrWT+49JgNd90Un1PS0UMbs/B
uvKCBXvdRXRximzmMEIOKcZHRJBs8Hr34l4XZ4DRhwmv/S2816YQVrnXNNNEWIlp
JIh4HFh7r+5173VjsSWwYyTjC2AjMubGBSmoqwTDiO4swSMugu+vjwxKJ3IsLFCn
eH7JsGMjFtwdUZGgkJXUjE7JY+LInB2gy43AQJNYkcVfRcWI9vlGKuZBcroU5UJk
6C60e8WXGMFJJIYX5NkSg7fyeBoxW5cjaDhGWlVBgG9xSgkzRq0KX8UWsMaI7Gzr
fM5vEHHfupa/i7E4tnF3PwlqimdVc4LNBmXo0CHm+agM/LbIaB/nV4aDRNvUe5nJ
/VPACzNJ2yChfa5snLUElsfM9ai485klmlNPsjgn0qBQ6kA/q/HZYMu3Zqbez+Hg
sHiwS98KxiuaPZ2ME9sbOB/KDSD4aPNOlFpz4Wl11XOhyUlR3TKLv9HO5ub2kNst
VYqjjyKaaSuUwYhM4quu
=cYLX
-----END PGP SIGNATURE-----

--X1bOJ3K7DJ5YkBrT--


--===============4067482440117467704==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4067482440117467704==--
