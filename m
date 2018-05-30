Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:50783 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932416AbeE3XJH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 May 2018 19:09:07 -0400
Date: Thu, 31 May 2018 09:09:05 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 08/13] iomap: use __bio_add_page in iomap_dio_zero
Message-ID: <20180530230905.GF10363@dastard>
References: <20180530095813.31245-1-hch@lst.de>
 <20180530095813.31245-9-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180530095813.31245-9-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org

On Wed, May 30, 2018 at 11:58:08AM +0200, Christoph Hellwig wrote:
> We don't need any merging logic, and this also replaces a BUG_ON with a
> WARN_ON_ONCE inside __bio_add_page for the impossible overflow condition.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
