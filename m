Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDBF5C433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Sep 2021 22:46:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A8336103B
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Sep 2021 22:46:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237905AbhI0Wsb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 27 Sep 2021 18:48:31 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:39096 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237760AbhI0Wsa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Sep 2021 18:48:30 -0400
Received: from dread.disaster.area (pa49-195-238-16.pa.nsw.optusnet.com.au [49.195.238.16])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id 38B728600A1;
        Tue, 28 Sep 2021 08:46:50 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mUzOb-00HTYb-Ef; Tue, 28 Sep 2021 08:46:49 +1000
Date:   Tue, 28 Sep 2021 08:46:49 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     linux-xfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH V3 05/12] xfs: Introduce xfs_dfork_nextents() helper
Message-ID: <20210927224649.GK1756565@dread.disaster.area>
References: <20210916100647.176018-1-chandan.babu@oracle.com>
 <20210916100647.176018-6-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210916100647.176018-6-chandan.babu@oracle.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
        a=DzKKRZjfViQTE5W6EVc0VA==:117 a=DzKKRZjfViQTE5W6EVc0VA==:17
        a=kj9zAlcOel0A:10 a=7QKq2e-ADPsA:10 a=yPCof4ZbAAAA:8 a=7-415B0cAAAA:8
        a=8JzJ_sS3BQKNUiC2LqsA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 16, 2021 at 03:36:40PM +0530, Chandan Babu R wrote:
> This commit replaces the macro XFS_DFORK_NEXTENTS() with the helper function
> xfs_dfork_nextents(). As of this commit, xfs_dfork_nextents() returns the same
> value as XFS_DFORK_NEXTENTS(). A future commit which extends inode's extent
> counter fields will add more logic to this helper.
> 
> This commit also replaces direct accesses to xfs_dinode->di_[a]nextents
> with calls to xfs_dfork_nextents().
> 
> No functional changes have been made.
> 
> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_format.h     | 28 +++++++++++++++++++++----
>  fs/xfs/libxfs/xfs_inode_buf.c  | 16 +++++++++-----
>  fs/xfs/libxfs/xfs_inode_fork.c | 10 +++++----
>  fs/xfs/scrub/inode.c           | 18 +++++++++-------
>  fs/xfs/scrub/inode_repair.c    | 38 +++++++++++++++++++++-------------
>  5 files changed, 75 insertions(+), 35 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index ed8a5354bcbf..b4638052801f 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -930,10 +930,30 @@ enum xfs_dinode_fmt {
>  	((w) == XFS_DATA_FORK ? \
>  		(dip)->di_format : \
>  		(dip)->di_aformat)
> -#define XFS_DFORK_NEXTENTS(dip,w) \
> -	((w) == XFS_DATA_FORK ? \
> -		be32_to_cpu((dip)->di_nextents) : \
> -		be16_to_cpu((dip)->di_anextents))
> +
> +static inline xfs_extnum_t
> +xfs_dfork_nextents(
> +	struct xfs_dinode	*dip,
> +	int			whichfork)
> +{
> +	xfs_extnum_t		nextents = 0;
> +
> +	switch (whichfork) {
> +	case XFS_DATA_FORK:
> +		nextents = be32_to_cpu(dip->di_nextents);
> +		break;
> +

No need for whitespace line after the break, and this could just
return the value directly.

> +	case XFS_ATTR_FORK:
> +		nextents = be16_to_cpu(dip->di_anextents);
> +		break;
> +
> +	default:
> +		ASSERT(0);
> +		break;
> +	}
> +
> +	return nextents;
> +}

I think that all the conditional inode fork macros
should be moved to libxfs/xfs_inode_fork.h as they are converted.

These macros are not acutally part of the on-disk format definition
(which is what xfs_format.h is supposed to contain) - it's code that
parses the on-disk format and that is supposed to be in
libxfs/xfs_inode_fork.[ch]....

Next thing: the caller almost always knows what fork it wants
the extents for - only 3 callers have a whichfork variable. So,
perhaps:

static inline xfs_extnum_t
xfs_dfork_data_extents(
	struct xfs_dinode	*dip)
{
	return be32_to_cpu(dip->di_nextents);
}

static inline xfs_extnum_t
xfs_dfork_attr_extents(
	struct xfs_dinode	*dip)
{
	return be16_to_cpu(dip->di_anextents);
}

static inline xfs_extnum_t
xfs_dfork_extents(
	struct xfs_dinode	*dip,
	int			whichfork)
{
	switch (whichfork) {
	case XFS_DATA_FORK:
		return xfs_dfork_data_extents(dip);
	case XFS_ATTR_FORK:
		return xfs_dfork_attr_extents(dip);
	default:
		ASSERT(0);
		break;
	}
	return 0;
}

So we don't have to rely on the compiler optimising away the switch
statement correctly to produce optimal code.

> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -342,9 +342,11 @@ xfs_dinode_verify_fork(
>  	struct xfs_mount	*mp,
>  	int			whichfork)
>  {
> -	xfs_extnum_t		di_nextents = XFS_DFORK_NEXTENTS(dip, whichfork);
> +	xfs_extnum_t		di_nextents;
>  	xfs_extnum_t		max_extents;
>  
> +	di_nextents = xfs_dfork_nextents(dip, whichfork);
> +
>  	switch (XFS_DFORK_FORMAT(dip, whichfork)) {
>  	case XFS_DINODE_FMT_LOCAL:
>  		/*
> @@ -474,6 +476,8 @@ xfs_dinode_verify(
>  	uint16_t		flags;
>  	uint64_t		flags2;
>  	uint64_t		di_size;
> +	xfs_extnum_t            nextents;
> +	xfs_rfsblock_t		nblocks;

That's a block number type, not a block count:

typedef uint64_t        xfs_rfsblock_t; /* blockno in filesystem (raw) */
....
typedef uint64_t        xfs_filblks_t;  /* number of blocks in a file */

The latter is the appropriate type to use here.

Oh, the struct xfs_inode and the struct xfs_log_dinode makes
this same type mistake. Ok, that's a cleanup for another day....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
