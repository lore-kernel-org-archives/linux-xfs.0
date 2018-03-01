Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:20699 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1161413AbeCAWEs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Mar 2018 17:04:48 -0500
Date: Fri, 2 Mar 2018 09:04:16 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/3] xfs: don't block on the ilock for RWF_NOWAIT
Message-ID: <20180301220416.GN30854@dastard>
References: <20180228174552.31919-1-hch@lst.de>
 <20180228174552.31919-4-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180228174552.31919-4-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Wed, Feb 28, 2018 at 09:45:52AM -0800, Christoph Hellwig wrote:
> Fix xfs_file_iomap_begin to trylock the ilock if IOMAP_NOWAIT is passed,
> so that we don't block io_submit callers.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

I'm not really happy with the locking mess we've created, but I have
patches on top of this to clean it up a bit. SO as a stepping
stone,

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
