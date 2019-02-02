Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:34992 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725828AbfBBQaH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 2 Feb 2019 11:30:07 -0500
Date: Sat, 2 Feb 2019 08:30:07 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 6/8] xfs: hoist unlinked list search and mapping to a
 separate function
Message-ID: <20190202163007.GD25154@infradead.org>
References: <154897667054.26065.13164381203002725289.stgit@magnolia>
 <154897670777.26065.9017810401812180528.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <154897670777.26065.9017810401812180528.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

Nitpick: why hoist here and refactor in the previous patches subject?

> +	xfs_agino_t		target_agino,
> +	xfs_ino_t		*ino,
> +	struct xfs_imap		*imap,
> +	struct xfs_dinode	**dipp,
> +	struct xfs_buf		**bpp)
> +{
> +	struct xfs_imap		last_imap;
> +	struct xfs_mount	*mp = tp->t_mountp;
> +	struct xfs_buf		*last_ibp = NULL;
> +	struct xfs_dinode	*last_dip;
> +	xfs_ino_t		next_ino = NULLFSINO;
> +	xfs_agino_t		next_agino;
> +	int			error;
> +
> +	ASSERT(head_agino != target_agino);
> +
> +	next_agino = head_agino;
> +	while (next_agino != target_agino) {
> +		xfs_agino_t	unlinked_agino;
> +
> +		if (last_ibp)
> +			xfs_trans_brelse(tp, last_ibp);
> +
> +		next_ino = XFS_AGINO_TO_INO(mp, pag->pag_agno, next_agino);
> +		error = xfs_iunlink_map_ino(tp, next_ino, &last_imap,
> +				&last_dip, &last_ibp);

And reason we stop formatting directly into the passed in imap,
as the old code did?
