Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D3DAC433FE
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Mar 2022 01:43:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232760AbiCDBo1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Mar 2022 20:44:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232050AbiCDBo1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Mar 2022 20:44:27 -0500
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 708034A927
        for <linux-xfs@vger.kernel.org>; Thu,  3 Mar 2022 17:43:40 -0800 (PST)
Received: from dread.disaster.area (pa49-186-17-0.pa.vic.optusnet.com.au [49.186.17.0])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 5C058530068;
        Fri,  4 Mar 2022 12:43:39 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nPwyo-001F0F-N4; Fri, 04 Mar 2022 12:43:38 +1100
Date:   Fri, 4 Mar 2022 12:43:38 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     linux-xfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH V7 04/17] xfs: Introduce xfs_dfork_nextents() helper
Message-ID: <20220304014338.GB59715@dread.disaster.area>
References: <20220301103938.1106808-1-chandan.babu@oracle.com>
 <20220301103938.1106808-5-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220301103938.1106808-5-chandan.babu@oracle.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=62216ecb
        a=+dVDrTVfsjPpH/ci3UuFng==:117 a=+dVDrTVfsjPpH/ci3UuFng==:17
        a=kj9zAlcOel0A:10 a=o8Y5sQTvuykA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
        a=7-415B0cAAAA:8 a=ER_wDJRHJH0WWCmry_oA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 01, 2022 at 04:09:25PM +0530, Chandan Babu R wrote:
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
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_format.h     |  4 ----
>  fs/xfs/libxfs/xfs_inode_buf.c  | 16 +++++++++++-----
>  fs/xfs/libxfs/xfs_inode_fork.c | 10 ++++++----
>  fs/xfs/libxfs/xfs_inode_fork.h | 32 ++++++++++++++++++++++++++++++++
>  fs/xfs/scrub/inode.c           | 18 ++++++++++--------
>  5 files changed, 59 insertions(+), 21 deletions(-)

Mostly good - a few consistency nits below.

> 
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index d75e5b16da7e..e5654b578ec0 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -925,10 +925,6 @@ enum xfs_dinode_fmt {
>  	((w) == XFS_DATA_FORK ? \
>  		(dip)->di_format : \
>  		(dip)->di_aformat)
> -#define XFS_DFORK_NEXTENTS(dip,w) \
> -	((w) == XFS_DATA_FORK ? \
> -		be32_to_cpu((dip)->di_nextents) : \
> -		be16_to_cpu((dip)->di_anextents))
>  
>  /*
>   * For block and character special files the 32bit dev_t is stored at the
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index 5c95a5428fc7..860d32816909 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -336,9 +336,11 @@ xfs_dinode_verify_fork(
>  	struct xfs_mount	*mp,
>  	int			whichfork)
>  {
> -	xfs_extnum_t		di_nextents = XFS_DFORK_NEXTENTS(dip, whichfork);
> +	xfs_extnum_t		di_nextents;
>  	xfs_extnum_t		max_extents;
>  
> +	di_nextents = xfs_dfork_nextents(dip, whichfork);

Why separate the declaration and init? We normally move the init
up to the declaration, not demote it like this....

>  	switch (XFS_DFORK_FORMAT(dip, whichfork)) {
>  	case XFS_DINODE_FMT_LOCAL:
>  		/*
> @@ -405,6 +407,8 @@ xfs_dinode_verify(
>  	uint16_t		flags;
>  	uint64_t		flags2;
>  	uint64_t		di_size;
> +	xfs_extnum_t            nextents;
> +	xfs_filblks_t		nblocks;
>  
>  	if (dip->di_magic != cpu_to_be16(XFS_DINODE_MAGIC))
>  		return __this_address;
> @@ -435,10 +439,12 @@ xfs_dinode_verify(
>  	if ((S_ISLNK(mode) || S_ISDIR(mode)) && di_size == 0)
>  		return __this_address;
>  
> +	nextents = xfs_dfork_data_extents(dip);
> +	nextents += xfs_dfork_attr_extents(dip);
> +	nblocks = be64_to_cpu(dip->di_nblocks);
> +
>  	/* Fork checks carried over from xfs_iformat_fork */
> -	if (mode &&
> -	    be32_to_cpu(dip->di_nextents) + be16_to_cpu(dip->di_anextents) >
> -			be64_to_cpu(dip->di_nblocks))
> +	if (mode && nextents > nblocks)
>  		return __this_address;

The naextents count is needed later in this function. Rather than
calculate it twice, I find the code reads a lot better if it is
structured like this:

	nextents = xfs_dfork_data_extents(dip);
	naextents = xfs_dfork_attr_extents(dip);
	nblocks = be64_to_cpu(dip->di_nblocks);

	if (mode && nextents + naextents > nblocks)
		return __this_address;
	.....

>  
>  	if (mode && XFS_DFORK_BOFF(dip) > mp->m_sb.sb_inodesize)
> @@ -495,7 +501,7 @@ xfs_dinode_verify(
>  		default:
>  			return __this_address;
>  		}
> -		if (dip->di_anextents)
> +		if (xfs_dfork_attr_extents(dip))
>  			return __this_address;
>  	}

