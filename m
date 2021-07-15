Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E184AC636C7
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Jul 2021 17:15:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C8B72613BA
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Jul 2021 17:15:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231950AbhGORSn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 15 Jul 2021 13:18:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:52462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231941AbhGORSn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 15 Jul 2021 13:18:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 92048613C7;
        Thu, 15 Jul 2021 17:15:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626369349;
        bh=H2jLRDxs9iBdozo7GdacWb0pVFF9GRrXsAgZwY1kXy8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PaTa7363lqLkXG+mNH/MusDih547jN7JRCj1ed3hZdeU4r8Qas0oiMPikpj2t9G3r
         HnxAiWv6BO33YUoCtI9+m1d6C145GhkBqo3Pc5xhMUaIuJeFEkFBGgZzaz063Bb3AE
         sfFqCF3sZgGZypBXRt+cw9ivlTqgXZ2ocUnWvc7VjDHZl9Dg1ZohCr9vNX2PZqjWfc
         L6kmCLvMKMd9dcUEjRrjc7mbMu8NU5LzngP9hEbzUKMDurb4KBiSQtPMYDX2uhUDWr
         yLFv7wtZ7tLsAaFtNQgbGFQmop1TC5ajaAeZ6omLlwASGZagcWLLzHcTEHU/7HlWzx
         T0ZajW79BlNQQ==
Date:   Thu, 15 Jul 2021 10:15:49 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: remove support for disabling quota accounting
 on a mounted file system
Message-ID: <20210715171549.GV22402@magnolia>
References: <20210712111426.83004-1-hch@lst.de>
 <20210712111426.83004-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210712111426.83004-2-hch@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jul 12, 2021 at 01:14:24PM +0200, Christoph Hellwig wrote:
> Disabling quota accounting is hairy, racy code with all kinds of pitfalls.
> And it has a very strange mind set, as quota accounting (unlike
> enforcement) really is a propery of the on-disk format.  There is no good
> use case for supporting this.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_trans_resv.c |  30 ----
>  fs/xfs/libxfs/xfs_trans_resv.h |   2 -
>  fs/xfs/xfs_dquot_item.c        | 134 ------------------
>  fs/xfs/xfs_dquot_item.h        |  17 ---
>  fs/xfs/xfs_qm.c                |   2 +-
>  fs/xfs/xfs_qm.h                |   3 -
>  fs/xfs/xfs_qm_syscalls.c       | 241 ++-------------------------------
>  fs/xfs/xfs_trans_dquot.c       |  38 ------
>  8 files changed, 13 insertions(+), 454 deletions(-)
> 

<snip> since Christoph didn't find the reply the first time...

> diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
> index 13a56e1ea15ce1..e00067a142a094 100644
> --- a/fs/xfs/xfs_qm_syscalls.c
> +++ b/fs/xfs/xfs_qm_syscalls.c

<snip>

