Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C9EA57F4E
	for <xfs@oss.sgi.com>; Wed, 27 Feb 2013 08:51:13 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B35778F8040
	for <xfs@oss.sgi.com>; Wed, 27 Feb 2013 06:51:10 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id p5jdc91xhUERZ0q1 for <xfs@oss.sgi.com>;
	Wed, 27 Feb 2013 06:51:09 -0800 (PST)
Message-ID: <512E1D5E.4070709@sandeen.net>
Date: Wed, 27 Feb 2013 08:51:10 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Volume fine on x86_64, corruption on ARM
References: <20130127225258.GA2287@vicerveza.homeunix.net>
In-Reply-To: <20130127225258.GA2287@vicerveza.homeunix.net>
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
To: =?ISO-8859-1?Q?Llu=EDs_Batlle_i_Rossell?= <viric@viric.name>
Cc: xfs@oss.sgi.com

On 1/27/13 4:52 PM, Llu=EDs Batlle i Rossell wrote:
> Hello,
> =

> I'm using linux 3.7.3 in both machines (x86_64 and armv5tel), and I creat=
ed
> a volume in x86_64 to be the rootfs for the ARM. All fine, until I plugge=
d it
> into the ARM (Log below).
> =

> Given the corruption, I used xfs_repair in the x86_64, moved a lot of fil=
es into lost+found, plugged it back to the ARM, booted, and corruption agai=
n.
> =

> In the same USB HD, in the same ARM, and this same way, I've used succesf=
ully
> ext4 and btrfs for a long time. Is there any known issue with ARM?

How is this kernel compiled, any chance that it is cross-compiled?

Could you try tracing xfs when this occurs?

You can use sysfs/debugfs to do it:

This should do it:

# mount -t debugfs none /sys/kernel/debug
# echo 1 > /sys/kernel/debug/tracing/tracing_enabled
# echo 1 > /sys/kernel/debug/tracing/events/xfs/xfs_da_btree_corrupt/enable

<run your failing run>

# cat /sys/kernel/debug/tracing/trace

-Eric

> Thank you,
> Llu=EDs.
> =

> ----------------------
> starting systemd...
> systemd 197 running in system mode. (+PAM -LIBWRAP -AUDIT -SELINUX +IMA +=
SYSVINIT -LIBCRYPTSETUP +GCRYPT +ACL +XZ)
> =

> Welcome to NixOS 0.2pre-4eb2b09-af495e0!
> =

> Failed to insert module 'autofs4'
> dea96000: 58 46 53 42 00 00 10 00 00 00 00 00 01 bd 26 f0  XFSB..........=
&.
> XFS (sda1): Internal error xfs_da_do_buf(2) at line 2192 of file fs/xfs/x=
fs_da_btree.c.  Caller 0xbf057e68
> =

> [<c000ecd0>] (unwind_backtrace+0x0/0xfc) from [<c052d9c8>] (dump_stack+0x=
20/0x24)
> [<c052d9c8>] (dump_stack+0x20/0x24) from [<bf016690>] (xfs_error_report+0=
x64/0x70 [xfs])
> [<bf016690>] (xfs_error_report+0x64/0x70 [xfs]) from [<bf016700>] (xfs_co=
rruption_error+0x64/0x80 [xfs])
> [<bf016700>] (xfs_corruption_error+0x64/0x80 [xfs]) from [<bf051a28>] (xf=
s_da_read_buf+0x1ac/0x27c [xfs])
> [<bf051a28>] (xfs_da_read_buf+0x1ac/0x27c [xfs]) from [<bf057e68>] (xfs_d=
ir2_leaf_readbuf+0x220/0x5f0 [xfs])
> [<bf057e68>] (xfs_dir2_leaf_readbuf+0x220/0x5f0 [xfs]) from [<bf058784>] =
(xfs_dir2_leaf_getdents+0x12c/0x3ec [xfs])
> [<bf058784>] (xfs_dir2_leaf_getdents+0x12c/0x3ec [xfs]) from [<bf0545dc>]=
 (xfs_readdir+0xf0/0x170 [xfs])
> [<bf0545dc>] (xfs_readdir+0xf0/0x170 [xfs]) from [<bf017cc8>] (xfs_file_r=
eaddir+0x58/0x68 [xfs])
> [<bf017cc8>] (xfs_file_readdir+0x58/0x68 [xfs]) from [<c00ff4a4>] (vfs_re=
addir+0x8c/0xb0)
> [<c00ff4a4>] (vfs_readdir+0x8c/0xb0) from [<c00ff618>] (sys_getdents64+0x=
78/0xd8)
> [<c00ff618>] (sys_getdents64+0x78/0xd8) from [<c0009340>] (ret_fast_sysca=
ll+0x0/0x2c)
> XFS (sda1): Corruption detected. Unmount and run xfs_repair
> dea96000: 58 46 53 42 00 00 10 00 00 00 00 00 01 bd 26 f0  XFSB..........=
&.
> XFS (sda1): Internal error xfs_da_do_buf(2) at line 2192 of file fs/xfs/x=
fs_da_btree.c.  Caller 0xbf057e68
> =

> [<c000ecd0>] (unwind_backtrace+0x0/0xfc) from [<c052d9c8>] (dump_stack+0x=
20/0x24)
> [<c052d9c8>] (dump_stack+0x20/0x24) from [<bf016690>] (xfs_error_report+0=
x64/0x70 [xfs])
> [<bf016690>] (xfs_error_report+0x64/0x70 [xfs]) from [<bf016700>] (xfs_co=
rruption_error+0x64/0x80 [xfs])
> [<bf016700>] (xfs_corruption_error+0x64/0x80 [xfs]) from [<bf051a28>] (xf=
s_da_read_buf+0x1ac/0x27c [xfs])
> [<bf051a28>] (xfs_da_read_buf+0x1ac/0x27c [xfs]) from [<bf057e68>] (xfs_d=
ir2_leaf_readbuf+0x220/0x5f0 [xfs])
> [<bf057e68>] (xfs_dir2_leaf_readbuf+0x220/0x5f0 [xfs]) from [<bf058784>] =
(xfs_dir2_leaf_getdents+0x12c/0x3ec [xfs])
> [<bf058784>] (xfs_dir2_leaf_getdents+0x12c/0x3ec [xfs]) from [<bf0545dc>]=
 (xfs_readdir+0xf0/0x170 [xfs])
> [<bf0545dc>] (xfs_readdir+0xf0/0x170 [xfs]) from [<bf017cc8>] (xfs_file_r=
eaddir+0x58/0x68 [xfs])
> [<bf017cc8>] (xfs_file_readdir+0x58/0x68 [xfs]) from [<c00ff4a4>] (vfs_re=
addir+0x8c/0xb0)
> [<c00ff4a4>] (vfs_readdir+0x8c/0xb0) from [<c00ff618>] (sys_getdents64+0x=
78/0xd8)
> [<c00ff618>] (sys_getdents64+0x78/0xd8) from [<c0009340>] (ret_fast_sysca=
ll+0x0/0x2c)
> XFS (sda1): Corruption detected. Unmount and run xfs_repair
> Failed to load default target: No such file or directory
> Trying to load rescue target...
> Failed to load rescue target: No such file or directory
> systemd-cgroups-agent[1324]: Failed to get D-Bus connection: Failed to co=
nnect to socket /org/freedesktop/systemd1/private: Connection refused
> =

> =

> =

> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> =


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
