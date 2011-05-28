Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4SEGKtZ107659 for <xfs@oss.sgi.com>; Sat, 28 May 2011 09:16:20 -0500
Received: from mail-fx0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 020FE48B775
	for <xfs@oss.sgi.com>; Sat, 28 May 2011 07:16:18 -0700 (PDT)
Received: from mail-fx0-f53.google.com (mail-fx0-f53.google.com
	[209.85.161.53]) by cuda.sgi.com with ESMTP id ulnXIAthFwb6tHlp
	for <xfs@oss.sgi.com>; Sat, 28 May 2011 07:16:18 -0700 (PDT)
Received: by fxm8 with SMTP id 8so1982966fxm.26
	for <xfs@oss.sgi.com>; Sat, 28 May 2011 07:16:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTi=B1S2+V4VvLM5X5Ea+S4r82RbaTQ@mail.gmail.com>
References: <BANLkTi=B1S2+V4VvLM5X5Ea+S4r82RbaTQ@mail.gmail.com>
Date: Sat, 28 May 2011 09:16:17 -0500
Message-ID: <BANLkTikxZgxyoAG-k2BJFvfKviHxnwHBgA@mail.gmail.com>
Subject: Re: xfs revival
From: James Grossmann <cctsurf@gmail.com>
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

On Sat, May 28, 2011 at 12:12 AM, James Grossmann <cctsurf@gmail.com> wrote:
> I recently decided to build a raid10 on my server. =A0sadly shortly
> after I built it, a pair of the drives (mirroring each other) dropped
> errors at the same time, but upon a little revival are both actively
> working. =A0I resynced the raid, but now I'm having difficulties
> reviving my xfs file system.
> I'm running ubuntu server 11.04, which includes xfsprogs 3.1.4.
> I have been attempting to get the git version or even 3.1.5 working on
> my system because I continue to get errors in attempting to xfs_repair
> the volume, but they don't seem to want to build for me. =A0I kept
> getting a hang on inode 2111, but with some searching found the
> command: sudo xfs_repair -P -o bhash=3D1024 /dev/md0 to get me to inode
> 538638356. =A0However, it fails at that point with the following
> message:
> corrupt dinode 538638356, extent total =3D 1, nblocks =3D 0. =A0This is a=
 bug.
