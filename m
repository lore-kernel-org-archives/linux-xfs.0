Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:49294 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932291AbeDWV5L (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 Apr 2018 17:57:11 -0400
Date: Mon, 23 Apr 2018 14:57:04 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 05/13] xfs: split out dqget for inodes from regular dqget
Message-ID: <20180423215704.GE26268@magnolia>
References: <152440954198.29601.14390250048915099607.stgit@magnolia>
 <152440958392.29601.4865223638433656924.stgit@magnolia>
 <20180423172345.GE834@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180423172345.GE834@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Mon, Apr 23, 2018 at 07:23:46PM +0200, Christoph Hellwig wrote:
> > +int
> > +xfs_qm_dqget_inode(
> > +	struct xfs_mount	*mp,
> 
> As pointed out by Brian, we can skip passing this argument.
> 
> > +	struct xfs_inode	*ip,
> > +	uint			type,
> > +	uint			can_alloc,
> 
> can_alloc should probably be a bool, or passing XFS_QMOPT_DQALLOC
> directly.  

Later I just turn it into a 'dqmode' argument where you can pass
XFS_DQGET_ALLOC (read or alloc on-disk dquot) or XFS_DQGET_EXISTS (read
from disk, error out if it's not there).

It's tempting to make those an enum xfs_dqget_mode to enforce that,
maybe I'll send that as a patch 14.

--D

> 
> Otherwise looks fine:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
