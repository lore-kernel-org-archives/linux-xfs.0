Return-Path: <SRS0=P3J0=4X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79211C10DCE
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Mar 2020 17:25:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2D53A20658
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Mar 2020 17:25:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eKTR1NUi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726083AbgCFRZn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 6 Mar 2020 12:25:43 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:35449 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725935AbgCFRZn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Mar 2020 12:25:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583515536;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NX2Mqg7RBP3xLbwoKHK4xumMnklMFVh1kFJ7eFnZQNw=;
        b=eKTR1NUirQc5x63kXog5bQoPj+T/JroHY0VikoSCr8NXQ6dg7Nu0WCcBMkOLXZAggZNuhe
        sJR1Pv7GRQzlEJUz3u15RRlLx0DLSxHjP3zauY4jD4AjDOeYfgV5vWHaciNlw7SqXZrvHx
        H1B1dbpTo1US+XypI1esaUK8Iz4Kf68=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-251-fud8S6RVOXiKtv0_bVdcaw-1; Fri, 06 Mar 2020 12:25:33 -0500
X-MC-Unique: fud8S6RVOXiKtv0_bVdcaw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AD582107ACC7;
        Fri,  6 Mar 2020 17:25:32 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1424B5C290;
        Fri,  6 Mar 2020 17:25:31 +0000 (UTC)
Date:   Fri, 6 Mar 2020 12:25:30 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs: support bulk loading of staged btrees
Message-ID: <20200306172530.GL2773@bfoster>
References: <158329250190.2423432.16958662769192587982.stgit@magnolia>
 <158329252104.2423432.14412164596264053619.stgit@magnolia>
 <20200304182144.GC22037@bfoster>
 <20200305012213.GL8045@magnolia>
 <20200305143029.GB27418@bfoster>
 <20200305235902.GH1752567@magnolia>
 <20200306142300.GC2773@bfoster>
 <20200306165144.GY8045@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200306165144.GY8045@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 06, 2020 at 08:51:44AM -0800, Darrick J. Wong wrote:
> On Fri, Mar 06, 2020 at 09:23:00AM -0500, Brian Foster wrote:
> > On Thu, Mar 05, 2020 at 03:59:02PM -0800, Darrick J. Wong wrote:
> > > On Thu, Mar 05, 2020 at 09:30:29AM -0500, Brian Foster wrote:
> > > > On Wed, Mar 04, 2020 at 05:22:13PM -0800, Darrick J. Wong wrote:
> > > > > On Wed, Mar 04, 2020 at 01:21:44PM -0500, Brian Foster wrote:
> > > > > > On Tue, Mar 03, 2020 at 07:28:41PM -0800, Darrick J. Wong wrote:
> > > > > > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > > > > > 
> > > > > > > Add a new btree function that enables us to bulk load a btree cursor.
> > > > > > > This will be used by the upcoming online repair patches to generate new
> > > > > > > btrees.  This avoids the programmatic inefficiency of calling
> > > > > > > xfs_btree_insert in a loop (which generates a lot of log traffic) in
> > > > > > > favor of stamping out new btree blocks with ordered buffers, and then
> > > > > > > committing both the new root and scheduling the removal of the old btree
> > > > > > > blocks in a single transaction commit.
> > > > > > > 
> > > > > > > The design of this new generic code is based off the btree rebuilding
> > > > > > > code in xfs_repair's phase 5 code, with the explicit goal of enabling us
> > > > > > > to share that code between scrub and repair.  It has the additional
> > > > > > > feature of being able to control btree block loading factors.
> > > > > > > 
> > > > > > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > > > > > ---
> > > > > > >  fs/xfs/libxfs/xfs_btree.c |  581 +++++++++++++++++++++++++++++++++++++++++++++
> > > > > > >  fs/xfs/libxfs/xfs_btree.h |   46 ++++
> > > > > > >  fs/xfs/xfs_trace.c        |    1 
> > > > > > >  fs/xfs/xfs_trace.h        |   85 +++++++
> > > > > > >  4 files changed, 712 insertions(+), 1 deletion(-)
> > > > > > > 
> > > > > > > 
> > > > > > > diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
> > > > > > > index 469e1e9053bb..c21db7ed8481 100644
> > > > > > > --- a/fs/xfs/libxfs/xfs_btree.c
> > > > > > > +++ b/fs/xfs/libxfs/xfs_btree.c
> > ...
> > > > > /*
> > > > >  * Bulk Loading of Staged Btrees
> > > > >  * =============================
> > > > >  *
> > > > >  * This interface is used with a staged btree cursor to create a totally new
> > > > >  * btree with a large number of records (i.e. more than what would fit in a
> > > > >  * single root block).  When the creation is complete, the new root can be
> > > > >  * linked atomically into the filesystem by committing the staged cursor.
> > > > >  *
> > > > >  * Creation of a new btree proceeds roughly as follows:
> > > > >  *
> > > > >  * The first step is to initialize an appropriate fake btree root structure and
> > > > >  * then construct a staged btree cursor.  Refer to the block comments about
> > > > >  * "Bulk Loading for AG Btrees" and "Bulk Loading for Inode-Rooted Btrees" for
> > > > >  * more information about how to do this.
> > > > >  *
> > > > >  * The second step is to initialize a struct xfs_btree_bload context as
> > > > >  * follows:
> > > > >  *
> > > > >  * - nr_records is the number of records that are to be loaded into the btree.
> > > > >  *
> > > > >  * - leaf_slack is the number of records to leave empty in new leaf blocks.
> > > > >  *
> > > > >  * - node_slack is the number of key/ptr slots to leave empty in new node
> > > > >  *   blocks.
> > > > >  *
> > > > 
> > > > I thought these were documented in the structure definition code as
> > > > well. The big picture comments are helpful, but I also think there's
> > > > value in brevity and keeping focus on the design vs. configuration
> > > > details. I.e., this could just say that the second step is to initialize
> > > > the xfs_btree_bload context and refer to the struct definition for
> > > > details on the parameters. Similar for some of the steps below. That
> > > > also makes it easier to locate/fix associated comments when
> > > > implementation details (i.e. the structure, geometry calculation) might
> > > > change, FWIW.
> > > 
> > > Ok, at this point the structure definition for xfs_btree_bload is as
> > > follows:
> > > 
> > > /* Bulk loading of staged btrees. */
> > > struct xfs_btree_bload {
> > > 	/*
> > > 	 * This function will be called nr_records times to load records into
> > > 	 * the btree.  The function does this by setting the cursor's bc_rec
> > > 	 * field in in-core format.  Records must be returned in sort order.
> > > 	 */
> > > 	xfs_btree_bload_get_fn		get_data;
> > > 
> > > 	/*
> > > 	 * This function will be called nr_blocks times to retrieve a pointer
> > > 	 * to a new btree block on disk.  Callers must preallocate all space
> > > 	 * for the new btree before calling xfs_btree_bload.
> > > 	 */
> > > 	xfs_btree_bload_alloc_block_fn	alloc_block;
> > > 
> > > 	/*
> > > 	 * This function should return the size of the in-core btree root
> > > 	 * block.  It is only necessary for XFS_BTREE_ROOT_IN_INODE btree
> > > 	 * types.
> > > 	 */
> > > 	xfs_btree_bload_iroot_size_fn	iroot_size;
> > > 
> > 
> > I'm assuming there's a reason this is a function rather than a fixed
> > value..?
> 
> Yes -- this function computes the number of bytes needed for an in-core
> btree root block buffer, which consists of a fake struct xfs_btree_block
> header followed by some number of key/ptr pairs.  We don't write this
> fake btree header into the actual inode fork, so we cannot use
> XFS_IFORK_Q or something like that.
> 

Ah, I see..

> > > 	/*
> > > 	 * The caller should set this to the number of records that will be
> > > 	 * stored in the new btree.
> > > 	 */
> > > 	uint64_t			nr_records;
> > > 
> > > 	/*
> > > 	 * The xfs_btree_bload_compute_geometry function will set this to the
> > > 	 * number of btree blocks needed to store nr_records records.
> > > 	 */
> > > 	uint64_t			nr_blocks;
> > > 
> > > 	/*
> > > 	 * Number of free records to leave in each leaf block.  If the caller
> > > 	 * sets this to -1, the slack value will be calculated to be be halfway
> > > 	 * between maxrecs and minrecs.  This typically leaves the block 75%
> > > 	 * full.  Note that slack values are not enforced on inode root blocks.
> > > 	 */
> > > 	int				leaf_slack;
> > > 
> > > 	/*
> > > 	 * Number of free key/ptrs pairs to leave in each node block.  This
> > > 	 * field has the same semantics as leaf_slack.
> > > 	 */
> > > 	int				node_slack;
> > > 
> > > 	/*
> > > 	 * The xfs_btree_bload_compute_geometry function will set this to the
> > > 	 * height of the new btree.
> > > 	 */
> > > 	unsigned int			btree_height;
> > > };
> > > 
> > 
> > Otherwise looks reasonable, though I wonder if there's value in
> > organizing the structure by parts initialized by the user vs. parts
> > initialized by the geometry calculation.
> 
> Yes, I can put the two computed values at the end of the struct.
> 
> > 
> > > and the Huuge Block Comment looks like:
> > > 
> > > /*
> > >  * Bulk Loading of Staged Btrees
> > >  * =============================
> > >  *
> > >  * This interface is used with a staged btree cursor to create a totally new
> > >  * btree with a large number of records (i.e. more than what would fit in a
> > >  * single root block).  When the creation is complete, the new root can be
> > >  * linked atomically into the filesystem by committing the staged cursor.
> > >  *
> > >  * Creation of a new btree proceeds roughly as follows:
> > >  *
> > >  * The first step is to initialize an appropriate fake btree root structure and
> > >  * then construct a staged btree cursor.  Refer to the block comments about
> > >  * "Bulk Loading for AG Btrees" and "Bulk Loading for Inode-Rooted Btrees" for
> > >  * more information about how to do this.
> > >  *
> > >  * The second step is to initialize a struct xfs_btree_bload context as
> > >  * documented in the structure definition.
> > >  *
> > >  * The third step is to call xfs_btree_bload_compute_geometry to compute the
> > >  * height of and the number of blocks needed to construct the btree.  See the
> > >  * section "Computing the Geometry of the New Btree" for details about this
> > >  * computation.
> > >  *
> > >  * In step four, the caller must allocate xfs_btree_bload.nr_blocks blocks and
> > >  * save them for later use by ->alloc_block().  Bulk loading requires all
> > >  * blocks to be allocated beforehand to avoid ENOSPC failures midway through a
> > >  * rebuild, and to minimize seek distances of the new btree.
> > >  *
> > >  * Step five is to call xfs_btree_bload() to start constructing the btree.
> > >  *
> > >  * The final step is to commit the staging btree cursor, which logs the new
> > >  * btree root and turns the staging cursor into a regular cursor.  The caller
> > >  * is responsible for cleaning up the previous btree blocks, if any.
> > >  *
> > >  * Computing the Geometry of the New Btree
> > >  * =======================================
> > >  *
> > >  * The number of items placed in each btree block is computed via the following
> > >  * algorithm: For leaf levels, the number of items for the level is nr_records
> > >  * in the bload structure.  For node levels, the number of items for the level
> > >  * is the number of blocks in the next lower level of the tree.  For each
> > >  * level, the desired number of items per block is defined as:
> > >  *
> > >  * desired = max(minrecs, maxrecs - slack factor)
> > >  *
> > >  * The number of blocks for the level is defined to be:
> > >  *
> > >  * blocks = floor(nr_items / desired)
> > >  *
> > >  * Note this is rounded down so that the npb calculation below will never fall
> > >  * below minrecs.  The number of items that will actually be loaded into each
> > >  * btree block is defined as:
> > >  *
> > >  * npb =  nr_items / blocks
> > >  *
> > >  * Some of the leftmost blocks in the level will contain one extra record as
> > >  * needed to handle uneven division.  If the number of records in any block
> > >  * would exceed maxrecs for that level, blocks is incremented and npb is
> > >  * recalculated.
> > >  *
> > >  * In other words, we compute the number of blocks needed to satisfy a given
> > >  * loading level, then spread the items as evenly as possible.
> > >  *
> > >  * The height and number of fs blocks required to create the btree are computed
> > >  * and returned via btree_height and nr_blocks.
> > >  */
> > > 
> > 
> > Looks good at a glance.
> 
> Thanks!
> 
> > > Also... last year when you reviewed the patch "implement block
> > > reservation accounting for btrees we're staging", you said that you
> > > found the ->alloc_block name a little confusing, especially since
> > > there's already an alloc_block function pointer in the btree ops.
> > > 
> > > In that patch I changed the name to xrep_newbt_claim_block so that we
> > > can say that first the caller reserves space, and later during bulk
> > > loading we claim the space.  I think it makes sense to change
> > > alloc_block to claim_block in the xfs_btree_bload as well, do you?
> > > 
> > 
> > I don't recall the specifics, but that sounds reasonable to me. Perhaps
> > both the block and record callouts should change to be
> > consistent/explicit... get_block()/get_record()?
> 
> I definitely like get_record over get_data, but I think I'll go with
> claim_block.
> 

