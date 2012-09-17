Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8HEtB5F173932 for <xfs@oss.sgi.com>; Mon, 17 Sep 2012 09:55:11 -0500
Received: from smtprelay06.ispgateway.de (smtprelay06.ispgateway.de
	[80.67.31.95]) by cuda.sgi.com with ESMTP id fBG9MK3ylx27zXFx
	for <xfs@oss.sgi.com>; Mon, 17 Sep 2012 07:56:21 -0700 (PDT)
Received: from [62.43.225.238] (helo=localhost)
	by smtprelay06.ispgateway.de with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.68) (envelope-from <richard.ems@cape-horn-eng.com>)
	id 1TDckF-0005lA-Ve
	for xfs@oss.sgi.com; Mon, 17 Sep 2012 16:56:20 +0200
Message-ID: <50573A13.7000206@cape-horn-eng.com>
Date: Mon, 17 Sep 2012 16:56:19 +0200
From: Richard Ems <richard.ems@cape-horn-eng.com>
MIME-Version: 1.0
Subject: XFS (sdd1): Internal error xfs_da_do_buf(2) at line 2097 of file
	/usr/src/packages/BUILD/kernel-default-3.3.6/linux-3.3/fs/xfs/xfs_da_btree.c.
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hi all,

saturday morning one hard disc on our RAID6 failed. About one hour later,
 the XFS running on that device reported the following error:

XFS (sdd1): Internal error xfs_da_do_buf(2) at line 2097 of file /usr/src/p=
ackages/BUILD/kernel-default-3.3.6/linux-3.3/fs/xfs/xfs_da_btree.c.

We run openSUSE 12.1 64 bit, kernel 3.3.6, on a DELL R410 server, with
 4 MD1200 storage systems attached.
The failed disc was on one of these MD1200, configured with
 11 x 3 TB discs on a RAID 6 and one hot standby disc. =

A rebuild started on the standby disc immediately and finished
 several hours later.

But, and as mentioned above, about one hour after the disc failure
 the above error was reported and the mountpoint was set to read-only mode.

This error got reported 228664 times in 23 hours:

fs1:/var/log # grep -c -i "XFS .* Internal error xfs_da_do_buf(2)" messages=
-20120916
228664

fs1:/var/log # grep -i "XFS .* Internal error xfs_da_do_buf(2)" messages-20=
120916 | head -n 1
Sep 15 07:30:51 fs1 kernel: [7369085.790742] XFS (sdd1): Internal error xfs=
_da_do_buf(2) at line 2097 of file /usr/src/packages/BUILD/kernel-default-3=
.3.6/linux-3.3/fs/xfs/xfs_da_btree.c.  Caller 0xffffffffa038a09a

fs1:/var/log # grep -i "XFS .* Internal error xfs_da_do_buf(2)" messages-20=
120916 | tail -n 1
Sep 16 06:30:00 fs1 kernel: [7451668.512765] XFS (sdd1): Internal error xfs=
_da_do_buf(2) at line 2097 of file /usr/src/packages/BUILD/kernel-default-3=
.3.6/linux-3.3/fs/xfs/xfs_da_btree.c.  Caller 0xffffffffa038a09a


The complete stack trace reported is:

Sep 15 07:30:51 fs1 kernel: [7369085.790735] ffff8801fd805000: 6f 86 00 0f =
9d 38 00 15 26 1c 00 aa e3 17 00 a7  o....8..&.......
Sep 15 07:30:51 fs1 kernel: [7369085.790742] XFS (sdd1): Internal error xfs=
_da_do_buf(2) at line 2097 of file /usr/src/packages/BUILD/kernel-default-3=
.3.6/linux-3.3/fs/xfs/xfs_da_btree.c.  Caller 0xffffffffa038a09a
Sep 15 07:30:51 fs1 kernel: [7369085.790745] =

