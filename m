Return-Path: <SRS0=qEB5=44=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C57FC10F25
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Mar 2020 05:36:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0C4BE20873
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Mar 2020 05:36:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726160AbgCKFgD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 11 Mar 2020 01:36:03 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:34670 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725813AbgCKFgD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Mar 2020 01:36:03 -0400
Received: from dread.disaster.area (pa49-195-202-68.pa.nsw.optusnet.com.au [49.195.202.68])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 3D2B07EA0DA;
        Wed, 11 Mar 2020 16:36:00 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jBu2B-0007F2-M7; Wed, 11 Mar 2020 16:35:59 +1100
Date:   Wed, 11 Mar 2020 16:35:59 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/7] xfs: add a function to deal with corrupt buffers
 post-verifiers
Message-ID: <20200311053559.GU10776@dread.disaster.area>
References: <158388763282.939165.6485358230553665775.stgit@magnolia>
 <158388763904.939165.1796274155705134706.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158388763904.939165.1796274155705134706.stgit@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=mqTaRPt+QsUAtUurwE173Q==:117 a=mqTaRPt+QsUAtUurwE173Q==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=SS2py6AdgQ4A:10
        a=yPCof4ZbAAAA:8 a=7-415B0cAAAA:8 a=M00gapl7VjOCj5S8sGwA:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 10, 2020 at 05:47:19PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Add a helper function to get rid of buffers that we have decided are
> corrupt after the verifiers have run.  This function is intended to
> handle metadata checks that can't happen in the verifiers, such as
> inter-block relationship checking.  Note that we now mark the buffer
> stale so that it will not end up on any LRU and will be purged on
> release.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
....
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 11a97bc35f70..9d26e37f78f5 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -16,6 +16,8 @@
>  #include "xfs_log.h"
>  #include "xfs_errortag.h"
>  #include "xfs_error.h"
> +#include "xfs_trans.h"
> +#include "xfs_buf_item.h"
>  
>  static kmem_zone_t *xfs_buf_zone;
>  
> @@ -1572,6 +1574,29 @@ xfs_buf_zero(
>  	}
>  }
>  
> +/*
> + * Log a message about and stale a buffer that a caller has decided is corrupt.
> + *
> + * This function should be called for the kinds of metadata corruption that
> + * cannot be detect from a verifier, such as incorrect inter-block relationship
> + * data.  Do /not/ call this function from a verifier function.

So if it's called from a read verifier, the buffer will not have the
XBF_DONE flag set on it. Maybe we should assert that this flag is
set on the buffer? Yes, I know XBF_DONE will be set at write time,
but most verifiers are called from both the read and write path so
it should catch invalid use at read time...

> + * The buffer must not be dirty prior to the call.  Afterwards, the buffer will

Why can't it be dirty?

> + * be marked stale, but b_error will not be set.  The caller is responsible for
> + * releasing the buffer or fixing it.
> + */
> +void
> +__xfs_buf_mark_corrupt(
> +	struct xfs_buf		*bp,
> +	xfs_failaddr_t		fa)
> +{
> +	ASSERT(bp->b_log_item == NULL ||
> +	       !(bp->b_log_item->bli_flags & XFS_BLI_DIRTY));

XFS_BLI_DIRTY isn't a complete definition of a dirty buffer. What it
means is "modifications to this buffer are not yet
committed to the journal". It may have been linked into a
transaction but not modified, but it can still be XFS_BLI_DIRTY
because it is in the CIL. IOWs, transactions can cancel safely
aborted even when the items in it are dirty as long as the
transaction itself is clean and made no modifications to the object.

Hence I'm not sure what you are trying to protect against here?

The rest of the code looks fine.

Cheers,

Dave,
-- 
Dave Chinner
david@fromorbit.com
