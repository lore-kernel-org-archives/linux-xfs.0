Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:40462 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753150AbcI3HNQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Sep 2016 03:13:16 -0400
Date: Fri, 30 Sep 2016 00:13:14 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 14/63] xfs: connect refcount adjust functions to upper
 layers
Message-ID: <20160930071314.GF18305@infradead.org>
References: <147520472904.29434.15518629624221621056.stgit@birch.djwong.org>
 <147520482520.29434.12158124022433689078.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <147520482520.29434.12158124022433689078.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

>  DEFINE_AG_EXTENT_EVENT(xfs_refcount_find_shared_result);
>  DEFINE_AG_ERROR_EVENT(xfs_refcount_find_shared_error);
> +#define DEFINE_REFCOUNT_DEFERRED_EVENT DEFINE_PHYS_EXTENT_DEFERRED_EVENT
> +DEFINE_REFCOUNT_DEFERRED_EVENT(xfs_refcount_defer);
> +DEFINE_REFCOUNT_DEFERRED_EVENT(xfs_refcount_deferred);

What is the value add of the #define above?

Otherwise this looks fine to me:

Reviewed-by: Christoph Hellwig <hch@lst.de>
