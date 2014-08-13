Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4F9177F3F
	for <xfs@oss.sgi.com>; Wed, 13 Aug 2014 04:42:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 098AC8F8074
	for <xfs@oss.sgi.com>; Wed, 13 Aug 2014 02:42:29 -0700 (PDT)
Received: from mescalin.tbi.univie.ac.at (mescalin.tbi.univie.ac.at
	[131.130.44.61]) by cuda.sgi.com with ESMTP id Bv7fHOpIy5suhGax
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 13 Aug 2014 02:42:27 -0700 (PDT)
Received: from denobula.tbi.univie.ac.at ([131.130.44.65]:42797)
	by mescalin.tbi.univie.ac.at with esmtpsa
	(TLS1.0:DHE_RSA_AES_128_CBC_SHA1:16) (Exim 4.76)
	(envelope-from <hawk@tbi.univie.ac.at>) id 1XHV4c-0004N8-A4
	for xfs@oss.sgi.com; Wed, 13 Aug 2014 11:42:26 +0200
Message-ID: <53EB3302.1090000@tbi.univie.ac.at>
Date: Wed, 13 Aug 2014 11:42:26 +0200
From: Richard Neuboeck <hawk@tbi.univie.ac.at>
MIME-Version: 1.0
Subject: File System Corruption - Internal error xfs_dir3_data_reada_verify
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1475535825473796520=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--===============1475535825473796520==
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="OgiujWGRgACxmDpNj1g6pLCq7sCfhs5ti"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--OgiujWGRgACxmDpNj1g6pLCq7sCfhs5ti
Content-Type: multipart/mixed;
 boundary="------------040508060702070407000707"

This is a multi-part message in MIME format.
--------------040508060702070407000707
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi,

for some time now our storage machine using XFS stops the file
system due to some reason I don't seem to have found so far. In this
process the file system gets corrupted and the attached trace log is
shown. After xfs_repair is run it's running again for an always
changing amount of time. In general it fails within a few hours or
days. There are no relevant log messages before the entries shown
below and no immediate actions that lead to this condition. So far
my experiments (Ubuntu upgrade from 10.04 to 14.04, different kernel
versions, changes to the hypervisor) didn't show any lasting effects
(positive or negative). If any one could shed some light on what XFS
is trying to tell me it would be highly appreciated.

I've found the mention of 'xfs_dir3_data_reada_verify' in the
mailing list but didn't find a solution that was applicable.

Thanks in advance
Richard


Operating System: Ubuntu 14.04 x86_64
Kernel: 3.13.0-32-generic
Machine: Virtual, gets an LVM device (/dev/vdb)

The system hosting the virtual machine is Ubuntu lucid (10.04LTS)
x86_64. There are no log messages related to this incident on this
machine.

--=20
/dev/null

--------------040508060702070407000707
Content-Type: text/plain; charset=UTF-8;
 name="xfs_trace.log"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="xfs_trace.log"

Aug 13 10:11:16 huddle kernel: [ 5247.325984] ffff880113855000: 20 73 63 =
6f 70 65 2e 52 65 73 65 74 48 69 73 74   scope.ResetHist
Aug 13 10:11:16 huddle kernel: [ 5247.326066] ffff880113855010: 6f 72 79 =
28 29 3b 0a 20 20 20 20 20 20 20 20 20  ory();.        =20
Aug 13 10:11:16 huddle kernel: [ 5247.326107] ffff880113855020: 20 20 20 =
20 20 20 20 68 61 6e 64 6c 65 2e 52 65         handle.Re
Aug 13 10:11:16 huddle kernel: [ 5247.326147] ffff880113855030: 73 65 74 =
28 29 3b 0a 20 20 20 20 20 20 20 20 20  set();.        =20
Aug 13 10:11:16 huddle kernel: [ 5247.326196] XFS (vdb): Internal error x=
fs_dir3_data_reada_verify at line 258 of file /build/buildd/linux-3.13.0/=
fs/xfs/xfs_dir2_data.c.  Caller 0xffffffffa006b6c5
Aug 13 10:11:16 huddle kernel: [ 5247.326276] CPU: 0 PID: 341 Comm: kwork=
er/0:1H Not tainted 3.13.0-32-generic #57-Ubuntu
Aug 13 10:11:16 huddle kernel: [ 5247.326278] Hardware name: Bochs Bochs,=
 BIOS Bochs 01/01/2007
