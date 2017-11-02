Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:65280 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S964867AbdKBVWU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Nov 2017 17:22:20 -0400
Date: Fri, 3 Nov 2017 08:22:17 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs_repair: clear extra file attributes on symlinks
Message-ID: <20171102212217.GV5858@dastard>
References: <20171031215156.12544-1-mcgrof@kernel.org>
 <20171031221253.GV4911@magnolia>
 <CAB=NE6WusGvGYVBokMOup9snofncCm9gXopM7BaUukp9N3zbRQ@mail.gmail.com>
 <20171031224320.GB4911@magnolia>
 <20171102003948.GG22894@wotan.suse.de>
 <20171102052306.GQ4911@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171102052306.GQ4911@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>, Eric Sandeen <sandeen@sandeen.net>, David Howells <dhowells@redhat.com>, xfs <linux-xfs@vger.kernel.org>, Tso Ted <tytso@mit.edu>, Nikolay Borisov <nborisov@suse.com>, Flex Liu <fliu@suse.com>, Jake Norris <jake.norris@suse.com>, Jan Kara <jack@suse.cz>

On Wed, Nov 01, 2017 at 10:23:06PM -0700, Darrick J. Wong wrote:
> On Thu, Nov 02, 2017 at 01:39:48AM +0100, Luis R. Rodriguez wrote:
> > On Tue, Oct 31, 2017 at 03:43:20PM -0700, Darrick J. Wong wrote:
> > > you shouldn't be able to set any DIFLAG/DIFLAG2 flags on special files.
> > 
> > Do we know for certain *all* DIFLAG/DIFLAG2 flags can *only* be set via
> > an ioctl()?
> 
> I'm fairly sure that inode flags get set via ioctl, via inheritance at
> creation time with only two exceptions*, but could you please take a look
> at all the places we set inode di_flags/di_flags2 and report back?

*users* can only set/clear inode flags through ioctls. The kernel
can set/clear inode flags at any time, and they may be flags that
users cannot change (e.g. the reflink flag, or the prealloc flag
which is set during fallocate() calls to tell the kernel not to
remove preallocations beyond EOF).

Write up a set of masks that state what flags are valid on what
type of inode. We can review that for correctness, then we can
work out how to handle bad flags in repair...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
