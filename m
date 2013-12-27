Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id F34717F3F
	for <xfs@oss.sgi.com>; Fri, 27 Dec 2013 06:42:32 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 97B21AC004
	for <xfs@oss.sgi.com>; Fri, 27 Dec 2013 04:42:29 -0800 (PST)
Received: from smtprelay01.ispgateway.de (smtprelay01.ispgateway.de
	[80.67.29.23]) by cuda.sgi.com with ESMTP id D28GoDe8eF7vVMaY
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 27 Dec 2013 04:42:26 -0800 (PST)
Received: from [91.44.238.103] (helo=remote.visual4.de)
	by smtprelay01.ispgateway.de with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.68) (envelope-from <bjoern_rafreider@visual4.de>)
	id 1VwWkC-00053I-Pz
	for xfs@oss.sgi.com; Fri, 27 Dec 2013 13:42:24 +0100
From: =?iso-8859-1?Q?Bj=F6rn_Rafreider?= <bjoern_rafreider@visual4.de>
Date: Fri, 27 Dec 2013 13:42:21 +0100
Subject: Bug - xfs_repair asks me to report it
Message-ID: <7ED0247242FEFB40BCA665733E613DCA0640C14C985D@V4SERVER.v4.local>
Content-Language: de-DE
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Hi,
over christmas our backup system with XFS on LVM2 on iSCSI on Ubuntu 12.04.=
03 gave me several errors. Turned out, that the XFS was halted because of a=
n error. XFS_repair fixed several errors but finally quit with the followin=
g error message:

corrupt dinode 3328159430, extent total =3D 1, nblocks =3D 0.  This is a bu=
g.
Please capture the filesystem metadata with xfs_metadump and
report it to xfs@oss.sgi.com.
cache_node_purge: refcount was 1, not zero (node=3D0x1b928ab0)

fatal error -- couldn't map inode 3328159430, err =3D 117

the dump is running at the moment - but it already has 5G - little too big =
for sending it by mail so I add a little more information

The file System is ~2.9TB on two physical iSCSI drives with 1TB and 1.9TB, =
~80% used
Kernel is: 3.2.0-57-generic #87-Ubuntu SMP Tue Nov 12 21:35:10 UTC 2013 x86=
_64 x86_64 x86_64 GNU/Linux
System is running on Xen with 2G of memory (doubled it to 4G now without a =
change)

The backup is using snapback2, which is basically a wrapper around rsync. I=
t hardlinks existing files so a real huge amount of inodes is created.
Filesystem                        Inodes    IUsed      IFree IUse% Mounted =
on
/dev/mapper/v4iscsibu-backups 1659061776 23831539 1635230237    2% /mnt/bac=
kups

Dmesg gave the following errors before shutting down the filesystem:
-------------------------------------------------------------
[   16.216309] scsi0 : iSCSI Initiator over TCP/IP
[   17.227571] scsi 0:0:0:0: Direct-Access     Promise  VessRAID 1840i   03=
06 PQ: 0 ANSI: 5
[   17.228312] sd 0:0:0:0: [sda] 2147483648 512-byte logical blocks: (1.09 =
TB/1.00 TiB)
[   17.228443] sd 0:0:0:0: Attached scsi generic sg0 type 0
[   17.229380] sd 0:0:0:0: [sda] Write Protect is off
[   17.229384] sd 0:0:0:0: [sda] Mode Sense: a3 00 10 08
[   17.229704] scsi 0:0:0:1: Direct-Access     Promise  VessRAID 1840i   03=
06 PQ: 0 ANSI: 5
[   17.229889] sd 0:0:0:1: Attached scsi generic sg1 type 0
[   17.233345] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 supports DPO and FUA
[   17.233895] sd 0:0:0:1: [sdb] 4110147584 512-byte logical blocks: (2.10 =
TB/1.91 TiB)
[   17.237268] sd 0:0:0:1: [sdb] Write Protect is off
[   17.237273] sd 0:0:0:1: [sdb] Mode Sense: a3 00 10 08
[   17.237852] sd 0:0:0:1: [sdb] Write cache: enabled, read cache: enabled,=
 supports DPO and FUA
