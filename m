Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:46140 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965391AbeE2SBx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 May 2018 14:01:53 -0400
Date: Tue, 29 May 2018 11:01:49 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2 04/22] xfs: add helpers to dispose of old btree blocks
 after a repair
Message-ID: <20180529180149.GG30110@magnolia>
References: <152642361893.1556.9335169821674946249.stgit@magnolia>
 <152642364418.1556.17533271717583168316.stgit@magnolia>
 <20180518035347.GA23858@magnolia>
 <20180529031422.GK10363@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180529031422.GK10363@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, Allison Henderson <allison.henderson@oracle.com>

On Tue, May 29, 2018 at 01:14:22PM +1000, Dave Chinner wrote:
> On Thu, May 17, 2018 at 08:53:47PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Now that we've plumbed in the ability to construct a list of dead btree
> > blocks following a repair, add more helpers to dispose of them.  This is
> > done by examining the rmapbt -- if the btree was the only owner we can
> > free the block, otherwise it's crosslinked and we can only remove the
> > rmapbt record.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> > v2: document the design of how old btree block disposal is supposed to
> >     work and document some of the limitations of the buffer cache that
> >     we can't fix here, and reduce perag_get/put traffic
> 
> Yup, I can accept those limitations for the initial implementation.
> Gotta leave something for you to work on once it's been merged,
> right?

Yeah.  I'd spec'd out adding a bitmap to each AG's xfs_buf cache to
track non-stale cached buffers and scream if someone tries to add an
overlapping buffer, but then started talking to Dan last week about
connecting XFS to pmem poison notifications.

If the metadata block using the poisoned pmem is cached in dram then
we'd want to find the associated xfs_buf and write it back out.  For
that we'd need full block -> buf mapping abilities (and not just a
bitmap), which will likely bloat the radix tree significantly.  This
became a mess of ink in my notebook so I gave up, for now.

--D

> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> 
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
