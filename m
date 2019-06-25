Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:55900 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726756AbfFYKju (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Jun 2019 06:39:50 -0400
Date: Tue, 25 Jun 2019 03:39:49 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/6] libxfs: fix uncached buffer refcounting
Message-ID: <20190625103949.GE30156@infradead.org>
References: <156114701371.1643538.316410894576032261.stgit@magnolia>
 <156114703289.1643538.16263048212251920271.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156114703289.1643538.16263048212251920271.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: sandeen@sandeen.net, linux-xfs@vger.kernel.org

On Fri, Jun 21, 2019 at 12:57:12PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Currently, uncached buffers in userspace are created with zero refcount
> and are fed to cache_node_put when they're released.  This is totally
> broken -- the refcount should be 1 (because the caller now holds a
> reference) and we should never be dumping uncached buffers into the
> cache.  Fix both of these problems.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
