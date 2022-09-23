Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB6B2C07E9D
	for <linux-xfs@archiver.kernel.org>; Fri, 23 Sep 2022 19:02:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230325AbiIWTCD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 23 Sep 2022 15:02:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbiIWTCD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 23 Sep 2022 15:02:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45A6A11D0C9
        for <linux-xfs@vger.kernel.org>; Fri, 23 Sep 2022 12:02:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CC7EE61EBD
        for <linux-xfs@vger.kernel.org>; Fri, 23 Sep 2022 19:02:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE6C6C433C1;
        Fri, 23 Sep 2022 19:02:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663959720;
        bh=R99tACwUKTfuZSk/oFKPFIbSyBL1Z8SfYZtSVHFsiLA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Q75fLjceDSjo/ujCWFpkcR0ZvJHC4WAo/j3Mpvd9JiEUAPxKTb/DEDBGZJCEOIPjs
         te/+CdSCJxrjfHykMHnYO4IEC1c4fDIIFWTQDjZb61oZ6ehuNq4nTJP/dst3zCzp0M
         sCt/vurHIqnDd/GKizyU02GvXioO8AX+Mx+/Mt7yuHmgBCAoZOiNluiHP5T2k50gfi
         4j6qErKTqGRKkfzEwDck8SVN+Wr9WwyZucF3WMQTmxgVnq0UgA3Lu5QxPv0iTzMeoy
         sbMU8phUmxD5y6qiFVXoNPFmtWib4b+t77GeZ8XDT+1LLzrN/R/z6JwZrFQLgZtXnQ
         F8tXRmrwenRMQ==
Date:   Fri, 23 Sep 2022 12:02:00 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     allison.henderson@oracle.com
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3 02/26] xfs: Increase XFS_DEFER_OPS_NR_INODES to 5
Message-ID: <Yy4CqNJxPitsHvf+@magnolia>
References: <20220922054458.40826-1-allison.henderson@oracle.com>
 <20220922054458.40826-3-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220922054458.40826-3-allison.henderson@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 21, 2022 at 10:44:34PM -0700, allison.henderson@oracle.com wrote:
> From: Allison Henderson <allison.henderson@oracle.com>
> 
> Renames that generate parent pointer updates can join up to 5
> inodes locked in sorted order.  So we need to increase the
> number of defer ops inodes and relock them in the same way.
> 
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_defer.c | 28 ++++++++++++++++++++++++++--
>  fs/xfs/libxfs/xfs_defer.h |  8 +++++++-
>  fs/xfs/xfs_inode.c        |  2 +-
>  fs/xfs/xfs_inode.h        |  1 +
>  4 files changed, 35 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
> index 5a321b783398..c0279b57e51d 100644
> --- a/fs/xfs/libxfs/xfs_defer.c
> +++ b/fs/xfs/libxfs/xfs_defer.c
> @@ -820,13 +820,37 @@ xfs_defer_ops_continue(
>  	struct xfs_trans		*tp,
>  	struct xfs_defer_resources	*dres)
>  {
> -	unsigned int			i;
> +	unsigned int			i, j;
> +	struct xfs_inode		*sips[XFS_DEFER_OPS_NR_INODES];
> +	struct xfs_inode		*temp;
>  
>  	ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
>  	ASSERT(!(tp->t_flags & XFS_TRANS_DIRTY));
>  
>  	/* Lock the captured resources to the new transaction. */
> -	if (dfc->dfc_held.dr_inos == 2)
> +	if (dfc->dfc_held.dr_inos > 2) {
> +		/*
> +		 * Renames with parent pointer updates can lock up to 5 inodes,
> +		 * sorted by their inode number.  So we need to make sure they
> +		 * are relocked in the same way.
> +		 */
> +		memset(sips, 0, sizeof(sips));
> +		for (i = 0; i < dfc->dfc_held.dr_inos; i++)
> +			sips[i] = dfc->dfc_held.dr_ip[i];
> +
> +		/* Bubble sort of at most 5 inodes */
> +		for (i = 0; i < dfc->dfc_held.dr_inos; i++) {
> +			for (j = 1; j < dfc->dfc_held.dr_inos; j++) {
> +				if (sips[j]->i_ino < sips[j-1]->i_ino) {
> +					temp = sips[j];
> +					sips[j] = sips[j-1];
> +					sips[j-1] = temp;
> +				}
> +			}
> +		}
> +
> +		xfs_lock_inodes(sips, dfc->dfc_held.dr_inos, XFS_ILOCK_EXCL);
> +	} else if (dfc->dfc_held.dr_inos == 2)
>  		xfs_lock_two_inodes(dfc->dfc_held.dr_ip[0], XFS_ILOCK_EXCL,
>  				    dfc->dfc_held.dr_ip[1], XFS_ILOCK_EXCL);
>  	else if (dfc->dfc_held.dr_inos == 1)
> diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
> index 114a3a4930a3..3e4029d2ce41 100644
> --- a/fs/xfs/libxfs/xfs_defer.h
> +++ b/fs/xfs/libxfs/xfs_defer.h
> @@ -70,7 +70,13 @@ extern const struct xfs_defer_op_type xfs_attr_defer_type;
>  /*
>   * Deferred operation item relogging limits.
>   */
> -#define XFS_DEFER_OPS_NR_INODES	2	/* join up to two inodes */
> +
> +/*
> + * Rename w/ parent pointers can require up to 5 inodes with defered ops to

s/defered/deferred/

> + * be joined to the transaction: src_dp, target_dp, src_ip, target_ip, and wip.
> + * These inodes are locked in sorted order by their inode numbers
> + */

When would we be processing *five* different inodes?

Does this happen when src_ip is a child of src_dp, target_ip is a child
of target_dp, all four inodes are distinct, and the VFS asks us to move
src_ip from src_dp to target_dp, unlink target_ip from target_dp, *and*
install a whiteout in the dirent in src_dp?  In which case src_ip,
target_ip, and wip all need parent pointer adjustments?

So that's three inodes that need to stay locked for deferred operations;
what about src_dp and target_dp?  I don't think they need to stay
locked, but OTOH it's probably easier (for now) to lock everything until
the end of the entire rename operation instead of making everyone
reason about when they fall off the transaction chain, right?

If the answer to all that is yes and the typo gets fixed, then
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> +#define XFS_DEFER_OPS_NR_INODES	5
>  #define XFS_DEFER_OPS_NR_BUFS	2	/* join up to two buffers */
>  
>  /* Resources that must be held across a transaction roll. */
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index c000b74dd203..5ebbfceb1ada 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -447,7 +447,7 @@ xfs_lock_inumorder(
>   * lock more than one at a time, lockdep will report false positives saying we
>   * have violated locking orders.
>   */
> -static void
> +void
>  xfs_lock_inodes(
>  	struct xfs_inode	**ips,
>  	int			inodes,
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index fa780f08dc89..2eaed98af814 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -574,5 +574,6 @@ void xfs_end_io(struct work_struct *work);
>  
>  int xfs_ilock2_io_mmap(struct xfs_inode *ip1, struct xfs_inode *ip2);
>  void xfs_iunlock2_io_mmap(struct xfs_inode *ip1, struct xfs_inode *ip2);
> +void xfs_lock_inodes(struct xfs_inode **ips, int inodes, uint lock_mode);
>  
>  #endif	/* __XFS_INODE_H__ */
> -- 
> 2.25.1
> 
