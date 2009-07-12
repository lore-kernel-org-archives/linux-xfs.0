Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6CM7k09005896 for <xfs@oss.sgi.com>; Sun, 12 Jul 2009 17:07:47 -0500
Received: from mailsrv1.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E913535B7B2
	for <xfs@oss.sgi.com>; Sun, 12 Jul 2009 15:08:22 -0700 (PDT)
Received: from mailsrv1.zmi.at (mailsrv1.zmi.at [212.69.162.198]) by
	cuda.sgi.com with ESMTP id 1SEkRSVt3rHYdNhE for
	<xfs@oss.sgi.com>; Sun, 12 Jul 2009 15:08:22 -0700 (PDT)
Received: from mailsrv2.i.zmi.at (h081217106033.dyn.cm.kabsi.at
	[81.217.106.33])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv1.zmi.at (Postfix) with ESMTP id 639E14E10
	for <xfs@oss.sgi.com>; Mon, 13 Jul 2009 00:09:11 +0200 (CEST)
Received: from saturn.localnet (unknown [10.72.27.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv2.i.zmi.at (Postfix) with ESMTPSA id 94767400154
	for <xfs@oss.sgi.com>; Mon, 13 Jul 2009 00:08:21 +0200 (CEST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: bad fs - xfs_repair 3.01 crashes on it
Date: Mon, 13 Jul 2009 00:08:20 +0200
References: <200907031320.48358@zmi.at> <4A5A30E4.6090309@sandeen.net>
In-Reply-To: <4A5A30E4.6090309@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200907130008.21006@zmi.at>
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

On Sonntag 12 Juli 2009 Eric Sandeen wrote:
> Just out of curiosity, it looks like you have rather a lot of
> extended attributes on at least the inode above, is that accurate?
> =A0Or maybe that's part of the corruption?

# find . -inum 3857051697
find: "./samba/tmp/BettyPC.tib": Die Struktur muss bereinigt werden
(means: structure needs cleaning)

I'm not sure if that message means that file has the corresponding inode
number? If it is, it's a backup of a PC made with Acronis.

Normally I only use xattr's to set one or two extra rights

> I'll focus on getting xfs_repair to cope first, but I wonder what
> happened here...

No idea. Didn't have a crash on that server IIRC. I tried some "ls" =

and "getfacl" and got these crashes:

Jul 13 00:01:10 orion.i.zmi.at kernel: Filesystem "dm-0": corrupt inode 385=
7051697 ((a)extents =3D 5).  Unmount and run xfs_repair.
Jul 13 00:01:10 orion.i.zmi.at kernel: Pid: 17213, comm: find Tainted: G   =
       2.6.27.23-0.1-xen #1
Jul 13 00:01:10 orion.i.zmi.at kernel:
Jul 13 00:01:10 orion.i.zmi.at kernel: Call Trace:
Jul 13 00:01:10 orion.i.zmi.at kernel:  [<ffffffff8020c597>] show_trace_log=
_lvl+0x41/0x58
Jul 13 00:01:10 orion.i.zmi.at kernel:  [<ffffffff80463a33>] dump_stack+0x6=
9/0x6f
Jul 13 00:01:10 orion.i.zmi.at kernel:  [<ffffffffa033abf8>] xfs_iformat_ex=
tents+0xc9/0x1c4 [xfs]
Jul 13 00:01:10 orion.i.zmi.at kernel:  [<ffffffffa033b153>] xfs_iformat+0x=
2b0/0x3f7 [xfs]
Jul 13 00:01:10 orion.i.zmi.at kernel:  [<ffffffffa033b381>] xfs_iread+0xe7=
/0x1ee [xfs]
Jul 13 00:01:10 orion.i.zmi.at kernel:  [<ffffffffa0336928>] xfs_iget_core+=
0x3a5/0x63a [xfs]
Jul 13 00:01:10 orion.i.zmi.at kernel:  [<ffffffffa0336c9f>] xfs_iget+0xe2/=
0x187 [xfs]
Jul 13 00:01:10 orion.i.zmi.at kernel:  [<ffffffffa0350941>] xfs_lookup+0x7=
9/0xa5 [xfs]
Jul 13 00:01:10 orion.i.zmi.at kernel:  [<ffffffffa035955b>] xfs_vn_lookup+=
0x3c/0x78 [xfs]
Jul 13 00:01:10 orion.i.zmi.at kernel:  [<ffffffff802a5d27>] real_lookup+0x=
7e/0x10f
Jul 13 00:01:10 orion.i.zmi.at kernel:  [<ffffffff802a5e1b>] do_lookup+0x63=
/0xb6
Jul 13 00:01:10 orion.i.zmi.at kernel:  [<ffffffff802a84a8>] __link_path_wa=
lk+0x9f4/0xe58
Jul 13 00:01:10 orion.i.zmi.at kernel:  [<ffffffff802a8ad7>] path_walk+0x5e=
/0xb9
Jul 13 00:01:10 orion.i.zmi.at kernel:  [<ffffffff802a8c94>] do_path_lookup=
+0x162/0x1b9
Jul 13 00:01:10 orion.i.zmi.at kernel:  [<ffffffff802a962e>] user_path_at+0=
x48/0x79
Jul 13 00:01:10 orion.i.zmi.at kernel:  [<ffffffff802a1b65>] vfs_lstat_fd+0=
x15/0x41
Jul 13 00:01:10 orion.i.zmi.at kernel:  [<ffffffff802a1c68>] sys_newfstatat=
+0x22/0x43
Jul 13 00:01:10 orion.i.zmi.at kernel:  [<ffffffff8020b3b8>] system_call_fa=
stpath+0x16/0x1b
Jul 13 00:01:10 orion.i.zmi.at kernel:  [<00007f802a89f4ce>] 0x7f802a89f4ce
Jul 13 00:01:10 orion.i.zmi.at kernel:
Jul 13 00:02:35 orion.i.zmi.at kernel: Filesystem "dm-0": corrupt inode 385=
7051697 ((a)extents =3D 5).  Unmount and run xfs_repair.
Jul 13 00:02:35 orion.i.zmi.at kernel: Pid: 17232, comm: getfacl Tainted: G=
          2.6.27.23-0.1-xen #1
Jul 13 00:02:35 orion.i.zmi.at kernel:
Jul 13 00:02:35 orion.i.zmi.at kernel: Call Trace:
Jul 13 00:02:35 orion.i.zmi.at kernel:  [<ffffffff8020c597>] show_trace_log=
_lvl+0x41/0x58
Jul 13 00:02:35 orion.i.zmi.at kernel:  [<ffffffff80463a33>] dump_stack+0x6=
9/0x6f
Jul 13 00:02:35 orion.i.zmi.at kernel:  [<ffffffffa033abf8>] xfs_iformat_ex=
tents+0xc9/0x1c4 [xfs]
Jul 13 00:02:35 orion.i.zmi.at kernel:  [<ffffffffa033b153>] xfs_iformat+0x=
2b0/0x3f7 [xfs]
Jul 13 00:02:35 orion.i.zmi.at kernel:  [<ffffffffa033b381>] xfs_iread+0xe7=
/0x1ee [xfs]
Jul 13 00:02:35 orion.i.zmi.at kernel:  [<ffffffffa0336928>] xfs_iget_core+=
0x3a5/0x63a [xfs]
Jul 13 00:02:35 orion.i.zmi.at kernel:  [<ffffffffa0336c9f>] xfs_iget+0xe2/=
0x187 [xfs]
Jul 13 00:02:35 orion.i.zmi.at kernel:  [<ffffffffa0350941>] xfs_lookup+0x7=
9/0xa5 [xfs]
Jul 13 00:02:35 orion.i.zmi.at kernel:  [<ffffffffa035955b>] xfs_vn_lookup+=
0x3c/0x78 [xfs]
Jul 13 00:02:35 orion.i.zmi.at kernel:  [<ffffffff802a5d27>] real_lookup+0x=
7e/0x10f
Jul 13 00:02:35 orion.i.zmi.at kernel:  [<ffffffff802a5e1b>] do_lookup+0x63=
/0xb6
Jul 13 00:02:35 orion.i.zmi.at kernel:  [<ffffffff802a84a8>] __link_path_wa=
lk+0x9f4/0xe58
Jul 13 00:02:35 orion.i.zmi.at kernel:  [<ffffffff802a8ad7>] path_walk+0x5e=
/0xb9
Jul 13 00:02:35 orion.i.zmi.at kernel:  [<ffffffff802a8c94>] do_path_lookup=
+0x162/0x1b9
Jul 13 00:02:35 orion.i.zmi.at kernel:  [<ffffffff802a962e>] user_path_at+0=
x48/0x79
Jul 13 00:02:35 orion.i.zmi.at kernel:  [<ffffffff802a1b65>] vfs_lstat_fd+0=
x15/0x41
Jul 13 00:02:35 orion.i.zmi.at kernel:  [<ffffffff802a1baa>] sys_newlstat+0=
x19/0x31
Jul 13 00:02:35 orion.i.zmi.at kernel:  [<ffffffff8020b3b8>] system_call_fa=
stpath+0x16/0x1b
Jul 13 00:02:35 orion.i.zmi.at kernel:  [<00007f9a8d911225>] 0x7f9a8d911225

Jul 11 03:02:53 orion.i.zmi.at kernel: Filesystem "dm-0": corrupt inode 385=
7051697 ((a)extents =3D 5).  Unmount and run xfs_repair.
Jul 11 03:02:53 orion.i.zmi.at kernel: Pid: 2881, comm: xfs_fsr Tainted: G =
         2.6.27.23-0.1-xen #1
Jul 11 03:02:53 orion.i.zmi.at kernel:
Jul 11 03:02:53 orion.i.zmi.at kernel: Call Trace:
Jul 11 03:02:53 orion.i.zmi.at kernel:  [<ffffffff8020c597>] show_trace_log=
_lvl+0x41/0x58
Jul 11 03:02:53 orion.i.zmi.at kernel:  [<ffffffff80463a33>] dump_stack+0x6=
9/0x6f
Jul 11 03:02:53 orion.i.zmi.at kernel:  [<ffffffffa033abf8>] xfs_iformat_ex=
tents+0xc9/0x1c4 [xfs]
Jul 11 03:02:53 orion.i.zmi.at kernel:  [<ffffffffa033b153>] xfs_iformat+0x=
2b0/0x3f7 [xfs]
Jul 11 03:02:53 orion.i.zmi.at kernel:  [<ffffffffa033b381>] xfs_iread+0xe7=
/0x1ee [xfs]
Jul 11 03:02:53 orion.i.zmi.at kernel:  [<ffffffffa0336928>] xfs_iget_core+=
0x3a5/0x63a [xfs]
Jul 11 03:02:53 orion.i.zmi.at kernel:  [<ffffffffa0336c9f>] xfs_iget+0xe2/=
0x187 [xfs]
Jul 11 03:02:53 orion.i.zmi.at kernel:  [<ffffffffa0358336>] xfs_vget_fsop_=
handlereq+0xc2/0x11b [xfs]
Jul 11 03:02:53 orion.i.zmi.at kernel:  [<ffffffffa03583ef>] xfs_open_by_ha=
ndle+0x60/0x1cb [xfs]
Jul 11 03:02:53 orion.i.zmi.at kernel:  [<ffffffffa0358f9e>] xfs_ioctl+0x3c=
a/0x680 [xfs]
Jul 11 03:02:53 orion.i.zmi.at kernel:  [<ffffffffa035702a>] xfs_file_ioctl=
+0x25/0x69 [xfs]
Jul 11 03:02:53 orion.i.zmi.at kernel:  [<ffffffff802aab39>] vfs_ioctl+0x21=
/0x6c
Jul 11 03:02:53 orion.i.zmi.at kernel:  [<ffffffff802aada6>] do_vfs_ioctl+0=
x222/0x231
Jul 11 03:02:53 orion.i.zmi.at kernel:  [<ffffffff802aae06>] sys_ioctl+0x51=
/0x73
Jul 11 03:02:53 orion.i.zmi.at kernel:  [<ffffffff8020b3b8>] system_call_fa=
stpath+0x16/0x1b
Jul 11 03:02:53 orion.i.zmi.at kernel:  [<00007fc76ba0bb77>] 0x7fc76ba0bb77

I also found this one:
Jul 12 00:01:29 orion.i.zmi.at kernel: Filesystem "dm-0": corrupt inode 385=
7051697 ((a)extents =3D 5).  Unmount and run xfs_repair.
Jul 12 00:01:29 orion.i.zmi.at kernel: 00000000: 49 4e 81 ff 02 02 00 00 00=
 00 03 e8 00 00 00 64  IN.............d
Jul 12 00:01:29 orion.i.zmi.at kernel: Filesystem "dm-0": XFS internal erro=
r xfs_iformat_extents(1) at line 565 of file fs/xfs/xfs_inode.c.  Caller 0x=
ffffffffa033b153
Jul 12 00:01:29 orion.i.zmi.at kernel: Pid: 9592, comm: find Tainted: G    =
      2.6.27.23-0.1-xen #1
Jul 12 00:01:29 orion.i.zmi.at kernel:
Jul 12 00:01:29 orion.i.zmi.at kernel: Call Trace:
Jul 12 00:01:29 orion.i.zmi.at kernel:  [<ffffffff8020c597>] show_trace_log=
_lvl+0x41/0x58
Jul 12 00:01:29 orion.i.zmi.at kernel:  [<ffffffff80463a33>] dump_stack+0x6=
9/0x6f
Jul 12 00:01:29 orion.i.zmi.at kernel:  [<ffffffffa033abf8>] xfs_iformat_ex=
tents+0xc9/0x1c4 [xfs]
Jul 12 00:01:29 orion.i.zmi.at kernel:  [<ffffffffa033b153>] xfs_iformat+0x=
2b0/0x3f7 [xfs]
Jul 12 00:01:29 orion.i.zmi.at kernel:  [<ffffffffa033b381>] xfs_iread+0xe7=
/0x1ee [xfs]
Jul 12 00:01:29 orion.i.zmi.at kernel:  [<ffffffffa0336928>] xfs_iget_core+=
0x3a5/0x63a [xfs]
Jul 12 00:01:29 orion.i.zmi.at kernel:  [<ffffffffa0336c9f>] xfs_iget+0xe2/=
0x187 [xfs]
Jul 12 00:01:29 orion.i.zmi.at kernel:  [<ffffffffa0350941>] xfs_lookup+0x7=
9/0xa5 [xfs]
Jul 12 00:01:29 orion.i.zmi.at kernel:  [<ffffffffa035955b>] xfs_vn_lookup+=
0x3c/0x78 [xfs]
Jul 12 00:01:29 orion.i.zmi.at kernel:  [<ffffffff802a5d27>] real_lookup+0x=
7e/0x10f
Jul 12 00:01:29 orion.i.zmi.at kernel:  [<ffffffff802a5e1b>] do_lookup+0x63=
/0xb6
Jul 12 00:01:29 orion.i.zmi.at kernel:  [<ffffffff802a84a8>] __link_path_wa=
lk+0x9f4/0xe58
Jul 12 00:01:29 orion.i.zmi.at kernel:  [<ffffffff802a8ad7>] path_walk+0x5e=
/0xb9
Jul 12 00:01:29 orion.i.zmi.at kernel:  [<ffffffff802a8c94>] do_path_lookup=
+0x162/0x1b9
Jul 12 00:01:29 orion.i.zmi.at kernel:  [<ffffffff802a962e>] user_path_at+0=
x48/0x79
Jul 12 00:01:29 orion.i.zmi.at kernel:  [<ffffffff802a1b65>] vfs_lstat_fd+0=
x15/0x41
Jul 12 00:01:29 orion.i.zmi.at kernel:  [<ffffffff802a1c68>] sys_newfstatat=
+0x22/0x43
Jul 12 00:01:29 orion.i.zmi.at kernel:  [<ffffffff8020b3b8>] system_call_fa=
stpath+0x16/0x1b
Jul 12 00:01:29 orion.i.zmi.at kernel:  [<00007fdc209084ce>] 0x7fdc209084ce


mfg zmi
-- =

// Michael Monnerie, Ing.BSc    -----      http://it-management.at
// Tel: 0660 / 415 65 31                      .network.your.ideas.
// PGP Key:         "curl -s http://zmi.at/zmi.asc | gpg --import"
// Fingerprint: AC19 F9D5 36ED CD8A EF38  500E CE14 91F7 1C12 09B4
// Keyserver: wwwkeys.eu.pgp.net                  Key-ID: 1C1209B4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
