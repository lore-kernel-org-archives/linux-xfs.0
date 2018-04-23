Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:54894 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932136AbeDWRWX (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 23 Apr 2018 13:22:23 -0400
Date: Mon, 23 Apr 2018 19:23:46 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 05/13] xfs: split out dqget for inodes from regular
        dqget
Message-ID: <20180423172345.GE834@lst.de>
References: <152440954198.29601.14390250048915099607.stgit@magnolia> <152440958392.29601.4865223638433656924.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152440958392.29601.4865223638433656924.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, hch@lst.de

> +int
> +xfs_qm_dqget_inode(
> +	struct xfs_mount	*mp,

As pointed out by Brian, we can skip passing this argument.

> +	struct xfs_inode	*ip,
> +	uint			type,
> +	uint			can_alloc,

can_alloc should probably be a bool, or passing XFS_QMOPT_DQALLOC
directly.  

Otherwise looks fine:

Reviewed-by: Christoph Hellwig <hch@lst.de>