> Please capture the filesystem metadata with xfs_metadump and
> report it to xfs@oss.sgi.com.
> cache_node_purge: refcount was 1, not zero (node=3D0x3412410)
>
> fatal error -- 117 - couldn't iget disconnected inode
>
> When I attempt the referenced command, it fails on me with the
> following error, I have attached the file it produces in dumping.
> udo xfs_metadump /dev/md/OlIronsides\:0 Olironsides.xfs.metadump
> cache_node_purge: refcount was 1, not zero (node=3D0x20b2420)
> xfs_metadump: cannot read root inode (117)
> cache_node_purge: refcount was 1, not zero (node=3D0x20b6020)
> xfs_metadump: cannot read realtime bitmap inode (117)
> *** glibc detected *** xfs_db: free(): invalid next size (normal):
> 0x00000000020d6000 ***
> =3D=3D=3D=3D=3D=3D=3D Backtrace: =3D=3D=3D=3D=3D=3D=3D=3D=3D
> /lib/x86_64-linux-gnu/libc.so.6(+0x78a8f)[0x7f5c6ca5ca8f]
> /lib/x86_64-linux-gnu/libc.so.6(cfree+0x73)[0x7f5c6ca608e3]
> xfs_db[0x415cb3]
> xfs_db[0x418f47]
> xfs_db[0x4175f0]
> xfs_db[0x419f60]
> xfs_db[0x414d72]
> /lib/x86_64-linux-gnu/libc.so.6(__libc_start_main+0xff)[0x7f5c6ca02eff]
> xfs_db[0x402819]
> =3D=3D=3D=3D=3D=3D=3D Memory map: =3D=3D=3D=3D=3D=3D=3D=3D
> 00400000-0046a000 r-xp 00000000 08:01 2369055
> =A0/usr/sbin/xfs_db
> 00669000-0066a000 r--p 00069000 08:01 2369055
> =A0/usr/sbin/xfs_db
> 0066a000-0066b000 rw-p 0006a000 08:01 2369055
> =A0/usr/sbin/xfs_db
> 0066b000-00676000 rw-p 00000000 00:00 0
> 02090000-0214d000 rw-p 00000000 00:00 0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0[heap]
> 7f5c68000000-7f5c68021000 rw-p 00000000 00:00 0
> 7f5c68021000-7f5c6c000000 ---p 00000000 00:00 0
> 7f5c6c0e2000-7f5c6c0f7000 r-xp 00000000 08:01 784940
> =A0/lib/x86_64-linux-gnu/libgcc_s.so.1
> 7f5c6c0f7000-7f5c6c2f6000 ---p 00015000 08:01 784940
> =A0/lib/x86_64-linux-gnu/libgcc_s.so.1
> 7f5c6c2f6000-7f5c6c2f7000 r--p 00014000 08:01 784940
> =A0/lib/x86_64-linux-gnu/libgcc_s.so.1
> 7f5c6c2f7000-7f5c6c2f8000 rw-p 00015000 08:01 784940
> =A0/lib/x86_64-linux-gnu/libgcc_s.so.1
> 7f5c6c2f8000-7f5c6c59c000 r--p 00000000 08:01 2360086
> =A0/usr/lib/locale/locale-archive
> 7f5c6c59c000-7f5c6c59e000 r-xp 00000000 08:01 784922
> =A0/lib/x86_64-linux-gnu/libdl-2.13.so
> 7f5c6c59e000-7f5c6c79e000 ---p 00002000 08:01 784922
> =A0/lib/x86_64-linux-gnu/libdl-2.13.so
> 7f5c6c79e000-7f5c6c79f000 r--p 00002000 08:01 784922
> =A0/lib/x86_64-linux-gnu/libdl-2.13.so
> 7f5c6c79f000-7f5c6c7a0000 rw-p 00003000 08:01 784922
> =A0/lib/x86_64-linux-gnu/libdl-2.13.so
> 7f5c6c7a0000-7f5c6c7e0000 r-xp 00000000 08:01 784972
> =A0/lib/libncurses.so.5.7
> 7f5c6c7e0000-7f5c6c9df000 ---p 00040000 08:01 784972
> =A0/lib/libncurses.so.5.7
> 7f5c6c9df000-7f5c6c9e3000 r--p 0003f000 08:01 784972
> =A0/lib/libncurses.so.5.7
> 7f5c6c9e3000-7f5c6c9e4000 rw-p 00043000 08:01 784972
> =A0/lib/libncurses.so.5.7
> 7f5c6c9e4000-7f5c6cb6e000 r-xp 00000000 08:01 784915
> =A0/lib/x86_64-linux-gnu/libc-2.13.so
> 7f5c6cb6e000-7f5c6cd6d000 ---p 0018a000 08:01 784915
> =A0/lib/x86_64-linux-gnu/libc-2.13.so
> 7f5c6cd6d000-7f5c6cd71000 r--p 00189000 08:01 784915
> =A0/lib/x86_64-linux-gnu/libc-2.13.so
> 7f5c6cd71000-7f5c6cd72000 rw-p 0018d000 08:01 784915
> =A0/lib/x86_64-linux-gnu/libc-2.13.so
> 7f5c6cd72000-7f5c6cd78000 rw-p 00000000 00:00 0
> 7f5c6cd78000-7f5c6cdb1000 r-xp 00000000 08:01 785158
> =A0/lib/libreadline.so.6.2
> 7f5c6cdb1000-7f5c6cfb1000 ---p 00039000 08:01 785158
> =A0/lib/libreadline.so.6.2
> 7f5c6cfb1000-7f5c6cfb3000 r--p 00039000 08:01 785158
> =A0/lib/libreadline.so.6.2
> 7f5c6cfb3000-7f5c6cfb9000 rw-p 0003b000 08:01 785158
> =A0/lib/libreadline.so.6.2
> 7f5c6cfb9000-7f5c6cfba000 rw-p 00000000 00:00 0
> 7f5c6cfba000-7f5c6cfd2000 r-xp 00000000 08:01 784933
> =A0/lib/x86_64-linux-gnu/libpthread-2.13.so
> 7f5c6cfd2000-7f5c6d1d2000 ---p 00018000 08:01 784933
> =A0/lib/x86_64-linux-gnu/libpthread-2.13.so
> 7f5c6d1d2000-7f5c6d1d3000 r--p 00018000 08:01 784933
> =A0/lib/x86_64-linux-gnu/libpthread-2.13.so
> 7f5c6d1d3000-7f5c6d1d4000 rw-p 00019000 08:01 784933
> =A0/lib/x86_64-linux-gnu/libpthread-2.13.so
> 7f5c6d1d4000-7f5c6d1d8000 rw-p 00000000 00:00 0
> 7f5c6d1d8000-7f5c6d1dc000 r-xp 00000000 08:01 785015
> =A0/lib/x86_64-linux-gnu/libuuid.so.1.3.0
> 7f5c6d1dc000-7f5c6d3db000 ---p 00004000 08:01 785015
> =A0/lib/x86_64-linux-gnu/libuuid.so.1.3.0
> 7f5c6d3db000-7f5c6d3dc000 r--p 00003000 08:01 785015
> =A0/lib/x86_64-linux-gnu/libuuid.so.1.3.0
> 7f5c6d3dc000-7f5c6d3dd000 rw-p 00004000 08:01 785015
> =A0/lib/x86_64-linux-gnu/libuuid.so.1.3.0
> 7f5c6d3dd000-7f5c6d3fe000 r-xp 00000000 08:01 784912
> =A0/lib/x86_64-linux-gnu/ld-2.13.so
> 7f5c6d5ab000-7f5c6d5f1000 rw-p 00000000 00:00 0
> 7f5c6d5fa000-7f5c6d5fd000 rw-p 00000000 00:00 0
> 7f5c6d5fd000-7f5c6d5fe000 r--p 00020000 08:01 784912
> =A0/lib/x86_64-linux-gnu/ld-2.13.so
> 7f5c6d5fe000-7f5c6d600000 rw-p 00021000 08:01 784912
> =A0/lib/x86_64-linux-gnu/ld-2.13.so
> 7fffcdb88000-7fffcdba9000 rw-p 00000000 00:00 0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0[stack]
> 7fffcdbff000-7fffcdc00000 r-xp 00000000 00:00 0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0[vdso]
> ffffffffff600000-ffffffffff601000 r-xp 00000000 00:00 0
> =A0[vsyscall]
> Aborted
>
> Thank You,
> James
>

