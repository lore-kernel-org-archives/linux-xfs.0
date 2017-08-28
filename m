Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:46148 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751282AbdH1JZo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Aug 2017 05:25:44 -0400
Date: Mon, 28 Aug 2017 02:25:43 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/9] xfs: remove unnecessary dirty bli format check for
 ordered bufs
Message-ID: <20170828092543.GB28514@infradead.org>
References: <20170825150557.43010-1-bfoster@redhat.com>
 <20170825150557.43010-3-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170825150557.43010-3-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

This looks generally good, but I have a few nitpicks, too :)

On Fri, Aug 25, 2017 at 11:05:50AM -0400, Brian Foster wrote:
> -	bool			clean;
> +	bool			dirty;
>  	bool			aborted;
> +	bool			ordered;

Can we just initialize all these variables here at the declaration

> +	 * The bli dirty state should match whether the blf has logged segments
> +	 * except for ordered buffers, where only the bli should be dirty.
>  	 */
> +	dirty = (flags & XFS_BLI_DIRTY) ? true : false;
> +	ordered = (flags & XFS_BLI_ORDERED) ? true : false;

No need for the "? true : false" both for these two and the existing
aborted case.

> +/*
> + * Return true if the buffer has any ranges logged/dirtied by a transaction,
> + * false otherwise.
> + */
> +bool
> +xfs_buf_item_dirty_format(

Do you need this outside of xfs_buf_item.c later?

