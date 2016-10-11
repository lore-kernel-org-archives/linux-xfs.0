Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:26226 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751297AbcJKHpN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Oct 2016 03:45:13 -0400
Date: Tue, 11 Oct 2016 18:38:25 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: convert COW blocks to real blocks before unwritten
 extent conversion
Message-ID: <20161011073825.GI23194@dastard>
References: <1476104794-28175-1-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1476104794-28175-1-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, darrick.wong@oracle.com

On Mon, Oct 10, 2016 at 03:06:34PM +0200, Christoph Hellwig wrote:
> We need to splice COW blocks we've completed in xfs_end_io_direct_write
> into the data fork before converting unwritten extents.  Otherwise
> xfs_bmapi_write might first allocate blocks for any holes in the data
> fork, which isn't only not needed but also harmful as it might cause
> reserved block underruns in the transaction.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Committed and pushe dout to the for-next branch (commit
feac470e3642e8956ac9b7f14224e6b301b9219d). If there's no more
late-breaking, urgent fixes, then this is what I'll ask Linus to
pull tomorrow....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
