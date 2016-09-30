Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44421 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750853AbcI3Hm6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Sep 2016 03:42:58 -0400
Date: Fri, 30 Sep 2016 00:42:57 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 32/63] xfs: support allocating delayed extents in CoW fork
Message-ID: <20160930074257.GC951@infradead.org>
References: <147520472904.29434.15518629624221621056.stgit@birch.djwong.org>
 <147520494805.29434.17194986410231500471.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <147520494805.29434.17194986410231500471.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Thu, Sep 29, 2016 at 08:09:08PM -0700, Darrick J. Wong wrote:
> Modify xfs_bmap_add_extent_delay_real() so that we can convert delayed
> allocation extents in the CoW fork to real allocations, and wire this
> up all the way back to xfs_iomap_write_allocate().  In a subsequent
> patch, we'll modify the writepage handler to call this.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>
