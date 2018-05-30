Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:4927 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932416AbeE3XFF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 May 2018 19:05:05 -0400
Date: Thu, 31 May 2018 09:05:02 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 05/13] iomap: inline data should be an iomap type, not a
 flag
Message-ID: <20180530230502.GC10363@dastard>
References: <20180530095813.31245-1-hch@lst.de>
 <20180530095813.31245-6-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180530095813.31245-6-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org

On Wed, May 30, 2018 at 11:58:05AM +0200, Christoph Hellwig wrote:
> Inline data is fundamentally different from our normal mapped case in that
> it doesn't even have a block address.  So instead of having a flag for it
> it should be an entirely separate iomap range type.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
