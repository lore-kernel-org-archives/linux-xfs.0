Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55CD8C19F2D
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Aug 2022 16:39:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244627AbiHIQid (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 9 Aug 2022 12:38:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245211AbiHIQiY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Aug 2022 12:38:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 787F72F9
        for <linux-xfs@vger.kernel.org>; Tue,  9 Aug 2022 09:38:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3BB7EB81625
        for <linux-xfs@vger.kernel.org>; Tue,  9 Aug 2022 16:38:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D21EFC433C1;
        Tue,  9 Aug 2022 16:38:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660063100;
        bh=lEYpRlWcM7sRJKvoSBWmY6Gj+CujEZW4+6/jgnNBYSc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=A40xocr44VkoYiMrPBUv4eE4APR5nFU1BGWGeKCHQIT05qgurw/5r7+fz4ORYJ1Fd
         YxHzZgvtdIuQ9nB8BZrQ2VMQYJfS56qScs71qVdtOI+ad+ah89Wafxd46HfW4TZHAe
         e/Z8CDTeZ03zaRm/tI4veTF8puy40S0xbjXINBdMhyQSMYa/qPsm2px2RRpbQOcxMB
         17PzTVB6SwtYGBj6qx3t4bu5EXoOAAl7gWgi7EIJFUfh4YYpRWL1iiAeC+i2jeV+Yu
         sNEPH+mi6GbZa6YorJZ/2RP/8Ty1Lp+QJPDQYjHtI2U91x14C86fNClg5l6kjqC2rz
         jHAKTFL9bAEtA==
Date:   Tue, 9 Aug 2022 09:38:19 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH RESEND v2 02/18] xfs: Increase XFS_DEFER_OPS_NR_INODES to
 5
Message-ID: <YvKNe10WaSRRPdzf@magnolia>
References: <20220804194013.99237-1-allison.henderson@oracle.com>
 <20220804194013.99237-3-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220804194013.99237-3-allison.henderson@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 04, 2022 at 12:39:57PM -0700, Allison Henderson wrote:
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

Why not reuse xfs_sort_for_rename?

I also wonder if it's worth the trouble to replace the open-coded
bubblesort with a call to sort_r(), but TBH I suspect the cost of a
retpoline for the compare function isn't worth the overhead.

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
> + * be joined to the transaction: src_dp, target_dp, src_ip, target_ip, and wip.
> + * These inodes are locked in sorted order by their inode numbers

Much inode.  Thanks for recording this.

--D

> + */
> +#define XFS_DEFER_OPS_NR_INODES	5
>  #define XFS_DEFER_OPS_NR_BUFS	2	/* join up to two buffers */
>  
>  /* Resources that must be held across a transaction roll. */
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 3022918bf96a..cfdcca95594f 100644
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
> index 4d626f4321bc..bc06d6e4164a 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -573,5 +573,6 @@ void xfs_end_io(struct work_struct *work);
>  
>  int xfs_ilock2_io_mmap(struct xfs_inode *ip1, struct xfs_inode *ip2);
>  void xfs_iunlock2_io_mmap(struct xfs_inode *ip1, struct xfs_inode *ip2);
> +void xfs_lock_inodes(struct xfs_inode **ips, int inodes, uint lock_mode);
>  
>  #endif	/* __XFS_INODE_H__ */
> -- 
> 2.25.1
> 
