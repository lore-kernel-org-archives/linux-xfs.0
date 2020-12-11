Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC6C4C4361B
	for <linux-xfs@archiver.kernel.org>; Fri, 11 Dec 2020 01:19:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B7DE323C18
	for <linux-xfs@archiver.kernel.org>; Fri, 11 Dec 2020 01:19:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394646AbgLKBSu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 10 Dec 2020 20:18:50 -0500
Received: from mail109.syd.optusnet.com.au ([211.29.132.80]:41949 "EHLO
        mail109.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389023AbgLKBS1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Dec 2020 20:18:27 -0500
Received: from dread.disaster.area (pa49-179-6-140.pa.nsw.optusnet.com.au [49.179.6.140])
        by mail109.syd.optusnet.com.au (Postfix) with ESMTPS id AFDEA85E67;
        Fri, 11 Dec 2020 12:17:44 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1knX44-002foD-73; Fri, 11 Dec 2020 12:17:44 +1100
Date:   Fri, 11 Dec 2020 12:17:44 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: silence a cppcheck warning
Message-ID: <20201211011744.GA632069@dread.disaster.area>
References: <20201210235747.469708-1-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201210235747.469708-1-hsiangkao@redhat.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0 cx=a_idp_d
        a=uDU3YIYVKEaHT0eX+MXYOQ==:117 a=uDU3YIYVKEaHT0eX+MXYOQ==:17
        a=kj9zAlcOel0A:10 a=zTNgK-yGK50A:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=vGZH_jae6QtphXMy2M4A:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Dec 11, 2020 at 07:57:47AM +0800, Gao Xiang wrote:
> This patch silences a new cppcheck static analysis warning
> >> fs/xfs/libxfs/xfs_sb.c:367:21: warning: Boolean result is used in bitwise operation. Clarify expression with parentheses. [clarifyCondition]
>     if (!!sbp->sb_unit ^ xfs_sb_version_hasdalign(sbp)) {
> 
> introduced from my patch. Sorry I didn't test it with cppcheck before.
> 
> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>

Title of the patch needs to indicate the fix being made, not
the tool that reported the issue.

So:

xfs: fix logic in sb_unit alignment checks

The cppcheck static analysis checker reported this warning:

>> fs/xfs/libxfs/xfs_sb.c:367:21: warning: Boolean result is used in bitwise operation. Clarify expression with parentheses. [clarifyCondition]
	if (!!sbp->sb_unit ^ xfs_sb_version_hasdalign(sbp)) {

Modify the logic to avoid the warning.

Fixes: xxxx ("yyyy")
SOB:....

> ---
>  fs/xfs/libxfs/xfs_sb.c | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> index bbda117e5d85..ae5df66c2fa0 100644
> --- a/fs/xfs/libxfs/xfs_sb.c
> +++ b/fs/xfs/libxfs/xfs_sb.c
> @@ -360,11 +360,8 @@ xfs_validate_sb_common(
>  		}
>  	}
>  
> -	/*
> -	 * Either (sb_unit and !hasdalign) or (!sb_unit and hasdalign)
> -	 * would imply the image is corrupted.
> -	 */
> -	if (!!sbp->sb_unit ^ xfs_sb_version_hasdalign(sbp)) {
> +	if ((sbp->sb_unit && !xfs_sb_version_hasdalign(sbp)) ||
> +	    (!sbp->sb_unit && xfs_sb_version_hasdalign(sbp))) {
>  		xfs_notice(mp, "SB stripe alignment sanity check failed");
>  		return -EFSCORRUPTED;

But, ummm, what's the bug here? THe logic looks correct to me -
!!sbp->sb_unit will have a value of 0 or 1, and
xfs_sb_version_hasdalign() returns a bool so will also have a value
of 0 or 1. That means the bitwise XOR does exactly the correct thing
here as we are operating on two boolean values. So I don't see a bug
here, nor that it's a particularly useful warning.

FWIW, I've never heard of this "cppcheck" analysis tool. Certainly
I've never used it, and this warning seems to be somewhat
questionable so I'm wondering if this is just a new source of random
code churn or whether it's actually finding real bugs?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
