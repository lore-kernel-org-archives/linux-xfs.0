Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail01.adl2.internode.on.net ([150.101.137.133]:59629 "EHLO
        ipmail01.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S934930AbdIYXgi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Sep 2017 19:36:38 -0400
Date: Tue, 26 Sep 2017 09:16:58 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v4 3/3] xfs: Add realtime fallback if data device full
Message-ID: <20170925231658.GJ10955@dastard>
References: <20170919035238.3976871-1-rwareing@fb.com>
 <20170919035238.3976871-4-rwareing@fb.com>
 <20170922070423.GE10955@dastard>
 <768B086C-A345-40AD-A1DD-6C175E768B63@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <768B086C-A345-40AD-A1DD-6C175E768B63@fb.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Richard Wareing <rwareing@fb.com>
Cc: linux-xfs@vger.kernel.org, darrick.wong@oracle.com, hch@infradead.org

On Mon, Sep 25, 2017 at 11:37:02AM -0700, Richard Wareing wrote:
> Dave Chinner <david@fromorbit.com> wrote:
> >On Mon, Sep 18, 2017 at 08:52:38PM -0700, Richard Wareing wrote:
> >>+		/* Pre-compute minimum data blocks required before
> >>+		 * falling back to RT device for allocations
> >>+		 */
> >
> >Comment format.
> >
> >>+		mp->m_rt_min_fdblocks = min_blocks;
> >
> >Hmmm - I wonder if it would be better to tie this into the existing
> >data device low space threshold code?
> >
> 
> Not sure what you mean here?

The lowspace threshold code is just an array of thresholds at which
we do trigger different behaviour. e.g. we trim maximum speculative
delalloc space based one where free space falls in that table.  If
we add another entry in the table for the "switch to RT device at
this low space" threshold, we don't need a specific variable in the
struct xfs_mount....

> 
> >>+void xfs_rt_fallback(
> >>+    struct xfs_inode    *ip,
> >>+    struct xfs_mount    *mp)
> >
> >Mount first, then inode.
> >
> 
> Just for my own knowledge, is this a convention?

Convention. I also missed that the return type goes on a separate
line. i.e.

void
xfs_rt_fallback(
	struct xfs_mount	*mp,
	struct xfs_inode	*ip)

It's different to the standard linux convention for a couple of
reasons. Firstly, it's the historic format inherited from Irix but
we kept it because it makes using grep to find a function
declaration really easy (i.e. "^xfs_rt_fallback" finds the function
declaration instead of all the callers) and there are functions with
lots of parameters and the "run them all together in as few lines as
possible" is hard on the eyes and requires reformatting of the
entire function definition when one changes.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
