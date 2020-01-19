Return-Path: <SRS0=5eVt=3I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00366C33CAF
	for <linux-xfs@archiver.kernel.org>; Sun, 19 Jan 2020 20:49:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C495220678
	for <linux-xfs@archiver.kernel.org>; Sun, 19 Jan 2020 20:49:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728792AbgASUtb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 19 Jan 2020 15:49:31 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:42146 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728721AbgASUtb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 19 Jan 2020 15:49:31 -0500
Received: from dread.disaster.area (pa49-181-172-170.pa.nsw.optusnet.com.au [49.181.172.170])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 40C0D7EB5F2;
        Mon, 20 Jan 2020 07:49:27 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1itHVd-0007GU-B4; Mon, 20 Jan 2020 07:49:25 +1100
Date:   Mon, 20 Jan 2020 07:49:25 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 1/2] xfs: force writes to delalloc regions to unwritten
Message-ID: <20200119204925.GC9407@dread.disaster.area>
References: <157915534429.2406747.2688273938645013888.stgit@magnolia>
 <157915535059.2406747.264640456606868955.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157915535059.2406747.264640456606868955.stgit@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=IIEU8dkfCNxGYurWsojP/w==:117 a=IIEU8dkfCNxGYurWsojP/w==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=Jdjhy38mL1oA:10
        a=yPCof4ZbAAAA:8 a=7-415B0cAAAA:8 a=zaeWMwQE6Whg1QJTH98A:9
        a=fA_ONMZ9WOeYEU84:21 a=2Mi-Ex1vVm9ECiPF:21 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 15, 2020 at 10:15:50PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> When writing to a delalloc region in the data fork, commit the new
> allocations (of the da reservation) as unwritten so that the mappings
> are only marked written once writeback completes successfully.  This
> fixes the problem of stale data exposure if the system goes down during
> targeted writeback of a specific region of a file, as tested by
> generic/042.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_bmap.c |   28 +++++++++++++++++-----------
>  1 file changed, 17 insertions(+), 11 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 4544732d09a5..220ea1dc67ab 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -4190,17 +4190,7 @@ xfs_bmapi_allocate(
>  	bma->got.br_blockcount = bma->length;
>  	bma->got.br_state = XFS_EXT_NORM;
>  
> -	/*
> -	 * In the data fork, a wasdelay extent has been initialized, so
> -	 * shouldn't be flagged as unwritten.
> -	 *
> -	 * For the cow fork, however, we convert delalloc reservations
> -	 * (extents allocated for speculative preallocation) to
> -	 * allocated unwritten extents, and only convert the unwritten
> -	 * extents to real extents when we're about to write the data.
> -	 */
> -	if ((!bma->wasdel || (bma->flags & XFS_BMAPI_COWFORK)) &&
> -	    (bma->flags & XFS_BMAPI_PREALLOC))
> +	if (bma->flags & XFS_BMAPI_PREALLOC)
>  		bma->got.br_state = XFS_EXT_UNWRITTEN;
>  
>  	if (bma->wasdel)
> @@ -4608,8 +4598,24 @@ xfs_bmapi_convert_delalloc(
>  	bma.offset = bma.got.br_startoff;
>  	bma.length = max_t(xfs_filblks_t, bma.got.br_blockcount, MAXEXTLEN);
>  	bma.minleft = xfs_bmapi_minleft(tp, ip, whichfork);
> +
> +	/*
> +	 * When we're converting the delalloc reservations backing dirty pages
> +	 * in the page cache, we must be careful about how we create the new
> +	 * extents:
> +	 *
> +	 * New CoW fork extents are created unwritten, turned into real extents
> +	 * when we're about to write the data to disk, and mapped into the data
> +	 * fork after the write finishes.  End of story.
> +	 *
> +	 * New data fork extents must be mapped in as unwritten and converted
> +	 * to real extents after the write succeeds to avoid exposing stale
> +	 * disk contents if we crash.
> +	 */
>  	if (whichfork == XFS_COW_FORK)
>  		bma.flags = XFS_BMAPI_COWFORK | XFS_BMAPI_PREALLOC;
> +	else
> +		bma.flags = XFS_BMAPI_PREALLOC;

	bma.flags = XFS_BMAPI_PREALLOC;
	if (whichfork == XFS_COW_FORK)
		bma.flags |= XFS_BMAPI_COWFORK;

However, I'm still not convinced that this is the right/best
solution to the problem. It is the easiest, yes, but the down side
on fast/high iops storage and/or under low memory conditions has
potential to be extremely significant.

I suspect that heavy users of buffered O_DSYNC writes into sparse
files are going to notice this the most - there are databases out
there that work this way. And I suspect that most of the workloads
that use buffered O_DSYNC IO heavily won't see this change for years
as enterprise upgrade cycles are notoriously slow.

IOWs, all I see this change doing is kicking the can down the road
and guaranteeing that we'll still have to solve this stale data
exposure problem more efficiently in the future. And instead of
doing it now when we have the time and freedom to do the work, it
will have to be done urgently under high priority escalation
pressures...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
