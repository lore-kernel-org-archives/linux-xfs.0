Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10E24C47094
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Jun 2021 01:26:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E880B6124C
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Jun 2021 01:26:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231175AbhFHB2P (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Jun 2021 21:28:15 -0400
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:54393 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231148AbhFHB2M (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Jun 2021 21:28:12 -0400
Received: from dread.disaster.area (pa49-179-138-183.pa.nsw.optusnet.com.au [49.179.138.183])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id 55D45102AE06;
        Tue,  8 Jun 2021 11:26:07 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lqQVJ-00AD7h-SC; Tue, 08 Jun 2021 11:26:05 +1000
Date:   Tue, 8 Jun 2021 11:26:05 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 5/9] xfs: force inode garbage collection before fallocate
 when space is low
Message-ID: <20210608012605.GI664593@dread.disaster.area>
References: <162310469340.3465262.504398465311182657.stgit@locust>
 <162310472140.3465262.3509717954267805085.stgit@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162310472140.3465262.3509717954267805085.stgit@locust>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0
        a=MnllW2CieawZLw/OcHE/Ng==:117 a=MnllW2CieawZLw/OcHE/Ng==:17
        a=kj9zAlcOel0A:10 a=r6YtysWOX24A:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=LpvWrjS3o2wnucQrIaUA:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 07, 2021 at 03:25:21PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Generally speaking, when a user calls fallocate, they're looking to
> preallocate space in a file in the largest contiguous chunks possible.
> If free space is low, it's possible that the free space will look
> unnecessarily fragmented because there are unlinked inodes that are
> holding on to space that we could allocate.  When this happens,
> fallocate makes suboptimal allocation decisions for the sake of deleted
> files, which doesn't make much sense, so scan the filesystem for dead
> items to delete to try to avoid this.
> 
> Note that there are a handful of fstests that fill a filesystem, delete
> just enough files to allow a single large allocation, and check that
> fallocate actually gets the allocation.  These tests regress because the
> test runs fallocate before the inode gc has a chance to run, so add this
> behavior to maintain as much of the old behavior as possible.

I don't think this is a good justification for the change. Just
because the unit tests exploit an undefined behaviour that no
filesystem actually guarantees to acheive a specific layout, it
doesn't mean we always have to behave that way.

For example, many tests used to use reverse sequential writes to
exploit deficiencies in the allocation algorithms to generate
fragmented files. We fixed that problem and the tests broke because
they couldn't fragment files any more.

Did we reject those changes because the tests broke? No, we didn't
because the tests were exploiting an observed behaviour rather than
a guaranteed behaviour.

So, yeah, "test does X to make Y happen" doesn't mean "X will always
make Y happen". It just means the test needs to be made more robust,
or we have to provide a way for the test to trigger the behaviour it
needs.

Indeed, I think that the way to fix these sorts of issues is to have
the tests issue a syncfs(2) after they've deleted the inodes and have
the filesystem run a inodegc flush as part of the sync mechanism.

Then we don't need to do.....

> +/*
> + * If the target device (or some part of it) is full enough that it won't to be
> + * able to satisfy the entire request, try to free inactive files to free up
> + * space.  While it's perfectly fine to fill a preallocation request with a
> + * bunch of short extents, we prefer to slow down preallocation requests to
> + * combat long term fragmentation in new file data.
> + */
> +static int
> +xfs_alloc_consolidate_freespace(
> +	struct xfs_inode	*ip,
> +	xfs_filblks_t		wanted)
> +{
> +	struct xfs_mount	*mp = ip->i_mount;
> +	struct xfs_perag	*pag;
> +	struct xfs_sb		*sbp = &mp->m_sb;
> +	xfs_agnumber_t		agno;
> +
> +	if (!xfs_has_inodegc_work(mp))
> +		return 0;
> +
> +	if (XFS_IS_REALTIME_INODE(ip)) {
> +		if (sbp->sb_frextents * sbp->sb_rextsize >= wanted)
> +			return 0;
> +		goto free_space;
> +	}
> +
> +	for_each_perag(mp, agno, pag) {
> +		if (pag->pagf_freeblks >= wanted) {
> +			xfs_perag_put(pag);
> +			return 0;
> +		}
> +	}

... really hurty things (e.g. on high AG count fs) on every fallocate()
call, and we have a simple modification to the tests that allow them
to work as they want to on both old and new kernels....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
