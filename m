Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 21 Jul 2008 21:27:25 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6M4RL18014529
	for <xfs@oss.sgi.com>; Mon, 21 Jul 2008 21:27:21 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 45B8A311127
	for <xfs@oss.sgi.com>; Mon, 21 Jul 2008 21:28:31 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id 21uXZaqCm50QpK1V for <xfs@oss.sgi.com>; Mon, 21 Jul 2008 21:28:31 -0700 (PDT)
Date: Tue, 22 Jul 2008 00:28:29 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/4] XFS: Use the inode tree for finding dirty inodes
Message-ID: <20080722042829.GB27123@infradead.org>
References: <1216556394-17529-1-git-send-email-david@fromorbit.com> <1216556394-17529-3-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1216556394-17529-3-git-send-email-david@fromorbit.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Sun, Jul 20, 2008 at 10:19:52PM +1000, Dave Chinner wrote:
> Update xfs_sync_inodes to walk the inode radix tree cache to find
> dirty inodes. This removes a huge bunch of nasty, messy code for
> traversing the mount inode list safely and removes another user of
> the mount inode list.

Looks good, some minor nits below:

>  	xfs_inode_t	*ip = NULL;
>  	bhv_vnode_t	*vp = NULL;

As you're touching most uses of vp what about just turning it
into a plain Linux inode?

> +	if (!pag->pag_ici_init)
> +		return 0;

I think it would be cleaner to move this into the caller and not even
call into this function for uninitialized AGs.

> +		read_lock(&pag->pag_ici_lock);
> +		nr_found = radix_tree_gang_lookup(&pag->pag_ici_root,
> +				(void**)&ip, first_index, 1);

This needs a big comment on why you're using the gang lookup for
a single lookup.  I guess that's because the gang lookup skips to
the next actually existing entry instead of returning NULL, but that's
not really obvious to the reader.

> +			VN_RELE(vp);

This should either be an iput or IRELE, VN_RELE is on it's way out.

Btw, all these also apply to the next patch, I won't comment on them
there again.
