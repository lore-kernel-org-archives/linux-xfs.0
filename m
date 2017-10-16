Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:21063 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751817AbdJPUgn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Oct 2017 16:36:43 -0400
Date: Mon, 16 Oct 2017 13:36:39 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 17/30] xfs: scrub free space btrees
Message-ID: <20171016203639.GK4703@magnolia>
References: <150777244315.1724.6916081372861799350.stgit@magnolia>
 <150777255503.1724.7657235551348811131.stgit@magnolia>
 <20171016022558.GT3666@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171016022558.GT3666@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Oct 16, 2017 at 01:25:58PM +1100, Dave Chinner wrote:
> On Wed, Oct 11, 2017 at 06:42:35PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Check the extent records free space btrees to ensure that the values
> > look sane.
> 
> Minor thing:
> 
> > +/* Scrub a bnobt/cntbt record. */
> > +STATIC int
> > +xfs_scrub_allocbt_helper(
> 
> xfs_scrub_allocbt_rec()
> 
> Reads much more nicely with this name. :P

<nod> Will change as I go through the patches.

--D

> Otherwise, consider it:
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> 
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
