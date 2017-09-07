Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:9803 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932095AbdIGVvu (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 7 Sep 2017 17:51:50 -0400
Date: Thu, 7 Sep 2017 15:51:48 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 0/9] add ext4 per-inode DAX flag
Message-ID: <20170907215148.GA12669@linux.intel.com>
References: <20170905223541.20594-1-ross.zwisler@linux.intel.com>
 <f856f8fd-3697-adb1-198b-a9ae2fce405f@redhat.com>
 <20170906170754.GB17663@linux.intel.com>
 <CAPcyv4hfhDT9NFRXL+MT5epiqWHJ0RLraV4P3CZ4EJM6L-s0Nw@mail.gmail.com>
 <20170907211303.GA23212@linux.intel.com>
 <5F58D3F5-D93B-4648-AE01-8A46956FBB4B@dilger.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5F58D3F5-D93B-4648-AE01-8A46956FBB4B@dilger.ca>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andreas Dilger <adilger@dilger.ca>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, Dan Williams <dan.j.williams@intel.com>, Eric Sandeen <sandeen@redhat.com>, Lukas Czerner <lczerner@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, Theodore Ts'o <tytso@mit.edu>, Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.cz>, linux-ext4 <linux-ext4@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, xfs <linux-xfs@vger.kernel.org>

On Thu, Sep 07, 2017 at 03:26:10PM -0600, Andreas Dilger wrote:
> On Sep 7, 2017, at 3:13 PM, Ross Zwisler <ross.zwisler@linux.intel.com> wrote:
> > 
> > On Thu, Sep 07, 2017 at 01:54:45PM -0700, Dan Williams wrote:
> >> On Wed, Sep 6, 2017 at 10:07 AM, Ross Zwisler
> >> <ross.zwisler@linux.intel.com> wrote:
> >>> On Tue, Sep 05, 2017 at 09:12:35PM -0500, Eric Sandeen wrote:
> >>>> On 9/5/17 5:35 PM, Ross Zwisler wrote:
> >>>>> The original intent of this series was to add a per-inode DAX flag to ext4
> >>>>> so that it would be consistent with XFS.  In my travels I found and fixed
> >>>>> several related issues in both ext4 and XFS.
> >>>> 
> >>>> Hi Ross -
> >>>> 
> >>>> hch had a lot of reasons to nuke the dax flag from orbit, and we just
> >>>> /disabled/ it in xfs due to its habit of crashing the kernel...
> >>> 
> >>> Ah, sorry, I wasn't CC'd on those threads and missed them.  For any interested
> >>> bystanders:
> >>> 
> >>> https://www.spinics.net/lists/linux-ext4/msg57840.html
> >>> https://www.spinics.net/lists/linux-xfs/msg09831.html
> >>> https://www.spinics.net/lists/linux-xfs/msg10124.html
> >>> 
> >>>> so a couple questions:
> >>>> 
> >>>> 1) does this series pass hch's "test the per-inode DAX flag" fstest?
> >>> 
> >>> Nope, it has the exact same problems as the XFS per-inode DAX flag.
> >>> 
> >>>> 2) do we have an agreement that we need this flag at all, or is this
> >>>>   just a parity item because xfs has^whad a per-inode flag?
> >>> 
> >>> It was for parity, and because it allows admins finer grained control over
> >>> their system.  Basically all things discussed in response to Lukas's original
> >>> patch in the first link above.
> >> 
> >> I think it's more than parity. When pmem is slower than page cache it
> >> is actively harmful to have DAX enabled globally for a filesystem. So,
> >> not only should we push for per-inode DAX control, we should also push
> >> to deprecate the mount option. I agree with Christoph that we should
> >> try to automatically and transparently enable DAX where it makes
> >> sense, but we also need a finer-grained mechanism than a mount flag to
> >> force the behavior one way or the other.
> > 
> > Yep, agreed.  I'll play with how to make this work after I've sorted out all
> > the data corruptions I've found. :)
> 
> It seems that the majority of problems are from enabling/disabling S_DAX
> on an inode that already has dirty data. 

I don't think it's precisely about dirty data, more about having mappings set
up and I/Os in flight, even if those are read operations.  Tomorrow I'll post
some xfstests for the data corruptions due to DAX + each of inline data and
journaling, and those both happen because we set up one mapping to page cache,
and one to DAX.  Once either is written to they become out of sync.

> However, I wonder if this could
> be prevented at runtime, and only allow S_DAX to be set when the inode is
> first instantiated, and wouldn't be allowed to change after that?  Setting
> or clearing the per-inode DAX flag might still be allowed, but it wouldn't
> be enabled until the inode is next fetched into cache?  Similarly, for
> inodes that have conflicting features (e.g. inline data or encryption)
> would not be allowed to enable S_DAX.

Ooh, this seems interesting.  This would ensure that S_DAX transitions
couldn't ever race with I/Os or mmaps().  I had some other ideas for how to
handle this, but I think your idea is more promising. :)

I guess with this solution we'd need:

a) A good way of letting the user detect the state where they had set the DAX
inode flag, but that it wasn't yet in use by the inode.

b) A reliable way of flushing the inode from the filesystem cache, so that the
next time an open() happens they get the new behavior.  The way I usually do
this is via umount/remount, but there is probably already a way to do this?

> My assumption here is that it is possible to fall back to always using
> page cache for such inodes, and flush the data to pmem via the block
> interface for inodes that don't have S_DAX set?

Correct.

> That would allow the vast majority of cases to work out of the box, or in
> a few rare cases where the DAX feature is being changed (e.g. inline data
> inode on disk growing to external disk blocks) would use the page cache
> until such a time that the inode is dropped from cache and reloaded (at
> worst the next remount).

Ah, yep, this has the potential to solve those cases as well.  Seems
promising, to me at least. :)
