Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:35067 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1162308AbeCAWDD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Mar 2018 17:03:03 -0500
Date: Fri, 2 Mar 2018 09:02:31 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/3] xfs: don't start out with the exclusive ilock for
 direct I/O
Message-ID: <20180301220231.GM30854@dastard>
References: <20180228174552.31919-1-hch@lst.de>
 <20180228174552.31919-3-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180228174552.31919-3-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Wed, Feb 28, 2018 at 09:45:51AM -0800, Christoph Hellwig wrote:
> There is no reason to take the ilock exclusively at the start of
> xfs_file_iomap_begin for direct I/O, given that it will be demoted
> just before calling xfs_iomap_write_direct anyway.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Seems to work fine, and reverts us back to the per-iomap behaviour.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
