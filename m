Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2ED8voa204756 for <xfs@oss.sgi.com>; Wed, 14 Mar 2012 08:09:01 -0500
Received: from v3-1046.systemlinux.org (systemlinux.org [79.140.41.46]) by
	cuda.sgi.com with ESMTP id faWYzl0jZ0mREyAq for
	<xfs@oss.sgi.com>; Wed, 14 Mar 2012 06:08:49 -0700 (PDT)
Date: Wed, 14 Mar 2012 14:09:02 +0100
From: Andre Noll <maan@systemlinux.org>
Subject: display project quota as user
Message-ID: <20120314130902.GA26508@systemlinux.org>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7605837670671961118=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: =?utf-8?B?QW5kcsOpIEMu?= Stiel <andre.stiel@tuebingen.mpg.de>


--===============7605837670671961118==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PNTmBPCT7hxwcZjr"
Content-Disposition: inline


--PNTmBPCT7hxwcZjr
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Simple question: Can non-privileged users display XFS project quotas?

Currently the command

	xfs_quota -c 'quota -p 42'

fails when executed as a non-root user due to quotactl(Q_XGETQUOTA,...)
returning EPERM. The problem seems to be that fs/quota/quota.c has no
knowledge of project quotas at all.

The proof-of-concept patch below makes quotactl(Q_XGETQUOTA,...)
succeed for any user when called with type =3D=3D XQM_PRJQUOTA. However,
relaxing the permission checks like this might not please everybody,
changes semantics of an existing API and adds the XFS specific constant
XQM_PRJQUOTA to fs/quota.c. So I'm not even asking to apply something
like that.

Is there a better way to allow users to display project quotas?

Thanks
Andre
---

diff --git a/fs/quota/quota.c b/fs/quota/quota.c
index fc2c438..010763d 100644
--- a/fs/quota/quota.c
+++ b/fs/quota/quota.c
@@ -33,7 +33,8 @@ static int check_quotactl_permission(struct super_block *=
sb, int type, int cmd,
 	case Q_GETQUOTA:
 	case Q_XGETQUOTA:
 		if ((type =3D=3D USRQUOTA && current_euid() =3D=3D id) ||
-		    (type =3D=3D GRPQUOTA && in_egroup_p(id)))
+		    (type =3D=3D GRPQUOTA && in_egroup_p(id)) ||
+		    (type =3D=3D XQM_PRJQUOTA))
 			break;
 		/*FALLTHROUGH*/
 	default:
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--PNTmBPCT7hxwcZjr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk9gmG4ACgkQWto1QDEAkw8MygCfVUklgw57FKSreTY0gYV96FVO
5OwAoITjEUj2niy1WEwA2pUMyWnzcV9d
=g6pe
-----END PGP SIGNATURE-----

--PNTmBPCT7hxwcZjr--


--===============7605837670671961118==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7605837670671961118==--