And then just check naextents here, too?

> diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
> index a17c4d87520a..829739e249b6 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.c
> +++ b/fs/xfs/libxfs/xfs_inode_fork.c
> @@ -105,7 +105,7 @@ xfs_iformat_extents(
>  	struct xfs_mount	*mp = ip->i_mount;
>  	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
>  	int			state = xfs_bmap_fork_to_state(whichfork);
> -	xfs_extnum_t		nex = XFS_DFORK_NEXTENTS(dip, whichfork);
> +	xfs_extnum_t		nex = xfs_dfork_nextents(dip, whichfork);

I'll point out declaration with init as I mentioned earlier...

>  	int			size = nex * sizeof(xfs_bmbt_rec_t);
>  	struct xfs_iext_cursor	icur;
>  	struct xfs_bmbt_rec	*dp;
> @@ -230,7 +230,7 @@ xfs_iformat_data_fork(
>  	 * depend on it.
>  	 */
>  	ip->i_df.if_format = dip->di_format;
> -	ip->i_df.if_nextents = be32_to_cpu(dip->di_nextents);
> +	ip->i_df.if_nextents = xfs_dfork_data_extents(dip);
>  
>  	switch (inode->i_mode & S_IFMT) {
>  	case S_IFIFO:
> @@ -295,14 +295,16 @@ xfs_iformat_attr_fork(
>  	struct xfs_inode	*ip,
>  	struct xfs_dinode	*dip)
>  {
> +	xfs_extnum_t		naextents;
>  	int			error = 0;
>  
> +	naextents = xfs_dfork_attr_extents(dip);
> +

.... and point it out again because otherwise this looks
inconsistent.

>  struct xfs_ifork *xfs_iext_state_to_fork(struct xfs_inode *ip, int state);
> diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
> index 87925761e174..edad5307e430 100644
> --- a/fs/xfs/scrub/inode.c
> +++ b/fs/xfs/scrub/inode.c
> @@ -233,6 +233,7 @@ xchk_dinode(
>  	unsigned long long	isize;
>  	uint64_t		flags2;
>  	xfs_extnum_t		nextents;
> +	xfs_extnum_t		naextents;
>  	prid_t			prid;
>  	uint16_t		flags;
>  	uint16_t		mode;
> @@ -391,7 +392,7 @@ xchk_dinode(
>  	xchk_inode_extsize(sc, dip, ino, mode, flags);
>  
>  	/* di_nextents */
> -	nextents = be32_to_cpu(dip->di_nextents);
> +	nextents = xfs_dfork_data_extents(dip);
>  	fork_recs =  XFS_DFORK_DSIZE(dip, mp) / sizeof(struct xfs_bmbt_rec);
>  	switch (dip->di_format) {
>  	case XFS_DINODE_FMT_EXTENTS:
> @@ -408,10 +409,12 @@ xchk_dinode(
>  		break;
>  	}
>  
> +	naextents = xfs_dfork_attr_extents(dip);

Initialise the two extent counts in the same place - they are both
first used only a handful of lines apart.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
