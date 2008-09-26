Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 26 Sep 2008 03:14:32 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8QAETLn014194
	for <xfs@oss.sgi.com>; Fri, 26 Sep 2008 03:14:29 -0700
Received: from ipmail04.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 267734873EC
	for <xfs@oss.sgi.com>; Fri, 26 Sep 2008 03:16:03 -0700 (PDT)
Received: from ipmail04.adl2.internode.on.net (ipmail04.adl2.internode.on.net [203.16.214.57]) by cuda.sgi.com with ESMTP id Swo0aGeTANvY4Gxw for <xfs@oss.sgi.com>; Fri, 26 Sep 2008 03:16:03 -0700 (PDT)
Date: Fri, 26 Sep 2008 20:16:00 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS internal error xfs_trans_cancel at line 1138 of file
	fs/xfs/xfs_trans.c
Message-ID: <20080926101600.GO27997@disturbed>
References: <48D6A0AD.3040307@kevinjamieson.com> <20080923091811.GE5448@disturbed> <54241.24.80.224.145.1222383385.squirrel@squirrel.kevinjamieson.com> <20080926012704.GI27997@disturbed> <62255.192.168.1.1.1222403942.squirrel@squirrel.kevinjamieson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <62255.192.168.1.1.1222403942.squirrel@squirrel.kevinjamieson.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Kevin Jamieson <kevin@kevinjamieson.com>
Cc: Mark Goodwin <markgw@sgi.com>, xfs@oss.sgi.com

On Thu, Sep 25, 2008 at 09:39:02PM -0700, Kevin Jamieson wrote:
> On Thu, September 25, 2008 6:27 pm, Dave Chinner wrote:
> > On Thu, Sep 25, 2008 at 03:56:25PM -0700, Kevin Jamieson wrote:
> >> On Tue, September 23, 2008 2:18 am, Dave Chinner wrote:
> >>
> >> > A metadump will tell us what the freespace patterns are....
> >>
> >> Hi Dave,
> >>
> >> A metadump of a file system that triggers this issue is now available on

Cc'įng this back to the open list because there have been several
other occurrences of this problem recently, so I want this to
hit the public archives.

Firstly, Kevinn, thank you for the image and the trivial test case.
This is exactly how I found the last one of these problems - 20
minutes with UML and single stepping through gdb....

Breakpoint 5, xfs_dir_createname (tp=0x7f3bba18, dp=0x7f4b90c0,
	name=0x7f273c30, inum=308318065,
	first=0x7f273bc0, flist=0x7f273b90, total=35) at fs/xfs/xfs_dir2.c:207

We have a reservation of 35 blocks for this operation.

	xfs_dir_createname()
	  xfs_dir2_node_addname()
		xfs_dir2_node_addname_int()	- adds new block,
		xfs_dir2_leafn_add() 	- full block, no stale
		xfs_da_split()
		  xfs_dir2_leafn_split() - single block allocated out of AG 9
		    xfs_da_grow_inode()
		xfs_da_root_split()
		    xfs_da_grow_inode() - fails to allocate single block

Allocation fails with AG 9 having 34 free blocks and it does not
try any other AG. Now to trace the second xfs_bmapi call to see why
it fails.

	xfs_bmapi()
	  xfs_bmap_alloc()
(gdb) p *ap
$26 = {firstblock = 83559978, rval = 1612378431, off = 8388610, tp = 0x7f14da18,
  ip = 0x7f4ba0c0, prevp = 0x7f0c7790, gotp = 0x7f0c77b0, alen = 1, total = 35,
  minlen = 1, minleft = 0, eof = 0 '\0', wasdel = 0 '\0', userdata = 0 '\0',
  low = 0 '\0', aeof = 0 '\0', conv = 0 '\0'}

	  xfs_bmap_btalloc()
	    xfs_alloc_vextent()
(gdb) p *args
$30 = {tp = 0x7f14da18, mp = 0x7f12f800, agbp = 0x7f0c77f4, pag = 0x7f595e80, fsbno = 83559979,
  agno = 9, agbno = 0, minlen = 1, maxlen = 1, mod = 0, prod = 1, minleft = 0,
  total = 35, alignment = 1, minalignslop = 0, len = 2131523184, type = XFS_ALLOCTYPE_NEAR_BNO,
  otype = 1612065600, wasdel = 0 '\0', wasfromfl = 0 '\0', isfl = 0 '\0', userdata = 0 '\0',
  firstblock = 83559978}

		xfs_alloc_fix_freelist()

1842         if (!(flags & XFS_ALLOC_FLAG_FREEING)) {
1843                 need = XFS_MIN_FREELIST_PAG(pag, mp);
1844                 delta = need > pag->pagf_flcount ? need - pag->pagf_flcount : 0;
1845                 /*
1846                  * If it looks like there isn't a long enough extent, or enough
1847                  * total blocks, reject it.
1848                  */
1849                 longest = (pag->pagf_longest > delta) ?
1850                         (pag->pagf_longest - delta) :
1851                         (pag->pagf_flcount > 0 || pag->pagf_longest > 0);
1852                 if ((args->minlen + args->alignment + args->minalignslop - 1) >
1853                                 longest ||
1854 >>>>>>>             ((int)(pag->pagf_freeblks + pag->pagf_flcount -
1855 >>>>>>>                    need - args->total) < (int)args->minleft)) {
1856                         if (agbp)
1857                                 xfs_trans_brelse(tp, agbp);
1858 >>>>>>>                 args->agbp = NULL;
1859 >>>>>>>                 return 0;
1860                 }
1861         }


We are failing the marked check.

	pag->pagf_freeblks + pag->pagf_flcount - need - args->total = -1.

and

	args->minleft = 0

The problem is that AG 9 has only 34 free blocks left when the root
split occurs.

So, what has happened is this:

	- transaction block reservation is for 35 blocks
	- directory located in AG 9
	- AG 9 has 35 free blocks.
	- we've allocated a new block in the directory for the name
		- allocation set up with args->total = 35
		- single block allocated reduces AG 9 to 34 free blocks
	- node is full, so can't add pointer to new free block
		- triggers root split
	- root split tries to allocate new block with:
		- allocation set up with args->total = 35
		- AG 9 only has 34 free blocks now.
		- fails with not enough space for "entire transaction"
		  in the AG.

Hence an ENOSPC with plenty of space left in the AG and huge
amounts of free space in the filesystem, and a shutdown because we
are cancelling a dirty transaction.

There's several problems here.

	1. the directory code does not account for blocks that get allocated
	   by reducing args->total as blocks are allocated. That directly
	   causes this particular shutdown.

	2. the xfs bmap code has no way of passing back how many blocks
	   were allocated to the inode. We're going to have to infer it
	   from the number of reserved blocks used in the transaction
	   structure or from the change in the inode block count
	   across the allocation....

	3. we're going to have to audit and fix all the allocation
	   calls in the directory code to ensure the accounting is
	   correct.

	4. the check in xfs_alloc_fix_freelist() is incorrect.
		- it assumes that we can completely empty the AG
		- we must leave 4 blocks behind in the AG so that the
		  first extent free on a full AG can succeed.
		- hence even if we fix 1), this case could still fail
		  once we get to 32 of 35 blocks allocated.

	5. The metadata allocation is a XFS_ALLOCTYPE_NEAR_BNO
	   allocation with no fallback if the AG is ENOSPC - if we
	   can't allocate in that AG, we fail. Why isn't there a
	   fallback in this case? Directory btree blocks are not
	   confined to a single AG, right?

This is going to take a bit of work to fix....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