Aug 13 10:11:16 huddle kernel: [ 5247.326352] Workqueue: xfslogd xfs_buf_=
iodone_work [xfs]
Aug 13 10:11:16 huddle kernel: [ 5247.326357]  0000000000000001 ffff88021=
1f97d88 ffffffff8171bcb4 ffff8802125bd000
Aug 13 10:11:16 huddle kernel: [ 5247.326361]  ffff880211f97da0 ffffffffa=
006e53b ffffffffa006b6c5 ffff880211f97dd8
Aug 13 10:11:16 huddle kernel: [ 5247.326363]  ffffffffa006e595 000001021=
1f97dc8 ffff880101aa8000 ffff880101aa8000
Aug 13 10:11:16 huddle kernel: [ 5247.326365] Call Trace:
Aug 13 10:11:16 huddle kernel: [ 5247.326373]  [<ffffffff8171bcb4>] dump_=
stack+0x45/0x56
Aug 13 10:11:16 huddle kernel: [ 5247.326385]  [<ffffffffa006e53b>] xfs_e=
rror_report+0x3b/0x40 [xfs]
Aug 13 10:11:16 huddle kernel: [ 5247.326395]  [<ffffffffa006b6c5>] ? xfs=
_buf_iodone_work+0x85/0xf0 [xfs]
Aug 13 10:11:16 huddle kernel: [ 5247.326406]  [<ffffffffa006e595>] xfs_c=
orruption_error+0x55/0x80 [xfs]
Aug 13 10:11:16 huddle kernel: [ 5247.326442]  [<ffffffffa00a9012>] xfs_d=
ir3_data_reada_verify+0x62/0xc0 [xfs]
Aug 13 10:11:16 huddle kernel: [ 5247.326451]  [<ffffffffa006b6c5>] ? xfs=
_buf_iodone_work+0x85/0xf0 [xfs]
Aug 13 10:11:16 huddle kernel: [ 5247.326460]  [<ffffffffa006b6c5>] xfs_b=
uf_iodone_work+0x85/0xf0 [xfs]
Aug 13 10:11:16 huddle kernel: [ 5247.326465]  [<ffffffff810838f2>] proce=
ss_one_work+0x182/0x450
Aug 13 10:11:16 huddle kernel: [ 5247.326478]  [<ffffffff810846e1>] worke=
r_thread+0x121/0x410
Aug 13 10:11:16 huddle kernel: [ 5247.326481]  [<ffffffff810845c0>] ? res=
cuer_thread+0x430/0x430
Aug 13 10:11:16 huddle kernel: [ 5247.326484]  [<ffffffff8108b3d2>] kthre=
ad+0xd2/0xf0
Aug 13 10:11:16 huddle kernel: [ 5247.326486]  [<ffffffff8108b300>] ? kth=
read_create_on_node+0x1d0/0x1d0
Aug 13 10:11:16 huddle kernel: [ 5247.326490]  [<ffffffff8172c5bc>] ret_f=
rom_fork+0x7c/0xb0
Aug 13 10:11:16 huddle kernel: [ 5247.326492]  [<ffffffff8108b300>] ? kth=
read_create_on_node+0x1d0/0x1d0
Aug 13 10:11:16 huddle kernel: [ 5247.326494] XFS (vdb): Corruption detec=
ted. Unmount and run xfs_repair
Aug 13 10:11:16 huddle kernel: [ 5247.326532] XFS (vdb): metadata I/O err=
or: block 0x160003e488 ("xfs_trans_read_buf_map") error 117 numblks 8
Aug 13 10:11:16 huddle kernel: [ 5247.326789] ffff880113855000: 20 73 63 =
6f 70 65 2e 52 65 73 65 74 48 69 73 74   scope.ResetHist
Aug 13 10:11:16 huddle kernel: [ 5247.326831] ffff880113855010: 6f 72 79 =
28 29 3b 0a 20 20 20 20 20 20 20 20 20  ory();.        =20
Aug 13 10:11:16 huddle kernel: [ 5247.326870] ffff880113855020: 20 20 20 =
20 20 20 20 68 61 6e 64 6c 65 2e 52 65         handle.Re
Aug 13 10:11:16 huddle kernel: [ 5247.326909] ffff880113855030: 73 65 74 =
28 29 3b 0a 20 20 20 20 20 20 20 20 20  set();.        =20
Aug 13 10:11:16 huddle kernel: [ 5247.326949] XFS (vdb): Internal error x=
fs_dir3_data_read_verify at line 274 of file /build/buildd/linux-3.13.0/f=
s/xfs/xfs_dir2_data.c.  Caller 0xffffffffa006b6c5
Aug 13 10:11:16 huddle kernel: [ 5247.327029] CPU: 0 PID: 341 Comm: kwork=
er/0:1H Not tainted 3.13.0-32-generic #57-Ubuntu
Aug 13 10:11:16 huddle kernel: [ 5247.327031] Hardware name: Bochs Bochs,=
 BIOS Bochs 01/01/2007
