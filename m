Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0DNDZVa192342 for <xfs@oss.sgi.com>; Thu, 13 Jan 2011 17:13:36 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6059925FEB2
	for <xfs@oss.sgi.com>; Thu, 13 Jan 2011 15:15:48 -0800 (PST)
Received: from mail.internode.on.net (bld-mail18.adl2.internode.on.net
	[150.101.137.103]) by cuda.sgi.com with ESMTP id
	pCKBPyxW3Z1G16lO for <xfs@oss.sgi.com>;
	Thu, 13 Jan 2011 15:15:48 -0800 (PST)
Date: Fri, 14 Jan 2011 10:15:44 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs_bmap_add_extent_delay_real should set br_startoff
Message-ID: <20110113231544.GE16267@dastard>
References: <20110112194228.8449.41844.stgit@lady3jane.americas.sgi.com>
	<20110113005207.GR28803@dastard> <20110113193928.GC28274@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110113193928.GC28274@sgi.com>
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
To: bpm@sgi.com
Cc: xfs@oss.sgi.com, aelder@sgi.com

On Thu, Jan 13, 2011 at 01:39:28PM -0600, bpm@sgi.com wrote:
> Hi Dave,
> 
> On Thu, Jan 13, 2011 at 11:52:07AM +1100, Dave Chinner wrote:
> > On Wed, Jan 12, 2011 at 01:42:28PM -0600, Ben Myers wrote:
> > > When filling in the middle of a previous delayed allocation, set
> > > br_startoff of the new delay extent to the right to NULLSTARTBLOCK
> > > so that it is ignored by xfs_bmap_extent_to_btree.  This prevents
> > > a forced shutdown when that in-core extent is converted from delay
> > > to real and is found to be already in the btree.  The value is
> > > overwritten below.
> 
> You're right.  That's not a very good description.  I'll see about
> describing it here and then see about boiling it down for repost.
>  
> > I'm not sure I understand what the problem is from your description.
> > What actually goes wrong in xfs_bmap_extent_to_btree()?
> 
> While testing a related patch whose side effect is to exercise this code
> more often...
> 
> I was hitting XFS_WANT_CORRUPTED_GOTOs in xfs_bmap_extent_delay_real in the
> LEFT_FILLING, RIGHT_FILLING cases where we are going to insert an extent
> into the btree and we look it up to make sure it isn't already there:
> 
> From xfs_bmap_extent_delay_real:
> 911         case BMAP_LEFT_FILLING:
> 912                 /*
> 913                  * Filling in the first part of a previous delayed allocation.
> 914                  * The left neighbor is not contiguous.
> 915                  */
> 916                 trace_xfs_bmap_pre_update(ip, idx, state, _THIS_IP_);
> 917                 xfs_bmbt_set_startoff(ep, new_endoff);
> 918                 temp = PREV.br_blockcount - new->br_blockcount;
> 919                 xfs_bmbt_set_blockcount(ep, temp);
> 920                 xfs_iext_insert(ip, idx, 1, new, state);
> 921                 ip->i_df.if_lastex = idx;
> 922                 ip->i_d.di_nextents++;
> 923                 if (cur == NULL)
> 924                         rval = XFS_ILOG_CORE | XFS_ILOG_DEXT;
> 925                 else {
> 926                         rval = XFS_ILOG_CORE;
> 927                         if ((error = xfs_bmbt_lookup_eq(cur, new->br_startoff,
> 928                                         new->br_startblock, new->br_blockcount,
> 929                                         &i)))
> 930                                 goto done;
> 931                         XFS_WANT_CORRUPTED_GOTO(i == 0, done);
> 
> Forced shutdown at 931.

So it was allocating a different part of the delalloc extent
that triggered it. OK.

<snip>

> This loop in xfs_bmap_extents_to_btree copies extents from the ifork into
> the btree:
> 
> 3242         /*
> 3243          * Fill in the child block.
> 3244          */
> 3245         ablock = XFS_BUF_TO_BLOCK(abp);
> 3246         ablock->bb_magic = cpu_to_be32(XFS_BMAP_MAGIC);
> 3247         ablock->bb_level = 0;
> 3248         ablock->bb_u.l.bb_leftsib = cpu_to_be64(NULLDFSBNO);
> 3249         ablock->bb_u.l.bb_rightsib = cpu_to_be64(NULLDFSBNO);
> 3250         arp = XFS_BMBT_REC_ADDR(mp, ablock, 1);
> 3251         nextents = ifp->if_bytes / (uint)sizeof(xfs_bmbt_rec_t);
> 3252         for (cnt = i = 0; i < nextents; i++) {
> 3253                 ep = xfs_iext_get_ext(ifp, i);
> 3254                 if (!isnullstartblock(xfs_bmbt_get_startblock(ep))) {
> 
> ^ note that it explicitly ignores delay allocation extents by testing for
> STARTBLOCKMASK in br_startblock.
> 
> 3255                         arp->l0 = cpu_to_be64(ep->l0);
> 3256                         arp->l1 = cpu_to_be64(ep->l1);
> 3257                         arp++; cnt++;
> 3258                 }
> 3259         }
> 
> So... when we converted from extents format to btree format we copied
> 	extent to the right into the tree because right.br_startblock = 0
> 	which is not a nullstartblock.  The right extent was actually
> 	destined to become delalloc in the ifork but that assignment
> 	happens only after we've converted to btree format.
> 
> The fix works because we set br_startblock to something that includes
> STARTBLOCKMASK before inserting it into the ifork.  This way the test at
> 3254 will fail for that extent and it won't be inserted into the btree.
> 
> > I'm assuming
> > that it counts one too many real extents, and if so, shouldn't it
> > fire this assert long before you get to a shutdown situation?
> > 
> > 	ASSERT(cnt == XFS_IFORK_NEXTENTS(ip, whichfork));
> 
> It should.

Thanks for confirming that. Might I suggest that running a debug XFS
build is a good idea purely because it will catch problems like this
when they happen, rather than when you trip over the result later
on?

> > Also, do you have a test case that triggers this? If so, can it be
> > turned into a xfstests case? I like to have some idea of how the
> > problem was encountered and verified, because this code is complex
> > and easy to misunderstand...
> 
> I don't have a test case.  Building one might be possible by using extsize
> to get large delalloc allocations and modifying xfs_iomap_write_allocate to
> only allocate for the passed in offset and count instead of from passed in
> iomap...

Hmmm, not really a generic test case :/

I was thinking that we might be able to use sync_file_range() to
write small ranges of pages inside a delalloc extent. However, it
does not limit wbc->nr_to_write() so I suspect it will write entire
delalloc extents at a time rather than small chunks.

> > > SGI-PV: 1013221
> > 
> > The following is mostly the notes I wrote to understand what your
> > patch does.  I'm posting them so others don't need to go through the
> > same analysis to understand the patch. While you might have the
> > analysis in the above PV we can't see it at all, so it would be
> > appreciated if you could put a summary of the bug analysis and
> > test case in the commit message so we don't have to spend a couple of
> > hours just to work out what the patch does...
> 
> Here are some traces from the PV:
> 
> Dec 21 13:08:22 gtomds1 kernel: [ 2008.237772] xfs_iext_insert (ffff88018de2c3c0) br_startoff 9240 br_startblock 304078611 br_blockcount 512 br_state 0
> Dec 21 13:08:22 gtomds1 kernel: [ 2008.237775] xfs_bmbt_set_all set w/ startblock == 0.  br_startoff 9752, br_startblock 0 br_blockcount 18408, br_state 0
> ....
> Dec 21 13:08:22 gtomds1 kernel: [ 2008.238578] xfs_bmap_extents_to_btree (0xffff88018de2c3c0) 0: startoff 0 startblock NULLSTARTBLOCK(5) blockcount 5 flag 0
> Dec 21 13:08:22 gtomds1 kernel: [ 2008.238583] xfs_bmap_extents_to_btree (0xffff88018de2c3c0) 1: startoff 5 startblock 304069376[4:21fbb00] blockcount 512 flag 0
> Dec 21 13:08:22 gtomds1 kernel: [ 2008.238590] xfs_bmap_extents_to_btree (0xffff88018de2c3c0) 2: startoff 517 startblock NULLSTARTBLOCK(5) blockcount 2 flag 0
> Dec 21 13:08:22 gtomds1 kernel: [ 2008.238594] xfs_bmap_extents_to_btree (0xffff88018de2c3c0) 3: startoff 519 startblock 304069890[4:21fbd02] blockcount 512 flag 0
> Dec 21 13:08:22 gtomds1 kernel: [ 2008.238598] xfs_bmap_extents_to_btree (0xffff88018de2c3c0) 4: startoff 1031 startblock NULLSTARTBLOCK(5) blockcount 1 flag 0
> Dec 21 13:08:22 gtomds1 kernel: [ 2008.238602] xfs_bmap_extents_to_btree (0xffff88018de2c3c0) 5: startoff 1032 startblock 304070403[4:21fbf03] blockcount 1024 flag 0
> Dec 21 13:08:22 gtomds1 kernel: [ 2008.238606] xfs_bmap_extents_to_btree (0xffff88018de2c3c0) 6: startoff 2056 startblock NULLSTARTBLOCK(5) blockcount 3 flag 0
> Dec 21 13:08:22 gtomds1 kernel: [ 2008.238610] xfs_bmap_extents_to_btree (0xffff88018de2c3c0) 7: startoff 2059 startblock 304071430[4:21fc306] blockcount 1024 flag 0
> Dec 21 13:08:22 gtomds1 kernel: [ 2008.238614] xfs_bmap_extents_to_btree (0xffff88018de2c3c0) 8: startoff 3083 startblock NULLSTARTBLOCK(5) blockcount 3 flag 0
> Dec 21 13:08:22 gtomds1 kernel: [ 2008.238618] xfs_bmap_extents_to_btree (0xffff88018de2c3c0) 9: startoff 3086 startblock 304072457[4:21fc709] blockcount 2560 flag 0
> Dec 21 13:08:22 gtomds1 kernel: [ 2008.238623] xfs_bmap_extents_to_btree (0xffff88018de2c3c0) 10: startoff 5646 startblock NULLSTARTBLOCK(5) blockcount 1 flag 0
> Dec 21 13:08:22 gtomds1 kernel: [ 2008.238627] xfs_bmap_extents_to_btree (0xffff88018de2c3c0) 11: startoff 5647 startblock 304075018[4:21fd10a] blockcount 512 flag 0
> Dec 21 13:08:22 gtomds1 kernel: [ 2008.238631] xfs_bmap_extents_to_btree (0xffff88018de2c3c0) 12: startoff 6159 startblock NULLSTARTBLOCK(5) blockcount 4 flag 0
> Dec 21 13:08:22 gtomds1 kernel: [ 2008.238635] xfs_bmap_extents_to_btree (0xffff88018de2c3c0) 13: startoff 6163 startblock 304075534[4:21fd30e] blockcount 1024 flag 0
> Dec 21 13:08:23 gtomds1 kernel: [ 2008.238639] xfs_bmap_extents_to_btree (0xffff88018de2c3c0) 14: startoff 7187 startblock NULLSTARTBLOCK(5) blockcount 2 flag 0
> Dec 21 13:08:23 gtomds1 kernel: [ 2008.238643] xfs_bmap_extents_to_btree (0xffff88018de2c3c0) 15: startoff 7189 startblock 304076560[4:21fd710] blockcount 1024 flag 0
> Dec 21 13:08:23 gtomds1 kernel: [ 2008.238647] xfs_bmap_extents_to_btree (0xffff88018de2c3c0) 16: startoff 8213 startblock NULLSTARTBLOCK(5) blockcount 2 flag 0
> Dec 21 13:08:23 gtomds1 kernel: [ 2008.238651] xfs_bmap_extents_to_btree (0xffff88018de2c3c0) 17: startoff 8215 startblock 304077586[4:21fdb12] blockcount 1024 flag 0
> Dec 21 13:08:23 gtomds1 kernel: [ 2008.238655] xfs_bmap_extents_to_btree (0xffff88018de2c3c0) 18: startoff 9239 startblock NULLSTARTBLOCK(79) blockcount 1 flag 0
> Dec 21 13:08:23 gtomds1 kernel: [ 2008.238659] xfs_bmap_extents_to_btree (0xffff88018de2c3c0) 19: startoff 9240 startblock 304078611[4:21fdf13] blockcount 512 flag 0
> Dec 21 13:08:23 gtomds1 kernel: [ 2008.238663] xfs_bmap_extents_to_btree (0xffff88018de2c3c0) 20: startoff 9752 startblock 0[0:0] blockcount 18408 flag 0		<---- we added an extent to the btree with startblock=0
> ....
> Dec 21 13:08:42 gtomds1 kernel: [ 2009.735411] xfs_bmap_add_extent_delay_real new br_startoff 9752 br_startblock 304079636 br_blockcount1      <---- and it turns out to be the same one we crash on later!

It's this pattern of alloc/delalloc extents that I'm having trouble
reproducing. The current TOT XFS code simply will not allocate the
middle part of a delalloc extent like this.  What exactly is your
test doing to produce this sort of pattern?  Also, delalloc
behaviour has changed over different versions, so can you tell me
what version of XFS you are running to cause this?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
