Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C14F9C7EE22
	for <linux-xfs@archiver.kernel.org>; Fri, 12 May 2023 01:28:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239589AbjELB2H (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 11 May 2023 21:28:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239504AbjELB2E (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 May 2023 21:28:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0017F171C
        for <linux-xfs@vger.kernel.org>; Thu, 11 May 2023 18:28:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 834FE61214
        for <linux-xfs@vger.kernel.org>; Fri, 12 May 2023 01:28:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D27A6C433EF;
        Fri, 12 May 2023 01:28:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1683854881;
        bh=pVKf1l2Eg8jJDmHE8JiEubCGPaI3lkLG1lZbuJM61T0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=deHU8JlCuX1iUtYbTL/jhgCS4I6tbTLg37zNBWt3inhbSh1LABBIlyvruT4H9uT11
         cMKLaQnx61OXYYFiqaPSp9L2ZaUwbUCp5wzODIa7YgXdewQQwWD7iNPFZA9fjLiAWW
         6aMpxNZsTnBbL1L4cOl3nwfibcef+US5lXK/t2CgskXtUaMHsDZdSHfBH7Ew5yY81y
         wT6X23I0nFu7keYozXCBrL3QAM/TcEUIBqie6Ns0wI4w+KhO7X+ACoR1Ban5dIVmeQ
         037LVFEvDI98ujtw9TVjFeBVD4DgDZ530VIUocvNpEmcS1od3JmD6LutpFHm6Tzp76
         hV+AmeOEIiGjg==
Date:   Thu, 11 May 2023 18:28:01 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [GIT PULL] xfs: Improve CIL scalability
Message-ID: <20230512012801.GI858799@frogsfrogsfrogs>
References: <20220707233347.GO227878@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220707233347.GO227878@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jul 08, 2022 at 09:33:47AM +1000, Dave Chinner wrote:
> Hi Darrick,
> 
> Can you please pull the CIL scalability improvements for 5.20 from
> the tag below? This branch is based on the linux-xfs/for-next branch
> as of 2 days ago, so should apply without any merge issues at all.
> 
> Cheers,
> 
> Dave.
> 
> The following changes since commit 7561cea5dbb97fecb952548a0fb74fb105bf4664:
> 
>   xfs: prevent a UAF when log IO errors race with unmount (2022-07-01 09:09:52 -0700)
> 
> are available in the Git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs tags/xfs-cil-scale-5.20
> 
> for you to fetch changes up to 51a117edff133a1ea8cb0fcbc599b8d5a34414e9:
> 
>   xfs: expanding delayed logging design with background material (2022-07-07 18:56:09 +1000)
> 
> ----------------------------------------------------------------
> xfs: improve CIL scalability
> 
> This series aims to improve the scalability of XFS transaction
> commits on large CPU count machines. My 32p machine hits contention
> limits in xlog_cil_commit() at about 700,000 transaction commits a
> section. It hits this at 16 thread workloads, and 32 thread
> workloads go no faster and just burn CPU on the CIL spinlocks.
> 
> This patchset gets rid of spinlocks and global serialisation points
> in the xlog_cil_commit() path. It does this by moving to a
> combination of per-cpu counters, unordered per-cpu lists and
> post-ordered per-cpu lists.

FWIW, I (rather infrequently) see things like this in the 10 months or
so that this has been in mainline:

run fstests generic/650 at 2023-05-10 19:17:09
XFS (sda3): EXPERIMENTAL Large extent counts feature in use. Use at your own risk!
XFS (sda3): Mounting V5 Filesystem 75c42b12-8a39-4ecd-aac4-6b6ab0e384bd
XFS (sda3): Ending clean mount
smpboot: CPU 1 is now offline
x86: Booting SMP configuration:
smpboot: Booting Node 0 Processor 1 APIC 0x1
smpboot: CPU 1 is now offline
smpboot: CPU 3 is now offline
x86: Booting SMP configuration:
smpboot: Booting Node 0 Processor 1 APIC 0x1
smpboot: Booting Node 0 Processor 3 APIC 0x3
smpboot: CPU 3 is now offline
smpboot: Booting Node 0 Processor 3 APIC 0x3
smpboot: CPU 2 is now offline
smpboot: CPU 3 is now offline
XFS (sda3): ctx ticket reservation ran out. Need to up reservation
XFS (sda3): ticket reservation summary:
XFS (sda3):   unit res    = 9268 bytes
XFS (sda3):   current res = -40 bytes
XFS (sda3):   original count  = 1
XFS (sda3):   remaining count = 1
XFS (sda3): Filesystem has been shut down due to log error (0x2).
XFS (sda3): Please unmount the filesystem and rectify the problem(s).

Not sure what that's about, but given the recent discussions about
percpu counters not quite working correctly when racing with cpu
hotremove, I figured this would be a good time to capture one of the
failures and report it to the list.

--D

> This results in transaction commit rates exceeding 1.4 million
> commits/s under unlink certain workloads, and while the log lock
> contention is largely gone there is still significant lock
> contention in the VFS (dentry cache, inode cache and security layers)
> at >600,000 transactions/s that still limit scalability.
> 
> The changes to the CIL accounting and behaviour, combined with the
> structural changes to xlog_write() in prior patchsets make the
> per-cpu restructuring possible and sane. This allows us to move to
> precalculated reservation requirements that allow for reservation
> stealing to be accounted across multiple CPUs accurately.
> 
> That is, instead of trying to account for continuation log opheaders
> on a "growth" basis, we pre-calculate how many iclogs we'll need to
> write out a maximally sized CIL checkpoint and steal that reserveD
> that space one commit at a time until the CIL has a full
> reservation. If we ever run a commit when we are already at the hard
> limit (because post-throttling) we simply take an extra reservation
> from each commit that is run when over the limit. Hence we don't
> need to do space usage math in the fast path and so never need to
> sum the per-cpu counters in this fast path.
> 
> Similarly, per-cpu lists have the problem of ordering - we can't
> remove an item from a per-cpu list if we want to move it forward in
> the CIL. We solve this problem by using an atomic counter to give
> every commit a sequence number that is copied into the log items in
> that transaction. Hence relogging items just overwrites the sequence
> number in the log item, and does not move it in the per-cpu lists.
> Once we reaggregate the per-cpu lists back into a single list in the
> CIL push work, we can run it through list-sort() and reorder it back
> into a globally ordered list. This costs a bit of CPU time, but now
> that the CIL can run multiple works and pipelines properly, this is
> not a limiting factor for performance. It does increase fsync
> latency when the CIL is full, but workloads issuing large numbers of
> fsync()s or sync transactions end up with very small CILs and so the
> latency impact or sorting is not measurable for such workloads.
> 
> OVerall, this pushes the transaction commit bottleneck out to the
> lockless reservation grant head updates. These atomic updates don't
> start to be a limiting fact until > 1.5 million transactions/s are
> being run, at which point the accounting functions start to show up
> in profiles as the highest CPU users. Still, this series doubles
> transaction throughput without increasing CPU usage before we get
> to that cacheline contention breakdown point...
> `
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> 
> ----------------------------------------------------------------
> Dave Chinner (14):
>       xfs: use the CIL space used counter for emptiness checks
>       xfs: lift init CIL reservation out of xc_cil_lock
>       xfs: rework per-iclog header CIL reservation
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
>  Documentation/filesystems/xfs-delayed-logging-design.rst | 361 +++++++++++++++++++++++++++++++++++++++++++++++------
>  fs/xfs/xfs_log.c                                         |  55 ++++++---
>  fs/xfs/xfs_log.h                                         |   3 +-
>  fs/xfs/xfs_log_cil.c                                     | 472 +++++++++++++++++++++++++++++++++++++++++++++++++++++-----------------
>  fs/xfs/xfs_log_priv.h                                    |  58 ++++++---
>  fs/xfs/xfs_super.c                                       |   1 +
>  fs/xfs/xfs_trans.c                                       |   4 +-
>  fs/xfs/xfs_trans.h                                       |   1 +
>  fs/xfs/xfs_trans_priv.h                                  |   3 +-
>  9 files changed, 768 insertions(+), 190 deletions(-)
> 
> -- 
> Dave Chinner
> david@fromorbit.com
