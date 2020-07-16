Return-Path: <SRS0=b91c=A3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60FAAC433E1
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jul 2020 07:00:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3787120720
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jul 2020 07:00:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="k6L4/K7p"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728041AbgGPHAI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Jul 2020 03:00:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726069AbgGPHAF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Jul 2020 03:00:05 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A20AC061755
        for <linux-xfs@vger.kernel.org>; Thu, 16 Jul 2020 00:00:02 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id u5so3235628pfn.7
        for <linux-xfs@vger.kernel.org>; Thu, 16 Jul 2020 00:00:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LfFeEYRWX+G/Vry0pViT0SWhdlNEje72NX6PVJBalLQ=;
        b=k6L4/K7pnRbW1Ea3jUqPXa5OznBZTivqEJi/25X1FniOFBNirWwZ2YkK2vB6AfBrln
         MteKXt6F5+/h3ORDQWrEhXk/jyOC55yta/aBf37d3niXLCZHrs6VDnnLnj3f0rPTQu09
         KgdfSJW1rAokf7wLvDda6/3anPH/W+eYAsdZRa4ZxzTTsRmG73J8i+3ps8nPMPlAo9ty
         aqSX6ylmA1nGzBRrTGe9kXWC6fhqxNEIXFvnGvqnSw2fgI3gQxhpNw2XN/L4gvo5hRHB
         AG9nXZ3s4CMWnBjezNGIBCZZ2p/52ZzNDmTL4m+D2km6qVQrj1pGskG0jsnoWIGKgnQ9
         Ja7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LfFeEYRWX+G/Vry0pViT0SWhdlNEje72NX6PVJBalLQ=;
        b=XkGPu27vChY0pA4BVifmX/S3WTTwzP5e3sGqpfrQrUWs24JxCGRsClIPOFMdef0WGP
         24f1q4kjGKRn0x7YpHCgKyxhRwHf+Rq3swHlI3QZ+MadbUiNP6QXFKMKmCA5EBGpOqmD
         sL+fY2leFyk9+0kbMP3dF7W6L4wy3iR9n6jyq+Cdw5YdU/bCejBdL0Agd7FLIqsBuSTg
         FwOW2cuvkciCXwA6oW0LSe67wf5nz8ElkMOKkfs4lCikfVKm7e2UymgQQsjYjUDIbUR3
         KjkyIfvft2yC8I+k6O5io8F3z1rV05fXiwJvDI9M81eNbyMF9JmCCBandunGmK9X4sDK
         rzjw==
X-Gm-Message-State: AOAM5325xqHq/CC80uMH2tXS7v52Gk/bjA6E7uZghm3wakTUH0F7SwNN
        7yYTUzO+QlJMeiaUlAq2z13DRYvL
X-Google-Smtp-Source: ABdhPJyqWdcXJFKGEU/kywW9QhCP75cbTdxjO3XIsjH0fQb/9BAccxBa0e6Z+nuvVvD5whQ49tIScw==
X-Received: by 2002:a63:e14c:: with SMTP id h12mr3106469pgk.110.1594882801888;
        Thu, 16 Jul 2020 00:00:01 -0700 (PDT)
Received: from garuda.localnet ([122.167.32.2])
        by smtp.gmail.com with ESMTPSA id mu17sm4388263pjb.53.2020.07.15.23.59.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2020 00:00:01 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/26] xfs: rename dquot incore state flags
