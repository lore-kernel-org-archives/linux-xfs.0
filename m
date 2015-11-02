Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 44F057F66
	for <xfs@oss.sgi.com>; Sun,  1 Nov 2015 21:53:57 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id CB835AC002
	for <xfs@oss.sgi.com>; Sun,  1 Nov 2015 19:53:56 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	HTTXkLbZOmcS8soy for <xfs@oss.sgi.com>;
	Sun, 01 Nov 2015 19:53:54 -0800 (PST)
Received: from dave by dastard with local (Exim 4.80)
	(envelope-from <david@fromorbit.com>) id 1Zt6BF-00018G-3l
	for xfs@oss.sgi.com; Mon, 02 Nov 2015 14:53:13 +1100
Date: Mon, 2 Nov 2015 14:53:13 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfs: for-next branch updated to f108bf2
Message-ID: <20151102035313.GZ19199@dastard>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============9109870644084264330=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--===============9109870644084264330==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cmJC7u66zC7hs+87"
Content-Disposition: inline


--cmJC7u66zC7hs+87
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Folks,

The for-next branch of the xfs kernel repository at

git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git

has just been updated.

The new head of the for-next branch is commit:

f108bf2 Merge branch 'xfs-misc-fixes-for-4.4-2' into for-next

New Commits:

Andreas Gruenbacher (2):
      [1c99cfd] xfs: Validate the length of on-disk ACLs
      [80e0f22] xfs: Plug memory leak in xfs_attrmulti_attr_set

Brian Foster (1):
      [6caa105] xfs: invalidate cached acl if set directly via xattr

Dave Chinner (1):
      [f108bf2] Merge branch 'xfs-misc-fixes-for-4.4-2' into for-next

Jiri Kosina (1):
      [24ba16b] xfs: clear PF_NOFREEZE for xfsaild kthread


Code Diffstat:

 fs/xfs/libxfs/xfs_format.h |  8 ++++++--
 fs/xfs/xfs_acl.c           | 13 ++++++++-----
 fs/xfs/xfs_ioctl.c         |  5 ++++-
 fs/xfs/xfs_trans_ail.c     |  1 +
 fs/xfs/xfs_xattr.c         | 19 +++++++++++++++++--
 5 files changed, 36 insertions(+), 10 deletions(-)
--=20
Dave Chinner
david@fromorbit.com

--cmJC7u66zC7hs+87
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJWNt4oAAoJEK3oKUf0dfod4sIP/0U5Sb60erzFD4oIeXDZmwef
nDYV+SCt+vRuqKb8r2Zbilse3pHViiZJgRUKli9x/suepe2eBGARsv5xTp9qPZin
9HMnRl/KCKxZMtd4N/eR4YaDntdjoN8UIiMgASEuriWmGxtZTJ+LIYpdR7Us159T
plrthX2klT3kIKY4x8hZpEHI7O9RJYzUQ59ZzM8zaZrekoh/nyKt1/wCprSr6TLv
fjt2zZqJKIvotdmI35mLaVCkljyvxHk0oSIxLZDB5U7BvZULThwN9hExw6UgIxH3
MrjE367z6ltDqKn7CkDYzcGpaKJ4YNmaaq4cuHS8io/XitR/7qUSR12PbhP+P7Ic
PS1pRwKq5QOAG0IwaZ2vBvBWwB234HDO8MpeD4GxRgov5PBjI+EkGezj7LqwJFEI
07R5QS9j6IPzNR5M2dZEGCjC4rk/GFryUEqXqQ574iY5sdN9FSIB5zYg2kqAEFj1
YTY4RjZ+xcnRXw2IRBcbYYXJ2WbdtKY0XNwHTEC/vT1FDx6H0ifjMFDrggPJTjzz
91bOl/k7fvrgzvUflvnayKn8IZxnsPMZT/ctA2c7pAPLLVukY0PFWwmmWi6vkVbJ
MOKMpPHBE5fUwnGfH75xcNrVd898hxucoBP1G87cQcaGzUa7agrsyrAwlV72J5KO
p/9WMS/gwMRDzM5y4oZa
=Dp/c
-----END PGP SIGNATURE-----

--cmJC7u66zC7hs+87--


--===============9109870644084264330==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============9109870644084264330==--
