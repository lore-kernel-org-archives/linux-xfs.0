Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 04 Aug 2008 17:49:21 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m750nJ0q020593
	for <xfs@oss.sgi.com>; Mon, 4 Aug 2008 17:49:19 -0700
Received: from ipmail04.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 853C519844B3
	for <xfs@oss.sgi.com>; Mon,  4 Aug 2008 17:50:31 -0700 (PDT)
Received: from ipmail04.adl2.internode.on.net (ipmail04.adl2.internode.on.net [203.16.214.57]) by cuda.sgi.com with ESMTP id ggd2JBrNNTOblqyt for <xfs@oss.sgi.com>; Mon, 04 Aug 2008 17:50:31 -0700 (PDT)
Date: Tue, 5 Aug 2008 10:50:13 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 20/26] move xfs_bmbt_newroot to common code
Message-ID: <20080805005013.GK6119@disturbed>
References: <20080804013530.GU8819@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080804013530.GU8819@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Mon, Aug 04, 2008 at 03:35:30AM +0200, Christoph Hellwig wrote:
> xfs_bmbt_newroot is a mostly generic implementation of moving from
> an inode root to a real block based root.  So move it to xfs_btree.c
> where it can use all the nice infrastructure there and make it pointer
> size agnostic
> 
> The new name for it is xfs_btree_iroot_to_root which is not very
> nice but at least slightly more descriptive than the old name.

.....
> +
> +	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
> +	XFS_BTREE_STATS_INC(cur, newroot);
> +
> +	level = cur->bc_nlevels - 1;
> +	/* XXX(hch): this should be an get_inode_from_root, right? */
> +	block = xfs_btree_get_block(cur, level, &bp);

Yes, probably should be. Also an assert to ensure the btree does
have the root in inode falg set might be appropriate....

Otherwise looks fine.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