I was able to install the ubuntu Oneiric Ocelot's version of xfsprogs
(3.1.5), but I still get the same error at the same place.
Following the user guide, I was able to read inode 538638356:

sudo xfs_db -c "inode 538638356" -c "print" /dev/md/OlIronsides\:0
cache_node_purge: refcount was 1, not zero (node=3D0x2062420)
xfs_db: cannot read root inode (117)
cache_node_purge: refcount was 1, not zero (node=3D0x2066020)
xfs_db: cannot read realtime bitmap inode (117)
core.magic =3D 0x494e
core.mode =3D 0100755
core.version =3D 2
core.format =3D 2 (extents)
core.nlinkv2 =3D 1
core.onlink =3D 0
core.projid_lo =3D 0
core.projid_hi =3D 0
core.uid =3D 1000
core.gid =3D 100
core.flushiter =3D 3
core.atime.sec =3D Wed May 25 22:44:12 2011
core.atime.nsec =3D 569449438
core.mtime.sec =3D Sat Dec 12 13:55:26 2009
core.mtime.nsec =3D 000000000
core.ctime.sec =3D Thu May 26 16:14:51 2011
core.ctime.nsec =3D 201400000
core.size =3D 5035163
core.nblocks =3D 1230
core.extsize =3D 0
core.nextents =3D 1
core.naextents =3D 0
core.forkoff =3D 0
core.aformat =3D 2 (extents)
core.dmevmask =3D 0
core.dmstate =3D 0
core.newrtbm =3D 0
core.prealloc =3D 0
core.realtime =3D 0
core.immutable =3D 0
core.append =3D 0
core.sync =3D 0
core.noatime =3D 0
core.nodump =3D 0
core.rtinherit =3D 0
core.projinherit =3D 0
core.nosymlinks =3D 0
core.extsz =3D 0
core.extszinherit =3D 0
core.nodefrag =3D 0
core.filestream =3D 0
core.gen =3D 2106989417
next_unlinked =3D null
u.bmx[0] =3D [startoff,startblock,blockcount,extentflag] 0:[0,386750464,123=
0,0]

I'm having problems building the git xfsprogs, I get the following
error when I run make, I'm guessing I just don't have something
installed for the build.

autoconf: Undefined macros:
configure.in:100:AC_PACKAGE_NEED_PTHREADMUTEXINIT
configure.in:102:AC_HAVE_FADVISE
configure.in:103:AC_HAVE_MADVISE
configure.in:104:AC_HAVE_MINCORE
configure.in:105:AC_HAVE_SENDFILE
configure.in:106:AC_HAVE_GETMNTENT
configure.in:107:AC_HAVE_GETMNTINFO
configure.in:108:AC_HAVE_FALLOCATE
configure.in:109:AC_HAVE_FIEMAP
configure.in:110:AC_HAVE_BLKID_TOPO($enable_blkid)
configure.in:112:AC_TYPE_PSINT
configure.in:113:AC_TYPE_PSUNSIGNED
configure.in:114:AC_TYPE_U32
configure.in:115:AC_SIZEOF_POINTERS_AND_LONG
configure.in:116:AC_MANUAL_FORMAT
configure.in:3:AC_CONFIG_MACRO_DIR([m4])
configure.in:7:AC_PROG_LIBTOOL
configure.in:89:AC_PACKAGE_GLOBALS(xfsprogs)
configure.in:90:AC_PACKAGE_UTILITIES(xfsprogs)
configure.in:91:AC_MULTILIB($enable_lib64)
configure.in:93:AC_PACKAGE_NEED_AIO_H
configure.in:94:AC_PACKAGE_NEED_LIO_LISTIO
configure.in:96:AC_PACKAGE_NEED_UUID_H
configure.in:97:AC_PACKAGE_NEED_UUIDCOMPARE
configure.in:99:AC_PACKAGE_NEED_PTHREAD_H

Thanks
James

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
