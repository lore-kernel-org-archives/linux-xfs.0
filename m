Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6LAonYe158145 for <xfs@oss.sgi.com>; Tue, 21 Jul 2009 05:50:50 -0500
Received: from mail.michael-prokop.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B64A71D4DF71
	for <xfs@oss.sgi.com>; Tue, 21 Jul 2009 03:51:29 -0700 (PDT)
Received: from mail.michael-prokop.at (mail.michael-prokop.at [88.198.6.110])
	by cuda.sgi.com with ESMTP id uZ13eM0jYn5cTto9 for
	<xfs@oss.sgi.com>; Tue, 21 Jul 2009 03:51:29 -0700 (PDT)
Received: from mail.michael-prokop.at (grmlvrs [127.0.0.1])
	by mail.michael-prokop.at (Postfix) with ESMTP id 021733BC007
	for <xfs@oss.sgi.com>; Tue, 21 Jul 2009 12:51:28 +0200 (CEST)
Received: from localhost (grmlvrs [127.0.0.1])
	by mail.michael-prokop.at (Postfix) with ESMTP id 9531D3BC007
	for <xfs@oss.sgi.com>; Tue, 21 Jul 2009 12:51:20 +0200 (CEST)
Date: Tue, 21 Jul 2009 12:51:20 +0200
From: Michael Prokop <mika@grml.org>
Subject: xfs tries to write on readonly device on unmount
Message-ID: <2009-07-21T12-28-50@devnull.michael-prokop.at>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5911364890997924108=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--===============5911364890997924108==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qyHYMwAXsHLOQihY"
Content-Disposition: inline


--qyHYMwAXsHLOQihY
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

This issue might be related to
http://oss.sgi.com/bugzilla/show_bug.cgi?id=3D413

A XFS partition is set to read-only mode (using 'blockdev --setro')
and mounted. As soon as I *un*mount the filesystem there seem to
happen write requests.

I've a Tableau Forensic Bridge=B9 which avoids the write requests and
attached it to a Linux live-system running kernel 2.6.28 inside
VMware and Virtualbox. I can easily reproduce the problem.

Full debugging details:

# vol_id /dev/sdb2
ID_FS_USAGE=3Dfilesystem
ID_FS_TYPE=3Dxfs
ID_FS_VERSION=3D
ID_FS_UUID=3D884331b1-0d0b-4314-abc8-46f7ddb96c68
ID_FS_UUID_ENC=3D884331b1-0d0b-4314-abc8-46f7ddb96c68
ID_FS_LABEL=3D
ID_FS_LABEL_ENC=3D
# blockdev --getro /dev/sdb2
1
# logger before-mounting
# sysctl -w vm.block_dump=3D1
vm.block_dump =3D 1
# mount /dev/sdb2 /mnt/test
mount: block device /dev/sdb2 is write-protected, mounting read-only
# logger finished-mounting-now-unmounting
# umount /mnt/test
# logger finished-unmounting

Quoting /var/log/syslog:

