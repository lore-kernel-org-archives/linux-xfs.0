Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:50102 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725783AbeJ0EDS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 27 Oct 2018 00:03:18 -0400
Date: Fri, 26 Oct 2018 12:24:58 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] libxfs: check all defer ops types
Message-ID: <20181026192458.GA8643@infradead.org>
References: <20181026161905.GH28243@magnolia>
 <0dc53e1c-2ad6-b04f-2747-451b6760e1d5@sandeen.net>
 <d13db2aa-3e73-7dd6-8677-7e19f9b7ffcd@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d13db2aa-3e73-7dd6-8677-7e19f9b7ffcd@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Eric Sandeen <sandeen@redhat.com>, xfs <linux-xfs@vger.kernel.org>

On Fri, Oct 26, 2018 at 02:11:47PM -0500, Eric Sandeen wrote:
> static const struct
> xfs_defer_op_type *defer_op_types[XFS_DEFER_OPS_TYPE_MAX] = {
>        xfs_bmap_update_defer_type,
>        xfs_refcount_update_defer_type,
>        xfs_rmap_update_defer_type,
>        xfs_extent_free_defer_type,
>        xfs_agfl_free_defer_type,
> };

I think this should be:

static const struct xfs_defer_op_type *defer_op_types[] = {
	[XFS_DEFER_OPS_TYPE_BMAP]	= &xfs_bmap_update_defer_type,
	[XFS_DEFER_OPS_TYPE_REFCOUNT]	= &xfs_refcount_update_defer_type,
	[XFS_DEFER_OPS_TYPE_RMAP]	= &xfs_rmap_update_defer_type,
	[XFS_DEFER_OPS_TYPE_FREE]	= &xfs_extent_free_defer_type,
	[XFS_DEFER_OPS_TYPE_AGFL_FREE]	= &xfs_agfl_free_defer_type,
};

somefunc()
{
	BUILD_BUG_ON(ARRAY_SIZE(defer_op_types) != XFS_DEFER_OPS_TYPE_MAX);
}
