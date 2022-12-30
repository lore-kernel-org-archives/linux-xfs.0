Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF0ABC4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:11:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235657AbiL3XLA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:11:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235616AbiL3XK6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:10:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E851DE81
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 15:10:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 180FDB81DA8
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 23:10:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB228C433EF;
        Fri, 30 Dec 2022 23:10:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672441854;
        bh=wzQo5aObNdjatgdRQHotFlUGtTvjZbp9oUXkeANZlek=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=HKn/oSSB4SY6eD93PvKPyYl76F3kLQb5bq1q9MDi7TZD2JBJBZOvDHp24Mlnig9t7
         SBX/IsbLMZtLxX0NSldXGwmkHMaFQ1K6EXTxOfTl+I75L9gTcEES9I3pS2QZRmY8P7
         074BHyLRkXMpiL4lp4S456vZuLKhW/hRQvyGjUHejWVt3jiR9X3gxeBjlwiFFL4YU9
         x/JvzTBOPgB0ymrFXxHvz3gN4q3YZg+4HH9lhuuoE/BbtDA6/s62/NxclR3IL3jGxU
         ibTqOC7l4Zi3nRhr+xF/+yF/bqKiMPcFay7fxpvLkn21vB6jzgtJmpAkUMJkvrPstE
         pmJptD/9lX0Ow==
Subject: [PATCHSET v24.0 0/9] libxfs: support in-memory btrees
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:41 -0800
Message-ID: <167243866153.711834.17585439086893346840.stgit@magnolia>
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

Online repair of the reverse-mapping btrees presens some unique
challenges.  To construct a new reverse mapping btree, we must scan the
entire filesystem, but we cannot afford to quiesce the entire filesystem
for the potentially lengthy scan.

For rmap btrees, therefore, we relax our requirements of totally atomic
repairs.  Instead, repairs will scan all inodes, construct a new reverse
mapping dataset, format a new btree, and commit it before anyone trips
over the corruption.  This is exactly the same strategy as was used in
the quotacheck and nlink scanners.

Unfortunately, the xfarray cannot perform key-based lookups and is
therefore unsuitable for supporting live updates.  Luckily, we already a
data structure that maintains an indexed rmap recordset -- the existing
rmap btree code!  Hence we port the existing btree and buffer target
code to be able to create a btree using the xfile we developed earlier.
Live hooks keep the in-memory btree up to date for any resources that
have already been scanned.

This approach is not maximally memory efficient, but we can use the same
rmap code that we do everywhere else, which provides improved stability
without growing the code base even more.  Note that in-memory btree
blocks are always page sized.

This patchset modifies the kernel xfs buffer cache to be capable of
using a xfile (aka a shmem file) as a backing device.  It then augments
the btree code to support creating btree cursors with buffers that come
from a buftarg other than the data device (namely an xfile-backed
buftarg).  For the userspace xfs buffer cache, we instead use a memfd or
an O_TMPFILE file as a backing device.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=in-memory-btrees

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=in-memory-btrees
---
 configure.ac                |    3 
 copy/xfs_copy.c             |    2 
 db/init.c                   |    7 
 db/sb.c                     |    3 
 include/builddefs.in        |    3 
 include/libxfs.h            |    5 
 include/xfs_mount.h         |   10 +
 include/xfs_trace.h         |   15 +
 include/xfs_trans.h         |    1 
 libfrog/bitmap.c            |   64 +++
 libfrog/bitmap.h            |    3 
 libxfs/Makefile             |   15 +
 libxfs/init.c               |  131 +++++--
 libxfs/libxfs_io.h          |   38 ++
 libxfs/libxfs_priv.h        |    2 
 libxfs/rdwr.c               |  117 +++++-
 libxfs/trans.c              |   40 ++
 libxfs/xfbtree.c            |  797 +++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfbtree.h            |   57 +++
 libxfs/xfile.c              |  258 ++++++++++++++
 libxfs/xfile.h              |  108 ++++++
 libxfs/xfs_btree.c          |  173 ++++++++-
 libxfs/xfs_btree.h          |   17 +
 libxfs/xfs_btree_mem.h      |  128 +++++++
 libxfs/xfs_refcount_btree.c |    4 
 libxfs/xfs_rmap_btree.c     |    4 
 logprint/logprint.c         |    2 
 m4/package_libcdev.m4       |   50 +++
 mkfs/xfs_mkfs.c             |    4 
 repair/prefetch.c           |   12 -
 repair/prefetch.h           |    1 
 repair/progress.c           |   14 -
 repair/progress.h           |    2 
 repair/scan.c               |    2 
 repair/xfs_repair.c         |   32 +-
 35 files changed, 1970 insertions(+), 154 deletions(-)
 create mode 100644 libxfs/xfbtree.c
 create mode 100644 libxfs/xfbtree.h
 create mode 100644 libxfs/xfile.c
 create mode 100644 libxfs/xfile.h
 create mode 100644 libxfs/xfs_btree_mem.h

