Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56C9DC433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Jan 2022 06:22:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244983AbiASGWu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Jan 2022 01:22:50 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:49474 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236345AbiASGWu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jan 2022 01:22:50 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1B6DC6112E
        for <linux-xfs@vger.kernel.org>; Wed, 19 Jan 2022 06:22:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 81BCFC340EA
        for <linux-xfs@vger.kernel.org>; Wed, 19 Jan 2022 06:22:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642573369;
        bh=58YRehPtuvfc8O+IC8FYeai41cXL35uNib25DXPPkso=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=ggJqewbNSlrqP+OCWbv5gsFl9ZACTLpq/4Ike3rIJGABoHpksGcx51gQuirl0TJv4
         KUyIGdaSzwk+VuEko6wTmHVyNlHHEIoD2vzPmERN0VG5HU4z9PzefHNW0631qq7cUB
         IS6Fpd6edZqHSTg8+b6lAaPBc16sGvhR/Qufw8wz73WAvJYKHRSQUqq2GdhbG7WFi0
         c9m5Vs23b/uZ1j25cxxA/lrh4/WVMCI8c/WRlueO8zy8EbmYmRBZkPAR1e3fqqilI6
         o9fKPn02jfmJbR3nHneoOukjGfJ3uEu/4uO7Q3ozeGF0WG4Sx8HhZ93inWRnjTIptD
         WRGniJxYphurw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 71E78CC13AF; Wed, 19 Jan 2022 06:22:49 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 215506] Internal error !ino_ok at line 200 of file
 fs/xfs/libxfs/xfs_dir2.c.  Caller xfs_dir_ino_validate+0x5d/0xd0 [xfs]
Date:   Wed, 19 Jan 2022 06:22:49 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: david@fromorbit.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-215506-201763-XZJmcvVyo8@https.bugzilla.kernel.org/>
In-Reply-To: <bug-215506-201763@https.bugzilla.kernel.org/>
References: <bug-215506-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D215506

--- Comment #1 from Dave Chinner (david@fromorbit.com) ---
On Wed, Jan 19, 2022 at 03:08:33AM +0000, bugzilla-daemon@bugzilla.kernel.o=
rg
wrote:
> I have encountered a bug in xfs file system.

I don't think so.

> I created a disk image and modified some properties.

Let's call it what it is: you -corrupted- the disk image.

> After that I mount the image

According to the trace, the mount failed because XFS detected one
of the many corruptions you created in the filesystem.

> and run some commands related to file operations, and the bug occured.

The filesystem mount was aborted due to the detected corruption, so
I don't actually beleive that this corruption was produced by the
test program....

> The kernel message is shown below:
>=20
> loop7: detected capacity change from 0 to 131072
> loop8: detected capacity change from 0 to 131072
> XFS (loop8): Mounting V5 Filesystem
> XFS (loop8): Internal error !ino_ok at line 200 of file
> fs/xfs/libxfs/xfs_dir2.c.  Caller xfs_dir_ino_validate+0x5d/0xd0 [xfs]

XFS found an invalid inode number in a directory entry.

> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xea/0x130
>  dump_stack+0x1c/0x25
>  xfs_error_report+0xd3/0xe0 [xfs]
>  xfs_corruption_error+0xab/0x120 [xfs]
>  xfs_dir_ino_validate+0xa2/0xd0 [xfs]
>  xfs_dir2_sf_verify+0x5d2/0xb50 [xfs]
>  xfs_ifork_verify_local_data+0xd6/0x180 [xfs]
>  xfs_iformat_data_fork+0x3ff/0x4c0 [xfs]
>  xfs_inode_from_disk+0xb5a/0x1460 [xfs]
>  xfs_iget+0x1281/0x2850 [xfs]
>  xfs_mountfs+0x12f5/0x1ff0 [xfs]
>  xfs_fs_fill_super+0x1198/0x2030 [xfs]
>  get_tree_bdev+0x494/0x850
>  xfs_fs_get_tree+0x2a/0x40 [xfs]
>  vfs_get_tree+0x9a/0x380
>  path_mount+0x7e3/0x24c0
>  do_mount+0x11b/0x140

Whilst reading and validating the root inode during mount. The error
messages emitted tell us that this isn't a bug but an on-disk
corruption that was encountered:

> XFS (loop8): Corruption detected. Unmount and run xfs_repair
> XFS (loop8): Invalid inode number 0x2000000
> XFS (loop8): Metadata corruption detected at xfs_dir2_sf_verify+0x906/0xb=
50
> [xfs], inode 0x60 data fork
> XFS (loop8): Unmount and run xfs_repair
> XFS (loop8): First 17 bytes of corrupted metadata buffer:
> 00000000: 01 00 00 00 00 60 03 00 60 66 6f 6f 02 00 00 00  .....`..`foo..=
..
> 00000010: 63                                               c
> XFS (loop8): Failed to read root inode 0x60, error 117

