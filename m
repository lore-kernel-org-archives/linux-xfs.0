Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 08 Oct 2008 11:48:06 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m98Im4Wf012203
	for <xfs@oss.sgi.com>; Wed, 8 Oct 2008 11:48:04 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 86B6013C00ED
	for <xfs@oss.sgi.com>; Wed,  8 Oct 2008 11:49:28 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id W5hGn6oBlWHvAnr4 for <xfs@oss.sgi.com>; Wed, 08 Oct 2008 11:49:28 -0700 (PDT)
Date: Wed, 8 Oct 2008 14:49:28 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/7] XFS: replace fixed size busy extent array with an
	rbtree
Message-ID: <20081008184928.GB6823@infradead.org>
References: <1223417377-8679-1-git-send-email-david@fromorbit.com> <1223417377-8679-3-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1223417377-8679-3-git-send-email-david@fromorbit.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

> @@ -131,14 +131,8 @@ STATIC void
>  xfs_free_perag(
>  	xfs_mount_t	*mp)
>  {
> -	if (mp->m_perag) {
> -		int	agno;
> -
> -		for (agno = 0; agno < mp->m_maxagi; agno++)
> -			if (mp->m_perag[agno].pagb_list)
> -				kmem_free(mp->m_perag[agno].pagb_list);
> +	if (mp->m_perag)
>  		kmem_free(mp->m_perag);
> -	}

kmem_free(NULL) is fine, so no need for the if.  And with that there's
no need for this one-line wrapper and we can just do the free in the
caller.

>  typedef struct xfs_log_busy_slot {
> -	xfs_agnumber_t		lbc_ag;
> -	ushort			lbc_idx;	/* index in perag.busy[] */
> +	struct xfs_busy_extent	*lbc_busyp;
>  } xfs_log_busy_slot_t;

Just use xfs_busy_extent directly - there's only about a handful places
using xfs_log_busy_slot anyway.

>  xfs_log_busy_slot_t *
> -xfs_trans_add_busy(xfs_trans_t *tp, xfs_agnumber_t ag, xfs_extlen_t idx)
> +xfs_trans_add_busy(
> +	xfs_trans_t		*tp,
> +	struct xfs_busy_extent	*busyp)

And this one can lose it's return value.  It's always the second
argmument and ignored by all callers anyway.
