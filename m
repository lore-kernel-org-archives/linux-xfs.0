Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8MHN6Ou073702 for <xfs@oss.sgi.com>; Wed, 22 Sep 2010 12:23:07 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6A310183C63A
	for <xfs@oss.sgi.com>; Wed, 22 Sep 2010 10:24:01 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id JsVrIsmH2UYzQDuA for
	<xfs@oss.sgi.com>; Wed, 22 Sep 2010 10:24:01 -0700 (PDT)
Date: Wed, 22 Sep 2010 13:24:01 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 04/16] xfs: don't use vfs writeback for pure metadata
	modifications
Message-ID: <20100922172401.GB5697@infradead.org>
References: <1285137869-10310-1-git-send-email-david@fromorbit.com>
	<1285137869-10310-5-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1285137869-10310-5-git-send-email-david@fromorbit.com>
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
Cc: xfs@oss.sgi.com

> However, the timstamp changes are slightly more complex than this -
> there are a couple of places that do unlogged updates of the
> timestamps, and the VFS need to be informed of these. Hence add a
> new function xfs_trans_inode_chgtime() for transactional changes,
> and leave xfs_ichgtime() for the non-transactional changes.

The only user of xfs_ichgtime after this patch is a special case in
truncate for the case of a zero-sized file that's also truncated to size
zero.  I think we should just remove this special case and not require
xfs_ichgtime at all.  I'll prepare patches to clean up xfs_setattr
and remove this non-transaction update and once this patch is rebased
ontop of that it can be simplied again.

That leaves the timestamp updates from the data I/O path special as
they still get updated via direct writes to inode->i_*time and
mark_inode_dirty.  I guess we'll have to live with that for now.


> + * Transactional inode timestamp update. requires inod to be locked and joined
> + * to the transaction supplied. Relies on the transaction subsystem to track
> + * dirty state and update/writeback the inode accordingly.

s/inod/the inode/

Also I wonder if xfs_trans_ichgtime should be in xfs_trans_inode.c with
a prototype in xfs_trans.h, just like all the other xfs_trans*
functions.

>  	/*
> +	 * Hit the inode change time.
> +	 */

All these comments are utterly pointless.  I'd suggest removing them
when touching the surrounding areas.

> +++ b/fs/xfs/xfs_inode_item.c
> @@ -223,15 +223,6 @@ xfs_inode_item_format(
>  	nvecs	     = 1;
>  
>  	/*
> -	 * Make sure the linux inode is dirty. We do this before
> -	 * clearing i_update_core as the VFS will call back into
> -	 * XFS here and set i_update_core, so we need to dirty the
> -	 * inode first so that the ordering of i_update_core and
> -	 * unlogged modifications still works as described below.
> -	 */
> -	xfs_mark_inode_dirty_sync(ip);
> -

With this gone the comment above xfs_fs_dirty_inode will need an update.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
