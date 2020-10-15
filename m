Return-Path: <SRS0=m1l6=DW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D197AC43457
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Oct 2020 07:22:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 83EE822249
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Oct 2020 07:22:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729324AbgJOHWP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 15 Oct 2020 03:22:15 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:60705 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728742AbgJOHWO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Oct 2020 03:22:14 -0400
Received: from dread.disaster.area (pa49-179-6-140.pa.nsw.optusnet.com.au [49.179.6.140])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 3E5B93AB146
        for <linux-xfs@vger.kernel.org>; Thu, 15 Oct 2020 18:21:57 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kSxaG-000hv5-AY
        for linux-xfs@vger.kernel.org; Thu, 15 Oct 2020 18:21:56 +1100
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1kSxaG-006qLM-07
        for linux-xfs@vger.kernel.org; Thu, 15 Oct 2020 18:21:56 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 00/27] [RFC, WIP] xfsprogs: xfs_buf unification and AIO
Date:   Thu, 15 Oct 2020 18:21:28 +1100
Message-Id: <20201015072155.1631135-1-david@fromorbit.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Ubgvt5aN c=1 sm=1 tr=0 cx=a_idp_d
        a=uDU3YIYVKEaHT0eX+MXYOQ==:117 a=uDU3YIYVKEaHT0eX+MXYOQ==:17
        a=afefHYAZSVUA:10 a=arcD8BCyKO2jvCiehZ0A:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

Big rework. Aimed at unifying the user and kernel buffer caches so
the first thing to do is port the kernel buffer cache code and hack
it to pieces to use userspace AIO.

Overview:

This patchset introduces the kernel buffer caching mechanism to
userspace libxfs. THe core of this is per-AG indexing of the buffer
cache along with global scope LRU based reclaiming. Like the kernel,
it supports both cached and uncached buffers, and the implementation
of these APIs are identical between userspace and kernel space.

To allow the buffer cache implementation to be shared between kernel
and userspace, it needs to be split into two parts. The first is
the domain specific "target" abstraction that implements all the
kernel or userspace specific functions (e.g. memory allocation,
the per-AG cache indexing, the IO engine, etc). The second part is
the shared buffer cache and buffer IO API implementation.

TO use the kernel code, however, we need a bunch of infrastructure
userspace doesn't currently provide. These are atomic variables,
locking primitives, completions, memory barriers, LRU lists, memory
reclaim triggers, and so on.

The simplest, most portable choice for atomic variables and
memory barriers is to use the Userspace RCU library, which is
provides many of the same semantics and interfaces we use within the
kernel for atomic, memory barriers and RCU algorithms. Hence
xfsprogs grows a hard dependency on liburcu6, but this is packaged
on all major distros these days, so that's not a huge problem.

Locking APIs are fleshed out simply by using pthread locks. Spin
locks are not a reliable solution in userspace, so all the kernel
locking mechanisms wrap sleeping locks. We can even use a
pthread_mutex_t as a kernel semaphore replacement because, by
default, pthread_mutex_unlock() does not check the owner matches the
unlocking and hence, unlike kernel mutexes, can be used safely in
non-owner release situations.

For reclaiming the buffer cache when memory usage goes too high, we
make use of the kernel Pressure Stall Information (PSI) monitoring
API via /proc/pressure/memory. THis was introduced in kernel v5.2
and provides dynamic notification of the kernel memory allocation
stalling to reclaim memory. When we get such a notification, we
trigger the buffer cache shrinker to run to free cached buffers,
just like the kernel does. Hence we no longer need to care about how
much RAM we need to reserve for the buffer cache.

The patch series is structured in a way that:

- guts old tracing and debug interfaces 
- adds support infrastructure for atomics, locking, etc.
- creates a new buftarg abstraction
- restructures buftarg implemenation and usage
- moves uncached IO into new buftarg abstraction
- reworks userspace specific buffer read/write interfaces
- implements new functions the buftarg abstraction eeds to provide
- adds the kernel buffer cache implementation
- switches the implementation and removes the old rd/wr and caching
  code
