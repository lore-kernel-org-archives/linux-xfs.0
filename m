Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 20BBB29E05
	for <xfs@oss.sgi.com>; Mon, 29 Feb 2016 01:01:55 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 89957AC006
	for <xfs@oss.sgi.com>; Sun, 28 Feb 2016 23:01:51 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	UDcn3uRe2qKc1KOH for <xfs@oss.sgi.com>;
	Sun, 28 Feb 2016 23:01:49 -0800 (PST)
Received: from dave by dastard with local (Exim 4.80)
	(envelope-from <david@fromorbit.com>) id 1aaHpR-0000PX-10
	for xfs@oss.sgi.com; Mon, 29 Feb 2016 18:01:13 +1100
Date: Mon, 29 Feb 2016 18:01:12 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfs: for-next branch updated to f012de6
Message-ID: <20160229070112.GJ29057@dastard>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3157638493215192900=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--===============3157638493215192900==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5p8PegU4iirBW1oA"
Content-Disposition: inline


--5p8PegU4iirBW1oA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi folks,

The for-next branch of the xfs kernel repository at

git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git

has just been updated. This is to pick up a bug fix for ext4
unwritten extent conversion in the xfs-dio-fix-4.6 branch.

-Dave.

The new head of the for-next branch is commit:

f012de6 Merge branch 'xfs-dio-fix-4.6' into for-next

New Commits:

Dave Chinner (1):
      [f012de6] Merge branch 'xfs-dio-fix-4.6' into for-next

Jan Kara (1):
      [74c66bc] ext4: Fix data exposure after failed AIO DIO


Code Diffstat:

 fs/ext4/ext4.h    | 30 +++++++++++++++++++++---------
 fs/ext4/inode.c   | 21 ++++++++-------------
 fs/ext4/page-io.c | 10 ----------
 3 files changed, 29 insertions(+), 32 deletions(-)
--=20
Dave Chinner
david@fromorbit.com

--5p8PegU4iirBW1oA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJW0+y4AAoJEK3oKUf0dfod/7gQAK9XQ6C7gdkzcKhU0cXMFAkg
q8Sct/WRbwGujW90YUwgYlBV89rOUT7/hLDT86lIsbQOTnB/ITn9jx2zIq8+w35M
HgwLWjUFXsILyLWZQmA/Ex1weV7HqH3esn8B9xuMvgNVQwuIVaIU/SEOBg6k6SXz
4toogCPCtxs9njflUWgqrK40L84wDeSVJppN2/1Pb1qJff83PniGnhf2hGINTzDU
CkEOenC4gHTiqXuRZ/4c0IAKq2WwyRO/9KQoggMZBCuG7kp3oqGExqPIpG38KT3L
xtLgP8G/rLB63SoC9Qa1JuQEIZZZ2YwvaUlb0BqEvrZAXUlepOppDdhr+kZaXw8q
rpqZouvkvmq8x4xqeaCwWE+T1OGtxn+FclcUirkitOg2qwwRr3peeqx4es6EgPeu
xT3IUncSyprahjPpNxAUe/7iugKS70N9mzsQfHxZklp923PTdt/dI8wvDz37VYmx
YDfaeX5V8LDKr/APYu38EWdNNku1AvkLhHaBsQpdY9BTCFjGcty/CfF3fONMU9JT
3sgm4Swffa5RQeiMUDxFXOlVd5eiHgQE6K7CQwIwlYbuSFRi7qqEtHHvsRf481qL
jwYrpGq/EyUZUFk0AEKWL4lQRigazhavznvXWvqcpdonXUmAKlkVu5OSSkV76b11
kYC/O++3HlEJNgTBtQrZ
=MLS+
-----END PGP SIGNATURE-----

--5p8PegU4iirBW1oA--


--===============3157638493215192900==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3157638493215192900==--