Aug 13 10:11:16 huddle kernel: [ 5247.327042] Workqueue: xfslogd xfs_buf_=
iodone_work [xfs]
Aug 13 10:11:16 huddle kernel: [ 5247.327044]  0000000000000001 ffff88021=
1f97d68 ffffffff8171bcb4 ffff8802125bd000
Aug 13 10:11:16 huddle kernel: [ 5247.327045]  ffff880211f97d80 ffffffffa=
006e53b ffffffffa006b6c5 ffff880211f97db8
Aug 13 10:11:16 huddle kernel: [ 5247.327047]  ffffffffa006e595 000001121=
1f97db0 ffff880036ab1300 ffff8802125bd000
Aug 13 10:11:16 huddle kernel: [ 5247.327049] Call Trace:
Aug 13 10:11:16 huddle kernel: [ 5247.327052]  [<ffffffff8171bcb4>] dump_=
stack+0x45/0x56
Aug 13 10:11:16 huddle kernel: [ 5247.327061]  [<ffffffffa006e53b>] xfs_e=
rror_report+0x3b/0x40 [xfs]
Aug 13 10:11:16 huddle kernel: [ 5247.327070]  [<ffffffffa006b6c5>] ? xfs=
_buf_iodone_work+0x85/0xf0 [xfs]
Aug 13 10:11:16 huddle kernel: [ 5247.327079]  [<ffffffffa006e595>] xfs_c=
orruption_error+0x55/0x80 [xfs]
Aug 13 10:11:16 huddle kernel: [ 5247.327092]  [<ffffffffa00a8f2d>] xfs_d=
ir3_data_read_verify+0x6d/0xf0 [xfs]
Aug 13 10:11:16 huddle kernel: [ 5247.327101]  [<ffffffffa006b6c5>] ? xfs=
_buf_iodone_work+0x85/0xf0 [xfs]
Aug 13 10:11:16 huddle kernel: [ 5247.327104]  [<ffffffff81097508>] ? fin=
ish_task_switch+0x128/0x170
Aug 13 10:11:16 huddle kernel: [ 5247.327113]  [<ffffffffa006b6c5>] xfs_b=
uf_iodone_work+0x85/0xf0 [xfs]
Aug 13 10:11:16 huddle kernel: [ 5247.327115]  [<ffffffff810838f2>] proce=
ss_one_work+0x182/0x450
Aug 13 10:11:16 huddle kernel: [ 5247.327117]  [<ffffffff810846e1>] worke=
r_thread+0x121/0x410
Aug 13 10:11:16 huddle kernel: [ 5247.327119]  [<ffffffff810845c0>] ? res=
cuer_thread+0x430/0x430
Aug 13 10:11:16 huddle kernel: [ 5247.327121]  [<ffffffff8108b3d2>] kthre=
ad+0xd2/0xf0
Aug 13 10:11:16 huddle kernel: [ 5247.327122]  [<ffffffff8108b300>] ? kth=
read_create_on_node+0x1d0/0x1d0
Aug 13 10:11:16 huddle kernel: [ 5247.327124]  [<ffffffff8172c5bc>] ret_f=
rom_fork+0x7c/0xb0
Aug 13 10:11:16 huddle kernel: [ 5247.327126]  [<ffffffff8108b300>] ? kth=
read_create_on_node+0x1d0/0x1d0
Aug 13 10:11:16 huddle kernel: [ 5247.327127] XFS (vdb): Corruption detec=
ted. Unmount and run xfs_repair
Aug 13 10:11:16 huddle kernel: [ 5247.327164] XFS (vdb): metadata I/O err=
or: block 0x160003e488 ("xfs_trans_read_buf_map") error 117 numblks 8
Aug 13 10:11:21 huddle kernel: [ 5252.482540] XFS: Internal error XFS_WAN=
T_CORRUPTED_GOTO at line 1602 of file /build/buildd/linux-3.13.0/fs/xfs/x=
fs_alloc.c.  Caller 0xffffffffa0088485
Aug 13 10:11:21 huddle kernel: [ 5252.482644] CPU: 0 PID: 2167 Comm: rm N=
ot tainted 3.13.0-32-generic #57-Ubuntu
Aug 13 10:11:21 huddle kernel: [ 5252.482646] Hardware name: Bochs Bochs,=
 BIOS Bochs 01/01/2007
