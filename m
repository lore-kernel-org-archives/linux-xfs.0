Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54519 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725896AbfAWS6j (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 23 Jan 2019 13:58:39 -0500
Date: Wed, 23 Jan 2019 13:58:35 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: Regular FS shutdown while rsync is running
Message-ID: <20190123185835.GC27886@bfoster>
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
To: Lucas Stach <l.stach@pengutronix.de>
Cc: linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>

On Wed, Jan 23, 2019 at 08:03:07AM -0500, Brian Foster wrote:
> On Wed, Jan 23, 2019 at 07:11:53AM -0500, Brian Foster wrote:
> > On Wed, Jan 23, 2019 at 12:14:17PM +0100, Lucas Stach wrote:
> > > Am Dienstag, den 22.01.2019, 08:02 -0500 schrieb Brian Foster:
> > > > On Tue, Jan 22, 2019 at 11:39:53AM +0100, Lucas Stach wrote:
> > > > > Hi Brian,
> > > > > 
> > > > > Am Montag, den 21.01.2019, 13:11 -0500 schrieb Brian Foster:
> > > > > [...]
> > > > > > > So for the moment, here's the output of the above sequence.
> > > > > > > 
> > > > > > > xfs_db> convert agno 5 agbno 7831662 fsb
> > > > > > > 0x5077806e (1350008942)
> > > > > > > xfs_db> fsb 0x5077806e
> > > > > > > xfs_db> type finobt
> > > > > > > xfs_db> print
> > > > > > > magic = 0x49414233
> > > > > > > level = 1
> > > > > > > numrecs = 335
> > > > > > > leftsib = 7810856
> > > > > > > rightsib = null
> > > > > > > bno = 7387612016
> > > > > > > lsn = 0x6671003d9700
> > > > > > > uuid = 026711cc-25c7-44b9-89aa-0aac496edfec
> > > > > > > owner = 5
> > > > > > > crc = 0xe12b19b2 (correct)
> > > > > > 
> > > > > > As expected, we have the inobt magic. Interesting that this is a fairly
> > > > > > full intermediate (level > 0) node. There is no right sibling, which
> > > > > > means we're at the far right end of the tree. I wouldn't mind poking
> > > > > > around a bit more at the tree, but that might be easier with access to
> > > > > > the metadump. I also think that xfs_repair would have complained were
> > > > > > something more significant wrong with the tree.
> > > > > > 
> > > > > > Hmm, I wonder if the (lightly tested) diff below would help us catch
> > > > > > anything. It basically just splits up the currently combined inobt and
> > > > > > finobt I/O verifiers to expect the appropriate magic number (rather than
> > > > > > accepting either magic for both trees). Could you give that a try?
> > > > > > Unless we're doing something like using the wrong type of cursor for a
> > > > > > particular tree, I'd think this would catch wherever we happen to put a
> > > > > > bad magic on disk. Note that this assumes the underlying filesystem has
> > > > > > been repaired so as to try and detect the next time an on-disk
> > > > > > corruption is introduced.
> > > > > > 
> > > > > > You'll also need to turn up the XFS error level to make sure this prints
> > > > > > out a stack trace if/when a verifier failure triggers:
> > > > > > 
> > > > > > echo 5 > /proc/sys/fs/xfs/error_level
> > > > > > 
> > > > > > I guess we also shouldn't rule out hardware issues or whatnot. I did
> > > > > > notice you have a strange kernel version: 4.19.4-holodeck10. Is that a
> > > > > > distro kernel? Has it been modified from upstream in any way? If so, I'd
> > > > > > strongly suggest to try and confirm whether this is reproducible with an
> > > > > > upstream kernel.
> > > > > 
> > > > > With the finobt verifier changes applied we are unable to mount the FS,
> > > > > even after running xfs_repair.
> > > > > 
> > > > > xfs_repair had found "bad magic # 0x49414233 in inobt block 5/2631703",
> > > > > which would be daddr 0x1b5db40b8 according to xfs_db. The mount trips
> > > > > over a buffer at a different daddr though:
> > > > > 
> > > > 
> > > > So the mount failed, you ran repair and discovered the bad magic..? That
> > > > suggests there was still an issue with the fs on-disk. Could you run
> > > > 'xfs_repair -n' after the actual xfs_repair to confirm the fs is free of
> > > > errors before it is mounted? Note that xfs_repair unconditionally
> > > > regenerates certain metadata structures (like the finobt) from scratch
> > > > so there is always the possibility that xfs_repair itself is introducing
> > > > some problem in the fs.
> > > 
> > > The sequence was:
> > > 1. Trying to mount with the debug kernel, which didn't work due to the
> > > finobt verifier rejecting a bad btree node.
> > > 2. Full run of mutating xfs_repair (which did find a finobt node with
> > > bad magic)
> > > 3. Try to mount again, still fails due to finobt verifier rejecting a
> > > bad btree node, but at a different daddr than what was flagged by
> > > xfs_repair.
> > > 4. xfs_repair -n finds a bad magic finobt node at the same position as
> > > the mount splat.
> > > 
> > > This leads me to wonder if xfs_repair was the poison rather than the
> > > cure in this case. After digging into the xfs_repair code I found the
> > > following, which looks suspicious, but I don't know enough about XFS
> > > internals to tell if this can actually happen:
> > > 
> > 
> > That does imply xfs_repair is the culprit. If you haven't, could you try
> > the xfs_repair -> xfs_repair -n sequence without a mount attempt in the
> > picture just to be sure? That may also explain why the block seems to
> > shift around. It wouldn't surprise me if it's the same relative block in
> > the tree, but IIRC the tree itself can be shifted around run to run.
> > 
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
> > > 
> > 
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

I created a large finobt filesystem, confirmed that xfs_repair stamps
every node as noted above with the inobt magic, and verified that the
patch below fixes the problem. I'll post it to the list shortly. Thanks
again.

Brian

> I'm guessing you have a large enough set of inodes and a sustained
> enough deletion pattern in your workload that you eventually free enough
> inodes across a large enough set of records to populate a multi-block
> level 1 tree. Then as soon as you try to allocate from that side of the
> tree the finer grained checks in __xfs_btree_check_[l|s]block() discover
> the wrong magic and generate the error.
> 
> The positive here is that this isn't really a coherency problem with the
> filesystem. The finobt itself is coherent, consistent with the inobt and
> the magic value doesn't really dictate how the trees are used/updated at
> runtime. This means that the only real corruption should be the magic
> value.
> 
> I am wondering whether this warrants a special case in the magic
> checking to convert the runtime internal error into more of a warning to
> unmount and run xfs_repair (similar to how we detected the agfl size
> mismatch problem). Dave, any thoughts on that?
> 
> Brian
> 
> > > So if it's possible to get into this code path while rebuilding the
> > > finobt, xfs_repair will generate a otherwise valid btree node with the
> > > wrong magic, which matches what we see.
> > > 
> > > Sadly we have no more debug information available about the state of
> > > the FS on the first crash, which lead us to run xfs_repair in the first
> > > place.
> > > 
> > 
> > Naturally, the next question would have been what required repair in the
> > first place. :P
> > 
> > Anyways, if you wanted to give this a quick try to confirm it looks like
> > a fairly straightforward change. See the appended xfsprogs patch. Note
> > again that you can (and should) run this against the restored metadump
> > that captures the corruption before running against the primary fs.
> > 
> > Brian
> > 
> > --- 8< ---
> > 
> > diff --git a/repair/phase5.c b/repair/phase5.c
> > index 85d1f4fb..05333f11 100644
> > --- a/repair/phase5.c
> > +++ b/repair/phase5.c
> > @@ -983,7 +983,7 @@ init_ino_cursor(xfs_mount_t *mp, xfs_agnumber_t agno, bt_status_t *btree_curs,
> >  
> >  static void
> >  prop_ino_cursor(xfs_mount_t *mp, xfs_agnumber_t agno, bt_status_t *btree_curs,
> > -	xfs_agino_t startino, int level)
> > +	xfs_btnum_t btnum, xfs_agino_t startino, int level)
> >  {
> >  	struct xfs_btree_block	*bt_hdr;
> >  	xfs_inobt_key_t		*bt_key;
> > @@ -1005,7 +1005,7 @@ prop_ino_cursor(xfs_mount_t *mp, xfs_agnumber_t agno, bt_status_t *btree_curs,
> >  		 * first path up the left side of the tree
> >  		 * where the agbno's are already set up
> >  		 */
> > -		prop_ino_cursor(mp, agno, btree_curs, startino, level);
> > +		prop_ino_cursor(mp, agno, btree_curs, btnum, startino, level);
> >  	}
> >  
> >  	if (be16_to_cpu(bt_hdr->bb_numrecs) ==
> > @@ -1041,7 +1041,7 @@ prop_ino_cursor(xfs_mount_t *mp, xfs_agnumber_t agno, bt_status_t *btree_curs,
> >  		lptr->buf_p->b_ops = &xfs_inobt_buf_ops;
> >  		bt_hdr = XFS_BUF_TO_BLOCK(lptr->buf_p);
> >  		memset(bt_hdr, 0, mp->m_sb.sb_blocksize);
> > -		libxfs_btree_init_block(mp, lptr->buf_p, XFS_BTNUM_INO,
> > +		libxfs_btree_init_block(mp, lptr->buf_p, btnum,
> >  					level, 0, agno, 0);
> >  
> >  		bt_hdr->bb_u.s.bb_leftsib = cpu_to_be32(lptr->prev_agbno);
> > @@ -1049,7 +1049,7 @@ prop_ino_cursor(xfs_mount_t *mp, xfs_agnumber_t agno, bt_status_t *btree_curs,
> >  		/*
> >  		 * propagate extent record for first extent in new block up
> >  		 */
> > -		prop_ino_cursor(mp, agno, btree_curs, startino, level);
> > +		prop_ino_cursor(mp, agno, btree_curs, btnum, startino, level);
> >  	}
> >  	/*
> >  	 * add inode info to current block
> > @@ -1201,7 +1201,7 @@ build_ino_tree(xfs_mount_t *mp, xfs_agnumber_t agno,
> >  			lptr->modulo--;
> >  
> >  		if (lptr->num_recs_pb > 0)
> > -			prop_ino_cursor(mp, agno, btree_curs,
> > +			prop_ino_cursor(mp, agno, btree_curs, btnum,
> >  					ino_rec->ino_startnum, 0);
> >  
> >  		bt_rec = (xfs_inobt_rec_t *)
