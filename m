Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yb1-f194.google.com ([209.85.219.194]:38929 "EHLO
        mail-yb1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726389AbfAAJ35 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Jan 2019 04:29:57 -0500
Received: by mail-yb1-f194.google.com with SMTP id n187so7607772yba.6
        for <linux-xfs@vger.kernel.org>; Tue, 01 Jan 2019 01:29:56 -0800 (PST)
MIME-Version: 1.0
References: <154630934595.21716.17416691804044507782.stgit@magnolia>
In-Reply-To: <154630934595.21716.17416691804044507782.stgit@magnolia>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 1 Jan 2019 11:29:44 +0200
Message-ID: <CAOQ4uxjbgjPt8OL9brNPe1PUCa+ySnDhppSdYZar=W4v7f+N9A@mail.gmail.com>
Subject: Re: [PATCH 00/13] xfs: metadata inode directories
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Tue, Jan 1, 2019 at 4:22 AM Darrick J. Wong <darrick.wong@oracle.com> wrote:
>
> Hi all,
>
> This series delivers a new feature -- metadata inode directories.  This
> is a separate directory tree (rooted in the superblock) that contains
> only inodes that contain filesystem metadata.  Different metadata
> objects can be looked up with regular paths.
>
> We start by creating xfs_imeta_* functions to mediate access to metadata
> inode pointers.  This enables the imeta code to abstract inode pointers,
> whether they're the classic five in the superblock, or the much more
> complex directory tree.  All current users of metadata inodes (rt+quota)
> are converted to use the boilerplate code.
>
> Next, we define the metadir on-disk format, which consists of marking
> inodes with a new iflag that says they're metadata.  This we use to
> prevent bulkstat and friends from ever getting their hands on fs
> metadata.
>
> Finally, we implement metadir operations so that clients can create,
> delete, zap, and look up metadata inodes by path.  Beware that much of
> this code is only lightly used, because the five current users of
> metadata inodes don't tend to change them very often.  This is likely to
> change if and when the subvolume and multiple-rt-volume features get
> written/merged/etc.
>

Finally, the motivation ;-)

How far is this feature expected to scale in the future in term of
number of entries and frequency of lookups?

It seems odd (to put it gently) for xfs to re-invent path lookup,
without cache and loosing all the maturity and vfs path lookup code.
I realize this is for xfs internal use, but is there really anything preventing
you from using internal dcache helpers to maintain an xfs internal
dcache metadata tree?
The metadata tree root dentry would be disconnected from the sb
root and cached in the in core xfs sb struct.

It may not be trivial to pull this off, but the benefits of using mature
and scalable lookup code might just out weight the initial effort in
the long run.

> If you're going to start using this mess, you probably ought to just
> pull from my git trees.  The kernel patches[1] should apply against
> 4.20.  xfsprogs[2] and xfstests[3] can be found in their usual
> places.  The git trees contain all four series' worth of changes.
>
> This is an extraordinary way to destroy everything.  Enjoy!
> Comments and questions are, as always, welcome.
>
> --D
>
> [1] https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=djwong-devel
> [2] https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=djwong-devel
> [3] https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=djwong-devel

It's not there as far as I can tell. Forgot to push?
Many other patches you posted are on djwong-wtf and not on djwong-devel as
declared and this specific series is not even on djwong-wtf.

Happy new year!

Amir.