Sep 15 07:30:51 fs1 kernel: [7369085.790749] Pid: 16081, comm: rsync Not ta=
inted 3.3.6-1-default #1
Sep 15 07:30:51 fs1 kernel: [7369085.790752] Call Trace:
Sep 15 07:30:51 fs1 kernel: [7369085.790766]  [<ffffffff81004618>] dump_tra=
ce+0x78/0x320
Sep 15 07:30:51 fs1 kernel: [7369085.790775]  [<ffffffff81579939>] dump_sta=
ck+0x69/0x6f
Sep 15 07:30:51 fs1 kernel: [7369085.790804]  [<ffffffffa0357202>] xfs_corr=
uption_error+0x62/0x90 [xfs]
Sep 15 07:30:51 fs1 kernel: [7369085.790858]  [<ffffffffa0389fba>] xfs_da_d=
o_buf+0x5fa/0x680 [xfs]
Sep 15 07:30:51 fs1 kernel: [7369085.790961]  [<ffffffffa038a09a>] xfs_da_r=
ead_buf+0x1a/0x20 [xfs]
Sep 15 07:30:51 fs1 kernel: [7369085.791061]  [<ffffffffa03903a0>] xfs_dir2=
_leaf_lookup_int+0x60/0x300 [xfs]
Sep 15 07:30:51 fs1 kernel: [7369085.791169]  [<ffffffffa0390b05>] xfs_dir2=
_leaf_lookup+0x25/0x100 [xfs]
Sep 15 07:30:51 fs1 kernel: [7369085.791275]  [<ffffffffa038c937>] xfs_dir_=
lookup+0x187/0x1a0 [xfs]
Sep 15 07:30:51 fs1 kernel: [7369085.791376]  [<ffffffffa03693d0>] xfs_look=
up+0xb0/0x110 [xfs]
Sep 15 07:30:51 fs1 kernel: [7369085.791442]  [<ffffffffa035f492>] xfs_vn_l=
ookup+0x42/0x90 [xfs]
Sep 15 07:30:51 fs1 kernel: [7369085.791496]  [<ffffffff81169b5c>] d_alloc_=
and_lookup+0x3c/0x90
Sep 15 07:30:51 fs1 kernel: [7369085.791505]  [<ffffffff8116beb3>] do_looku=
p+0x2a3/0x3a0
Sep 15 07:30:51 fs1 kernel: [7369085.791514]  [<ffffffff8116e1ff>] do_last+=
0xef/0x7d0
Sep 15 07:30:51 fs1 kernel: [7369085.791524]  [<ffffffff8116ea0c>] path_ope=
nat+0xdc/0x400
Sep 15 07:30:51 fs1 kernel: [7369085.791532]  [<ffffffff8116ee5d>] do_filp_=
open+0x4d/0xc0
Sep 15 07:30:51 fs1 kernel: [7369085.791542]  [<ffffffff8115e952>] do_sys_o=
pen+0x102/0x1e0
Sep 15 07:30:51 fs1 kernel: [7369085.791552]  [<ffffffff815848b9>] system_c=
all_fastpath+0x16/0x1b
Sep 15 07:30:51 fs1 kernel: [7369085.791569]  [<00007f2e079aadf0>] 0x7f2e07=
9aadef
Sep 15 07:30:51 fs1 kernel: [7369085.791574] XFS (sdd1): Corruption detecte=
d. Unmount and run xfs_repair
Sep 15 07:30:51 fs1 kernel: [7369085.791836] ffff8801fd805000: 6f 86 00 0f =
9d 38 00 15 26 1c 00 aa e3 17 00 a7  o....8..&.......

Sep 15 07:30:51 fs1 kernel: [7369085.791842] XFS (sdd1): Internal error xfs=
_da_do_buf(2) at line 2097 of file /usr/src/packages/BUILD/kernel-default-3=
.3.6/linux-3.3/fs/xfs/xfs_da_btree.c.  Caller 0xffffffffa038a09a
Sep 15 07:30:51 fs1 kernel: [7369085.791849] =

