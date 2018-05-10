Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:54886 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964827AbeEJPUa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 May 2018 11:20:30 -0400
Date: Thu, 10 May 2018 08:20:05 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 09/13] xfs: remove direct calls to _qm_dqread
Message-ID: <20180510152005.GX11261@magnolia>
References: <152506698177.21553.13500862866416804148.stgit@magnolia>
 <152506705098.21553.6894396720813018127.stgit@magnolia>
 <20180508000535.GZ11261@magnolia>
 <20180510082600.GA13114@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180510082600.GA13114@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, bfoster@redhat.com, Dave Chinner <david@fromorbit.com>

On Thu, May 10, 2018 at 10:26:00AM +0200, Christoph Hellwig wrote:
> On Mon, May 07, 2018 at 05:05:35PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > The quota initialization code needs an "uncached" variant of _dqget to
> > read in default quota limits and timers before the dquot cache is fully
> > set up.  We've already split up _dqget into its component pieces so
> > create a fourth variant to address this need, and make dqread internal
> > to xfs_dquot.c again.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Looks fine,
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> But can you please resend the whole series?  I've lost track of all the
> updates..

Will do.  I'll also try to push all the accumulated/reviewed 4.18 stuff
to for-next in time for tomorrow's tree.

--D

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
