Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFAABC4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:19:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235707AbiL3XTE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:19:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235266AbiL3XTD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:19:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BF33FCCB;
        Fri, 30 Dec 2022 15:19:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E047DB81DA2;
        Fri, 30 Dec 2022 23:19:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62ED6C433D2;
        Fri, 30 Dec 2022 23:18:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672442339;
        bh=slMw/zT1HrEDCT95j0h63uewWYkMv4Hhhn2MrzeFGzs=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ZdyUH0GFYuMAD/Y/hnd9C4XJWRdnHtAx03fLez+riojj+Q3c+6lFvu/vqVOhkse24
         fHOA4B6mfF0StC5LVS5aGRv2remOTV/HI1/xX2W1trDimxhqt3aH3BCn9Y5a9Cmgrq
         xGCZZOHgD2906f3Mp0pk5pZKs1Njij739KgYFgCtfqeLxz84WVNg0Kx2Q7WTkS51a/
         rSZK3MkuGbl3E6RZqH+J6PpS8wueEWvi6oS2WqyCRtQ7HzYUJhvYnJ7OeXCIkb3bUB
         asID7Wr0XKe2foVx2T5t19UxDhEvvFgJjaIgjWXVG1EXJ6etJ+iuVod4S24T61360E
         8bT8pQP3oRGGg==
Subject: [PATCHSET v24.0 0/7] fstests: atomic file updates
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:19:48 -0800
Message-ID: <167243878818.732172.6392253687008406885.stgit@magnolia>
In-Reply-To: <Y69Unb7KRM5awJoV@magnolia>
References: <Y69Unb7KRM5awJoV@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This series creates a new FIEXCHANGE_RANGE system call to exchange
ranges of bytes between two files atomically.  This new functionality
enables data storage programs to stage and commit file updates such that
reader programs will see either the old contents or the new contents in
their entirety, with no chance of torn writes.  A successful call
completion guarantees that the new contents will be seen even if the
system fails.

The ability to swap extent mappings between files in this manner is
critical to supporting online filesystem repair, which is built upon the
strategy of constructing a clean copy of a damaged structure and
committing the new structure into the metadata file atomically.

User programs will be able to update files atomically by opening an
O_TMPFILE, reflinking the source file to it, making whatever updates
they want to make, and exchange the relevant ranges of the temp file
with the original file.  If the updates are aligned with the file block
size, a new (since v2) flag provides for exchanging only the written
areas.  Callers can arrange for the update to be rejected if the
original file has been changed.

The intent behind this new userspace functionality is to enable atomic
rewrites of arbitrary parts of individual files.  For years, application
programmers wanting to ensure the atomicity of a file update had to
write the changes to a new file in the same directory, fsync the new
file, rename the new file on top of the old filename, and then fsync the
directory.  People get it wrong all the time, and $fs hacks abound.

The reference implementation in XFS creates a new log incompat feature
and log intent items to track high level progress of swapping ranges of
two files and finish interrupted work if the system goes down.  Sample
code can be found in the corresponding changes to xfs_io to exercise the
use case mentioned above.

Note that this function is /not/ the O_DIRECT atomic file writes concept
that has also been floating around for years.  This RFC is constructed
entirely in software, which means that there are no limitations other
than the general filesystem limits.

As a side note, the original motivation behind the kernel functionality
is online repair of file-based metadata.  The atomic file swap is
implemented as an atomic inode fork swap, which means that we can
implement online reconstruction of extended attributes and directories
by building a new one in another inode and atomically swap the contents.

Subsequent patchsets adapt the online filesystem repair code to use
atomic extent swapping.  This enables repair functions to construct a
clean copy of a directory, xattr information, symbolic links, realtime
bitmaps, and realtime summary information in a temporary inode.  If this
completes successfully, the new contents can be swapped atomically into
the inode being repaired.  This is essential to avoid making corruption
problems worse if the system goes down in the middle of running repair.

This patchset also ports the old XFS extent swap ioctl interface to use
the new extent swap code.

For userspace, this series also includes the userspace pieces needed to
test the new functionality, and a sample implementation of atomic file
updates.

Question: Should we really bother with fsdevel bikeshedding?  Most
filesystems cannot support this functionality, so we could keep it
private to XFS for now.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=atomic-file-updates

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=atomic-file-updates

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=atomic-file-updates

