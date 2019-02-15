Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:6225 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725924AbfBOARC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Feb 2019 19:17:02 -0500
Date: Fri, 15 Feb 2019 11:16:57 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC PATCH 0/6] Allow setting file birth time with utimensat()
Message-ID: <20190215001657.GY14116@dastard>
References: <cover.1550136164.git.osandov@fb.com>
 <20190214220626.GV14116@dastard>
 <20190214231429.GE9819@vader>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190214231429.GE9819@vader>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Omar Sandoval <osandov@osandov.com>
Cc: linux-fsdevel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>, kernel-team@fb.com, linux-api@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org

On Thu, Feb 14, 2019 at 03:14:29PM -0800, Omar Sandoval wrote:
> On Fri, Feb 15, 2019 at 09:06:26AM +1100, Dave Chinner wrote:
> > On Thu, Feb 14, 2019 at 02:00:07AM -0800, Omar Sandoval wrote:
> > > From: Omar Sandoval <osandov@fb.com>
> > > 
> > > Hi,
> > > 
> > > Since statx was added in 4.11, userspace has had an interface for
> > > reading btime (file creation time), but no way to set it. This RFC patch
> > > series adds support for changing btime with utimensat(). Patch 1 adds
> > > the VFS infrastructure, patch 2 adds the support to utimensat() with a
> > > new flag, and the rest of the patches add filesystem support; I excluded
> > > CIFS for now because I don't have a CIFS setup to test it on.
> > > 
> > > Updating btime is useful for at least a couple of use cases:
> > > 
> > > - Backup/restore programs (my motivation for this feature is btrfs send)
> > > - File servers which interoperate with operating systems that allow
> > >   updating file creation time, including Mac OS [1] and Windows [2]
> > 
> > So you're adding an interface that allows users to change the create
> > time of files without needing any privileges?
> 
> I think it'd be reasonable to make this a privileged operation. I didn't
> for this initial submission for a couple of reasons:
> 
> 1. The precedent on Mac OS and Windows is that this isn't a privileged
>    operation.

Don't really care about them. Interop file servers that support these
operations on other OSs will need to be storing this info in xattrs
because they have to work on filesystems that don't support btime.

> 2. I knew there would be different opinions on this either way I went.

Yup.

> > Inode create time is forensic metadata in XFS  - information we use
> > for sequence of event and inode lifetime analysis during examination
> > of broken filesystem images and systems that have been broken into.
> > Just because it's exposed to userspace via statx(), it doesn't mean
> > that it is information that users should be allowed to change. i.e.
> > allowing users to be able to change the create time on files makes
> > it completely useless for the purpose it was added to XFS for...
> > 
> > And allowing root to change the create time doesn't really help,
> > because once you've broken into a system, this makes it really easy
> > to cover tracks
> 
> If the threat model is that the attacker has root, then they can
> overwrite the timestamp on disk anyways, no?

Modifying the block devicee under an active filesystem is fraught
with danger, and there's no guarantee it will work if the metadata
being modified is still active in memory. Corrupting the filesystem
is a sure way to get noticed....

> > (e.g. we can't find files that were created and
> > unlinked during the break in window anymore) and lay false
> > trails....
> 
> Fair point, although there's still ctime during the break-in window,

Unless you're smart enough to know how to trigger S_NOCMTIME or
FMODE_NOCMTIME....

> which I assume you'd be looking for anyways since files modified during
> the break-in window are also of interest.

... and then that also can't be guaranteed. :/

> I see a few options, none of which are particularly nice:
> 
> 1. Filesystems like XFS could choose not to support setting btime even
>    if they support reading it.
> 2. XFS could add a second, writeable btime which is used for
>    statx/utimes when available (it would fit in di_pad2...).
> 3. We could add a btime_writable sysctl/mount option/mkfs option.

4. create time remains a read-only field, and btrfs grows its own
special interface to twiddle it in btrfs-recv if it really is
necessary.

I'm still not convinced that even backup/restore should be doing this,
because there's so much other metadata that is unique even on
restored files that it doesn't really make any sense to me to lie
about it being created in the past....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
