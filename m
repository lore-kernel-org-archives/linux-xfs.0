Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:2211 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1162327AbeCAWBj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Mar 2018 17:01:39 -0500
Date: Fri, 2 Mar 2018 09:01:20 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/3] xfs: don't allocate COW blocks for zeroing holes or
 unwritten extents
Message-ID: <20180301220120.GL30854@dastard>
References: <20180228174552.31919-1-hch@lst.de>
 <20180228174552.31919-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180228174552.31919-2-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Wed, Feb 28, 2018 at 09:45:50AM -0800, Christoph Hellwig wrote:
> The iomap zeroing interface is smart enough to skip zeroing holes or
> unwritten extents.  Don't subvert this logic for reflink files.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good,

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