Jul 21 14:31:19 grml logger: before-mounting
[...]
Jul 21 14:31:31 grml kernel: [  535.624072] mount(5945): READ block 385408 =
on sdb2
Jul 21 14:31:31 grml kernel: [  535.676864] mount(5945): dirtied inode 1173=
1 (sdb2) on tmpfs
Jul 21 14:31:31 grml kernel: [  535.676942] mount(5945): READ block 0 on sd=
b2
Jul 21 14:31:31 grml kernel: [  535.676959] mount(5945): READ block 8 on sd=
b2
Jul 21 14:31:31 grml kernel: [  535.676968] mount(5945): READ block 16 on s=
db2
Jul 21 14:31:31 grml kernel: [  535.676974] mount(5945): READ block 24 on s=
db2
Jul 21 14:31:31 grml kernel: [  535.676979] mount(5945): READ block 32 on s=
db2
Jul 21 14:31:31 grml kernel: [  535.676985] mount(5945): READ block 40 on s=
db2
Jul 21 14:31:31 grml kernel: [  535.676991] mount(5945): READ block 48 on s=
db2
Jul 21 14:31:31 grml kernel: [  535.676996] mount(5945): READ block 56 on s=
db2
Jul 21 14:31:31 grml kernel: [  535.677003] mount(5945): READ block 64 on s=
db2
Jul 21 14:31:31 grml kernel: [  535.677009] mount(5945): READ block 72 on s=
db2
Jul 21 14:31:31 grml kernel: [  535.677014] mount(5945): READ block 80 on s=
db2
Jul 21 14:31:31 grml kernel: [  535.677026] mount(5945): READ block 88 on s=
db2
Jul 21 14:31:31 grml kernel: [  535.677033] mount(5945): READ block 96 on s=
db2
Jul 21 14:31:31 grml kernel: [  535.677040] mount(5945): READ block 104 on =
sdb2
Jul 21 14:31:31 grml kernel: [  535.677045] mount(5945): READ block 112 on =
sdb2
Jul 21 14:31:31 grml kernel: [  535.677051] mount(5945): READ block 120 on =
sdb2
Jul 21 14:31:31 grml kernel: [  535.677056] mount(5945): READ block 128 on =
sdb2
Jul 21 14:31:31 grml kernel: [  535.740494] mount(5945): READ block 385408 =
on sdb2
Jul 21 14:31:31 grml kernel: [  535.790687] mount(5945): READ block 0 on sd=
b2
Jul 21 14:31:31 grml kernel: [  535.790707] mount(5945): READ block 8 on sd=
b2
Jul 21 14:31:31 grml kernel: [  535.790716] mount(5945): READ block 16 on s=
db2
Jul 21 14:31:31 grml kernel: [  535.790723] mount(5945): READ block 24 on s=
db2
Jul 21 14:31:31 grml kernel: [  535.790730] mount(5945): READ block 32 on s=
db2
Jul 21 14:31:31 grml kernel: [  535.790737] mount(5945): READ block 40 on s=
db2
Jul 21 14:31:31 grml kernel: [  535.790743] mount(5945): READ block 48 on s=
db2
Jul 21 14:31:31 grml kernel: [  535.790750] mount(5945): READ block 56 on s=
db2
Jul 21 14:31:31 grml kernel: [  535.790757] mount(5945): READ block 64 on s=
db2
Jul 21 14:31:31 grml kernel: [  535.790763] mount(5945): READ block 72 on s=
db2
Jul 21 14:31:31 grml kernel: [  535.790770] mount(5945): READ block 80 on s=
db2
Jul 21 14:31:31 grml kernel: [  535.790776] mount(5945): READ block 88 on s=
db2
Jul 21 14:31:31 grml kernel: [  535.790784] mount(5945): READ block 96 on s=
db2
Jul 21 14:31:31 grml kernel: [  535.790791] mount(5945): READ block 104 on =
sdb2
Jul 21 14:31:31 grml kernel: [  535.790798] mount(5945): READ block 112 on =
sdb2
Jul 21 14:31:31 grml kernel: [  535.790805] mount(5945): READ block 120 on =
sdb2
Jul 21 14:31:31 grml kernel: [  535.790812] mount(5945): READ block 128 on =
sdb2
Jul 21 14:31:31 grml kernel: [  535.867701] mount(5945): READ block 0 on sd=
b2
Jul 21 14:31:31 grml kernel: [  535.900281] Filesystem "sdb2": Disabling ba=
rriers, underlying device is readonly
Jul 21 14:31:31 grml kernel: [  535.900313] mount(5945): READ block 385552 =
on sdb2
Jul 21 14:31:31 grml kernel: [  535.930552] XFS mounting filesystem sdb2
Jul 21 14:31:31 grml kernel: [  535.931159] mount(5945): READ block 192816 =
on sdb2
Jul 21 14:31:31 grml kernel: [  535.953967] mount(5945): READ block 202415 =
on sdb2
Jul 21 14:31:31 grml kernel: [  535.987222] mount(5945): READ block 197615 =
on sdb2
Jul 21 14:31:31 grml kernel: [  536.007964] mount(5945): READ block 195215 =
on sdb2
Jul 21 14:31:31 grml kernel: [  536.041195] mount(5945): READ block 194015 =
on sdb2
Jul 21 14:31:31 grml kernel: [  536.066990] mount(5945): READ block 193415 =
on sdb2
Jul 21 14:31:32 grml kernel: [  536.134166] mount(5945): READ block 193115 =
on sdb2
Jul 21 14:31:32 grml kernel: [  536.180253] mount(5945): READ block 192965 =
on sdb2
Jul 21 14:31:32 grml kernel: [  536.251434] mount(5945): READ block 192890 =
on sdb2
Jul 21 14:31:32 grml kernel: [  536.321465] mount(5945): READ block 192853 =
on sdb2
Jul 21 14:31:32 grml kernel: [  536.391436] mount(5945): READ block 192834 =
on sdb2
Jul 21 14:31:32 grml kernel: [  536.461507] mount(5945): READ block 192825 =
on sdb2
Jul 21 14:31:32 grml kernel: [  536.491863] mount(5945): READ block 192829 =
on sdb2
Jul 21 14:31:32 grml kernel: [  536.521982] mount(5945): READ block 192831 =
on sdb2
Jul 21 14:31:32 grml kernel: [  536.548595] mount(5945): READ block 192832 =
on sdb2
Jul 21 14:31:32 grml kernel: [  536.581878] mount(5945): READ block 192833 =
on sdb2
Jul 21 14:31:32 grml kernel: [  536.612013] mount(5945): READ block 192816 =
on sdb2
Jul 21 14:31:32 grml kernel: [  536.638629] mount(5945): READ block 192818 =
on sdb2
Jul 21 14:31:32 grml kernel: [  536.671866] mount(5945): READ block 192820 =
on sdb2
Jul 21 14:31:32 grml kernel: [  536.701942] mount(5945): READ block 192822 =
on sdb2
Jul 21 14:31:32 grml kernel: [  536.728635] mount(5945): READ block 192824 =
on sdb2
Jul 21 14:31:32 grml kernel: [  536.756766] mount(5945): READ block 192826 =
on sdb2
Jul 21 14:31:32 grml kernel: [  536.781954] mount(5945): READ block 192828 =
on sdb2
Jul 21 14:31:32 grml kernel: [  536.817006] mount(5945): READ block 192830 =
on sdb2
Jul 21 14:31:32 grml kernel: [  536.848537] mount(5945): READ block 192832 =
on sdb2
Jul 21 14:31:32 grml kernel: [  536.872031] mount(5945): READ block 192816 =
on sdb2
Jul 21 14:31:32 grml kernel: [  536.905224] mount(5945): READ block 192832 =
on sdb2
Jul 21 14:31:32 grml kernel: [  536.935298] mount(5945): READ block 192831 =
on sdb2
Jul 21 14:31:32 grml kernel: [  536.956758] mount(5945): READ block 192832 =
on sdb2
Jul 21 14:31:32 grml kernel: [  536.991921] mount(5945): READ block 64 on s=
db2
Jul 21 14:31:32 grml kernel: [  537.035209] Ending clean XFS mount for file=
system: sdb2
Jul 21 14:31:44 grml logger: finished-mounting-now-unmounting
Jul 21 14:31:50 grml kernel: [  554.547532] umount(5982): WRITE block 0 on =
sdb2
Jul 21 14:32:20 grml kernel: [  585.113445] usb 1-1: reset high speed USB d=
evice using ehci_hcd and address 2
Jul 21 14:32:21 grml kernel: [  585.917964] sd 2:0:0:0: [sdb] Result: hostb=
yte=3DDID_OK driverbyte=3DDRIVER_SENSE,SUGGEST_OK
Jul 21 14:32:21 grml kernel: [  585.917987] sd 2:0:0:0: [sdb] Sense Key : D=
ata Protect [current]
Jul 21 14:32:21 grml kernel: [  585.918004] sd 2:0:0:0: [sdb] Add. Sense: W=
rite protected
Jul 21 14:32:21 grml kernel: [  585.918022] end_request: I/O error, dev sdb=
, sector 385560
Jul 21 14:32:21 grml kernel: [  585.918135] xfs_force_shutdown(sdb2,0x1) ca=
lled from line 420 of file fs/xfs/xfs_rw.c.  Return address =3D 0xc029a511
Jul 21 14:32:21 grml kernel: [  585.918172] Filesystem "sdb2": I/O Error De=
tected.  Shutting down filesystem: sdb2
Jul 21 14:32:21 grml kernel: [  585.918185] Please umount the filesystem, a=
nd rectify the problem(s)
Jul 21 14:32:21 grml kernel: [  585.918213] Filesystem "sdb2": xfs_log_forc=
e: error 5 returned.
Jul 21 14:32:21 grml kernel: [  585.918226] Filesystem "sdb2": xfs_log_forc=
e: error 5 returned.
Jul 21 14:32:21 grml kernel: [  585.918243] xfs_force_shutdown(sdb2,0x1) ca=
lled from line 420 of file fs/xfs/xfs_rw.c.  Return address =3D 0xc029a511
Jul 21 14:32:21 grml kernel: [  585.918305] Filesystem "sdb2": xfs_log_forc=
e: error 5 returned.
Jul 21 14:32:21 grml kernel: [  585.918317] Filesystem "sdb2": xfs_log_forc=
e: error 5 returned.
Jul 21 14:32:21 grml kernel: [  585.918387] Filesystem "sdb2": xfs_log_forc=
e: error 5 returned.
Jul 21 14:32:21 grml kernel: [  585.918408] Filesystem "sdb2": xfs_log_forc=
e: error 5 returned.
Jul 21 14:32:21 grml kernel: [  585.918421] Filesystem "sdb2": xfs_log_forc=
e: error 5 returned.
Jul 21 14:32:21 grml kernel: [  585.923639] umount(5982): dirtied inode 157=
99 (mtab.tmp) on tmpfs
Jul 21 14:32:21 grml kernel: [  585.923894] umount(5982): dirtied inode 157=
99 (mtab.tmp) on tmpfs
Jul 21 14:33:03 grml logger: finished-unmounting

I couldn't reproduce the same problem with other filesystems.
Let me know if you need any further details.

Please Cc me on replies as I'm not subscribed to the mailinglist.

=B9 http://www.tableau.com/index.php?pageid=3Dproducts&category=3Dforensic_=
bridges

regards,
-mika-
--=20
http://michael-prokop.at/  || http://adminzen.org/
http://grml-solutions.com/ || http://grml.org/

--qyHYMwAXsHLOQihY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFKZZ2o2N9T+zficugRAmCiAJ47L6oYFSDT3DweTsM2s4JK2ZkVWQCfXarv
y4HRBUcCE1xGHVozvbgihCI=
=P+d4
-----END PGP SIGNATURE-----

--qyHYMwAXsHLOQihY--


--===============5911364890997924108==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5911364890997924108==--
