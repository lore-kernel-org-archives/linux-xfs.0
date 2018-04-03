Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:13276 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752109AbeDCBs7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Apr 2018 21:48:59 -0400
Date: Tue, 3 Apr 2018 11:48:57 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/2] xfs: skip scrub xref if corruption already noted
Message-ID: <20180403014857.GI1150@dastard>
References: <152269892987.16253.3900560313483881560.stgit@magnolia>
 <152269893600.16253.2058199896357918178.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152269893600.16253.2058199896357918178.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Apr 02, 2018 at 12:55:36PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Don't bother looking for cross-referencing problems if the metadata is
> already corrupt or we've already found a cross-referencing problem.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/scrub/alloc.c    |    4 +++-
>  fs/xfs/scrub/common.c   |    5 +++++
>  fs/xfs/scrub/ialloc.c   |    4 +++-
>  fs/xfs/scrub/refcount.c |    8 ++++++--
>  fs/xfs/scrub/rmap.c     |    8 ++++++--
>  fs/xfs/scrub/rtbitmap.c |    4 ++++
>  6 files changed, 27 insertions(+), 6 deletions(-)
> 
> 
> diff --git a/fs/xfs/scrub/alloc.c b/fs/xfs/scrub/alloc.c
> index 517c079..096bc53 100644
> --- a/fs/xfs/scrub/alloc.c
> +++ b/fs/xfs/scrub/alloc.c
> @@ -172,7 +172,9 @@ xfs_scrub_xref_is_used_space(
>  	bool				is_freesp;
>  	int				error;
>  
> -	if (!sc->sa.bno_cur)
> +	if (!sc->sa.bno_cur ||
> +	    (sc->sm->sm_flags & (XFS_SCRUB_OFLAG_CORRUPT |
> +				 XFS_SCRUB_OFLAG_XCORRUPT)))

Can you put this check in a static inline?

	if (xfs_scrub_object_is_corrupt(sc))
		return;

Looks a bunch neater here.

Otherwise it looks fine.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
