Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B1BF27CBF
	for <xfs@oss.sgi.com>; Mon,  9 Nov 2015 18:16:09 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9B2AC304043
	for <xfs@oss.sgi.com>; Mon,  9 Nov 2015 16:16:06 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	Ex7njdqqJv3zanON for <xfs@oss.sgi.com>;
	Mon, 09 Nov 2015 16:16:02 -0800 (PST)
Received: from dave by dastard with local (Exim 4.80)
	(envelope-from <david@fromorbit.com>) id 1ZvwbQ-0006eZ-TC
	for xfs@oss.sgi.com; Tue, 10 Nov 2015 11:16:00 +1100
Date: Tue, 10 Nov 2015 11:16:00 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfs: for-next branch updated to 4e14e49
Message-ID: <20151110001600.GC14311@dastard>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5741060594833806902=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--===============5741060594833806902==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="x+6KMIRAuhnl3hBn"
Content-Disposition: inline


--x+6KMIRAuhnl3hBn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi folks,

The for-next branch of the xfs kernel repository at

git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git

has just been updated. it contains the couple of outstanding fixes
for the 4.4 merge window. This is essentially what I'll ask linus to
pull in the next couple of days.

-Dave.

The new head of the for-next branch is commit:

4e14e49 Merge branch 'xfs-misc-fixes-for-4.4-3' into for-next

New Commits:

Andreas Gruenbacher (1):
      [edfb8eb] xfs: Fix error path in xfs_get_acl

Brian Foster (1):
      [848ccfc] xfs: fix log recovery op header validation assert

Chris Mason (1):
      [7a29ac4] xfs: give all workqueues rescuer threads

Dave Chinner (1):
      [4e14e49] Merge branch 'xfs-misc-fixes-for-4.4-3' into for-next


Code Diffstat:

 fs/xfs/xfs_acl.c         | 1 +
 fs/xfs/xfs_acl.h         | 1 -
 fs/xfs/xfs_log_recover.c | 2 +-
 fs/xfs/xfs_super.c       | 7 ++++---
 4 files changed, 6 insertions(+), 5 deletions(-)
--=20
Dave Chinner
david@fromorbit.com

--x+6KMIRAuhnl3hBn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJWQTdAAAoJEK3oKUf0dfod6zIQAIb00jj80mY//9XAIaNi4uJr
n9O0eyUhdBkR6dNTw8TR/HZRK5Huhf7cCnPfQTT2TWTOtYBDo91rP3EEtgkMwqaB
vgCqXHREX2lhwqeaNZjqInZYVi3GiKpCSLAsEYHbgfVjzyZMBQhk/ZSkjAAFX53v
9kAJL7lDOlEtKoSJv2rX71HJNJLzQLpQytHFFsWE9bLR7WOOU5CiuG863hfX/tPW
IhKa0BglVxBEfT3T9rIlI8Gsl+Nu4CFVF4Hkh9ptT7IY1rZEJ51nvTFus162P4oE
OX9pHPTSbRqUEwSeg8ZkfDqN8HE4zja0GYckXSJRjCeQYZefQSlAOOo7JMB8VNIk
vUYC2wh5AGkgChQw4h5ALyrGkWXR5554xqh3R23SQIWnoxswnVHxq/3SaqaZcOD8
/fLRM8G5j6r481dkjPu8DNt0BhIedympklzZ9C4ku8EzL75iTji0gDexdbKMZCGa
UiPK3nYDs2Bjn+GNZe4ZtIx1XiH7iUQVMFLjvIyelePZdBjndRBMKBBN/3v7Oo3O
2gGo/boLgLCsM/leV+eAHne4cFHoOXluFsVB2wBPjghAC8iZpkarHUlR9imdEvZ+
BqkLguMeHxX2/S+VhADtGeIUFcI6fruxnO6T7sB91KF+0JqZALBRYy1uQEe+HamN
VFjnM6R4uqkH/xgv4Va0
=US5V
-----END PGP SIGNATURE-----

--x+6KMIRAuhnl3hBn--


--===============5741060594833806902==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5741060594833806902==--
