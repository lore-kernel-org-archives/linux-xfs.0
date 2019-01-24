Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34180 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725909AbfAXTLU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 24 Jan 2019 14:11:20 -0500
Date: Thu, 24 Jan 2019 14:11:17 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: Regular FS shutdown while rsync is running
Message-ID: <20190124191117.GA48262@bfoster>
References: <20190121130121.GA4537@bfoster>
 <1548087824.2465.9.camel@pengutronix.de>
 <20190121181151.GD14281@bfoster>
 <1548153593.2465.18.camel@pengutronix.de>
 <20190122130254.GA22901@bfoster>
 <1548242057.28802.1.camel@pengutronix.de>
 <20190123121153.GA27284@bfoster>
 <20190123130306.GB27284@bfoster>
 <20190123204528.GL4205@dastard>
 <20190124133120.GA2855@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190124133120.GA2855@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Lucas Stach <l.stach@pengutronix.de>, linux-xfs@vger.kernel.org

On Thu, Jan 24, 2019 at 08:31:20AM -0500, Brian Foster wrote:
> On Thu, Jan 24, 2019 at 07:45:28AM +1100, Dave Chinner wrote:
> > On Wed, Jan 23, 2019 at 08:03:07AM -0500, Brian Foster wrote:
> > > On Wed, Jan 23, 2019 at 07:11:53AM -0500, Brian Foster wrote:
> > > > On Wed, Jan 23, 2019 at 12:14:17PM +0100, Lucas Stach wrote:
> > > > > build_ino_tree(), which is shared between XFS_BTNUM_INO and
> > > > > XFS_BTNUM_FINO btree rebuilds contains the following in one of the
> > > > > loops:
> > > > > 
> > > > > if (lptr->num_recs_pb > 0)
> > > > > 		prop_ino_cursor(mp, agno, btree_curs,
> > > > > 				ino_rec->ino_startnum, 0);
> > > > > 
> > > > > prop_ino_cursor() calls libxfs_btree_init_block() with the btnum
> > > > > parameter being a fixed XFS_BTNUM_INO.
> > 
> > Nice find, Lucas!
> > 
> > > > It's been a while since I've looked at the guts of this code but that
> > > > definitely does not look right. build_ino_tree() is where we abstract
> > > > construction of the different tree types. Nice catch!
> > > > 
> > > > If this is the problem, I'll have to take a closer look to figure out
> > > > why this problem isn't more prevalent..
> > > > 
> > > 
> > > Hmm... so it looks like this is the code responsible for _growing_ the
> > > interior nodes of the tree (i.e., level > 0). If I'm following the code
> > > correctly, the high level algorithm is to first set up a block for each
> > > level of the tree. This occurs early in build_ino_tree() and uses the
> > > correct btnum. We then start populating the leaf nodes with the finobt
> > > records that have previously been built up in-core. For each leaf block,
> > > we populate the higher level block with the key based on the first
> > > record in the leaf then fill in the remaining records in the leaf. This
> > > repeats until the block at the next level up is full, at which point we
> > > grab a new level > 0 block and initialize it with the inobt magic.
> > > 
> > > I haven't confirmed, but I think this basically means that we'd
> > > initialize every intermediate block after the left-most block at each
> > > level in the tree with the inobt magic. I think Dave already recognized
> > > in the other subthread that you have a 2 block level 1 tree. I suspect
> > > the only reasons we haven't run into this until now are that the finobt
> > > is intended to remain fairly small by only tracking free inode records
> > > and thus prioritizing allocation from those records (removing them from
> > > the tree) and this is limited to users who repair a filesystem in such a
> > > state.
> > > 
> > > I'm guessing you have a large enough set of inodes and a sustained
> > > enough deletion pattern in your workload that you eventually free enough
> > > inodes across a large enough set of records to populate a multi-block
> > > level 1 tree. Then as soon as you try to allocate from that side of the
> > > tree the finer grained checks in __xfs_btree_check_[l|s]block() discover
> > > the wrong magic and generate the error.
> > 
> > Yeah, this is the "lots of sparse free inodes" sort of filesystem
> > that finobt is intended to really help with. :/
> > 
> > > The positive here is that this isn't really a coherency problem with the
> > > filesystem. The finobt itself is coherent, consistent with the inobt and
> > > the magic value doesn't really dictate how the trees are used/updated at
> > > runtime. This means that the only real corruption should be the magic
> > > value.
> > 
> > *nod*
> > 
> > Which means it should be fixable by a bit of xfs_db magic to find
> > and rewrite the magic numbers without needing a full repair to run.
> > 
> > > I am wondering whether this warrants a special case in the magic
> > > checking to convert the runtime internal error into more of a warning to
> > > unmount and run xfs_repair (similar to how we detected the agfl size
> > > mismatch problem). Dave, any thoughts on that?
> > 
> > I don't think it has the scope and breadth of the AGFL issue - there
> > isn't an actual fatal corruption on disk that will lead to loss or
> > corruption of user data.  It's just the wrong magic number being
> > placed in the btree block.
> > 
> 
> Right, it's not a corruption that's going to have compound effects and
> lead to broader inconsistencies and whatnot. We made a decision to nuke
> the agfl at runtime to preserve behavior and allow the fs to continue
> running (in spite of less severe corruption actually introduced by the
> agfl reset).
> 
> This problem is still a fatal runtime error in some cases (and probably
> all cases once we fix up the verifiers), however, and that's the
> behavior I'm wondering whether we should mitigate because otherwise the
> fs is fully capable of continuing to run (and the state may ultimately
> clear itself).
> 

