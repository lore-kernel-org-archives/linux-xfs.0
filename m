Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q479fZT6008557 for <xfs@oss.sgi.com>; Mon, 7 May 2012 04:41:35 -0500
Received: from mail.wnohang.net (wnohang.net [178.79.154.173]) by cuda.sgi.com
	with ESMTP id 7zmR4T8lNGXvz3J6 for <xfs@oss.sgi.com>;
	Mon, 07 May 2012 02:41:34 -0700 (PDT)
Received: from localhost (unknown [122.167.119.151])
	by mail.wnohang.net (Postfix) with ESMTPSA id C530EF0413
	for <xfs@oss.sgi.com>; Mon,  7 May 2012 05:41:31 -0400 (EDT)
Date: Mon, 7 May 2012 15:11:28 +0530
From: Raghavendra D Prabhu <rprabhu@wnohang.net>
Subject: Re: [PATCH] [PATCH] Stop periodic syncing if filesystem is already
	shutdown.
Message-ID: <20120507094128.GA13925@Xye>
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
Content-Type: multipart/mixed; boundary="===============3150362741345724566=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--===============3150362741345724566==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OwLcNYc0lM97+oe1"
Content-Disposition: inline


--OwLcNYc0lM97+oe1
Content-Type: multipart/mixed; boundary="5vNYLRcllDrimb99"
Content-Disposition: inline


--5vNYLRcllDrimb99
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

Somehow git send-email sent with empty body, I have attached the=20
patch.

* On Mon, May 07, 2012 at 02:44:07PM +0530, raghu.prabhu13@gmail.com <raghu=
=2Eprabhu13@gmail.com> wrote:




Regards,
--=20
Raghavendra Prabhu
GPG Id : 0xD72BE977
Fingerprint: B93F EBCB 8E05 7039 CD3C A4B8 A616 DCA1 D72B E977
www: wnohang.net

--5vNYLRcllDrimb99
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0001-PATCH-Stop-periodic-syncing-if-filesystem-is-already.patch"
Content-Transfer-Encoding: quoted-printable

=46rom a27cbce4f4b35c2a8aee1b58d88c22381fe70ccf Mon Sep 17 00:00:00 2001
Message-Id: <a27cbce4f4b35c2a8aee1b58d88c22381fe70ccf.1336378182.git.rprabh=
u@wnohang.net>
=46rom: Raghavendra D Prabhu <rprabhu@wnohang.net>
Date: Mon, 7 May 2012 13:33:55 +0530
Subject: [PATCH] Stop periodic syncing if filesystem is already
 shutdown.

This is to prevent syncing from running ad-infinitum till umount if the dis=
k has been forcefully unplugged.

This is to prevent messages like these from being displayed.

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[ 3816.416570] XFS (sdb3): xfs_do_force_shutdown(0x1) called from line 1031=
 of file fs/xfs/xfs_buf.c.  Return address =3D 0xffffffff8127c13a
[ 3816.416586] XFS (sdb3): I/O Error Detected. Shutting down filesystem
[ 3816.416592] XFS (sdb3): Please umount the filesystem and rectify the pro=
blem(s)
[ 3842.941953] XFS (sdb3): xfs_log_force: error 5 returned.
[ 3873.009329] XFS (sdb3): xfs_log_force: error 5 returned.
[ 3878.913310] XFS (sdb3): xfs_log_force: error 5 returned.
[ 3878.913322] XFS (sdb3): xfs_do_force_shutdown(0x1) called from line 1031=
 of file fs/xfs/xfs_buf.c.  Return address =3D 0xffffffff8127c13a
[ 3878.913350] XFS (sdb3): xfs_log_force: error 5 returned.
[ 3878.913362] XFS (sdb3): xfs_log_force: error 5 returned.
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

Note, that even after xfs_do_force_shutdown has been called, xfs_log_force
doesn't stop till the filesystem has been unmounted (and it keeps printing
"error 5 returned" to kernel log).

To simulate it, mount an xfs filesystem located on external disk, and then =
pull
the power to the disk (non-usb powered disk).

Tested it on latest linus tree.=20
Now, the kernel log looks,

[ 2477.305280] XFS (sdc3): xfs_do_force_shutdown(0x1) called from line 1031=
 of file fs/xfs/xfs_buf.c.  Return address =3D 0xffffffff8127c13a
