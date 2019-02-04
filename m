Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:38282 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725855AbfBDU64 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Feb 2019 15:58:56 -0500
Date: Mon, 4 Feb 2019 12:58:55 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 08/10] xfs: refactor inode update in iunlink_remove
Message-ID: <20190204205855.GG30334@infradead.org>
References: <154930313674.31814.17994684613232167921.stgit@magnolia>
 <154930319253.31814.2352584428677696706.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <154930319253.31814.2352584428677696706.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Feb 04, 2019 at 09:59:52AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> In xfs_iunlink_remove we have two identical calls to
> xfs_iunlink_update_inode, so move it out of the if statement to simplify
> the code some more.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
