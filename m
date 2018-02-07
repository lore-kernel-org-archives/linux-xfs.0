Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:60884 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752682AbeBGHJx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Feb 2018 02:09:53 -0500
Date: Wed, 7 Feb 2018 18:10:45 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/7] xfs: refactor and tablise growfs
Message-ID: <20180207071045.5nlw7b7fozldohgs@destitution>
References: <20180201064202.7174-1-david@fromorbit.com>
 <20180206234407.GN4849@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180206234407.GN4849@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Feb 06, 2018 at 03:44:07PM -0800, Darrick J. Wong wrote:
> On Thu, Feb 01, 2018 at 05:41:55PM +1100, Dave Chinner wrote:
> > Hi folks,
> > 
> > This is a series I posted months ago with the first thinspace
> > filesystem support. There was no comments on any of these patches
> > because all the heat and light got focussed on the growfs API.
> > I'm posting this separately to avoid that problem again....
> 
> ...just in time to collide head-on with the online repair series that I
> am planning to push out for review for 4.17. :)

Yuck. :(

> > Anyway, the core of this change is to make the growfs code much
> > simpler to extend. Most of the code that does structure
> > initialisation is cookie-cutter code and it's whacked into one great
> > big function. This patch set splits it up into separate functions
> > and uses common helper functions where possible. The different
> > structures and their initialisation definitions are now held in a
> > table, so when we add new stuctures or modify existing structures
> > it's a simple and isolate change.
> > 
> > The reworked initialisation code is suitable for moving to libxfs
> > and converting mkfs.xfs to use it for the initial formatting of
> > the filesystem. This will take more work to acheive, so this
> > patch set stops short of moving the code to libxfs.
> 
> Or maybe I'll just pull the patches into my dev tree and move all the
> code to libxfs /now/ since I don't see much difference between growing
> extra limbs and regrowing new body parts.  The "repair" code I've
> written so far chooses to rebuild the entire data structure from other
> parts rather than trying to save an existing structure:
> 
> 1. Lock the AG{I,F,FL} header/inode/whatever we're repairing.
> 2. Gather all the data that would have been in that data structure.
> 3. Make a list of all the blocks with the relevant rmap owner.
> 4. Make a list of all the blocks with the relevant rmap owner that are
>    owned by any other structure.  For example, if we're rebuilding the
>    inobt then we make a list of all the OWN_INOBT blocks, and then we
>    iterate the finobt to make a list of finobt blocks.
> 5. Allocate a new block for the root, if necessary.
> 6. Initialize the data structure.
> 7. Import all the data gathered in step 2.
> 8. Subtract the list made in step 4 from the list made in step 3.  These
>    are all the blocks that were owned by the structure we just rebuilt,
>    so free them.
> 9. Commit transaction, release locks, we're done.
> 
> (Steps 7-8 involve rolling transactions.)
> 
> I think growfs'ing a new AG is basically steps 1, 5, 6, 9, with the only
> twist being that growfs uses a delwri list instead of joining things to
> a transaction. 

Actually, it's a lot more different than just that. It's not
transactional, and we can't use cached buffers (and hence
transactions) because we're writing beyond the current valid end
of the filesystem. i.e. we're initialising all the structures before
we modify the superblock to indicate they are valid. That's also why
all the dirty buffers are gathered on a delwri list rather than in a
transaction context and we don't have to worry about locking...

> For this to work there needs to be separate functions to
> initialize a block and to deal with writing the xfs_buf to disk; I think
> I see this happening in the patchset, but tbh I suck at reading diff. :)

Yeah, there are separate functions to initialise the different
structures, but common code controls the delwri list addition and
writeback.

> > There are also mods to the secondary superblock update algorithm
> > which make it more resilient in the face of writeback failures. We
> > use a two pass update now - the main growfs loop now initialised
> > secondary superblocks with sb_inprogess = 1 to indicate it is not
> > in a valid state before we make any modifications, then after teh
> > transactional grow we do a second pass to set sb_inprogess = 0 and
> > mark them valid.
> > 
> > This means that if we fail to write any secondary superblock, repair
> > is not going to get confused by partial grow state. If we crash
> > during the initial write, nothing has changed in the primary
> > superblock. If we crash after the primary sb grow, then we'll know
> > exactly what secondary superblocks did not get updated because
> > they'll be the ones with sb_inprogress = 1 in them. Hence the
> > recovery process becomes much easier as the parts of the fs that
> > need updating are obvious....
> 
> I assume there will eventually be some kind of code to detect
> sb_inprogress==1 and fix it as soon as we try to write an AG?

Well, sort of. We never actually read secondary superblocks, except
in repair and now scrub. But reapir needs to know if secondary
superblocks are stale or not yet valid - right now it's an interesting
situation to be in if grow succeeds and then fails to write all the
secondary superblocks because we can't tell the difference between
per-grow and post-grow sbs. At least with sb_inprogress set in these
secondary superblocks we'll be able to tell how far the update got
before failing, and hence that makes it easier to recover to
consistent state.

Ultimately, I want to make the secondary superblock update loop a
set of ordered buffers associated with the primary superblock change
transaction. That way we can make log recovery correctly recover
from crashes during grow operations (i.e. it can re-run the
secondary sb updates based on the sb_inprogress flags...).

Or alternatively, turn grow into a set of defered ops with intents
so we can do the superblock size change first and always be able to
complete the secondary superblock updates in a transactional
manner...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
