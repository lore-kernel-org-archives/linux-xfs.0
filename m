Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 377947CC7
	for <xfs@oss.sgi.com>; Fri, 26 Aug 2016 01:44:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id BA44D8F8054
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 23:43:51 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	3exjtSCyBzcS2MQB for <xfs@oss.sgi.com>;
	Thu, 25 Aug 2016 23:25:42 -0700 (PDT)
Date: Fri, 26 Aug 2016 16:25:08 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfs: for-next branch updated to 800b269
Message-ID: <20160826062508.GG19025@dastard>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1706257211698420559=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com, linux-xfs@vger.kernel.org


--===============1706257211698420559==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SnV5plBeK2Ge1I9g"
Content-Disposition: inline


--SnV5plBeK2Ge1I9g
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi folks,

The for-next branch of the xfs kernel repository at:

git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git

has just been updated.

This (hopefully) is the last set of fixes for the 4.8 cycle - I plan
to send them to linus by the middle of next week. For this point
onwards I'll be focussing on patches for the 4.9 merge window - I'm
not sure how much of the reflink set we'll get through before the
window closes, but I'm going to take a good swing at getting that
merged for 4.9....

-Dave.

The new head of the for-next branch is commit:

800b269 xfs: prevent dropping ioend completions during buftarg wait

New Commits:

Brian Foster (1):
      [800b269] xfs: prevent dropping ioend completions during buftarg wait

Darrick J. Wong (5):
      [ed150e1] xfs: don't perform lookups on zero-height btrees
      [738f57c] xfs: disallow mounting of realtime + rmap filesystems
      [da1f039] xfs: don't log the entire end of the AGF
      [7222789] xfs: fix some key handling problems in _btree_simple_query_=
range
      [5b5c2db] xfs: simple btree query range should look right if LE looku=
p fails

Dave Chinner (1):
      [f3d7ebd] xfs: fix superblock inprogress check


Code Diffstat:

 fs/xfs/libxfs/xfs_alloc.c  |  2 ++
 fs/xfs/libxfs/xfs_btree.c  | 14 +++++++++++++-
 fs/xfs/libxfs/xfs_format.h |  6 ++++--
 fs/xfs/libxfs/xfs_sb.c     |  3 ++-
 fs/xfs/xfs_buf.c           |  2 +-
 fs/xfs/xfs_super.c         |  9 ++++++++-
 6 files changed, 30 insertions(+), 6 deletions(-)
--=20
Dave Chinner
david@fromorbit.com

--SnV5plBeK2Ge1I9g
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXv+DDAAoJEK3oKUf0dfodYFYP/jeCAlZh1UFn/0v6gas2TzH9
yxtUJcCN2I/6Dj6+uIT74Ny+v/ELkpwQUC7FUPgvk7nLxokVhgGc+q3EUu2jQhYy
sT41gWDs2vrtsFeWBhHoLrKC/qOsyCZrvsDz47K6xYTVj+YeK3VCDUUiwmMuIrZY
pJDpwIJwVY84O8kx7j736U8UPsLz+56iVG8lzaJ2YE55tZOUCKLVB2nKNmgMo8XK
PeQJB0LtGZvcU7EycqM8t/K1NQl7i4z815VLNAkKPBFtklI+CPOCvVuGX6sbfeaL
WaWZBZVDBrwA0HOLcedTRlYO69BlbnYPklWEj1QOkzHLqucafMgBB3+0JAMHk4ec
tVQIAbD5RsHl6jdq6n1voSPDeTmXH7HTyEVA9uWfIpPUFizQO+Ovy1TzDwri+Twa
AkBRiEpLts93Bfpw17mklJmg5o+PEIJnpEhwTSemRrw3Anf1YnXXWKtaVmXllc+J
Ek0Opo34nxUK7shtLmWw1bqUUE7nOcVeYxlHlHcrYmeS4yuI8g3NtIRAKZ7sWRur
ZLfNE8HsOZdWes8/1R7C6uN7Scehlxezka/mB1fbKo6/Q6kmKEAuRc7YfDvfZ9x9
rNSnng+fJKlGFQLNLlz78EEzmmjRe7CwUOAZXJCr3A96fW87/Rz0Y8VoYC56q7ZL
6SUoukic2tYzsT/GJPjt
=0LS3
-----END PGP SIGNATURE-----

--SnV5plBeK2Ge1I9g--


--===============1706257211698420559==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1706257211698420559==--
