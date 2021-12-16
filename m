Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 973E3C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Dec 2021 04:41:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233592AbhLPElG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Dec 2021 23:41:06 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:55720 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231775AbhLPElF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Dec 2021 23:41:05 -0500
Received: from dread.disaster.area (pa49-181-243-119.pa.nsw.optusnet.com.au [49.181.243.119])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 786418A51CA;
        Thu, 16 Dec 2021 15:41:03 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mxiZi-003dDT-PD; Thu, 16 Dec 2021 15:41:02 +1100
Date:   Thu, 16 Dec 2021 15:41:02 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/7] xfs: only run COW extent recovery when there are no
 live extents
Message-ID: <20211216044102.GX449541@dread.disaster.area>
References: <163961695502.3129691.3496134437073533141.stgit@magnolia>
 <163961699399.3129691.9449691191051808697.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <163961699399.3129691.9449691191051808697.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=61bac35f
        a=BEa52nrBdFykVEm6RU8P4g==:117 a=BEa52nrBdFykVEm6RU8P4g==:17
        a=kj9zAlcOel0A:10 a=IOMw9HtfNCkA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
        a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=M3aAEzC58v9h7IVJa1oA:9
        a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Dec 15, 2021 at 05:09:54PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> As part of multiple customer escalations due to file data corruption
> after copy on write operations, I wrote some fstests that use fsstress
> to hammer on COW to shake things loose.  Regrettably, I caught some
> filesystem shutdowns due to incorrect rmap operations with the following
> loop:
> 
> mount <filesystem>				# (0)
> fsstress <run only readonly ops> &		# (1)
> while true; do
> 	fsstress <run all ops>
> 	mount -o remount,ro			# (2)
> 	fsstress <run only readonly ops>
> 	mount -o remount,rw			# (3)
> done
> 
> When (2) happens, notice that (1) is still running.  xfs_remount_ro will
> call xfs_blockgc_stop to walk the inode cache to free all the COW
> extents, but the blockgc mechanism races with (1)'s reader threads to
> take IOLOCKs and loses, which means that it doesn't clean them all out.
> Call such a file (A).
> 
> When (3) happens, xfs_remount_rw calls xfs_reflink_recover_cow, which
> walks the ondisk refcount btree and frees any COW extent that it finds.
> This function does not check the inode cache, which means that incore
> COW forks of inode (A) is now inconsistent with the ondisk metadata.  If
> one of those former COW extents are allocated and mapped into another
> file (B) and someone triggers a COW to the stale reservation in (A), A's
> dirty data will be written into (B) and once that's done, those blocks
> will be transferred to (A)'s data fork without bumping the refcount.
> 
> The results are catastrophic -- file (B) and the refcount btree are now
> corrupt.  In the first patch, we fixed the race condition in (2) so that
> (A) will always flush the COW fork.  In this second patch, we move the
> _recover_cow call to the initial mount call in (0) for safety.
> 
> As mentioned previously, xfs_reflink_recover_cow walks the refcount
> btree looking for COW staging extents, and frees them.  This was
> intended to be run at mount time (when we know there are no live inodes)
> to clean up any leftover staging events that may have been left behind
> during an unclean shutdown.  As a time "optimization" for readonly
> mounts, we deferred this to the ro->rw transition, not realizing that
> any failure to clean all COW forks during a rw->ro transition would
> result in catastrophic corruption.
> 
> Therefore, remove this optimization and only run the recovery routine
> when we're guaranteed not to have any COW staging extents anywhere,
> which means we always run this at mount time.  While we're at it, move
> the callsite to xfs_log_mount_finish because any refcount btree
> expansion (however unlikely given that we're removing records from the
> right side of the index) must be fed by a per-AG reservation, which
> doesn't exist in its current location.
> 
> Fixes: 174edb0e46e5 ("xfs: store in-progress CoW allocations in the refcount btree")
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>

Looks good now.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
