Return-Path: <SRS0=4OPL=YK=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB3F5ECE599
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Oct 2019 00:40:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7D746218DE
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Oct 2019 00:40:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dqLQR+7s"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392690AbfJQAka (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Oct 2019 20:40:30 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:47102 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725877AbfJQAka (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Oct 2019 20:40:30 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9H0Tb57053993;
        Thu, 17 Oct 2019 00:40:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=KpW57IKON+jVoePL6Q/5qgQT2irEEfyUcRgz9SEMcJE=;
 b=dqLQR+7s+uleBm6T6h62iB9jBrnC5FxizMd4xpv3bWdXAjt/1/RYxrXO3ovR0G8y/DxO
 Kk0ThMvb4HfBLMBetm7K/pmF76LsNf6UgkpT+UJSwRfTQQu0XfeeuYd4p1RMoJodD7gS
 UTTJkOW9WGuLzkQeFmnZPcV8fjuEV+VOkT3PVvE7NDJc8xK1EfZLB66dVh8//IuVoZ4S
 eFa4/VUWldSV2lRV75yMF+WmxAc53HzZ7vLuTGTds6RndjuRk4jNpdtEW0wAt60fIVg7
 GhDbBPBIudyjqDNAf3a/emzGhZ2ogXeV99NaH4hJb9Rmk3Fqo2jySn5Dt580YwHn6oYp dQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2vk68utp1e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Oct 2019 00:40:21 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9H0SVqM026249;
        Thu, 17 Oct 2019 00:40:20 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2vp3bjbwqs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Oct 2019 00:40:20 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9H0eJTb018061;
        Thu, 17 Oct 2019 00:40:19 GMT
