Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:65336 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754095AbeAaX4k (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 31 Jan 2018 18:56:40 -0500
Date: Thu, 1 Feb 2018 10:57:33 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [LSF/MM TOPIC][LSF/MM ATTEND] Parent pointer future use cases
Message-ID: <20180131235733.z7vwnxer6dadgyw3@destitution>
References: <588cad68-78eb-88de-49c3-716330b70cd5@oracle.com>
 <20180131184653.GA4841@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180131184653.GA4841@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Allison Henderson <allison.henderson@oracle.com>, lsf-pc@lists.linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-xfs <linux-xfs@vger.kernel.org>

On Wed, Jan 31, 2018 at 10:46:53AM -0800, Darrick J. Wong wrote:
> On Tue, Jan 30, 2018 at 08:56:07PM -0700, Allison Henderson wrote:
> > Hi everyone!
> > 
> > Recently I have been working towards adding a new parent pointer patch set
> > to xfs.  Briefly summarized, goal of the feature is to enable an application
> > to quickly derive an inodes path from the mount point by storing information
> > about the inodes parent(s) in an extended attribute.  Currently, I am aware
> > of the intent to use the feature as part of an online scrub and repair
> > feature.
> 
> The online fs check use case is that we iterate every inode in the
> filesystem from start to finish via file handles, and if we find some
> damage it would be much more helpful to be able to report the file path
> to userspace (e.g. "/foo/bar/file is corrupt" vs. "inode 325325 is
> corrupt").
> 
> A second use is for xfs_repair and/or online fs repair -- instead of
> dumping files orphaned by a destroyed directory in lost+found, we have
> the possibility of rebuilding that directory by scanning all the inodes
> to see which ones have parent pointers to the broken directory and then
> rebuilding it from there.  Easy enough to do in xfs_repair, but will be
> significantly more challenging to do it in the kernel <cough>.
> 
> The third use I can think of relates to past years' discussion of head
> de-pop and pmem badblocks -- given a range of defective storage, we can
> cross reference that with the reverse mapping to figure out which
> (inode, offset) are affected, and try to use parent pointers to turn the
> inode numbers into file paths.  We can also figure out if metadata is
> affected and start a rebuild operation (though obviously if the rmap
> data is affected then we're toast).
> 
> > Looking forward however, I would like to know about any other
> > future coding intents that might make use of this feature.  For example,
> > optimizing file system shrink or exportfs operations?  Are there certain
> 
> Not sure it'll help for fs shrink, but clearly the exportfs part of the
> discussion has taken off. :)

For shrink it would help identify the parent directories that need
to be modified when we move an inode. i.e. bulkstat to find inodes
that need moving, copy the data to a new inode, parent lookup to
find all the directories that need modifying, modify the dirents
to point to the new inode, delete old inode.

i.e. parent lookups are needed for an optimal 'bottom up' shrink
algorithm based on bulkstat and fsmap....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
