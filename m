Return-Path: <SRS0=OEwr=77=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68159C433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Jun 2020 22:58:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4768A2078D
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Jun 2020 22:58:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727037AbgFRW6f (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Jun 2020 18:58:35 -0400
Received: from [211.29.132.246] ([211.29.132.246]:38120 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-FAIL-FAIL-OK-OK)
        by vger.kernel.org with ESMTP id S1726282AbgFRW6f (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Jun 2020 18:58:35 -0400
Received: from dread.disaster.area (unknown [49.180.124.177])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 92BA3822725;
        Fri, 19 Jun 2020 08:58:13 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jm3U2-00015D-Mt; Fri, 19 Jun 2020 08:58:10 +1000
Date:   Fri, 19 Jun 2020 08:58:10 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Waiman Long <longman@redhat.com>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Qian Cai <cai@lca.pw>, Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH v4] xfs: Fix false positive lockdep warning with
 sb_internal & fs_reclaim
Message-ID: <20200618225810.GJ2005@dread.disaster.area>
References: <20200618171941.9475-1-longman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200618171941.9475-1-longman@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=QIgWuTDL c=1 sm=1 tr=0
        a=k3aV/LVJup6ZGWgigO6cSA==:117 a=k3aV/LVJup6ZGWgigO6cSA==:17
        a=kj9zAlcOel0A:10 a=nTHF0DUjJn0A:10 a=7-415B0cAAAA:8
        a=ZdpVamzyzpo1vji6fVUA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 18, 2020 at 01:19:41PM -0400, Waiman Long wrote:
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 379cbff438bc..1b94b9bfa4d7 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -913,11 +913,33 @@ xfs_fs_freeze(
>  	struct super_block	*sb)
>  {
>  	struct xfs_mount	*mp = XFS_M(sb);
> +	unsigned long		pflags;
> +	int			ret;
>  
> +	/*
> +	 * A fs_reclaim pseudo lock is added to check for potential deadlock
> +	 * condition with fs reclaim. The following lockdep splat was hit
> +	 * occasionally. This is actually a false positive as the allocation
> +	 * is being done only after the frozen filesystem is no longer dirty.
> +	 * One way to avoid this splat is to add GFP_NOFS to the affected
> +	 * allocation calls. This is what PF_MEMALLOC_NOFS is for.
> +	 *
> +	 *       CPU0                    CPU1
> +	 *       ----                    ----
> +	 *  lock(sb_internal);
> +	 *                               lock(fs_reclaim);
> +	 *                               lock(sb_internal);
> +	 *  lock(fs_reclaim);
> +	 *
> +	 *  *** DEADLOCK ***
> +	 */

The lockdep splat is detailed in the commit message - it most
definitely does not need to be repeated in full here because:

	a) it doesn't explain why the splat occurring is, and
	b) we most definitely don't care about how the lockdep check
	   that triggered it is implemented.

IOWs, the comment here needs to explain how the freeze state held at
this point requires that we avoid reclaim recursion back into the
filesystem, regardless of how lockdep detects it or whether the
lockdep splats are a false positive or not...

e.g.

/*
 * The superblock is now in the frozen state, which means we cannot
 * allow memory allocation to recurse into reclaim on this
 * filesystem as this may require running operations that the
 * current freeze state prevents. This should not occur if
 * everything is working correctly and sometimes lockdep may report
 * false positives in this path. However, to be safe and to avoid
 * unnecessary false positives in test/CI environments, put the
 * entire final freeze processing path under GFP_NOFS allocation
 * contexts to prevent reclaim recursion from occurring anywhere in
 * the path.
 */

Cheers,

Dave.

> +	current_set_flags_nested(&pflags, PF_MEMALLOC_NOFS);
>  	xfs_stop_block_reaping(mp);
>  	xfs_save_resvblks(mp);
>  	xfs_quiesce_attr(mp);
> -	return xfs_sync_sb(mp, true);
> +	ret = xfs_sync_sb(mp, true);
> +	current_restore_flags_nested(&pflags, PF_MEMALLOC_NOFS);
> +	return ret;
>  }
>  
>  STATIC int
> -- 
> 2.18.1
> 
> 

-- 
Dave Chinner
david@fromorbit.com
