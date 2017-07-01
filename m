Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:46706 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751581AbdGAHDT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 1 Jul 2017 03:03:19 -0400
Date: Sat, 1 Jul 2017 00:03:06 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 5/5] ext4: Switch to iomap for SEEK_HOLE / SEEK_DATA
Message-ID: <20170701070306.GW5874@birch.djwong.org>
References: <20170629135420.21357-1-hch@lst.de>
 <20170629135420.21357-6-hch@lst.de>
 <CAHc6FU4u+G1gtZVr3CUbJi2i+GwWhfDUOZemQ4Nnde=uiOmjXA@mail.gmail.com>
 <20170630173740.GB11420@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170630173740.GB11420@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: Andreas Gruenbacher <agruenba@redhat.com>, Jan Kara <jack@suse.cz>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-xfs@vger.kernel.org, linux-ext4 <linux-ext4@vger.kernel.org>

On Fri, Jun 30, 2017 at 07:37:40PM +0200, Christoph Hellwig wrote:
> On Fri, Jun 30, 2017 at 01:51:10PM +0200, Andreas Gruenbacher wrote:
> > Also, ext4 no longer calls inode_lock or inode_lock_shared; that needs
> > to be added back for consistency between reading i_size and walking
> > the file extents.
> 
> At least for XFS we never had such a consistency as we never took
> the iolock (aka i_rwsem).

Do we need it?  It seems strange to me that someone else could be
changing the file size while we're trying to use it to scan for holes or
data, but OTOH there are plenty of other places where the kernel
effectively requires that userspace either has synchronized writer
processess with the seeker process or is prepared to deal with the
inconsistent results.  If that's the intended behavior for the
SEEK_{HOLE,DATA} then I guess I can put my fears to rest about XFS /not/
taking the IOLOCK/i_rwsem.

The non-ext4 mechanical parts look ok to me (and test out ok), but I
want to be sure that we don't create a locking mess.  Dave complained in
an earlier thread about lockdep problems because the old code took the
ilock and then started locking pages; since we take the ILOCK
during ->iomap_begin, drop it, and only take page locks during
page_cache_seek_hole_data (which is called from the iomap actor) I think
that particular problem goes away.

(As for the ext4 patch that involves deeper surgery to the ext4 iomap
implementation so you'll have to take that up with Ted...)

--D

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
