Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:59816 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751671AbcKIB0u (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Nov 2016 20:26:50 -0500
Date: Wed, 9 Nov 2016 12:23:43 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [ANNOUNCE] xfs: for-next branch updated to 84716639acc3
Message-ID: <20161109012343.GE28922@dastard>
References: <20161108231639.GC28922@dastard>
 <20161109000152.GB16813@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161109000152.GB16813@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, jack@suse.cz, tytso@mit.edu, ross.zwisler@linux.intel.com

On Tue, Nov 08, 2016 at 04:01:53PM -0800, Darrick J. Wong wrote:
> On Wed, Nov 09, 2016 at 10:16:39AM +1100, Dave Chinner wrote:
> > Hi folks,
> > 
> > The for-next branch of the xfs kernel repository at
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git
> > 
> > has just been updated.
> > 
> > This update includes the DAX iomap PMD fault infrastructure, a bunch
> > of libxfs cleanups that sync the kernel code with changes that
> > have been made in the userspace libxfs and a few bug fixes thrown in
> > there for good measure.
> 
> /me notices the commit message for 132f2ac5055a96 ("xfs: check minimum block
> size for CRC filesystems") says that you cleaned up the XFS_MIN_CRC_BLOCKSIZE
> check, but the patch appears identical to the one that I sent.  I think all
> you changed was removing the unlikely()...?
> 
> (<shrug> I doubt it's a big deal either way really...)

Ok, that's a little strange.

Hmmm - looks like I hadn't saved the modified file when I refreshed
the patch after modifying the commit message. I've already updated
my local for-next tree, so when I next push it out it will have this
update in it.

/me accidentally demonstrates why he uses topic branches to isolate
different bodies of work and the reasons that for-next needs to be
considered an unstable branch...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
