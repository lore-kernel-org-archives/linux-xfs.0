Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:31599 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750992AbdAKRck (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Jan 2017 12:32:40 -0500
Date: Wed, 11 Jan 2017 09:32:27 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [RFC PATCH] xfs_db: sanitize geometry on load
Message-ID: <20170111173227.GS14038@birch.djwong.org>
References: <20170110194249.GK14038@birch.djwong.org>
 <CAOQ4uxggOoFJ_KR40XX2hU+bSr9zqXu9y_7HWqVxTfQ6ETC4hA@mail.gmail.com>
 <CAOQ4uxj+H4ZAXkPgob5ANJW=BDBzj6P2nKbb3aE9w1igGmcRfw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxj+H4ZAXkPgob5ANJW=BDBzj6P2nKbb3aE9w1igGmcRfw@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-xfs@vger.kernel.org, Eryu Guan <eguan@redhat.com>

On Wed, Jan 11, 2017 at 12:01:22PM +0200, Amir Goldstein wrote:
> On Wed, Jan 11, 2017 at 10:34 AM, Amir Goldstein <amir73il@gmail.com> wrote:
> > On Tue, Jan 10, 2017 at 9:42 PM, Darrick J. Wong
> > <darrick.wong@oracle.com> wrote:
> >> xfs_db doesn't check the filesystem geometry when it's mounting, which
> >> means that garbage agcount values can cause OOMs when we try to allocate
> >> all the per-AG incore metadata.  If we see geometry that looks
> >> suspicious, try to derive the actual AG geometry to avoid crashing the
> >> system.  This should help with xfs/1301 fuzzing.
> >>
> >> Also fix up xfs_repair to use the min/max dblocks macros.
> >>
> >> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> >
> > Test machine is back to health with this patch, but some test are failing due
> > to the new error messages.
> > I guess its no surprise to you.
> >
> >
> > xfs/1300 5s ... 5s
> > xfs/1301         - output mismatch (see
> > /home/amir/src/xfstests-dev/results//xfs/1301.out.bad)
> >     --- tests/xfs/1301.out      2017-01-08 15:35:07.647897359 +0200
> >     +++ /home/amir/src/xfstests-dev/results//xfs/1301.out.bad
> > 2017-01-11 09:58:10.981678272 +0200
> >     @@ -1,4 +1,61 @@
> >      QA output created by 1301
> >      Format and populate
> >      Fuzz superblock
> >     +xfs_db: device /dev/mapper/storage-scratch AG geometry is insane.
> > Using agcount=4.
> >     +SB sanity check failed
> >     +Metadata corruption detected at xfs_sb block 0x0/0x200
> >     +xfs_db: device /dev/mapper/storage-scratch AG geometry is insane.
> > Using agcount=4.
> >     ...
> >     (Run 'diff -u tests/xfs/1301.out
> > /home/amir/src/xfstests-dev/results//xfs/1301.out.bad'  to see the

Uh.... this is odd, all that stuff should go into 1301.full.

> > entire diff)
> > _check_xfs_filesystem: filesystem on /dev/mapper/storage-scratch is
> > inconsistent (c) (see
> > /home/amir/src/xfstests-dev/results//xfs/1301.full)
> > _check_xfs_filesystem: filesystem on /dev/mapper/storage-scratch is
> > inconsistent (r) (see
> > /home/amir/src/xfstests-dev/results//xfs/1301.full)
> > xfs/1302         - output mismatch (see
> > /home/amir/src/xfstests-dev/results//xfs/1302.out.bad)
> >     --- tests/xfs/1302.out      2017-01-08 15:35:07.647897359 +0200
> >     +++ /home/amir/src/xfstests-dev/results//xfs/1302.out.bad
> > 2017-01-11 10:05:16.710031113 +0200
> >     @@ -1,4 +1,26 @@
> >      QA output created by 1302
> >      Format and populate
> >      Fuzz AGF
> >     +Metadata corruption detected at xfs_agf block 0x1/0x200
> >     +xfs_db: cannot init perag data (117). Continuing anyway.
> >     +Metadata corruption detected at xfs_agf block 0x1/0x200
> >     +xfs_db: cannot init perag data (117). Continuing anyway.

I just ran 1302, all the output goes into 1302.full.

Now I wonder what's different with your setup than mine?

> >     ...
> >     (Run 'diff -u tests/xfs/1302.out
> > /home/amir/src/xfstests-dev/results//xfs/1302.out.bad'  to see the
> > entire diff)
> > _check_xfs_filesystem: filesystem on /dev/mapper/storage-scratch is
> > inconsistent (c) (see
> > /home/amir/src/xfstests-dev/results//xfs/1302.full)
> > xfs/1303 132s ... 130s
> > _check_xfs_filesystem: filesystem on /dev/mapper/storage-scratch is
> > inconsistent (c) (see
> > /home/amir/src/xfstests-dev/results//xfs/1303.full)
> > _check_xfs_filesystem: filesystem on /dev/mapper/storage-scratch is
> > inconsistent (r) (see
> > /home/amir/src/xfstests-dev/results//xfs/1303.full)
> > xfs/1304         - output mismatch (see
> > /home/amir/src/xfstests-dev/results//xfs/1304.out.bad)
> >     --- tests/xfs/1304.out      2017-01-08 15:35:07.647897359 +0200
> >     +++ /home/amir/src/xfstests-dev/results//xfs/1304.out.bad
> > 2017-01-11 10:12:26.506167776 +0200
> >     @@ -1,4 +1,12 @@
> >      QA output created by 1304
> >      Format and populate
> >      Fuzz AGI
> >     +Metadata corruption detected at xfs_agi block 0x2/0x200
> >     +xfs_db: cannot init perag data (117). Continuing anyway.
> >     +Metadata corruption detected at xfs_agi block 0x2/0x200
> >     +xfs_db: cannot init perag data (117). Continuing anyway.
> >     ...
> >     (Run 'diff -u tests/xfs/1304.out
> > /home/amir/src/xfstests-dev/results//xfs/1304.out.bad'  to see the
> > entire diff)
> > _check_xfs_filesystem: filesystem on /dev/mapper/storage-scratch is
> > inconsistent (c) (see
> > /home/amir/src/xfstests-dev/results//xfs/1304.full)
> > _check_xfs_filesystem: filesystem on /dev/mapper/storage-scratch is
> > inconsistent (r) (see
> > /home/amir/src/xfstests-dev/results//xfs/1304.full)
> > xfs/1305 224s ... 218s
> > _check_xfs_filesystem: filesystem on /dev/mapper/storage-scratch is
> > inconsistent (c) (see
> > /home/amir/src/xfstests-dev/results//xfs/1305.full)
> > _check_xfs_filesystem: filesystem on /dev/mapper/storage-scratch is
> > inconsistent (r) (see
> > /home/amir/src/xfstests-dev/results//xfs/1305.full)
> > xfs/1306 239s ... 234s
> 
> Now I am hitting these xfs_db crashes during xfs/1316, which are apparently not
> related to OOM killer. I have seen them last run as well but dmesg is quiet now.
> 
> xfs/1316        *** Error in `/usr/sbin/xfs_db': free(): invalid
> pointer: 0x00007f9dbf036b78 ***
> ======= Backtrace: =========
> /lib/x86_64-linux-gnu/libc.so.6(+0x77725)[0x7f9dbecea725]
> /lib/x86_64-linux-gnu/libc.so.6(+0x7ff4a)[0x7f9dbecf2f4a]
> /lib/x86_64-linux-gnu/libc.so.6(cfree+0x4c)[0x7f9dbecf6abc]
> /usr/sbin/xfs_db[0x414961]
> /usr/sbin/xfs_db[0x4154de]
> /usr/sbin/xfs_db[0x420d38]
> /usr/sbin/xfs_db[0x420926]
> /usr/sbin/xfs_db[0x405125]
> /lib/x86_64-linux-gnu/libc.so.6(__libc_start_main+0xf0)[0x7f9dbec93830]
> /usr/sbin/xfs_db[0x405179]

Ok well I definitely don't see /this/ happening.  I gather you built
xfsprogs with the insane geometry patch; if so, against what git commit?
And, did the binary get installed as /usr/sbin/xfs_db, or is this just
the system xfs_db?

In any case, all that extra output is supposed to end up in
$seqres.full, not on stdout.  At most you should see admonishments about
scrub or repair failing to detect/fix things; those messages look like:

"offline repair failed (4) with $field = $fuzzverb"

--D

> ======= Memory map: ========
> 00400000-0049e000 r-xp 00000000 08:01 15995842
>   /usr/sbin/xfs_db
> 0069d000-0069e000 r--p 0009d000 08:01 15995842
>   /usr/sbin/xfs_db
> 0069e000-006a1000 rw-p 0009e000 08:01 15995842
>   /usr/sbin/xfs_db
> 006a1000-006b0000 rw-p 00000000 00:00 0
> 0119e000-011e0000 rw-p 00000000 00:00 0                                  [heap]
> 7f9db8000000-7f9db8021000 rw-p 00000000 00:00 0
> 7f9db8021000-7f9dbc000000 ---p 00000000 00:00 0
> 7f9dbea5d000-7f9dbea73000 r-xp 00000000 08:01 6033829
>   /lib/x86_64-linux-gnu/libgcc_s.so.1
> 7f9dbea73000-7f9dbec72000 ---p 00016000 08:01 6033829
>   /lib/x86_64-linux-gnu/libgcc_s.so.1
> 7f9dbec72000-7f9dbec73000 rw-p 00015000 08:01 6033829
>   /lib/x86_64-linux-gnu/libgcc_s.so.1
> 7f9dbec73000-7f9dbee33000 r-xp 00000000 08:01 6033791
>   /lib/x86_64-linux-gnu/libc-2.23.so
> 7f9dbee33000-7f9dbf032000 ---p 001c0000 08:01 6033791
>   /lib/x86_64-linux-gnu/libc-2.23.so
> 7f9dbf032000-7f9dbf036000 r--p 001bf000 08:01 6033791
>   /lib/x86_64-linux-gnu/libc-2.23.so
> 7f9dbf036000-7f9dbf038000 rw-p 001c3000 08:01 6033791
>   /lib/x86_64-linux-gnu/libc-2.23.so
> 7f9dbf038000-7f9dbf03c000 rw-p 00000000 00:00 0
> 7f9dbf03c000-7f9dbf054000 r-xp 00000000 08:01 6033937
>   /lib/x86_64-linux-gnu/libpthread-2.23.so
> 7f9dbf054000-7f9dbf253000 ---p 00018000 08:01 6033937
>   /lib/x86_64-linux-gnu/libpthread-2.23.so
> 7f9dbf253000-7f9dbf254000 r--p 00017000 08:01 6033937
>   /lib/x86_64-linux-gnu/libpthread-2.23.so
> 7f9dbf254000-7f9dbf255000 rw-p 00018000 08:01 6033937
>   /lib/x86_64-linux-gnu/libpthread-2.23.so
> 7f9dbf255000-7f9dbf259000 rw-p 00000000 00:00 0
> 7f9dbf259000-7f9dbf25d000 r-xp 00000000 08:01 6033975
>   /lib/x86_64-linux-gnu/libuuid.so.1.3.0
> 7f9dbf25d000-7f9dbf45c000 ---p 00004000 08:01 6033975
>   /lib/x86_64-linux-gnu/libuuid.so.1.3.0
> 7f9dbf45c000-7f9dbf45d000 r--p 00003000 08:01 6033975
>   /lib/x86_64-linux-gnu/libuuid.so.1.3.0
> 7f9dbf45d000-7f9dbf45e000 rw-p 00004000 08:01 6033975
>   /lib/x86_64-linux-gnu/libuuid.so.1.3.0
> 7f9dbf45e000-7f9dbf484000 r-xp 00000000 08:01 6033763
>   /lib/x86_64-linux-gnu/ld-2.23.so
> 7f9dbf667000-7f9dbf66b000 rw-p 00000000 00:00 0
> 7f9dbf680000-7f9dbf683000 rw-p 00000000 00:00 0
> 7f9dbf683000-7f9dbf684000 r--p 00025000 08:01 6033763
>   /lib/x86_64-linux-gnu/ld-2.23.so
> 7f9dbf684000-7f9dbf685000 rw-p 00026000 08:01 6033763
>   /lib/x86_64-linux-gnu/ld-2.23.so
> 7f9dbf685000-7f9dbf686000 rw-p 00000000 00:00 0
> 7ffdde2cb000-7ffdde2ed000 rw-p 00000000 00:00 0                          [stack]
> 7ffdde366000-7ffdde368000 r--p 00000000 00:00 0                          [vvar]
> 7ffdde368000-7ffdde36a000 r-xp 00000000 00:00 0                          [vdso]
> ffffffffff600000-ffffffffff601000 r-xp 00000000 00:00 0
>   [vsyscall]
> *** Error in `/usr/sbin/xfs_db': free(): invalid pointer: 0x00007f202b108b78 ***
> 
> ...
> 
>  - output mismatch (see /home/amir/src/xfstests-dev/results//xfs/1316.out.bad)
>     --- tests/xfs/1316.out      2017-01-08 15:35:07.647897359 +0200
>     +++ /home/amir/src/xfstests-dev/results//xfs/1316.out.bad
> 2017-01-11 11:56:06.156948852 +0200
>     @@ -2,4 +2,20 @@
>      Format and populate
>      Find bmbt block
>      Fuzz bmbt
>     +./common/xfs: line 157: 19209 Aborted                 (core
> dumped) $XFS_DB_PROG "$@" $(_scratch_xfs_db_options)
>     +./common/xfs: line 157: 19219 Aborted                 (core
> dumped) $XFS_DB_PROG "$@" $(_scratch_xfs_db_options)
>     +./common/xfs: line 157: 19256 Aborted                 (core
> dumped) $XFS_DB_PROG "$@" $(_scratch_xfs_db_options)
>     +./common/xfs: line 157: 19264 Aborted                 (core
> dumped) $XFS_DB_PROG "$@" $(_scratch_xfs_db_options)
>     ...
>     (Run 'diff -u tests/xfs/1316.out
> /home/amir/src/xfstests-dev/results//xfs/1316.out.bad'  to see the
> entire diff)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
