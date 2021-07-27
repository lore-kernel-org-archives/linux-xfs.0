Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BECCC4338F
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 21:59:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4E7E560F57
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 21:59:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231599AbhG0V70 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Jul 2021 17:59:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:49920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231135AbhG0V7Z (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 27 Jul 2021 17:59:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 256DB60D07;
        Tue, 27 Jul 2021 21:59:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627423165;
        bh=3rgs8pwK6nVFsHB/Sd5fAchR0QmIzHbrbs2azyHtxfg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Se/tUapt76DuUMJg6IXo0o+K0jQzTjxNfgYpT9gW1XyMOihOaJaB63pnd2WI3vD3N
         x+1ZF5QTFl25iSeJOgbspuScfhyJ6R3eZyNdtUSONz9XfJZROO3vxg/ZJR3jIfjSW6
         9vcvYqvWA3MPlx15Uqv08olDqv4sDah6wNYIC5/W6XGPfJ3jyuozcpEVfG4GKj5unR
         Q8STB3eneCkT5RJC+z+UFZiwfs748ONFR/XMFrANHmQDYCXe53QkjsRrblLy8HFqKh
         4ydAl/Dm8uXkL4AwGzKNRfvrVs1Ao92qLvk8wfnmXi9RBjhhX9ect9r5iuAYOXuS2o
         7fzr/5qTfTl3A==
Date:   Tue, 27 Jul 2021 14:59:24 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH V2 04/12] xfs: Use xfs_extnum_t instead of basic data
 types
Message-ID: <20210727215924.GM559212@magnolia>
References: <20210726114541.24898-1-chandanrlinux@gmail.com>
 <20210726114541.24898-5-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210726114541.24898-5-chandanrlinux@gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jul 26, 2021 at 05:15:33PM +0530, Chandan Babu R wrote:
> xfs_extnum_t is the type to use to declare variables which have values
> obtained from xfs_dinode->di_[a]nextents. This commit replaces basic
> types (e.g. uint32_t) with xfs_extnum_t for such variables.
> 
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>

Not sure why the structure members change places, but otherwise LGTM.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D


> ---
>  fs/xfs/libxfs/xfs_bmap.c       | 2 +-
>  fs/xfs/libxfs/xfs_inode_buf.c  | 2 +-
>  fs/xfs/libxfs/xfs_inode_fork.c | 2 +-
>  fs/xfs/scrub/inode.c           | 2 +-
>  fs/xfs/scrub/inode_repair.c    | 2 +-
>  fs/xfs/xfs_trace.h             | 2 +-
>  6 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 282aeb3c0e49..e5d243fd187d 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -53,9 +53,9 @@ xfs_bmap_compute_maxlevels(
>  	xfs_mount_t	*mp,		/* file system mount structure */
>  	int		whichfork)	/* data or attr fork */
>  {
> +	xfs_extnum_t	maxleafents;	/* max leaf entries possible */
>  	int		level;		/* btree level */
>  	uint		maxblocks;	/* max blocks at this level */
> -	uint		maxleafents;	/* max leaf entries possible */
>  	int		maxrootrecs;	/* max records in root block */
>  	int		minleafrecs;	/* min records in leaf block */
>  	int		minnoderecs;	/* min records in node block */
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index 419b92dc6ac8..cba9a38f3270 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -342,7 +342,7 @@ xfs_dinode_verify_fork(
>  	struct xfs_mount	*mp,
>  	int			whichfork)
>  {
> -	uint32_t		di_nextents = XFS_DFORK_NEXTENTS(dip, whichfork);
> +	xfs_extnum_t		di_nextents = XFS_DFORK_NEXTENTS(dip, whichfork);
>  	xfs_extnum_t		max_extents;
>  
>  	switch (XFS_DFORK_FORMAT(dip, whichfork)) {
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
> index c6856ec95335..a1e40df585a3 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.c
> +++ b/fs/xfs/libxfs/xfs_inode_fork.c
> @@ -107,7 +107,7 @@ xfs_iformat_extents(
>  	struct xfs_mount	*mp = ip->i_mount;
>  	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
>  	int			state = xfs_bmap_fork_to_state(whichfork);
> -	int			nex = XFS_DFORK_NEXTENTS(dip, whichfork);
> +	xfs_extnum_t		nex = XFS_DFORK_NEXTENTS(dip, whichfork);
>  	int			size = nex * sizeof(xfs_bmbt_rec_t);
>  	struct xfs_iext_cursor	icur;
>  	struct xfs_bmbt_rec	*dp;
> diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
> index e6068590484b..246d11ca133f 100644
> --- a/fs/xfs/scrub/inode.c
> +++ b/fs/xfs/scrub/inode.c
> @@ -219,7 +219,7 @@ xchk_dinode(
>  	size_t			fork_recs;
>  	unsigned long long	isize;
>  	uint64_t		flags2;
> -	uint32_t		nextents;
> +	xfs_extnum_t		nextents;
>  	prid_t			prid;
>  	uint16_t		flags;
>  	uint16_t		mode;
> diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
> index a44d7b48c374..042c7d0bc0f5 100644
> --- a/fs/xfs/scrub/inode_repair.c
> +++ b/fs/xfs/scrub/inode_repair.c
> @@ -597,9 +597,9 @@ xrep_dinode_bad_extents_fork(
>  {
>  	struct xfs_bmbt_irec	new;
>  	struct xfs_bmbt_rec	*dp;
> +	xfs_extnum_t		nex;
>  	bool			isrt;
>  	int			i;
> -	int			nex;
>  	int			fork_size;
>  
>  	nex = XFS_DFORK_NEXTENTS(dip, whichfork);
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index affc9b5834fb..5ed11f894f79 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -2338,7 +2338,7 @@ DECLARE_EVENT_CLASS(xfs_swap_extent_class,
>  		__field(int, which)
>  		__field(xfs_ino_t, ino)
>  		__field(int, format)
> -		__field(int, nex)
> +		__field(xfs_extnum_t, nex)
>  		__field(int, broot_size)
>  		__field(int, fork_off)
>  	),
> -- 
> 2.30.2
> 
