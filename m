Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E247C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 14 Oct 2022 03:56:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229740AbiJND4m (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 13 Oct 2022 23:56:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229657AbiJND4k (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Oct 2022 23:56:40 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 239B61A0C1E
        for <linux-xfs@vger.kernel.org>; Thu, 13 Oct 2022 20:56:36 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-106-210.pa.nsw.optusnet.com.au [49.181.106.210])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id B9BED1101831;
        Fri, 14 Oct 2022 14:56:35 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ojBoI-001jy4-FG; Fri, 14 Oct 2022 14:56:34 +1100
Date:   Fri, 14 Oct 2022 14:56:34 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: online checking of the free rt extent count
Message-ID: <20221014035634.GM3600936@dread.disaster.area>
References: <166473480544.1083794.8963547317476704789.stgit@magnolia>
 <166473480575.1083794.6363015906526063261.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <166473480575.1083794.6363015906526063261.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=6348ddf3
        a=j6JUzzrSC7wlfFge/rmVbg==:117 a=j6JUzzrSC7wlfFge/rmVbg==:17
        a=kj9zAlcOel0A:10 a=Qawa6l4ZSaYA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=GYjIJaPcl1TlHDYP5m8A:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Oct 02, 2022 at 11:20:05AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Teach the summary count checker to count the number of free realtime
> extents and compare that to the superblock copy.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/scrub/fscounters.c |   86 ++++++++++++++++++++++++++++++++++++++++++++-
>  fs/xfs/scrub/scrub.h      |    8 ----
>  2 files changed, 84 insertions(+), 10 deletions(-)

.....
> @@ -288,6 +301,59 @@ xchk_fscount_aggregate_agcounts(
>  	return 0;
>  }
>  
> +#ifdef CONFIG_XFS_RT
> +static inline int
> +xchk_fscount_add_frextent(
> +	struct xfs_mount		*mp,
> +	struct xfs_trans		*tp,
> +	const struct xfs_rtalloc_rec	*rec,
> +	void				*priv)

This is a callback function, so it shouldn't be declared as
"inline"....

With that fixed,

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