Using xfs_db, the root inode contains:

u3.sfdir2.hdr.count =3D 1
u3.sfdir2.hdr.i8count =3D 0
u3.sfdir2.hdr.parent.i4 =3D 96
u3.sfdir2.list[0].namelen =3D 3
u3.sfdir2.list[0].offset =3D 0x60
u3.sfdir2.list[0].name =3D "foo"
u3.sfdir2.list[0].inumber.i4 =3D 33554432

That the inode number for foo is, indeed, 0x200000. Given that
this is a 64MB filesystem, the largest inode number that is valid
is around 0x20000 (131072). Hence the mount failed immediately
as the root inode has clearly been corrupted.

Looking at the AGI btree for AG 0, I see that inode 99 is also
allocated, which is where that should point. That contains one
entry:

u3.sfdir2.hdr.count =3D 1
u3.sfdir2.hdr.i8count =3D 0
u3.sfdir2.hdr.parent.i4 =3D 96
u3.sfdir2.list[0].namelen =3D 3
u3.sfdir2.list[0].offset =3D 0x160
u3.sfdir2.list[0].name =3D "bar"
u3.sfdir2.list[0].inumber.i4 =3D 33554560

Which points to inode 0x200080, also beyond EOFS.

So that's two corrupt inode numbers out of two shortform directory
entries, both with a very similar corruption.

Then looking at your reproducer, it assumes that the directory
structure /foo/bar/ needs to pre-exist before the test file is run.
I can also see ifrom the LSN values in various metadata that the
filesystem was mounted and foo/bar was created. e.g.  those two
inodes have a LSN of 0x100000002 (cycle 1, block 2), and so would
have been the very first modifications made after the filesystem was
created.

I can see other inodes that are marked allocated in AGI 1, and I
found that inode 0x8060 should have been the /foo/bar/ directory
inode. I can see the traces of it in the literal area when I change
the inode to local format:

u3.sfdir2.hdr.count =3D 7
u3.sfdir2.hdr.i8count =3D 0
u3.sfdir2.hdr.parent.i4 =3D 99
u3.sfdir2.list[0].namelen =3D 255
u3.sfdir2.list[0].offset =3D 0xffff
u3.sfdir2.list[0].name =3D
"\177az\001\000\000\200a\003\000phln\001\000\000\200b\005\000\200xattr\001\=
000\000\200c\003\000\230acl\001
....

as it's parent directory points back to inode 99 that I identified
above. But it's been corrupted - not only have the format been
changed, the first few bytes of the shortform entry have been
overwritten and so the directory entry data is corrupt, too.

IOWs, it's pretty clear that this filesystem image was corrupted
-after- the test binary was run to create all these files.

So I thought "lets run repair just to see how many structures have
been maliciously corrupted":

# xfs_repair -n tmp.img
Phase 1 - find and verify superblock...
bad primary superblock - inconsistent inode alignment value !!!
attempting to find secondary superblock...
.found candidate secondary superblock...
verified secondary superblock...
would write modified primary superblock
Primary superblock would have been modified.
Cannot proceed further in no_modify mode.
Exiting now.
#

Yeah, didn't get far. There's significant modification to all the
superblocks - the inode alignment, and all the features fields (f2,
bad f2, ro feat, incompat feat) have been zeroed too. SO there are
serious inconsistencies between what the filesystem says is the
format on disk and what is actually on disk.

Other superblocks fail simple checks, too:

xfs_db> sb 1
Superblock has unknown read-only compatible features (0xff000000) enabled.
Attempted to mount read-only compatible filesystem read-write.
Filesystem can only be safely mounted read only.
xfs_db> sb 2
SB sanity check failed
Metadata corruption detected at 0x561fdae339f5, xfs_sb block 0x10000/0x200

and so on. There's random metadata field corruption all over the
place, and it clearly has been done by a third party as there are
corruptions in metadata that clearly is not written by the kernel,
yet the CRCs for those objects are correct.

IOWs, you've maliciously modified random fields in the filesystem to
try to induce a failure, but the kernel has detected those malicious
corruptions and correctly aborted mounting the filesystem.  I'd say
the kernel code is working exactly as intended at this point in time.

Please close this bug, and for next time, please learn the
difference between XFS reporting on-disk corruption and an actual
kernel bug.

-Dave.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
