Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q47C7Tvg038928 for <xfs@oss.sgi.com>; Mon, 7 May 2012 07:07:29 -0500
Received: from mail.wnohang.net (wnohang.net [178.79.154.173]) by cuda.sgi.com
	with ESMTP id e25gc1VqF8GCLOXb for <xfs@oss.sgi.com>;
	Mon, 07 May 2012 05:07:27 -0700 (PDT)
Received: from localhost (unknown [122.167.119.151])
	by mail.wnohang.net (Postfix) with ESMTPSA id 6A71FF0413
	for <xfs@oss.sgi.com>; Mon,  7 May 2012 08:07:22 -0400 (EDT)
Date: Mon, 7 May 2012 17:37:18 +0530
From: Raghavendra D Prabhu <rprabhu@wnohang.net>
Subject: Re: [PATCH] [PATCH] Stop periodic syncing if filesystem is already
	shutdown.
Message-ID: <20120507120718.GA18105@Xye>
References: <a27cbce4f4b35c2a8aee1b58d88c22381fe70ccf.1336378182.git.rprabhu@wnohang.net>
MIME-Version: 1.0
In-Reply-To: <a27cbce4f4b35c2a8aee1b58d88c22381fe70ccf.1336378182.git.rprabhu@wnohang.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7334790812452526330=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--===============7334790812452526330==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bg08WKrSYDhXBjb5"
Content-Disposition: inline


--bg08WKrSYDhXBjb5
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

Apparently calling xfs_syncd_stop from xfs_sync_worker doesn't=20
work well; So I have moved it to xfs_bwrite; though with this I=20
noticed a 2-3 log force errors at flush and umount. Here is the=20
revised version.=20


 From e202a7d76d8209fd3eb70158719a65034a409168 Mon Sep 17 00:00:00 2001
Message-Id: <e202a7d76d8209fd3eb70158719a65034a409168.1336390891.git.rprabh=
u@wnohang.net>
=46rom: Raghavendra D Prabhu <rprabhu@wnohang.net>
Date: Mon, 7 May 2012 17:07:49 +0530
Subject: [PATCH] Stop periodic syncing if filesystem is already shutdown.

This is to prevent xfs_log_force from running ad-infinitum (due to xfs_sync=
) till umount if the disk has been forcefully unplugged.

This is to prevent messages like these from being displayed repeatedly.

[ 3873.009329] XFS (sdb3): xfs_log_force: error 5 returned.

Note, that even after xfs_do_force_shutdown has been called, xfs_log_force
doesn't stop till the filesystem has been unmounted (and it keeps printing
"error 5 returned" to kernel log).

To simulate it, mount an xfs filesystem located on external disk, and then =
pull
the power to the disk (non-usb powered disk).

Tested it on latest linus tree.
Now, the kernel log looks,

[  268.307303] XFS (sdb2): xfs_do_force_shutdown(0x1) called from line 1031=
 of file fs/xfs/xfs_buf.c.  Return address =3D 0xffffffff8127c13a
[  268.307318] XFS (sdb2): I/O Error Detected. Shutting down filesystem
[  268.307323] XFS (sdb2): Please umount the filesystem and rectify the pro=
blem(s)

Since, xfs_syncd_stop is already called in xfs_bwrite; the message is not
printed; also added checks in xfs_sync_worker and xfs_flush_worker to retur=
n in
this case (if they have already been entered).

Signed-off-by: Raghavendra D Prabhu <rprabhu@wnohang.net>
Tested-by: Raghavendra D Prabhu <rprabhu@wnohang.net>
  ---
---
  fs/xfs/xfs_buf.c  |    1 +
  fs/xfs/xfs_sync.c |   10 ++++++++++
  2 files changed, 11 insertions(+)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 6819b51..7bdf018 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1029,6 +1029,7 @@ xfs_bwrite(
  	if (error) {
  		xfs_force_shutdown(bp->b_target->bt_mount,
  				   SHUTDOWN_META_IO_ERROR);
+		xfs_syncd_stop(bp->b_target->bt_mount);
  	}
  	return error;
  }
