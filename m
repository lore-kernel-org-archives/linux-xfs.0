Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:33982 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750822AbeECVZR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 May 2018 17:25:17 -0400
Date: Thu, 3 May 2018 14:24:47 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v3 1/2] iomap: add a swapfile activation function
Message-ID: <20180503212447.GG4141@magnolia>
References: <20180503174659.GD4127@magnolia>
 <20180503205803.GA26037@vader>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180503205803.GA26037@vader>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Omar Sandoval <osandov@osandov.com>
Cc: xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-mm@kvack.org, hch@infradead.org, cyberax@amazon.com, jack@suse.cz, Eryu Guan <guaneryu@gmail.com>

On Thu, May 03, 2018 at 01:58:03PM -0700, Omar Sandoval wrote:
> On Thu, May 03, 2018 at 10:46:59AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Add a new iomap_swapfile_activate function so that filesystems can
> > activate swap files without having to use the obsolete and slow bmap
> > function.  This enables XFS to support fallocate'd swap files and
> > swap files on realtime devices.
> > 
> 
> Shouldn't we also prevent the extents of an active swapfile from
> becoming shared? If I swapon(a) and reflink(a, b), swapout to a now has
> to break the reflink or corrupt b! In my old Btrfs swapfile series [1] I
> just forbid all reflink operations on active swapfiles. 

xfs already does this in its reflink handler: it takes the inode lock &
bails out if IS_SWAPFILE().  swapon calls claim_swapfile to take the
inode lock and sets S_SWAPFILE (if successful) so the two are
effectively locked out from each other...

> One thing to note is that then this will need a matching
> ->swap_deactivate(), which currently isn't called if ->swap_activate()
> returned > 0.

...so there shouldn't be any state to undo if the
iomap_swapfile_activate fails.

--D

> 
> 1: https://github.com/osandov/linux/tree/btrfs-swap
> 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> > v3: catch null iomap addr, fix too-short extent detection
> > v2: document the swap file layout requirements, combine adjacent
> >     real/unwritten extents, align reported swap extents to physical page
> >     size boundaries, fix compiler errors when swap disabled
