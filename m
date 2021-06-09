Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-21.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,INCLUDES_PULL_REQUEST,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34C8EC48BCF
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Jun 2021 20:46:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1597561359
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Jun 2021 20:46:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229705AbhFIUst (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Jun 2021 16:48:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:39624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229639AbhFIUst (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 9 Jun 2021 16:48:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 35A1A6128A;
        Wed,  9 Jun 2021 20:46:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623271614;
        bh=Zkng/w4oUhxjCzOgCOH4jlluKJDb5EBDF9eHHrM8uVI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Iz9hvQsRpeST0Cwh6VNR75rouUhp3c6dLifJGqc5s1Mo7RbrHfqvCjXlFq107kZKV
         3dj5tSa4EYHecK5Uvwgr4dH5PeGu4eADG2kHoUzu750DVMu5cuYO5jKjomglnhUtkp
         CPAssLjT1NB9GyAj8I1pbwLYYhUYUjeMKjN+pvv6Kfy8OW87M2FqaW69x1bQlHjXz5
         Y5yJoAQc0pC01x0enM8L5z0rjTAeAYROdS6lFv+h9MZhUz4tjjWeLmhCeRiMOJuRa8
         aZVE+PrwqYgNDWcrxUE0ByQbPJ4w4asXPuitHe9HMSRBa28nZ1dyuOUwpRnYf+oWkM
         opSA4BjGKL9SQ==
Date:   Wed, 9 Jun 2021 13:46:53 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [GIT PULL v2] xfs: CIL and log scalability improvements
Message-ID: <20210609204653.GZ2945738@locust>
References: <20210608044340.GK664593@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210608044340.GK664593@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 08, 2021 at 02:43:40PM +1000, Dave Chinner wrote:
> Hi Darrick,
> 
> I've updated the branch and tag for the CIL and log scalability
> improvements to fix the CPU hotplug bug that was in the previous
> version. The code changes are limited to those, otherwise everything
> else in the series is unchanged.
> 
> Please pull from the tag decsribed below.

Pulled, thanks!

--D

> 
> Cheers,
> 
> Dave.
> 
> The following changes since commit d07f6ca923ea0927a1024dfccafc5b53b61cfecc:
> 
>   Linux 5.13-rc2 (2021-05-16 15:27:44 -0700)
> 
> are available in the Git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git tags/xfs-cil-scale-2-tag
> 
> for you to fetch changes up to 7017b129e69c1b451fa926f2cac507c4128608dc:
> 
>   xfs: expanding delayed logging design with background material (2021-06-08 14:27:46 +1000)
> 
> ----------------------------------------------------------------
> xfs: CIL and log scalability improvements
> 
> Performance improvements are largely documented in the change logs of the
> individual patches. Headline numbers are an increase in transaction rate from
> 700k commits/s to 1.7M commits/s, and a reduction in fua/flush operations by
> 2-3 orders of magnitude on metadata heavy workloads that don't use fsync.
> 
> Summary of series:
> 
> Patches         Modifications
> -------         -------------
> 1-7:            log write FUA/FLUSH optimisations
> 8:              bug fix
> 9-11:           Async CIL pushes
> 12-25:          xlog_write() rework
> 26-39:          CIL commit scalability
> 
> The log write FUA/FLUSH optimisations reduce the number of cache flushes
> required to flush the CIL to the journal. It extends the old pre-delayed logging
> ordering semantics required by writing individual transactions to the iclogs out
> to cover then CIL checkpoint transactions rather than individual writes to the
> iclogs. In doing so, we reduce the cache flush requirements to once per CIL
> checkpoint rather than once per iclog write.
> 
> The async CIL pushes fix a pipeline limitation that only allowed a single CIL
> push to be processed at a time. This was causing CIL checkpoint writing to
> become CPU bound as only a single CIL checkpoint could be pushed at a time. The
> checkpoint pipleine was designed to allow multiple pushes to be in flight at
> once and use careful ordering of the commit records to ensure correct recovery
> order, but the workqueue implementation didn't allow concurrent works to be run.
> The concurrent works now extend out to 4 CIL checkpoints running at a time,
> hence removing the CPU usage limiations without introducing new lock contention
> issues.
> 
> The xlog_write() rework is long overdue. The code is complex, difficult to
> understand, full of tricky, subtle corner cases and just generally really hard
> to modify. This patchset reworks the xlog_write() API to reduce the processing
> overhead of writing out long log vector chains, and factors the xlog_write()
> code into a simple, compact fast path along with a clearer slow path to handle
> the complex cases.
> 
> The CIL commit scalability patchset removes spinlocks from the transaction
> commit fast path. These spinlocks are the performance limiting bottleneck in the
> transaction commit path, so we apply a variety of different techniques to do
> either atomic. lockless or per-cpu updates of the CIL tracking structures during
> commits. This greatly increases the throughput of the the transaction commit
> engine, moving the contention point to the log space tracking algorithms after
> doubling throughput on 32-way workloads.
> 
> ----------------------------------------------------------------
> Dave Chinner (40):
>       xfs: log stripe roundoff is a property of the log
>       xfs: separate CIL commit record IO
>       xfs: remove xfs_blkdev_issue_flush
>       xfs: async blkdev cache flush
>       xfs: CIL checkpoint flushes caches unconditionally
>       xfs: remove need_start_rec parameter from xlog_write()
>       xfs: journal IO cache flush reductions
>       xfs: Fix CIL throttle hang when CIL space used going backwards
>       xfs: xfs_log_force_lsn isn't passed a LSN
>       xfs: AIL needs asynchronous CIL forcing
>       xfs: CIL work is serialised, not pipelined
>       xfs: factor out the CIL transaction header building
>       xfs: only CIL pushes require a start record
>       xfs: embed the xlog_op_header in the unmount record
>       xfs: embed the xlog_op_header in the commit record
>       xfs: log tickets don't need log client id
>       xfs: move log iovec alignment to preparation function
>       xfs: reserve space and initialise xlog_op_header in item formatting
>       xfs: log ticket region debug is largely useless
>       xfs: pass lv chain length into xlog_write()
>       xfs: introduce xlog_write_single()
>       xfs:_introduce xlog_write_partial()
>       xfs: xlog_write() no longer needs contwr state
>       xfs: xlog_write() doesn't need optype anymore
>       xfs: CIL context doesn't need to count iovecs
>       xfs: use the CIL space used counter for emptiness checks
>       xfs: lift init CIL reservation out of xc_cil_lock
>       xfs: rework per-iclog header CIL reservation
>       xfs: introduce CPU hotplug infrastructure
>       xfs: introduce per-cpu CIL tracking structure
>       xfs: implement percpu cil space used calculation
>       xfs: track CIL ticket reservation in percpu structure
>       xfs: convert CIL busy extents to per-cpu
>       xfs: Add order IDs to log items in CIL
>       xfs: convert CIL to unordered per cpu lists
>       xfs: convert log vector chain to use list heads
>       xfs: move CIL ordering to the logvec chain
>       xfs: avoid cil push lock if possible
>       xfs: xlog_sync() manually adjusts grant head space
>       xfs: expanding delayed logging design with background material
> 
>  Documentation/filesystems/xfs-delayed-logging-design.rst |  361 ++++++++++++++++++++++++++----
>  fs/xfs/libxfs/xfs_log_format.h                           |    4 -
>  fs/xfs/libxfs/xfs_types.h                                |    1 +
>  fs/xfs/xfs_bio_io.c                                      |   35 +++
>  fs/xfs/xfs_buf.c                                         |    2 +-
>  fs/xfs/xfs_buf_item.c                                    |   39 ++--
>  fs/xfs/xfs_dquot_item.c                                  |    2 +-
>  fs/xfs/xfs_file.c                                        |   20 +-
>  fs/xfs/xfs_inode.c                                       |   10 +-
>  fs/xfs/xfs_inode_item.c                                  |   18 +-
>  fs/xfs/xfs_inode_item.h                                  |    2 +-
>  fs/xfs/xfs_linux.h                                       |    2 +
>  fs/xfs/xfs_log.c                                         | 1015 +++++++++++++++++++++++++++++++++++++++---------------------------------------------
>  fs/xfs/xfs_log.h                                         |   66 ++----
>  fs/xfs/xfs_log_cil.c                                     |  804 ++++++++++++++++++++++++++++++++++++++++++++++++------------------
>  fs/xfs/xfs_log_priv.h                                    |  123 ++++++-----
>  fs/xfs/xfs_super.c                                       |   52 ++++-
>  fs/xfs/xfs_super.h                                       |    1 -
>  fs/xfs/xfs_sysfs.c                                       |    1 +
>  fs/xfs/xfs_trace.c                                       |    1 +
>  fs/xfs/xfs_trans.c                                       |   18 +-
>  fs/xfs/xfs_trans.h                                       |    5 +-
>  fs/xfs/xfs_trans_ail.c                                   |   11 +-
>  fs/xfs/xfs_trans_priv.h                                  |    3 +-
>  include/linux/cpuhotplug.h                               |    1 +
>  25 files changed, 1632 insertions(+), 965 deletions(-)
> 
> -- 
> Dave Chinner
> david@fromorbit.com
