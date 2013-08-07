Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 823C17F4E
	for <xfs@oss.sgi.com>; Wed,  7 Aug 2013 15:19:21 -0500 (CDT)
Message-ID: <5202ABC5.30000@sgi.com>
Date: Wed, 07 Aug 2013 15:19:17 -0500
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
Cc: Boris Ranto <branto@redhat.com>, xfs-oss <xfs@oss.sgi.com>

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

Looks good. This does not harm the current version of the Linux 3.12 crc 
xfsprogs series at all. But we will wait for the weekly community phone 
call before any new commits.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
