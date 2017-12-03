Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:23045 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751626AbdLCVwH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 3 Dec 2017 16:52:07 -0500
Date: Mon, 4 Dec 2017 08:52:04 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 6/7] xfs: refactor inode chunk alloc/free tx
 reservation
Message-ID: <20171203215204.GU5858@dastard>
References: <20171130185836.18481-1-bfoster@redhat.com>
 <20171130185836.18481-7-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171130185836.18481-7-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Nov 30, 2017 at 01:58:35PM -0500, Brian Foster wrote:
> The reservation for the various forms of inode allocation is
> scattered across several different functions. This includes two
> variants of chunk allocation (v5 icreate transactions vs. older
> create transactions) and the inode free transaction.
> 
> To clean up some of this code and clarify the purpose of specific
> allocfree reservations, continue the pattern of defining helper
> functions for smaller operational units of broader transactions.
> Refactor the reservation into an inode chunk alloc/free helper that
> considers the various conditions based on filesystem format.
> 
> An inode chunk free involves an extent free and buffer
> invalidations. The latter requires reservation for log headers only.
> An inode chunk allocation modifies the free space btrees and logs
> the chunk on v4 supers. v5 supers initialize the inode chunk using
> ordered buffers and so do not log the chunk.
> 
> As a side effect of this refactoring, add one more allocfree res to
> the ifree transaction. Technically this does not serve a specific
> purpose because inode chunks are freed via deferred operations and
> thus occur after a transaction roll. tr_ifree has a bit of a history
> of tx overruns caused by too many agfl fixups during sustained file
> deletion workloads, so add this extra reservation as a form of
> padding nonetheless.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Minor quibble below, otherwise looks fine.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

> ---
>  fs/xfs/libxfs/xfs_trans_resv.c | 67 ++++++++++++++++++++++++++++++++----------
>  1 file changed, 52 insertions(+), 15 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
> index 19f3a226a357..432dd7d7afea 100644
> --- a/fs/xfs/libxfs/xfs_trans_resv.c
> +++ b/fs/xfs/libxfs/xfs_trans_resv.c
> @@ -34,6 +34,9 @@
>  #include "xfs_trans_space.h"
>  #include "xfs_trace.h"
>  
> +#define _ALLOC	true
> +#define _FREE	false
> +
>  /*
>   * A buffer has a format structure overhead in the log in addition
>   * to the data, so we need to take this into account when reserving

These are defined at the top of the file so most functions see
them (i.e. scope is the file wide)....

> @@ -795,6 +829,9 @@ xfs_calc_sb_reservation(
>  	return xfs_calc_buf_res(1, mp->m_sb.sb_sectsize);
>  }
>  
> +#undef _ALLOC
> +#undef _FREE
> +
>  void
>  xfs_trans_resv_calc(
>  	struct xfs_mount	*mp,

... so why bother undef'ing them seemingly at random in the middle of
the file? Doesn't seem necessary, and will just be more code to
move around in future...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