Too soon to ressurrect after killing off buffer heads? :)

Brian

> --D
> 
> > Brian
> > 
> > > --D
> > > 
> > > > >  *   If a caller sets a slack value to -1, that slack value will be computed to
> > > > >  *   fill the block halfway between minrecs and maxrecs items per block.
> > > > >  *
> > > > >  * - get_data is a function will be called for each record that will be loaded
> > > > >  *   into the btree.  It must set the cursor's bc_rec field.  Records returned
> > > > >  *   from this function /must/ be in sort order for the btree type, as they
> > > > >  *   are converted to on-disk format and written to disk in order!
> > > > >  *
> > > > >  * - alloc_block is a function that should return a pointer to one of the
> > > > >  *   blocks that are pre-allocated in step four.
> > > > >  *
> > > > >  * - For btrees which are rooted in an inode fork, iroot_size is a function
> > > > >  *   that will be called to compute the size of the incore btree root block.
> > > > >  *
> > > > >  * All other fields should be zero.
> > > > >  *
> > > > >  * The third step is to call xfs_btree_bload_compute_geometry to compute the
> > > > >  * height of and the number of blocks needed to construct the btree.  These
> > > > >  * values are stored in the @btree_height and @nr_blocks fields of struct
> > > > >  * xfs_btree_bload.  See the section "Computing the Geometry of the New Btree"
> > > > >  * for details about this computation.
> > > > >  *
> > > > >  * In step four, the caller must allocate xfs_btree_bload.nr_blocks blocks and
> > > > >  * save them for later calls to alloc_block().  Bulk loading requires all
> > > > >  * blocks to be allocated beforehand to avoid ENOSPC failures midway through a
> > > > >  * rebuild, and to minimize seek distances of the new btree.
> > > > >  *
> > > > >  * If disk space is to be allocated transactionally, the staging cursor must be
> > > > >  * deleted before allocation and recreated after.
> > > > >  *
> > > > >  * Step five is to call xfs_btree_bload() to start constructing the btree.
> > > > >  *
> > > > >  * The final step is to commit the staging cursor, which logs the new btree
> > > > >  * root, turns the btree cursor into a regular btree cursor.  The caller is
> > > > >  * responsible for cleaning up the previous btree, if any.
> > > > >  *
> > > > >  * Computing the Geometry of the New Btree
> > > > >  * =======================================
> > > > >  *
> > > > >  * The number of items placed in each btree block is computed via the following
> > > > >  * algorithm: For leaf levels, the number of items for the level is nr_records
> > > > >  * in the bload structure.  For node levels, the number of items for the level
> > > > >  * is the number of blocks in the next lower level of the tree.  For each
> > > > >  * level, the desired number of items per block is defined as:
> > > > >  *
> > > > >  * desired = max(minrecs, maxrecs - slack factor)
> > > > >  *
> > > > >  * The number of blocks for the level is defined to be:
> > > > >  *
> > > > >  * blocks = floor(nr_items / desired)
> > > > >  *
> > > > >  * Note this is rounded down so that the npb calculation below will never fall
> > > > >  * below minrecs.  The number of items that will actually be loaded into each
> > > > >  * btree block is defined as:
> > > > >  *
> > > > >  * npb =  nr_items / blocks
> > > > >  *
> > > > >  * Some of the leftmost blocks in the level will contain one extra record as
> > > > >  * needed to handle uneven division.  If the number of records in any block
> > > > >  * would exceed maxrecs for that level, blocks is incremented and npb is
> > > > >  * recalculated.
> > > > >  *
> > > > >  * In other words, we compute the number of blocks needed to satisfy a given
> > > > >  * loading level, then spread the items as evenly as possible.
> > > > >  *
> > > > >  * The height and number of fs blocks required to create the btree are computed
> > > > >  * and returned via btree_height and nr_blocks.
> > > > >  */
> > > > > 
> > > > > > I'm not following this ordering requirement wrt to the staging cursor..?
> > > > > 
> > > > > I /think/ the reason I put that in there is because rolling the
> > > > > transaction in between space allocations can change sc->tp and there's
> > > > > no way to update the btree cursor to point to the new transaction.
> > > > > 
> > > > > *However* on second thought I can't see why we would need or even want a
> > > > > transaction to be attached to the staging cursor during the rebuild
> > > > > process.  Staging cursors can't do normal btree updates, and there's no
> > > > > need for a transaction since the new blocks are attached to a delwri
> > > > > list.
> > > > > 
> > > > > So I think we can even rearrange the code here so that the _stage_cursor
> > > > > functions don't take a transaction at all, and only set bc_tp when we
> > > > > commit the new btree.
> > > > > 
> > > > 
> > > > Ok.
> > > > 
> > > > > > > + * The fourth step in the bulk loading process is to set the
> > > > > > > function pointers
> > > > > > > + * in the bload context structure.  @get_data will be called for each record
> > > > > > > + * that will be loaded into the btree; it should set the cursor's bc_rec
> > > > > > > + * field, which will be converted to on-disk format and copied into the
> > > > > > > + * appropriate record slot.  @alloc_block should supply one of the blocks
> > > > > > > + * allocated in the previous step.  For btrees which are rooted in an inode
> > > > > > > + * fork, @iroot_size is called to compute the size of the incore btree root
> > > > > > > + * block.  Call xfs_btree_bload to start constructing the btree.
> > > > > > > + *
> > > > > > > + * The final step is to commit the staging cursor, which logs the new btree
> > > > > > > + * root and turns the btree into a regular btree cursor, and free the fake
> > > > > > > + * roots.
> > > > > > > + */
> > > > > > > +
> > > > > > > +/*
> > > > > > > + * Put a btree block that we're loading onto the ordered list and release it.
> > > > > > > + * The btree blocks will be written when the final transaction swapping the
> > > > > > > + * btree roots is committed.
> > > > > > > + */
> > > > > > > +static void
> > > > > > > +xfs_btree_bload_drop_buf(
> > > > > > > +	struct xfs_btree_bload	*bbl,
> > > > > > > +	struct xfs_trans	*tp,
> > > > > > > +	struct xfs_buf		**bpp)
> > > > > > > +{
> > > > > > > +	if (*bpp == NULL)
> > > > > > > +		return;
> > > > > > > +
> > > > > > > +	xfs_buf_delwri_queue(*bpp, &bbl->buffers_list);
> > > > > > > +	xfs_trans_brelse(tp, *bpp);
> > > > > > > +	*bpp = NULL;
> > > > > > > +}
> > > > > > > +
> > > > > > > +/* Allocate and initialize one btree block for bulk loading. */
> > > > > > > +STATIC int
> > > > > > > +xfs_btree_bload_prep_block(
> > > > > > > +	struct xfs_btree_cur		*cur,
> > > > > > > +	struct xfs_btree_bload		*bbl,
> > > > > > > +	unsigned int			level,
> > > > > > > +	unsigned int			nr_this_block,
> > > > > > > +	union xfs_btree_ptr		*ptrp,
> > > > > > > +	struct xfs_buf			**bpp,
> > > > > > > +	struct xfs_btree_block		**blockp,
> > > > > > > +	void				*priv)
> > > > > > > +{
> > > > > > 
> > > > > > Would help to have some one-line comments to describe the params. It
> > > > > > looks like some of these are the previous pointers, but are also
> > > > > > input/output..?
> > > > > 
> > > > > Ok.
> > > > > 
> > > > > "The new btree block will have its level and numrecs fields set to the
> > > > > values of the level and nr_this_block parameters, respectively.  If bpp
> > > > > is set on entry, the buffer will be released.  On exit, ptrp, bpp, and
> > > > > blockp will all point to the new block."
> > > > > 
> > > > 
> > > > Sounds good.
> > > > 
> > > > > > > +	union xfs_btree_ptr		new_ptr;
> > > > > > > +	struct xfs_buf			*new_bp;
> > > > > > > +	struct xfs_btree_block		*new_block;
> > > > > > > +	int				ret;
> > > > > > > +
> > > > > > > +	if ((cur->bc_flags & XFS_BTREE_ROOT_IN_INODE) &&
> > > > > > > +	    level == cur->bc_nlevels - 1) {
> > > > > > > +		struct xfs_ifork	*ifp = cur->bc_private.b.ifake->if_fork;
> > > > > > 
> > > > > > Wasn't a helper added for this cur -> ifp access?
> > > > > 
> > > > > Yes.  I'll go use that instead.
> > > > > 
> > > > > > > +		size_t			new_size;
> > > > > > > +
> > > > > > > +		/* Allocate a new incore btree root block. */
> > > > > > > +		new_size = bbl->iroot_size(cur, nr_this_block, priv);
> > > > > > > +		ifp->if_broot = kmem_zalloc(new_size, 0);
> > > > > > > +		ifp->if_broot_bytes = (int)new_size;
> > > > > > > +		ifp->if_flags |= XFS_IFBROOT;
> > > > > > > +
> > > > > > > +		/* Initialize it and send it out. */
> > > > > > > +		xfs_btree_init_block_int(cur->bc_mp, ifp->if_broot,
> > > > > > > +				XFS_BUF_DADDR_NULL, cur->bc_btnum, level,
> > > > > > > +				nr_this_block, cur->bc_private.b.ip->i_ino,
> > > > > > > +				cur->bc_flags);
> > > > > > > +
> > > > > > > +		*bpp = NULL;
> > > > > > 
> > > > > > Is there no old bpp to drop here?
> > > > > 
> > > > > Correct.  We drop the buffer between levels, which means that when we
> > > > > prep the inode root, *bpp should already be NULL.
> > > > > 
> > > > > However, I guess it won't hurt to xfs_btree_bload_drop_buf here just in
> > > > > case that ever changes.
> > > > > 
> > > > 
> > > > Ok, perhaps an assert as well?
> > > > 
> > > > > > > +		*blockp = ifp->if_broot;
> > > > > > > +		xfs_btree_set_ptr_null(cur, ptrp);
> > > > > > > +		return 0;
> > > > > > > +	}
> > > > > > > +
> > > > > > > +	/* Allocate a new leaf block. */
> > > > > > > +	ret = bbl->alloc_block(cur, &new_ptr, priv);
> > > > > > > +	if (ret)
> > > > > > > +		return ret;
> > > > > > > +
> > > > > > > +	ASSERT(!xfs_btree_ptr_is_null(cur, &new_ptr));
> > > > > > > +
> > > > > > > +	ret = xfs_btree_get_buf_block(cur, &new_ptr, &new_block, &new_bp);
> > > > > > > +	if (ret)
> > > > > > > +		return ret;
> > > > > > > +
> > > > > > > +	/* Initialize the btree block. */
> > > > > > > +	xfs_btree_init_block_cur(cur, new_bp, level, nr_this_block);
> > > > > > > +	if (*blockp)
> > > > > > > +		xfs_btree_set_sibling(cur, *blockp, &new_ptr, XFS_BB_RIGHTSIB);
> > > > > > > +	xfs_btree_set_sibling(cur, new_block, ptrp, XFS_BB_LEFTSIB);
> > > > > > > +	xfs_btree_set_numrecs(new_block, nr_this_block);
> > > > > > 
> > > > > > I think numrecs is already set by the init_block_cur() call above.
> > > > > 
> > > > > Yes.  Fixed.
> > > > > 
> > > > > > > +
> > > > > > > +	/* Release the old block and set the out parameters. */
> > > > > > > +	xfs_btree_bload_drop_buf(bbl, cur->bc_tp, bpp);
> > > > > > > +	*blockp = new_block;
> > > > > > > +	*bpp = new_bp;
> > > > > > > +	xfs_btree_copy_ptrs(cur, ptrp, &new_ptr, 1);
> > > > > > > +	return 0;
> > > > > > > +}
> > > > > > > +
> > > > > > > +/* Load one leaf block. */
> > > > > > > +STATIC int
> > > > > > > +xfs_btree_bload_leaf(
> > > > > > > +	struct xfs_btree_cur		*cur,
> > > > > > > +	unsigned int			recs_this_block,
> > > > > > > +	xfs_btree_bload_get_fn		get_data,
> > > > > > > +	struct xfs_btree_block		*block,
> > > > > > > +	void				*priv)
> > > > > > > +{
> > > > > > > +	unsigned int			j;
> > > > > > > +	int				ret;
> > > > > > > +
> > > > > > > +	/* Fill the leaf block with records. */
> > > > > > > +	for (j = 1; j <= recs_this_block; j++) {
> > > > > > > +		union xfs_btree_rec	*block_recs;
> > > > > > > +
> > > > > > 
> > > > > > s/block_recs/block_rec/ ?
> > > > > 
> > > > > Fixed.
> > > > > 
> > > > > > > +		ret = get_data(cur, priv);
> > > > > > > +		if (ret)
> > > > > > > +			return ret;
> > > > > > > +		block_recs = xfs_btree_rec_addr(cur, j, block);
> > > > > > > +		cur->bc_ops->init_rec_from_cur(cur, block_recs);
> > > > > > > +	}
> > > > > > > +
> > > > > > > +	return 0;
> > > > > > > +}
> > > > > > > +
> > > > > > > +/* Load one node block. */
> > > > > > 
> > > > > > More comments here to document the child_ptr please..
> > > > > 
> > > > > "child_ptr must point to a block within the next level down in the tree.
> > > > > A key/ptr entry will be created in the new node block to the block
> > > > > pointed to by child_ptr.  On exit, child_ptr will be advanced to where
> > > > > it needs to be to start the next _bload_node call."
> > > > > 
> > > > 
> > > > "child_ptr is advanced to the next block at the child level."
> > > > 
> > > > ... or something less vague than "where it needs to be for the next
> > > > call." :P Otherwise sounds good.
> > > > 
> > > > > > > +STATIC int
> > > > > > > +xfs_btree_bload_node(
> > > > > > > +	struct xfs_btree_cur	*cur,
> > > > > > > +	unsigned int		recs_this_block,
> > > > > > > +	union xfs_btree_ptr	*child_ptr,
> > > > > > > +	struct xfs_btree_block	*block)
> > > > > > > +{
> > > > > > > +	unsigned int		j;
> > > > > > > +	int			ret;
> > > > > > > +
> > > > > > > +	/* Fill the node block with keys and pointers. */
> > > > > > > +	for (j = 1; j <= recs_this_block; j++) {
> > > > > > > +		union xfs_btree_key	child_key;
> > > > > > > +		union xfs_btree_ptr	*block_ptr;
> > > > > > > +		union xfs_btree_key	*block_key;
> > > > > > > +		struct xfs_btree_block	*child_block;
> > > > > > > +		struct xfs_buf		*child_bp;
> > > > > > > +
> > > > > > > +		ASSERT(!xfs_btree_ptr_is_null(cur, child_ptr));
> > > > > > > +
> > > > > > > +		ret = xfs_btree_get_buf_block(cur, child_ptr, &child_block,
> > > > > > > +				&child_bp);
> > > > > > > +		if (ret)
> > > > > > > +			return ret;
> > > > > > > +
> > > > > > > +		xfs_btree_get_keys(cur, child_block, &child_key);
> > > > > > 
> > > > > > Any reason this isn't pushed down a couple lines with the key copy code?
> > > > > 
> > > > > No reason.
> > > > > 
> > > > 
> > > > Doing so helps readability IMO. For whatever reason all the meta ops
> > > > associated with the generic btree code tend to make my eyes cross..
> > > > 
> > > > > > > +
> > > > > > > +		block_ptr = xfs_btree_ptr_addr(cur, j, block);
> > > > > > > +		xfs_btree_copy_ptrs(cur, block_ptr, child_ptr, 1);
> > > > > > > +
> > > > > > > +		block_key = xfs_btree_key_addr(cur, j, block);
> > > > > > > +		xfs_btree_copy_keys(cur, block_key, &child_key, 1);
> > > > > > > +
> > > > > > > +		xfs_btree_get_sibling(cur, child_block, child_ptr,
> > > > > > > +				XFS_BB_RIGHTSIB);
> > > > > > > +		xfs_trans_brelse(cur->bc_tp, child_bp);
> > > > > > > +	}
> > > > > > > +
> > > > > > > +	return 0;
> > > > > > > +}
> > > > > > > +
> > > > > > > +/*
> > > > > > > + * Compute the maximum number of records (or keyptrs) per block that we want to
> > > > > > > + * install at this level in the btree.  Caller is responsible for having set
> > > > > > > + * @cur->bc_private.b.forksize to the desired fork size, if appropriate.
> > > > > > > + */
> > > > > > > +STATIC unsigned int
> > > > > > > +xfs_btree_bload_max_npb(
> > > > > > > +	struct xfs_btree_cur	*cur,
> > > > > > > +	struct xfs_btree_bload	*bbl,
> > > > > > > +	unsigned int		level)
> > > > > > > +{
> > > > > > > +	unsigned int		ret;
> > > > > > > +
> > > > > > > +	if (level == cur->bc_nlevels - 1 && cur->bc_ops->get_dmaxrecs)
> > > > > > > +		return cur->bc_ops->get_dmaxrecs(cur, level);
> > > > > > > +
> > > > > > > +	ret = cur->bc_ops->get_maxrecs(cur, level);
> > > > > > > +	if (level == 0)
> > > > > > > +		ret -= bbl->leaf_slack;
> > > > > > > +	else
> > > > > > > +		ret -= bbl->node_slack;
> > > > > > > +	return ret;
> > > > > > > +}
> > > > > > > +
> > > > > > > +/*
> > > > > > > + * Compute the desired number of records (or keyptrs) per block that we want to
> > > > > > > + * install at this level in the btree, which must be somewhere between minrecs
> > > > > > > + * and max_npb.  The caller is free to install fewer records per block.
> > > > > > > + */
> > > > > > > +STATIC unsigned int
> > > > > > > +xfs_btree_bload_desired_npb(
> > > > > > > +	struct xfs_btree_cur	*cur,
> > > > > > > +	struct xfs_btree_bload	*bbl,
> > > > > > > +	unsigned int		level)
> > > > > > > +{
> > > > > > > +	unsigned int		npb = xfs_btree_bload_max_npb(cur, bbl, level);
> > > > > > > +
> > > > > > > +	/* Root blocks are not subject to minrecs rules. */
> > > > > > > +	if (level == cur->bc_nlevels - 1)
> > > > > > > +		return max(1U, npb);
> > > > > > > +
> > > > > > > +	return max_t(unsigned int, cur->bc_ops->get_minrecs(cur, level), npb);
> > > > > > > +}
> > > > > > > +
> > > > > > > +/*
> > > > > > > + * Compute the number of records to be stored in each block at this level and
> > > > > > > + * the number of blocks for this level.  For leaf levels, we must populate an
> > > > > > > + * empty root block even if there are no records, so we have to have at least
> > > > > > > + * one block.
> > > > > > > + */
> > > > > > > +STATIC void
> > > > > > > +xfs_btree_bload_level_geometry(
> > > > > > > +	struct xfs_btree_cur	*cur,
> > > > > > > +	struct xfs_btree_bload	*bbl,
> > > > > > > +	unsigned int		level,
> > > > > > > +	uint64_t		nr_this_level,
> > > > > > > +	unsigned int		*avg_per_block,
> > > > > > > +	uint64_t		*blocks,
> > > > > > > +	uint64_t		*blocks_with_extra)
> > > > > > > +{
> > > > > > > +	uint64_t		npb;
> > > > > > > +	uint64_t		dontcare;
> > > > > > > +	unsigned int		desired_npb;
> > > > > > > +	unsigned int		maxnr;
> > > > > > > +
> > > > > > > +	maxnr = cur->bc_ops->get_maxrecs(cur, level);
> > > > > > > +
> > > > > > > +	/*
> > > > > > > +	 * Compute the number of blocks we need to fill each block with the
> > > > > > > +	 * desired number of records/keyptrs per block.  Because desired_npb
> > > > > > > +	 * could be minrecs, we use regular integer division (which rounds
> > > > > > > +	 * the block count down) so that in the next step the effective # of
> > > > > > > +	 * items per block will never be less than desired_npb.
> > > > > > > +	 */
> > > > > > > +	desired_npb = xfs_btree_bload_desired_npb(cur, bbl, level);
> > > > > > > +	*blocks = div64_u64_rem(nr_this_level, desired_npb, &dontcare);
> > > > > > > +	*blocks = max(1ULL, *blocks);
> > > > > > > +
> > > > > > > +	/*
> > > > > > > +	 * Compute the number of records that we will actually put in each
> > > > > > > +	 * block, assuming that we want to spread the records evenly between
> > > > > > > +	 * the blocks.  Take care that the effective # of items per block (npb)
> > > > > > > +	 * won't exceed maxrecs even for the blocks that get an extra record,
> > > > > > > +	 * since desired_npb could be maxrecs, and in the previous step we
> > > > > > > +	 * rounded the block count down.
> > > > > > > +	 */
> > > > > > > +	npb = div64_u64_rem(nr_this_level, *blocks, blocks_with_extra);
> > > > > > > +	if (npb > maxnr || (npb == maxnr && *blocks_with_extra > 0)) {
> > > > > > > +		(*blocks)++;
> > > > > > > +		npb = div64_u64_rem(nr_this_level, *blocks, blocks_with_extra);
> > > > > > > +	}
> > > > > > > +
> > > > > > > +	*avg_per_block = min_t(uint64_t, npb, nr_this_level);
> > > > > > > +
> > > > > > > +	trace_xfs_btree_bload_level_geometry(cur, level, nr_this_level,
> > > > > > > +			*avg_per_block, desired_npb, *blocks,
> > > > > > > +			*blocks_with_extra);
> > > > > > > +}
> > > > > > > +
> > > > > > > +/*
> > > > > > > + * Ensure a slack value is appropriate for the btree.
> > > > > > > + *
> > > > > > > + * If the slack value is negative, set slack so that we fill the block to
> > > > > > > + * halfway between minrecs and maxrecs.  Make sure the slack is never so large
> > > > > > > + * that we can underflow minrecs.
> > > > > > > + */
> > > > > > > +static void
> > > > > > > +xfs_btree_bload_ensure_slack(
> > > > > > > +	struct xfs_btree_cur	*cur,
> > > > > > > +	int			*slack,
> > > > > > > +	int			level)
> > > > > > > +{
> > > > > > > +	int			maxr;
> > > > > > > +	int			minr;
> > > > > > > +
> > > > > > > +	/*
> > > > > > > +	 * We only care about slack for btree blocks, so set the btree nlevels
> > > > > > > +	 * to 3 so that level 0 is a leaf block and level 1 is a node block.
> > > > > > > +	 * Avoid straying into inode roots, since we don't do slack there.
> > > > > > > +	 */
> > > > > > > +	cur->bc_nlevels = 3;
> > > > > > 
> > > > > > Ok, but what does this assignment do as it relates to the code? It seems
> > > > > > this is related to this function as it is overwritten by the caller...
> > > > > 
> > > > > Hm, I'm not 100% sure what you're confused about -- what does "as it
> > > > > relates to the code" mean?
> > > > > 
> > > > 
> > > > I guess a better phrasing is: where is ->bc_nlevels accessed such that
> > > > we need to set a particular value here?
> > > > 
> > > > Yesterday I just looked at the allocbt code, didn't see an access and
> > > > didn't feel like searching through the rest. Today I poked at the bmbt
> > > > it looks like the min/max calls there use it, so perhaps that is the
> > > > answer.
> > > > 
> > > > > In any case, we're creating an artificial btree geometry here so that we
> > > > > can measure min and maxrecs for a given level, and setting slack based
> > > > > on that.
> > > > > 
> > > > > "3" is the magic value so that we always get min/max recs for a level
> > > > > that consists of fs blocks (as opposed to inode roots).  We don't have
> > > > > to preserve the old value since we're about to compute the real one.
> > > > > 
> > > > > Hmm, maybe you're wondering why we're setting nlevels = 3 here instead
> > > > > of in the caller?  That might be a good idea...
> > > > > 
> > > > 
> > > > That might be more consistent..
> > > > 
> > > > > > > +	maxr = cur->bc_ops->get_maxrecs(cur, level);
> > > > > > > +	minr = cur->bc_ops->get_minrecs(cur, level);
> > > > > > > +
> > > > > > > +	/*
> > > > > > > +	 * If slack is negative, automatically set slack so that we load the
> > > > > > > +	 * btree block approximately halfway between minrecs and maxrecs.
> > > > > > > +	 * Generally, this will net us 75% loading.
> > > > > > > +	 */
> > > > > > > +	if (*slack < 0)
> > > > > > > +		*slack = maxr - ((maxr + minr) >> 1);
> > > > > > > +
> > > > > > > +	*slack = min(*slack, maxr - minr);
> > > > > > > +}
> > > > > > > +
> > > > > > > +/*
> > > > > > > + * Prepare a btree cursor for a bulk load operation by computing the geometry
> > > > > > > + * fields in @bbl.  Caller must ensure that the btree cursor is a staging
> > > > > > > + * cursor.  This function can be called multiple times.
> > > > > > > + */
> > > > > > > +int
> > > > > > > +xfs_btree_bload_compute_geometry(
> > > > > > > +	struct xfs_btree_cur	*cur,
> > > > > > > +	struct xfs_btree_bload	*bbl,
> > > > > > > +	uint64_t		nr_records)
> > > > > > > +{
> > > > > > > +	uint64_t		nr_blocks = 0;
> > > > > > > +	uint64_t		nr_this_level;
> > > > > > > +
> > > > > > > +	ASSERT(cur->bc_flags & XFS_BTREE_STAGING);
> > > > > > > +
> > > > > 
> > > > > ...so then this becomes:
> > > > > 
> > > > > 	/*
> > > > > 	 * Make sure that the slack values make sense for btree blocks
> > > > > 	 * that are full disk blocks by setting the btree nlevels to 3.
> > > > > 	 * We don't try to enforce slack for inode roots.
> > > > > 	 */
> > > > > 	cur->bc_nlevels = 3;
> > > > > 	xfs_btree_bload_ensure_slack(cur, &bbl->leaf_slack, 0);
> > > > > 	xfs_btree_bload_ensure_slack(cur, &bbl->node_slack, 1);
> > > > > 
> > > > > 
> > > > > > > +	xfs_btree_bload_ensure_slack(cur, &bbl->leaf_slack, 0);
> > > > > > > +	xfs_btree_bload_ensure_slack(cur, &bbl->node_slack, 1);
> > > > > > > +
> > > > > > > +	bbl->nr_records = nr_this_level = nr_records;
> > > > > > 
> > > > > > I found nr_this_level a bit vague of a name when reading through the
> > > > > > code below. Perhaps level_recs is a bit more clear..?
> > > > > > 
> > > > > > > +	for (cur->bc_nlevels = 1; cur->bc_nlevels < XFS_BTREE_MAXLEVELS;) {
> > > > > > > +		uint64_t	level_blocks;
> > > > > > > +		uint64_t	dontcare64;
> > > > > > > +		unsigned int	level = cur->bc_nlevels - 1;
> > > > > > > +		unsigned int	avg_per_block;
> > > > > > > +
> > > > > > > +		/*
> > > > > > > +		 * If all the things we want to store at this level would fit
> > > > > > > +		 * in a single root block, then we have our btree root and are
> > > > > > > +		 * done.  Note that bmap btrees do not allow records in the
> > > > > > > +		 * root.
> > > > > > > +		 */
> > > > > > > +		if (!(cur->bc_flags & XFS_BTREE_ROOT_IN_INODE) || level != 0) {
> > > > > > > +			xfs_btree_bload_level_geometry(cur, bbl, level,
> > > > > > > +					nr_this_level, &avg_per_block,
> > > > > > > +					&level_blocks, &dontcare64);
> > > > > > > +			if (nr_this_level <= avg_per_block) {
> > > > > > > +				nr_blocks++;
> > > > > > > +				break;
> > > > > > > +			}
> > > > > > > +		}
> > > > > > > +
> > > > > > > +		/*
> > > > > > > +		 * Otherwise, we have to store all the records for this level
> > > > > > > +		 * in blocks and therefore need another level of btree to point
> > > > > > > +		 * to those blocks.  Increase the number of levels and
> > > > > > > +		 * recompute the number of records we can store at this level
> > > > > > > +		 * because that can change depending on whether or not a level
> > > > > > > +		 * is the root level.
> > > > > > > +		 */
> > > > > > > +		cur->bc_nlevels++;
> > > > > > 
> > > > > > Hmm.. so does the ->bc_nlevels increment affect the
> > > > > > _bload_level_geometry() call or is it just part of the loop iteration?
> > > > > > If the latter, can these two _bload_level_geometry() calls be combined?
> > > > > 
> > > > > It affects the xfs_btree_bload_level_geometry call because that calls
> > > > > ->get_maxrecs(), which returns a different answer for the root level
> > > > > when the root is an inode fork.  Therefore, we cannot combine the calls.
> > > > > 
> > > > 
> > > > Hmm.. but doesn't this cause double calls for other cases? I.e. for
> > > > non-inode rooted trees it looks like we call the function once, check
> > > > the avg_per_block and then potentially call it again until we get to the
> > > > root block. Confused.. :/
> > > > 
> > > > Brian
> > > > 
> > > > > > 
> > > > > > > +		xfs_btree_bload_level_geometry(cur, bbl, level, nr_this_level,
> > > > > > > +				&avg_per_block, &level_blocks, &dontcare64);
> > > > > > > +		nr_blocks += level_blocks;
> > > > > > > +		nr_this_level = level_blocks;
> > > > > > > +	}
> > > > > > > +
> > > > > > > +	if (cur->bc_nlevels == XFS_BTREE_MAXLEVELS)
> > > > > > > +		return -EOVERFLOW;
> > > > > > > +
> > > > > > > +	bbl->btree_height = cur->bc_nlevels;
> > > > > > > +	if (cur->bc_flags & XFS_BTREE_ROOT_IN_INODE)
> > > > > > > +		bbl->nr_blocks = nr_blocks - 1;
> > > > > > > +	else
> > > > > > > +		bbl->nr_blocks = nr_blocks;
> > > > > > > +	return 0;
> > > > > > > +}
> > > > > > > +
> > > > > > > +/*
> > > > > > > + * Bulk load a btree.
> > > > > > > + *
> > > > > > > + * Load @bbl->nr_records quantity of records into a btree using the supplied
> > > > > > > + * empty and staging btree cursor @cur and a @bbl that has been filled out by
> > > > > > > + * the xfs_btree_bload_compute_geometry function.
> > > > > > > + *
> > > > > > > + * The @bbl->get_data function must populate the cursor's bc_rec every time it
> > > > > > > + * is called.  The @bbl->alloc_block function will be used to allocate new
> > > > > > > + * btree blocks.  @priv is passed to both functions.
> > > > > > > + *
> > > > > > > + * Caller must ensure that @cur is a staging cursor.  Any existing btree rooted
> > > > > > > + * in the fakeroot will be lost, so do not call this function twice.
> > > > > > > + */
> > > > > > > +int
> > > > > > > +xfs_btree_bload(
> > > > > > > +	struct xfs_btree_cur		*cur,
> > > > > > > +	struct xfs_btree_bload		*bbl,
> > > > > > > +	void				*priv)
> > > > > > > +{
> > > > > > > +	union xfs_btree_ptr		child_ptr;
> > > > > > > +	union xfs_btree_ptr		ptr;
> > > > > > > +	struct xfs_buf			*bp = NULL;
> > > > > > > +	struct xfs_btree_block		*block = NULL;
> > > > > > > +	uint64_t			nr_this_level = bbl->nr_records;
> > > > > > > +	uint64_t			blocks;
> > > > > > > +	uint64_t			i;
> > > > > > > +	uint64_t			blocks_with_extra;
> > > > > > > +	uint64_t			total_blocks = 0;
> > > > > > > +	unsigned int			avg_per_block;
> > > > > > > +	unsigned int			level = 0;
> > > > > > > +	int				ret;
> > > > > > > +
> > > > > > > +	ASSERT(cur->bc_flags & XFS_BTREE_STAGING);
> > > > > > > +
> > > > > > > +	INIT_LIST_HEAD(&bbl->buffers_list);
> > > > > > > +	cur->bc_nlevels = bbl->btree_height;
> > > > > > > +	xfs_btree_set_ptr_null(cur, &child_ptr);
> > > > > > > +	xfs_btree_set_ptr_null(cur, &ptr);
> > > > > > > +
> > > > > > > +	xfs_btree_bload_level_geometry(cur, bbl, level, nr_this_level,
> > > > > > > +			&avg_per_block, &blocks, &blocks_with_extra);
> > > > > > > +
> > > > > > > +	/* Load each leaf block. */
> > > > > > > +	for (i = 0; i < blocks; i++) {
> > > > > > > +		unsigned int		nr_this_block = avg_per_block;
> > > > > > > +
> > > > > > > +		if (i < blocks_with_extra)
> > > > > > > +			nr_this_block++;
> > > > > > > +
> > > > > > > +		ret = xfs_btree_bload_prep_block(cur, bbl, level,
> > > > > > > +				nr_this_block, &ptr, &bp, &block, priv);
> > > > > > > +		if (ret)
> > > > > > > +			return ret;
> > > > > > > +
> > > > > > > +		trace_xfs_btree_bload_block(cur, level, i, blocks, &ptr,
> > > > > > > +				nr_this_block);
> > > > > > > +
> > > > > > > +		ret = xfs_btree_bload_leaf(cur, nr_this_block, bbl->get_data,
> > > > > > > +				block, priv);
> > > > > > > +		if (ret)
> > > > > > > +			goto out;
> > > > > > > +
> > > > > > > +		/* Record the leftmost pointer to start the next level. */
> > > > > > > +		if (i == 0)
> > > > > > > +			xfs_btree_copy_ptrs(cur, &child_ptr, &ptr, 1);
> > > > > > 
> > > > > > "leftmost pointer" refers to the leftmost leaf block..?
> > > > > 
> > > > > Yes.  "Record the leftmost leaf pointer so we know where to start with
> > > > > the first node level." ?
> > > > > 
> > > > > > > +	}
> > > > > > > +	total_blocks += blocks;
> > > > > > > +	xfs_btree_bload_drop_buf(bbl, cur->bc_tp, &bp);
> > > > > > > +
> > > > > > > +	/* Populate the internal btree nodes. */
> > > > > > > +	for (level = 1; level < cur->bc_nlevels; level++) {
> > > > > > > +		union xfs_btree_ptr	first_ptr;
> > > > > > > +
> > > > > > > +		nr_this_level = blocks;
> > > > > > > +		block = NULL;
> > > > > > > +		xfs_btree_set_ptr_null(cur, &ptr);
> > > > > > > +
> > > > > > > +		xfs_btree_bload_level_geometry(cur, bbl, level, nr_this_level,
> > > > > > > +				&avg_per_block, &blocks, &blocks_with_extra);
> > > > > > > +
> > > > > > > +		/* Load each node block. */
> > > > > > > +		for (i = 0; i < blocks; i++) {
> > > > > > > +			unsigned int	nr_this_block = avg_per_block;
> > > > > > > +
> > > > > > > +			if (i < blocks_with_extra)
> > > > > > > +				nr_this_block++;
> > > > > > > +
> > > > > > > +			ret = xfs_btree_bload_prep_block(cur, bbl, level,
> > > > > > > +					nr_this_block, &ptr, &bp, &block,
> > > > > > > +					priv);
> > > > > > > +			if (ret)
> > > > > > > +				return ret;
> > > > > > > +
> > > > > > > +			trace_xfs_btree_bload_block(cur, level, i, blocks,
> > > > > > > +					&ptr, nr_this_block);
> > > > > > > +
> > > > > > > +			ret = xfs_btree_bload_node(cur, nr_this_block,
> > > > > > > +					&child_ptr, block);
> > > > > > > +			if (ret)
> > > > > > > +				goto out;
> > > > > > > +
> > > > > > > +			/*
> > > > > > > +			 * Record the leftmost pointer to start the next level.
> > > > > > > +			 */
> > > > > > 
> > > > > > And the same thing here. I think the generic ptr name is a little
> > > > > > confusing, though I don't have a better suggestion. I think it would
> > > > > > help if the comments were more explicit to say something like: "ptr
> > > > > > refers to the current block addr. Save the first block in the current
> > > > > > level so the next level up knows where to start looking for keys."
> > > > > 
> > > > > Yes, I'll do that:
> > > > > 
> > > > > "Record the leftmost node pointer so that we know where to start the
> > > > > next node level above this one."
> > > > > 
> > > > > Thanks for reviewing!
> > > > > 
> > > > > --D
> > > > > 
> > > > > > Brian
> > > > > > 
> > > > > > > +			if (i == 0)
> > > > > > > +				xfs_btree_copy_ptrs(cur, &first_ptr, &ptr, 1);
> > > > > > > +		}
> > > > > > > +		total_blocks += blocks;
> > > > > > > +		xfs_btree_bload_drop_buf(bbl, cur->bc_tp, &bp);
> > > > > > > +		xfs_btree_copy_ptrs(cur, &child_ptr, &first_ptr, 1);
> > > > > > > +	}
> > > > > > > +
> > > > > > > +	/* Initialize the new root. */
> > > > > > > +	if (cur->bc_flags & XFS_BTREE_ROOT_IN_INODE) {
> > > > > > > +		ASSERT(xfs_btree_ptr_is_null(cur, &ptr));
> > > > > > > +		cur->bc_private.b.ifake->if_levels = cur->bc_nlevels;
> > > > > > > +		cur->bc_private.b.ifake->if_blocks = total_blocks - 1;
> > > > > > > +	} else {
> > > > > > > +		cur->bc_private.a.afake->af_root = be32_to_cpu(ptr.s);
> > > > > > > +		cur->bc_private.a.afake->af_levels = cur->bc_nlevels;
> > > > > > > +		cur->bc_private.a.afake->af_blocks = total_blocks;
> > > > > > > +	}
> > > > > > > +
> > > > > > > +	/*
> > > > > > > +	 * Write the new blocks to disk.  If the ordered list isn't empty after
> > > > > > > +	 * that, then something went wrong and we have to fail.  This should
> > > > > > > +	 * never happen, but we'll check anyway.
> > > > > > > +	 */
> > > > > > > +	ret = xfs_buf_delwri_submit(&bbl->buffers_list);
> > > > > > > +	if (ret)
> > > > > > > +		goto out;
> > > > > > > +	if (!list_empty(&bbl->buffers_list)) {
> > > > > > > +		ASSERT(list_empty(&bbl->buffers_list));
> > > > > > > +		ret = -EIO;
> > > > > > > +	}
> > > > > > > +out:
> > > > > > > +	xfs_buf_delwri_cancel(&bbl->buffers_list);
> > > > > > > +	if (bp)
> > > > > > > +		xfs_trans_brelse(cur->bc_tp, bp);
> > > > > > > +	return ret;
> > > > > > > +}
> > > > > > > diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
> > > > > > > index 2965ed663418..51720de366ae 100644
> > > > > > > --- a/fs/xfs/libxfs/xfs_btree.h
> > > > > > > +++ b/fs/xfs/libxfs/xfs_btree.h
> > > > > > > @@ -578,4 +578,50 @@ void xfs_btree_stage_ifakeroot(struct xfs_btree_cur *cur,
> > > > > > >  void xfs_btree_commit_ifakeroot(struct xfs_btree_cur *cur, int whichfork,
> > > > > > >  		const struct xfs_btree_ops *ops);
> > > > > > >  
> > > > > > > +typedef int (*xfs_btree_bload_get_fn)(struct xfs_btree_cur *cur, void *priv);
> > > > > > > +typedef int (*xfs_btree_bload_alloc_block_fn)(struct xfs_btree_cur *cur,
> > > > > > > +		union xfs_btree_ptr *ptr, void *priv);
> > > > > > > +typedef size_t (*xfs_btree_bload_iroot_size_fn)(struct xfs_btree_cur *cur,
> > > > > > > +		unsigned int nr_this_level, void *priv);
> > > > > > > +
> > > > > > > +/* Bulk loading of staged btrees. */
> > > > > > > +struct xfs_btree_bload {
> > > > > > > +	/* Buffer list for delwri_queue. */
> > > > > > > +	struct list_head		buffers_list;
> > > > > > > +
> > > > > > > +	/* Function to store a record in the cursor. */
> > > > > > > +	xfs_btree_bload_get_fn		get_data;
> > > > > > > +
> > > > > > > +	/* Function to allocate a block for the btree. */
> > > > > > > +	xfs_btree_bload_alloc_block_fn	alloc_block;
> > > > > > > +
> > > > > > > +	/* Function to compute the size of the in-core btree root block. */
> > > > > > > +	xfs_btree_bload_iroot_size_fn	iroot_size;
> > > > > > > +
> > > > > > > +	/* Number of records the caller wants to store. */
> > > > > > > +	uint64_t			nr_records;
> > > > > > > +
> > > > > > > +	/* Number of btree blocks needed to store those records. */
> > > > > > > +	uint64_t			nr_blocks;
> > > > > > > +
> > > > > > > +	/*
> > > > > > > +	 * Number of free records to leave in each leaf block.  If this (or
> > > > > > > +	 * any of the slack values) are negative, this will be computed to
> > > > > > > +	 * be halfway between maxrecs and minrecs.  This typically leaves the
> > > > > > > +	 * block 75% full.
> > > > > > > +	 */
> > > > > > > +	int				leaf_slack;
> > > > > > > +
> > > > > > > +	/* Number of free keyptrs to leave in each node block. */
> > > > > > > +	int				node_slack;
> > > > > > > +
> > > > > > > +	/* Computed btree height. */
> > > > > > > +	unsigned int			btree_height;
> > > > > > > +};
> > > > > > > +
> > > > > > > +int xfs_btree_bload_compute_geometry(struct xfs_btree_cur *cur,
> > > > > > > +		struct xfs_btree_bload *bbl, uint64_t nr_records);
> > > > > > > +int xfs_btree_bload(struct xfs_btree_cur *cur, struct xfs_btree_bload *bbl,
> > > > > > > +		void *priv);
> > > > > > > +
> > > > > > >  #endif	/* __XFS_BTREE_H__ */
> > > > > > > diff --git a/fs/xfs/xfs_trace.c b/fs/xfs/xfs_trace.c
> > > > > > > index bc85b89f88ca..9b5e58a92381 100644
> > > > > > > --- a/fs/xfs/xfs_trace.c
> > > > > > > +++ b/fs/xfs/xfs_trace.c
> > > > > > > @@ -6,6 +6,7 @@
> > > > > > >  #include "xfs.h"
> > > > > > >  #include "xfs_fs.h"
> > > > > > >  #include "xfs_shared.h"
> > > > > > > +#include "xfs_bit.h"
> > > > > > >  #include "xfs_format.h"
> > > > > > >  #include "xfs_log_format.h"
> > > > > > >  #include "xfs_trans_resv.h"
> > > > > > > diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> > > > > > > index 7e162ca80c92..69e8605f9f97 100644
> > > > > > > --- a/fs/xfs/xfs_trace.h
> > > > > > > +++ b/fs/xfs/xfs_trace.h
> > > > > > > @@ -35,6 +35,7 @@ struct xfs_icreate_log;
> > > > > > >  struct xfs_owner_info;
> > > > > > >  struct xfs_trans_res;
> > > > > > >  struct xfs_inobt_rec_incore;
> > > > > > > +union xfs_btree_ptr;
> > > > > > >  
> > > > > > >  DECLARE_EVENT_CLASS(xfs_attr_list_class,
> > > > > > >  	TP_PROTO(struct xfs_attr_list_context *ctx),
> > > > > > > @@ -3655,6 +3656,90 @@ TRACE_EVENT(xfs_btree_commit_ifakeroot,
> > > > > > >  		  __entry->blocks)
> > > > > > >  )
> > > > > > >  
> > > > > > > +TRACE_EVENT(xfs_btree_bload_level_geometry,
> > > > > > > +	TP_PROTO(struct xfs_btree_cur *cur, unsigned int level,
> > > > > > > +		 uint64_t nr_this_level, unsigned int nr_per_block,
> > > > > > > +		 unsigned int desired_npb, uint64_t blocks,
> > > > > > > +		 uint64_t blocks_with_extra),
> > > > > > > +	TP_ARGS(cur, level, nr_this_level, nr_per_block, desired_npb, blocks,
> > > > > > > +		blocks_with_extra),
> > > > > > > +	TP_STRUCT__entry(
> > > > > > > +		__field(dev_t, dev)
> > > > > > > +		__field(xfs_btnum_t, btnum)
> > > > > > > +		__field(unsigned int, level)
> > > > > > > +		__field(unsigned int, nlevels)
> > > > > > > +		__field(uint64_t, nr_this_level)
> > > > > > > +		__field(unsigned int, nr_per_block)
> > > > > > > +		__field(unsigned int, desired_npb)
> > > > > > > +		__field(unsigned long long, blocks)
> > > > > > > +		__field(unsigned long long, blocks_with_extra)
> > > > > > > +	),
> > > > > > > +	TP_fast_assign(
> > > > > > > +		__entry->dev = cur->bc_mp->m_super->s_dev;
> > > > > > > +		__entry->btnum = cur->bc_btnum;
> > > > > > > +		__entry->level = level;
> > > > > > > +		__entry->nlevels = cur->bc_nlevels;
> > > > > > > +		__entry->nr_this_level = nr_this_level;
> > > > > > > +		__entry->nr_per_block = nr_per_block;
> > > > > > > +		__entry->desired_npb = desired_npb;
> > > > > > > +		__entry->blocks = blocks;
> > > > > > > +		__entry->blocks_with_extra = blocks_with_extra;
> > > > > > > +	),
> > > > > > > +	TP_printk("dev %d:%d btree %s level %u/%u nr_this_level %llu nr_per_block %u desired_npb %u blocks %llu blocks_with_extra %llu",
> > > > > > > +		  MAJOR(__entry->dev), MINOR(__entry->dev),
> > > > > > > +		  __print_symbolic(__entry->btnum, XFS_BTNUM_STRINGS),
> > > > > > > +		  __entry->level,
> > > > > > > +		  __entry->nlevels,
> > > > > > > +		  __entry->nr_this_level,
> > > > > > > +		  __entry->nr_per_block,
> > > > > > > +		  __entry->desired_npb,
> > > > > > > +		  __entry->blocks,
> > > > > > > +		  __entry->blocks_with_extra)
> > > > > > > +)
> > > > > > > +
> > > > > > > +TRACE_EVENT(xfs_btree_bload_block,
> > > > > > > +	TP_PROTO(struct xfs_btree_cur *cur, unsigned int level,
> > > > > > > +		 uint64_t block_idx, uint64_t nr_blocks,
> > > > > > > +		 union xfs_btree_ptr *ptr, unsigned int nr_records),
> > > > > > > +	TP_ARGS(cur, level, block_idx, nr_blocks, ptr, nr_records),
> > > > > > > +	TP_STRUCT__entry(
> > > > > > > +		__field(dev_t, dev)
> > > > > > > +		__field(xfs_btnum_t, btnum)
> > > > > > > +		__field(unsigned int, level)
> > > > > > > +		__field(unsigned long long, block_idx)
> > > > > > > +		__field(unsigned long long, nr_blocks)
> > > > > > > +		__field(xfs_agnumber_t, agno)
> > > > > > > +		__field(xfs_agblock_t, agbno)
> > > > > > > +		__field(unsigned int, nr_records)
> > > > > > > +	),
> > > > > > > +	TP_fast_assign(
> > > > > > > +		__entry->dev = cur->bc_mp->m_super->s_dev;
> > > > > > > +		__entry->btnum = cur->bc_btnum;
> > > > > > > +		__entry->level = level;
> > > > > > > +		__entry->block_idx = block_idx;
> > > > > > > +		__entry->nr_blocks = nr_blocks;
> > > > > > > +		if (cur->bc_flags & XFS_BTREE_LONG_PTRS) {
> > > > > > > +			xfs_fsblock_t	fsb = be64_to_cpu(ptr->l);
> > > > > > > +
> > > > > > > +			__entry->agno = XFS_FSB_TO_AGNO(cur->bc_mp, fsb);
> > > > > > > +			__entry->agbno = XFS_FSB_TO_AGBNO(cur->bc_mp, fsb);
> > > > > > > +		} else {
> > > > > > > +			__entry->agno = cur->bc_private.a.agno;
> > > > > > > +			__entry->agbno = be32_to_cpu(ptr->s);
> > > > > > > +		}
> > > > > > > +		__entry->nr_records = nr_records;
> > > > > > > +	),
> > > > > > > +	TP_printk("dev %d:%d btree %s level %u block %llu/%llu fsb (%u/%u) recs %u",
> > > > > > > +		  MAJOR(__entry->dev), MINOR(__entry->dev),
> > > > > > > +		  __print_symbolic(__entry->btnum, XFS_BTNUM_STRINGS),
> > > > > > > +		  __entry->level,
> > > > > > > +		  __entry->block_idx,
> > > > > > > +		  __entry->nr_blocks,
> > > > > > > +		  __entry->agno,
> > > > > > > +		  __entry->agbno,
> > > > > > > +		  __entry->nr_records)
> > > > > > > +)
> > > > > > > +
> > > > > > >  #endif /* _TRACE_XFS_H */
> > > > > > >  
> > > > > > >  #undef TRACE_INCLUDE_PATH
> > > > > > > 
> > > > > > 
> > > > > 
> > > > 
> > > 
> > 
> 

