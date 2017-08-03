Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:52507 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751743AbdHCUYv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Aug 2017 16:24:51 -0400
Message-Id: <1501791890.2285873.1062452112.61520C55@webmail.messagingengine.com>
From: Colin Walters <walters@verbum.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
References: <20170519002032.GA21202@birch.djwong.org>
 <1495202431.1896310.982081664.066926F8@webmail.messagingengine.com>
 <20170519190115.GJ4519@birch.djwong.org>
In-Reply-To: <20170519190115.GJ4519@birch.djwong.org>
Date: Thu, 03 Aug 2017 16:24:50 -0400
Subject: Re: [PATCH] vfs: freeze filesystems just prior to reboot
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>

Resurrecting this thread:

On Fri, May 19, 2017, at 03:01 PM, Darrick J. Wong wrote:
> On Fri, May 19, 2017 at 10:00:31AM -0400, Colin Walters wrote:
> > On Thu, May 18, 2017, at 08:20 PM, Darrick J. Wong wrote:
> > 
> > > Therefore, add a reboot hook to freeze all filesystems (which in general
> > > will induce ext4/xfs/btrfs to checkpoint the log) just prior to reboot.
> > > This is an unfortunate and insufficient workaround for multiple layers
> > > of inadequate external software, but at least it will reduce boot time
> > > surprises for the "OS updater failed to disengage the filesystem before
> > > rebooting" case.
> > 
> > As a maintainer of one of those userspace tools
> > (https://github.com/ostreedev/ostree), which I don't think is the one
> > in question here, but likely has the same issue - I'd like to have
> > some sort of API to fix this - maybe flush the journal *without*
> > remounting r/o?
> 
> The convention (at least among ext4 and xfs) is that fs freeze should be
> checkpointing the journal.

OK, so I finally implemented this:
https://github.com/ostreedev/ostree/pull/1049

I had to go to some awkward lengths to try to make this safe; everything
in libostree is designed to be "crash only" - we're an update system
that doesn't install a SIGINT/SIGTERM handler, we just let the kernel
kill us, and that should always be safe.  But if we're interrupted right after
we invoke FIFREEZE we'd leave the fs frozen.  

Any objections to something like an ioctl (fd, FIFREEZETHAW, 0) ?

I was thinking about this more though, and while this obviously helps,
it's still just narrowing a window; if we have a system crash after
writing the config but before we've done a freeze-thaw, we still
have the journaled data problem.
 
in the end probably the real fix is probably something like storing
multiple copies of the bootloader config with checksums that grub
can verify.  Basically teach grub to try really hard to extract known-good
data from the FS.  For file-level consistency that'd be pretty easy,
we could have e.g. 
/boot/efi/grub.cfg
/boot/efi/grub.cfg.checksum (sha256 of grub.cfg)
/boot/efi/grub.cfg.orig
/boot/efi/grub.cfg.orig.checksum (sha256 of grub.cfg.orig)
etc.

But what I don't know offhand without diving a lot more into XFS
internals is how resilient such a scheme would be against the
outstanding journal writes for the directory.  (Maybe it's more
resilient to use separate /boot/efi/grub-new and /boot/efi/grub-old
dirs?)