[   17.251513]  sda: unknown partition table
[   17.253550] sd 0:0:0:0: [sda] Attached SCSI disk
[   17.263924]  sdb: unknown partition table
[   17.266117] sd 0:0:0:1: [sdb] Attached SCSI disk
[   17.406363] init: failsafe main process (791) killed by TERM signal
[   17.736859] XFS (dm-2): Mounting Filesystem
[   17.933764] XFS (dm-2): Starting recovery (logdev: internal)
[   18.345411] XFS (dm-2): Ending recovery (logdev: internal)
[   18.778605] type=3D1400 audit(1387993447.308:11): apparmor=3D"STATUS" op=
eration=3D"profile_replace" name=3D"/sbin/dhclient" pid=3D1029 comm=3D"appa=
rmor_parser"
[   18.779096] type=3D1400 audit(1387993447.308:12): apparmor=3D"STATUS" op=
eration=3D"profile_replace" name=3D"/usr/lib/NetworkManager/nm-dhcp-client.=
action" pid=3D1029 comm=3D"apparmor_parser"
[   18.779349] type=3D1400 audit(1387993447.308:13): apparmor=3D"STATUS" op=
eration=3D"profile_replace" name=3D"/usr/lib/connman/scripts/dhclient-scrip=
t" pid=3D1029 comm=3D"apparmor_parser"
[   18.807264] type=3D1400 audit(1387993447.340:14): apparmor=3D"STATUS" op=
eration=3D"profile_load" name=3D"/usr/sbin/dhcpd3" pid=3D1031 comm=3D"appar=
mor_parser"
[   18.821018] type=3D1400 audit(1387993447.352:15): apparmor=3D"STATUS" op=
eration=3D"profile_load" name=3D"/usr/sbin/dhcpd" pid=3D1030 comm=3D"apparm=
or_parser"
[   18.879035] type=3D1400 audit(1387993447.412:16): apparmor=3D"STATUS" op=
eration=3D"profile_load" name=3D"/usr/sbin/mysqld" pid=3D1032 comm=3D"appar=
mor_parser"
[   18.882830] type=3D1400 audit(1387993447.412:17): apparmor=3D"STATUS" op=
eration=3D"profile_load" name=3D"/usr/sbin/tcpdump" pid=3D1034 comm=3D"appa=
rmor_parser"
[   19.208464] type=3D1400 audit(1387993447.740:18): apparmor=3D"STATUS" op=
eration=3D"profile_replace" name=3D"/usr/sbin/mysqld" pid=3D1122 comm=3D"ap=
parmor_parser"
[   19.248026] eth0: no IPv6 routers present
[   19.248031] eth1: no IPv6 routers present
[104404.965327] XFS (dm-2): Internal error xfs_trans_cancel at line 1925 of=
 file /build/buildd/linux-3.2.0/fs/xfs/xfs_trans.c.  Caller 0xffffffffa0143=
773
[104404.965331]
[104404.965452] Pid: 10341, comm: rsync Not tainted 3.2.0-57-generic #87-Ub=
untu
[104404.965458] Call Trace:
[104404.965503]  [<ffffffffa01336ef>] xfs_error_report+0x3f/0x50 [xfs]
[104404.965525]  [<ffffffffa0143773>] ? xfs_rename+0x363/0x760 [xfs]
[104404.965549]  [<ffffffffa018e177>] ? xfs_trans_ichgtime+0x27/0xa0 [xfs]
[104404.965571]  [<ffffffffa01847e5>] xfs_trans_cancel+0xe5/0x110 [xfs]
[104404.965588]  [<ffffffffa0143773>] xfs_rename+0x363/0x760 [xfs]
[104404.965605]  [<ffffffffa013c056>] xfs_vn_rename+0x66/0x70 [xfs]
[104404.965613]  [<ffffffff81186ade>] vfs_rename_other+0xde/0x130
[104404.965617]  [<ffffffff81187a1b>] vfs_rename+0xbb/0x240
[104404.965621]  [<ffffffff81185d11>] ? __lookup_hash.part.28+0x31/0xe0
[104404.965625]  [<ffffffff81185fca>] ? inode_permission+0x4a/0x110
[104404.965630]  [<ffffffff8118acc8>] sys_renameat+0x218/0x240
[104404.965635]  [<ffffffff81196501>] ? notify_change+0x271/0x360
[104404.965640]  [<ffffffff81197e6e>] ? vfsmount_lock_local_unlock+0x1e/0x30
[104404.965644]  [<ffffffff81199c80>] ? mntput_no_expire+0x30/0xf0
[104404.965648]  [<ffffffff81199d5f>] ? mntput+0x1f/0x30
[104404.965652]  [<ffffffff81185152>] ? path_put+0x22/0x30
[104404.965656]  [<ffffffff8118ad0b>] sys_rename+0x1b/0x20
[104404.965662]  [<ffffffff81669b82>] system_call_fastpath+0x16/0x1b
[104404.965668] XFS (dm-2): xfs_do_force_shutdown(0x8) called from line 192=
6 of file /build/buildd/linux-3.2.0/fs/xfs/xfs_trans.c.  Return address =3D=
 0xffffffffa01847fe
[104404.979180] XFS (dm-2): xfs_imap_to_bp: xfs_trans_read_buf() returned e=
rror 5.
[104404.983241] XFS (dm-2): Corruption of in-memory data detected.  Shuttin=
g down filesystem
[104404.983315] XFS (dm-2): Please umount the filesystem and rectify the pr=
oblem(s)
[104426.080039] XFS (dm-2): xfs_log_force: error 5 returned.

Is there a way to get this filesystem working again? I will use another LUN=
 with a fresh FS for now.

Thanks,
Bj=F6rn
---------------------------------------------------------------------------=
------------------------------------------
N-E-W-S: >>> www.meine-moebelmanufaktur.de =

3D-M=F6belkonfigurator - Erlebe Deinen Schrank schon vor der Bestellung im =
Internet<<
---------------------------------------
Bj=F6rn Rafreider
visual4 GmbH
Schreiberstra=DFe 27
70199 Stuttgart
www.visual4.de
Fon.: +49 (0)711 / 64.91.23.8
Fax.: +49 (0)711 / 64.91.23.9
-----------------------------------------
Sitz der Gesellschaft: Stuttgart
Handelsregister: Amtsgericht Stuttgart, HRB 736092
Gesch=E4ftsf=FChrung:
Dipl.-Ing. (FH) Christoph Plessner
Dipl.-Ing. Bj=F6rn Rafreider
Dipl.-Ing. Walter H. Sindlinger

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
