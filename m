Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:57302 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750714AbeFEXyl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Jun 2018 19:54:41 -0400
Date: Tue, 5 Jun 2018 16:54:35 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 02/14] xfs: repair the AGI
Message-ID: <20180605235435.GP9437@magnolia>
References: <152770863951.11611.5866814627357136911.stgit@magnolia>
 <152770865219.11611.15383367715338540008.stgit@magnolia>
 <20180604015637.GK10363@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180604015637.GK10363@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Jun 04, 2018 at 11:56:38AM +1000, Dave Chinner wrote:
> On Wed, May 30, 2018 at 12:30:52PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Rebuild the AGI header items with some help from the rmapbt.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Looks OK, but I can't help but think it should be structured similar
> to the AGF rebuild, even though the functions would be smaller and
> simpler...
> 
> Thoughts?

Will do.

--D

> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
