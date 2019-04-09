Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:53640 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726780AbfDIDZT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 8 Apr 2019 23:25:19 -0400
Date: Mon, 8 Apr 2019 20:23:03 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] bootfs: simple bootloader filesystem
Message-ID: <20190409032303.GS15524@magnolia>
References: <20190401070001.GJ1173@magnolia>
 <20190401214632.GS26298@dastard>
 <20190402045519.GK1173@magnolia>
 <20190406232717.GH18897@mit.edu>
 <e358c920-d49e-8319-ee19-4b3fa930b0f5@sandeen.net>
 <20190407201328.GR15524@magnolia>
 <581BC10D-6743-4E2E-A4C1-C8C3F9BE9DA3@dilger.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <581BC10D-6743-4E2E-A4C1-C8C3F9BE9DA3@dilger.ca>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andreas Dilger <adilger@dilger.ca>
Cc: Eric Sandeen <sandeen@sandeen.net>, Theodore Ts'o <tytso@mit.edu>, Dave Chinner <david@fromorbit.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>

On Mon, Apr 08, 2019 at 05:28:23AM -0600, Andreas Dilger wrote:
> On Apr 7, 2019, at 2:13 PM, Darrick J. Wong <darrick.wong@oracle.com> wrote:
> > 
> > On Sun, Apr 07, 2019 at 01:10:55PM -0500, Eric Sandeen wrote:
> >> On 4/6/19 6:27 PM, Theodore Ts'o wrote:
> >>> On Mon, Apr 01, 2019 at 09:55:19PM -0700, Darrick J. Wong wrote:
> >>>> 
> >>>> When Ted is done laughing, I really would like to consider something
> >>>> like this to solve the problem of grub-style bootloaders requiring a
> >>>> lease on the blocks underneath a file with a term exceeding that of the
> >>>> running kernel.
> >>>> 
> >>>> We can probably skip the harsh synchronous writes in favor of fsync on
> >>>> close, but we would need to keep the critical component of checkpointing
> >>>> the journal on fsync and syncfs.
> >>> 
> >>> At least for ext4, we don't need to add anything new, since FIFREEZE
> >>> force a journal checkpoint.  So we could try to get a patch into grub
> >>> which causes update_grub to open each kernel that it finds, and calls
> >>> fsync(2) on it, and then for all file systems where it finds a kernel,
> >>> it can call FIFREEZE and FITHAW on it, and that would be that.
> >> 
> >> Certain operating systems have hacked this in.  My concern would be when
> >> /boot is on / ... calling FIFREEZE on the root fs would most likely be
> >> a bad thing.  Certain operating systems avoid calling FIFREEZE for
> >> /boot-on-root.  ;)
> >> 
> >> Doing it for a standalone /boot seems like a reasonable (if hacky)
> >> workaround as long as we lack a more targeted quiesce interface...
> > 
> > The other problem we noticed is that neither the grub scripts nor the
> > rpm package scripts bother to call fsync on the files they write (or
> > sync after they're done to mop up after everyone else), so I figured as
> > long as I'm ("jokingly") working around it all in kernel space, why not
> > just go all the way? :P
> > 
> > Ok, I'll go work on an ioctl or something.
> 
> If Grub isn't even bothering to call fsync() on a file, what is the chance
> that they would call a special ioctl on the file?

Well yes, that is the justification for the existence of bootfs, isn't
it? :)

> What about doing "chattr +S /boot" so that all file IO in this directory is
> done synchronously, which would work even if /boot is not on a separate
> filesystem?  The "+S" flag is inherited by new files created in the directory.

That also isn't sufficient, since it doesn't solve the problem of grub
needing the journal/log to be checkpointed.

(I mean, unless you meant chattr +S on *bootfs* instead of its forced
-o sync,dirsync funniness?)

--D

> Cheers, Andreas
> 
> 
> 
> 
> 
