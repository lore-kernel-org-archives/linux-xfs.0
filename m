Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9HEh0nw004202 for <xfs@oss.sgi.com>; Mon, 17 Oct 2011 09:43:00 -0500
Received: from smtprelay01.ispgateway.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7E230562366
	for <xfs@oss.sgi.com>; Mon, 17 Oct 2011 07:42:57 -0700 (PDT)
Received: from smtprelay01.ispgateway.de (smtprelay01.ispgateway.de
	[80.67.18.43]) by cuda.sgi.com with ESMTP id 7KxO5SJPBi0KBD3N
	for <xfs@oss.sgi.com>; Mon, 17 Oct 2011 07:42:57 -0700 (PDT)
Received: from [62.43.225.238] (helo=[192.168.30.191])
	by smtprelay01.ispgateway.de with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.68) (envelope-from <richard.ems@cape-horn-eng.com>)
	id 1RFoP2-0001lK-8q
	for xfs@oss.sgi.com; Mon, 17 Oct 2011 16:42:56 +0200
Message-ID: <4E9C3EEF.5080609@cape-horn-eng.com>
Date: Mon, 17 Oct 2011 16:42:55 +0200
From: Richard Ems <richard.ems@cape-horn-eng.com>
MIME-Version: 1.0
Subject: xfs_repair v3.1.6 - Segmentation fault AND XFS internal error
	xfs_btree_check_sblock
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

Hi all !

We have a XFS that started giving errors some days ago.
This is on an openSUSE 11.4 64 bit system.
The XFS is 12 TB big, 9.8 TB are used. Hardware RAID 6 on an Areca 1680 con=
troller.

Mounting the XFS with ro,norecovery works almost always.

But xfs_repair crashes with a Segmentation fault. I tried both v3.1.4 from =

openSUSE 11.4 and xfs_repair v3.1.6 downloaded from the git repo.

Now after a reboot - the ___production___system completely freezed while ru=
nning =

the last xfs_repair v3.1.6 !!! - the XFS got mounted rw, but just trying to =

touch a file generated the following error:


Oct 17 16:33:02 c3m kernel: [  794.628715] Filesystem "sdb1": XFS internal =
error xfs_btree_check_sblock at line 120 of file /usr/src/packages/BUILD/ke=
rnel-default-2.6.37.6/linux-2.6.37/fs/xfs/xfs_btree.c.  Caller 0xffffffffa0=
376cbe
Oct 17 16:33:02 c3m kernel: [  794.628718] =

Oct 17 16:33:02 c3m kernel: [  794.628722] Pid: 9066, comm: touch Not taint=
ed 2.6.37.6-0.7-default #1
Oct 17 16:33:02 c3m kernel: [  794.628724] Call Trace:
Oct 17 16:33:02 c3m kernel: [  794.628737]  [<ffffffff81005819>] dump_trace=
+0x69/0x2e0
Oct 17 16:33:02 c3m kernel: [  794.628744]  [<ffffffff814ba5c3>] dump_stack=
+0x69/0x6f
Oct 17 16:33:02 c3m kernel: [  794.628776]  [<ffffffffa0376666>] xfs_btree_=
check_sblock+0x86/0x120 [xfs]
Oct 17 16:33:02 c3m kernel: [  794.628864]  [<ffffffffa0376cbe>] xfs_btree_=
read_buf_block.clone.0+0x9e/0xc0 [xfs]
Oct 17 16:33:02 c3m kernel: [  794.628947]  [<ffffffffa0378a3e>] xfs_btree_=
increment+0x1ee/0x290 [xfs]
Oct 17 16:33:02 c3m kernel: [  794.629036]  [<ffffffffa038e522>] xfs_diallo=
c+0x5e2/0x900 [xfs]
Oct 17 16:33:02 c3m kernel: [  794.629148]  [<ffffffffa0390bd5>] xfs_ialloc=
+0x75/0x6d0 [xfs]
Oct 17 16:33:02 c3m kernel: [  794.629259]  [<ffffffffa03aaa25>] xfs_dir_ia=
lloc+0x95/0x340 [xfs]
Oct 17 16:33:02 c3m kernel: [  794.629409]  [<ffffffffa03adbb6>] xfs_create=
+0x406/0x6c0 [xfs]
Oct 17 16:33:02 c3m kernel: [  794.629560]  [<ffffffffa03b9fdf>] xfs_vn_mkn=
od+0xaf/0x1d0 [xfs]
Oct 17 16:33:02 c3m kernel: [  794.629717]  [<ffffffff811552c3>] vfs_create=
+0x113/0x190
Oct 17 16:33:02 c3m kernel: [  794.629724]  [<ffffffff81155c52>] do_last+0x=
572/0x600
Oct 17 16:33:02 c3m kernel: [  794.629730]  [<ffffffff81155e88>] do_filp_op=
en+0x1a8/0x610
Oct 17 16:33:02 c3m kernel: [  794.629736]  [<ffffffff81147496>] do_sys_ope=
n+0x66/0x110
Oct 17 16:33:02 c3m kernel: [  794.629743]  [<ffffffff81002e4b>] system_cal=
l_fastpath+0x16/0x1b
Oct 17 16:33:02 c3m kernel: [  794.629754]  [<00007fbb0de57ce0>] 0x7fbb0de5=
7ce0


The last lines before the " xfs_repair -n -P /dev/sdb1 " Segmentation fault=
 where:

would clear forw/back pointers in block 0 for attributes in inode 4319273
bad attribute leaf magic # 0x250 for dir ino 4319273
problem with attribute contents in inode 4319273
would clear attr fork
bad nblocks 2 for inode 4319273, would reset to 1
bad anextents 1 for inode 4319273, would reset to 0
-bash: line 5:  6488 Segmentation fault      /opt/xfsprogs-3.1.6/sbin/xfs_r=
epair -n -P /dev/sdb1

The complete " xfs_repair -n -P /dev/sdb1 " output file is 1.2 MB gzipped. =
If anyone wants =

to have a look at it please ask and I will send it as a private mail.


What can I do to recover/repair this XFS ? We have important data in there !

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
