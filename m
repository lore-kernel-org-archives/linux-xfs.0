Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9AA2A7CA2
	for <xfs@oss.sgi.com>; Mon, 15 Feb 2016 23:46:01 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 89BAF8F8040
	for <xfs@oss.sgi.com>; Mon, 15 Feb 2016 21:45:58 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	EbLWWRhO5MwrivPI for <xfs@oss.sgi.com>;
	Mon, 15 Feb 2016 21:45:55 -0800 (PST)
Received: from dave by dastard with local (Exim 4.80)
	(envelope-from <david@fromorbit.com>) id 1aVYSI-00033Z-S5
	for xfs@oss.sgi.com; Tue, 16 Feb 2016 16:45:46 +1100
Date: Tue, 16 Feb 2016 16:45:46 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfs: for-next branch updated to e15c65b
Message-ID: <20160216054546.GM14668@dastard>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3910122074002497992=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--===============3910122074002497992==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GPJrCs/72TxItFYR"
Content-Disposition: inline


--GPJrCs/72TxItFYR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi folks,

The for-next branch of the xfs kernel repository at

git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git

has just been updated.

The new head of the for-next branch is commit:

e15c65b Merge branch 'xfs-writepage-rework-4.6' into for-next

New Commits:

Dave Chinner (7):
      [988ef92] xfs: remove nonblocking mode from xfs_vm_writepage
      [150d5be] xfs: remove xfs_cancel_ioend
      [fbcc025] xfs: Introduce writeback context for writepages
      [ad68972] xfs: xfs_cluster_write is redundant
      [bfce7d2] xfs: factor mapping out of xfs_do_writepage
      [e10de37] xfs: don't chain ioends during writepage submission
      [e15c65b] Merge branch 'xfs-writepage-rework-4.6' into for-next


Code Diffstat:

 fs/xfs/xfs_aops.c | 732 ++++++++++++++++++++------------------------------=
----
 fs/xfs/xfs_aops.h |   4 +-
 2 files changed, 269 insertions(+), 467 deletions(-)
--=20
Dave Chinner
david@fromorbit.com

--GPJrCs/72TxItFYR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJWwreKAAoJEK3oKUf0dfodsAgQAIsnVCYe/c0tA1uY5hJofeLW
NJRUg4zSVh+zgE8ySIOpxmec/BIGIG5yiBQvt4/5R8omjGPc2le6rzgRm1y7Av0H
177bMvaX0yKMkCN1AJBnA3ezsjIFpnidjZOy4Oh4oC5HwRncurbvtdjr+2DwaHww
OSmQ0gGoevOxNpG+fXy3UmNmkqaZR4OP1A3eXLhBYmM61EPmVklpD4PmPwET0wee
Qr+KF0X81dOezbwazyNhV1kbRs7dB/nkkKdFl/cYETl+MysdWs+HXUt475N/25zt
U/qnh3MLuHuNi1TspvXXoc7mIhiL0O38eP/nFrI7lN/AvTTcx9PyF0DHlD3AvwMu
K0hYqzgMnbGYPgvz5vtzVXxVIdijcpVl6L4RQOxSj4ZUDRhonW5d3wtmazuU5B0e
w1rNoUf2+uFpDlL1Iu3Em/7a0ujl+GvoTBkJgGNFqUdT2W5aaoXBVff6NYjz8whB
h8+pjaDsHJFHdYx6s6BJwwBmq8veIKNL3l8ajjZ6hQE9TfIlVvS4wcZjJG7kcMLD
B1+YyG4LtR3SDybckJkyNG8t9BaDaWXbczR5xAEF8lIkAVX3joTZEm1EOa1Vjig6
s3nqK4FkJIQyKL1mbQjA9zJI/G+fU4ZUEi9A9RZO4lV39yq66heHA7WMma861Yjz
IZRMrubbfvtWCMy3Y44M
=KJqY
-----END PGP SIGNATURE-----

--GPJrCs/72TxItFYR--


--===============3910122074002497992==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3910122074002497992==--
