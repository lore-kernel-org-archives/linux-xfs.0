Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:24918 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751123AbdA3Xgz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 30 Jan 2017 18:36:55 -0500
Date: Mon, 30 Jan 2017 15:35:57 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2] xfs: clear _XBF_PAGES from buffers when readahead
 page allocation fails
Message-ID: <20170130233557.GA6442@birch.djwong.org>
References: <20170126035330.GU9134@birch.djwong.org>
 <20170128225517.GE316@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170128225517.GE316@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, linux-xfs <linux-xfs@vger.kernel.org>

On Sun, Jan 29, 2017 at 09:55:17AM +1100, Dave Chinner wrote:
> On Wed, Jan 25, 2017 at 07:53:30PM -0800, Darrick J. Wong wrote:
> > If we try to allocate memory pages to back an xfs_buf that we're trying
> > to read, it's possible that we'll be so short on memory that the page
> > allocation fails.  For a blocking read we'll just wait, but for
> > readahead we simply dump all the pages we've collected so far.
> > 
> > Unfortunately, after dumping the pages we neglect to clear the
> > _XBF_PAGES state, which means that the subsequent call to xfs_buf_free
> > thinks that b_pages still points to pages we own.  It then double-frees
> > the b_pages pages.
> > 
> > This results in screaming about negative page refcounts from the memory
> > manager, which xfs oughtn't be triggering.  To reproduce this case,
> > mount a filesystem where the size of the inodes far outweighs the
> > availalble memory (a ~500M inode filesystem on a VM with 300MB memory
> > did the trick here) and run bulkstat in parallel with other memory
> > eating processes to put a huge load on the system.  The "check summary"
> > phase of xfs_scrub also works for this purpose.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Can you rename the patch "prevent double free of buffer pages on
> readahead failure"? That way people looking for commits to backport
> are going to see it clearly and easily....

Uh... this patch was already in Linus' tree by the time I received this reply,
so I don't think I can change it.

> And I think it also needs a stable cc....

Will send it to the stable list.

--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