Sep 15 07:30:51 fs1 kernel: [7369085.791851] Pid: 16081, comm: rsync Not ta=
inted 3.3.6-1-default #1
Sep 15 07:30:51 fs1 kernel: [7369085.791854] Call Trace:
Sep 15 07:30:51 fs1 kernel: [7369085.791864]  [<ffffffff81004618>] dump_tra=
ce+0x78/0x320
Sep 15 07:30:51 fs1 kernel: [7369085.791869]  [<ffffffff81579939>] dump_sta=
ck+0x69/0x6f
Sep 15 07:30:51 fs1 kernel: [7369085.791887]  [<ffffffffa0357202>] xfs_corr=
uption_error+0x62/0x90 [xfs]
Sep 15 07:30:51 fs1 kernel: [7369085.791937]  [<ffffffffa0389fba>] xfs_da_d=
o_buf+0x5fa/0x680 [xfs]
Sep 15 07:30:51 fs1 kernel: [7369085.792039]  [<ffffffffa038a09a>] xfs_da_r=
ead_buf+0x1a/0x20 [xfs]
Sep 15 07:30:51 fs1 kernel: [7369085.792140]  [<ffffffffa03903a0>] xfs_dir2=
_leaf_lookup_int+0x60/0x300 [xfs]
Sep 15 07:30:51 fs1 kernel: [7369085.792247]  [<ffffffffa0390b05>] xfs_dir2=
_leaf_lookup+0x25/0x100 [xfs]
Sep 15 07:30:51 fs1 kernel: [7369085.792354]  [<ffffffffa038c937>] xfs_dir_=
lookup+0x187/0x1a0 [xfs]
Sep 15 07:30:51 fs1 kernel: [7369085.792455]  [<ffffffffa03693d0>] xfs_look=
up+0xb0/0x110 [xfs]
Sep 15 07:30:51 fs1 kernel: [7369085.792522]  [<ffffffffa035f492>] xfs_vn_l=
ookup+0x42/0x90 [xfs]
Sep 15 07:30:51 fs1 kernel: [7369085.792562]  [<ffffffff81169b5c>] d_alloc_=
and_lookup+0x3c/0x90
Sep 15 07:30:51 fs1 kernel: [7369085.792569]  [<ffffffff8116beb3>] do_looku=
p+0x2a3/0x3a0
Sep 15 07:30:51 fs1 kernel: [7369085.792577]  [<ffffffff8116cc15>] path_loo=
kupat+0x135/0x730
Sep 15 07:30:51 fs1 kernel: [7369085.792585]  [<ffffffff8116d23c>] do_path_=
lookup+0x2c/0xd0
Sep 15 07:30:51 fs1 kernel: [7369085.792592]  [<ffffffff8116edac>] user_pat=
h_at_empty+0x5c/0xb0
Sep 15 07:30:51 fs1 kernel: [7369085.792597]  [<ffffffff81163efe>] vfs_fsta=
tat+0x3e/0x90
Sep 15 07:30:51 fs1 kernel: [7369085.792603]  [<ffffffff8116414f>] sys_newl=
stat+0x1f/0x50
Sep 15 07:30:51 fs1 kernel: [7369085.792609]  [<ffffffff815848b9>] system_c=
all_fastpath+0x16/0x1b
Sep 15 07:30:51 fs1 kernel: [7369085.792616]  [<00007f2e079aa4c5>] 0x7f2e07=
9aa4c4
Sep 15 07:30:51 fs1 kernel: [7369085.792619] XFS (sdd1): Corruption detecte=
d. Unmount and run xfs_repair


And this repeating again and again ...

This system has been running fine for 87 days, no power outages or such.
It's connected to an UPS, and the H800 Raid Controller has a BBU installed.

The XFS is mounted with these options:
/dev/sdd1 on /data_1 type xfs (rw,noatime,attr2,nobarrier,inode64,logbufs=
=3D8,logbsize=3D256k,sunit=3D128,swidth=3D1152,noquota,_netdev)


After running xfs_repair on it, the XFS could be mounted again, =

BUT several dirs and plain files were put into lost+found:

fs1:/data_1/lost+found # find . -type d | wc -l
115

fs1:/data_1/lost+found # find . -type f | wc -l
479

I have the full xfs_repair output. It's 56 MB uncompressed, and 1.1 MB gzip=
ped.
Should I attach/send it here?
Why could this have happened?
What more info can I provide to understand this issue and avoid this to hap=
pen again?

Many thanks,
Richard





-- =

Richard Ems       mail: Richard.Ems@Cape-Horn-Eng.com

Cape Horn Engineering S.L.
C/ Dr. J.J. D=F3mine 1, 5=BA piso
46011 Valencia
Tel : +34 96 3242923 / Fax 924
http://www.cape-horn-eng.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
