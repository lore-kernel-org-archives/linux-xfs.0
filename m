Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 31 Aug 2008 22:00:21 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m814xxbU026918
	for <xfs@oss.sgi.com>; Sun, 31 Aug 2008 22:00:04 -0700
Date: Mon, 1 Sep 2008 01:00:45 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [REVIEW #2]  Update kernel code to compile in userspace
	(libxfs)
Message-ID: <20080901050045.GA1396@infradead.org>
References: <op.ugmy3u2o3jf8g2@pc-bnaujok.melbourne.sgi.com> <op.ugm1ttzb3jf8g2@pc-bnaujok.melbourne.sgi.com> <20080829181120.GA9455@infradead.org> <op.ugr4zpyv3jf8g2@pc-bnaujok.melbourne.sgi.com> <20080901015950.GA16825@infradead.org> <op.ugr5hsao3jf8g2@pc-bnaujok.melbourne.sgi.com> <20080901020826.GA31724@infradead.org> <op.ugsdamyd3jf8g2@pc-bnaujok.melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <op.ugsdamyd3jf8g2@pc-bnaujok.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

> --- 2.6.x-xfs.orig/fs/xfs/xfs_ag.h
> +++ 2.6.x-xfs/fs/xfs/xfs_ag.h
> @@ -192,15 +192,16 @@ typedef struct xfs_perag
>  	xfs_agino_t	pagi_freecount;	/* number of free inodes */
>  	xfs_agino_t	pagi_count;	/* number of allocated inodes */
>  	int		pagb_count;	/* pagb slots in use */
> +	xfs_perag_busy_t *pagb_list;	/* unstable blocks */
>  #ifdef __KERNEL__
>  	spinlock_t	pagb_lock;	/* lock for pagb_list */
> -#endif
> -	xfs_perag_busy_t *pagb_list;	/* unstable blocks */
> +

Inside structures we should be more careful about reordering,
but this one looks fine becaus pagb_list and pagb_lock should
be in the same cache line either way.

The rest looks good, too.
