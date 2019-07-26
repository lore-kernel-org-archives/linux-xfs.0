Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:40486 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725909AbfGZGh3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 26 Jul 2019 02:37:29 -0400
Date: Thu, 25 Jul 2019 23:37:29 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2] xfs: fix stack contents leakage in the v1 inumber
 ioctls
Message-ID: <20190726063728.GA316@infradead.org>
References: <20190725175346.GF1561054@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190725175346.GF1561054@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>, Eric Sandeen <sandeen@redhat.com>

On Thu, Jul 25, 2019 at 10:53:46AM -0700, Darrick J. Wong wrote:
> Explicitly initialize the onstack structures to zero so we don't leak
> kernel memory into userspace when converting the in-core inumbers
> structure to the v1 inogrp ioctl structure.  Add a comment about why we
> have to use memset to ensure that the padding holes in the structures
> are set to zero.
> 
> Fixes: 5f19c7fc6873351 ("xfs: introduce v5 inode group structure")
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> v2: add comments, use memset this time

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
