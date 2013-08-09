Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id CEBF97F9C
	for <xfs@oss.sgi.com>; Fri,  9 Aug 2013 08:34:44 -0500 (CDT)
Message-ID: <5204EFF0.1090402@sgi.com>
Date: Fri, 09 Aug 2013 08:34:40 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] mkfs.xfs: fix protofile name create block reservation
References: <5201E28B.1050800@redhat.com>
In-Reply-To: <5201E28B.1050800@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On 08/07/13 01:00, Eric Sandeen wrote:
> A large protofile which creates a large directory and requires
> a a dir tree split, can fail:
>
>    mkfs.xfs: directory createname error [28 - No space left on device]
>
> This is because when we've split a block once, we decrement args->total:
> (see kernel commit a7444053fb3ebd3d905e3c7a7bd5ea80a54b083a for the
> rationale)
>
>         /* account for newly allocated blocks in reserved blocks total */
>         args->total -= dp->i_d.di_nblocks - nblks;
>
> but every call into this path from proto file parsing started
> reserved / args->total as only "1" as passed tro newdirent() -
> so if we allocate a block, args->total hits 0, and then in
> xfs_dir2_node_addname():
>
>          /*
>           * Add the new leaf entry.
>           */
>          rval = xfs_dir2_leafn_add(blk->bp, args, blk->index);
>          if (rval == 0) {
> 		...
>          } else {
>                  /*
>                   * It didn't work, we need to split the leaf block.
>                   */
>                  if (args->total == 0) {
>                          ASSERT(rval == ENOSPC);
>                          goto done;
>                  }
>                  /*
>                   * Split the leaf block and insert the new entry.
>                   */
>
> we hit the args->total == 0 special case, and don't do the next
> split, and ENOSPC gets returned all the way up, and we fail.
>
> So rather than calling newdirent with a total of "1" in every case,
> which doesn't account for possible tree splits, we should call it
> with a more appropriate value: XFS_DIRENTER_SPACE_RES(mp, name->len),
> which will handle the maximum nr of block allocations that might be
> needed during a directory entry insert.
>
> Since the reservation required doesn't depend on entry type,
> just push this down a level, into newdirent() itself.
>
> Reported-by: Boris Ranto<branto@redhat.com>
> Signed-off-by: Eric Sandeen<sandeen@redhat.com>
> ---

This patches and the Coverity xfsprog patches have been commited to the 
master branch:

commit 312592defb8b6051389a56a5c780819b4239dab4
Author: Eric Sandeen <sandeen@redhat.com>
Date:   Thu Aug 1 01:13:10 2013 +0000

     xfsprogs: fix unint var in repair phase6

commit aba29588f81dad52129037c15fe584ec89b36a4f
Author: Eric Sandeen <sandeen@sandeen.net>
Date:   Thu Aug 1 02:25:18 2013 +0000

     xfsprogs: fix agcnts leak in xfs_repair's scan_ags

commit dc93954aa6f13963bcc87fc00ce55a4745dc7b93
Author: Eric Sandeen <sandeen@redhat.com>
Date:   Thu Aug 1 01:33:47 2013 +0000

     xfsprogs:free bp in xlog_find_tail() error path

commit 4623d1041dd34d73aeab4b51002fc9ca6d543415
Author: Eric Sandeen <sandeen@redhat.com>
Date:   Thu Aug 1 01:32:30 2013 +0000

     xfsprogs: free bp in xlog_find_zeroed() error path

commit a134873e2903837bdbeab261b6d0ceee2fd499ba
Author: Eric Sandeen <sandeen@redhat.com>
Date:   Thu Aug 1 01:42:58 2013 +0000

     xfsprogs: fix buffer leak in xlog_print_find_oldest

commit 504dbe46549d462e79565514d86ce69b74b96893
Author: Eric Sandeen <sandeen@redhat.com>
Date:   Thu Aug 1 01:18:54 2013 +0000

     xfsprogs: avoid double-free in xfs_attr_node_addname

commit 1b6bf714a7179942b8523cc966124249b74381da
Author: Eric Sandeen <sandeen@redhat.com>
Date:   Wed Aug 7 06:00:43 2013 +0000

     mkfs.xfs: fix protofile name create block reservation


None collide with the for Linux 3.12 kernel/user sync series.

The kernel patches should make Linux 3.12.

--Mark.


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
