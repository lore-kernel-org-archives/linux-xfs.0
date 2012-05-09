Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q49KYoHj126702 for <xfs@oss.sgi.com>; Wed, 9 May 2012 15:34:50 -0500
Received: from mail-pz0-f53.google.com (mail-pz0-f53.google.com
	[209.85.210.53]) by cuda.sgi.com with ESMTP id EvqAxrz5XHHKvZzG
	(version=TLSv1 cipher=RC4-MD5 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 09 May 2012 13:34:49 -0700 (PDT)
Received: by dadg9 with SMTP id g9so906255dad.26
	for <xfs@oss.sgi.com>; Wed, 09 May 2012 13:34:48 -0700 (PDT)
Date: Thu, 10 May 2012 02:04:44 +0530
From: Raghavendra D Prabhu <raghu.prabhu13@gmail.com>
Subject: Re: Re: [PATCH] [PATCH] Stop periodic syncing if filesystem is
	already shutdown.
Message-ID: <20120509203444.GB29360@Xye>
References: <a27cbce4f4b35c2a8aee1b58d88c22381fe70ccf.1336378182.git.rprabhu@wnohang.net>
	<20120507235321.GD5091@dastard> <20120509200746.GA29360@Xye>
MIME-Version: 1.0
In-Reply-To: <20120509200746.GA29360@Xye>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1500695536806971499=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com


--===============1500695536806971499==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7ZAtKRhVyVSsbBD2"
Content-Disposition: inline


--7ZAtKRhVyVSsbBD2
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

Resent with changes I had mentioned earlier.

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

[PATCH] This is to prevent xfs_log_force from running ad-infinitum (due to =
xfs_sync) till umount if the disk has been forcefully unplugged.

This is also to prevent messages like these from being displayed repeatedly.

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

Signed-off-by: Raghavendra D Prabhu <rprabhu@wnohang.net>
Tested-by: Raghavendra D Prabhu <rprabhu@wnohang.net>
---
---
  fs/xfs/xfs_log.c |    7 +++++++
  1 file changed, 7 insertions(+)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 6db1fef..e4192b2 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -2932,6 +2932,13 @@ xfs_log_force(
  {
  	int	error;
 =20
+	/*
+	 * No need to printk here since xfs_bwrite already printks about xfs
+	 * shutdown if it has shutdown already.
+	 */
+	if (XFS_FORCED_SHUTDOWN(mp))
+		return;
+
  	error =3D _xfs_log_force(mp, flags, NULL);
  	if (error)
  		xfs_warn(mp, "%s: error %d returned.", __func__, error);
--=20
1.7.10.1


* On Thu, May 10, 2012 at 01:37:46AM +0530, Raghavendra D Prabhu <raghu.pra=
bhu13@gmail.com> wrote:
>
>Hi,
>
>
>* On Tue, May 08, 2012 at 09:53:21AM +1000, Dave Chinner <david@fromorbit.=
com> wrote:
>>On Mon, May 07, 2012 at 02:44:07PM +0530, raghu.prabhu13@gmail.com wrote:
>>>From: Raghavendra D Prabhu <rprabhu@wnohang.net>
>>>
>>>This is to prevent syncing from running ad-infinitum till umount if the =
disk has been forcefully unplugged.
>>>
>>>This is to prevent messages like these from being displayed.
>>.....
>>>---
>>> fs/xfs/xfs_sync.c |   12 ++++++++++++
>>> 1 file changed, 12 insertions(+)
>>>
>>>diff --git a/fs/xfs/xfs_sync.c b/fs/xfs/xfs_sync.c
>>>index 205ebcb..7ec412c 100644
>>>--- a/fs/xfs/xfs_sync.c
>>>+++ b/fs/xfs/xfs_sync.c
>>>@@ -460,6 +460,12 @@ xfs_sync_worker(
>>> 					struct xfs_mount, m_sync_work);
>>> 	int		error;
>>>
>>>+	if (!xfs_fs_writable(mp)) {
>>>+		xfs_err(mp, "Filesystem not writable / already shutdown.");
>>>+		xfs_syncd_stop(mp);
>>>+		return;
>>>+	}
>>>+
>>
>>That is going to kill the xfssyncd on read only and frozen
>>filesystems as well as shutdowns, so this is certainly not correct.
>>The xfs_sync_worker should continue to run until the filesystem is
>>unmounted, even if it does nothing when it runs.
>
>Yes, in the next patch I had sent --=20
>http://article.gmane.org/gmane.comp.file-systems.xfs.general/45568 --=20
>I removed xfs_syncd_stop from there and added it under xfs_bwrite.
>
>(PS: Adding xfs_syncd_stop in xfs_sync_worker was a very bad decision=20
>- it sent few of my kworkers to 'D' state and nearly corrupted that=20
>fs)
>
>
>>
>>Indeed, all that is needed in xfs_sync_worker() is this:
>>
>>-	if (!(mp->m_flags & XFS_MOUNT_RDONLY)) {
>>+	if (!xfs_fs_writable(mp)) {
>>
>>and the error message won't appear. It fixes the problem for the
>>shutdown case, as well as handles frozen and read-only filesystems
>>correctly.
>                 I realized from your earlier comment that, calling       =
 =20
>xfs_syncd_stop under xfs_bwrite won't be good either;
>        so I was thinking of just checking for
>
>        XFS_FORCED_SHUTDOWN(mp) in xfs_log_force and bailing out        =
=20
>if already shutdown.
>
>        which should take care of xfs_sync_worker,        =20
>xfs_flush_worker, xfs_iflush and xfs_unmountfs
>
>
>    Does this sound good?
>
>>
>>> 		/* dgc: errors ignored here */
>>> 		if (mp->m_super->s_frozen =3D=3D SB_UNFROZEN &&
>>>@@ -551,6 +557,12 @@ xfs_flush_worker(
>>> 	struct xfs_mount *mp =3D container_of(work,
>>> 					struct xfs_mount, m_flush_work);
>>>
>>>+	if (!xfs_fs_writable(mp)) {
>>>+		xfs_err(mp, "Filesystem not writable / already shutdown.");
>>>+		xfs_syncd_stop(mp);
>>>+		return;
>>>+	}
>>>+
>>> 	xfs_sync_data(mp, SYNC_TRYLOCK);
>>> 	xfs_sync_data(mp, SYNC_TRYLOCK | SYNC_WAIT);
>>
>>This is not necessary, either, because xfs_sync_data() has shutdown
>>checks and xfs_flush_worker() should never be called on a shutdown
>>filesystem....
>Yeah, I realized that (sent a patch after this=20
>http://article.gmane.org/gmane.comp.file-systems.xfs.general/45568).
>>
>>Cheers,
>>
>>Dave.
>>--=20
>>Dave Chinner
>>david@fromorbit.com
>>
>
>
>
>
>
>
>
>
>Regards,
>--=20
>Raghavendra Prabhu
>GPG Id : 0xD72BE977
>Fingerprint: B93F EBCB 8E05 7039 CD3C A4B8 A616 DCA1 D72B E977
>www: wnohang.net






Regards,
--=20
Raghavendra Prabhu
GPG Id : 0xD72BE977
Fingerprint: B93F EBCB 8E05 7039 CD3C A4B8 A616 DCA1 D72B E977
www: wnohang.net

--7ZAtKRhVyVSsbBD2
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQEcBAEBAgAGBQJPqtTkAAoJEKYW3KHXK+l3EOMIAKlkDGxpHbQbs6xqmprusUIH
r5hUXdQFL5y5qLHxccgbPSMyXBBd7yaTbNC35pSWJ4pG3mgXi35Bt3aiwv7UmfC5
7prKfHZV7hpI6hM3H0EvJbMIvKB2ChPg8mqPn/7+W6LnOwW6xmI+3xlK/HJTIEVE
3rOyOqjRpc6CU9axj/AXvggF5OFGObYMq/rIk1/IUE+F97XpsDpUzXAXhWPm3rKE
GZegpb1tkIMmx3jroTIv9kY+cc1NA9fiV8HWWub13J458qo38/Cl/t5qcEg4Hrot
VZoa+B3kFPlOmwSMrxVv3YHMVoicgkIrGd5qcP8rY8EfXwag7Y+n1udl4+bBzW0=
=dXSY
-----END PGP SIGNATURE-----

--7ZAtKRhVyVSsbBD2--


--===============1500695536806971499==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1500695536806971499==--
