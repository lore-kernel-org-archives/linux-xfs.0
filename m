Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:56966 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753872AbeGHPm0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 8 Jul 2018 11:42:26 -0400
Date: Sun, 8 Jul 2018 08:42:26 -0700
Subject: Re: [PATCH RFC 2/8] xfs: introduce extents to local conversion helper
Message-ID: <20180708154226.GA8625@infradead.org>
References: <1530846750-6686-1-git-send-email-shan.hai@oracle.com>
 <1530846750-6686-3-git-send-email-shan.hai@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1530846750-6686-3-git-send-email-shan.hai@oracle.com>
From: Christoph Hellwig <hch@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Shan Hai <shan.hai@oracle.com>
Cc: linux-xfs@vger.kernel.org

>  /*
> + * Convert an inode from extents to the local format.
> + * Free all the extents of the inode and reset it to the local
> + * format. Copy the contents of the inode's blocks to the inode's
> + * literal area.
> + */

Please use up all 80 chars for your comments (and code)

> +int
> +xfs_bmap_extents_to_local(
> +	xfs_trans_t		*tp,
> +	xfs_inode_t		*ip,

Please use the struct types instead of the typedefs wherever possible.

> +	if (xfs_iext_count(ifp) == 0)
> +		goto init_local_fork;
> +
> +	for_each_xfs_iext(ifp, &icur, &got) {

for_each_xfs_iext should do the right thing for an empty fork.

> +out:
> +	return error;

Just return errors directly instead of going to a label that returns
the error.

> +}
> +
> +
> +/*

One blank line after a function body is enough.

