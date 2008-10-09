Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 08 Oct 2008 17:00:27 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9900PoE010043
	for <xfs@oss.sgi.com>; Wed, 8 Oct 2008 17:00:25 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 030104CFE99
	for <xfs@oss.sgi.com>; Wed,  8 Oct 2008 17:02:04 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id 7LYwKLxs7txrg2Zb for <xfs@oss.sgi.com>; Wed, 08 Oct 2008 17:02:04 -0700 (PDT)
Date: Thu, 9 Oct 2008 11:02:01 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 6/6] XFS: Prevent looping in xfs_sync_inodes_ag
Message-ID: <20081009000201.GB9597@disturbed>
References: <1223416480-7701-1-git-send-email-david@fromorbit.com> <1223416480-7701-7-git-send-email-david@fromorbit.com> <20081008182138.GB22941@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081008182138.GB22941@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Wed, Oct 08, 2008 at 02:21:38PM -0400, Christoph Hellwig wrote:
> On Wed, Oct 08, 2008 at 08:54:40AM +1100, Dave Chinner wrote:
> > If the last  block of the AG has inodes in it and the AG is an
> > exactly power-of-2 size then the last inode in the AG points
> > to the last block in the AG. If we try to find the next inode
> > in the AG by adding one to the inode number, we increment the
> > inode number past the size of the AG. The result is that the
> > macro XFS_INO_TO_AGINO() will strip the AG portion of the inode
> > number and return an inode number of zero.
> > 
> > That is, instead of terminating the lookup loop because we hit the
> > inode number went outside the valid range for the AG, the search
> > index returns to zero and we start traversing the radix tree from
> > the start again. This results in an endless loop in
> > xfs_sync_inodes_ag().
> > 
> > Fix it be detecting if the new search index decreases as a result of
> > incrementing the current inode number. That indicate an overflow and
> > hence that we have finished processing the AG so we can terminate
> > the loop.
> 
> Shouldn't this get merged into the patch that introduces the radix-tree
> based sync?

It could be, but I didn't want to have to redo that reviewed patch
series. I've only hit this problem once in the past 6 weeks so I
thought adding a new patch rather than modifying patches to add the
fix was a better way to go....

I can integrate it if you want....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
