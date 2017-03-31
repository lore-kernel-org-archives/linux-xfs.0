Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:23049 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933204AbdCaRG3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 31 Mar 2017 13:06:29 -0400
Date: Fri, 31 Mar 2017 10:06:01 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [ANNOUNCE] xfs-linux: for-next updated to 0cbf8c9
Message-ID: <20170331170601.GH4874@birch.djwong.org>
References: <20170330173724.GE4864@birch.djwong.org>
 <20170331160438.GA3255@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170331160438.GA3255@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs <linux-xfs@vger.kernel.org>

On Fri, Mar 31, 2017 at 09:04:38AM -0700, Christoph Hellwig wrote:
> On Thu, Mar 30, 2017 at 10:37:24AM -0700, Darrick J. Wong wrote:
> > has just been updated.  I intend to try to put in Eric Sandeen's patches
> > to perform unlinked inode cleanup during ro mount and my own GETFSMAP
> > patches for 4.12, so I put them in along with the other fixes and
> > cleanups to get further testing.
> 
> Any chance we could not use for-next for stuff that's just queued up
> for testing?

I've had a difficult time figuring out the timeline for Eric's patches.

I've been testing them internally since they were posted and haven't
seen any problems crop up.  There's already an xfstest to reproduce the
problem and exercise the fix.  Dave is concerned about the repercussions
of the fs suddenly reaping up to several years' worth of orphaned inodes
during a ro mount, since XFS never used to do that.  It's hard to know
just how many people across the entire userbase that have read-only
filesystems with inodes that have been sitting orphaned for years.

Maybe we need generic/417 to create more than the 200 orphaned inodes it
creates now?  But how many is enough?  200,000 fragmented files?

That's why I was thinking that it would be useful to have wider testing
across the community than just me, so I decided to put it in for-next a
few weeks before the merge window opens and if people start complaining
I can always pull them out and defer it for 4.13.

(Hopefully Eric Sandeen chimes in here, though I think he's still on
vacation...)

--D

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
