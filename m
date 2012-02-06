Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q169BAon117114 for <xfs@oss.sgi.com>; Mon, 6 Feb 2012 03:11:10 -0600
Date: Mon, 6 Feb 2012 14:41:00 +0530
From: Raghavendra D Prabhu <raghu.prabhu13@gmail.com>
Subject: Re: [PATCH][RFC] XFS: Fix mem leak and possible NULL deref in
	xfs_setattr_nonsize()
Message-ID: <20120206091100.GA4350@Xye>
References: <alpine.LNX.2.00.1202052220390.32529@swampdragon.chaosbits.net>
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1202052220390.32529@swampdragon.chaosbits.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1711330231478756467=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Jesper Juhl <jj@chaosbits.net>
Cc: xfs-masters@oss.sgi.com, Ben Myers <bpm@sgi.com>, Alex Elder <elder@kernel.org>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com


--===============1711330231478756467==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HcAYCG3uE/tztfnV"
Content-Disposition: inline


--HcAYCG3uE/tztfnV
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,
=20

* On Sun, Feb 05, 2012 at 10:23:44PM +0100, Jesper Juhl <jj@chaosbits.net> =
wrote:
>In xfs_setattr_nonsize(), xfs_trans_alloc() gets its memory from
>_xfs_trans_alloc() which gets it from kmem_zone_zalloc() which may
>fail and return NULL. So this:
>
>	tp =3D xfs_trans_alloc(mp, XFS_TRANS_SETATTR_NOT_SIZE);
>
>may result in a NULL 'tp'.
>If it does, then the call:
>
>	error =3D xfs_trans_reserve(tp, 0, XFS_ICHANGE_LOG_RES(mp), 0, 0, 0);
>
>with a NULL 'tp' will explode, since xfs_trans_reserve() dereferences
>its first argument unconditionally.
>
>And if the memory allocation for 'tp' goes well (and thus
>xfs_trans_reserve() does not explode) then we may leak the memory
>allocated to 'tp' if xfs_trans_reserve() returns error.
>
>I believe this patch should fix both issues, but I'm not intimate with
>the XFS code at all, so there can easily be something I overlooked or
>something that should be done differently than what I did.
>
>Signed-off-by: Jesper Juhl <jj@chaosbits.net>
>---
> fs/xfs/xfs_iops.c |    7 ++++++-
> 1 files changed, 6 insertions(+), 1 deletions(-)
>
> Note:
>  Please review carefully before applying.
>  Especially since I don't currently have any XFS filesystems to test
>  this on, nor any clear idea of a good way to actually test this if I
>  had. So this patch is compile tested only on my end.
>
>diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
>index ab30253..194c9d7 100644
>--- a/fs/xfs/xfs_iops.c
>+++ b/fs/xfs/xfs_iops.c
>@@ -575,9 +575,14 @@ xfs_setattr_nonsize(
> 	}
>
> 	tp =3D xfs_trans_alloc(mp, XFS_TRANS_SETATTR_NOT_SIZE);
>+	if (!tp)
>+		goto out_dqrele;
>+
> 	error =3D xfs_trans_reserve(tp, 0, XFS_ICHANGE_LOG_RES(mp), 0, 0, 0);
>-	if (error)
>+	if (error) {
>+		xfs_trans_cancel(tp, 0);
> 		goto out_dqrele;
>+	}
>
> 	xfs_ilock(ip, XFS_ILOCK_EXCL);
>
>--=20
>1.7.9
>
>
>Please CC me on replies.
>
>--=20
>Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
>Don't top-post http://www.catb.org/jargon/html/T/top-post.html
>Plain text mails only, please.
>
>_______________________________________________
>xfs mailing list
>xfs@oss.sgi.com
>http://oss.sgi.com/mailman/listinfo/xfs

The first one won't be triggered because kmem_zone_alloc (the=20
last one in call chain) checks for=20

     if (ptr || (flags & (KM_MAYFAIL|KM_NOSLEEP)))

whereas xfs_trans_alloc  calls _xfs_trans_alloc with KM_SLEEP,=20
also all other callers of _xfs_trans_alloc call it with KM_SLEEP=20
(except one which calls with KM_NOFS), so it looks like we are=20
safe there, it keeps spinning till it finds mem.


As far as second one is concerned, looks fine, though this one=20
should also do the same.

diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index ab30253..d331f5b 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -730,9 +730,9 @@ xfs_setattr_nonsize(
         return 0;

out_trans_cancel:
-       xfs_trans_cancel(tp, 0);
         xfs_iunlock(ip, XFS_ILOCK_EXCL);
out_dqrele:
+       xfs_trans_cancel(tp, 0);
         xfs_qm_dqrele(udqp);
         xfs_qm_dqrele(gdqp);
         return error;



Regards,
--=20
Raghavendra Prabhu
GPG Id : 0xD72BE977
Fingerprint: B93F EBCB 8E05 7039 CD3C A4B8 A616 DCA1 D72B E977
www: wnohang.net

--HcAYCG3uE/tztfnV
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQEcBAEBAgAGBQJPL5kkAAoJEKYW3KHXK+l3yjEH/01m6573on8Hc54IpbzsJYA/
WQ3wDy9fL2ZF5tqXc5aDyOPKkvAdVJZibkSmOhfPpiRYVubrJPD+6Ws0ck/MOeY5
jFPwWW7u6fhy7CZ2+fOI3iulEnVFXQYpRBFdbLIZHo1Z0Q+y0bNhQlfopHi/vFqw
/dz/ut9OAxR3ccTkVhY5MztAo93qiLdccQBWJkJy5Jxflr8QaYpGFUZEY6QZTh88
eLZw7UQKBOpb10/hMRxTG5dw02mB5uSLMDrXQ3QWhTcnNm05mxG2YCVQIO7YFMpe
nYsU2ba1twc6UPVB6zJAn1cbcrqii94OzIM20PL1SGnCnfyDbURt57edqqDHhRo=
=IWUX
-----END PGP SIGNATURE-----

--HcAYCG3uE/tztfnV--


--===============1711330231478756467==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1711330231478756467==--
