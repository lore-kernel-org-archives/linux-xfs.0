Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id CAE6A29DFA
	for <xfs@oss.sgi.com>; Thu, 13 Jun 2013 14:16:20 -0500 (CDT)
Date: Thu, 13 Jun 2013 14:16:17 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 3/3] xfs: ensure btree root split sets blkno correctly
Message-ID: <20130613191617.GY20932@sgi.com>
References: <1371003548-4026-1-git-send-email-david@fromorbit.com>
	<1371003548-4026-4-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1371003548-4026-4-git-send-email-david@fromorbit.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Wed, Jun 12, 2013 at 12:19:08PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> For CRC enabled filesystems, the BMBT is rooted in an inode, so it
> passes through a difference code path on root splits to the
		   different			       than

> freespace and inode btrees. This is much less traversed by xfstests
> than the other trees. When testing on a 1k block size filesystem,
> I've been seeing ASSERT failures in generic/234 like:
> 
> XFS: Assertion failed: cur->bc_btnum != XFS_BTNUM_BMAP || cur->bc_private.b.allocated == 0, file: fs/xfs/xfs_btree.c, line: 317
> 
> which are generally preceded by a lblock check failure. I noticed
> this in the bmbt stats:
> 
> $ pminfo -f xfs.btree.block_map
> 
> xfs.btree.block_map.lookup
>     value 39135
> 
> xfs.btree.block_map.compare
>     value 268432
> 
> xfs.btree.block_map.insrec
>     value 15786
> 
> xfs.btree.block_map.delrec
>     value 13884
> 
> xfs.btree.block_map.newroot
>     value 2
> 
> xfs.btree.block_map.killroot
>     value 0
> .....
> 
> Very little coverage of root splits and merges. Indeed, on a 4k
> filesystem, block_map.newroot and block_map.killroot are both zero.
> i.e the code is not exercised at all, and it's the only generic
     .
> btree infrastruct operation that is not exercised by a default run
	infrastructure 

Cleaned those up.

> of xfstests.
> 
> Turns out that on a 1k filesystem, generic/234 accounts for one of
> those two root splits, and that is somewhat of a smoking gun. In
> fact, it's the same problem we saw in the directory/attr code where
> headers are memcpy()d from one block to another without updating the
> self describing metadata.

It is very interesting that this area of code is exercised so infrequently.  I
remember seeing a paper that described a tool that would list codepaths that
are exercised during a test run.  Does that ring a bell?  It seems like this
might be worth looking into more generally.

> Simple fix - when copying the header out of the root block, make
> sure the block number is updated correctly.

Yep, looks fine.

> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Reviewed-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
