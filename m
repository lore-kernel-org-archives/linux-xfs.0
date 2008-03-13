Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 13 Mar 2008 07:53:39 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m2DErQ0G030326
	for <xfs@oss.sgi.com>; Thu, 13 Mar 2008 07:53:30 -0700
Date: Fri, 14 Mar 2008 01:53:49 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: XFS internal error xfs_trans_cancel at line 1150 of file fs/xfs/xfs_trans.c
Message-ID: <20080313145349.GJ95344431@sgi.com>
References: <20080311122103.GP155407@sgi.com> <1a4a774c0803110539s129fd2am86e933a03cdd1b18@mail.gmail.com> <20080312232425.GR155407@sgi.com> <1a4a774c0803130114l3927051byd54cd96cdb0efbe7@mail.gmail.com> <20080313090830.GD95344431@sgi.com> <1a4a774c0803130214x406a4eb9wfb8738d1f503663f@mail.gmail.com> <20080313092139.GF95344431@sgi.com> <1a4a774c0803130227l2fdf4861v21183b9bd3e7ce8d@mail.gmail.com> <20080313113634.GH95344431@sgi.com> <1a4a774c0803130446x609b9cb2mf3da323183c35606@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1a4a774c0803130446x609b9cb2mf3da323183c35606@mail.gmail.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christian =?iso-8859-1?Q?R=F8snes?= <christian.rosnes@gmail.com>
Cc: xfs@oss.sgi.com

ok..... loads the metadump...

Looking at the AGF status before the mkdir:

dgc@budgie:/mnt/test$ for i in `seq 0 1 15`; do echo AG $i ; sudo xfs_db -r -c "agf $i" -c 'p flcount longest' -f /mnt/scratch/shutdown; done
AG 0
flcount = 6
longest = 8
AG 1
flcount = 6
longest = 8
AG 2
flcount = 6
longest = 7
AG 3
flcount = 6
longest = 7
AG 4
flcount = 6
longest = 7
AG 5
flcount = 7
longest = 8
....

AG 5 immediately caught my eye:

seqno = 5
length = 4476752
bnoroot = 7
cntroot = 46124
bnolevel = 2
cntlevel = 2
flfirst = 56
fllast = 62
flcount = 7
freeblks = 68797
longest = 8
btreeblks = 0
magicnum = 0x58414746
versionnum = 1


Mainly because at level 2 btrees this:

	blocks = XFS_MIN_FREELIST_PAG(pag,mp);

gives blocks = 6 and the freelist count says 7 blocks.
hence if the alignment check fails in some way, it will
try to reduce the free list down to 6 blocks. Unsurprisingly,
then, this breakpoint (what function does every "log object"
operation call?) eventually tripped:

Stack traceback for pid 2936
0xe000003817440000     2936     2902  1    1   R  0xe0000038174403a0 *mkdir
0xa0000001003c3cc0 xfs_trans_find_item
0xa0000001003c0d10 xfs_trans_log_buf+0x2f0
0xa0000001002f81e0 xfs_alloc_log_agf+0x80
0xa0000001002fa3d0 xfs_alloc_get_freelist+0x3d0
0xa0000001002ffe90 xfs_alloc_fix_freelist+0x770
0xa000000100300a00 xfs_alloc_vextent+0x440
0xa000000100374d70 xfs_ialloc_ag_alloc+0x2d0
0xa000000100375dd0 xfs_dialloc+0x2d0
.......

Which is the first place we dirty a log item. It's the
AGF of block 5:

[1]kdb> xbuf 0xe0000038143e2e00
buf 0xe0000038143e2e00 agf 0xe000003817550200
magicnum 0x58414746 versionnum 0x1 seqno 0x5 length 0x444f50
roots b 0x7 c 0xb42c levels b 2 c 2
flfirst 57 fllast 62 flcount 6 freeblks 68797 longest 8

And you'll note that flcount = 6 and flfirst = 57 now. In memory:

[1]kdb> xperag 0xe000003802979510
.....
ag 5 f_init 1 i_init 1
    f_levels[b,c] 2,2 f_flcount 6 f_freeblks 68797 f_longest 8
    f__metadata 0
    i_freecount 0 i_inodeok 1
.....