Aug 13 10:11:21 huddle kernel: [ 5252.482648]  0000000000fef248 ffff88010=
d125b88 ffffffff8171bcb4 0000000000000004
Aug 13 10:11:21 huddle kernel: [ 5252.482651]  ffff88010d125ba0 ffffffffa=
006e53b ffffffffa0088485 ffff88010d125c38
Aug 13 10:11:21 huddle kernel: [ 5252.482653]  ffffffffa0086f19 ffff88021=
25bd000 ffff880033fff780 ffff880211f9b9c0
Aug 13 10:11:21 huddle kernel: [ 5252.482655] Call Trace:
Aug 13 10:11:21 huddle kernel: [ 5252.482664]  [<ffffffff8171bcb4>] dump_=
stack+0x45/0x56
Aug 13 10:11:21 huddle kernel: [ 5252.482694]  [<ffffffffa006e53b>] xfs_e=
rror_report+0x3b/0x40 [xfs]
Aug 13 10:11:21 huddle kernel: [ 5252.482706]  [<ffffffffa0088485>] ? xfs=
_free_extent+0xc5/0xf0 [xfs]
Aug 13 10:11:21 huddle kernel: [ 5252.482718]  [<ffffffffa0086f19>] xfs_f=
ree_ag_extent+0x1e9/0x710 [xfs]
Aug 13 10:11:21 huddle kernel: [ 5252.482730]  [<ffffffffa0088485>] xfs_f=
ree_extent+0xc5/0xf0 [xfs]
Aug 13 10:11:21 huddle kernel: [ 5252.482748]  [<ffffffffa00680df>] xfs_b=
map_finish+0x13f/0x190 [xfs]
Aug 13 10:11:21 huddle kernel: [ 5252.482766]  [<ffffffffa00b6acd>] xfs_i=
truncate_extents+0x16d/0x2a0 [xfs]
Aug 13 10:11:21 huddle kernel: [ 5252.482781]  [<ffffffffa00b6c8d>] xfs_i=
nactive_truncate+0x8d/0x120 [xfs]
Aug 13 10:11:21 huddle kernel: [ 5252.482812]  [<ffffffffa00b7438>] xfs_i=
nactive+0x138/0x160 [xfs]
Aug 13 10:11:21 huddle kernel: [ 5252.482844]  [<ffffffffa007fa50>] xfs_f=
s_evict_inode+0x80/0xc0 [xfs]
Aug 13 10:11:21 huddle kernel: [ 5252.482848]  [<ffffffff811d7d70>] evict=
+0xb0/0x1b0
Aug 13 10:11:21 huddle kernel: [ 5252.482850]  [<ffffffff811d8585>] iput+=
0xf5/0x180
Aug 13 10:11:21 huddle kernel: [ 5252.482852]  [<ffffffff811ccf8e>] do_un=
linkat+0x18e/0x2b0
Aug 13 10:11:21 huddle kernel: [ 5252.482857]  [<ffffffff81020d45>] ? sys=
call_trace_enter+0x145/0x250
Aug 13 10:11:21 huddle kernel: [ 5252.482859]  [<ffffffff811cdeab>] SyS_u=
nlinkat+0x1b/0x40
Aug 13 10:11:21 huddle kernel: [ 5252.482863]  [<ffffffff8172c87f>] trace=
sys+0xe1/0xe6
Aug 13 10:11:21 huddle kernel: [ 5252.482872] XFS (vdb): xfs_do_force_shu=
tdown(0x8) called from line 138 of file /build/buildd/linux-3.13.0/fs/xfs=
/xfs_bmap_util.c.  Return address =3D 0xffffffffa0068118
Aug 13 10:11:21 huddle kernel: [ 5252.483790] XFS (vdb): Corruption of in=
-memory data detected.  Shutting down filesystem
Aug 13 10:11:21 huddle kernel: [ 5252.483830] XFS (vdb): Please umount th=
e filesystem and rectify the problem(s)

--------------040508060702070407000707--

--OgiujWGRgACxmDpNj1g6pLCq7sCfhs5ti
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlPrMwIACgkQnGohgOrO9GG9eACfTUkJVdEERdE5uq8Ffc4bsYIZ
imIAnA8AZu1dRRuEqNelIQ+7CoGAVyMc
=NS9s
-----END PGP SIGNATURE-----

--OgiujWGRgACxmDpNj1g6pLCq7sCfhs5ti--


--===============1475535825473796520==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1475535825473796520==--
