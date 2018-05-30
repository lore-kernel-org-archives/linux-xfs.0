Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:57407 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932416AbeE3XIq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 May 2018 19:08:46 -0400
Date: Thu, 31 May 2018 09:08:44 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 07/13] iomap: move IOMAP_F_BOUNDARY to gfs2
Message-ID: <20180530230844.GE10363@dastard>
References: <20180530095813.31245-1-hch@lst.de>
 <20180530095813.31245-8-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180530095813.31245-8-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org

On Wed, May 30, 2018 at 11:58:07AM +0200, Christoph Hellwig wrote:
> Just define a range of fs specific flags and use that in gfs2 instead of
> exposing this internal flag flobally.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

Makes sense to have a private range for the flags - cleans this up
nicely.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
