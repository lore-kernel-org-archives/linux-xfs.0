Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43086 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751803AbcI3HfC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Sep 2016 03:35:02 -0400
Date: Fri, 30 Sep 2016 00:35:01 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 24/63] xfs: when replaying bmap operations, don't let
 unlinked inodes get reaped
Message-ID: <20160930073501.GE13587@infradead.org>
References: <147520472904.29434.15518629624221621056.stgit@birch.djwong.org>
 <147520489698.29434.13242363533695270347.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <147520489698.29434.13242363533695270347.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Thu, Sep 29, 2016 at 08:08:17PM -0700, Darrick J. Wong wrote:
> Log recovery will iget an inode to replay BUI items and iput the inode
> when it's done.  Unfortunately, the iput will see that i_nlink == 0
> and decide to truncate & free the inode, which prevents us from
> replaying subsequent BUIs.  We can't skip the BUIs because we have to
> replay all the redo items to ensure that atomic operations complete.
> 
> Since unlinked inode recovery will reap the inode anyway, we can
> safely introduce a new inode flag to indicate that an inode is in this
> 'unlinked recovery' state and should not be auto-reaped in the
> drop_inode path.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>
