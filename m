Return-Path: <SRS0=vNgo=5K=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 033F6C1975A
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Mar 2020 05:00:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D57AB20714
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Mar 2020 05:00:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725781AbgCYFAb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Mar 2020 01:00:31 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:48412 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725263AbgCYFAb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Mar 2020 01:00:31 -0400
Received: from dread.disaster.area (pa49-195-202-68.pa.nsw.optusnet.com.au [49.195.202.68])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 5CA367E9594;
        Wed, 25 Mar 2020 16:00:29 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jGy9U-0007UC-Ej; Wed, 25 Mar 2020 16:00:28 +1100
Date:   Wed, 25 Mar 2020 16:00:28 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] xfs: validate the realtime geometry in
 xfs_validate_sb_common
Message-ID: <20200325050028.GG10776@dread.disaster.area>
References: <158510667039.922633.6138311243444001882.stgit@magnolia>
 <158510668306.922633.16796248628127177511.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158510668306.922633.16796248628127177511.stgit@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=mqTaRPt+QsUAtUurwE173Q==:117 a=mqTaRPt+QsUAtUurwE173Q==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=SS2py6AdgQ4A:10
        a=yPCof4ZbAAAA:8 a=7-415B0cAAAA:8 a=gPFyL9hYjUHvsKqw0qQA:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 24, 2020 at 08:24:43PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Validate the geometry of the realtime geometry when we mount the
> filesystem, so that we don't abruptly shut down the filesystem later on.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_sb.c |   35 +++++++++++++++++++++++++++++++++++
>  1 file changed, 35 insertions(+)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> index 2f60fc3c99a0..dee0a1a594dc 100644
> --- a/fs/xfs/libxfs/xfs_sb.c
> +++ b/fs/xfs/libxfs/xfs_sb.c
> @@ -328,6 +328,41 @@ xfs_validate_sb_common(
>  		return -EFSCORRUPTED;
>  	}
>  
> +	/* Validate the realtime geometry; stolen from xfs_repair */
> +	if (unlikely(
> +	    sbp->sb_rextsize * sbp->sb_blocksize > XFS_MAX_RTEXTSIZE	||

Whacky whitespace before the ||

> +	    sbp->sb_rextsize * sbp->sb_blocksize < XFS_MIN_RTEXTSIZE)) {
> +		xfs_notice(mp,
> +			"realtime extent sanity check failed");
> +		return -EFSCORRUPTED;
> +	}

We really don't need unlikely() in code like this. the compiler
already considers code that returns inside an if statement as
"unlikely" because it's the typical error handling pattern, for
cases like this it really isn't necessary.


> +
> +	if (sbp->sb_rblocks == 0) {
> +		if (unlikely(
> +		    sbp->sb_rextents != 0				||
> +		    sbp->sb_rbmblocks != 0				||
> +		    sbp->sb_rextslog != 0				||
> +		    sbp->sb_frextents != 0)) {

Ditto on the unlikely and the whitespace. That code looks weird...

		if (sbp->sb_rextents || sbp->sb_rbmblocks ||
		    sbp->sb_rextslog || sbp->sb_frextents) {

> +			xfs_notice(mp,
> +				"realtime zeroed geometry sanity check failed");
> +			return -EFSCORRUPTED;
> +		}
> +	} else {
> +		xfs_rtblock_t	rexts;
> +		uint32_t	temp;
> +
> +		rexts = div_u64_rem(sbp->sb_rblocks, sbp->sb_rextsize, &temp);
> +		if (unlikely(
> +		    rexts != sbp->sb_rextents				||
> +		    sbp->sb_rextslog != xfs_highbit32(sbp->sb_rextents)	||

And again.

At least you're consistent, Darrick :)

-Dave.
-- 
Dave Chinner
david@fromorbit.com
