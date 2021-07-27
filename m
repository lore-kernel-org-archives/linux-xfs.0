Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EC90C4338F
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 23:11:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 34E5260F9B
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 23:11:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232556AbhG0XLp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Jul 2021 19:11:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:56492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232198AbhG0XLo (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 27 Jul 2021 19:11:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 10E0C60249;
        Tue, 27 Jul 2021 23:11:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627427504;
        bh=S/MjT7vZ7TfIoaq2Nm0rZHsC6YCErDs+A7t51vHT4Cw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JozsGill3K8tEHt7flzS3VBN3aLDhcTNEje4sPINjlwWFnhlmRxIuTBXCy7e/TGIS
         zSwVZ9DcL2da086LoE5IbvvYxlgX3CkFpqkkgp4DGuDntqDQbDVEjMhEdga2r/CM7L
         8gth9F5SxGFyxUeXKEP7hoEyWNPShtyOeiv5ex0iGchynugVcdJZQs3JeCeRPr0+y5
         i8ci/RGXM5HsYyPNaJdtWviZYqI0LvAUbOg/6e+5JMG+Q5Ptwp1Zgt8SNPVEkdmIZp
         X1A/oGRNbLny+zZRSxwNeKpDocUryY7WxrsVoBAyesXIE/uL7Qiu3agngD60/UEowt
         FjKswsykmfp1A==
Date:   Tue, 27 Jul 2021 16:11:43 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH V2 04/12] xfsprogs: Use xfs_extnum_t instead of basic
 data types
Message-ID: <20210727231143.GW559212@magnolia>
References: <20210726114724.24956-1-chandanrlinux@gmail.com>
 <20210726114724.24956-5-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210726114724.24956-5-chandanrlinux@gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jul 26, 2021 at 05:17:16PM +0530, Chandan Babu R wrote:
> xfs_extnum_t is the type to use to declare variables which have values
> obtained from xfs_dinode->di_[a]nextents. This commit replaces basic
> types (e.g. uint32_t) with xfs_extnum_t for such variables.
> 
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> ---
>  db/bmap.c               | 2 +-
>  db/frag.c               | 2 +-

For the db and repair parts,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

>  libxfs/xfs_bmap.c       | 2 +-
>  libxfs/xfs_inode_buf.c  | 2 +-
>  libxfs/xfs_inode_fork.c | 2 +-
>  repair/dinode.c         | 2 +-
>  6 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/db/bmap.c b/db/bmap.c
> index 5f81d2b52..50f0474bc 100644
> --- a/db/bmap.c
> +++ b/db/bmap.c
> @@ -47,7 +47,7 @@ bmap(
>  	int			n;
>  	int			nex;
>  	xfs_fsblock_t		nextbno;
> -	int			nextents;
> +	xfs_extnum_t		nextents;
>  	xfs_bmbt_ptr_t		*pp;
>  	xfs_bmdr_block_t	*rblock;
>  	typnm_t			typ;
> diff --git a/db/frag.c b/db/frag.c
> index 570ad3b74..90fa2131c 100644
> --- a/db/frag.c
> +++ b/db/frag.c
> @@ -273,7 +273,7 @@ process_fork(
>  	int		whichfork)
>  {
>  	extmap_t	*extmap;
> -	int		nex;
> +	xfs_extnum_t	nex;
>  
>  	nex = XFS_DFORK_NEXTENTS(dip, whichfork);
>  	if (!nex)
> diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
> index 608ae5b83..dd60d8105 100644
> --- a/libxfs/xfs_bmap.c
> +++ b/libxfs/xfs_bmap.c
> @@ -46,9 +46,9 @@ xfs_bmap_compute_maxlevels(
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
> diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
> index 056fe252b..b2e8e431a 100644
> --- a/libxfs/xfs_inode_buf.c
> +++ b/libxfs/xfs_inode_buf.c
> @@ -339,7 +339,7 @@ xfs_dinode_verify_fork(
>  	struct xfs_mount	*mp,
>  	int			whichfork)
>  {
> -	uint32_t		di_nextents = XFS_DFORK_NEXTENTS(dip, whichfork);
> +	xfs_extnum_t		di_nextents = XFS_DFORK_NEXTENTS(dip, whichfork);
>  	xfs_extnum_t		max_extents;
>  
>  	switch (XFS_DFORK_FORMAT(dip, whichfork)) {
> diff --git a/libxfs/xfs_inode_fork.c b/libxfs/xfs_inode_fork.c
> index 4cd117382..48afaaeec 100644
> --- a/libxfs/xfs_inode_fork.c
> +++ b/libxfs/xfs_inode_fork.c
> @@ -105,7 +105,7 @@ xfs_iformat_extents(
>  	struct xfs_mount	*mp = ip->i_mount;
>  	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
>  	int			state = xfs_bmap_fork_to_state(whichfork);
> -	int			nex = XFS_DFORK_NEXTENTS(dip, whichfork);
> +	xfs_extnum_t		nex = XFS_DFORK_NEXTENTS(dip, whichfork);
>  	int			size = nex * sizeof(xfs_bmbt_rec_t);
>  	struct xfs_iext_cursor	icur;
>  	struct xfs_bmbt_rec	*dp;
> diff --git a/repair/dinode.c b/repair/dinode.c
> index a0c5be7c3..a034b5e86 100644
> --- a/repair/dinode.c
> +++ b/repair/dinode.c
> @@ -967,7 +967,7 @@ process_exinode(
>  	xfs_bmbt_rec_t		*rp;
>  	xfs_fileoff_t		first_key;
>  	xfs_fileoff_t		last_key;
> -	int32_t			numrecs;
> +	xfs_extnum_t		numrecs;
>  	int			ret;
>  
>  	lino = XFS_AGINO_TO_INO(mp, agno, ino);
> -- 
> 2.30.2
> 