Having looked more into this (see the RFC I sent earlier).. an explicit
verifier magic check plus the existing mount time finobt scan pretty
much means anybody affected by this goes from having a fully working fs
to an unmountable fs due to the verifier change. I don't think that's
appropriate at all. We need to figure out some way to handle this a
little more gracefully IMO.. thoughts?

Brian

> > IMO, after fixing the repair bug, we should:
> > 
> > 	a) make the inobt/finobt block verifier more robust to make
> > 	sure we have the correct magic number for the btree type. In
> > 	hindsight, if we did that in the first place then the
> > 	repair bug would have not escaped into the wild.
> > 
> 
> Agreed. I had already sent Lucas a patch along this lines that pretty
> much implicated xfs_repair as the cause by virtue of the mount time
> finobt scan. I'll post that to the list separately.
> 
> > 	b) write a xfs_db finobt traversal command that rewrites the
> > 	magic numbers of all the blocks in the tree. Probably with
> > 	an xfs_admin wrapper to make it nice for users who need to
> > 	run it.
> > 
> 
> Hmm, I can't really think of any time I'd suggest a user run something
> that swizzles on-disk data like this without running xfs_repair before
> and after. I certainly wouldn't ever do otherwise myself. Of course such
> a script means those xfs_repair runs could be non-destructive, but I'm
> not sure that's much of an advantage.
> 
> Hmm, I was thinking a more targeted script to fix a single block based
> on daddr might be reasonable, but I'm not sure I'd even trust that.
> 
> > 	c) audit all the other verifiers to determine whether the
> > 	combined magic number checks can/should be split so in
> > 	future we detect this class of bug during development and
> > 	testing.
> > 
> 
> Agree. TBH, I think the failure in this case was not thorough enough
> testing of the xfs_repair changes moreso than the kernel checks not
> being granular enough. Otherwise an immediate follow up xfs_repair -n
> run (which I tend to do) would have caught this much quicker than split
> checks in the kernel verifiers. That said, the split checks definitely
> facilitate analysis of this kind of error report and are worth
> considering for that alone.
> 
> Brian
> 
> > Cheers,
> > 
> > Dave.
> > 
> > -- 
> > Dave Chinner
> > david@fromorbit.com
