Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl6.internode.on.net ([150.101.137.143]:7844 "EHLO
        ipmail03.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726252AbfAWUpe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Jan 2019 15:45:34 -0500
Date: Thu, 24 Jan 2019 07:45:28 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Regular FS shutdown while rsync is running
Message-ID: <20190123204528.GL4205@dastard>
References: <20181126153249.GC14585@bfoster>
 <1548067317.2465.7.camel@pengutronix.de>
 <20190121130121.GA4537@bfoster>
 <1548087824.2465.9.camel@pengutronix.de>
 <20190121181151.GD14281@bfoster>
 <1548153593.2465.18.camel@pengutronix.de>
 <20190122130254.GA22901@bfoster>
 <1548242057.28802.1.camel@pengutronix.de>
 <20190123121153.GA27284@bfoster>
 <20190123130306.GB27284@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190123130306.GB27284@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Lucas Stach <l.stach@pengutronix.de>, linux-xfs@vger.kernel.org

On Wed, Jan 23, 2019 at 08:03:07AM -0500, Brian Foster wrote:
> On Wed, Jan 23, 2019 at 07:11:53AM -0500, Brian Foster wrote:
> > On Wed, Jan 23, 2019 at 12:14:17PM +0100, Lucas Stach wrote:
> > > build_ino_tree(), which is shared between XFS_BTNUM_INO and
> > > XFS_BTNUM_FINO btree rebuilds contains the following in one of the
> > > loops:
> > > 
> > > if (lptr->num_recs_pb > 0)
> > > 		prop_ino_cursor(mp, agno, btree_curs,
> > > 				ino_rec->ino_startnum, 0);
> > > 
> > > prop_ino_cursor() calls libxfs_btree_init_block() with the btnum
> > > parameter being a fixed XFS_BTNUM_INO.

Nice find, Lucas!

> > It's been a while since I've looked at the guts of this code but that
> > definitely does not look right. build_ino_tree() is where we abstract
> > construction of the different tree types. Nice catch!
> > 
> > If this is the problem, I'll have to take a closer look to figure out
> > why this problem isn't more prevalent..
> > 
> 
> Hmm... so it looks like this is the code responsible for _growing_ the
> interior nodes of the tree (i.e., level > 0). If I'm following the code
> correctly, the high level algorithm is to first set up a block for each
> level of the tree. This occurs early in build_ino_tree() and uses the
> correct btnum. We then start populating the leaf nodes with the finobt
> records that have previously been built up in-core. For each leaf block,
> we populate the higher level block with the key based on the first
> record in the leaf then fill in the remaining records in the leaf. This
> repeats until the block at the next level up is full, at which point we
> grab a new level > 0 block and initialize it with the inobt magic.
> 
> I haven't confirmed, but I think this basically means that we'd
> initialize every intermediate block after the left-most block at each
> level in the tree with the inobt magic. I think Dave already recognized
> in the other subthread that you have a 2 block level 1 tree. I suspect
> the only reasons we haven't run into this until now are that the finobt
> is intended to remain fairly small by only tracking free inode records
> and thus prioritizing allocation from those records (removing them from
> the tree) and this is limited to users who repair a filesystem in such a
> state.
> 
> I'm guessing you have a large enough set of inodes and a sustained
> enough deletion pattern in your workload that you eventually free enough
> inodes across a large enough set of records to populate a multi-block
> level 1 tree. Then as soon as you try to allocate from that side of the
> tree the finer grained checks in __xfs_btree_check_[l|s]block() discover
> the wrong magic and generate the error.

Yeah, this is the "lots of sparse free inodes" sort of filesystem
that finobt is intended to really help with. :/

> The positive here is that this isn't really a coherency problem with the
> filesystem. The finobt itself is coherent, consistent with the inobt and
> the magic value doesn't really dictate how the trees are used/updated at
> runtime. This means that the only real corruption should be the magic
> value.

*nod*

Which means it should be fixable by a bit of xfs_db magic to find
and rewrite the magic numbers without needing a full repair to run.

> I am wondering whether this warrants a special case in the magic
> checking to convert the runtime internal error into more of a warning to
> unmount and run xfs_repair (similar to how we detected the agfl size
> mismatch problem). Dave, any thoughts on that?

I don't think it has the scope and breadth of the AGFL issue - there
isn't an actual fatal corruption on disk that will lead to loss or
corruption of user data.  It's just the wrong magic number being
placed in the btree block.

IMO, after fixing the repair bug, we should:

	a) make the inobt/finobt block verifier more robust to make
	sure we have the correct magic number for the btree type. In
	hindsight, if we did that in the first place then the
	repair bug would have not escaped into the wild.

	b) write a xfs_db finobt traversal command that rewrites the
	magic numbers of all the blocks in the tree. Probably with
	an xfs_admin wrapper to make it nice for users who need to
	run it.

	c) audit all the other verifiers to determine whether the
	combined magic number checks can/should be split so in
	future we detect this class of bug during development and
	testing.

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
