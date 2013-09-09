Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 48F1A7F55
	for <xfs@oss.sgi.com>; Mon,  9 Sep 2013 15:32:55 -0500 (CDT)
Message-ID: <522E3073.2080501@sgi.com>
Date: Mon, 09 Sep 2013 15:32:51 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 1/2] xfs: swap extents operations for CRC filesystems
References: <1377822225-17621-1-git-send-email-david@fromorbit.com>
	<1377822225-17621-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1377822225-17621-2-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 08/29/13 19:23, Dave Chinner wrote:
> From: Dave Chinner<dchinner@redhat.com>
>
> For CRC enabled filesystems, we can't just swap inode forks from one
> inode to another when defragmenting a file - the blocks in the inode
> fork bmap btree contain pointers back to the owner inode. Hence if
> we are to swap the inode forks we have to atomically modify every
> block in the btree during the transaction.
>
> We are doing an entire fork swap here, so we could create a new
> transaction item type that indicates we are changing the owner of a
> certain structure from one value to another. If we combine this with
> ordered buffer logging to modify all the buffers in the tree, then
> we can change the buffers in the tree without needing log space for
> the operation. However, this then requires log recovery to perform
> the modification of the owner information of the objects/structures
> in question.
>
> This does introduce some interesting ordering details into recovery:
> we have to make sure that the owner change replay occurs after the
> change that moves the objects is made, not before. Hence we can't
> use a separate log item for this as we have no guarantee of strict
> ordering between multiple items in the log due to the relogging
> action of asynchronous transaction commits. Hence there is no
> "generic" method we can use for changing the ownership of arbitrary
> metadata structures.
>
> For inode forks, however, there is a simple method of communicating
> that the fork contents need the owner rewritten - we can pass a
> inode log format flag for the fork for the transaction that does a
> fork swap. This flag will then follow the inode fork through
> relogging actions so when the swap actually gets replayed the
> ownership can be changed immediately by log recovery.  So that gives
> us a simple method of "whole fork" exchange between two inodes.
>
> This is relatively simple to implement, so it makes sense to do this
> as an initial implementation to support xfs_fsr on CRC enabled
> filesytems in the same manner as we do on existing filesystems. This
> commit introduces the swapext driven functionality, the recovery
> functionality will be in a separate patch.
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---

Makes sense. Change owner in btree entry, Don't log the modified btree 
buffers but recreate in recovery when necessary.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