xfsdocs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-documentation.git/log/?h=atomic-file-updates
---
 common/rc              |   24 +++++++
 common/reflink         |   33 +++++++++
 common/xfs             |   19 +++++
 configure.ac           |    1 
 doc/group-names.txt    |    2 +
 include/builddefs.in   |    1 
 ltp/Makefile           |    4 +
 ltp/fsstress.c         |  168 ++++++++++++++++++++++++++++++++++++++++++++++++
 ltp/fsx.c              |  160 +++++++++++++++++++++++++++++++++++++++++++++-
 m4/package_libcdev.m4  |   21 ++++++
 src/fiexchange.h       |  101 +++++++++++++++++++++++++++++
 src/global.h           |    6 ++
 tests/generic/1200     |   55 ++++++++++++++++
 tests/generic/1200.out |    3 +
 tests/generic/1201     |   53 +++++++++++++++
 tests/generic/1201.out |    4 +
 tests/generic/1202     |   47 +++++++++++++
 tests/generic/1202.out |    2 +
 tests/generic/1203     |   58 +++++++++++++++++
 tests/generic/1203.out |    2 +
 tests/generic/1204     |  100 +++++++++++++++++++++++++++++
 tests/generic/1204.out |   86 +++++++++++++++++++++++++
 tests/generic/1205     |  116 +++++++++++++++++++++++++++++++++
 tests/generic/1205.out |   90 ++++++++++++++++++++++++++
 tests/generic/1206     |   76 ++++++++++++++++++++++
 tests/generic/1206.out |   32 +++++++++
 tests/generic/1207     |  122 +++++++++++++++++++++++++++++++++++
 tests/generic/1207.out |   48 ++++++++++++++
 tests/generic/1209     |  101 +++++++++++++++++++++++++++++
 tests/generic/1209.out |   33 +++++++++
 tests/generic/1210     |   48 ++++++++++++++
 tests/generic/1210.out |    6 ++
 tests/generic/1211     |  105 ++++++++++++++++++++++++++++++
 tests/generic/1211.out |   40 +++++++++++
 tests/generic/1212     |   58 +++++++++++++++++
 tests/generic/1212.out |    2 +
 tests/generic/1213     |  126 ++++++++++++++++++++++++++++++++++++
 tests/generic/1213.out |   48 ++++++++++++++
 tests/generic/1214     |   63 ++++++++++++++++++
 tests/generic/1214.out |    2 +
 tests/generic/1215     |   70 ++++++++++++++++++++
 tests/generic/1215.out |    2 +
 tests/generic/1216     |   53 +++++++++++++++
 tests/generic/1216.out |    6 ++
 tests/generic/1217     |   56 ++++++++++++++++
 tests/generic/1217.out |    4 +
 tests/generic/1218     |  115 +++++++++++++++++++++++++++++++++
 tests/generic/1218.out |   49 ++++++++++++++
 tests/generic/1219     |   83 ++++++++++++++++++++++++
 tests/generic/1219.out |   17 +++++
 tests/xfs/1202         |   59 +++++++++++++++++
 tests/xfs/1202.out     |   12 +++
 tests/xfs/1208         |   62 ++++++++++++++++++
 tests/xfs/1208.out     |   10 +++
 tests/xfs/1211         |   59 +++++++++++++++++
 tests/xfs/1211.out     |    7 ++
 tests/xfs/1212         |   61 +++++++++++++++++
 tests/xfs/1212.out     |    5 +
 tests/xfs/122.out      |    3 +
 tests/xfs/537          |    2 -
 60 files changed, 2798 insertions(+), 3 deletions(-)
 create mode 100644 src/fiexchange.h
 create mode 100755 tests/generic/1200
 create mode 100644 tests/generic/1200.out
 create mode 100755 tests/generic/1201
 create mode 100644 tests/generic/1201.out
 create mode 100755 tests/generic/1202
 create mode 100644 tests/generic/1202.out
 create mode 100755 tests/generic/1203
 create mode 100644 tests/generic/1203.out
 create mode 100755 tests/generic/1204
 create mode 100644 tests/generic/1204.out
 create mode 100755 tests/generic/1205
 create mode 100644 tests/generic/1205.out
 create mode 100755 tests/generic/1206
 create mode 100644 tests/generic/1206.out
 create mode 100755 tests/generic/1207
 create mode 100644 tests/generic/1207.out
 create mode 100755 tests/generic/1209
 create mode 100644 tests/generic/1209.out
 create mode 100755 tests/generic/1210
 create mode 100644 tests/generic/1210.out
 create mode 100755 tests/generic/1211
 create mode 100644 tests/generic/1211.out
 create mode 100755 tests/generic/1212
 create mode 100644 tests/generic/1212.out
 create mode 100755 tests/generic/1213
 create mode 100644 tests/generic/1213.out
 create mode 100755 tests/generic/1214
 create mode 100644 tests/generic/1214.out
 create mode 100755 tests/generic/1215
 create mode 100644 tests/generic/1215.out
 create mode 100755 tests/generic/1216
 create mode 100644 tests/generic/1216.out
 create mode 100755 tests/generic/1217
 create mode 100644 tests/generic/1217.out
 create mode 100755 tests/generic/1218
 create mode 100644 tests/generic/1218.out
 create mode 100755 tests/generic/1219
 create mode 100755 tests/generic/1219.out
 create mode 100755 tests/xfs/1202
 create mode 100644 tests/xfs/1202.out
 create mode 100755 tests/xfs/1208
 create mode 100644 tests/xfs/1208.out
 create mode 100755 tests/xfs/1211
 create mode 100644 tests/xfs/1211.out
 create mode 100755 tests/xfs/1212
 create mode 100644 tests/xfs/1212.out

