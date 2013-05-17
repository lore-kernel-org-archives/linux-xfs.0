Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 082187F3F
	for <xfs@oss.sgi.com>; Fri, 17 May 2013 15:55:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id ECD31304066
	for <xfs@oss.sgi.com>; Fri, 17 May 2013 13:55:12 -0700 (PDT)
Received: from mail-ia0-f177.google.com (mail-ia0-f177.google.com
	[209.85.210.177]) by cuda.sgi.com with ESMTP id
	8QAMAwUP3tjCReCe (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 17 May 2013 13:55:11 -0700 (PDT)
Received: by mail-ia0-f177.google.com with SMTP id z13so5361205iaz.22
	for <xfs@oss.sgi.com>; Fri, 17 May 2013 13:55:11 -0700 (PDT)
Message-ID: <51969917.2080209@gmail.com>
Date: Fri, 17 May 2013 16:54:47 -0400
From: "Michael L. Semon" <mlsemon35@gmail.com>
MIME-Version: 1.0
Subject: Re: [PATCH 00/30] xfsprogs: Initial CRC support
References: <1368789205-19969-1-git-send-email-david@fromorbit.com>
In-Reply-To: <1368789205-19969-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 05/17/2013 07:12 AM, Dave Chinner wrote:
> Hi Folks,
>
> This is the first real "works ok" CRC patchset for xfsprogs. It
> provides full support for mkfs.xfs and xfs_repair, and partial
> read-only support for xfs_db.
>
> For mkfs.xfs, it does everything properly, and filesystems that are
> freshly made also run cleanly through xfs_repair and mount and run
> just fine.
>
> For xfs_repair, it reads and writes all metadata with CRC checks,
> calculations and validation just like the kernel code does, but it
> currently silently ignores the validation done in the IO layer.
> Enabling that is future work - it involves adding buffer error checking to
> every libxfs_readbuf() call that is made, and we do none of that
> right now. It does, however, fully validate all the non-CRC format
> metadata just as it does for non-CRC filesystems, and so the
> coverage it has is the same for both CRC and non-CRC filesystems.
>
> For xfs_db, there is read-only support for looking at the filesystem
> as the xfs_db IO stack does not support CRCs at all. We need to
> convert xfs_db to use the libxfs infrastructure to enable that.
> Apart from that, xfs_db has partial support for the extended
> metadata fields - the directory/attribute blocks don't have extended
> support yet, but everything else does.
>
> xfs_check is made special. It currently detects a version 5
> superblock, and immediately exits with success. Hence it always says
> CRC enabled filesystems are OK. This is a temporary change that
> enables running xfstests without full support in xfs_db for all the
> new metadata structures (like headers in remote symlink and
> attribute blocks). Depending on if we want to keep xfs-check useful
> for xfstests, we can revisit this bypass hack once xfs_db has been
> converted to use the libxfs IO engine.
>
> Overall, xfstests is now running enough to start to find bugs in the
> kernel CRC code - I'm mainly hitting remote attribute block bugs
> right now (generic/117!) but there's certainly less problems being
> reported than I expected.
>
> Oh, and I've tested it with external log devices and real time
> devices, too.
>
> Comments, thoughts, flames, and testing all welcome!
>
> Cheers,
>
> Dave.

OK.  The basics look good so far.  The patchset applied without need for 
additional work with vi and patch.  Whitespace errors were reported for 
Patches 8, 14, 16, 17, 24, 25, and 27.  xfsprogs built with no 
additional errors over a normal xfsprogs build.

That all stated, the `tar -xvf qt-source.tar.xz` still fails on a 
CRC-enabled filesystem.  Worse, until I return home, I won't be able to 
do serial-console capture of hard oopses.  However, the initial oops I 
got was a soft one, so it is included after my closing.  The kernel is 
this...

last night's kernel git

last night's xfs-oss/master

some of your recent patches (didn't apply your 6_5 patch yet)

J. Liu's most recent patchset + 2 older bitness patches

Chandra's v8 pquota/gquota patchset + one E-mail fix

Shaggy's JFS patch to make it through the old xfstests #068 on JFS

an NILFS2 patch to address broken bmap handling, lurked from the NILFS2 
mailing list

one local removed assert to make it through the old xfstests #111

maybe one or two XFS patches beyond this

...all on a 32-bit Pentium 4.

What I'm trying to state is that a lot is in there, but the PC is 
spinning like a top, and xfstests results are really good right now. 
However, if I feel the need to provide a fresh environment, patch 
management is taking some time.

Great job on a fine patchset so far, and good luck!

Michael

[ 6188.126012] XFS: Assertion failed: first <= last && last < 
BBTOB(bp->b_length), file: fs/xfs/xfs_trans_buf.c, line: 569
[ 6188.137663] ------------[ cut here ]------------
[ 6188.143109] kernel BUG at fs/xfs/xfs_message.c:108!
[ 6188.147632] invalid opcode: 0000 [#1]
[ 6188.147632] CPU: 0 PID: 12676 Comm: tar Not tainted 3.10.0-rc1+ #25
[ 6188.147632] Hardware name: Dell Computer Corporation Dimension 
2350/07W080, BIOS A01 12/17/2002
[ 6188.147632] task: e0ef53e0 ti: ea330000 task.ti: ea330000
[ 6188.147632] EIP: 0060:[<c1170664>] EFLAGS: 00010282 CPU: 0
[ 6188.147632] EIP is at assfail+0x26/0x28
[ 6188.147632] EAX: 0000006b EBX: ea042630 ECX: 00000000 EDX: c1689820
[ 6188.147632] ESI: d94a3900 EDI: ea347aa8 EBP: ea331bf0 ESP: ea331bdc
[ 6188.147632]  DS: 007b ES: 007b FS: 0000 GS: 00e0 SS: 0068
[ 6188.147632] CR0: 8005003b CR2: b74f0000 CR3: 1964e000 CR4: 000007d0
[ 6188.147632] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[ 6188.147632] DR6: ffff0ff0 DR7: 00000400
[ 6188.147632] Stack:
[ 6188.147632]  00000000 c160a688 c1613b74 c15fe01d 00000239 ea331c08 
c11c6d67 00001ff6
[ 6188.147632]  d94a5ffc d94a5000 d94a3900 ea331c24 c11a0653 00001ff7 
ea347aa8 d94a5ffc
[ 6188.147632]  00000ffc d94a5000 ea331c54 c11a0e45 d94a3900 ea347aa8 
01ff0034 d94a5030
[ 6188.147632] Call Trace:
[ 6188.147632]  [<c11c6d67>] xfs_trans_log_buf+0x64/0x11b
[ 6188.147632]  [<c11a0653>] xfs_dir2_data_log_unused+0x7b/0x83
[ 6188.147632]  [<c11a0e45>] xfs_dir2_data_use_free+0x1bf/0x41a
[ 6188.147632]  [<c11a308b>] xfs_dir2_leaf_addname+0x307/0x6f2
[ 6188.147632]  [<c119d32f>] xfs_dir_createname+0x113/0x129
[ 6188.147632]  [<c1174633>] xfs_create+0x3e0/0x4fb
[ 6188.147632]  [<c116e555>] xfs_vn_mknod+0x8f/0x15a
[ 6188.147632]  [<c116e620>] ? xfs_vn_mknod+0x15a/0x15a
[ 6188.147632]  [<c116e635>] xfs_vn_create+0x15/0x17
[ 6188.147632]  [<c109eb31>] vfs_create+0x68/0xeb
[ 6188.147632]  [<c109f410>] do_last+0x85c/0xc45
[ 6188.147632]  [<c109cf53>] ? inode_permission+0x11/0x3e
[ 6188.147632]  [<c109d955>] ? link_path_walk+0x4f/0x67f
[ 6188.147632]  [<c109f898>] path_openat+0x9f/0x38d
[ 6188.147632]  [<c109fbac>] do_filp_open+0x26/0x6b
[ 6188.147632]  [<c12ad0c6>] ? tty_write_unlock+0x2d/0x33
[ 6188.147632]  [<c109cc94>] ? getname_flags+0x86/0x118
[ 6188.147632]  [<c1095157>] do_sys_open+0xf0/0x1ae
[ 6188.147632]  [<c109524f>] SyS_openat+0x1b/0x1d
[ 6188.147632]  [<c14d5d4c>] syscall_call+0x7/0xb
[ 6188.147632]  [<c14d0000>] ? spurious_fault+0xbf/0xc2
[ 6188.147632] Code: 56 eb ff c9 c3 55 89 e5 83 ec 14 89 4c 24 10 89 54 
24 0c 89 44 24 08 c7 44 24 04 88 a6 60 c1 c7 04 24 00 00 00 00 e8 e4 fd 
ff ff <0f> 0b 55 89 e5 83 ec 14 c7 44 24 10 01 00 00 00 89 54 24 0c 89
[ 6188.147632] EIP: [<c1170664>] assfail+0x26/0x28 SS:ESP 0068:ea331bdc
[ 6188.415714] ---[ end trace c213c626812e5949 ]---
[ 6211.447695] XFS (sdb5): Version 5 superblock detected. This kernel 
has EXPERIMENTAL support enabled!
[ 6211.447695] Use of these features in this kernel is at your own risk!


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