[ 2477.305295] XFS (sdc3): I/O Error Detected. Shutting down filesystem
[ 2477.305300] XFS (sdc3): Please umount the filesystem and rectify the pro=
blem(s)
[ 2477.305588] XFS (sdc2): xfs_do_force_shutdown(0x1) called from line 1031=
 of file fs/xfs/xfs_buf.c.  Return address =3D 0xffffffff8127c13a
[ 2477.305600] XFS (sdc2): I/O Error Detected. Shutting down filesystem
[ 2477.305604] XFS (sdc2): Please umount the filesystem and rectify the pro=
blem(s)
[ 2487.810718] XFS (sdc3): xfs_log_force: error 5 returned.
[ 2487.810729] XFS (sdc3): xfs_do_force_shutdown(0x1) called from line 1031=
 of file fs/xfs/xfs_buf.c.  Return address =3D 0xffffffff8127c13a
[ 2487.812981] XFS (sdc2): xfs_log_force: error 5 returned.
[ 2487.812991] XFS (sdc2): xfs_do_force_shutdown(0x1) called from line 1031=
 of file fs/xfs/xfs_buf.c.  Return address =3D 0xffffffff8127c13a
[ 2489.420042] XFS (sdc3): Filesystem not writable / already shutdown.
[ 2490.955438] XFS (sdc2): Filesystem not writable / already shutdown.

Signed-off-by: Raghavendra D Prabhu <rprabhu@wnohang.net>
Tested-by: Raghavendra D Prabhu <rprabhu@wnohang.net>
---
 fs/xfs/xfs_sync.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/fs/xfs/xfs_sync.c b/fs/xfs/xfs_sync.c
index 205ebcb..7ec412c 100644
--- a/fs/xfs/xfs_sync.c
+++ b/fs/xfs/xfs_sync.c
@@ -460,6 +460,12 @@ xfs_sync_worker(
 					struct xfs_mount, m_sync_work);
 	int		error;
=20
+	if (!xfs_fs_writable(mp)) {
+		xfs_err(mp, "Filesystem not writable / already shutdown.");
+		xfs_syncd_stop(mp);
+		return;
+	}
+
 	if (!(mp->m_flags & XFS_MOUNT_RDONLY)) {
 		/* dgc: errors ignored here */
 		if (mp->m_super->s_frozen =3D=3D SB_UNFROZEN &&
@@ -551,6 +557,12 @@ xfs_flush_worker(
 	struct xfs_mount *mp =3D container_of(work,
 					struct xfs_mount, m_flush_work);
=20
+	if (!xfs_fs_writable(mp)) {
+		xfs_err(mp, "Filesystem not writable / already shutdown.");
+		xfs_syncd_stop(mp);
+		return;
+	}
+
 	xfs_sync_data(mp, SYNC_TRYLOCK);
 	xfs_sync_data(mp, SYNC_TRYLOCK | SYNC_WAIT);
 }
--=20
1.7.10.1


--5vNYLRcllDrimb99--

--OwLcNYc0lM97+oe1
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQEcBAEBAgAGBQJPp5jIAAoJEKYW3KHXK+l3atoIAKIBobbqk8lH6YDEiQjaWMyU
5D/Q1S3I5ZbU4fNWwUAo4klk3VVoMJboFXhiE6eX4VzR9XmjMN2LAKqW8G+GajM7
NhAeTgQaqJ3SYdvjlRGXQGnFfZp4TfpEHprKyevHPwq13dI+/ZDV+pbdg6PjFl1p
i3tL8Ib0CkJ2yGKpd//gPJPydFz2h/E3gWaikOEs2D94RW2HIGExuOm/wwZ/AO7u
o73/3S3S+5MRvg2DTmd4ieyNXynIPHMfUbsYjXvzSAhxGxNwmIpA4aTs9WaCYNWa
sF58QotZ2YMR9FMG9YArq1+pg+JS9cElVjsRm+nFF9+ZQUxieol1e5DpNkgUAco=
=8qDS
-----END PGP SIGNATURE-----

--OwLcNYc0lM97+oe1--


--===============3150362741345724566==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3150362741345724566==--
