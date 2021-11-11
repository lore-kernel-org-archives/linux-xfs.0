Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D554FC433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Nov 2021 23:17:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ACAE961073
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Nov 2021 23:17:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230308AbhKKXUB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 11 Nov 2021 18:20:01 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:33169 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230131AbhKKXUA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 Nov 2021 18:20:00 -0500
Received: from dread.disaster.area (pa49-195-103-97.pa.nsw.optusnet.com.au [49.195.103.97])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id DB68A88C519;
        Fri, 12 Nov 2021 10:17:09 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mlJJc-007iUD-2o; Fri, 12 Nov 2021 10:17:08 +1100
Date:   Fri, 12 Nov 2021 10:17:08 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Catherine Hoang <catherine.hoang@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH 1/2] xfs: add leaf split error tag
Message-ID: <20211111231708.GJ449541@dread.disaster.area>
References: <20211111001716.77336-1-catherine.hoang@oracle.com>
 <20211111001716.77336-2-catherine.hoang@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211111001716.77336-2-catherine.hoang@oracle.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=618da475
        a=fP9RlOTWD4uZJjPSFnn6Ew==:117 a=fP9RlOTWD4uZJjPSFnn6Ew==:17
        a=kj9zAlcOel0A:10 a=vIxV3rELxO4A:10 a=yPCof4ZbAAAA:8 a=7-415B0cAAAA:8
        a=q0XNMpBCU8MrkIu_THEA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Nov 11, 2021 at 12:17:15AM +0000, Catherine Hoang wrote:
> Add an error tag on xfs_da3_split to test log attribute recovery
> and replay.
> 
> Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_da_btree.c | 6 ++++++
>  fs/xfs/libxfs/xfs_errortag.h | 4 +++-
>  fs/xfs/xfs_error.c           | 3 +++
>  3 files changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
> index dd7a2dbce1d1..000101783648 100644
> --- a/fs/xfs/libxfs/xfs_da_btree.c
> +++ b/fs/xfs/libxfs/xfs_da_btree.c
> @@ -22,6 +22,7 @@
>  #include "xfs_trace.h"
>  #include "xfs_buf_item.h"
>  #include "xfs_log.h"
> +#include "xfs_errortag.h"
>  
>  /*
>   * xfs_da_btree.c
> @@ -482,6 +483,11 @@ xfs_da3_split(
>  
>  	trace_xfs_da_split(state->args);
>  
> +	if (XFS_TEST_ERROR(false, state->mp, XFS_ERRTAG_LEAF_SPLIT)) {
> +		error = -EIO;
> +		return error;
> +	}
> +
>  	/*
>  	 * Walk back up the tree splitting/inserting/adjusting as necessary.
>  	 * If we need to insert and there isn't room, split the node, then
> diff --git a/fs/xfs/libxfs/xfs_errortag.h b/fs/xfs/libxfs/xfs_errortag.h
> index c15d2340220c..31aeeb94dd5b 100644
> --- a/fs/xfs/libxfs/xfs_errortag.h
> +++ b/fs/xfs/libxfs/xfs_errortag.h
> @@ -60,7 +60,8 @@
>  #define XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT		37
>  #define XFS_ERRTAG_AG_RESV_FAIL				38
>  #define XFS_ERRTAG_LARP					39
> -#define XFS_ERRTAG_MAX					40
> +#define XFS_ERRTAG_LEAF_SPLIT				40

What leaf is being split?

This looks to be a DA btree split that it the error injection is
being applied to, not a allocbt, rmapbt, etc split. And it's not
really a "leaf split" because xfs_da3_split() walks the entire path
back up the tree splitting nodes as well.

So, really, it's a da tree split, not a generic "leaf split" error
injection point.

And, I suspect this won't always work as intended, because it can
trigger on directory operations as well as attribute ops. Hence it
could be difficult to direct this for testing attr fork operations
during stress at the attr fork....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
