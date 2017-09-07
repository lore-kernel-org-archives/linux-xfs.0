Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:65237 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932238AbdIGWMG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Sep 2017 18:12:06 -0400
Date: Fri, 8 Sep 2017 08:12:01 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/9] add ext4 per-inode DAX flag
Message-ID: <20170907221201.GZ17782@dastard>
References: <20170905223541.20594-1-ross.zwisler@linux.intel.com>
 <f856f8fd-3697-adb1-198b-a9ae2fce405f@redhat.com>
 <20170906170754.GB17663@linux.intel.com>
 <CAPcyv4hfhDT9NFRXL+MT5epiqWHJ0RLraV4P3CZ4EJM6L-s0Nw@mail.gmail.com>
 <20170907211303.GA23212@linux.intel.com>
 <5F58D3F5-D93B-4648-AE01-8A46956FBB4B@dilger.ca>
 <20170907215148.GA12669@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170907215148.GA12669@linux.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Andreas Dilger <adilger@dilger.ca>, Dan Williams <dan.j.williams@intel.com>, Eric Sandeen <sandeen@redhat.com>, Lukas Czerner <lczerner@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, Theodore Ts'o <tytso@mit.edu>, Christoph Hellwig <hch@lst.de>, Jan Kara <jack@suse.cz>, linux-ext4 <linux-ext4@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, xfs <linux-xfs@vger.kernel.org>

On Thu, Sep 07, 2017 at 03:51:48PM -0600, Ross Zwisler wrote:
> On Thu, Sep 07, 2017 at 03:26:10PM -0600, Andreas Dilger wrote:
> > However, I wonder if this could
> > be prevented at runtime, and only allow S_DAX to be set when the inode is
> > first instantiated, and wouldn't be allowed to change after that?  Setting
> > or clearing the per-inode DAX flag might still be allowed, but it wouldn't
> > be enabled until the inode is next fetched into cache?  Similarly, for
> > inodes that have conflicting features (e.g. inline data or encryption)
> > would not be allowed to enable S_DAX.
> 
> Ooh, this seems interesting.  This would ensure that S_DAX transitions
> couldn't ever race with I/Os or mmaps().  I had some other ideas for how to
> handle this, but I think your idea is more promising. :)

IMO, that's an awful admin interface - it can't be done on demand
(i.e. when needed) because we can't force an inode to be evicted
from the cache. And then we have the "why the hell did that just
change" problem if an inode is evicted due to memory pressure and
then immediately reinstantiated by the running workload. That's a
recipe for driving admins insane...

> I guess with this solution we'd need:
> 
> a) A good way of letting the user detect the state where they had set the DAX
> inode flag, but that it wasn't yet in use by the inode.
> 
> b) A reliable way of flushing the inode from the filesystem cache, so that the
> next time an open() happens they get the new behavior.  The way I usually do
> this is via umount/remount, but there is probably already a way to do this?

Not if it's referenced. And if it's not referenced, then the only
hammer we have is Brutus^Wdrop_caches. That's not an option for
production machines.

Neat idea, but one I'd already thought of and discarded as "not
practical from an admin perspective".

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
