Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:53046 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725882AbfDWGTx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Apr 2019 02:19:53 -0400
Date: Mon, 22 Apr 2019 23:19:52 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: unlock inode when xfs_ioctl_setattr_get_trans can't
 get transaction
Message-ID: <20190423061952.GA28518@infradead.org>
References: <20190422182541.GA4676@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190422182541.GA4676@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>

On Mon, Apr 22, 2019 at 11:25:41AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> We passed an inode into xfs_ioctl_setattr_get_trans with join_flags
> indicating which locks are held on that inode.  If we can't allocate a
> transaction then we need to unlock the inode before we bail out, like
> all the other error paths do.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