Received: from localhost (/10.145.178.76)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 17 Oct 2019 00:40:18 +0000
Date:   Wed, 16 Oct 2019 17:40:18 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs: support bulk loading of staged btrees
Message-ID: <20191017004018.GL26541@magnolia>
References: <157063967800.2912204.4012307770844087647.stgit@magnolia>
 <157063969861.2912204.17896220944927257559.stgit@magnolia>
 <20191016152648.GC41077@bfoster>
 <20191016181502.GA13108@magnolia>
 <20191016210731.GA17602@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191016210731.GA17602@bfoster>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9412 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910170001
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9412 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910170001
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 16, 2019 at 05:07:31PM -0400, Brian Foster wrote:
> On Wed, Oct 16, 2019 at 11:15:02AM -0700, Darrick J. Wong wrote:
> > On Wed, Oct 16, 2019 at 11:26:48AM -0400, Brian Foster wrote:
> > > On Wed, Oct 09, 2019 at 09:48:18AM -0700, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > > 
> > > > Add a new btree function that enables us to bulk load a btree cursor.
> > > > This will be used by the upcoming online repair patches to generate new
> > > > btrees.
> > > > 
> > > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > > ---
> > > >  fs/xfs/libxfs/xfs_btree.c |  566 +++++++++++++++++++++++++++++++++++++++++++++
> > > >  fs/xfs/libxfs/xfs_btree.h |   43 +++
> > > >  fs/xfs/xfs_trace.c        |    1 
> > > >  fs/xfs/xfs_trace.h        |   85 +++++++
> > > >  4 files changed, 694 insertions(+), 1 deletion(-)
> > > > 
> > > > 
> > > > diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
> > > > index 4b06d5d86834..17b0fdb87729 100644
> > > > --- a/fs/xfs/libxfs/xfs_btree.c
> > > > +++ b/fs/xfs/libxfs/xfs_btree.c
> > > ...
> > > > @@ -5104,3 +5104,567 @@ xfs_btree_commit_ifakeroot(
> > > >  	cur->bc_ops = ops;
> > > >  	cur->bc_flags &= ~XFS_BTREE_STAGING;
> > > >  }
> > > > +
> > > > +/*
> > > > + * Bulk Loading of Staged Btrees
> > > > + * =============================
> > > > + *
> > > > + * This interface is used with a staged btree cursor to create a totally new
> > > > + * btree with a large number of records (i.e. more than what would fit in a
> > > > + * single block).  When the creation is complete, the new root can be linked
> > > > + * atomically into the filesystem by committing the staged cursor.
> > > > + *
> > 
> > [paraphrasing a conversation we had on irc]
> > 
> > > Thanks for the documentation. So what is the purpose behind the whole
> > > bulk loading thing as opposed to something like faking up an AG
> > > structure (i.e. AGF) somewhere and using the existing cursor mechanisms
> > > (or something closer to it) to copy records from one place to another?
> > > Is it purely a performance/efficiency tradeoff? Bulk block allocation
> > > issues? Transactional/atomicity issues? All (or none :P) of the above?
> > 
> > Prior to the v20, the online repair series created a new btree root,
> > committed that into wherever the root lived, and inserted records one by
> > one into the btree.  There were quite a few drawbacks to this method:
> > 
> > 1. Inserting records one at a time can involve walking up the tree to
> > update node block pointers, which isn't terribly efficient if we're
> > likely going to rewrite the pointers (and relogging nodes) several more
> > times.
> > 
> > 2. Inserting records one at a time tends to leave a lot of half-empty
> > btree blocks because when one block fills up we split it and push half
> > the records to the new block.  It would be nice not to explode the size
> > of the btrees, and it would be particularly useful if we could control
> > the load factor of the new btree precisely.
> > 
> 
> Interesting... this is a trait the traditional btree update paths share
> though, right?

Right.  It's similar to the behavior Dave was seeing a couple of weeks
ago with Zorro's stress testing of the incore extent cache.

> > 3. The rebuild wasn't atomic, since we were replacing the root prior to
> > the insert loop.  If we crashed midway through a rebuild we'd end up
> > with a garbage btree and no indication that it was incorrect.  That's
> > how the fakeroot code got started.
> > 
> 
> Indeed, though this seems more related to the anchoring (i.e. fake root)
> approach than bulk vs. iterative construction.

Correct.

> > 4. In a previous version of the repair series I tried to batch as many
> > insert operations into a single transaction as possible, but my
> > transaction reservation fullness estimation function didn't work
> > reliably (particularly when things got really fragmented), so I backed
> > off to rolling after /every/ insertion.  That works well enough, but at
> > a cost of a lot of transaction rolling, which means that repairs plod
> > along very slowly.
> > 
> > 5. Performing an insert loop means that the btree blocks are allocated
> > one at a time as the btree expands.  This is suboptimal since we can
> > calculate the exact size of the new btree prior to building it, which
> > gives us the opportunity to recreate the index in a set of contiguous
> > blocks instead of scattering them.
> > 
> 
> Yep, FWIW it sounds like most of these tradeoffs are around
> performance/efficiency. 

<nod>

> > 6. If we crash midway through a rebuild, XFS neither cleaned up the mess
> > nor informed the administrator that it was necessary to re-run xfs_scrub
> > or xfs_repair to clean up the lost blocks.  Obviously, automatic cleanup
> > is a far better solution.
> > 
> 
> Similar to above, I think this kind of depends more on how/where to
> anchor an in-progress tree as opposed to what level records are copied
> at.

<nod> The six points are indeed the overall list of complaints about the
v19 code. :)

> > The first thing I decided to solve was the lack of atomicity.
> > 
> > For AG-rooted btrees, I thought about creating a fake xfs_buf for an AG
> > header buffer and extracting the root/level values after construction
> > completes.  That's possible, but it's risky because the fake buffer
> > could get logged and if the sector number matches the actual header
> > then it introduces buffer cache aliasing issues.
> > 
> > For inode-rooted btrees, one could create a fake xfs_inode with the same
> > i_ino as the target.  That presents the same aliasing issues as the fake
> > xfs_buf above.  A different strategy would be to allocate an unlinked
> > inode and then use the bmbt owner change (a.k.a. extent swap) to move
> > the mappings over.  That would work, though it has two large drawbacks:
> > (a) a lot of additional complexity around allocating and freeing the
> > temporary inode; and (b) future inode-rooted btrees such as the realtime
> > rmap btree would also have to implement an owner-change operation.
> > 
> 
> I was wondering more along the lines of having an actual anchor
> somewhere. E.g., think of it as a temporary/inaccessible location of a
> legitimate on-disk structure as opposed to a fake object in memory
> somewhere. A hidden/internal repair inode or some such, perhaps. I'm
> sure there's new code/complexity that would come around with that, but I
> think that's going to be unavoidable to some degree for an online repair
> mechanism. ;)

<nod> So far I /think/ I've managed to keep to an absolute minimum the
amount of metadata that gets written to disk prior to the commit.  I
haven't reread the series with an eye for how v20 is going to come up
short though. :)

I may very well have to revisit the hidden/internal repair inode concept
whenever I start working on rebuilding directories and xattrs since I
can't see any other way of atomically rebuilding those.  But that's
very very far out still.

> Note that this is all just handwaving on my part and still without full
> context as to how things are currently anchored, made atomic, etc. I'm
> primarily trying to understand the design reasoning based on the high
> level description.

<nod>

> > To fix (3), I thought it wise to have explicit fakeroot structures to
> > maintain a clean separation between what we're building and the rest of
> > the filesystem.  This also means that there's nothing on disk to clean
> > up if we fail at any point before we're ready to commit the new btree.
> > 
> 
> Hmm.. so this approach facilites a tree reconstruction in a single open
> transaction? If so, I suppose I could see some functional advantages to
> that.

Correct.

> > Then Dave (I think?) suggested that I  use EFIs strategically to
> > schedule freeing of the new btree blocks (the root commit transaction
> > would log EFDs to cancel them) and to schedule freeing of the old
> > blocks.  That solves (6), though the EFI wrangling doesn't happen for
> > another couple of series after this one.
> > 
> 
> Hm, Ok... so new btree block allocation(s?) in the same transaction as
> an EFI, to be processed on recovery if we crash, otherwise cancelled
> with an EFD on construction completion..?

Correct.  In the end, the transaction sequence looks like:

T[1]: Allocate an extent, log metadata updates to reflect that, log EFI
for the extent.

<repeat until we've allocated as many blocks as we need>

T[N]: Attach ordered buffers for the new btree's blocks.  Log the root
change.  Log EFDs for all the EFIs logged in T[1..N-1].  Log EFIs for
all the old btree blocks that we could find.

<roll transaction to write the ordered buffers and commit>

T[N+1]: Free an extent to finish the first EFI logged in the previous step.

<repeat until we've processed everything from the second wave of EFIs>

Call xfs_trans_commit and we're done.

> > He also suggested using ordered buffers to write out the new btree
> > blocks along with whatever logging was necessary to commit the new
> > btree.  It then occurred to me that xfs_repair open-codes the process of
> > calculating the geometry of a new btree, allocating all the blocks at
> > once, and writing out full btree blocks.  Somewhat annoyingly, it
> > features nearly the same (open-)code for all four AG btree types, which
> > is less maintainable than it could be.
> > 
> > I read through all four versions and used it to write the generic btree
> > bulk loading code.  For scrub I hooked that up to the "staged btree with
> > a fake root" stuff I'd already written, which solves (1), (2), (4), and
> > (5).
> > 
> > For xfsprogs[1], I deleted a few thousand lines of code from xfs_repair.
> > True, we don't reuse existing common code, but we at least get to share
> > new common btree code.
> > 
> 
> Yeah, the xfsprogs work certainly makes sense. Part of the reason I ask
> about this is the tradeoff of having multiple avenues to construct a
> tree in the kernel codebase.

<nod>

> > > This is my first pass through this so I'm mostly looking at big picture
> > > until I get to a point to see how these bits are used. The mechanism
> > > itself seems reasonable in principle, but the reason I ask is it also
> > > seems like there's inherent value in using more of same infrastructure
> > > to reconstruct a tree that we use to create one in the first place. We
> > > also already have primitives for things like fork swapping via the
> > > extent swap mechanism, etc.
> > 
> > "bfoster: I guess it would be nice to see that kind of make it work ->
> > make it fast evolution in tree"
> > 
> > For a while I did maintain the introduction of the bulk loading code as
> > separate patches against the v19 repair code, but unfortunately I
> > smushed them down before sending v20 to reduce the patch count, and
> > because I didn't want to argue with everyone over the semi-working code
> > that would then be replaced in the very next patch.
> > 
> 
> That's not quite what I meant... The approach you've taken makes sense
> to me for an implementation presented in a single series. I was more
> thinking that at the point where it was determined the implementation
> was going to change so drastically, after so many iterations it might
> have been useful to see the v19 approach merged in an experimental form

I would have liked to see the online repair stuff merged in experimental
form too so I can reduce the size of my patch queue, but oh well. :)

The silver lining to these lengthy reworks and slow review is that I can
come back and do a fresh self-review after a month and straighten out
the ugly parts as time goes by.  Unfortunately, that doesn't leave much
of a paper trail or obvious evidence of development history.

Eight months ago it occurred to me that perhaps there is some value in
retaining *some* periodic development history of this, so I've been
adding dated tags to my integration repo[1] based on my development
branch names, so I guess you could actually clone the git repo and git
diff from one tag to another.  In general I'll generate a new pile of
tags just before patchbombing.

(Granted 'repair-part-one' has been split into smaller parts now...)

> and then reworked upstream from there. Now that the new approach is
> implemented, I agree it's probably not worth reinserting the old
> approach at this point just to switch it out.

<nod>

> Thanks for the breakdown...

No problem, thanks for reading! :)

--D

[1] https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git

> Brian
> 
> > I could split them back out, though at a cost of having to reintroduce a
> > lot of hairy code in the bnobt/cntbt rebuild function to seed the free
> > new space btree root in order to make sure that the btree block
> > allocation code works properly, along with auditing the allocation paths
> > to make sure they don't use the old AGF or encounter other subtleties.
> > 
> > It'd be a lot of work considering that the v20 reconstruction code is
> > /much/ simpler than v19's was.  I also restructured the repair functions
> > to allocate one large context structure at the beginning instead of the
> > piecemeal way it was done onstack in v19 because stack usage was growing
> > close to 1k in some cases.
> > 
> > --D
> > 
> > [1] https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=repair-bulk-load
> > 
> > > 
> > > Brian
> > > 
> > > > + * The first step for the caller is to construct a fake btree root structure
> > > > + * and a staged btree cursor.  A staging cursor contains all the geometry
> > > > + * information for the btree type but will fail all operations that could have
> > > > + * side effects in the filesystem (e.g. btree shape changes).  Regular
> > > > + * operations will not work unless the staging cursor is committed and becomes
> > > > + * a regular cursor.
> > > > + *
> > > > + * For a btree rooted in an AG header, use an xbtree_afakeroot structure.
> > > > + * This should be initialized to zero.  For a btree rooted in an inode fork,
> > > > + * use an xbtree_ifakeroot structure.  @if_fork_size field should be set to
> > > > + * the number of bytes available to the fork in the inode; @if_fork should
> > > > + * point to a freshly allocated xfs_inode_fork; and @if_format should be set
> > > > + * to the appropriate fork type (e.g. XFS_DINODE_FMT_BTREE).
> > > > + *
> > > > + * The next step for the caller is to initialize a struct xfs_btree_bload
> > > > + * context.  The @nr_records field is the number of records that are to be
> > > > + * loaded into the btree.  The @leaf_slack and @node_slack fields are the
> > > > + * number of records (or key/ptr) slots to leave empty in new btree blocks.
> > > > + * If a caller sets a slack value to -1, the slack value will be computed to
> > > > + * fill the block halfway between minrecs and maxrecs items per block.
> > > > + *
> > > > + * The number of items placed in each btree block is computed via the following
> > > > + * algorithm: For leaf levels, the number of items for the level is nr_records.
> > > > + * For node levels, the number of items for the level is the number of blocks
> > > > + * in the next lower level of the tree.  For each level, the desired number of
> > > > + * items per block is defined as:
> > > > + *
> > > > + * desired = max(minrecs, maxrecs - slack factor)
> > > > + *
> > > > + * The number of blocks for the level is defined to be:
> > > > + *
> > > > + * blocks = nr_items / desired
> > > > + *
> > > > + * Note this is rounded down so that the npb calculation below will never fall
> > > > + * below minrecs.  The number of items that will actually be loaded into each
> > > > + * btree block is defined as:
> > > > + *
> > > > + * npb =  nr_items / blocks
> > > > + *
> > > > + * Some of the leftmost blocks in the level will contain one extra record as
> > > > + * needed to handle uneven division.  If the number of records in any block
> > > > + * would exceed maxrecs for that level, blocks is incremented and npb is
> > > > + * recalculated.
> > > > + *
> > > > + * In other words, we compute the number of blocks needed to satisfy a given
> > > > + * loading level, then spread the items as evenly as possible.
> > > > + *
> > > > + * To complete this step, call xfs_btree_bload_compute_geometry, which uses
> > > > + * those settings to compute the height of the btree and the number of blocks
> > > > + * that will be needed to construct the btree.  These values are stored in the
> > > > + * @btree_height and @nr_blocks fields.
> > > > + *
> > > > + * At this point, the caller must allocate @nr_blocks blocks and save them for
> > > > + * later.  If space is to be allocated transactionally, the staging cursor
> > > > + * must be deleted before and recreated after, which is why computing the
> > > > + * geometry is a separate step.
> > > > + *
> > > > + * The fourth step in the bulk loading process is to set the function pointers
> > > > + * in the bload context structure.  @get_data will be called for each record
> > > > + * that will be loaded into the btree; it should set the cursor's bc_rec
> > > > + * field, which will be converted to on-disk format and copied into the
> > > > + * appropriate record slot.  @alloc_block should supply one of the blocks
> > > > + * allocated in the previous step.  For btrees which are rooted in an inode
> > > > + * fork, @iroot_size is called to compute the size of the incore btree root
> > > > + * block.  Call xfs_btree_bload to start constructing the btree.
> > > > + *
> > > > + * The final step is to commit the staging cursor, which logs the new btree
> > > > + * root and turns the btree into a regular btree cursor, and free the fake
> > > > + * roots.
> > > > + */
> > > > +
> > > > +/*
> > > > + * Put a btree block that we're loading onto the ordered list and release it.
> > > > + * The btree blocks will be written when the final transaction swapping the
> > > > + * btree roots is committed.
> > > > + */
> > > > +static void
> > > > +xfs_btree_bload_drop_buf(
> > > > +	struct xfs_trans	*tp,
> > > > +	struct xfs_buf		**bpp)
> > > > +{
> > > > +	if (*bpp == NULL)
> > > > +		return;
> > > > +
> > > > +	xfs_trans_buf_set_type(tp, *bpp, XFS_BLFT_BTREE_BUF);
> > > > +	xfs_trans_ordered_buf(tp, *bpp);
> > > > +	xfs_trans_brelse(tp, *bpp);
> > > > +	*bpp = NULL;
> > > > +}
> > > > +
> > > > +/* Allocate and initialize one btree block for bulk loading. */
> > > > +STATIC int
> > > > +xfs_btree_bload_prep_block(
> > > > +	struct xfs_btree_cur		*cur,
> > > > +	struct xfs_btree_bload		*bbl,
> > > > +	unsigned int			level,
> > > > +	unsigned int			nr_this_block,
> > > > +	union xfs_btree_ptr		*ptrp,
> > > > +	struct xfs_buf			**bpp,
> > > > +	struct xfs_btree_block		**blockp,
> > > > +	void				*priv)
> > > > +{
> > > > +	union xfs_btree_ptr		new_ptr;
> > > > +	struct xfs_buf			*new_bp;
> > > > +	struct xfs_btree_block		*new_block;
> > > > +	int				ret;
> > > > +
> > > > +	if ((cur->bc_flags & XFS_BTREE_ROOT_IN_INODE) &&
> > > > +	    level == cur->bc_nlevels - 1) {
> > > > +		struct xfs_ifork	*ifp = cur->bc_private.b.ifake->if_fork;
> > > > +		size_t			new_size;
> > > > +
> > > > +		/* Allocate a new incore btree root block. */
> > > > +		new_size = bbl->iroot_size(cur, nr_this_block, priv);
> > > > +		ifp->if_broot = kmem_zalloc(new_size, 0);
> > > > +		ifp->if_broot_bytes = (int)new_size;
> > > > +		ifp->if_flags |= XFS_IFBROOT;
> > > > +
> > > > +		/* Initialize it and send it out. */
> > > > +		xfs_btree_init_block_int(cur->bc_mp, ifp->if_broot,
> > > > +				XFS_BUF_DADDR_NULL, cur->bc_btnum, level,
> > > > +				nr_this_block, cur->bc_private.b.ip->i_ino,
> > > > +				cur->bc_flags);
> > > > +
> > > > +		*bpp = NULL;
> > > > +		*blockp = ifp->if_broot;
> > > > +		xfs_btree_set_ptr_null(cur, ptrp);
> > > > +		return 0;
> > > > +	}
> > > > +
> > > > +	/* Allocate a new leaf block. */
> > > > +	ret = bbl->alloc_block(cur, &new_ptr, priv);
> > > > +	if (ret)
> > > > +		return ret;
> > > > +
> > > > +	ASSERT(!xfs_btree_ptr_is_null(cur, &new_ptr));
> > > > +
> > > > +	ret = xfs_btree_get_buf_block(cur, &new_ptr, &new_block, &new_bp);
> > > > +	if (ret)
> > > > +		return ret;
> > > > +
> > > > +	/* Initialize the btree block. */
> > > > +	xfs_btree_init_block_cur(cur, new_bp, level, nr_this_block);
> > > > +	if (*blockp)
> > > > +		xfs_btree_set_sibling(cur, *blockp, &new_ptr, XFS_BB_RIGHTSIB);
> > > > +	xfs_btree_set_sibling(cur, new_block, ptrp, XFS_BB_LEFTSIB);
> > > > +	xfs_btree_set_numrecs(new_block, nr_this_block);
> > > > +
> > > > +	/* Release the old block and set the out parameters. */
> > > > +	xfs_btree_bload_drop_buf(cur->bc_tp, bpp);
> > > > +	*blockp = new_block;
> > > > +	*bpp = new_bp;
> > > > +	xfs_btree_copy_ptrs(cur, ptrp, &new_ptr, 1);
> > > > +	return 0;
> > > > +}
> > > > +
> > > > +/* Load one leaf block. */
> > > > +STATIC int
> > > > +xfs_btree_bload_leaf(
> > > > +	struct xfs_btree_cur		*cur,
> > > > +	unsigned int			recs_this_block,
> > > > +	xfs_btree_bload_get_fn		get_data,
> > > > +	struct xfs_btree_block		*block,
> > > > +	void				*priv)
> > > > +{
> > > > +	unsigned int			j;
> > > > +	int				ret;
> > > > +
> > > > +	/* Fill the leaf block with records. */
> > > > +	for (j = 1; j <= recs_this_block; j++) {
> > > > +		union xfs_btree_rec	*block_recs;
> > > > +
> > > > +		ret = get_data(cur, priv);
> > > > +		if (ret)
> > > > +			return ret;
> > > > +		block_recs = xfs_btree_rec_addr(cur, j, block);
> > > > +		cur->bc_ops->init_rec_from_cur(cur, block_recs);
> > > > +	}
> > > > +
> > > > +	return 0;
> > > > +}
> > > > +
> > > > +/* Load one node block. */
> > > > +STATIC int
> > > > +xfs_btree_bload_node(
> > > > +	struct xfs_btree_cur	*cur,
> > > > +	unsigned int		recs_this_block,
> > > > +	union xfs_btree_ptr	*child_ptr,
> > > > +	struct xfs_btree_block	*block)
> > > > +{
> > > > +	unsigned int		j;
> > > > +	int			ret;
> > > > +
> > > > +	/* Fill the node block with keys and pointers. */
> > > > +	for (j = 1; j <= recs_this_block; j++) {
> > > > +		union xfs_btree_key	child_key;
> > > > +		union xfs_btree_ptr	*block_ptr;
> > > > +		union xfs_btree_key	*block_key;
> > > > +		struct xfs_btree_block	*child_block;
> > > > +		struct xfs_buf		*child_bp;
> > > > +
> > > > +		ASSERT(!xfs_btree_ptr_is_null(cur, child_ptr));
> > > > +
> > > > +		ret = xfs_btree_get_buf_block(cur, child_ptr, &child_block,
> > > > +				&child_bp);
> > > > +		if (ret)
> > > > +			return ret;
> > > > +
> > > > +		xfs_btree_get_keys(cur, child_block, &child_key);
> > > > +
> > > > +		block_ptr = xfs_btree_ptr_addr(cur, j, block);
> > > > +		xfs_btree_copy_ptrs(cur, block_ptr, child_ptr, 1);
> > > > +
> > > > +		block_key = xfs_btree_key_addr(cur, j, block);
> > > > +		xfs_btree_copy_keys(cur, block_key, &child_key, 1);
> > > > +
> > > > +		xfs_btree_get_sibling(cur, child_block, child_ptr,
> > > > +				XFS_BB_RIGHTSIB);
> > > > +		xfs_trans_brelse(cur->bc_tp, child_bp);
> > > > +	}
> > > > +
> > > > +	return 0;
> > > > +}
> > > > +
> > > > +/*
> > > > + * Compute the maximum number of records (or keyptrs) per block that we want to
> > > > + * install at this level in the btree.  Caller is responsible for having set
> > > > + * @cur->bc_private.b.forksize to the desired fork size, if appropriate.
> > > > + */
> > > > +STATIC unsigned int
> > > > +xfs_btree_bload_max_npb(
> > > > +	struct xfs_btree_cur	*cur,
> > > > +	struct xfs_btree_bload	*bbl,
> > > > +	unsigned int		level)
> > > > +{
> > > > +	unsigned int		ret;
> > > > +
> > > > +	if (level == cur->bc_nlevels - 1 && cur->bc_ops->get_dmaxrecs)
> > > > +		return cur->bc_ops->get_dmaxrecs(cur, level);
> > > > +
> > > > +	ret = cur->bc_ops->get_maxrecs(cur, level);
> > > > +	if (level == 0)
> > > > +		ret -= bbl->leaf_slack;
> > > > +	else
> > > > +		ret -= bbl->node_slack;
> > > > +	return ret;
> > > > +}
> > > > +
> > > > +/*
> > > > + * Compute the desired number of records (or keyptrs) per block that we want to
> > > > + * install at this level in the btree, which must be somewhere between minrecs
> > > > + * and max_npb.  The caller is free to install fewer records per block.
> > > > + */
> > > > +STATIC unsigned int
> > > > +xfs_btree_bload_desired_npb(
> > > > +	struct xfs_btree_cur	*cur,
> > > > +	struct xfs_btree_bload	*bbl,
> > > > +	unsigned int		level)
> > > > +{
> > > > +	unsigned int		npb = xfs_btree_bload_max_npb(cur, bbl, level);
> > > > +
> > > > +	/* Root blocks are not subject to minrecs rules. */
> > > > +	if (level == cur->bc_nlevels - 1)
> > > > +		return max(1U, npb);
> > > > +
> > > > +	return max_t(unsigned int, cur->bc_ops->get_minrecs(cur, level), npb);
> > > > +}
> > > > +
> > > > +/*
> > > > + * Compute the number of records to be stored in each block at this level and
> > > > + * the number of blocks for this level.  For leaf levels, we must populate an
> > > > + * empty root block even if there are no records, so we have to have at least
> > > > + * one block.
> > > > + */
> > > > +STATIC void
> > > > +xfs_btree_bload_level_geometry(
> > > > +	struct xfs_btree_cur	*cur,
> > > > +	struct xfs_btree_bload	*bbl,
> > > > +	unsigned int		level,
> > > > +	uint64_t		nr_this_level,
> > > > +	unsigned int		*avg_per_block,
> > > > +	uint64_t		*blocks,
> > > > +	uint64_t		*blocks_with_extra)
> > > > +{
> > > > +	uint64_t		npb;
> > > > +	uint64_t		dontcare;
> > > > +	unsigned int		desired_npb;
> > > > +	unsigned int		maxnr;
> > > > +
> > > > +	maxnr = cur->bc_ops->get_maxrecs(cur, level);
> > > > +
> > > > +	/*
> > > > +	 * Compute the number of blocks we need to fill each block with the
> > > > +	 * desired number of records/keyptrs per block.  Because desired_npb
> > > > +	 * could be minrecs, we use regular integer division (which rounds
> > > > +	 * the block count down) so that in the next step the effective # of
> > > > +	 * items per block will never be less than desired_npb.
> > > > +	 */
> > > > +	desired_npb = xfs_btree_bload_desired_npb(cur, bbl, level);
> > > > +	*blocks = div64_u64_rem(nr_this_level, desired_npb, &dontcare);
> > > > +	*blocks = max(1ULL, *blocks);
> > > > +
> > > > +	/*
> > > > +	 * Compute the number of records that we will actually put in each
> > > > +	 * block, assuming that we want to spread the records evenly between
> > > > +	 * the blocks.  Take care that the effective # of items per block (npb)
> > > > +	 * won't exceed maxrecs even for the blocks that get an extra record,
> > > > +	 * since desired_npb could be maxrecs, and in the previous step we
> > > > +	 * rounded the block count down.
> > > > +	 */
> > > > +	npb = div64_u64_rem(nr_this_level, *blocks, blocks_with_extra);
> > > > +	if (npb > maxnr || (npb == maxnr && *blocks_with_extra > 0)) {
> > > > +		(*blocks)++;
> > > > +		npb = div64_u64_rem(nr_this_level, *blocks, blocks_with_extra);
> > > > +	}
> > > > +
> > > > +	*avg_per_block = min_t(uint64_t, npb, nr_this_level);
> > > > +
> > > > +	trace_xfs_btree_bload_level_geometry(cur, level, nr_this_level,
> > > > +			*avg_per_block, desired_npb, *blocks,
> > > > +			*blocks_with_extra);
> > > > +}
> > > > +
> > > > +/*
> > > > + * Ensure a slack value is appropriate for the btree.
> > > > + *
> > > > + * If the slack value is negative, set slack so that we fill the block to
> > > > + * halfway between minrecs and maxrecs.  Make sure the slack is never so large
> > > > + * that we can underflow minrecs.
> > > > + */
> > > > +static void
> > > > +xfs_btree_bload_ensure_slack(
> > > > +	struct xfs_btree_cur	*cur,
> > > > +	int			*slack,
> > > > +	int			level)
> > > > +{
> > > > +	int			maxr;
> > > > +	int			minr;
> > > > +
> > > > +	/*
> > > > +	 * We only care about slack for btree blocks, so set the btree nlevels
> > > > +	 * to 3 so that level 0 is a leaf block and level 1 is a node block.
> > > > +	 * Avoid straying into inode roots, since we don't do slack there.
> > > > +	 */
> > > > +	cur->bc_nlevels = 3;
> > > > +	maxr = cur->bc_ops->get_maxrecs(cur, level);
> > > > +	minr = cur->bc_ops->get_minrecs(cur, level);
> > > > +
> > > > +	/*
> > > > +	 * If slack is negative, automatically set slack so that we load the
> > > > +	 * btree block approximately halfway between minrecs and maxrecs.
> > > > +	 * Generally, this will net us 75% loading.
> > > > +	 */
> > > > +	if (*slack < 0)
> > > > +		*slack = maxr - ((maxr + minr) >> 1);
> > > > +
> > > > +	*slack = min(*slack, maxr - minr);
> > > > +}
> > > > +
> > > > +/*
> > > > + * Prepare a btree cursor for a bulk load operation by computing the geometry
> > > > + * fields in @bbl.  Caller must ensure that the btree cursor is a staging
> > > > + * cursor.  This function can be called multiple times.
> > > > + */
> > > > +int
> > > > +xfs_btree_bload_compute_geometry(
> > > > +	struct xfs_btree_cur	*cur,
> > > > +	struct xfs_btree_bload	*bbl,
> > > > +	uint64_t		nr_records)
> > > > +{
> > > > +	uint64_t		nr_blocks = 0;
> > > > +	uint64_t		nr_this_level;
> > > > +
> > > > +	ASSERT(cur->bc_flags & XFS_BTREE_STAGING);
> > > > +
> > > > +	xfs_btree_bload_ensure_slack(cur, &bbl->leaf_slack, 0);
> > > > +	xfs_btree_bload_ensure_slack(cur, &bbl->node_slack, 1);
> > > > +
> > > > +	bbl->nr_records = nr_this_level = nr_records;
> > > > +	for (cur->bc_nlevels = 1; cur->bc_nlevels < XFS_BTREE_MAXLEVELS;) {
> > > > +		uint64_t	level_blocks;
> > > > +		uint64_t	dontcare64;
> > > > +		unsigned int	level = cur->bc_nlevels - 1;
> > > > +		unsigned int	avg_per_block;
> > > > +
> > > > +		/*
> > > > +		 * If all the things we want to store at this level would fit
> > > > +		 * in a single root block, then we have our btree root and are
> > > > +		 * done.  Note that bmap btrees do not allow records in the
> > > > +		 * root.
> > > > +		 */
> > > > +		if (!(cur->bc_flags & XFS_BTREE_ROOT_IN_INODE) || level != 0) {
> > > > +			xfs_btree_bload_level_geometry(cur, bbl, level,
> > > > +					nr_this_level, &avg_per_block,
> > > > +					&level_blocks, &dontcare64);
> > > > +			if (nr_this_level <= avg_per_block) {
> > > > +				nr_blocks++;
> > > > +				break;
> > > > +			}
> > > > +		}
> > > > +
> > > > +		/*
> > > > +		 * Otherwise, we have to store all the records for this level
> > > > +		 * in blocks and therefore need another level of btree to point
> > > > +		 * to those blocks.  Increase the number of levels and
> > > > +		 * recompute the number of records we can store at this level
> > > > +		 * because that can change depending on whether or not a level
> > > > +		 * is the root level.
> > > > +		 */
> > > > +		cur->bc_nlevels++;
> > > > +		xfs_btree_bload_level_geometry(cur, bbl, level, nr_this_level,
> > > > +				&avg_per_block, &level_blocks, &dontcare64);
> > > > +		nr_blocks += level_blocks;
> > > > +		nr_this_level = level_blocks;
> > > > +	}
> > > > +
> > > > +	if (cur->bc_nlevels == XFS_BTREE_MAXLEVELS)
> > > > +		return -EOVERFLOW;
> > > > +
> > > > +	bbl->btree_height = cur->bc_nlevels;
> > > > +	if (cur->bc_flags & XFS_BTREE_ROOT_IN_INODE)
> > > > +		bbl->nr_blocks = nr_blocks - 1;
> > > > +	else
> > > > +		bbl->nr_blocks = nr_blocks;
> > > > +	return 0;
> > > > +}
> > > > +
> > > > +/*
> > > > + * Bulk load a btree.
> > > > + *
> > > > + * Load @bbl->nr_records quantity of records into a btree using the supplied
> > > > + * empty and staging btree cursor @cur and a @bbl that has been filled out by
> > > > + * the xfs_btree_bload_compute_geometry function.
> > > > + *
> > > > + * The @bbl->get_data function must populate the cursor's bc_rec every time it
> > > > + * is called.  The @bbl->alloc_block function will be used to allocate new
> > > > + * btree blocks.  @priv is passed to both functions.
> > > > + *
> > > > + * Caller must ensure that @cur is a staging cursor.  Any existing btree rooted
> > > > + * in the fakeroot will be lost, so do not call this function twice.
> > > > + */
> > > > +int
> > > > +xfs_btree_bload(
> > > > +	struct xfs_btree_cur		*cur,
> > > > +	struct xfs_btree_bload		*bbl,
> > > > +	void				*priv)
> > > > +{
> > > > +	union xfs_btree_ptr		child_ptr;
> > > > +	union xfs_btree_ptr		ptr;
> > > > +	struct xfs_buf			*bp = NULL;
> > > > +	struct xfs_btree_block		*block = NULL;
> > > > +	uint64_t			nr_this_level = bbl->nr_records;
> > > > +	uint64_t			blocks;
> > > > +	uint64_t			i;
> > > > +	uint64_t			blocks_with_extra;
> > > > +	uint64_t			total_blocks = 0;
> > > > +	unsigned int			avg_per_block;
> > > > +	unsigned int			level = 0;
> > > > +	int				ret;
> > > > +
> > > > +	ASSERT(cur->bc_flags & XFS_BTREE_STAGING);
> > > > +
> > > > +	cur->bc_nlevels = bbl->btree_height;
> > > > +	xfs_btree_set_ptr_null(cur, &child_ptr);
> > > > +	xfs_btree_set_ptr_null(cur, &ptr);
> > > > +
> > > > +	xfs_btree_bload_level_geometry(cur, bbl, level, nr_this_level,
> > > > +			&avg_per_block, &blocks, &blocks_with_extra);
> > > > +
> > > > +	/* Load each leaf block. */
> > > > +	for (i = 0; i < blocks; i++) {
> > > > +		unsigned int		nr_this_block = avg_per_block;
> > > > +
> > > > +		if (i < blocks_with_extra)
> > > > +			nr_this_block++;
> > > > +
> > > > +		ret = xfs_btree_bload_prep_block(cur, bbl, level,
> > > > +				nr_this_block, &ptr, &bp, &block, priv);
> > > > +		if (ret)
> > > > +			return ret;
> > > > +
> > > > +		trace_xfs_btree_bload_block(cur, level, i, blocks, &ptr,
> > > > +				nr_this_block);
> > > > +
> > > > +		ret = xfs_btree_bload_leaf(cur, nr_this_block, bbl->get_data,
> > > > +				block, priv);
> > > > +		if (ret)
> > > > +			goto out;
> > > > +
> > > > +		/* Record the leftmost pointer to start the next level. */
> > > > +		if (i == 0)
> > > > +			xfs_btree_copy_ptrs(cur, &child_ptr, &ptr, 1);
> > > > +	}
> > > > +	total_blocks += blocks;
> > > > +	xfs_btree_bload_drop_buf(cur->bc_tp, &bp);
> > > > +
> > > > +	/* Populate the internal btree nodes. */
> > > > +	for (level = 1; level < cur->bc_nlevels; level++) {
> > > > +		union xfs_btree_ptr	first_ptr;
> > > > +
> > > > +		nr_this_level = blocks;
> > > > +		block = NULL;
> > > > +		xfs_btree_set_ptr_null(cur, &ptr);
> > > > +
> > > > +		xfs_btree_bload_level_geometry(cur, bbl, level, nr_this_level,
> > > > +				&avg_per_block, &blocks, &blocks_with_extra);
> > > > +
> > > > +		/* Load each node block. */
> > > > +		for (i = 0; i < blocks; i++) {
> > > > +			unsigned int	nr_this_block = avg_per_block;
> > > > +
> > > > +			if (i < blocks_with_extra)
> > > > +				nr_this_block++;
> > > > +
> > > > +			ret = xfs_btree_bload_prep_block(cur, bbl, level,
> > > > +					nr_this_block, &ptr, &bp, &block,
> > > > +					priv);
> > > > +			if (ret)
> > > > +				return ret;
> > > > +
> > > > +			trace_xfs_btree_bload_block(cur, level, i, blocks,
> > > > +					&ptr, nr_this_block);
> > > > +
> > > > +			ret = xfs_btree_bload_node(cur, nr_this_block,
> > > > +					&child_ptr, block);
> > > > +			if (ret)
> > > > +				goto out;
> > > > +
> > > > +			/*
> > > > +			 * Record the leftmost pointer to start the next level.
> > > > +			 */
> > > > +			if (i == 0)
> > > > +				xfs_btree_copy_ptrs(cur, &first_ptr, &ptr, 1);
> > > > +		}
> > > > +		total_blocks += blocks;
> > > > +		xfs_btree_bload_drop_buf(cur->bc_tp, &bp);
> > > > +		xfs_btree_copy_ptrs(cur, &child_ptr, &first_ptr, 1);
> > > > +	}
> > > > +
> > > > +	/* Initialize the new root. */
> > > > +	if (cur->bc_flags & XFS_BTREE_ROOT_IN_INODE) {
> > > > +		ASSERT(xfs_btree_ptr_is_null(cur, &ptr));
> > > > +		cur->bc_private.b.ifake->if_levels = cur->bc_nlevels;
> > > > +		cur->bc_private.b.ifake->if_blocks = total_blocks - 1;
> > > > +	} else {
> > > > +		cur->bc_private.a.afake->af_root = be32_to_cpu(ptr.s);
> > > > +		cur->bc_private.a.afake->af_levels = cur->bc_nlevels;
> > > > +		cur->bc_private.a.afake->af_blocks = total_blocks;
> > > > +	}
> > > > +out:
> > > > +	if (bp)
> > > > +		xfs_trans_brelse(cur->bc_tp, bp);
> > > > +	return ret;
> > > > +}
> > > > diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
> > > > index a17becb72ab8..5c6992a04ea2 100644
> > > > --- a/fs/xfs/libxfs/xfs_btree.h
> > > > +++ b/fs/xfs/libxfs/xfs_btree.h
> > > > @@ -582,4 +582,47 @@ void xfs_btree_stage_ifakeroot(struct xfs_btree_cur *cur,
> > > >  void xfs_btree_commit_ifakeroot(struct xfs_btree_cur *cur, int whichfork,
> > > >  		const struct xfs_btree_ops *ops);
> > > >  
> > > > +typedef int (*xfs_btree_bload_get_fn)(struct xfs_btree_cur *cur, void *priv);
> > > > +typedef int (*xfs_btree_bload_alloc_block_fn)(struct xfs_btree_cur *cur,
> > > > +		union xfs_btree_ptr *ptr, void *priv);
> > > > +typedef size_t (*xfs_btree_bload_iroot_size_fn)(struct xfs_btree_cur *cur,
> > > > +		unsigned int nr_this_level, void *priv);
> > > > +
> > > > +/* Bulk loading of staged btrees. */
> > > > +struct xfs_btree_bload {
> > > > +	/* Function to store a record in the cursor. */
> > > > +	xfs_btree_bload_get_fn		get_data;
> > > > +
> > > > +	/* Function to allocate a block for the btree. */
> > > > +	xfs_btree_bload_alloc_block_fn	alloc_block;
> > > > +
> > > > +	/* Function to compute the size of the in-core btree root block. */
> > > > +	xfs_btree_bload_iroot_size_fn	iroot_size;
> > > > +
> > > > +	/* Number of records the caller wants to store. */
> > > > +	uint64_t			nr_records;
> > > > +
> > > > +	/* Number of btree blocks needed to store those records. */
> > > > +	uint64_t			nr_blocks;
> > > > +
> > > > +	/*
> > > > +	 * Number of free records to leave in each leaf block.  If this (or
> > > > +	 * any of the slack values) are negative, this will be computed to
> > > > +	 * be halfway between maxrecs and minrecs.  This typically leaves the
> > > > +	 * block 75% full.
> > > > +	 */
> > > > +	int				leaf_slack;
> > > > +
> > > > +	/* Number of free keyptrs to leave in each node block. */
> > > > +	int				node_slack;
> > > > +
> > > > +	/* Computed btree height. */
> > > > +	unsigned int			btree_height;
> > > > +};
> > > > +
> > > > +int xfs_btree_bload_compute_geometry(struct xfs_btree_cur *cur,
> > > > +		struct xfs_btree_bload *bbl, uint64_t nr_records);
> > > > +int xfs_btree_bload(struct xfs_btree_cur *cur, struct xfs_btree_bload *bbl,
> > > > +		void *priv);
> > > > +
> > > >  #endif	/* __XFS_BTREE_H__ */
> > > > diff --git a/fs/xfs/xfs_trace.c b/fs/xfs/xfs_trace.c
> > > > index bc85b89f88ca..9b5e58a92381 100644
> > > > --- a/fs/xfs/xfs_trace.c
> > > > +++ b/fs/xfs/xfs_trace.c
> > > > @@ -6,6 +6,7 @@
> > > >  #include "xfs.h"
> > > >  #include "xfs_fs.h"
> > > >  #include "xfs_shared.h"
> > > > +#include "xfs_bit.h"
> > > >  #include "xfs_format.h"
> > > >  #include "xfs_log_format.h"
> > > >  #include "xfs_trans_resv.h"
> > > > diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> > > > index a78055521fcd..6d7ba64b7a0f 100644
> > > > --- a/fs/xfs/xfs_trace.h
> > > > +++ b/fs/xfs/xfs_trace.h
> > > > @@ -35,6 +35,7 @@ struct xfs_icreate_log;
> > > >  struct xfs_owner_info;
> > > >  struct xfs_trans_res;
> > > >  struct xfs_inobt_rec_incore;
> > > > +union xfs_btree_ptr;
> > > >  
> > > >  DECLARE_EVENT_CLASS(xfs_attr_list_class,
> > > >  	TP_PROTO(struct xfs_attr_list_context *ctx),
> > > > @@ -3670,6 +3671,90 @@ TRACE_EVENT(xfs_btree_commit_ifakeroot,
> > > >  		  __entry->blocks)
> > > >  )
> > > >  
> > > > +TRACE_EVENT(xfs_btree_bload_level_geometry,
> > > > +	TP_PROTO(struct xfs_btree_cur *cur, unsigned int level,
> > > > +		 uint64_t nr_this_level, unsigned int nr_per_block,
> > > > +		 unsigned int desired_npb, uint64_t blocks,
> > > > +		 uint64_t blocks_with_extra),
> > > > +	TP_ARGS(cur, level, nr_this_level, nr_per_block, desired_npb, blocks,
> > > > +		blocks_with_extra),
> > > > +	TP_STRUCT__entry(
> > > > +		__field(dev_t, dev)
> > > > +		__field(xfs_btnum_t, btnum)
> > > > +		__field(unsigned int, level)
> > > > +		__field(unsigned int, nlevels)
> > > > +		__field(uint64_t, nr_this_level)
> > > > +		__field(unsigned int, nr_per_block)
> > > > +		__field(unsigned int, desired_npb)
> > > > +		__field(unsigned long long, blocks)
> > > > +		__field(unsigned long long, blocks_with_extra)
> > > > +	),
> > > > +	TP_fast_assign(
> > > > +		__entry->dev = cur->bc_mp->m_super->s_dev;
> > > > +		__entry->btnum = cur->bc_btnum;
> > > > +		__entry->level = level;
> > > > +		__entry->nlevels = cur->bc_nlevels;
> > > > +		__entry->nr_this_level = nr_this_level;
> > > > +		__entry->nr_per_block = nr_per_block;
> > > > +		__entry->desired_npb = desired_npb;
> > > > +		__entry->blocks = blocks;
> > > > +		__entry->blocks_with_extra = blocks_with_extra;
> > > > +	),
> > > > +	TP_printk("dev %d:%d btree %s level %u/%u nr_this_level %llu nr_per_block %u desired_npb %u blocks %llu blocks_with_extra %llu",
> > > > +		  MAJOR(__entry->dev), MINOR(__entry->dev),
> > > > +		  __print_symbolic(__entry->btnum, XFS_BTNUM_STRINGS),
> > > > +		  __entry->level,
> > > > +		  __entry->nlevels,
> > > > +		  __entry->nr_this_level,
> > > > +		  __entry->nr_per_block,
> > > > +		  __entry->desired_npb,
> > > > +		  __entry->blocks,
> > > > +		  __entry->blocks_with_extra)
> > > > +)
> > > > +
> > > > +TRACE_EVENT(xfs_btree_bload_block,
> > > > +	TP_PROTO(struct xfs_btree_cur *cur, unsigned int level,
> > > > +		 uint64_t block_idx, uint64_t nr_blocks,
> > > > +		 union xfs_btree_ptr *ptr, unsigned int nr_records),
> > > > +	TP_ARGS(cur, level, block_idx, nr_blocks, ptr, nr_records),
> > > > +	TP_STRUCT__entry(
> > > > +		__field(dev_t, dev)
> > > > +		__field(xfs_btnum_t, btnum)
> > > > +		__field(unsigned int, level)
> > > > +		__field(unsigned long long, block_idx)
> > > > +		__field(unsigned long long, nr_blocks)
> > > > +		__field(xfs_agnumber_t, agno)
> > > > +		__field(xfs_agblock_t, agbno)
> > > > +		__field(unsigned int, nr_records)
> > > > +	),
> > > > +	TP_fast_assign(
> > > > +		__entry->dev = cur->bc_mp->m_super->s_dev;
> > > > +		__entry->btnum = cur->bc_btnum;
> > > > +		__entry->level = level;
> > > > +		__entry->block_idx = block_idx;
> > > > +		__entry->nr_blocks = nr_blocks;
> > > > +		if (cur->bc_flags & XFS_BTREE_LONG_PTRS) {
> > > > +			xfs_fsblock_t	fsb = be64_to_cpu(ptr->l);
> > > > +
> > > > +			__entry->agno = XFS_FSB_TO_AGNO(cur->bc_mp, fsb);
> > > > +			__entry->agbno = XFS_FSB_TO_AGBNO(cur->bc_mp, fsb);
> > > > +		} else {
> > > > +			__entry->agno = cur->bc_private.a.agno;
> > > > +			__entry->agbno = be32_to_cpu(ptr->s);
> > > > +		}
> > > > +		__entry->nr_records = nr_records;
> > > > +	),
> > > > +	TP_printk("dev %d:%d btree %s level %u block %llu/%llu fsb (%u/%u) recs %u",
> > > > +		  MAJOR(__entry->dev), MINOR(__entry->dev),
> > > > +		  __print_symbolic(__entry->btnum, XFS_BTNUM_STRINGS),
> > > > +		  __entry->level,
> > > > +		  __entry->block_idx,
> > > > +		  __entry->nr_blocks,
> > > > +		  __entry->agno,
> > > > +		  __entry->agbno,
> > > > +		  __entry->nr_records)
> > > > +)
> > > > +
> > > >  #endif /* _TRACE_XFS_H */
> > > >  
> > > >  #undef TRACE_INCLUDE_PATH
> > > > 
