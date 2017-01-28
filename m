Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:64084 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752777AbdA2AJk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 28 Jan 2017 19:09:40 -0500
Date: Sun, 29 Jan 2017 09:55:17 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2] xfs: clear _XBF_PAGES from buffers when readahead
 page allocation fails
Message-ID: <20170128225517.GE316@dastard>
References: <20170126035330.GU9134@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170126035330.GU9134@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, linux-xfs <linux-xfs@vger.kernel.org>

On Wed, Jan 25, 2017 at 07:53:30PM -0800, Darrick J. Wong wrote:
> If we try to allocate memory pages to back an xfs_buf that we're trying
> to read, it's possible that we'll be so short on memory that the page
> allocation fails.  For a blocking read we'll just wait, but for
> readahead we simply dump all the pages we've collected so far.
> 
> Unfortunately, after dumping the pages we neglect to clear the
> _XBF_PAGES state, which means that the subsequent call to xfs_buf_free
> thinks that b_pages still points to pages we own.  It then double-frees
> the b_pages pages.
> 
> This results in screaming about negative page refcounts from the memory
> manager, which xfs oughtn't be triggering.  To reproduce this case,
> mount a filesystem where the size of the inodes far outweighs the
> availalble memory (a ~500M inode filesystem on a VM with 300MB memory
> did the trick here) and run bulkstat in parallel with other memory
> eating processes to put a huge load on the system.  The "check summary"
> phase of xfs_scrub also works for this purpose.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Can you rename the patch "prevent double free of buffer pages on
readahead failure"? That way people looking for commits to backport
are going to see it clearly and easily....

And I think it also needs a stable cc....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
