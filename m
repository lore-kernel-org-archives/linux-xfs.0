Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:53402 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730024AbfGAR7O (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Jul 2019 13:59:14 -0400
Date: Mon, 1 Jul 2019 10:59:05 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH RFC 00/11] iomap: regroup code by functional area
Message-ID: <20190701175905.GC1654093@magnolia>
References: <156200051933.1790352.5147420943973755350.stgit@magnolia>
 <20190701174129.GA3315@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190701174129.GA3315@mit.edu>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Theodore Ts'o <tytso@mit.edu>
Cc: hch@infradead.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Mon, Jul 01, 2019 at 01:41:29PM -0400, Theodore Ts'o wrote:
> On Mon, Jul 01, 2019 at 10:01:59AM -0700, Darrick J. Wong wrote:
> > Note that this is not the final format of the patches, because I intend
> > to pick a point towards the end of the merge window (after everyone
> > else's merges have landed), rebase this series atop that, and push it
> > back to Linus.
> 
> So normally Linus isn't psyched about pulling branches that were
> rebased at the last minute.  I guess we could ask him ahead of time if
> he's OK with this plan.  Or have you done that already?

I've not done so yet, since this is the first time this cleanup has been
posted.  Assuming I don't hear any loud complaining from anyone, I was
going to send the existing iomap 5.3 patches (all three of them) to
Linus at the start of the merge window and let him know that I'd like
to do the quick cleanup during the second week.  I've done tree cleanups
this way before without hearing any complaints, though they've never
gone outside the xfs tree.

> Alternatively you could rebase this on top of v5.3-rc2, after the
> merge window closes, and get agreement from the 4 file systems which
> are currently iomap users: ext2, ext4, gfs2, and xfs to start their
> development trees on top of that common branch for the 5.4 merge
> window.  After all, it's just moving code around and there are no
> substantive changes in this patch series, right?  So there's no rush
> as I understand things for this to hit mainline.

<shrug> I prefer to get this done quickly at the end of the 5.3 merge
window to reduce the risk that I'll have to reconcile the cleanup with
whatever iomap fixes land during -rc1 to -rc7.

I don't know if you've been following the "lift xfs writeback to iomap"
thread lately but I've also been thinking about putting out a work
branch for 5.4 with the sample writeback code in fs/iomap/writeback.c
to see if anyone bites, so we're likely to get such a tree anyway.

--D

> Cheers,
> 
> 						- Ted
