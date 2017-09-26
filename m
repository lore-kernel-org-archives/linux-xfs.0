Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail01.adl2.internode.on.net ([150.101.137.133]:12349 "EHLO
        ipmail01.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S934482AbdIZFaZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Sep 2017 01:30:25 -0400
Date: Tue, 26 Sep 2017 15:25:19 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v5 2/3] xfs: Set realtime flag based on initial
 allocation size
Message-ID: <20170926052519.GQ10955@dastard>
References: <20170925194418.720146-1-rwareing@fb.com>
 <20170925194418.720146-3-rwareing@fb.com>
 <20170925224738.GD5020@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170925224738.GD5020@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Richard Wareing <rwareing@fb.com>, linux-xfs@vger.kernel.org, hch@infradead.org

On Mon, Sep 25, 2017 at 03:47:38PM -0700, Darrick J. Wong wrote:
> On Mon, Sep 25, 2017 at 12:44:17PM -0700, Richard Wareing wrote:
> > - The rt_alloc_min sysfs option automatically selects the device (data
> >   device, or realtime) based on the size of the initial allocation of the
> >   file.
> > - This option can be used to route the storage of small files (and the
> >   inefficient workloads associated with them) to a suitable storage
> >   device such a SSD, while larger allocations are sent to a traditional
> >   HDD.
> > - Supports writes via O_DIRECT, buffered (i.e. page cache), and
> >   pre-allocations (i.e. fallocate)
> > - Available only when kernel is compiled w/ CONFIG_XFS_RT option.
> > 
> > Signed-off-by: Richard Wareing <rwareing@fb.com>
> > ---
> > Changes since v4:
> > * Added xfs_inode_select_target function to hold target selection
> >   code
> > * XFS_IS_REALTIME_MOUNT check now moved inside xfs_inode_select_target
> >   function for better gating
> > * Improved consistency in the sysfs set behavior
> > * Style fixes
> > 
> > Changes since v3:
> > * Now functions via initial allocation regardless of O_DIRECT, buffered or
> >   pre-allocation code paths.  Provides a consistent user-experience.
> > * I Did do some experiments putting this in the xfs_bmapi_write code path
> >   however pre-allocation accounting unfortunately prevents this cleaner
> >   approach.  As such, this proved to be the cleanest and functional approach.
> > * No longer a mount option, now a sysfs tunable
> 
> I'm still struggling with the last two patches in this series.
> Currently the decision to set or clear a file's RT flag rests with
> whoever has write access to the file; and whatever they set stays that
> way throughout the life of the file.
> 
> These patches add new behaviors to the filesystem, namely that initial
> allocations and certain truncate operations can set or clear the
> realtime flag, and that this happens without any particular notification
> for whatever might've set that flag.  I imagine that programs that set
> the realtime flag might be a little surprised when it doesn't stay set,
> since we never used to do that.

This only happens if the filesystem has been configured to use the
"auto rtdev selection" function. It will *not* happen to existing RT
device users using default behaviour.

i.e. if you turn on auto-placement, you get the new behaviour. If
you don't turn it on, nothing at all should change.

> At least the new behaviors are hidden behind a sysfs knob, but a big
> thing missing from this series is a document for admins explaining that
> we've added these various knobs to facilitate automatic tiering of files

Please stop calling this "teiring". It's nothing like the industry
definition of storage teiring - bcache and dm-cache get closer, but
without something like a HSM we do not have teiring in XFS because
there's no such thing as completely transparent automatic data
movement....

In reality, this is simply a filesystem allocation policy that is
very similar to inode32. Remember that inode32 selects the target AG
of the inode when XFS_ALLOC_INITIAL_USER_DATA is set. i.e. on the
first allocation to the file. That's exactly what we are doing here
- deciding on the physical location of the data on the first
write/allocation to the file.

If you have a concatenated set of storage volumes underneath the
filesystem, the using inode32 is actually selecting the physical
device the data will reside on when we use inode32. It's not trying
to keep data local to the directory, it's trying to spread data over
the entire block device address space. Align AG sizes to the
underlying physical devices, and you have a direct relationship
between the selected AG and the physical device the data is written
to. If you have multiple AGs to a physical device (e.g. multi-TB
lun) then you end up with stuff like ag_skip to provide better
per-device selection:

http://oss.sgi.com/archives/xfs/2013-01/msg00611.html

That wasn't data teiring, it was an allocation policy that was
tailored to the underlying storage layout. Auto-selecting the rtdev
is the same sort of allocation policy - it's not tiering data, it's
just a policy that selects the best physical location for the
data being written....

> on an XFS filesystem, what the knobs do, and which operations can change
> a file's tier.  I also worry that we have no means to distinguish a file
> that has had the rt flag set by the user from a file with automatic rt
> flag management.

Setting the flag should override the auto placement and directly
selects the rt device. Clearing the flag (which shouldn't be set on
a zero length file) means auto placement.

> I think I may have mislead you a bit on the v1 patches when I objected
> to the new fallocate behaviors -- my biggest concern back then (and now)
> is the behavioral changes and how to help our existing users fit that
> into their mental models of how XFS works.  Is the size of the first
> non-fallocate write to a file sufficient to decide the rtflag?

> TLDR: Is this how we (XFS community) want to present tiered XFS to users?

TL;DR: It's not teiring, and conceptually no different to how we've
used inode32 to direct physical placement of data for many, many
years.

> (Off in the crazy space that is my head we could just upload BPF
> programs into XFS that would set and manage all the hints that can be
> attached to an inode, along with either an "automanaged inode" flag that
> locks out manual control or some kind of note that a particular setting
> overrides the automated control.)

I think I mentioned that a couple of years ago when I saw people
using eBPF for inserting arbitrary debug code into the kernel... :P

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
