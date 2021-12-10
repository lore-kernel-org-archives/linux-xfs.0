Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98E10C433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 10 Dec 2021 00:32:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234874AbhLJAgM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Dec 2021 19:36:12 -0500
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:55481 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234840AbhLJAgM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Dec 2021 19:36:12 -0500
Received: from dread.disaster.area (pa49-181-243-119.pa.nsw.optusnet.com.au [49.181.243.119])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id A12C5E0DAC7;
        Fri, 10 Dec 2021 11:32:36 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mvTU4-001BoW-RV; Fri, 10 Dec 2021 11:09:56 +1100
Date:   Fri, 10 Dec 2021 11:09:56 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J. Wong" <djwong@kernel.org>
Subject: [GIT PULL] xfs: xlog_write rework and CIL scalability
Message-ID: <20211210000956.GO449541@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=epq8cqlX c=1 sm=1 tr=0 ts=61b2a024
        a=BEa52nrBdFykVEm6RU8P4g==:117 a=BEa52nrBdFykVEm6RU8P4g==:17
        a=kj9zAlcOel0A:10 a=IOMw9HtfNCkA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=ygoPz_a7nZXkr0Gp71UA:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Darrick,

Can you please pull the following changes from the tag listed below
for the XFS dev tree?

Cheers,

Dave.

The following changes since commit 0fcfb00b28c0b7884635dacf38e46d60bf3d4eb1:

  Linux 5.16-rc4 (2021-12-05 14:08:22 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git tags/xfs-cil-scale-3-tag

for you to fetch changes up to 3b5181b310e0f2064f2aafb6143cdb0e920f5858:

  xfs: expanding delayed logging design with background material (2021-12-09 10:22:36 +1100)

----------------------------------------------------------------
xfs: CIL and log scalability improvements

xlog_write() is code that causes severe eye bleeding. It's extremely
difficult to understand the way it is structured, and extremely easy
to break because of all the weird parameters it passes between
functions that do very non-obvious things. state is set in
xlog_write_finish_copy() that is carried across both outer and inner
loop iterations that is used by xlog_write_setup_copy(), which also
sets state that xlog_write_finish_copy() needs. The way iclog space
was obtained affects the accounting logic that ends up being passed
to xlog_state_finish_copy(). The code that handles commit iclogs is
spread over multiple functions and is obfuscated by the set/finish
copy code.

It's just a mess.

It's also extremely inefficient.

That's why I've rewritten the code. I think the code I've written is
much easier to understand and there's less of it.  The compiled code
is smaller and faster. It has much fewer subtleties and outside
dependencies, and is easier to reason about and modify.

Built on top of this is the CIL scalability improvements. My 32p
machine hits lock contention limits in xlog_cil_commit() at about
700,000 transaction commits a section. It hits this at 16 thread
workloads, and 32 thread workloads go no faster and just burn CPU on
the CIL spinlocks.

This patchset gets rid of spinlocks and global serialisation points
in the xlog_cil_commit() path. It does this by moving to a
combination of per-cpu counters, unordered per-cpu lists and
post-ordered per-cpu lists, and is built upon the xlog_write()
simplifications introduced earlier in the rewrite of that function.

This results in transaction commit rates exceeding 2 million
commits/s under unlink certain workloads, but in general the
improvements are smaller than this as the scalability limitations
simply move from xlog_cil_commit() to global VFS lock contexts.

----------------------------------------------------------------
Christoph Hellwig (2):
      xfs: change the type of ic_datap
      xfs: remove xlog_verify_dest_ptr

Dave Chinner (28):
      xfs: factor out the CIL transaction header building
      xfs: only CIL pushes require a start record
      xfs: embed the xlog_op_header in the unmount record
      xfs: embed the xlog_op_header in the commit record
      xfs: log tickets don't need log client id
      xfs: move log iovec alignment to preparation function
      xfs: reserve space and initialise xlog_op_header in item formatting
      xfs: log ticket region debug is largely useless
      xfs: pass lv chain length into xlog_write()
      xfs: introduce xlog_write_full()
      xfs: introduce xlog_write_partial()
      xfs: xlog_write() no longer needs contwr state
      xfs: xlog_write() doesn't need optype anymore
      xfs: CIL context doesn't need to count iovecs
      xfs: use the CIL space used counter for emptiness checks
      xfs: lift init CIL reservation out of xc_cil_lock
      xfs: rework per-iclog header CIL reservation
      xfs: introduce per-cpu CIL tracking structure
      xfs: implement percpu cil space used calculation
      xfs: track CIL ticket reservation in percpu structure
      xfs: convert CIL busy extents to per-cpu
      xfs: Add order IDs to log items in CIL
      xfs: convert CIL to unordered per cpu lists
      xfs: convert log vector chain to use list heads
      xfs: move CIL ordering to the logvec chain
      xfs: avoid cil push lock if possible
      xfs: xlog_sync() manually adjusts grant head space
      xfs: expanding delayed logging design with background material

 Documentation/filesystems/xfs-delayed-logging-design.rst | 361 +++++++++++++++++++++++++++++++++----
 fs/xfs/libxfs/xfs_log_format.h                           |   1 -
 fs/xfs/xfs_log.c                                         | 809 ++++++++++++++++++++++++++++++++++++----------------------------------------------
 fs/xfs/xfs_log.h                                         |  58 ++----
 fs/xfs/xfs_log_cil.c                                     | 550 +++++++++++++++++++++++++++++++++++++++-----------------
 fs/xfs/xfs_log_priv.h                                    | 103 +++++------
 fs/xfs/xfs_super.c                                       |   1 +
 fs/xfs/xfs_trans.c                                       |  10 +-
 fs/xfs/xfs_trans.h                                       |   1 +
 fs/xfs/xfs_trans_priv.h                                  |   3 +-
 10 files changed, 1134 insertions(+), 763 deletions(-)

-- 
Dave Chinner
david@fromorbit.com
