Return-Path: <SRS0=m1l6=DW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32602C433DF
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Oct 2020 18:38:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A890721582
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Oct 2020 18:38:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="E0oZDKSE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733063AbgJOSiE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 15 Oct 2020 14:38:04 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:38226 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731154AbgJOSiE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Oct 2020 14:38:04 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09FISdk7168497;
        Thu, 15 Oct 2020 18:37:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=DZm2ItxqLUXsjQl63Tk1IFoZ5rRurWbwxvipmU7JIGY=;
 b=E0oZDKSEAyDhbSn2m4TSpFSppoYVldWcTvFZcxVsbPqUKXRx5F3NbaIYsaHLoXSuo8lO
 1j5YGCKndwvGNe4wgD/WrihAFuZYv4sSu6Rglh2AiNLs/0zfs/rqK+HuMPbhkZbibKHZ
 O/fMeZs+wfBcXYpXU+7etRULZWrgw4OjItSF9QEYEB5y6yk3wT1zIyn1Cv6Y/p+qKmA2
 cgwJ0omvtLUFIp06gQMDdu5dVFEMCZknB6K8KJd2P6VTLBR4+hC0CU1Zj7H73rDEgycH
 rpEvEmmbhJG0KzoDTTs8Kigtzn0u8xEW1Fx/yKnvzKQKaR2AnCXTZ+AnlFzpJsyJO+ID 2A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 346g8gkj1w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 15 Oct 2020 18:37:59 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09FITdiQ123780;
        Thu, 15 Oct 2020 18:37:58 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 344by5jgqh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Oct 2020 18:37:58 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09FIbv2J011494;
        Thu, 15 Oct 2020 18:37:57 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 15 Oct 2020 11:37:57 -0700
Date:   Thu, 15 Oct 2020 11:37:56 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 00/27] [RFC, WIP] xfsprogs: xfs_buf unification and AIO
Message-ID: <20201015183756.GE9837@magnolia>
References: <20201015072155.1631135-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201015072155.1631135-1-david@fromorbit.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9775 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 suspectscore=59 mlxscore=0 malwarescore=0 adultscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010150123
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9775 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 suspectscore=59
 priorityscore=1501 phishscore=0 clxscore=1015 spamscore=0 adultscore=0
 mlxscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010150123
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 15, 2020 at 06:21:28PM +1100, Dave Chinner wrote:
> Hi folks,
> 
> Big rework. Aimed at unifying the user and kernel buffer caches so
> the first thing to do is port the kernel buffer cache code and hack
> it to pieces to use userspace AIO.

Hurrah!

> Overview:
> 
> This patchset introduces the kernel buffer caching mechanism to
> userspace libxfs. THe core of this is per-AG indexing of the buffer
> cache along with global scope LRU based reclaiming. Like the kernel,
> it supports both cached and uncached buffers, and the implementation
> of these APIs are identical between userspace and kernel space.
> 
> To allow the buffer cache implementation to be shared between kernel
> and userspace, it needs to be split into two parts. The first is
> the domain specific "target" abstraction that implements all the
> kernel or userspace specific functions (e.g. memory allocation,
> the per-AG cache indexing, the IO engine, etc). The second part is
> the shared buffer cache and buffer IO API implementation.
> 
> TO use the kernel code, however, we need a bunch of infrastructure
> userspace doesn't currently provide. These are atomic variables,
> locking primitives, completions, memory barriers, LRU lists, memory
> reclaim triggers, and so on.
> 
> The simplest, most portable choice for atomic variables and
> memory barriers is to use the Userspace RCU library, which is
> provides many of the same semantics and interfaces we use within the
> kernel for atomic, memory barriers and RCU algorithms. Hence
> xfsprogs grows a hard dependency on liburcu6, but this is packaged
> on all major distros these days, so that's not a huge problem.
> 
> Locking APIs are fleshed out simply by using pthread locks. Spin
> locks are not a reliable solution in userspace, so all the kernel
> locking mechanisms wrap sleeping locks. We can even use a
> pthread_mutex_t as a kernel semaphore replacement because, by
> default, pthread_mutex_unlock() does not check the owner matches the
> unlocking and hence, unlike kernel mutexes, can be used safely in
> non-owner release situations.
> 
> For reclaiming the buffer cache when memory usage goes too high, we
> make use of the kernel Pressure Stall Information (PSI) monitoring
> API via /proc/pressure/memory. THis was introduced in kernel v5.2
> and provides dynamic notification of the kernel memory allocation
> stalling to reclaim memory. When we get such a notification, we
> trigger the buffer cache shrinker to run to free cached buffers,
> just like the kernel does. Hence we no longer need to care about how
> much RAM we need to reserve for the buffer cache.

<nod> I have a few comments about that, but they're all in the PSI
patch. :)

