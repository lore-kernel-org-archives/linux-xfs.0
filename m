Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:45459 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753090AbdLNQiz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Dec 2017 11:38:55 -0500
Date: Thu, 14 Dec 2017 08:38:54 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/6] xfs: relax is_reflink_inode assert in
 xfs_reflink_find_cow_mapping
Message-ID: <20171214163854.GD32616@infradead.org>
References: <151295857424.30614.8269461794142248028.stgit@magnolia>
 <151295860143.30614.17097584029425726245.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151295860143.30614.17097584029425726245.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Sun, Dec 10, 2017 at 06:16:41PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> We don't hold the ilock through the entire sequence of xfs_writepage_map
> -> xfs_map_cow -> xfs_reflink_find_cow_mapping.  This means that we can
> race with another thread that is trying to clear the inode reflink flag,
> with the result that the flag is set for the xfs_map_cow check but
> cleared before we get to the assert in find_cow_mapping.  When this
> happens, we blow the assert even though everything is fine.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
