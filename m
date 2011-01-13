Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0DJbxZP183288 for <xfs@oss.sgi.com>; Thu, 13 Jan 2011 13:37:59 -0600
Date: Thu, 13 Jan 2011 13:39:28 -0600
From: bpm@sgi.com
Subject: Re: [PATCH] xfs_bmap_add_extent_delay_real should set br_startoff
Message-ID: <20110113193928.GC28274@sgi.com>
References: <20110112194228.8449.41844.stgit@lady3jane.americas.sgi.com>
	<20110113005207.GR28803@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110113005207.GR28803@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com, aelder@sgi.com

Hi Dave,

On Thu, Jan 13, 2011 at 11:52:07AM +1100, Dave Chinner wrote:
> On Wed, Jan 12, 2011 at 01:42:28PM -0600, Ben Myers wrote:
> > When filling in the middle of a previous delayed allocation, set
> > br_startoff of the new delay extent to the right to NULLSTARTBLOCK
> > so that it is ignored by xfs_bmap_extent_to_btree.  This prevents
> > a forced shutdown when that in-core extent is converted from delay
> > to real and is found to be already in the btree.  The value is
> > overwritten below.

You're right.  That's not a very good description.  I'll see about
describing it here and then see about boiling it down for repost.
 
> I'm not sure I understand what the problem is from your description.
> What actually goes wrong in xfs_bmap_extent_to_btree()?

While testing a related patch whose side effect is to exercise this code
more often...

I was hitting XFS_WANT_CORRUPTED_GOTOs in xfs_bmap_extent_delay_real in the
LEFT_FILLING, RIGHT_FILLING cases where we are going to insert an extent
into the btree and we look it up to make sure it isn't already there:

>From xfs_bmap_extent_delay_real:
911         case BMAP_LEFT_FILLING:
912                 /*
913                  * Filling in the first part of a previous delayed allocation.
914                  * The left neighbor is not contiguous.
915                  */
916                 trace_xfs_bmap_pre_update(ip, idx, state, _THIS_IP_);
917                 xfs_bmbt_set_startoff(ep, new_endoff);
918                 temp = PREV.br_blockcount - new->br_blockcount;
919                 xfs_bmbt_set_blockcount(ep, temp);
920                 xfs_iext_insert(ip, idx, 1, new, state);
921                 ip->i_df.if_lastex = idx;
922                 ip->i_d.di_nextents++;
923                 if (cur == NULL)
924                         rval = XFS_ILOG_CORE | XFS_ILOG_DEXT;
925                 else {
926                         rval = XFS_ILOG_CORE;
927                         if ((error = xfs_bmbt_lookup_eq(cur, new->br_startoff,
928                                         new->br_startblock, new->br_blockcount,
929                                         &i)))
930                                 goto done;
931                         XFS_WANT_CORRUPTED_GOTO(i == 0, done);

Forced shutdown at 931.  Alex was kind enough to review the code with me
and suggest that I print out the offending extent.  I found that the extent
in question was unusual... with a br_startblock == 0.  I set about
instrumenting xfs for assignments to br_startblock == 0 and mentioned this
to Alex.  He happened to remember this assignment at 1047 and his instincts
turned out to be right.

Assume ip->i_d.di_nextents == ip->i_df.if_ext_max, so you aren't btree
format yet and don't have a cursor.

1036         case 0:
1037                 /*
1038                  * Filling in the middle part of a previous delayed allocation.
1039                  * Contiguity is impossible here.
1040                  * This case is avoided almost all the time.
1041                  */
1042                 temp = new->br_startoff - PREV.br_startoff;

^ temp is the length of the extent to the left, which is delay

1043                 trace_xfs_bmap_pre_update(ip, idx, 0, _THIS_IP_);
1044                 xfs_bmbt_set_blockcount(ep, temp);

^ truncate the PREV extent so that it becomes the extent to the left.
	We don't need to set br_state because it should have already
	been delay.

1045                 r[0] = *new;

^ r[0] becomes the middle extent, a real allocation 

1046                 r[1].br_state = PREV.br_state;
1047                 r[1].br_startblock = 0;
1048                 r[1].br_startoff = new_endoff;
1049                 temp2 = PREV.br_startoff + PREV.br_blockcount - new_endoff;
1050                 r[1].br_blockcount = temp2;

^ r[1] becomes the extent to the right, and is supposed to be delay, but we
	set his br_startblock to 0 instead.

1051                 xfs_iext_insert(ip, idx + 1, 2, &r[0], state);

^ here we insert the middle r[0] and right r[1] extents into the ifork with
	r[1].br_startblock = 0

1052                 ip->i_df.if_lastex = idx + 1;
1053                 ip->i_d.di_nextents++;
1054                 if (cur == NULL)
1055                         rval = XFS_ILOG_CORE | XFS_ILOG_DEXT;

^ took this branch

1056                 else {
1057                         rval = XFS_ILOG_CORE;
1058                         if ((error = xfs_bmbt_lookup_eq(cur, new->br_startoff,
1059                                         new->br_startblock, new->br_blockcount,
1060                                         &i)))
1061                                 goto done;
1062                         XFS_WANT_CORRUPTED_GOTO(i == 0, done);
1063                         cur->bc_rec.b.br_state = XFS_EXT_NORM;
1064                         if ((error = xfs_btree_insert(cur, &i)))
1065                                 goto done;
1066                         XFS_WANT_CORRUPTED_GOTO(i == 1, done);
1067                 }

^ skipped this one

1068                 if (ip->i_d.di_format == XFS_DINODE_FMT_EXTENTS &&
1069                     ip->i_d.di_nextents > ip->i_df.if_ext_max) {
1070                         error = xfs_bmap_extents_to_btree(ip->i_transp, ip,
1071                                         first, flist, &cur, 1, &tmp_rval,
1072                                         XFS_DATA_FORK);

^ here we convert to btree format...

This loop in xfs_bmap_extents_to_btree copies extents from the ifork into
the btree:

3242         /*
3243          * Fill in the child block.
3244          */
3245         ablock = XFS_BUF_TO_BLOCK(abp);
3246         ablock->bb_magic = cpu_to_be32(XFS_BMAP_MAGIC);
3247         ablock->bb_level = 0;
3248         ablock->bb_u.l.bb_leftsib = cpu_to_be64(NULLDFSBNO);
3249         ablock->bb_u.l.bb_rightsib = cpu_to_be64(NULLDFSBNO);
3250         arp = XFS_BMBT_REC_ADDR(mp, ablock, 1);
3251         nextents = ifp->if_bytes / (uint)sizeof(xfs_bmbt_rec_t);
3252         for (cnt = i = 0; i < nextents; i++) {
3253                 ep = xfs_iext_get_ext(ifp, i);
3254                 if (!isnullstartblock(xfs_bmbt_get_startblock(ep))) {

^ note that it explicitly ignores delay allocation extents by testing for
STARTBLOCKMASK in br_startblock.

3255                         arp->l0 = cpu_to_be64(ep->l0);
3256                         arp->l1 = cpu_to_be64(ep->l1);
3257                         arp++; cnt++;
3258                 }
3259         }

So... when we converted from extents format to btree format we copied
	extent to the right into the tree because right.br_startblock = 0
	which is not a nullstartblock.  The right extent was actually
	destined to become delalloc in the ifork but that assignment
	happens only after we've converted to btree format.

The fix works because we set br_startblock to something that includes
STARTBLOCKMASK before inserting it into the ifork.  This way the test at
3254 will fail for that extent and it won't be inserted into the btree.

> I'm assuming
> that it counts one too many real extents, and if so, shouldn't it
> fire this assert long before you get to a shutdown situation?
> 
> 	ASSERT(cnt == XFS_IFORK_NEXTENTS(ip, whichfork));

It should.

> Also, do you have a test case that triggers this? If so, can it be
> turned into a xfstests case? I like to have some idea of how the
> problem was encountered and verified, because this code is complex
> and easy to misunderstand...

I don't have a test case.  Building one might be possible by using extsize
to get large delalloc allocations and modifying xfs_iomap_write_allocate to
only allocate for the passed in offset and count instead of from passed in
iomap...

> > SGI-PV: 1013221
> 
> The following is mostly the notes I wrote to understand what your
> patch does.  I'm posting them so others don't need to go through the
> same analysis to understand the patch. While you might have the
> analysis in the above PV we can't see it at all, so it would be
> appreciated if you could put a summary of the bug analysis and
> test case in the commit message so we don't have to spend a couple of
> hours just to work out what the patch does...

Here are some traces from the PV:

Dec 21 13:08:22 gtomds1 kernel: [ 2008.237772] xfs_iext_insert (ffff88018de2c3c0) br_startoff 9240 br_startblock 304078611 br_blockcount 512 br_state 0
Dec 21 13:08:22 gtomds1 kernel: [ 2008.237775] xfs_bmbt_set_all set w/ startblock == 0.  br_startoff 9752, br_startblock 0 br_blockcount 18408, br_state 0
....
Dec 21 13:08:22 gtomds1 kernel: [ 2008.238578] xfs_bmap_extents_to_btree (0xffff88018de2c3c0) 0: startoff 0 startblock NULLSTARTBLOCK(5) blockcount 5 flag 0
Dec 21 13:08:22 gtomds1 kernel: [ 2008.238583] xfs_bmap_extents_to_btree (0xffff88018de2c3c0) 1: startoff 5 startblock 304069376[4:21fbb00] blockcount 512 flag 0
Dec 21 13:08:22 gtomds1 kernel: [ 2008.238590] xfs_bmap_extents_to_btree (0xffff88018de2c3c0) 2: startoff 517 startblock NULLSTARTBLOCK(5) blockcount 2 flag 0
Dec 21 13:08:22 gtomds1 kernel: [ 2008.238594] xfs_bmap_extents_to_btree (0xffff88018de2c3c0) 3: startoff 519 startblock 304069890[4:21fbd02] blockcount 512 flag 0
Dec 21 13:08:22 gtomds1 kernel: [ 2008.238598] xfs_bmap_extents_to_btree (0xffff88018de2c3c0) 4: startoff 1031 startblock NULLSTARTBLOCK(5) blockcount 1 flag 0
Dec 21 13:08:22 gtomds1 kernel: [ 2008.238602] xfs_bmap_extents_to_btree (0xffff88018de2c3c0) 5: startoff 1032 startblock 304070403[4:21fbf03] blockcount 1024 flag 0
Dec 21 13:08:22 gtomds1 kernel: [ 2008.238606] xfs_bmap_extents_to_btree (0xffff88018de2c3c0) 6: startoff 2056 startblock NULLSTARTBLOCK(5) blockcount 3 flag 0
Dec 21 13:08:22 gtomds1 kernel: [ 2008.238610] xfs_bmap_extents_to_btree (0xffff88018de2c3c0) 7: startoff 2059 startblock 304071430[4:21fc306] blockcount 1024 flag 0
Dec 21 13:08:22 gtomds1 kernel: [ 2008.238614] xfs_bmap_extents_to_btree (0xffff88018de2c3c0) 8: startoff 3083 startblock NULLSTARTBLOCK(5) blockcount 3 flag 0
Dec 21 13:08:22 gtomds1 kernel: [ 2008.238618] xfs_bmap_extents_to_btree (0xffff88018de2c3c0) 9: startoff 3086 startblock 304072457[4:21fc709] blockcount 2560 flag 0
Dec 21 13:08:22 gtomds1 kernel: [ 2008.238623] xfs_bmap_extents_to_btree (0xffff88018de2c3c0) 10: startoff 5646 startblock NULLSTARTBLOCK(5) blockcount 1 flag 0
Dec 21 13:08:22 gtomds1 kernel: [ 2008.238627] xfs_bmap_extents_to_btree (0xffff88018de2c3c0) 11: startoff 5647 startblock 304075018[4:21fd10a] blockcount 512 flag 0
Dec 21 13:08:22 gtomds1 kernel: [ 2008.238631] xfs_bmap_extents_to_btree (0xffff88018de2c3c0) 12: startoff 6159 startblock NULLSTARTBLOCK(5) blockcount 4 flag 0
Dec 21 13:08:22 gtomds1 kernel: [ 2008.238635] xfs_bmap_extents_to_btree (0xffff88018de2c3c0) 13: startoff 6163 startblock 304075534[4:21fd30e] blockcount 1024 flag 0
Dec 21 13:08:23 gtomds1 kernel: [ 2008.238639] xfs_bmap_extents_to_btree (0xffff88018de2c3c0) 14: startoff 7187 startblock NULLSTARTBLOCK(5) blockcount 2 flag 0
Dec 21 13:08:23 gtomds1 kernel: [ 2008.238643] xfs_bmap_extents_to_btree (0xffff88018de2c3c0) 15: startoff 7189 startblock 304076560[4:21fd710] blockcount 1024 flag 0
Dec 21 13:08:23 gtomds1 kernel: [ 2008.238647] xfs_bmap_extents_to_btree (0xffff88018de2c3c0) 16: startoff 8213 startblock NULLSTARTBLOCK(5) blockcount 2 flag 0
Dec 21 13:08:23 gtomds1 kernel: [ 2008.238651] xfs_bmap_extents_to_btree (0xffff88018de2c3c0) 17: startoff 8215 startblock 304077586[4:21fdb12] blockcount 1024 flag 0
Dec 21 13:08:23 gtomds1 kernel: [ 2008.238655] xfs_bmap_extents_to_btree (0xffff88018de2c3c0) 18: startoff 9239 startblock NULLSTARTBLOCK(79) blockcount 1 flag 0
Dec 21 13:08:23 gtomds1 kernel: [ 2008.238659] xfs_bmap_extents_to_btree (0xffff88018de2c3c0) 19: startoff 9240 startblock 304078611[4:21fdf13] blockcount 512 flag 0
Dec 21 13:08:23 gtomds1 kernel: [ 2008.238663] xfs_bmap_extents_to_btree (0xffff88018de2c3c0) 20: startoff 9752 startblock 0[0:0] blockcount 18408 flag 0		<---- we added an extent to the btree with startblock=0
....
Dec 21 13:08:42 gtomds1 kernel: [ 2009.735411] xfs_bmap_add_extent_delay_real new br_startoff 9752 br_startblock 304079636 br_blockcount1      <---- and it turns out to be the same one we crash on later!
Dec 21 13:08:42 gtomds1 kernel: [ 2009.735415] cur ffff8802bbf16a80, tp 0xffff88018ce68450 mp 0xffff8802c5542800
Dec 21 13:08:42 gtomds1 kernel: [ 2009.735417] rec.b startoff 9752 startblock 121fe314 blockcount 1 state 0
Dec 21 13:08:42 gtomds1 kernel: [ 2009.735420] bufs level 1 ((null))    1, 0; 
Dec 21 13:08:42 gtomds1 kernel: [ 2009.735424]  level 0 (ffff8802c78b3340)      1, 0; 2, 5; 3, 2417; 4, 2418; 5, 2618; 6, 2619; 7, 281c; 8, 2a22; 9, 2c24; 10, 3427; 11, 362f; 12, 3833; 1
3, 3c34; 14, 3e36; 15, 4037; 16, 4438; 17, 4639; 18, 4e3a; 19, 563b; 20, 5a3d; 21, 5c41; 22, 5e45; 23, 6048; 24, 624a; 25, 684b; 26, 6c4c; 27, 6e4d; 28, 7251; 29, 7452; 30, 7653; 31, 785
5; 32, 7a56; 33, 7c58; 34, 8059; 35, 825b; 36, 845c; 37, 8a5f; 38, 8c60; 39, 8e62; 40, 9065; 41, 9467; 42, 9c6e; 43, 9e6f; 44, a070; 45, a471; 46, a675; 47, a879; 48, aa7a; 49, ac7b; 50,
 b07c; 51, b27d; 52, ba7f; 53, bc81; 54, c284; 55, c688; 56, c88a; 57, ca8e; 58, ce8f; 59, d094; 60, d295; 61, d496; 62, d697; 63, da9a; 64, dc9c; 65, dea2; 66, e0a5; 67, e2a8; 68, eaa9;
 69, ecaa; 70, eead; 71, f4b1; 72, f6b7; 73, f8b8; 74, fabd; 75, 100bf; 76, 102c7; 77, 104c8; 78, 106ca; 79, 108cd; 80, 10acf; 81, 10cd2; 82, 10ed8; 83, 114da; 84, 11adc; 85, 11ce4; 86, 
11ee5; 87, 124e8; 88, 126e9; 89, 128ef; 90, 12af3; 91, 12cf4; 92, 130f5; 93, 134fb; 94, 13efd; 95, 148f		<----------- we find that extent at key 5, startoff 0x2418
Dec 21 13:08:42 gtomds1 kernel: e; 96, 14b08; 97, 14d0b; 98, 14f11; 99, 15112; 100, 15519; 101, 1591c; 102, 15b1f; 103, 15d22; 104, 15f24; 105, 16126; 106, 16527; 107, 16728; 108, 16d31;
 109, 16f32; 110, 17133; 111, 17335; 112, 17538; 113, 1773a; 114, 1793b; 115, 17b3c; 116, 17d3e; 117, 17f3f; 118, 18142; 119, 1854d; 
Dec 21 13:08:42 gtomds1 kernel: [ 2009.735492] ptrs level 1: 0x1
Dec 21 13:08:42 gtomds1 kernel: [ 2009.735494] 
Dec 21 13:08:42 gtomds1 kernel: [ 2009.735495]   ra 3 0
Dec 21 13:08:42 gtomds1 kernel: [ 2009.735498] nlevels 2 btnum bmap blocklog 12
Dec 21 13:08:42 gtomds1 kernel: [ 2009.735500] private forksize 0x9c whichfork 0 ip 0xffff8800bf3c0900 flags 1
Dec 21 13:08:42 gtomds1 kernel: [ 2009.735504] private firstblock 304079636[4:21fe314] flist 0xffff88018ce85a10 allocated 0x0
....
Dec 21 13:13:34 gtomds1 kernel: [ 2273.368378] xfs_bmbt_lookup[exit@1180] ip 0xffff8800bf3c0900 df cur 0xffff8802bbf16a80

Let me know if you want more information.

Thanks,
Ben


> > 
> > Signed-off-by: Ben Myers <bpm@sgi.com>
> > ---
> >  fs/xfs/xfs_bmap.c |    5 +++--
> >  1 files changed, 3 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_bmap.c b/fs/xfs/xfs_bmap.c
> > index 4111cd3..cd75c77 100644
> > --- a/fs/xfs/xfs_bmap.c
> > +++ b/fs/xfs/xfs_bmap.c
> > @@ -1040,13 +1040,14 @@ xfs_bmap_add_extent_delay_real(
> >  		 * This case is avoided almost all the time.
> >  		 */
> >  		temp = new->br_startoff - PREV.br_startoff;
> > +		temp2 = PREV.br_startoff + PREV.br_blockcount - new_endoff;
> >  		trace_xfs_bmap_pre_update(ip, idx, 0, _THIS_IP_);
> >  		xfs_bmbt_set_blockcount(ep, temp);
> >  		r[0] = *new;
> >  		r[1].br_state = PREV.br_state;
> > -		r[1].br_startblock = 0;
> > +		r[1].br_startblock = nullstartblock(
> > +				(int)xfs_bmap_worst_indlen(ip, temp2));
> 
> As a side note, this would be easier to understand if you converted
> all the r[x] notations to LEFT, RIGHT and PREV to match the rest of
> the code (i.e. LEFT == r[0], RIGHT = r[1] and PREV = r[2]). if you
> are touching this code, then this should probably be done now.
> 
> The code starts with:
> 
>      +ddddddddddddddddddddddddddddddddddddddddddddddddd+
> 	 r[2] @ idx
> 	 PREV @ idx
> 
> and we are allocating:
>                          +rrrrrrrrrrrrrrr+
> 			        new
> and does:
> 
> 1042                 temp = new->br_startoff - PREV.br_startoff;
> 1043                 trace_xfs_bmap_pre_update(ip, idx, 0, _THIS_IP_);
> 1044                 xfs_bmbt_set_blockcount(ep, temp);
> 1045                 r[0] = *new;
> 1046                 r[1].br_state = PREV.br_state;
> 1047                 r[1].br_startblock = 0;
> 1048                 r[1].br_startoff = new_endoff;
> 1049                 temp2 = PREV.br_startoff + PREV.br_blockcount - new_endoff;
> 1050                 r[1].br_blockcount = temp2;
> 1051                 xfs_iext_insert(ip, idx + 1, 2, &r[0], state);
> 
> Which translates as:
> 
> 	LEFT = *new;
> 	PREV.br_blockcount = LEFT.br_startoff = PREV.br_startoff
> 	RIGHT.br_state = PREV.br_state;
> 	RIGHT.br_startblock = 0;
> 	RIGHT.br_startoff = LEFT.br_startblock + LEFT.br_blockcount;
> 	RIGHT.br_blockcount = PREV.br_startoff + PREV.br_blockcount
> 				- RIGHT.br_startoff;
> 
> Which means it has been set up as:
> 
>      +ddddddddddddddddddd+rrrrrrrrrrrrrrr+ddddddddddddd+
> 			        new
> 	 r[2] @ idx        r[0]              r[1]
> 	 PREV @ idx	   LEFT              RIGHT
> 	                 inserted @ idx + 1
> 
> Ok, that all looks good so far except RIGHT is not yet set up as a
> delalloc extent. If the inode is in btree format (i.e. a cursor
> exists), it inserts the new extent into the btree, otherwise we
> trigger:
> 
> 1068                 if (ip->i_d.di_format == XFS_DINODE_FMT_EXTENTS &&
> 1069                     ip->i_d.di_nextents > ip->i_df.if_ext_max) {
> 1070                         error = xfs_bmap_extents_to_btree(ip->i_transp, ip,
> 1071                                         first, flist, &cur, 1, &tmp_rval,
> 1072                                         XFS_DATA_FORK);
> 1073                         rval |= tmp_rval;
> 1074                         if (error)
> 1075                                 goto done;
> 1076                 }
> 
> OK, so this is done while the incore extent tree is in inconsistent
> state. Then we do some delalloc reservation futzing but does not
> modify the reservations in the extents based on the numbe of blocks
> allocated.
> 
> Oh, if the extent->btree conversion allocates more blocks than the
> extent allocated reserrved, then it tries to do a new reservation
> for the difference (some comments in this code would be nice) and
> has some nasty failure code.
> 
> But, that doesn't stop us from updating the delalloc block
> reservation counts in the extents before we convert the tree format
> so long ias we calculate diff (excluding allocated btree blocks) before
> we update PREV.br_startblock.
> 
> So that means if we move this hunk and the diff calculation up above
> the extent->btree conversion check:
> 
> 1109                 ep = xfs_iext_get_ext(ifp, idx);
> 1110                 xfs_bmbt_set_startblock(ep, nullstartblock((int)temp));
> 1111                 trace_xfs_bmap_post_update(ip, idx, state, _THIS_IP_);
> 1112                 trace_xfs_bmap_pre_update(ip, idx + 2, state, _THIS_IP_);
> 1113                 xfs_bmbt_set_startblock(xfs_iext_get_ext(ifp, idx + 2),
> 1114                         nullstartblock((int)temp2));
> 1115                 trace_xfs_bmap_post_update(ip, idx + 2, state, _THIS_IP_);
> 
> And add:
> 
> 	diff -= cur ? cur->bc_private.b.allocated : 0;
> 
> after the conversion, everything should work just fine and the
> tracing will continue to give the same output.
> 
> --
> 
> Ok, so the bug looks real, but I'm not sure that the fix really
> improves anything. The code needs to use LEFT, RIGHT and PREV, coul
> ddo with better variable names than temp and temp2, and probably
> should reorder the operations and the associated tracing as well as
> comment what the hell the code is actually doing. Typically with a
> fix like this I'll end up adding 5-10x as many lines in comments as
> code changes that fix the bug, just so I don't have to go through
> this process next time I have to look at this code....
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