> @@ -111,160 +31,23 @@ xfs_qm_scall_quotaoff(
>  	 */
>  	if ((mp->m_qflags & flags) == 0)
>  		return -EEXIST;
> -	error = 0;
> -
> -	flags &= (XFS_ALL_QUOTA_ACCT | XFS_ALL_QUOTA_ENFD);
>  
>  	/*
> -	 * We don't want to deal with two quotaoffs messing up each other,
> -	 * so we're going to serialize it. quotaoff isn't exactly a performance
> -	 * critical thing.
> -	 * If quotaoff, then we must be dealing with the root filesystem.
> +	 * We do not support actually turning off quota accounting any more.
> +	 * Just log a warning and ignored the accounting related flags.

s/ignored/ignore/

>  	 */
> -	ASSERT(q);
> -	mutex_lock(&q->qi_quotaofflock);
> +	if (flags & XFS_ALL_QUOTA_ACCT)
> +		xfs_info(mp, "disabling of quota accounting not supported.");

Why not return EOPNOTSUPP here?  We're not going to turn off accounting,
so we're not doing what the admin asked.

--D

>  
> -	/*
> -	 * If we're just turning off quota enforcement, change mp and go.
> -	 */
> -	if ((flags & XFS_ALL_QUOTA_ACCT) == 0) {
> -		mp->m_qflags &= ~(flags);
> -
> -		spin_lock(&mp->m_sb_lock);
> -		mp->m_sb.sb_qflags = mp->m_qflags;
> -		spin_unlock(&mp->m_sb_lock);
> -		mutex_unlock(&q->qi_quotaofflock);
> -
> -		/* XXX what to do if error ? Revert back to old vals incore ? */
> -		return xfs_sync_sb(mp, false);
> -	}
> -
> -	dqtype = 0;
> -	inactivate_flags = 0;
> -	/*
> -	 * If accounting is off, we must turn enforcement off, clear the
> -	 * quota 'CHKD' certificate to make it known that we have to
> -	 * do a quotacheck the next time this quota is turned on.
> -	 */
> -	if (flags & XFS_UQUOTA_ACCT) {
> -		dqtype |= XFS_QMOPT_UQUOTA;
> -		flags |= (XFS_UQUOTA_CHKD | XFS_UQUOTA_ENFD);
> -		inactivate_flags |= XFS_UQUOTA_ACTIVE;
> -	}
> -	if (flags & XFS_GQUOTA_ACCT) {
> -		dqtype |= XFS_QMOPT_GQUOTA;
> -		flags |= (XFS_GQUOTA_CHKD | XFS_GQUOTA_ENFD);
> -		inactivate_flags |= XFS_GQUOTA_ACTIVE;
> -	}
> -	if (flags & XFS_PQUOTA_ACCT) {
> -		dqtype |= XFS_QMOPT_PQUOTA;
> -		flags |= (XFS_PQUOTA_CHKD | XFS_PQUOTA_ENFD);
> -		inactivate_flags |= XFS_PQUOTA_ACTIVE;
> -	}
> -
> -	/*
> -	 * Nothing to do?  Don't complain. This happens when we're just
> -	 * turning off quota enforcement.
> -	 */
> -	if ((mp->m_qflags & flags) == 0)
> -		goto out_unlock;
> -
> -	/*
> -	 * Write the LI_QUOTAOFF log record, and do SB changes atomically,
> -	 * and synchronously. If we fail to write, we should abort the
> -	 * operation as it cannot be recovered safely if we crash.
> -	 */
> -	error = xfs_qm_log_quotaoff(mp, &qoffstart, flags);
> -	if (error)
> -		goto out_unlock;
> -
> -	/*
> -	 * Next we clear the XFS_MOUNT_*DQ_ACTIVE bit(s) in the mount struct
> -	 * to take care of the race between dqget and quotaoff. We don't take
> -	 * any special locks to reset these bits. All processes need to check
> -	 * these bits *after* taking inode lock(s) to see if the particular
> -	 * quota type is in the process of being turned off. If *ACTIVE, it is
> -	 * guaranteed that all dquot structures and all quotainode ptrs will all
> -	 * stay valid as long as that inode is kept locked.
> -	 *
> -	 * There is no turning back after this.
> -	 */
> -	mp->m_qflags &= ~inactivate_flags;
> -
> -	/*
> -	 * Give back all the dquot reference(s) held by inodes.
> -	 * Here we go thru every single incore inode in this file system, and
> -	 * do a dqrele on the i_udquot/i_gdquot that it may have.
> -	 * Essentially, as long as somebody has an inode locked, this guarantees
> -	 * that quotas will not be turned off. This is handy because in a
> -	 * transaction once we lock the inode(s) and check for quotaon, we can
> -	 * depend on the quota inodes (and other things) being valid as long as
> -	 * we keep the lock(s).
> -	 */
> -	error = xfs_dqrele_all_inodes(mp, flags);
> -	ASSERT(!error);
> -
> -	/*
> -	 * Next we make the changes in the quota flag in the mount struct.
> -	 * This isn't protected by a particular lock directly, because we
> -	 * don't want to take a mrlock every time we depend on quotas being on.
> -	 */
> -	mp->m_qflags &= ~flags;
> -
> -	/*
> -	 * Go through all the dquots of this file system and purge them,
> -	 * according to what was turned off.
> -	 */
> -	xfs_qm_dqpurge_all(mp, dqtype);
> -
> -	/*
> -	 * Transactions that had started before ACTIVE state bit was cleared
> -	 * could have logged many dquots, so they'd have higher LSNs than
> -	 * the first QUOTAOFF log record does. If we happen to crash when
> -	 * the tail of the log has gone past the QUOTAOFF record, but
> -	 * before the last dquot modification, those dquots __will__
> -	 * recover, and that's not good.
> -	 *
> -	 * So, we have QUOTAOFF start and end logitems; the start
> -	 * logitem won't get overwritten until the end logitem appears...
> -	 */
> -	error = xfs_qm_log_quotaoff_end(mp, &qoffstart, flags);
> -	if (error) {
> -		/* We're screwed now. Shutdown is the only option. */
> -		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
> -		goto out_unlock;
> -	}
> -
> -	/*
> -	 * If all quotas are completely turned off, close shop.
> -	 */
> -	if (mp->m_qflags == 0) {
> -		mutex_unlock(&q->qi_quotaofflock);
> -		xfs_qm_destroy_quotainfo(mp);
> -		return 0;
> -	}
> -
> -	/*
> -	 * Release our quotainode references if we don't need them anymore.
> -	 */
> -	if ((dqtype & XFS_QMOPT_UQUOTA) && q->qi_uquotaip) {
> -		xfs_irele(q->qi_uquotaip);
> -		q->qi_uquotaip = NULL;
> -	}
> -	if ((dqtype & XFS_QMOPT_GQUOTA) && q->qi_gquotaip) {
> -		xfs_irele(q->qi_gquotaip);
> -		q->qi_gquotaip = NULL;
> -	}
> -	if ((dqtype & XFS_QMOPT_PQUOTA) && q->qi_pquotaip) {
> -		xfs_irele(q->qi_pquotaip);
> -		q->qi_pquotaip = NULL;
> -	}
> +	mutex_lock(&mp->m_quotainfo->qi_quotaofflock);
> +	mp->m_qflags &= ~(flags & XFS_ALL_QUOTA_ENFD);
> +	spin_lock(&mp->m_sb_lock);
> +	mp->m_sb.sb_qflags = mp->m_qflags;
> +	spin_unlock(&mp->m_sb_lock);
> +	mutex_unlock(&mp->m_quotainfo->qi_quotaofflock);
>  
> -out_unlock:
> -	if (error && qoffstart)
> -		xfs_qm_qoff_logitem_relse(qoffstart);
> -	mutex_unlock(&q->qi_quotaofflock);
> -	return error;
> +	/* XXX what to do if error ? Revert back to old vals incore ? */
> +	return xfs_sync_sb(mp, false);
>  }
>  
>  STATIC int
> diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
> index 48e09ea30ee539..b7e4b05a559bdb 100644
> --- a/fs/xfs/xfs_trans_dquot.c
> +++ b/fs/xfs/xfs_trans_dquot.c
> @@ -843,44 +843,6 @@ xfs_trans_reserve_quota_icreate(
>  			dblocks, 1, XFS_QMOPT_RES_REGBLKS);
>  }
>  
> -/*
> - * This routine is called to allocate a quotaoff log item.
> - */
> -struct xfs_qoff_logitem *
> -xfs_trans_get_qoff_item(
> -	struct xfs_trans	*tp,
> -	struct xfs_qoff_logitem	*startqoff,
> -	uint			flags)
> -{
> -	struct xfs_qoff_logitem	*q;
> -
> -	ASSERT(tp != NULL);
> -
> -	q = xfs_qm_qoff_logitem_init(tp->t_mountp, startqoff, flags);
> -	ASSERT(q != NULL);
> -
> -	/*
> -	 * Get a log_item_desc to point at the new item.
> -	 */
> -	xfs_trans_add_item(tp, &q->qql_item);
> -	return q;
> -}
> -
> -
> -/*
> - * This is called to mark the quotaoff logitem as needing
> - * to be logged when the transaction is committed.  The logitem must
> - * already be associated with the given transaction.
> - */
> -void
> -xfs_trans_log_quotaoff_item(
> -	struct xfs_trans	*tp,
> -	struct xfs_qoff_logitem	*qlp)
> -{
> -	tp->t_flags |= XFS_TRANS_DIRTY;
> -	set_bit(XFS_LI_DIRTY, &qlp->qql_item.li_flags);
> -}
> -
>  STATIC void
>  xfs_trans_alloc_dqinfo(
>  	xfs_trans_t	*tp)
> -- 
> 2.30.2
> 
