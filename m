Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:34906 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726004AbfBHH5H (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Feb 2019 02:57:07 -0500
Date: Thu, 7 Feb 2019 23:57:06 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 6/9] xfs: refactor unlinked list search and mapping to a
 separate function
Message-ID: <20190208075706.GA5523@infradead.org>
References: <154947207759.22369.11575570374120223292.stgit@magnolia>
 <154947211711.22369.10227484386880189461.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <154947211711.22369.10227484386880189461.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Feb 06, 2019 at 08:55:17AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> There's a loop that searches an unlinked bucket list to find the inode
> that points to a given inode.  Hoist this into a separate function;
> later we'll use our iunlink backref cache to bypass the slow list
> operation.  No functional changes.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
