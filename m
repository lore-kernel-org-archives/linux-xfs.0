Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DF1107F4C
	for <xfs@oss.sgi.com>; Sun, 27 Jan 2013 16:53:11 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CCFF2304053
	for <xfs@oss.sgi.com>; Sun, 27 Jan 2013 14:53:08 -0800 (PST)
Received: from mho-02-ewr.mailhop.org (mho-04-ewr.mailhop.org [204.13.248.74])
	by cuda.sgi.com with ESMTP id yuueSPyVONjnDWUQ (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 27 Jan 2013 14:53:05 -0800 (PST)
Received: from 102.128.79.188.dynamic.jazztel.es ([188.79.128.102]
	helo=mail.viric.name)
	by mho-02-ewr.mailhop.org with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.72) (envelope-from <viric@viric.name>) id 1Tzb60-000BMI-1x
	for xfs@oss.sgi.com; Sun, 27 Jan 2013 22:53:04 +0000
Date: Sun, 27 Jan 2013 23:52:58 +0100
From: =?iso-8859-1?Q?Llu=EDs?= Batlle i Rossell <viric@viric.name>
Subject: Volume fine on x86_64, corruption on ARM
Message-ID: <20130127225258.GA2287@vicerveza.homeunix.net>
MIME-Version: 1.0
Content-Disposition: inline
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
To: xfs@oss.sgi.com

Hello,

I'm using linux 3.7.3 in both machines (x86_64 and armv5tel), and I created
a volume in x86_64 to be the rootfs for the ARM. All fine, until I plugged =
it
into the ARM (Log below).

Given the corruption, I used xfs_repair in the x86_64, moved a lot of files=
 into lost+found, plugged it back to the ARM, booted, and corruption again.

In the same USB HD, in the same ARM, and this same way, I've used succesful=
ly
ext4 and btrfs for a long time. Is there any known issue with ARM?

Thank you,
Llu=EDs.

----------------------
starting systemd...
systemd 197 running in system mode. (+PAM -LIBWRAP -AUDIT -SELINUX +IMA +SY=
SVINIT -LIBCRYPTSETUP +GCRYPT +ACL +XZ)

Welcome to NixOS 0.2pre-4eb2b09-af495e0!

Failed to insert module 'autofs4'
dea96000: 58 46 53 42 00 00 10 00 00 00 00 00 01 bd 26 f0  XFSB..........&.
XFS (sda1): Internal error xfs_da_do_buf(2) at line 2192 of file fs/xfs/xfs=
_da_btree.c.  Caller 0xbf057e68

[<c000ecd0>] (unwind_backtrace+0x0/0xfc) from [<c052d9c8>] (dump_stack+0x20=
/0x24)
[<c052d9c8>] (dump_stack+0x20/0x24) from [<bf016690>] (xfs_error_report+0x6=
4/0x70 [xfs])
[<bf016690>] (xfs_error_report+0x64/0x70 [xfs]) from [<bf016700>] (xfs_corr=
uption_error+0x64/0x80 [xfs])
[<bf016700>] (xfs_corruption_error+0x64/0x80 [xfs]) from [<bf051a28>] (xfs_=
da_read_buf+0x1ac/0x27c [xfs])
[<bf051a28>] (xfs_da_read_buf+0x1ac/0x27c [xfs]) from [<bf057e68>] (xfs_dir=
2_leaf_readbuf+0x220/0x5f0 [xfs])
[<bf057e68>] (xfs_dir2_leaf_readbuf+0x220/0x5f0 [xfs]) from [<bf058784>] (x=
fs_dir2_leaf_getdents+0x12c/0x3ec [xfs])
[<bf058784>] (xfs_dir2_leaf_getdents+0x12c/0x3ec [xfs]) from [<bf0545dc>] (=
xfs_readdir+0xf0/0x170 [xfs])
[<bf0545dc>] (xfs_readdir+0xf0/0x170 [xfs]) from [<bf017cc8>] (xfs_file_rea=
ddir+0x58/0x68 [xfs])
[<bf017cc8>] (xfs_file_readdir+0x58/0x68 [xfs]) from [<c00ff4a4>] (vfs_read=
dir+0x8c/0xb0)
[<c00ff4a4>] (vfs_readdir+0x8c/0xb0) from [<c00ff618>] (sys_getdents64+0x78=
/0xd8)
[<c00ff618>] (sys_getdents64+0x78/0xd8) from [<c0009340>] (ret_fast_syscall=
+0x0/0x2c)
XFS (sda1): Corruption detected. Unmount and run xfs_repair
dea96000: 58 46 53 42 00 00 10 00 00 00 00 00 01 bd 26 f0  XFSB..........&.
XFS (sda1): Internal error xfs_da_do_buf(2) at line 2192 of file fs/xfs/xfs=
_da_btree.c.  Caller 0xbf057e68

[<c000ecd0>] (unwind_backtrace+0x0/0xfc) from [<c052d9c8>] (dump_stack+0x20=
/0x24)
[<c052d9c8>] (dump_stack+0x20/0x24) from [<bf016690>] (xfs_error_report+0x6=
4/0x70 [xfs])
[<bf016690>] (xfs_error_report+0x64/0x70 [xfs]) from [<bf016700>] (xfs_corr=
uption_error+0x64/0x80 [xfs])
[<bf016700>] (xfs_corruption_error+0x64/0x80 [xfs]) from [<bf051a28>] (xfs_=
da_read_buf+0x1ac/0x27c [xfs])
[<bf051a28>] (xfs_da_read_buf+0x1ac/0x27c [xfs]) from [<bf057e68>] (xfs_dir=
2_leaf_readbuf+0x220/0x5f0 [xfs])
[<bf057e68>] (xfs_dir2_leaf_readbuf+0x220/0x5f0 [xfs]) from [<bf058784>] (x=
fs_dir2_leaf_getdents+0x12c/0x3ec [xfs])
[<bf058784>] (xfs_dir2_leaf_getdents+0x12c/0x3ec [xfs]) from [<bf0545dc>] (=
xfs_readdir+0xf0/0x170 [xfs])
[<bf0545dc>] (xfs_readdir+0xf0/0x170 [xfs]) from [<bf017cc8>] (xfs_file_rea=
ddir+0x58/0x68 [xfs])
[<bf017cc8>] (xfs_file_readdir+0x58/0x68 [xfs]) from [<c00ff4a4>] (vfs_read=
dir+0x8c/0xb0)
[<c00ff4a4>] (vfs_readdir+0x8c/0xb0) from [<c00ff618>] (sys_getdents64+0x78=
/0xd8)
[<c00ff618>] (sys_getdents64+0x78/0xd8) from [<c0009340>] (ret_fast_syscall=
+0x0/0x2c)
XFS (sda1): Corruption detected. Unmount and run xfs_repair
Failed to load default target: No such file or directory
Trying to load rescue target...
Failed to load rescue target: No such file or directory
systemd-cgroups-agent[1324]: Failed to get D-Bus connection: Failed to conn=
ect to socket /org/freedesktop/systemd1/private: Connection refused



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
