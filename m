Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:3053 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726493AbeJZT3Y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 26 Oct 2018 15:29:24 -0400
Date: Fri, 26 Oct 2018 21:52:45 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/5] xfs: factor data block addition from
 xfs_dir2_node_addname_int()
Message-ID: <20181026105245.GF19305@dastard>
References: <20181024225716.19459-1-david@fromorbit.com>
 <20181024225716.19459-3-david@fromorbit.com>
 <20181026094529.GA29302@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181026094529.GA29302@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org

On Fri, Oct 26, 2018 at 02:45:29AM -0700, Christoph Hellwig wrote:
> > +	} else {
> > +found_block:
> 
> This jumping into branch is a little ugly, but given that the next
> patch cleans it up it is probably ok.
> 
> > +		/* suppress gcc maybe-used-initialised warning */
> > +		bests = dp->d_ops->free_bests_p(free);
> 
> > -	 * If the freespace entry is now wrong, update it.
> > -	 */
> > -	bests = dp->d_ops->free_bests_p(free); /* gcc is so stupid */
> 
> So this moves bests from the common path of execution into the
> branch, where it duplicates one in the other branch just for later
> patches to move it back to almost where it was.  If it isn't to
> painful to redo the patch I'd suggest to just keep it in the common
> path here.

Which causes build warnings because gcc can't work out the code flow
if I leave it alone. And seeing as I use -Werror on the fs/xfs/
directories, that breaks the build.

So I'd prefer to leave it like this without a transient build
warning....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
