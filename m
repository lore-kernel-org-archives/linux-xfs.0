Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:41756 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726409AbfDGUNo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 7 Apr 2019 16:13:44 -0400
Date: Sun, 7 Apr 2019 13:13:28 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] bootfs: simple bootloader filesystem
Message-ID: <20190407201328.GR15524@magnolia>
References: <20190401070001.GJ1173@magnolia>
 <20190401214632.GS26298@dastard>
 <20190402045519.GK1173@magnolia>
 <20190406232717.GH18897@mit.edu>
 <e358c920-d49e-8319-ee19-4b3fa930b0f5@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e358c920-d49e-8319-ee19-4b3fa930b0f5@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Theodore Ts'o <tytso@mit.edu>, Dave Chinner <david@fromorbit.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>

On Sun, Apr 07, 2019 at 01:10:55PM -0500, Eric Sandeen wrote:
> On 4/6/19 6:27 PM, Theodore Ts'o wrote:
> > On Mon, Apr 01, 2019 at 09:55:19PM -0700, Darrick J. Wong wrote:
> >>
> >> When Ted is done laughing, I really would like to consider something
> >> like this to solve the problem of grub-style bootloaders requiring a
> >> lease on the blocks underneath a file with a term exceeding that of the
> >> running kernel.
> >>
> >> We can probably skip the harsh synchronous writes in favor of fsync on
> >> close, but we would need to keep the critical component of checkpointing
> >> the journal on fsync and syncfs.
> > 
> > At least for ext4, we don't need to add anything new, since FIFREEZE
> > force a journal checkpoint.  So we could try to get a patch into grub
> > which causes update_grub to open each kernel that it finds, and calls
> > fsync(2) on it, and then for all file systems where it finds a kernel,
> > it can call FIFREEZE and FITHAW on it, and that would be that.
> 
> Certain operating systems have hacked this in.  My concern would be when
> /boot is on / ... calling FIFREEZE on the root fs would most likely be
> a bad thing.  Certain operating systems avoid calling FIFREEZE for
> /boot-on-root.  ;)
> 
> Doing it for a standalone /boot seems like a reasonable (if hacky)
> workaround as long as we lack a more targeted quiesce interface...

The other problem we noticed is that neither the grub scripts nor the
rpm package scripts bother to call fsync on the files they write (or
sync after they're done to mop up after everyone else), so I figured as
long as I'm ("jokingly") working around it all in kernel space, why not
just go all the way? :P

Ok, I'll go work on an ioctl or something.

--D

> -Eric
>  
> > That's not guaranteed to work for all file systems, of course.  So the
> > right answer may be to define a new IOCTL which causes all file system
> > to do whatever log truncation is needed so that grub will do the right
> > thing.
> > 
> > 					- Ted
> > 
