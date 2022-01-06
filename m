Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BDFEC433EF
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Jan 2022 01:41:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344424AbiAFBlS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 5 Jan 2022 20:41:18 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:49404 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344426AbiAFBlS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Jan 2022 20:41:18 -0500
Received: from dread.disaster.area (pa49-181-243-119.pa.nsw.optusnet.com.au [49.181.243.119])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id EA43B62C1A1;
        Thu,  6 Jan 2022 12:41:15 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1n5HmF-00Bqw9-7j; Thu, 06 Jan 2022 12:41:15 +1100
Date:   Thu, 6 Jan 2022 12:41:15 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: warn about inodes with project id of -1
Message-ID: <20220106014115.GR945095@dread.disaster.area>
References: <20220104234325.GJ31583@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220104234325.GJ31583@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=61d648bc
        a=BEa52nrBdFykVEm6RU8P4g==:117 a=BEa52nrBdFykVEm6RU8P4g==:17
        a=kj9zAlcOel0A:10 a=DghFqjY3_ZEA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=1ryReVEzsjzeZqE36DsA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jan 04, 2022 at 03:43:25PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Inodes aren't supposed to have a project id of -1U (aka 4294967295) but
> the kernel hasn't always validated FSSETXATTR correctly.  Flag this as
> something for the sysadmin to check out.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/scrub/inode.c |   14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
> index 2405b09d03d0..eac15af7b08c 100644
> --- a/fs/xfs/scrub/inode.c
> +++ b/fs/xfs/scrub/inode.c
> @@ -233,6 +233,7 @@ xchk_dinode(
>  	unsigned long long	isize;
>  	uint64_t		flags2;
>  	uint32_t		nextents;
> +	prid_t			prid;
>  	uint16_t		flags;
>  	uint16_t		mode;
>  
> @@ -267,6 +268,7 @@ xchk_dinode(
>  		 * so just mark this inode for preening.
>  		 */
>  		xchk_ino_set_preen(sc, ino);
> +		prid = 0;
>  		break;
>  	case 2:
>  	case 3:
> @@ -279,12 +281,17 @@ xchk_dinode(
>  		if (dip->di_projid_hi != 0 &&
>  		    !xfs_has_projid32(mp))
>  			xchk_ino_set_corrupt(sc, ino);
> +
> +		prid = be16_to_cpu(dip->di_projid_lo);
>  		break;
>  	default:
>  		xchk_ino_set_corrupt(sc, ino);
>  		return;
>  	}
>  
> +	if (xfs_has_projid32(mp))
> +		prid |= (prid_t)be16_to_cpu(dip->di_projid_hi) << 16;
> +
>  	/*
>  	 * di_uid/di_gid -- -1 isn't invalid, but there's no way that
>  	 * userspace could have created that.
> @@ -293,6 +300,13 @@ xchk_dinode(
>  	    dip->di_gid == cpu_to_be32(-1U))
>  		xchk_ino_set_warning(sc, ino);
>  
> +	/*
> +	 * project id of -1 isn't supposed to be valid, but the kernel didn't
> +	 * always validate that.
> +	 */
> +	if (prid == -1U)
> +		xchk_ino_set_warning(sc, ino);
> +
>  	/* di_format */
>  	switch (dip->di_format) {
>  	case XFS_DINODE_FMT_DEV:

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
