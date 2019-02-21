Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmailnode02.adl6.internode.on.net ([150.101.137.148]:12196
        "EHLO ipmailnode02.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726220AbfBUUIH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 Feb 2019 15:08:07 -0500
Date: Fri, 22 Feb 2019 07:08:02 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [LSF/MM TOPIC] More async operations for file systems - async
 discard?
Message-ID: <20190221200802.GJ14116@dastard>
References: <92ab41f7-35bc-0f56-056f-ed88526b8ea4@gmail.com>
 <20190217210948.GB14116@dastard>
 <46540876-c222-0889-ddce-44815dcaad04@gmail.com>
 <20190220234723.GA5999@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190220234723.GA5999@localhost.localdomain>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Keith Busch <keith.busch@intel.com>
Cc: Ric Wheeler <ricwheeler@gmail.com>, lsf-pc@lists.linux-foundation.org, linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>, linux-btrfs <linux-btrfs@vger.kernel.org>, linux-block@vger.kernel.org

On Wed, Feb 20, 2019 at 04:47:24PM -0700, Keith Busch wrote:
> On Sun, Feb 17, 2019 at 06:42:59PM -0500, Ric Wheeler wrote:
> > I think the variability makes life really miserable for layers above it.
> > 
> > Might be worth constructing some tooling that we can use to validate or
> > shame vendors over - testing things like a full device discard, discard of
> > fs block size and big chunks, discard against already discarded, etc.
> 
> With respect to fs block sizes, one thing making discards suck is that
> many high capacity SSDs' physical page sizes are larger than the fs block
> size, and a sub-page discard is worse than doing nothing.
> 
> We've discussed previously about supporting block size larger than
> the system's page size, but it doesn't look like that's gone anywhere.

You mean in filesystems?  Work for XFS is in progress:

https://lwn.net/Articles/770975/

But it's still only a maximum of 64k block size. Essentially, that's
a hard limit backed into the on-disk format (similar to max sector
size limits of 32k)

> Maybe it's worth revisiting since it's really inefficient if you write
> or discard at the smaller granularity.

Filesystems discard extents these days, not individual blocks. If
you free a 1MB file, they you are likely to get a 1MB discard. Or if
you use fstrim, then it's free space extent sizes (on XFS can be
hundred of GBs) and small free spaces can be ignored. So the
filesystem block size is often not an issue at all...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
