Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail02.adl2.internode.on.net ([150.101.137.139]:11188 "EHLO
        ipmail02.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727273AbeKPPxT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 16 Nov 2018 10:53:19 -0500
Date: Fri, 16 Nov 2018 16:42:14 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/2] splice: increase pipe size in
 splice_direct_to_actor()
Message-ID: <20181116054214.GD19305@dastard>
References: <20181108221909.27602-1-david@fromorbit.com>
 <20181109005410.GG19305@dastard>
 <20181115101735.GC13913@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181115101735.GC13913@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Thu, Nov 15, 2018 at 02:17:35AM -0800, Christoph Hellwig wrote:
> > +long pipe_set_max_safe_size(struct pipe_inode_info *pipe)
> > +{
> > +	pipe_set_size(pipe, pipe_max_size);
> > +	return pipe->buffers * PAGE_SIZE;
> > +}
> 
> This should probably return an unsigned value, given that we don't return
> errors.  Then again the callers ignores the return value entirely.
> Wouldn't it be easier to just call pipe_set_size from splice.c after
> removing the static marker?

I didn't want to use pipe_max_size outside of the pipe code. it's
definitely simpler without a wrapper if using pipe_max_size directly
is acceptable.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
