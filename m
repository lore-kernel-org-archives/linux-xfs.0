Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:59670 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750740AbeAPG4E (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Jan 2018 01:56:04 -0500
Date: Mon, 15 Jan 2018 22:55:59 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2 21/21] xfs: cross-reference the block mappings when
 possible
Message-ID: <20180116065559.GL5602@magnolia>
References: <151398977028.18741.12031215574014508438.stgit@magnolia>
 <151398990147.18741.17837826861246689519.stgit@magnolia>
 <20180109212633.GP5602@magnolia>
 <20180116025855.GG16421@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180116025855.GG16421@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Jan 16, 2018 at 01:58:55PM +1100, Dave Chinner wrote:
> On Tue, Jan 09, 2018 at 01:26:33PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Use an inode's block mappings to cross-reference inode block counters.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> > v2: streamline scrubber arguments, remove stack allocated objects
> > ---
> >  fs/xfs/scrub/inode.c |   34 ++++++++++++++++++++++++++++++++++
> >  1 file changed, 34 insertions(+)
> 
> Looks fine.
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>

Wooo, thanks for the review!

--D

> 
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
