Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52908 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753693AbcI2HyR (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 29 Sep 2016 03:54:17 -0400
Date: Thu, 29 Sep 2016 15:54:14 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: BUG: Internal error xfs_trans_cancel at line 984 of file
 fs/xfs/xfs_trans.c
Message-ID: <20160929075414.GX27776@eguan.usersys.redhat.com>
References: <20160829103754.GH27776@eguan.usersys.redhat.com>
 <20160830023905.GU19025@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160830023905.GU19025@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com, linux-xfs@vger.kernel.org

On Tue, Aug 30, 2016 at 12:39:05PM +1000, Dave Chinner wrote:
> On Mon, Aug 29, 2016 at 06:37:54PM +0800, Eryu Guan wrote:
> > Hi,
> > 
> > I've hit an XFS internal error then filesystem shutdown with 4.8-rc3
> > kernel but not with 4.8-rc2
> .....
> > I attached a script too to reproduce it. Please note that the XFS
> > partition needs about 40G frees space, and it may take hours to finish
> > based on your memory setup on your host.
> 
> Ugh. can you try to narrow the cause so it takes less time to
> reproduce? This is almost certainly one of two things:
> 
> 	1) a ENOSPC issue where an AG is almost-but-not-quite full,
> 	but fixing up the freelist results in there being not enough
> 	blocks left to allocate the data extent; or
> 
> 	2) we've split a delalloc extent so many times that we've
> 	run out of indirect block reservation and we hit ENOSPC as a
> 	result.

[Sorry for getting back on this after so long time..]

> 
> For the latter, I suspect a test case where we take a large delalloc
> range and use sync_file_range to do single page writeback to "binary
> split" the delalloc range. i.e. start with a 128MB delalloc, then
> sync a 4k block at offset 64MB, then 4k at 32MB, then 16MB, then
> 8MB, ... all the way down to writing the first block in the file,
> and also all the way up to the final block in the file.
> 
> Then write every second 4k block to cause worse case growth of the
> bmbt and hopefully then exhaust the indirect block reservation for
> that delalloc region...

Seems it's only reproducible on certain hosts, and I haven't been able
to work out an efficient & reliable reproducer. I tried to tuned the
parameters of bash-shared-mapping run, but failed to find a efficient
parameter conbination. Also tried to write a script (attached, not sure
if it's correct) based on the second case above, but still cannot
reproduce it.

By adding debug logs, I got the following stack trace, it's
xfs_bmbt_alloc_block() returns first ENOSPC:

        if (!args.wasdel && args.tp->t_blk_res == 0) {
		error = -ENOSPC;
		goto error0;
	}

[  783.154400] xfs_bmbt_alloc_block: set -ENOSPC and returned                                                                                                                                  
[  783.183011] __xfs_btree_split: cur->bc_ops->alloc_block returned -28                                                                                                                        
[  783.214758] xfs_btree_split: workqueue result returned -28                                                                                                                                  
[  783.239319] xfs_btree_make_block_unfull: xfs_btree_split returned -28                                                                                                                       
[  783.268190] xfs_btree_insrec: xfs_btree_make_block_unfull returned -28                                                                                                                      
[  783.297550] xfs_btree_insert: xfs_btree_insrec returned -28                                                                                                                                 
[  783.322672] xfs_bmap_add_extent_hole_real: case 0 xfs_btree_insert returned -28                                                                                                             
[  783.355441] xfs_bmapi_allocate: xfs_bmap_add_extent_hole_real returned -28                                                                                                                  
[  783.386272] xfs_bmapi_write: xfs_bmapi_allocate returned -28                                                                                                                                
[  783.411332] xfs_iomap_write_allocate: goto trans_cancel after xfs_bmapi_write, error=-28

Not sure if this helps.

Thanks,
Eryu
