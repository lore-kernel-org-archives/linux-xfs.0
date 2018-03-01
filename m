Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sweaglesw.org ([216.129.123.154]:60682 "EHLO sweaglesw.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1162606AbeCAWh2 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 1 Mar 2018 17:37:28 -0500
Date: Thu, 1 Mar 2018 14:28:58 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
Subject: Re: [PATCH 1/3] xfs: don't allocate COW blocks for zeroing holes or
 unwritten extents
Message-ID: <20180301222858.GE8126@sweaglesw.org>
Reply-To: djwong@djwong.org
References: <20180228174552.31919-1-hch@lst.de>
 <20180228174552.31919-2-hch@lst.de>
 <20180301220120.GL30854@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180301220120.GL30854@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Fri, Mar 02, 2018 at 09:01:20AM +1100, Dave Chinner wrote:
> On Wed, Feb 28, 2018 at 09:45:50AM -0800, Christoph Hellwig wrote:
> > The iomap zeroing interface is smart enough to skip zeroing holes or
> > unwritten extents.  Don't subvert this logic for reflink files.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Looks good,
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>

Looks ok, will test.
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

Oracle mail and vger are having some sort of idiotic slapfest, which
means I haven't received any list traffic in 2 days.  Please cc me on
patches so that review isn't delayed. :)

--D

> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
