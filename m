Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 787C3C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Sep 2021 01:19:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 56A4561381
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Sep 2021 01:19:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230070AbhI3BVH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Sep 2021 21:21:07 -0400
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:38512 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229477AbhI3BVG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Sep 2021 21:21:06 -0400
Received: from dread.disaster.area (pa49-195-238-16.pa.nsw.optusnet.com.au [49.195.238.16])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id 37EDDAA9D;
        Thu, 30 Sep 2021 11:19:23 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mVkjK-000g0T-A0; Thu, 30 Sep 2021 11:19:22 +1000
Date:   Thu, 30 Sep 2021 11:19:22 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     linux-xfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH V3 06/12] xfs: xfs_dfork_nextents: Return extent count
 via an out argument
Message-ID: <20210930011922.GN2361455@dread.disaster.area>
References: <20210916100647.176018-1-chandan.babu@oracle.com>
 <20210916100647.176018-7-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210916100647.176018-7-chandan.babu@oracle.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=6155109b
        a=DzKKRZjfViQTE5W6EVc0VA==:117 a=DzKKRZjfViQTE5W6EVc0VA==:17
        a=kj9zAlcOel0A:10 a=7QKq2e-ADPsA:10 a=yPCof4ZbAAAA:8 a=7-415B0cAAAA:8
        a=GgJH210hQ0jFwe1QOuYA:9 a=M0C-vMso4fN1-_c1:21 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 16, 2021 at 03:36:41PM +0530, Chandan Babu R wrote:
> This commit changes xfs_dfork_nextents() to return an error code. The extent
> count itself is now returned through an out argument. This facility will be
> used by a future commit to indicate an inconsistent ondisk extent count.
> 
> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_format.h     | 14 ++---
>  fs/xfs/libxfs/xfs_inode_buf.c  | 16 ++++--
>  fs/xfs/libxfs/xfs_inode_fork.c | 21 ++++++--
>  fs/xfs/scrub/inode.c           | 94 +++++++++++++++++++++-------------
>  fs/xfs/scrub/inode_repair.c    | 34 ++++++++----
>  5 files changed, 118 insertions(+), 61 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index b4638052801f..dba868f2c3e3 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -931,28 +931,30 @@ enum xfs_dinode_fmt {
>  		(dip)->di_format : \
>  		(dip)->di_aformat)
>  
> -static inline xfs_extnum_t
> +static inline int
>  xfs_dfork_nextents(
>  	struct xfs_dinode	*dip,
> -	int			whichfork)
> +	int			whichfork,
> +	xfs_extnum_t		*nextents)
>  {
> -	xfs_extnum_t		nextents = 0;
> +	int			error = 0;
>  
>  	switch (whichfork) {
>  	case XFS_DATA_FORK:
> -		nextents = be32_to_cpu(dip->di_nextents);
> +		*nextents = be32_to_cpu(dip->di_nextents);
>  		break;
>  
>  	case XFS_ATTR_FORK:
> -		nextents = be16_to_cpu(dip->di_anextents);
> +		*nextents = be16_to_cpu(dip->di_anextents);
>  		break;
>  
>  	default:
>  		ASSERT(0);
> +		error = -EFSCORRUPTED;
>  		break;
>  	}
>  
> -	return nextents;
> +	return error;
>  }

So why do we need to do this? AFAICT, the only check that can return
errors that is added by the ned of the patch series is a
on-disk-format check that does:

	if (inode_has_nrext64 && dip->di_nextents16 != 0)
		return -EFSCORRUPTED;

This doesn't belong here - it is conflating verification with
extraction. Verfication of the on-disk format belongs in the
verifiers or verification code, not in the function that extracts

>  /*
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index 176c98798aa4..dc511630cc7a 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -345,7 +345,8 @@ xfs_dinode_verify_fork(
>  	xfs_extnum_t		di_nextents;
>  	xfs_extnum_t		max_extents;
>  
> -	di_nextents = xfs_dfork_nextents(dip, whichfork);
> +	if (xfs_dfork_nextents(dip, whichfork, &di_nextents))
> +		return __this_address;
>  
>  	switch (XFS_DFORK_FORMAT(dip, whichfork)) {
>  	case XFS_DINODE_FMT_LOCAL:
> @@ -477,6 +478,7 @@ xfs_dinode_verify(
>  	uint64_t		flags2;
>  	uint64_t		di_size;
>  	xfs_extnum_t            nextents;
> +	xfs_extnum_t            naextents;
>  	xfs_rfsblock_t		nblocks;
>  
>  	if (dip->di_magic != cpu_to_be16(XFS_DINODE_MAGIC))
> @@ -508,8 +510,13 @@ xfs_dinode_verify(
>  	if ((S_ISLNK(mode) || S_ISDIR(mode)) && di_size == 0)
>  		return __this_address;
>  
> -	nextents = xfs_dfork_nextents(dip, XFS_DATA_FORK);
> -	nextents += xfs_dfork_nextents(dip, XFS_ATTR_FORK);
> +	if (xfs_dfork_nextents(dip, XFS_DATA_FORK, &nextents))
> +		return __this_address;
> +
> +	if (xfs_dfork_nextents(dip, XFS_ATTR_FORK, &naextents))
> +		return __this_address;

Yeah, so this should end up being:

xfs_failaddr_t
xfs_dfork_nextents_verify(
	... )
{
	if (ip->di_flags2 & NREXT64) {
		if (!xfs_has_nrext64(mp))
			return __this_address;
		if (dip->di_nextents16 != 0)
			return __this_address;
	} else if (dip->di_nextents64 != 0)
		return __this_address;
	}
	return NULL;
}

and
	faddr = xfs_dfork_nextents_verify(dip, mp);
	if (faddr)
		return faddr;
	nextents = xfs_dfork_nextents(dip, XFS_DATA_FORK);
	naextents = xfs_dfork_nextents(dip, XFS_ATTR_FORK);

Now all the verification can be removed from xfs_dfork_nextents(),
and anything that needs to verify that the extent counts are in a
valid format can call xfs_dfork_nextents_verify() to perform this
check (i.e. the dinode verifiers and scrub checking code).

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
