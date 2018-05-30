Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:48764 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932459AbeE3XDJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 May 2018 19:03:09 -0400
Date: Thu, 31 May 2018 09:02:59 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 04/13] mm: split ->readpages calls to avoid
 non-contiguous pages lists
Message-ID: <20180530230259.GB10363@dastard>
References: <20180530095813.31245-1-hch@lst.de>
 <20180530095813.31245-5-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180530095813.31245-5-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org

On Wed, May 30, 2018 at 11:58:04AM +0200, Christoph Hellwig wrote:
> That way file systems don't have to go spotting for non-contiguous pages
> and work around them.  It also kicks off I/O earlier, allowing it to
> finish earlier and reduce latency.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks fine.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
