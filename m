Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:36147 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932459AbeE3XCY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 May 2018 19:02:24 -0400
Date: Thu, 31 May 2018 09:02:18 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 03/13] mm: return an unsigned int from
 __do_page_cache_readahead
Message-ID: <20180530230218.GA10363@dastard>
References: <20180530095813.31245-1-hch@lst.de>
 <20180530095813.31245-4-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180530095813.31245-4-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org

On Wed, May 30, 2018 at 11:58:03AM +0200, Christoph Hellwig wrote:
> We never return an error, so switch to returning an unsigned int.  Most
> callers already did implicit casts to an unsigned type, and the one that
> didn't can be simplified now.
> 
> Suggested-by: Matthew Wilcox <willy@infradead.org>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

Makes sense.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
