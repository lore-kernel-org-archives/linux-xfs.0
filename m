Return-Path: <SRS0=qEB5=44=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0B8CC10F25
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Mar 2020 05:22:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ADA5A2146E
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Mar 2020 05:22:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726000AbgCKFWK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 11 Mar 2020 01:22:10 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:37277 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725958AbgCKFWK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Mar 2020 01:22:10 -0400
Received: from dread.disaster.area (pa49-195-202-68.pa.nsw.optusnet.com.au [49.195.202.68])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 892067E9CCE;
        Wed, 11 Mar 2020 16:22:06 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jBtoj-000747-8U; Wed, 11 Mar 2020 16:22:05 +1100
Date:   Wed, 11 Mar 2020 16:22:05 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: fix xfs_rmap_has_other_keys usage of ECANCELED
Message-ID: <20200311052205.GT10776@dread.disaster.area>
References: <158388761806.939081.5340701470247161779.stgit@magnolia>
 <158388763048.939081.7269460615856522299.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158388763048.939081.7269460615856522299.stgit@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=mqTaRPt+QsUAtUurwE173Q==:117 a=mqTaRPt+QsUAtUurwE173Q==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=SS2py6AdgQ4A:10
        a=yPCof4ZbAAAA:8 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=PiSsWIYISQ-kgOQ1NAUA:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 10, 2020 at 05:47:10PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> In e7ee96dfb8c26, we converted all ITER_ABORT users to use ECANCELED
> instead, but we forgot to teach xfs_rmap_has_other_keys not to return
> that magic value to callers.  Fix it now.
> 
> Fixes: e7ee96dfb8c26 ("xfs: remove all *_ITER_ABORT values")
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

/me had to go look at that commit to see what this was fixing.

> ---
>  fs/xfs/libxfs/xfs_rmap.c |   13 ++++++-------
>  1 file changed, 6 insertions(+), 7 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
> index ff9412f113c4..dae1a2bf28eb 100644
> --- a/fs/xfs/libxfs/xfs_rmap.c
> +++ b/fs/xfs/libxfs/xfs_rmap.c
> @@ -2694,7 +2694,6 @@ struct xfs_rmap_key_state {
>  	uint64_t			owner;
>  	uint64_t			offset;
>  	unsigned int			flags;
> -	bool				has_rmap;
>  };
>  
>  /* For each rmap given, figure out if it doesn't match the key we want. */
> @@ -2709,7 +2708,6 @@ xfs_rmap_has_other_keys_helper(
>  	if (rks->owner == rec->rm_owner && rks->offset == rec->rm_offset &&
>  	    ((rks->flags & rec->rm_flags) & XFS_RMAP_KEY_FLAGS) == rks->flags)
>  		return 0;
> -	rks->has_rmap = true;
>  	return -ECANCELED;
>  }
>  
> @@ -2731,7 +2729,7 @@ xfs_rmap_has_other_keys(
>  	int				error;
>  
>  	xfs_owner_info_unpack(oinfo, &rks.owner, &rks.offset, &rks.flags);
> -	rks.has_rmap = false;
> +	*has_rmap = false;
>  
>  	low.rm_startblock = bno;
>  	memset(&high, 0xFF, sizeof(high));
> @@ -2739,11 +2737,12 @@ xfs_rmap_has_other_keys(
>  
>  	error = xfs_rmap_query_range(cur, &low, &high,
>  			xfs_rmap_has_other_keys_helper, &rks);
> -	if (error < 0)
> -		return error;
> +	if (error == -ECANCELED) {
> +		*has_rmap = true;
> +		return 0;
> +	}
>  
> -	*has_rmap = rks.has_rmap;
> -	return 0;
> +	return error;
>  }

Ok, so there's two things here. The first is catching ECANCELED and
returning the correct value(0). The second is we no longer need the
rks.has_rmap member to be passed to the helper, because -ECANCELED
indicates that we found an rmap.

Ok, makes sense.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
