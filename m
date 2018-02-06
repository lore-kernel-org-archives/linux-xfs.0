Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:50526 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753346AbeBFXtK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Feb 2018 18:49:10 -0500
Date: Tue, 6 Feb 2018 15:44:07 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 0/7] xfs: refactor and tablise growfs
Message-ID: <20180206234407.GN4849@magnolia>
References: <20180201064202.7174-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180201064202.7174-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Feb 01, 2018 at 05:41:55PM +1100, Dave Chinner wrote:
> Hi folks,
> 
> This is a series I posted months ago with the first thinspace
> filesystem support. There was no comments on any of these patches
> because all the heat and light got focussed on the growfs API.
> I'm posting this separately to avoid that problem again....

...just in time to collide head-on with the online repair series that I
am planning to push out for review for 4.17. :)

> Anyway, the core of this change is to make the growfs code much
> simpler to extend. Most of the code that does structure
> initialisation is cookie-cutter code and it's whacked into one great
> big function. This patch set splits it up into separate functions
> and uses common helper functions where possible. The different
> structures and their initialisation definitions are now held in a
> table, so when we add new stuctures or modify existing structures
> it's a simple and isolate change.
> 
> The reworked initialisation code is suitable for moving to libxfs
> and converting mkfs.xfs to use it for the initial formatting of
> the filesystem. This will take more work to acheive, so this
> patch set stops short of moving the code to libxfs.

Or maybe I'll just pull the patches into my dev tree and move all the
code to libxfs /now/ since I don't see much difference between growing
extra limbs and regrowing new body parts.  The "repair" code I've
written so far chooses to rebuild the entire data structure from other
parts rather than trying to save an existing structure:

1. Lock the AG{I,F,FL} header/inode/whatever we're repairing.
2. Gather all the data that would have been in that data structure.
3. Make a list of all the blocks with the relevant rmap owner.
4. Make a list of all the blocks with the relevant rmap owner that are
   owned by any other structure.  For example, if we're rebuilding the
   inobt then we make a list of all the OWN_INOBT blocks, and then we
   iterate the finobt to make a list of finobt blocks.
5. Allocate a new block for the root, if necessary.
6. Initialize the data structure.
7. Import all the data gathered in step 2.
8. Subtract the list made in step 4 from the list made in step 3.  These
   are all the blocks that were owned by the structure we just rebuilt,
   so free them.
9. Commit transaction, release locks, we're done.

(Steps 7-8 involve rolling transactions.)

I think growfs'ing a new AG is basically steps 1, 5, 6, 9, with the only
twist being that growfs uses a delwri list instead of joining things to
a transaction.  For this to work there needs to be separate functions to
initialize a block and to deal with writing the xfs_buf to disk; I think
I see this happening in the patchset, but tbh I suck at reading diff. :)

> The other changes to the growfs code in this patchset also isolate
> separate parts of the growfs functionality, such as updating the
> secondary superblocks and changing imaxpct. This makes adding
> thinspace functionality to growfs much easier.
> 
> Finally, there are optimisations to make a large AG count growfs
> much faster. Instead of initialising and writing headers one at a
> time synchronously, they are added to a delwri buffer list and
> written in bulk and asynchronously. This means AG headers get merged
> by the block layer and it can reduce the IO wait time by an order of
> magnitude or more.

Sounds good.

> There are also mods to the secondary superblock update algorithm
> which make it more resilient in the face of writeback failures. We
> use a two pass update now - the main growfs loop now initialised
> secondary superblocks with sb_inprogess = 1 to indicate it is not
> in a valid state before we make any modifications, then after teh
> transactional grow we do a second pass to set sb_inprogess = 0 and
> mark them valid.
> 
> This means that if we fail to write any secondary superblock, repair
> is not going to get confused by partial grow state. If we crash
> during the initial write, nothing has changed in the primary
> superblock. If we crash after the primary sb grow, then we'll know
> exactly what secondary superblocks did not get updated because
> they'll be the ones with sb_inprogress = 1 in them. Hence the
> recovery process becomes much easier as the parts of the fs that
> need updating are obvious....

I assume there will eventually be some kind of code to detect
sb_inprogress==1 and fix it as soon as we try to write an AG?

--D

> Cheers,
> 
> Dave.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
