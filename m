Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8A08C07E95
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Jul 2021 00:59:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8DF476135A
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Jul 2021 00:59:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237198AbhGNBBy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 13 Jul 2021 21:01:54 -0400
Received: from mail109.syd.optusnet.com.au ([211.29.132.80]:44805 "EHLO
        mail109.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237180AbhGNBBy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Jul 2021 21:01:54 -0400
Received: from dread.disaster.area (pa49-181-34-10.pa.nsw.optusnet.com.au [49.181.34.10])
        by mail109.syd.optusnet.com.au (Postfix) with ESMTPS id 762C26ABB5;
        Wed, 14 Jul 2021 10:58:51 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1m3TEg-006G60-Ce; Wed, 14 Jul 2021 10:58:50 +1000
Date:   Wed, 14 Jul 2021 10:58:50 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: improve FSGROWFSRT precondition checking
Message-ID: <20210714005850.GT664593@dread.disaster.area>
References: <162612763990.39052.10884597587360249026.stgit@magnolia>
 <162612764549.39052.13778481530353608889.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162612764549.39052.13778481530353608889.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
        a=hdaoRb6WoHYrV466vVKEyw==:117 a=hdaoRb6WoHYrV466vVKEyw==:17
        a=kj9zAlcOel0A:10 a=e_q4qTt1xDgA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=t2M7dM56xeUjvFoTyQwA:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jul 12, 2021 at 03:07:25PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Improve the checking at the start of a realtime grow operation so that
> we avoid accidentally set a new extent size that is too large and avoid
> adding an rt volume to a filesystem with rmap or reflink because we
> don't support rt rmap or reflink yet.
> 
> While we're at it, separate the checks so that we're only testing one
> aspect at a time.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_rtalloc.c |   20 ++++++++++++++++----
>  1 file changed, 16 insertions(+), 4 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> index 4e7be6b4ca8e..8920bce4fb0a 100644
> --- a/fs/xfs/xfs_rtalloc.c
> +++ b/fs/xfs/xfs_rtalloc.c
> @@ -928,11 +928,23 @@ xfs_growfs_rt(
>  	 */
>  	if (!capable(CAP_SYS_ADMIN))
>  		return -EPERM;
> -	if (mp->m_rtdev_targp == NULL || mp->m_rbmip == NULL ||
> -	    (nrblocks = in->newblocks) <= sbp->sb_rblocks ||
> -	    (sbp->sb_rblocks && (in->extsize != sbp->sb_rextsize)))
> +	if (mp->m_rtdev_targp == NULL || !mp->m_rbmip || !mp->m_rsumip)
>  		return -EINVAL;

Shouldn't this use XFS_IS_REALTIME_MOUNT() so it always fails if
CONFIG_XFS_RT=n?

i.e. if we have to check mp->m_rbmip and mp->m_rsumip to determine
if this mount is realtime enabled, then doesn't
XFS_IS_REALTIME_MOUNT() need to be fixed?


> -	if ((error = xfs_sb_validate_fsb_count(sbp, nrblocks)))
> +	if (in->newblocks <= sbp->sb_rblocks)
> +		return -EINVAL;
> +	if (xfs_sb_version_hasrealtime(&mp->m_sb) &&
> +	    in->extsize != sbp->sb_rextsize)
> +		return -EINVAL;

xfs_sb_version_hasrealtime() checks "sbp->sb_rblocks > 0", it's not
an actual version flag check. I think this makes much more sense
being open coded rather than masquerading as a feature check....

> +	if (XFS_FSB_TO_B(mp, in->extsize) > XFS_MAX_RTEXTSIZE ||
> +	    XFS_FSB_TO_B(mp, in->extsize) < XFS_MIN_RTEXTSIZE)
> +		return -EINVAL;
> +	if (xfs_sb_version_hasrmapbt(&mp->m_sb) ||
> +	    xfs_sb_version_hasreflink(&mp->m_sb))
> +		return -EOPNOTSUPP;
> +
> +	nrblocks = in->newblocks;
> +	error = xfs_sb_validate_fsb_count(sbp, nrblocks);
> +	if (error)
>  		return error;

Otherwise looks like a reasonable set of additional checks.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