> The patch series is structured in a way that:
> 
> - guts old tracing and debug interfaces 
> - adds support infrastructure for atomics, locking, etc.
> - creates a new buftarg abstraction
> - restructures buftarg implemenation and usage
> - moves uncached IO into new buftarg abstraction
> - reworks userspace specific buffer read/write interfaces
> - implements new functions the buftarg abstraction eeds to provide
> - adds the kernel buffer cache implementation
> - switches the implementation and removes the old rd/wr and caching
>   code
> - converts the buftarg IO engine to use AIO
> 
> The AIO engine is not fully functional yet - it does not support
> discontiguous buffers correctly yet (needs an iocb per buffer map) -
> but otherwise it largely works just fine.
> 
> There are -lots- of loose ends that still need to be worked on,
> especially w.r.t. xfs_repair. Stuff that comes to mind:
> 
> - xfs_buf_mark_dirty() just currently calls xfs_bwrite() and does
>   synchronous IO. This needs to be converted to a buftarg internal
>   delwri buffer list and a flushing mechanism needs to be added.

<nod>

> - AIO engine does not support discontiguous buffers.
> 
> - work out best way to handle IOCBs for AIO - is embedding them in
>   the xfs_buf the only way to do this efficiently?

The only other way I can think of is to embed MAX_AIO_EVENTS iocbs in
the buftarg and (I guess) track which ones are free with a bitmap.  That
would cut down the iocb memory overhead to the IOs that we're actually
running at a cost of more bookkeepping and potential starvation issues
for the yuuuge buffer that takes a long time to collect all NR iocbs.

> - rationalise the xfs_buf/xfs_buftarg split. Work out where to define
>   the stuff that is different between kernel and userspace (e.g. the
>   struct xfs_buf) vs the stuff that remains the same (e.g. the XBF
>   buffer flags)

Ow my brain.

> - lots of code cleanup
> 
> - xfs_repair does not cache between phases right now - it
>   unconditionally purges the AG cache at the end of AG processing.
>   This keeps memory usage way down, and for filesystems that have
>   too much metadata to cache entirely in RAM, it's *much* faster

Why is it faster to blow out the cache?  Is it the internal overhead of
digging through a huge buftarg hash table to find the buffer that the
caller wants and/or whacking enough of the other stale buffers to free
up memory to avoid the buffer cache limits?

>   than xfs_repair v5.6.0. On smaller filesystems, however, hitting
>   RAM caches is much more desirable. Hence there is work to be done
>   here determining how to manage the caches effectively.
> 
> - async buffer readahead works in userspace now, but unless you have
>   a very high IOP device (think in multiples of 100kiops) the
>   xfs_repair prefetch mechanism that trades off bandwidth for iops is
>   still faster. More investigative work is needed here.

(No idea what this means.)

> - xfs_db could likely use readahead for btree traversals and other
>   things.
> 
> - More memory pressure trigger testing needs to be done to determine
>   if the trigger settings are sufficient to prevent OOM kills on
>   different hardware and filesystem configurations.
> 
> - Replace AIO engine with io_uring engine?

Hm, is Al actually going to review io_uring as he's been threatening to
do?  I'd hold off until that happens, or one of us goes and tests it in
anger to watch all the smoke leak out, etc...

> - start working on splitting the kernel xfs_buf.[ch] code the same
>   way as the userspace code and moving xfs_buf.[ch] to fs/xfs/libxfs
>   so that they can be updated in sync.

Aha, so yes that answers my question in ... whichever patch that was
somewhere around #17.

--D

