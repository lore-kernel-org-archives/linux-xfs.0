Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:13811 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726963AbeJVNZu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 Oct 2018 09:25:50 -0400
Date: Mon, 22 Oct 2018 16:08:51 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v6 00/28] fs: fixes for serious clone/dedupe problems
Message-ID: <20181022050851.GY6311@dastard>
References: <154013850285.29026.16168387526580596209.stgit@magnolia>
 <20181022022112.GW6311@dastard>
 <20181022043741.GX6311@dastard>
 <20181022045249.GP32577@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181022045249.GP32577@ZenIV.linux.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@redhat.com, linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com

On Mon, Oct 22, 2018 at 05:52:49AM +0100, Al Viro wrote:
> On Mon, Oct 22, 2018 at 03:37:41PM +1100, Dave Chinner wrote:
> 
> > Ok, this is a bit of a mess. the patches do not merge cleanly to a
> > 4.19-rc1 base kernel because of all the changes to
> > include/linux/fs.h that have hit the tree after this. There's also
> > failures against Documentation/filesystems/fs.h
> > 
> > IOWs, it's not going to get merged through the main XFS tree because
> > I don't have the patience to resolve all the patch application
> > failures, then when it comes to merge make sure all the merge
> > failures end up being resolved correctly.
> > 
> > So if I take it through the XFS tree, it will being a standalone
> > branch based on 4.19-rc8 and won't hit linux-next until after the
> > first XFS merge when I can rebase the for-next branch...
> 
> How many conflicts does it have with XFS tree?  I can take it via
> vfs.git...

I gave up after 4 of the first 6 or 7 patches had conflicts in vfs
and documentation code.

There were changes that went into 4.19-rc7 that changed
{do|vfs}_clone_file_range() prototypes and this patchset hits
prototypes adjacent to that multiple times. There's also a conflicts
against a new f_ops->fadvise method. These all appear to be direct
fallout of fixes needed for all the overlay f_ops changes.

The XFS changes at the end of the patchset are based on
commits that were merged into -rc7 and -rc8, so if you are using
-rc8 as your base, then it all merges cleanly. There are no
conflicts with the current xfs/for-next branch.

I've just merged and built it into my test tree (-rc8, xfs/for-next,
djwong/devel) so I can test it properly, but if it merges cleanly
with the vfs tree you are building then that's probably the easiest
way to merge it all...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
