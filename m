Return-Path: <SRS0=NnDK=6T=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C20B7C47254
	for <linux-xfs@archiver.kernel.org>; Tue,  5 May 2020 13:05:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8E65A206B9
	for <linux-xfs@archiver.kernel.org>; Tue,  5 May 2020 13:05:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W5V91CsE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728894AbgEENFf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 5 May 2020 09:05:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728850AbgEENFe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 May 2020 09:05:34 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2EF7C061A0F
        for <linux-xfs@vger.kernel.org>; Tue,  5 May 2020 06:05:34 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id u22so762835plq.12
        for <linux-xfs@vger.kernel.org>; Tue, 05 May 2020 06:05:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aDpJif8k/fleqGaaFP/2ctMXOcngdP/rlZqsFU3FbrU=;
        b=W5V91CsEZo1cOThVt3suG+AS3JZFdznGyoho6hCAn3zUU+9DMOXNZyaVHimuYrlr0d
         3XLbhxNhkcRIOVuQAIf5+3FuVdv7p9FTuUA/Z4W7Br5nSonUhbDPnZZ23AaTqWnOD2hQ
         AzM3kiDTs4UA2ub1E7RIq70ootL8my4z3rOi5txKvByU0akRMWPFHNwBV4k+h8xtUd4D
         6BXaZA1nEgv35U0qUdquE2fVaqG55atOFJUaQXaaA2zzPm2U3//w5R+NzVLadzg9Ctm9
         vo87eGU4dI1xCI7YKt+tfQcsQm/2qVhOvV+QFcXfhMfhCQOjrb8F9qK0TuH0Wt/HqrqI
         0YgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aDpJif8k/fleqGaaFP/2ctMXOcngdP/rlZqsFU3FbrU=;
        b=GYcpLY9/7vYolBJvvACpsFMBA8WwEXUQ7/vZLc/dqx7jVELlechBNEkFGcTrD7fdGG
         kuMXysWPAGzlHuPsukezb1OZ8d97WJcy/M53d6hWb3jVe0MtVZFN0UPNeSe3tI58N3mX
         dRv2KImJnNd2lgZ9V/L1XDC6VD5+SsHAJqq/000FSP5xNaX1cscxWFY6kd5YRc8dEPAm
         dA7MRp61m86GuLgDcMq5wfsa4B2QF9rR52buAxktw2nkVk65FNvYz2oo2fxdB2l8qYdR
         t1XMmG0G44fO1zIZcQyowIMo6lwNffJaIABYzFMDAzItoow6yEu2/Me6nRUIMihteyzZ
         FdhQ==
X-Gm-Message-State: AGi0PubbnqMrqfaFeX0KcXiltTb+He0/TeYBqTJgFtLFMkofWn6JIRGR
        TImVDzacE+Tmh4hcZpnXvbm2owt5loU=
X-Google-Smtp-Source: APiQypIYhWoY+1reKsvntVv7LZYAeka6YOoFUIMXxDYD00YeW5n+SkMnn/g55PqUs5196Gq8cOJa8g==
X-Received: by 2002:a17:902:d68e:: with SMTP id v14mr3076196ply.24.1588683933987;
        Tue, 05 May 2020 06:05:33 -0700 (PDT)
Received: from garuda.localnet ([122.171.152.206])
        by smtp.gmail.com with ESMTPSA id u3sm2061925pfb.105.2020.05.05.06.05.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2020 06:05:33 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 18/28] xfs: refactor unlinked inode recovery
Date:   Tue, 05 May 2020 18:35:30 +0530
Message-ID: <2432898.NGv1NFZK6I@garuda>
In-Reply-To: <158864114901.182683.2099772155374609732.stgit@magnolia>
References: <158864103195.182683.2056162574447133617.stgit@magnolia> <158864114901.182683.2099772155374609732.stgit@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tuesday 5 May 2020 6:42:29 AM IST Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Move the code that processes unlinked inodes into a separate file in
> preparation for centralizing the log recovery bits that have to walk
> every AG.  No functional changes.
>

The functionality is indeed the same as was before applying this patch.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>


> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/Makefile                 |    3 -
>  fs/xfs/libxfs/xfs_log_recover.h |    1 
>  fs/xfs/xfs_log_recover.c        |  177 -----------------------------------
>  fs/xfs/xfs_unlink_recover.c     |  198 +++++++++++++++++++++++++++++++++++++++
>  4 files changed, 202 insertions(+), 177 deletions(-)
>  create mode 100644 fs/xfs/xfs_unlink_recover.c
> 
> 
> diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
> index 04611a1068b4..505c898d6cee 100644
> --- a/fs/xfs/Makefile
> +++ b/fs/xfs/Makefile
> @@ -109,7 +109,8 @@ xfs-y				+= xfs_log.o \
>  				   xfs_rmap_item.o \
>  				   xfs_log_recover.o \
>  				   xfs_trans_ail.o \
> -				   xfs_trans_buf.o
> +				   xfs_trans_buf.o \
> +				   xfs_unlink_recover.o
>  
>  # optional features
>  xfs-$(CONFIG_XFS_QUOTA)		+= xfs_dquot.o \
> diff --git a/fs/xfs/libxfs/xfs_log_recover.h b/fs/xfs/libxfs/xfs_log_recover.h
> index a45f6e9fa47b..33c14dd22b77 100644
> --- a/fs/xfs/libxfs/xfs_log_recover.h
> +++ b/fs/xfs/libxfs/xfs_log_recover.h
> @@ -124,5 +124,6 @@ bool xlog_add_buffer_cancelled(struct xlog *log, xfs_daddr_t blkno, uint len);
>  bool xlog_is_buffer_cancelled(struct xlog *log, xfs_daddr_t blkno, uint len);
>  bool xlog_put_buffer_cancelled(struct xlog *log, xfs_daddr_t blkno, uint len);
>  void xlog_recover_iodone(struct xfs_buf *bp);
> +void xlog_recover_process_unlinked(struct xlog *log);
>  
>  #endif	/* __XFS_LOG_RECOVER_H__ */
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 20ee32c2652d..362296b34490 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -2720,181 +2720,6 @@ xlog_recover_cancel_intents(
>  	spin_unlock(&ailp->ail_lock);
>  }
>  
> -/*
> - * This routine performs a transaction to null out a bad inode pointer
> - * in an agi unlinked inode hash bucket.
> - */
> -STATIC void
> -xlog_recover_clear_agi_bucket(
> -	xfs_mount_t	*mp,
> -	xfs_agnumber_t	agno,
> -	int		bucket)
> -{
> -	xfs_trans_t	*tp;
> -	xfs_agi_t	*agi;
> -	xfs_buf_t	*agibp;
> -	int		offset;
> -	int		error;
> -
> -	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_clearagi, 0, 0, 0, &tp);
> -	if (error)
> -		goto out_error;
> -
> -	error = xfs_read_agi(mp, tp, agno, &agibp);
> -	if (error)
> -		goto out_abort;
> -
> -	agi = agibp->b_addr;
> -	agi->agi_unlinked[bucket] = cpu_to_be32(NULLAGINO);
> -	offset = offsetof(xfs_agi_t, agi_unlinked) +
> -		 (sizeof(xfs_agino_t) * bucket);
> -	xfs_trans_log_buf(tp, agibp, offset,
> -			  (offset + sizeof(xfs_agino_t) - 1));
> -
> -	error = xfs_trans_commit(tp);
> -	if (error)
> -		goto out_error;
> -	return;
> -
> -out_abort:
> -	xfs_trans_cancel(tp);
> -out_error:
> -	xfs_warn(mp, "%s: failed to clear agi %d. Continuing.", __func__, agno);
> -	return;
> -}
> -
> -STATIC xfs_agino_t
> -xlog_recover_process_one_iunlink(
> -	struct xfs_mount		*mp,
> -	xfs_agnumber_t			agno,
> -	xfs_agino_t			agino,
> -	int				bucket)
> -{
> -	struct xfs_buf			*ibp;
> -	struct xfs_dinode		*dip;
> -	struct xfs_inode		*ip;
> -	xfs_ino_t			ino;
> -	int				error;
> -
> -	ino = XFS_AGINO_TO_INO(mp, agno, agino);
> -	error = xfs_iget(mp, NULL, ino, 0, 0, &ip);
> -	if (error)
> -		goto fail;
> -
> -	/*
> -	 * Get the on disk inode to find the next inode in the bucket.
> -	 */
> -	error = xfs_imap_to_bp(mp, NULL, &ip->i_imap, &dip, &ibp, 0, 0);
> -	if (error)
> -		goto fail_iput;
> -
> -	xfs_iflags_clear(ip, XFS_IRECOVERY);
> -	ASSERT(VFS_I(ip)->i_nlink == 0);
> -	ASSERT(VFS_I(ip)->i_mode != 0);
> -
> -	/* setup for the next pass */
> -	agino = be32_to_cpu(dip->di_next_unlinked);
> -	xfs_buf_relse(ibp);
> -
> -	/*
> -	 * Prevent any DMAPI event from being sent when the reference on
> -	 * the inode is dropped.
> -	 */
> -	ip->i_d.di_dmevmask = 0;
> -
> -	xfs_irele(ip);
> -	return agino;
> -
> - fail_iput:
> -	xfs_irele(ip);
> - fail:
> -	/*
> -	 * We can't read in the inode this bucket points to, or this inode
> -	 * is messed up.  Just ditch this bucket of inodes.  We will lose
> -	 * some inodes and space, but at least we won't hang.
> -	 *
> -	 * Call xlog_recover_clear_agi_bucket() to perform a transaction to
> -	 * clear the inode pointer in the bucket.
> -	 */
> -	xlog_recover_clear_agi_bucket(mp, agno, bucket);
> -	return NULLAGINO;
> -}
> -
> -/*
> - * Recover AGI unlinked lists
> - *
> - * This is called during recovery to process any inodes which we unlinked but
> - * not freed when the system crashed.  These inodes will be on the lists in the
> - * AGI blocks. What we do here is scan all the AGIs and fully truncate and free
> - * any inodes found on the lists. Each inode is removed from the lists when it
> - * has been fully truncated and is freed. The freeing of the inode and its
> - * removal from the list must be atomic.
> - *
> - * If everything we touch in the agi processing loop is already in memory, this
> - * loop can hold the cpu for a long time. It runs without lock contention,
> - * memory allocation contention, the need wait for IO, etc, and so will run
> - * until we either run out of inodes to process, run low on memory or we run out
> - * of log space.
> - *
> - * This behaviour is bad for latency on single CPU and non-preemptible kernels,
> - * and can prevent other filesytem work (such as CIL pushes) from running. This
> - * can lead to deadlocks if the recovery process runs out of log reservation
> - * space. Hence we need to yield the CPU when there is other kernel work
> - * scheduled on this CPU to ensure other scheduled work can run without undue
> - * latency.
> - */
> -STATIC void
> -xlog_recover_process_iunlinks(
> -	struct xlog	*log)
> -{
> -	xfs_mount_t	*mp;
> -	xfs_agnumber_t	agno;
> -	xfs_agi_t	*agi;
> -	xfs_buf_t	*agibp;
> -	xfs_agino_t	agino;
> -	int		bucket;
> -	int		error;
> -
> -	mp = log->l_mp;
> -
> -	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
> -		/*
> -		 * Find the agi for this ag.
> -		 */
> -		error = xfs_read_agi(mp, NULL, agno, &agibp);
> -		if (error) {
> -			/*
> -			 * AGI is b0rked. Don't process it.
> -			 *
> -			 * We should probably mark the filesystem as corrupt
> -			 * after we've recovered all the ag's we can....
> -			 */
> -			continue;
> -		}
> -		/*
> -		 * Unlock the buffer so that it can be acquired in the normal
> -		 * course of the transaction to truncate and free each inode.
> -		 * Because we are not racing with anyone else here for the AGI
> -		 * buffer, we don't even need to hold it locked to read the
> -		 * initial unlinked bucket entries out of the buffer. We keep
> -		 * buffer reference though, so that it stays pinned in memory
> -		 * while we need the buffer.
> -		 */
> -		agi = agibp->b_addr;
> -		xfs_buf_unlock(agibp);
> -
> -		for (bucket = 0; bucket < XFS_AGI_UNLINKED_BUCKETS; bucket++) {
> -			agino = be32_to_cpu(agi->agi_unlinked[bucket]);
> -			while (agino != NULLAGINO) {
> -				agino = xlog_recover_process_one_iunlink(mp,
> -							agno, agino, bucket);
> -				cond_resched();
> -			}
> -		}
> -		xfs_buf_rele(agibp);
> -	}
> -}
> -
>  STATIC void
>  xlog_unpack_data(
>  	struct xlog_rec_header	*rhead,
> @@ -3574,7 +3399,7 @@ xlog_recover_finish(
>  		 */
>  		xfs_log_force(log->l_mp, XFS_LOG_SYNC);
>  
> -		xlog_recover_process_iunlinks(log);
> +		xlog_recover_process_unlinked(log);
>  
>  		xlog_recover_check_summary(log);
>  
> diff --git a/fs/xfs/xfs_unlink_recover.c b/fs/xfs/xfs_unlink_recover.c
> new file mode 100644
> index 000000000000..2a19d096e88d
> --- /dev/null
> +++ b/fs/xfs/xfs_unlink_recover.c
> @@ -0,0 +1,198 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (c) 2000-2006 Silicon Graphics, Inc.
> + * All Rights Reserved.
> + */
> +#include "xfs.h"
> +#include "xfs_fs.h"
> +#include "xfs_shared.h"
> +#include "xfs_format.h"
> +#include "xfs_log_format.h"
> +#include "xfs_trans_resv.h"
> +#include "xfs_bit.h"
> +#include "xfs_sb.h"
> +#include "xfs_mount.h"
> +#include "xfs_defer.h"
> +#include "xfs_inode.h"
> +#include "xfs_trans.h"
> +#include "xfs_log.h"
> +#include "xfs_log_priv.h"
> +#include "xfs_log_recover.h"
> +#include "xfs_trans_priv.h"
> +#include "xfs_ialloc.h"
> +#include "xfs_icache.h"
> +
> +/*
> + * This routine performs a transaction to null out a bad inode pointer
> + * in an agi unlinked inode hash bucket.
> + */
> +STATIC void
> +xlog_recover_clear_agi_bucket(
> +	struct xfs_mount	*mp,
> +	xfs_agnumber_t		agno,
> +	int			bucket)
> +{
> +	struct xfs_trans	*tp;
> +	struct xfs_agi		*agi;
> +	struct xfs_buf		*agibp;
> +	int			offset;
> +	int			error;
> +
> +	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_clearagi, 0, 0, 0, &tp);
> +	if (error)
> +		goto out_error;
> +
> +	error = xfs_read_agi(mp, tp, agno, &agibp);
> +	if (error)
> +		goto out_abort;
> +
> +	agi = agibp->b_addr;
> +	agi->agi_unlinked[bucket] = cpu_to_be32(NULLAGINO);
> +	offset = offsetof(xfs_agi_t, agi_unlinked) +
> +		 (sizeof(xfs_agino_t) * bucket);
> +	xfs_trans_log_buf(tp, agibp, offset,
> +			  (offset + sizeof(xfs_agino_t) - 1));
> +
> +	error = xfs_trans_commit(tp);
> +	if (error)
> +		goto out_error;
> +	return;
> +
> +out_abort:
> +	xfs_trans_cancel(tp);
> +out_error:
> +	xfs_warn(mp, "%s: failed to clear agi %d. Continuing.", __func__, agno);
> +	return;
> +}
> +
> +STATIC xfs_agino_t
> +xlog_recover_process_one_iunlink(
> +	struct xfs_mount		*mp,
> +	xfs_agnumber_t			agno,
> +	xfs_agino_t			agino,
> +	int				bucket)
> +{
> +	struct xfs_buf			*ibp;
> +	struct xfs_dinode		*dip;
> +	struct xfs_inode		*ip;
> +	xfs_ino_t			ino;
> +	int				error;
> +
> +	ino = XFS_AGINO_TO_INO(mp, agno, agino);
> +	error = xfs_iget(mp, NULL, ino, 0, 0, &ip);
> +	if (error)
> +		goto fail;
> +
> +	/*
> +	 * Get the on disk inode to find the next inode in the bucket.
> +	 */
> +	error = xfs_imap_to_bp(mp, NULL, &ip->i_imap, &dip, &ibp, 0, 0);
> +	if (error)
> +		goto fail_iput;
> +
> +	xfs_iflags_clear(ip, XFS_IRECOVERY);
> +	ASSERT(VFS_I(ip)->i_nlink == 0);
> +	ASSERT(VFS_I(ip)->i_mode != 0);
> +
> +	/* setup for the next pass */
> +	agino = be32_to_cpu(dip->di_next_unlinked);
> +	xfs_buf_relse(ibp);
> +
> +	/*
> +	 * Prevent any DMAPI event from being sent when the reference on
> +	 * the inode is dropped.
> +	 */
> +	ip->i_d.di_dmevmask = 0;
> +
> +	xfs_irele(ip);
> +	return agino;
> +
> + fail_iput:
> +	xfs_irele(ip);
> + fail:
> +	/*
> +	 * We can't read in the inode this bucket points to, or this inode
> +	 * is messed up.  Just ditch this bucket of inodes.  We will lose
> +	 * some inodes and space, but at least we won't hang.
> +	 *
> +	 * Call xlog_recover_clear_agi_bucket() to perform a transaction to
> +	 * clear the inode pointer in the bucket.
> +	 */
> +	xlog_recover_clear_agi_bucket(mp, agno, bucket);
> +	return NULLAGINO;
> +}
> +
> +/*
> + * Recover AGI unlinked lists
> + *
> + * This is called during recovery to process any inodes which we unlinked but
> + * not freed when the system crashed.  These inodes will be on the lists in the
> + * AGI blocks. What we do here is scan all the AGIs and fully truncate and free
> + * any inodes found on the lists. Each inode is removed from the lists when it
> + * has been fully truncated and is freed. The freeing of the inode and its
> + * removal from the list must be atomic.
> + *
> + * If everything we touch in the agi processing loop is already in memory, this
> + * loop can hold the cpu for a long time. It runs without lock contention,
> + * memory allocation contention, the need wait for IO, etc, and so will run
> + * until we either run out of inodes to process, run low on memory or we run out
> + * of log space.
> + *
> + * This behaviour is bad for latency on single CPU and non-preemptible kernels,
> + * and can prevent other filesytem work (such as CIL pushes) from running. This
> + * can lead to deadlocks if the recovery process runs out of log reservation
> + * space. Hence we need to yield the CPU when there is other kernel work
> + * scheduled on this CPU to ensure other scheduled work can run without undue
> + * latency.
> + */
> +void
> +xlog_recover_process_unlinked(
> +	struct xlog		*log)
> +{
> +	struct xfs_mount	*mp;
> +	struct xfs_agi		*agi;
> +	struct xfs_buf		*agibp;
> +	xfs_agnumber_t		agno;
> +	xfs_agino_t		agino;
> +	int			bucket;
> +	int			error;
> +
> +	mp = log->l_mp;
> +
> +	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
> +		/*
> +		 * Find the agi for this ag.
> +		 */
> +		error = xfs_read_agi(mp, NULL, agno, &agibp);
> +		if (error) {
> +			/*
> +			 * AGI is b0rked. Don't process it.
> +			 *
> +			 * We should probably mark the filesystem as corrupt
> +			 * after we've recovered all the ag's we can....
> +			 */
> +			continue;
> +		}
> +		/*
> +		 * Unlock the buffer so that it can be acquired in the normal
> +		 * course of the transaction to truncate and free each inode.
> +		 * Because we are not racing with anyone else here for the AGI
> +		 * buffer, we don't even need to hold it locked to read the
> +		 * initial unlinked bucket entries out of the buffer. We keep
> +		 * buffer reference though, so that it stays pinned in memory
> +		 * while we need the buffer.
> +		 */
> +		agi = agibp->b_addr;
> +		xfs_buf_unlock(agibp);
> +
> +		for (bucket = 0; bucket < XFS_AGI_UNLINKED_BUCKETS; bucket++) {
> +			agino = be32_to_cpu(agi->agi_unlinked[bucket]);
> +			while (agino != NULLAGINO) {
> +				agino = xlog_recover_process_one_iunlink(mp,
> +							agno, agino, bucket);
> +				cond_resched();
> +			}
> +		}
> +		xfs_buf_rele(agibp);
> +	}
> +}
> 
> 


-- 
chandan



