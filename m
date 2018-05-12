Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:44110 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750776AbeELCBc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 11 May 2018 22:01:32 -0400
Date: Sat, 12 May 2018 12:01:30 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 04/10] xfs: factor ag btree root block initialisation
Message-ID: <20180512020130.GY10363@dastard>
References: <20180511225107.27171-1-david@fromorbit.com>
 <20180511225107.27171-5-david@fromorbit.com>
 <20180512004835.GQ11261@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180512004835.GQ11261@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Fri, May 11, 2018 at 05:48:35PM -0700, Darrick J. Wong wrote:
> On Sat, May 12, 2018 at 08:51:01AM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Cookie cutter code, easily factored.
> > 
> > Signed-Off-By: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/xfs_fsops.c | 485 ++++++++++++++++++++++++---------------------
> >  1 file changed, 263 insertions(+), 222 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> > index 4b560caaf397..4dbb7b41aeca 100644
> > --- a/fs/xfs/xfs_fsops.c
> > +++ b/fs/xfs/xfs_fsops.c
> > @@ -71,46 +71,141 @@ xfs_growfs_get_hdr_buf(
> >  	return bp;
> >  }
> >  
> > +struct aghdr_init_data {
> > +	/* per ag data */
> > +	xfs_agblock_t		agno;
> 
> xfs_agnumber_t ?

Oops, yes.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