- converts the buftarg IO engine to use AIO

The AIO engine is not fully functional yet - it does not support
discontiguous buffers correctly yet (needs an iocb per buffer map) -
but otherwise it largely works just fine.

There are -lots- of loose ends that still need to be worked on,
especially w.r.t. xfs_repair. Stuff that comes to mind:

- xfs_buf_mark_dirty() just currently calls xfs_bwrite() and does
  synchronous IO. This needs to be converted to a buftarg internal
  delwri buffer list and a flushing mechanism needs to be added.

- AIO engine does not support discontiguous buffers.

- work out best way to handle IOCBs for AIO - is embedding them in
  the xfs_buf the only way to do this efficiently?

- rationalise the xfs_buf/xfs_buftarg split. Work out where to define
  the stuff that is different between kernel and userspace (e.g. the
  struct xfs_buf) vs the stuff that remains the same (e.g. the XBF
  buffer flags)

- lots of code cleanup

- xfs_repair does not cache between phases right now - it
  unconditionally purges the AG cache at the end of AG processing.
  This keeps memory usage way down, and for filesystems that have
  too much metadata to cache entirely in RAM, it's *much* faster
  than xfs_repair v5.6.0. On smaller filesystems, however, hitting
  RAM caches is much more desirable. Hence there is work to be done
  here determining how to manage the caches effectively.

- async buffer readahead works in userspace now, but unless you have
  a very high IOP device (think in multiples of 100kiops) the
  xfs_repair prefetch mechanism that trades off bandwidth for iops is
  still faster. More investigative work is needed here.

- xfs_db could likely use readahead for btree traversals and other
  things.

- More memory pressure trigger testing needs to be done to determine
  if the trigger settings are sufficient to prevent OOM kills on
  different hardware and filesystem configurations.

- Replace AIO engine with io_uring engine?

- start working on splitting the kernel xfs_buf.[ch] code the same
  way as the userspace code and moving xfs_buf.[ch] to fs/xfs/libxfs
  so that they can be updated in sync.

There's plenty of other stuff, too, but this like is a good
start....

Cheers,

Dave.


