Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:32771 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753803AbdAKIei (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Jan 2017 03:34:38 -0500
Received: by mail-oi0-f65.google.com with SMTP id j15so20794813oih.0
        for <linux-xfs@vger.kernel.org>; Wed, 11 Jan 2017 00:34:37 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20170110194249.GK14038@birch.djwong.org>
References: <20170110194249.GK14038@birch.djwong.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 11 Jan 2017 10:34:36 +0200
Message-ID: <CAOQ4uxggOoFJ_KR40XX2hU+bSr9zqXu9y_7HWqVxTfQ6ETC4hA@mail.gmail.com>
Subject: Re: [RFC PATCH] xfs_db: sanitize geometry on load
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-xfs@vger.kernel.org, Eryu Guan <eguan@redhat.com>

On Tue, Jan 10, 2017 at 9:42 PM, Darrick J. Wong
<darrick.wong@oracle.com> wrote:
> xfs_db doesn't check the filesystem geometry when it's mounting, which
> means that garbage agcount values can cause OOMs when we try to allocate
> all the per-AG incore metadata.  If we see geometry that looks
> suspicious, try to derive the actual AG geometry to avoid crashing the
> system.  This should help with xfs/1301 fuzzing.
>
> Also fix up xfs_repair to use the min/max dblocks macros.
>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Test machine is back to health with this patch, but some test are failing due
to the new error messages.
I guess its no surprise to you.


xfs/1300 5s ... 5s
xfs/1301         - output mismatch (see
/home/amir/src/xfstests-dev/results//xfs/1301.out.bad)
    --- tests/xfs/1301.out      2017-01-08 15:35:07.647897359 +0200
    +++ /home/amir/src/xfstests-dev/results//xfs/1301.out.bad
2017-01-11 09:58:10.981678272 +0200
    @@ -1,4 +1,61 @@
     QA output created by 1301
     Format and populate
     Fuzz superblock
    +xfs_db: device /dev/mapper/storage-scratch AG geometry is insane.
Using agcount=4.
    +SB sanity check failed
    +Metadata corruption detected at xfs_sb block 0x0/0x200
    +xfs_db: device /dev/mapper/storage-scratch AG geometry is insane.
Using agcount=4.
    ...
    (Run 'diff -u tests/xfs/1301.out
/home/amir/src/xfstests-dev/results//xfs/1301.out.bad'  to see the
entire diff)
_check_xfs_filesystem: filesystem on /dev/mapper/storage-scratch is
inconsistent (c) (see
/home/amir/src/xfstests-dev/results//xfs/1301.full)
_check_xfs_filesystem: filesystem on /dev/mapper/storage-scratch is
inconsistent (r) (see
/home/amir/src/xfstests-dev/results//xfs/1301.full)
xfs/1302         - output mismatch (see
/home/amir/src/xfstests-dev/results//xfs/1302.out.bad)
    --- tests/xfs/1302.out      2017-01-08 15:35:07.647897359 +0200
    +++ /home/amir/src/xfstests-dev/results//xfs/1302.out.bad
2017-01-11 10:05:16.710031113 +0200
    @@ -1,4 +1,26 @@
     QA output created by 1302
     Format and populate
     Fuzz AGF
    +Metadata corruption detected at xfs_agf block 0x1/0x200
    +xfs_db: cannot init perag data (117). Continuing anyway.
    +Metadata corruption detected at xfs_agf block 0x1/0x200
    +xfs_db: cannot init perag data (117). Continuing anyway.
    ...
    (Run 'diff -u tests/xfs/1302.out
/home/amir/src/xfstests-dev/results//xfs/1302.out.bad'  to see the
entire diff)
_check_xfs_filesystem: filesystem on /dev/mapper/storage-scratch is
inconsistent (c) (see
/home/amir/src/xfstests-dev/results//xfs/1302.full)
xfs/1303 132s ... 130s
_check_xfs_filesystem: filesystem on /dev/mapper/storage-scratch is
inconsistent (c) (see
/home/amir/src/xfstests-dev/results//xfs/1303.full)
_check_xfs_filesystem: filesystem on /dev/mapper/storage-scratch is
inconsistent (r) (see
/home/amir/src/xfstests-dev/results//xfs/1303.full)
xfs/1304         - output mismatch (see
/home/amir/src/xfstests-dev/results//xfs/1304.out.bad)
    --- tests/xfs/1304.out      2017-01-08 15:35:07.647897359 +0200
    +++ /home/amir/src/xfstests-dev/results//xfs/1304.out.bad
2017-01-11 10:12:26.506167776 +0200
    @@ -1,4 +1,12 @@
     QA output created by 1304
     Format and populate
     Fuzz AGI
    +Metadata corruption detected at xfs_agi block 0x2/0x200
    +xfs_db: cannot init perag data (117). Continuing anyway.
    +Metadata corruption detected at xfs_agi block 0x2/0x200
    +xfs_db: cannot init perag data (117). Continuing anyway.
    ...
    (Run 'diff -u tests/xfs/1304.out
/home/amir/src/xfstests-dev/results//xfs/1304.out.bad'  to see the
entire diff)
_check_xfs_filesystem: filesystem on /dev/mapper/storage-scratch is
inconsistent (c) (see
/home/amir/src/xfstests-dev/results//xfs/1304.full)
_check_xfs_filesystem: filesystem on /dev/mapper/storage-scratch is
inconsistent (r) (see
/home/amir/src/xfstests-dev/results//xfs/1304.full)
xfs/1305 224s ... 218s
_check_xfs_filesystem: filesystem on /dev/mapper/storage-scratch is
inconsistent (c) (see
/home/amir/src/xfstests-dev/results//xfs/1305.full)
_check_xfs_filesystem: filesystem on /dev/mapper/storage-scratch is
inconsistent (r) (see
/home/amir/src/xfstests-dev/results//xfs/1305.full)
xfs/1306 239s ... 234s
