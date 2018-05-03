Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:36920 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751036AbeECXTf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 May 2018 19:19:35 -0400
Date: Thu, 3 May 2018 16:19:32 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 0/2] xfs: clean up xfs_file_iomap_begin()
Message-ID: <20180503231932.GF26569@magnolia>
References: <20180502055144.28851-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180502055144.28851-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Wed, May 02, 2018 at 03:51:42PM +1000, Dave Chinner wrote:
> Hi folks,
> 
> These patches follow up on recent changes to the locking and
> non-blocking behaviour of xfs_file_iomap_begin() to make it easier
> to follow and understand. The code is a bit of a tangle right now,
> and these two patches pull all of the locking and NOWAIT decisions
> into a single function and out of all the mapping code.
> 
> There are no functional changes here, just a code re-org.

Looks ok, will test...
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> 
> Cheers,
> 
> Dave.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
