Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 11 Aug 2008 17:18:46 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m7C0IgLc027160
	for <xfs@oss.sgi.com>; Mon, 11 Aug 2008 17:18:44 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 911A9383AE4
	for <xfs@oss.sgi.com>; Mon, 11 Aug 2008 17:19:58 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id G6QYVQ1Mr0DRyCzL for <xfs@oss.sgi.com>; Mon, 11 Aug 2008 17:19:58 -0700 (PDT)
Date: Tue, 12 Aug 2008 10:19:55 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/4] XFS: replace the mount inode list with radix tree
	traversals V2
Message-ID: <20080812001955.GG6119@disturbed>
References: <1216773673-3620-1-git-send-email-david@fromorbit.com> <20080811140850.GA12521@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080811140850.GA12521@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Mon, Aug 11, 2008 at 10:08:50AM -0400, Christoph Hellwig wrote:
> On Wed, Jul 23, 2008 at 10:41:09AM +1000, Dave Chinner wrote:
> > The list of all inodes on a mount is superfluous. We can traverse
> > all inodes now by walking the per-AG inode radix trees without
> > needing a separate list. This enables us to remove a bunch of
> > complex list traversal code and remove another two pointers from
> > the xfs_inode.
> > 
> > Also, by replacing the sync traversal with an ascending inode
> > number traversal, we will issue better inode I/O patterns for
> > writeback triggered by xfssyncd or unmount.
> 
> Any plans to send an updated version for the current tree and including
> the xfsidbg fixups?

Sure, I've been waiting for the git tree to get updated with all the
patch I had previously sent. I've been away for the past few days,
so it hasn't happened yet.

As to the xfsidbg changes, as I've said before the XFS git trees
do not have that file in it nor do I use kdb at all anymore. It
means I have to convert complex patch series to a CVS tree to create
a idbg patches that I can't test or then integrate back into the the
git tree. I dislike sending untested patches, especially when they
are non-trivial. It also means i can't use the git patch-bomb tools
to send them as part of the patch series.

Quite frankly, xfsidbg is a PITA to update because it's not in a
git tree, and hence I don't update it because I don't need it to
develop or debug code....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
