Return-Path: <SRS0=maQ1=AO=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4547FC433DF
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Jul 2020 01:07:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1E08B20781
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Jul 2020 01:07:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726032AbgGCBHZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 2 Jul 2020 21:07:25 -0400
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:52253 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725915AbgGCBHZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Jul 2020 21:07:25 -0400
Received: from dread.disaster.area (pa49-180-53-24.pa.nsw.optusnet.com.au [49.180.53.24])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id 3DA22D59879;
        Fri,  3 Jul 2020 11:07:21 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jrAAi-0001mh-CL; Fri, 03 Jul 2020 11:07:20 +1000
Date:   Fri, 3 Jul 2020 11:07:20 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Waiman Long <longman@redhat.com>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Qian Cai <cai@lca.pw>, Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH v5] xfs: Fix false positive lockdep warning with
 sb_internal & fs_reclaim
Message-ID: <20200703010720.GH5369@dread.disaster.area>
References: <20200702005923.10064-1-longman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200702005923.10064-1-longman@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=moVtWZxmCkf3aAMJKIb/8g==:117 a=moVtWZxmCkf3aAMJKIb/8g==:17
        a=kj9zAlcOel0A:10 a=_RQrkK6FrEwA:10 a=7-415B0cAAAA:8 a=20KFwNOVAAAA:8
        a=DRpurTtVrwkqR7YIFl8A:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 01, 2020 at 08:59:23PM -0400, Waiman Long wrote:
> Suggested-by: Dave Chinner <david@fromorbit.com>
> Signed-off-by: Waiman Long <longman@redhat.com>
> ---
>  fs/xfs/xfs_super.c | 12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 379cbff438bc..dcc97bad950a 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -913,11 +913,21 @@ xfs_fs_freeze(
>  	struct super_block	*sb)
>  {
>  	struct xfs_mount	*mp = XFS_M(sb);
> +	unsigned long		pflags;
> +	int			ret;
>  
> +	/*
> +	 * Disable fs reclaim in memory allocation for fs freeze to avoid
> +	 * causing a possible circular locking dependency lockdep splat
> +	 * relating to fs reclaim.
> +	 */

	/*
	 * The filesystem is now frozen far enough that memory reclaim
	 * cannot safely operate on the filesystem. Hence we need to
	 * set a GFP_NOFS context here to avoid recursion deadlocks.
	 */

> +	current_set_flags_nested(&pflags, PF_MEMALLOC_NOFS);

memalloc_nofs_save/restore(), please.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
