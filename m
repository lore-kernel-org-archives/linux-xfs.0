Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pl1-f196.google.com ([209.85.214.196]:38229 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728771AbfBNXOc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Feb 2019 18:14:32 -0500
Received: by mail-pl1-f196.google.com with SMTP id e5so3944718plb.5
        for <linux-xfs@vger.kernel.org>; Thu, 14 Feb 2019 15:14:31 -0800 (PST)
Date: Thu, 14 Feb 2019 15:14:29 -0800
From: Omar Sandoval <osandov@osandov.com>
Subject: Re: [RFC PATCH 0/6] Allow setting file birth time with utimensat()
Message-ID: <20190214231429.GE9819@vader>
References: <cover.1550136164.git.osandov@fb.com>
 <20190214220626.GV14116@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190214220626.GV14116@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>, kernel-team@fb.com, linux-api@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org

On Fri, Feb 15, 2019 at 09:06:26AM +1100, Dave Chinner wrote:
> On Thu, Feb 14, 2019 at 02:00:07AM -0800, Omar Sandoval wrote:
> > From: Omar Sandoval <osandov@fb.com>
> > 
> > Hi,
> > 
> > Since statx was added in 4.11, userspace has had an interface for
> > reading btime (file creation time), but no way to set it. This RFC patch
> > series adds support for changing btime with utimensat(). Patch 1 adds
> > the VFS infrastructure, patch 2 adds the support to utimensat() with a
> > new flag, and the rest of the patches add filesystem support; I excluded
> > CIFS for now because I don't have a CIFS setup to test it on.
> > 
> > Updating btime is useful for at least a couple of use cases:
> > 
> > - Backup/restore programs (my motivation for this feature is btrfs send)
> > - File servers which interoperate with operating systems that allow
> >   updating file creation time, including Mac OS [1] and Windows [2]
> 
> So you're adding an interface that allows users to change the create
> time of files without needing any privileges?

I think it'd be reasonable to make this a privileged operation. I didn't
for this initial submission for a couple of reasons:

1. The precedent on Mac OS and Windows is that this isn't a privileged
   operation.
2. I knew there would be different opinions on this either way I went.

> Inode create time is forensic metadata in XFS  - information we use
> for sequence of event and inode lifetime analysis during examination
> of broken filesystem images and systems that have been broken into.
> Just because it's exposed to userspace via statx(), it doesn't mean
> that it is information that users should be allowed to change. i.e.
> allowing users to be able to change the create time on files makes
> it completely useless for the purpose it was added to XFS for...
> 
> And allowing root to change the create time doesn't really help,
> because once you've broken into a system, this makes it really easy
> to cover tracks

If the threat model is that the attacker has root, then they can
overwrite the timestamp on disk anyways, no?

> (e.g. we can't find files that were created and
> unlinked during the break in window anymore) and lay false
> trails....

Fair point, although there's still ctime during the break-in window,
which I assume you'd be looking for anyways since files modified during
the break-in window are also of interest.

I see a few options, none of which are particularly nice:

1. Filesystems like XFS could choose not to support setting btime even
   if they support reading it.
2. XFS could add a second, writeable btime which is used for
   statx/utimes when available (it would fit in di_pad2...).
3. We could add a btime_writable sysctl/mount option/mkfs option.

Thanks!
