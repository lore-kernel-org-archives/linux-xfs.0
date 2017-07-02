Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:39399 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751635AbdGBPY5 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 2 Jul 2017 11:24:57 -0400
Date: Sun, 2 Jul 2017 17:24:54 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 5/5] ext4: Switch to iomap for SEEK_HOLE / SEEK_DATA
Message-ID: <20170702152454.GA27426@lst.de>
References: <20170629135420.21357-1-hch@lst.de> <20170629135420.21357-6-hch@lst.de> <CAHc6FU4u+G1gtZVr3CUbJi2i+GwWhfDUOZemQ4Nnde=uiOmjXA@mail.gmail.com> <20170630173740.GB11420@lst.de> <20170701070306.GW5874@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170701070306.GW5874@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Andreas Gruenbacher <agruenba@redhat.com>, Jan Kara <jack@suse.cz>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-xfs@vger.kernel.org, linux-ext4 <linux-ext4@vger.kernel.org>

On Sat, Jul 01, 2017 at 12:03:06AM -0700, Darrick J. Wong wrote:
> On Fri, Jun 30, 2017 at 07:37:40PM +0200, Christoph Hellwig wrote:
> > On Fri, Jun 30, 2017 at 01:51:10PM +0200, Andreas Gruenbacher wrote:
> > > Also, ext4 no longer calls inode_lock or inode_lock_shared; that needs
> > > to be added back for consistency between reading i_size and walking
> > > the file extents.
> > 
> > At least for XFS we never had such a consistency as we never took
> > the iolock (aka i_rwsem).
> 
> Do we need it?

For XFS I'm pretty sure we don't.  The lseek is fundamentally safe
without it due to the ilock.

> The non-ext4 mechanical parts look ok to me (and test out ok), but I
> want to be sure that we don't create a locking mess.  Dave complained in
> an earlier thread about lockdep problems because the old code took the
> ilock and then started locking pages; since we take the ILOCK
> during ->iomap_begin, drop it, and only take page locks during
> page_cache_seek_hole_data (which is called from the iomap actor) I think
> that particular problem goes away.

The old code took the ilook in the seek hole/data helper, which had
two problems:  it double locked the ilock as we take it in iomap,
and it hols the ilock over the page cache calls.  None of which happen
with this code.

