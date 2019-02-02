Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:37394 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726082AbfBBQvK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 2 Feb 2019 11:51:10 -0500
Date: Sat, 2 Feb 2019 08:51:10 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 6/8] xfs: hoist unlinked list search and mapping to a
 separate function
Message-ID: <20190202165109.GA18160@infradead.org>
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

> +/* Return the imap, dinode pointer, and buffer for an inode. */
> +STATIC int
> +xfs_iunlink_map_ino(
> +	struct xfs_trans	*tp,
> +	xfs_ino_t		next_ino,
> +	struct xfs_imap		*imap,
> +	struct xfs_dinode	**dipp,
> +	struct xfs_buf		**bpp)
> +{
> +	struct xfs_mount	*mp = tp->t_mountp;
> +	int			error;
> +
> +	imap->im_blkno = 0;
> +	error = xfs_imap(mp, tp, next_ino, imap, 0);

Looking at the next patch it actually would be nicer if we'd pass
agno/agino instead of the inode number to this function,
as currently both callers need to duplicate the caculation of the
ino.

In fact the first thing xfs_imap does is to split the ino into agno
and agino again, so maybe we should throw in a prep patch to change
the xfs_imap calling convention as well.