> There's plenty of other stuff, too, but this like is a good
> start....
> 
> Cheers,
> 
> Dave.
> 
> 
> Dave Chinner (27):
>   xfsprogs: remove unused buffer tracing code
>   xfsprogs: remove unused IO_DEBUG functionality
>   libxfs: get rid of b_bcount from xfs_buf
>   libxfs: rename buftarg->dev to btdev
>   xfsprogs: get rid of ancient btree tracing fragments
>   xfsprogs: remove xfs_buf_t typedef
>   xfsprogs: introduce liburcu support
>   libxfs: add spinlock_t wrapper
>   atomic: convert to uatomic
>   libxfs: add kernel-compatible completion API
>   libxfs: add wrappers for kernel semaphores
>   xfsprogs: convert use-once buffer reads to uncached IO
>   libxfs: introduce userspace buftarg infrastructure
>   xfs: rename libxfs_buftarg_init to libxfs_open_devices()
>   libxfs: introduce userspace buftarg infrastructure
>   libxfs: add a synchronous IO engine to the buftarg
>   xfsprogs: convert libxfs_readbufr to libxfs_buf_read_uncached
>   libxfs: convert libxfs_bwrite to buftarg IO
>   libxfs: add cache infrastructure to buftarg
>   libxfs: add internal lru to btcache
>   libxfs: Add kernel list_lru wrapper
>   libxfs: introduce new buffer cache infrastructure
>   libxfs: use PSI information to detect memory pressure
>   libxfs: add a buftarg cache shrinker implementation
>   libxfs: switch buffer cache implementations
>   build: set platform_defs.h.in dependency correctly
>   libxfs: convert sync IO buftarg engine to AIO
> 
>  Makefile                   |    2 +-
>  configure.ac               |    3 +
>  copy/Makefile              |    3 +-
>  copy/xfs_copy.c            |   15 +-
>  db/Makefile                |    3 +-
>  db/init.c                  |    4 +-
>  db/io.c                    |   33 +-
>  db/metadump.c              |    2 +-
>  db/sb.c                    |    2 +-
>  debian/control             |    2 +-
>  growfs/Makefile            |    3 +-
>  include/Makefile           |    6 +-
>  include/atomic.h           |   63 +-
>  include/builddefs.in       |    6 +-
>  include/cache.h            |  133 ----
>  include/completion.h       |   61 ++
>  include/libxfs.h           |   30 +-
>  include/libxlog.h          |    6 +-
>  include/list_lru.h         |   69 ++
>  include/platform_defs.h.in |    2 +
>  include/sema.h             |   35 +
>  include/spinlock.h         |   25 +
>  include/xfs.h              |   23 +
>  include/xfs_btree_trace.h  |   87 ---
>  include/xfs_inode.h        |    3 +-
>  include/xfs_mount.h        |   13 +
>  include/xfs_trace.h        |   24 +
>  include/xfs_trans.h        |    1 +
>  libfrog/linux.c            |   14 +-
>  libfrog/workqueue.c        |    3 +
>  libxfs/Makefile            |    7 +-
>  libxfs/buftarg.c           |  953 +++++++++++++++++++++++++
>  libxfs/cache.c             |  724 -------------------
>  libxfs/init.c              |  220 +++---
>  libxfs/libxfs_api_defs.h   |    7 +
>  libxfs/libxfs_io.h         |  185 +----
>  libxfs/libxfs_priv.h       |   74 +-
>  libxfs/logitem.c           |   10 +-
>  libxfs/rdwr.c              | 1234 +-------------------------------
>  libxfs/trans.c             |   21 +-
>  libxfs/util.c              |    8 +-
>  libxfs/xfs_alloc.c         |   16 +-
>  libxfs/xfs_bmap.c          |    6 +-
>  libxfs/xfs_btree.c         |   10 +-
>  libxfs/xfs_buf.c           | 1357 ++++++++++++++++++++++++++++++++++++
>  libxfs/xfs_buf.h           |  242 +++++++
>  libxfs/xfs_buftarg.h       |  176 +++++
>  libxfs/xfs_ialloc.c        |    4 +-
>  libxfs/xfs_rtbitmap.c      |   22 +-
>  libxlog/xfs_log_recover.c  |   23 +-
>  logprint/Makefile          |    3 +-
>  logprint/log_print_all.c   |    2 +-
>  logprint/logprint.c        |    2 +-
>  m4/Makefile                |    1 +
>  m4/package_urcu.m4         |   22 +
>  mdrestore/Makefile         |    3 +-
>  mkfs/Makefile              |    2 +-
>  mkfs/proto.c               |   11 +-
>  mkfs/xfs_mkfs.c            |   61 +-
>  repair/Makefile            |    2 +-
>  repair/agheader.c          |    2 +-
>  repair/attr_repair.c       |   14 +-
>  repair/da_util.c           |    2 +-
>  repair/da_util.h           |    2 +-
>  repair/dino_chunks.c       |   14 +-
>  repair/dinode.c            |    4 +-
>  repair/incore.h            |    2 +-
>  repair/phase3.c            |    7 +-
>  repair/phase4.c            |    5 +-
>  repair/phase5.c            |    2 +-
>  repair/phase6.c            |    4 +-
>  repair/prefetch.c          |  118 ++--
>  repair/progress.c          |   16 +-
>  repair/progress.h          |    4 +-
>  repair/rt.c                |    4 +-
>  repair/scan.c              |   10 +-
>  repair/xfs_repair.c        |  192 +++--
>  scrub/Makefile             |    3 +-
>  scrub/progress.c           |    2 +
>  79 files changed, 3644 insertions(+), 2847 deletions(-)
>  delete mode 100644 include/cache.h
>  create mode 100644 include/completion.h
>  create mode 100644 include/list_lru.h
>  create mode 100644 include/sema.h
>  create mode 100644 include/spinlock.h
>  delete mode 100644 include/xfs_btree_trace.h
>  create mode 100644 libxfs/buftarg.c
>  delete mode 100644 libxfs/cache.c
>  create mode 100644 libxfs/xfs_buf.c
>  create mode 100644 libxfs/xfs_buf.h
>  create mode 100644 libxfs/xfs_buftarg.h
>  create mode 100644 m4/package_urcu.m4
> 
> -- 
> 2.28.0
> 