f_flcount = 6 as well. So, we've really modified the AGF here,
and find out why the alignement checks failed.

[1]kdb> xalloc 0xe00000381744fc48
tp 0xe000003817450000 mp 0xe000003802979510 agbp 0x0000000000020024 pag 0xe000003802972378 fsbno 42563856[5:97910]
agno 0x5 agbno 0xffffffff minlen 0x8 maxlen 0x8 mod 0x0
prod 0x1 minleft 0x0 total 0x0 alignment 0x1
minalignslop 0x0 len 0x0 type this_bno otype this_bno wasdel 0
wasfromfl 0 isfl 0 userdata 0

Oh - alignment = 1. How did that happen? And why did it fail?  I
note: "this_bno" means it wants an exact allocation (fsbno
42563856[5:97910]).  Ah, that means we are in the first attmpt to
allocate a block in an AG. i.e here:

    153         /*
    154          * First try to allocate inodes contiguous with the last-allocated
    155          * chunk of inodes.  If the filesystem is striped, this will fill
    156          * an entire stripe unit with inodes.
    157          */
    158         agi = XFS_BUF_TO_AGI(agbp);
    159         newino = be32_to_cpu(agi->agi_newino);
    160         args.agbno = XFS_AGINO_TO_AGBNO(args.mp, newino) +
    161                         XFS_IALLOC_BLOCKS(args.mp);
    162         if (likely(newino != NULLAGINO &&
    163                   (args.agbno < be32_to_cpu(agi->agi_length)))) {
    164                 args.fsbno = XFS_AGB_TO_FSB(args.mp,
    165                                 be32_to_cpu(agi->agi_seqno), args.agbno);
    166                 args.type = XFS_ALLOCTYPE_THIS_BNO;
    167                 args.mod = args.total = args.wasdel = args.isfl =
    168                         args.userdata = args.minalignslop = 0;
    169   >>>>>>>>      args.prod = 1;
    170   >>>>>>>>      args.alignment = 1;
    171                 /*
    172                  * Allow space for the inode btree to split.
    173                  */
    174                 args.minleft = XFS_IN_MAXLEVELS(args.mp) - 1;
    175   >>>>>>>>      if ((error = xfs_alloc_vextent(&args)))
    176                         return error;


This now makes sense - at first we attempt an unaligned, exact block
allocation. This gets us to modifying the free list because we have
a free 8 block extent as required. However, the exact extent being
asked for is not free, so the btree lookup fails and we abort the
allocation attempt.

We then fall back to method 2 - try stripe alignment - which now
fails the longest free block checks because alignment is accounted
for and we need ~24 blocks to make sure of this.

We fall back to method 3 - cluster alignment - which also fails
because we need a extent of 9 blocks, but we only have extents of
8 blocks available.

We never try again without alignment....

Now we fail allocation in that AG having dirtied the AGF, the AGFL,
and a block out of both the by-size and by-count free space btrees.
Hence when we fail to allocate in all other AGs, we return ENOSPC
and the transaction get cancelled. Because it has dirty items
in it, we get shut down.

But no wonder it was so hard to reproduce....

The patch below fixes the shutdown for me. Can you give it a go?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group


---
 fs/xfs/xfs_ialloc.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

Index: 2.6.x-xfs-new/fs/xfs/xfs_ialloc.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_ialloc.c	2008-03-13 13:07:24.000000000 +1100
+++ 2.6.x-xfs-new/fs/xfs/xfs_ialloc.c	2008-03-14 01:40:21.926153338 +1100
@@ -167,7 +167,12 @@ xfs_ialloc_ag_alloc(
 		args.mod = args.total = args.wasdel = args.isfl =
 			args.userdata = args.minalignslop = 0;
 		args.prod = 1;
-		args.alignment = 1;
+		if (xfs_sb_version_hasalign(&args.mp->m_sb) &&
+			args.mp->m_sb.sb_inoalignmt >=
+			XFS_B_TO_FSBT(args.mp, XFS_INODE_CLUSTER_SIZE(args.mp)))
+				args.alignment = args.mp->m_sb.sb_inoalignmt;
+		else
+			args.alignment = 1;
 		/*
 		 * Allow space for the inode btree to split.
 		 */