Date:   Thu, 16 Jul 2020 12:29:08 +0530
Message-ID: <3648569.ikp86AD9L0@garuda>
In-Reply-To: <159477788070.3263162.4867863895520340082.stgit@magnolia>
References: <159477783164.3263162.2564345443708779029.stgit@magnolia> <159477788070.3263162.4867863895520340082.stgit@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wednesday 15 July 2020 7:21:20 AM IST Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Rename the existing incore dquot "dq_flags" field to "q_flags" to match
> everything else in the structure, then move the two actual dquot state
> flags to the XFS_DQFLAG_ namespace from XFS_DQ_.
>
The changes look good to me.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_quota_defs.h |   10 +++++-----
>  fs/xfs/xfs_dquot.c             |    6 +++---
>  fs/xfs/xfs_dquot.h             |    4 ++--
>  fs/xfs/xfs_qm.c                |   12 ++++++------
>  fs/xfs/xfs_qm_syscalls.c       |    2 +-
>  fs/xfs/xfs_trace.h             |    4 ++--
>  fs/xfs/xfs_trans_dquot.c       |    2 +-
>  7 files changed, 20 insertions(+), 20 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_quota_defs.h b/fs/xfs/libxfs/xfs_quota_defs.h
> index aaf85a47ae5f..2109fe621e1f 100644
> --- a/fs/xfs/libxfs/xfs_quota_defs.h
> +++ b/fs/xfs/libxfs/xfs_quota_defs.h
> @@ -37,17 +37,17 @@ typedef uint8_t		xfs_dqtype_t;
>  #define XFS_DQ_USER		0x0001		/* a user quota */
>  #define XFS_DQ_PROJ		0x0002		/* project quota */
>  #define XFS_DQ_GROUP		0x0004		/* a group quota */
> -#define XFS_DQ_DIRTY		0x0008		/* dquot is dirty */
> -#define XFS_DQ_FREEING		0x0010		/* dquot is being torn down */
> +#define XFS_DQFLAG_DIRTY	0x0008		/* dquot is dirty */
> +#define XFS_DQFLAG_FREEING	0x0010		/* dquot is being torn down */
>  
>  #define XFS_DQ_ALLTYPES		(XFS_DQ_USER|XFS_DQ_PROJ|XFS_DQ_GROUP)
>  
> -#define XFS_DQ_FLAGS \
> +#define XFS_DQFLAG_STRINGS \
>  	{ XFS_DQ_USER,		"USER" }, \
>  	{ XFS_DQ_PROJ,		"PROJ" }, \
>  	{ XFS_DQ_GROUP,		"GROUP" }, \
> -	{ XFS_DQ_DIRTY,		"DIRTY" }, \
> -	{ XFS_DQ_FREEING,	"FREEING" }
> +	{ XFS_DQFLAG_DIRTY,	"DIRTY" }, \
> +	{ XFS_DQFLAG_FREEING,	"FREEING" }
>  
>  /*
>   * We have the possibility of all three quota types being active at once, and
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index 8230faa9f66e..91d81a346801 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -730,7 +730,7 @@ xfs_qm_dqget_cache_lookup(
>  	}
>  
>  	xfs_dqlock(dqp);
> -	if (dqp->dq_flags & XFS_DQ_FREEING) {
> +	if (dqp->q_flags & XFS_DQFLAG_FREEING) {
>  		xfs_dqunlock(dqp);
>  		mutex_unlock(&qi->qi_tree_lock);
>  		trace_xfs_dqget_freeing(dqp);
> @@ -1186,7 +1186,7 @@ xfs_qm_dqflush(
>  	/*
>  	 * Clear the dirty field and remember the flush lsn for later use.
>  	 */
> -	dqp->dq_flags &= ~XFS_DQ_DIRTY;
> +	dqp->q_flags &= ~XFS_DQFLAG_DIRTY;
>  
>  	xfs_trans_ail_copy_lsn(mp->m_ail, &dqp->q_logitem.qli_flush_lsn,
>  					&dqp->q_logitem.qli_item.li_lsn);
> @@ -1227,7 +1227,7 @@ xfs_qm_dqflush(
>  	return 0;
>  
>  out_abort:
> -	dqp->dq_flags &= ~XFS_DQ_DIRTY;
> +	dqp->q_flags &= ~XFS_DQFLAG_DIRTY;
>  	xfs_trans_ail_delete(lip, 0);
>  	xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
>  out_unlock:
> diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
> index 077d0988cff9..7f3f734bced8 100644
> --- a/fs/xfs/xfs_dquot.h
> +++ b/fs/xfs/xfs_dquot.h
> @@ -31,10 +31,10 @@ enum {
>   * The incore dquot structure
>   */
>  struct xfs_dquot {
> -	uint			dq_flags;
>  	struct list_head	q_lru;
>  	struct xfs_mount	*q_mount;
>  	xfs_dqtype_t		q_type;
> +	uint16_t		q_flags;
>  	uint			q_nrefs;
>  	xfs_daddr_t		q_blkno;
>  	int			q_bufoffset;
> @@ -152,7 +152,7 @@ static inline bool xfs_dquot_lowsp(struct xfs_dquot *dqp)
>  }
>  
>  #define XFS_DQ_IS_LOCKED(dqp)	(mutex_is_locked(&((dqp)->q_qlock)))
> -#define XFS_DQ_IS_DIRTY(dqp)	((dqp)->dq_flags & XFS_DQ_DIRTY)
> +#define XFS_DQ_IS_DIRTY(dqp)	((dqp)->q_flags & XFS_DQFLAG_DIRTY)
>  #define XFS_QM_ISUDQ(dqp)	((dqp)->q_type == XFS_DQTYPE_USER)
>  #define XFS_QM_ISPDQ(dqp)	((dqp)->q_type == XFS_DQTYPE_PROJ)
>  #define XFS_QM_ISGDQ(dqp)	((dqp)->q_type == XFS_DQTYPE_GROUP)
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index 939ee728d9af..aabb08e85cd7 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -124,10 +124,10 @@ xfs_qm_dqpurge(
>  	int			error = -EAGAIN;
>  
>  	xfs_dqlock(dqp);
> -	if ((dqp->dq_flags & XFS_DQ_FREEING) || dqp->q_nrefs != 0)
> +	if ((dqp->q_flags & XFS_DQFLAG_FREEING) || dqp->q_nrefs != 0)
>  		goto out_unlock;
>  
> -	dqp->dq_flags |= XFS_DQ_FREEING;
> +	dqp->q_flags |= XFS_DQFLAG_FREEING;
>  
>  	xfs_dqflock(dqp);
>  
> @@ -148,7 +148,7 @@ xfs_qm_dqpurge(
>  			error = xfs_bwrite(bp);
>  			xfs_buf_relse(bp);
>  		} else if (error == -EAGAIN) {
> -			dqp->dq_flags &= ~XFS_DQ_FREEING;
> +			dqp->q_flags &= ~XFS_DQFLAG_FREEING;
>  			goto out_unlock;
>  		}
>  		xfs_dqflock(dqp);
> @@ -474,7 +474,7 @@ xfs_qm_dquot_isolate(
>  	/*
>  	 * Prevent lookups now that we are past the point of no return.
>  	 */
> -	dqp->dq_flags |= XFS_DQ_FREEING;
> +	dqp->q_flags |= XFS_DQFLAG_FREEING;
>  	xfs_dqunlock(dqp);
>  
>  	ASSERT(dqp->q_nrefs == 0);
> @@ -1113,7 +1113,7 @@ xfs_qm_quotacheck_dqadjust(
>  		xfs_qm_adjust_dqtimers(mp, dqp);
>  	}
>  
> -	dqp->dq_flags |= XFS_DQ_DIRTY;
> +	dqp->q_flags |= XFS_DQFLAG_DIRTY;
>  	xfs_qm_dqput(dqp);
>  	return 0;
>  }
> @@ -1219,7 +1219,7 @@ xfs_qm_flush_one(
>  	int			error = 0;
>  
>  	xfs_dqlock(dqp);
> -	if (dqp->dq_flags & XFS_DQ_FREEING)
> +	if (dqp->q_flags & XFS_DQFLAG_FREEING)
>  		goto out_unlock;
>  	if (!XFS_DQ_IS_DIRTY(dqp))
>  		goto out_unlock;
> diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
> index c7cb8a356c88..7f157275e370 100644
> --- a/fs/xfs/xfs_qm_syscalls.c
> +++ b/fs/xfs/xfs_qm_syscalls.c
> @@ -598,7 +598,7 @@ xfs_qm_scall_setqlim(
>  		 */
>  		xfs_qm_adjust_dqtimers(mp, dqp);
>  	}
> -	dqp->dq_flags |= XFS_DQ_DIRTY;
> +	dqp->q_flags |= XFS_DQFLAG_DIRTY;
>  	xfs_trans_log_dquot(tp, dqp);
>  
>  	error = xfs_trans_commit(tp);
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index f19e66da6646..0b6738070619 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -879,7 +879,7 @@ DECLARE_EVENT_CLASS(xfs_dquot_class,
>  		__entry->dev = dqp->q_mount->m_super->s_dev;
>  		__entry->id = be32_to_cpu(dqp->q_core.d_id);
>  		__entry->type = dqp->q_type;
> -		__entry->flags = dqp->dq_flags;
> +		__entry->flags = dqp->q_flags;
>  		__entry->nrefs = dqp->q_nrefs;
>  		__entry->res_bcount = dqp->q_res_bcount;
>  		__entry->bcount = be64_to_cpu(dqp->q_core.d_bcount);
> @@ -899,7 +899,7 @@ DECLARE_EVENT_CLASS(xfs_dquot_class,
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __entry->id,
>  		  __print_symbolic(__entry->type, XFS_DQTYPE_STRINGS),
> -		  __print_flags(__entry->flags, "|", XFS_DQ_FLAGS),
> +		  __print_flags(__entry->flags, "|", XFS_DQFLAG_STRINGS),
>  		  __entry->nrefs,
>  		  __entry->res_bcount,
>  		  __entry->bcount,
> diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
> index 964f69a444a3..bdbd8e88c772 100644
> --- a/fs/xfs/xfs_trans_dquot.c
> +++ b/fs/xfs/xfs_trans_dquot.c
> @@ -391,7 +391,7 @@ xfs_trans_apply_dquot_deltas(
>  				xfs_qm_adjust_dqtimers(tp->t_mountp, dqp);
>  			}
>  
> -			dqp->dq_flags |= XFS_DQ_DIRTY;
> +			dqp->q_flags |= XFS_DQFLAG_DIRTY;
>  			/*
>  			 * add this to the list of items to get logged
>  			 */
> 
> 


-- 
chandan



