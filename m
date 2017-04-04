Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:15848 "EHLO
        ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753176AbdDDMec (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Apr 2017 08:34:32 -0400
Date: Tue, 4 Apr 2017 22:34:14 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC PATCH v1 00/30] fs: inode->i_version rework and optimization
Message-ID: <20170404123414.GA23007@dastard>
References: <1490117004.2542.1.camel@redhat.com>
 <20170321183006.GD17872@fieldses.org>
 <1490122013.2593.1.camel@redhat.com>
 <20170329111507.GA18467@quack2.suse.cz>
 <1490810071.2678.6.camel@redhat.com>
 <20170330064724.GA21542@quack2.suse.cz>
 <1490872308.2694.1.camel@redhat.com>
 <20170330161231.GA9824@fieldses.org>
 <20170401230526.GW23007@dastard>
 <20170403140055.GF15168@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170403140055.GF15168@quack2.suse.cz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Kara <jack@suse.cz>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, Jeff Layton <jlayton@redhat.com>, Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org

On Mon, Apr 03, 2017 at 04:00:55PM +0200, Jan Kara wrote:
> On Sun 02-04-17 09:05:26, Dave Chinner wrote:
> > On Thu, Mar 30, 2017 at 12:12:31PM -0400, J. Bruce Fields wrote:
> > > On Thu, Mar 30, 2017 at 07:11:48AM -0400, Jeff Layton wrote:
> > > > On Thu, 2017-03-30 at 08:47 +0200, Jan Kara wrote:
> > > > > Because if above is acceptable we could make reported i_version to be a sum
> > > > > of "superblock crash counter" and "inode i_version". We increment
> > > > > "superblock crash counter" whenever we detect unclean filesystem shutdown.
> > > > > That way after a crash we are guaranteed each inode will report new
> > > > > i_version (the sum would probably have to look like "superblock crash
> > > > > counter" * 65536 + "inode i_version" so that we avoid reusing possible
> > > > > i_version numbers we gave away but did not write to disk but still...).
> > > > > Thoughts?
> > > 
> > > How hard is this for filesystems to support?  Do they need an on-disk
> > > format change to keep track of the crash counter?
> > 
> > Yes. We'll need version counter in the superblock, and we'll need to
> > know what the increment semantics are. 
> > 
> > The big question is how do we know there was a crash? The only thing
> > a journalling filesystem knows at mount time is whether it is clean
> > or requires recovery. Filesystems can require recovery for many
> > reasons that don't involve a crash (e.g. root fs is never unmounted
> > cleanly, so always requires recovery). Further, some filesystems may
> > not even know there was a crash at mount time because their
> > architecture always leaves a consistent filesystem on disk (e.g. COW
> > filesystems)....
> 
> What filesystems can or cannot easily do obviously differs. Ext4 has a
> recovery flag set in superblock on RW mount/remount and cleared on
> umount/RO remount.

Even this doesn't help. A recent bug that was reported to the XFS
list - turns out that systemd can't remount-ro the root
filesystem sucessfully on shutdown because there are open write fds
on the root filesystem when it attempts the remount. So it just
reboots without a remount-ro. This uncovered a bug in grub in
that it (still!) thinks sync(1) is sufficient to get all the
metadata that points to a kernel image onto disk in places it can
read. XFS, like ext4, leaves it in the journal and so the system then fails to
boot because systemd didn't remount-ro the root fs and hence the
journal was never flushed before reboot and so grub can't find the
kernel and so everything fails....

> This flag being set on mount would imply incrementing the crash
> counter. It should be pretty easy for each filesystem to implement
> such flag and the counter but I agree it requires an on-disk
> format change.

Yup, anything we want that is persistent and consistent across
filesystems will need on-disk format changes. Hence we need a solid
specification first, not to mention tests to validate correct
behaviour across all filesystems in xfstests...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