diff --git a/fs/xfs/xfs_sync.c b/fs/xfs/xfs_sync.c
index 205ebcb..79745a5 100644
--- a/fs/xfs/xfs_sync.c
+++ b/fs/xfs/xfs_sync.c
@@ -460,6 +460,11 @@ xfs_sync_worker(
  					struct xfs_mount, m_sync_work);
  	int		error;
 =20
+	if (!xfs_fs_writable(mp)) {
+		xfs_err(mp, "Filesystem not writable / already shutdown.");
+		return;
+	}
+
  	if (!(mp->m_flags & XFS_MOUNT_RDONLY)) {
  		/* dgc: errors ignored here */
  		if (mp->m_super->s_frozen =3D=3D SB_UNFROZEN &&
@@ -551,6 +556,11 @@ xfs_flush_worker(
  	struct xfs_mount *mp =3D container_of(work,
  					struct xfs_mount, m_flush_work);
 =20
+	if (!xfs_fs_writable(mp)) {
+		xfs_err(mp, "Filesystem not writable / already shutdown.");
+		return;
+	}
+
  	xfs_sync_data(mp, SYNC_TRYLOCK);
  	xfs_sync_data(mp, SYNC_TRYLOCK | SYNC_WAIT);
  }
--=20
1.7.10.1



* On Mon, May 07, 2012 at 02:44:07PM +0530, raghu.prabhu13@gmail.com <raghu=
=2Eprabhu13@gmail.com> wrote:
>From: Raghavendra D Prabhu <rprabhu@wnohang.net>
>
>This is to prevent syncing from running ad-infinitum till umount if the di=
sk has been forcefully unplugged.
>
>This is to prevent messages like these from being displayed.
>
>=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>[ 3816.416570] XFS (sdb3): xfs_do_force_shutdown(0x1) called from line 103=
1 of file fs/xfs/xfs_buf.c.  Return address =3D 0xffffffff8127c13a
>[ 3816.416586] XFS (sdb3): I/O Error Detected. Shutting down filesystem
>[ 3816.416592] XFS (sdb3): Please umount the filesystem and rectify the pr=
oblem(s)
>[ 3842.941953] XFS (sdb3): xfs_log_force: error 5 returned.
>[ 3873.009329] XFS (sdb3): xfs_log_force: error 5 returned.
>[ 3878.913310] XFS (sdb3): xfs_log_force: error 5 returned.
>[ 3878.913322] XFS (sdb3): xfs_do_force_shutdown(0x1) called from line 103=
1 of file fs/xfs/xfs_buf.c.  Return address =3D 0xffffffff8127c13a
>[ 3878.913350] XFS (sdb3): xfs_log_force: error 5 returned.
>[ 3878.913362] XFS (sdb3): xfs_log_force: error 5 returned.
>=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
>Note, that even after xfs_do_force_shutdown has been called, xfs_log_force
>doesn't stop till the filesystem has been unmounted (and it keeps printing
>"error 5 returned" to kernel log).
>
>To simulate it, mount an xfs filesystem located on external disk, and then=
 pull
>the power to the disk (non-usb powered disk).
>
>Tested it on latest linus tree.
>Now, the kernel log looks,
>
>[ 2477.305280] XFS (sdc3): xfs_do_force_shutdown(0x1) called from line 103=
1 of file fs/xfs/xfs_buf.c.  Return address =3D 0xffffffff8127c13a
>[ 2477.305295] XFS (sdc3): I/O Error Detected. Shutting down filesystem
>[ 2477.305300] XFS (sdc3): Please umount the filesystem and rectify the pr=
oblem(s)
>[ 2477.305588] XFS (sdc2): xfs_do_force_shutdown(0x1) called from line 103=
1 of file fs/xfs/xfs_buf.c.  Return address =3D 0xffffffff8127c13a
>[ 2477.305600] XFS (sdc2): I/O Error Detected. Shutting down filesystem
>[ 2477.305604] XFS (sdc2): Please umount the filesystem and rectify the pr=
oblem(s)
>[ 2487.810718] XFS (sdc3): xfs_log_force: error 5 returned.
>[ 2487.810729] XFS (sdc3): xfs_do_force_shutdown(0x1) called from line 103=
1 of file fs/xfs/xfs_buf.c.  Return address =3D 0xffffffff8127c13a
>[ 2487.812981] XFS (sdc2): xfs_log_force: error 5 returned.
>[ 2487.812991] XFS (sdc2): xfs_do_force_shutdown(0x1) called from line 103=
1 of file fs/xfs/xfs_buf.c.  Return address =3D 0xffffffff8127c13a
>[ 2489.420042] XFS (sdc3): Filesystem not writable / already shutdown.
>[ 2490.955438] XFS (sdc2): Filesystem not writable / already shutdown.
>
>Signed-off-by: Raghavendra D Prabhu <rprabhu@wnohang.net>
>Tested-by: Raghavendra D Prabhu <rprabhu@wnohang.net>
>---
> fs/xfs/xfs_sync.c |   12 ++++++++++++
> 1 file changed, 12 insertions(+)
>
>diff --git a/fs/xfs/xfs_sync.c b/fs/xfs/xfs_sync.c
>index 205ebcb..7ec412c 100644
>--- a/fs/xfs/xfs_sync.c
>+++ b/fs/xfs/xfs_sync.c
>@@ -460,6 +460,12 @@ xfs_sync_worker(
> 					struct xfs_mount, m_sync_work);
> 	int		error;
>
>+	if (!xfs_fs_writable(mp)) {
>+		xfs_err(mp, "Filesystem not writable / already shutdown.");
>+		xfs_syncd_stop(mp);
>+		return;
>+	}
>+
> 	if (!(mp->m_flags & XFS_MOUNT_RDONLY)) {
> 		/* dgc: errors ignored here */
> 		if (mp->m_super->s_frozen =3D=3D SB_UNFROZEN &&
>@@ -551,6 +557,12 @@ xfs_flush_worker(
> 	struct xfs_mount *mp =3D container_of(work,
> 					struct xfs_mount, m_flush_work);
>
>+	if (!xfs_fs_writable(mp)) {
>+		xfs_err(mp, "Filesystem not writable / already shutdown.");
>+		xfs_syncd_stop(mp);
>+		return;
>+	}
>+
> 	xfs_sync_data(mp, SYNC_TRYLOCK);
> 	xfs_sync_data(mp, SYNC_TRYLOCK | SYNC_WAIT);
> }
>--=20
>1.7.10.1
>
>_______________________________________________
>xfs mailing list
>xfs@oss.sgi.com
>http://oss.sgi.com/mailman/listinfo/xfs




Regards,
--=20
Raghavendra Prabhu
GPG Id : 0xD72BE977
Fingerprint: B93F EBCB 8E05 7039 CD3C A4B8 A616 DCA1 D72B E977
www: wnohang.net

--bg08WKrSYDhXBjb5
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQEcBAEBAgAGBQJPp7r2AAoJEKYW3KHXK+l3YEgH/jJDdTiMwGZfjyJF49PpmJms
1j+pvnZ96owjXeU1cpn7w7FCb/VRfq3b1z/1Re1vqrzEon1e7s+NVWi94RB3G+hK
0H6rNz3b4s1nZlaWKZBRzWjUzzrbZou6+4Ij6PWF0Dv+eo27KSTX5PxUnLOfweJv
udGVpatJHg6fAmF4w8IoXh9KRI7hVz0pi2VXp7amJMf0664d7JBrrg+3O2vLpIWK
8o4Sxw+49KdNAo3+nmgQ5kSmjme39UwJCIVE/IDQgR2jqIbw3XiehaMIeq0gIx53
UOukDrvlRY00LJ1W/LfmwmvffdKYL/AuS+SP3AA9/XOgNi/TeAzK8wLbAaXOg9I=
=wN7S
-----END PGP SIGNATURE-----

--bg08WKrSYDhXBjb5--


--===============7334790812452526330==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7334790812452526330==--