Dave Chinner (27):
  xfsprogs: remove unused buffer tracing code
  xfsprogs: remove unused IO_DEBUG functionality
  libxfs: get rid of b_bcount from xfs_buf
  libxfs: rename buftarg->dev to btdev
  xfsprogs: get rid of ancient btree tracing fragments
  xfsprogs: remove xfs_buf_t typedef
  xfsprogs: introduce liburcu support
  libxfs: add spinlock_t wrapper
  atomic: convert to uatomic
  libxfs: add kernel-compatible completion API
  libxfs: add wrappers for kernel semaphores
  xfsprogs: convert use-once buffer reads to uncached IO
  libxfs: introduce userspace buftarg infrastructure
  xfs: rename libxfs_buftarg_init to libxfs_open_devices()
  libxfs: introduce userspace buftarg infrastructure
  libxfs: add a synchronous IO engine to the buftarg
  xfsprogs: convert libxfs_readbufr to libxfs_buf_read_uncached
  libxfs: convert libxfs_bwrite to buftarg IO
  libxfs: add cache infrastructure to buftarg
  libxfs: add internal lru to btcache
  libxfs: Add kernel list_lru wrapper
  libxfs: introduce new buffer cache infrastructure
  libxfs: use PSI information to detect memory pressure
  libxfs: add a buftarg cache shrinker implementation
  libxfs: switch buffer cache implementations
  build: set platform_defs.h.in dependency correctly
  libxfs: convert sync IO buftarg engine to AIO

 Makefile                   |    2 +-
 configure.ac               |    3 +
 copy/Makefile              |    3 +-
 copy/xfs_copy.c            |   15 +-
 db/Makefile                |    3 +-
 db/init.c                  |    4 +-
 db/io.c                    |   33 +-
 db/metadump.c              |    2 +-
 db/sb.c                    |    2 +-
 debian/control             |    2 +-
 growfs/Makefile            |    3 +-
 include/Makefile           |    6 +-
 include/atomic.h           |   63 +-
 include/builddefs.in       |    6 +-
 include/cache.h            |  133 ----
 include/completion.h       |   61 ++
 include/libxfs.h           |   30 +-
 include/libxlog.h          |    6 +-
 include/list_lru.h         |   69 ++
 include/platform_defs.h.in |    2 +
 include/sema.h             |   35 +
 include/spinlock.h         |   25 +
 include/xfs.h              |   23 +
 include/xfs_btree_trace.h  |   87 ---
 include/xfs_inode.h        |    3 +-
 include/xfs_mount.h        |   13 +
 include/xfs_trace.h        |   24 +
 include/xfs_trans.h        |    1 +
 libfrog/linux.c            |   14 +-
 libfrog/workqueue.c        |    3 +
 libxfs/Makefile            |    7 +-
 libxfs/buftarg.c           |  953 +++++++++++++++++++++++++
 libxfs/cache.c             |  724 -------------------
 libxfs/init.c              |  220 +++---
 libxfs/libxfs_api_defs.h   |    7 +
 libxfs/libxfs_io.h         |  185 +----
 libxfs/libxfs_priv.h       |   74 +-
 libxfs/logitem.c           |   10 +-
 libxfs/rdwr.c              | 1234 +-------------------------------
 libxfs/trans.c             |   21 +-
 libxfs/util.c              |    8 +-
 libxfs/xfs_alloc.c         |   16 +-
 libxfs/xfs_bmap.c          |    6 +-
 libxfs/xfs_btree.c         |   10 +-
 libxfs/xfs_buf.c           | 1357 ++++++++++++++++++++++++++++++++++++
 libxfs/xfs_buf.h           |  242 +++++++
 libxfs/xfs_buftarg.h       |  176 +++++
 libxfs/xfs_ialloc.c        |    4 +-
 libxfs/xfs_rtbitmap.c      |   22 +-
 libxlog/xfs_log_recover.c  |   23 +-
 logprint/Makefile          |    3 +-
 logprint/log_print_all.c   |    2 +-
 logprint/logprint.c        |    2 +-
 m4/Makefile                |    1 +
 m4/package_urcu.m4         |   22 +
 mdrestore/Makefile         |    3 +-
 mkfs/Makefile              |    2 +-
 mkfs/proto.c               |   11 +-
 mkfs/xfs_mkfs.c            |   61 +-
 repair/Makefile            |    2 +-
 repair/agheader.c          |    2 +-
 repair/attr_repair.c       |   14 +-
 repair/da_util.c           |    2 +-
 repair/da_util.h           |    2 +-
 repair/dino_chunks.c       |   14 +-
 repair/dinode.c            |    4 +-
 repair/incore.h            |    2 +-
 repair/phase3.c            |    7 +-
 repair/phase4.c            |    5 +-
 repair/phase5.c            |    2 +-
 repair/phase6.c            |    4 +-
 repair/prefetch.c          |  118 ++--
 repair/progress.c          |   16 +-
 repair/progress.h          |    4 +-
 repair/rt.c                |    4 +-
 repair/scan.c              |   10 +-
 repair/xfs_repair.c        |  192 +++--
 scrub/Makefile             |    3 +-
 scrub/progress.c           |    2 +
 79 files changed, 3644 insertions(+), 2847 deletions(-)
 delete mode 100644 include/cache.h
 create mode 100644 include/completion.h
 create mode 100644 include/list_lru.h
 create mode 100644 include/sema.h
 create mode 100644 include/spinlock.h
 delete mode 100644 include/xfs_btree_trace.h
 create mode 100644 libxfs/buftarg.c
 delete mode 100644 libxfs/cache.c
 create mode 100644 libxfs/xfs_buf.c
 create mode 100644 libxfs/xfs_buf.h
 create mode 100644 libxfs/xfs_buftarg.h
 create mode 100644 m4/package_urcu.m4

-- 
2.28.0

