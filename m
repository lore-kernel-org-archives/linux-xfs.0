Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:58378 "EHLO
        ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932414AbcK1Vxq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Nov 2016 16:53:46 -0500
Date: Tue, 29 Nov 2016 08:53:08 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Slow file stat/deletion
Message-ID: <20161128215308.GD28177@dastard>
References: <bef58272-f791-52bf-cc4c-1cb1b7c9efec@assyoma.it>
 <20161127221433.GV28177@dastard>
 <a5774248-db44-bdfe-2310-bb1a327756fb@assyoma.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a5774248-db44-bdfe-2310-bb1a327756fb@assyoma.it>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Gionatan Danti <g.danti@assyoma.it>
Cc: linux-xfs@vger.kernel.org

On Mon, Nov 28, 2016 at 10:51:42AM +0100, Gionatan Danti wrote:
> 
> 
> On 27/11/2016 23:14, Dave Chinner wrote:
> >
> >Ah, hard link farms. aka "How to fragment the AGI btrees for fun and
> >profit."
> >
> 
> Interesting... there is anything I can read about AGI fragmentation?

Read up on finobt and the bug reports on the list about how inode
allocation slows to a crawl....

> >Nope, but it means that what should be sequential IO is probably
> >going to be random. i.e. instead of directory/inode/extent reading
> >IO having minimum track-track seek latency because they are all
> >nearby (1-2ms), they'll be average seeks (6-7ms) because locality is no
> >longer as the filesystem has optimised for.
> >
> 
> Should not thinp overhead be minimized by the big (8 MB) chunk size?

Minimised - maybe. Removed - no.

> Are inode allocation so much scattered around LBAs?

Yes. XFS distributes inodes across the entire device LBA.

> Maybe the
> slowdown can be increased by bad journal placement (I imagine it is
> near the start of the disk, while current read/write activity surely
> happen near the end)?

Contributing factor, yes. You just have to live with that thinp
behaviour.

> >noalign affects data placement only, and only for filesystems that
> >have a stripe unit/width set, which yours doesn't:
> >
> >>			sunit=0      swidth=0 blks
> 
> Isn't that the proper results of "noalign"?

No. "noalign" is a mount option - the sunit/swidth are geometry
values stored in the superblock. noalign will override the
superblock values, but it does not make them go away.

> By opting for "noalign"
> I am telling mkfs to discard any stripe information, right?

No. You are telling it to ignore stripe alignment for file data
allocation purposes.

> >Yes. Made worse by being on a thinp volume.
> 
> I can't do anything for that?

Nope. There's always going to be a penalty for subverting the
filesystem's physical layout optimisations on storage subsystems
that require physical layout optimisation for performance.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
