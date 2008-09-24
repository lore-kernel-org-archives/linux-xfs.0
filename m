Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 23 Sep 2008 19:48:26 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8O2mM8E029251
	for <xfs@oss.sgi.com>; Tue, 23 Sep 2008 19:48:23 -0700
Received: from idcmail-mo1so.shaw.ca (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C1CC9474FA6
	for <xfs@oss.sgi.com>; Tue, 23 Sep 2008 19:49:56 -0700 (PDT)
Received: from idcmail-mo1so.shaw.ca (idcmail-mo1so.shaw.ca [24.71.223.10]) by cuda.sgi.com with ESMTP id evtqrczFlYBS6rwn for <xfs@oss.sgi.com>; Tue, 23 Sep 2008 19:49:56 -0700 (PDT)
Message-ID: <54321.24.80.224.145.1222224594.squirrel@squirrel.kevinjamieson.com>
In-Reply-To: <20080923091811.GE5448@disturbed>
References: <48D6A0AD.3040307@kevinjamieson.com>
    <20080923091811.GE5448@disturbed>
Date: Tue, 23 Sep 2008 19:49:54 -0700 (PDT)
Subject: Re: XFS internal error xfs_trans_cancel at line 1138 of file
     fs/xfs/xfs_trans.c
From: "Kevin Jamieson" <kevin@kevinjamieson.com>
Reply-To: kevin@kevinjamieson.com
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Tue, September 23, 2008 2:18 am, Dave Chinner wrote:

> A metadump will tell us what the freespace patterns are....

I should be able to get a metadump for you soon, just waiting for approval
from management (sigh).


> I'm inclined to think that the free space is in an AG we can't
> currently allocate out of because of previous allocations for
> other blocks needed by the split....

Adding some debug messages (this is with the latest oss.sgi.com CVS
kernel) into xfs_alloc_vextent() and xfs_alloc_fix_freelist() shows the
following allocations for the create transaction, all in AG 9 which has
only 40 free blocks:

kernel: XFS: ENTER function xfs_alloc_vextent file fs/xfs/xfs_alloc.c line
2285 agno 9 type 4 called from:
kernel:  [<f951f5c0>] xfs_alloc_vextent+0xe4/0x520 [xfs]
kernel:  [<f952fe4f>] xfs_bmap_btalloc+0x791/0xa80 [xfs]
kernel:  [<f9530b2f>] xfs_bmapi+0x9cf/0x148c [xfs]
kernel:  [<f95372bd>] xfs_da_grow_inode+0xe6/0x2a1 [xfs]
kernel:  [<f954009a>] xfs_dir2_leafn_split+0x29/0x27f [xfs]
kernel:  [<f9539419>] xfs_da_split+0xc2/0x236 [xfs]
kernel:  [<f953f55b>] xfs_dir2_node_addname+0x845/0x8ae [xfs]
kernel:  [<f95646ca>] kmem_zone_alloc+0x46/0x8a [xfs]
kernel:  [<f956472b>] kmem_zone_zalloc+0x1d/0x41 [xfs]
kernel:  [<f953a149>] xfs_dir_createname+0x12c/0x13a [xfs]
kernel:  [<f9561447>] xfs_create+0x2d9/0x4e6 [xfs]
kernel:  =======================
kernel: XFS: function xfs_alloc_fix_freelist file fs/xfs/xfs_alloc.c line
1855 agno 9 minlen 1 alignment 1 minalignslop 0 longest 10 minleft 1
pagf_freeblks 36 pagf_flcount 4 need 4 total 35
kernel: XFS: EXIT function xfs_alloc_vextent file fs/xfs/xfs_alloc.c line
2454 fsbno 76102855


kernel: XFS: ENTER function xfs_alloc_vextent file fs/xfs/xfs_alloc.c line
2285 agno 9 type 5 called from:
kernel:  [<f951f5c0>] xfs_alloc_vextent+0xe4/0x520 [xfs]
kernel:  [<f952aeb3>] xfs_bmap_extents_to_btree+0x26d/0x4eb [xfs]
kernel:  [<f95490e6>] xfs_iext_add+0xe0/0x213 [xfs]
kernel:  [<f952d10d>] xfs_bmap_add_extent+0x338/0x3cb [xfs]
kernel:  [<f9530d50>] xfs_bmapi+0xbf0/0x148c [xfs]
kernel:  [<f95372bd>] xfs_da_grow_inode+0xe6/0x2a1 [xfs]
kernel:  [<f954009a>] xfs_dir2_leafn_split+0x29/0x27f [xfs]
kernel:  [<f9539419>] xfs_da_split+0xc2/0x236 [xfs]
kernel:  [<f953f55b>] xfs_dir2_node_addname+0x845/0x8ae [xfs]
kernel:  [<f95646ca>] kmem_zone_alloc+0x46/0x8a [xfs]
kernel:  [<f956472b>] kmem_zone_zalloc+0x1d/0x41 [xfs]
kernel:  [<f953a149>] xfs_dir_createname+0x12c/0x13a [xfs]
kernel:  [<f9561447>] xfs_create+0x2d9/0x4e6 [xfs]
kernel:  =======================
kernel: XFS: function xfs_alloc_fix_freelist file fs/xfs/xfs_alloc.c line
1855 agno 9 minlen 1 alignment 1 minalignslop 0 longest 10 minleft 0
pagf_freeblks 35 pagf_flcount 4 need 4 total 0
kernel: XFS: EXIT function xfs_alloc_vextent file fs/xfs/xfs_alloc.c line
2454 fsbno 76103705


kernel: XFS: ENTER function xfs_alloc_vextent file fs/xfs/xfs_alloc.c line
2285 agno 9 type 5 called from:
kernel:  [<f951f5c0>] xfs_alloc_vextent+0xe4/0x520 [xfs]
kernel:  [<c0132a98>] up+0x9/0x2a
kernel:  [<f952fe4f>] xfs_bmap_btalloc+0x791/0xa80 [xfs]
kernel:  [<f952d10d>] xfs_bmap_add_extent+0x338/0x3cb [xfs]
kernel:  [<f95485e3>] xfs_iext_bno_to_ext+0xd8/0x191 [xfs]
kernel:  [<f9530b2f>] xfs_bmapi+0x9cf/0x148c [xfs]
kernel:  [<f956713f>] _xfs_buf_lookup_pages+0x25e/0x285 [xfs]
kernel:  [<f95372bd>] xfs_da_grow_inode+0xe6/0x2a1 [xfs]
kernel:  [<f953ed09>] xfs_dir2_leafn_add+0x29c/0x2a9 [xfs]
kernel:  [<f953c7c7>] xfs_dir2_leaf_log_header+0x9/0xb [xfs]
kernel:  [<f9538df4>] xfs_da_root_split+0x1d/0x15e [xfs]
kernel:  [<f953756e>] xfs_da_fixhashpath+0x4c/0xbe [xfs]
kernel:  [<f95394ba>] xfs_da_split+0x163/0x236 [xfs]
kernel:  [<f953f55b>] xfs_dir2_node_addname+0x845/0x8ae [xfs]
kernel:  [<f95646ca>] kmem_zone_alloc+0x46/0x8a [xfs]
kernel:  [<f956472b>] kmem_zone_zalloc+0x1d/0x41 [xfs]
kernel:  [<f953a149>] xfs_dir_createname+0x12c/0x13a [xfs]
kernel:  [<f9561447>] xfs_create+0x2d9/0x4e6 [xfs]
kernel:  =======================
kernel: XFS: function xfs_alloc_fix_freelist file fs/xfs/xfs_alloc.c line
1855 agno 9 minlen 1 alignment 1 minalignslop 0 longest 10 minleft 0
pagf_freeblks 34 pagf_flcount 4 need 4 total 35
kernel: XFS: EXIT function xfs_alloc_vextent file fs/xfs/xfs_alloc.c line
2454 fsbno -1


So this last allocation is failing this test in xfs_alloc_fix_freelist()
and not allocating anything:

        /*
         * If it looks like there isn't a long enough extent, or enough
         * total blocks, reject it.
         */
        if ((args->minlen + args->alignment + args->minalignslop - 1) >
                longest ||
            ((int)(pag->pagf_freeblks + pag->pagf_flcount -
               need - args->total) < (int)args->minleft)) {
            if (agbp)
                xfs_trans_brelse(tp, agbp);
            args->agbp = NULL;
            return 0;


Thanks for your help,
Kevin Jamieson
