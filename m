Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:40017 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750772AbeAQAg4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Jan 2018 19:36:56 -0500
Date: Wed, 17 Jan 2018 11:36:42 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 07/21] xfs: add scrub cross-referencing helpers for
 the inode btrees
Message-ID: <20180117003642.GC6304@dastard>
References: <151398977028.18741.12031215574014508438.stgit@magnolia>
 <151398981557.18741.8176324698766997260.stgit@magnolia>
 <20180105215145.GK5602@magnolia>
 <20180116230536.GY5602@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180116230536.GY5602@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Jan 16, 2018 at 03:05:36PM -0800, Darrick J. Wong wrote:
> On Fri, Jan 05, 2018 at 01:51:45PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Add a couple of functions to the inode btrees that will be used
> > to cross-reference metadata against the inobt.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> > v2: minor fixes suggested by dchinner
> 
> Ping?

Oh, sorry, I missed this when going back through all the updates
that needed review...

.....
> > +struct xfs_ialloc_count_inodes {
> > +	xfs_agino_t			count;
> > +	xfs_agino_t			freecount;
> > +};
> > +
> > +/* Record inode counts across all inobt records. */
> > +STATIC int
> > +xfs_ialloc_count_inodes_helper(

xfs_ialloc_count_inodes_rec(), like a recent comment I made
reviewing a later patch.

Otherwise looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>


-- 
Dave Chinner
david@fromorbit.com
