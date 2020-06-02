Return-Path: <SRS0=pQq2=7P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D13B7C433E0
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Jun 2020 16:34:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A521220738
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Jun 2020 16:34:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FvOwa5O7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726112AbgFBQew (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Jun 2020 12:34:52 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:20022 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725940AbgFBQew (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Jun 2020 12:34:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591115689;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BFbanCwuINPl5zlqED3KeA1X4U5o/RpgDriFD4L8yiE=;
        b=FvOwa5O7rTGncRRsk3z4lbbu04K8bR7SwlSuGBhPripWU3oPIylLkVw5m/pEP80H4HKITO
        nlbiJJtMaulfb70NocbNGbVx8q9KL+IINgJOWzwS3EuQmwjv1TVQVdl8XktDYUyzgbVf61
        L8t8aU8b6pHh/bJs9XncT1URYIyfcMA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-299-NSMiu7E3PKmAX0ALRZ7g7A-1; Tue, 02 Jun 2020 12:34:48 -0400
X-MC-Unique: NSMiu7E3PKmAX0ALRZ7g7A-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0EB351009600;
        Tue,  2 Jun 2020 16:34:47 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 951F4121A2E;
        Tue,  2 Jun 2020 16:34:46 +0000 (UTC)
Date:   Tue, 2 Jun 2020 12:34:44 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/30] xfs: add an inode item lock
Message-ID: <20200602163444.GC7967@bfoster>
References: <20200601214251.4167140-1-david@fromorbit.com>
 <20200601214251.4167140-4-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200601214251.4167140-4-david@fromorbit.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 02, 2020 at 07:42:24AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The inode log item is kind of special in that it can be aggregating
> new changes in memory at the same time time existing changes are
> being written back to disk. This means there are fields in the log
> item that are accessed concurrently from contexts that don't share
> any locking at all.
> 
> e.g. updating ili_last_fields occurs at flush time under the
> ILOCK_EXCL and flush lock at flush time, under the flush lock at IO
> completion time, and is read under the ILOCK_EXCL when the inode is
> logged.  Hence there is no actual serialisation between reading the
> field during logging of the inode in transactions vs clearing the
> field in IO completion.
> 
> We currently get away with this by the fact that we are only
> clearing fields in IO completion, and nothing bad happens if we
> accidentally log more of the inode than we actually modify. Worst
> case is we consume a tiny bit more memory and log bandwidth.
> 
> However, if we want to do more complex state manipulations on the
> log item that requires updates at all three of these potential
> locations, we need to have some mechanism of serialising those
> operations. To do this, introduce a spinlock into the log item to
> serialise internal state.
> 
> This could be done via the xfs_inode i_flags_lock, but this then
> leads to potential lock inversion issues where inode flag updates
> need to occur inside locks that best nest inside the inode log item
> locks (e.g. marking inodes stale during inode cluster freeing).
> Using a separate spinlock avoids these sorts of problems and
> simplifies future code.
> 
> This does not touch the use of ili_fields in the item formatting
> code - that is entirely protected by the ILOCK_EXCL at this point in
> time, so it remains untouched.
> 

Thanks for pointing this out.

> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_trans_inode.c | 54 +++++++++++++++++----------------
>  fs/xfs/xfs_file.c               |  9 ++++--
>  fs/xfs/xfs_inode.c              | 20 +++++++-----
>  fs/xfs/xfs_inode_item.c         |  7 +++++
>  fs/xfs/xfs_inode_item.h         | 18 +++++++++--
>  5 files changed, 68 insertions(+), 40 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_trans_inode.c b/fs/xfs/libxfs/xfs_trans_inode.c
> index 4504d215cd590..fe6c2e39be85d 100644
> --- a/fs/xfs/libxfs/xfs_trans_inode.c
> +++ b/fs/xfs/libxfs/xfs_trans_inode.c
...
> @@ -122,23 +117,30 @@ xfs_trans_log_inode(
>  	 * set however, then go ahead and bump the i_version counter
>  	 * unconditionally.
>  	 */
> -	if (!test_and_set_bit(XFS_LI_DIRTY, &ip->i_itemp->ili_item.li_flags) &&
> -	    IS_I_VERSION(VFS_I(ip))) {
> -		if (inode_maybe_inc_iversion(VFS_I(ip), flags & XFS_ILOG_CORE))
> -			flags |= XFS_ILOG_CORE;
> +	if (!test_and_set_bit(XFS_LI_DIRTY, &iip->ili_item.li_flags)) {
> +		if (IS_I_VERSION(inode) &&
> +		    inode_maybe_inc_iversion(inode, flags & XFS_ILOG_CORE))
> +			iversion_flags = XFS_ILOG_CORE;
>  	}
>  
> -	tp->t_flags |= XFS_TRANS_DIRTY;
> +	/*
> +	 * Record the specific change for fdatasync optimisation. This allows
> +	 * fdatasync to skip log forces for inodes that are only timestamp
> +	 * dirty. We do this before the change count so that the core being
> +	 * logged in this case does not impact on fdatasync behaviour.
> +	 */

We no longer do this before the change count logic so that part of the
comment is bogus.

> +	spin_lock(&iip->ili_lock);
> +	iip->ili_fsync_fields |= flags;
>  
>  	/*
> -	 * Always OR in the bits from the ili_last_fields field.
> -	 * This is to coordinate with the xfs_iflush() and xfs_iflush_done()
> -	 * routines in the eventual clearing of the ili_fields bits.
> -	 * See the big comment in xfs_iflush() for an explanation of
> -	 * this coordination mechanism.
> +	 * Always OR in the bits from the ili_last_fields field.  This is to
> +	 * coordinate with the xfs_iflush() and xfs_iflush_done() routines in
> +	 * the eventual clearing of the ili_fields bits.  See the big comment in
> +	 * xfs_iflush() for an explanation of this coordination mechanism.
>  	 */
> -	flags |= ip->i_itemp->ili_last_fields;
> -	ip->i_itemp->ili_fields |= flags;
> +	iip->ili_fields |= (flags | iip->ili_last_fields |
> +			    iversion_flags);
> +	spin_unlock(&iip->ili_lock);
>  }
>  
>  int
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 403c90309a8ff..0abf770b77498 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -94,6 +94,7 @@ xfs_file_fsync(
>  {
>  	struct inode		*inode = file->f_mapping->host;
>  	struct xfs_inode	*ip = XFS_I(inode);
> +	struct xfs_inode_log_item *iip = ip->i_itemp;
>  	struct xfs_mount	*mp = ip->i_mount;
>  	int			error = 0;
>  	int			log_flushed = 0;
> @@ -137,13 +138,15 @@ xfs_file_fsync(
>  	xfs_ilock(ip, XFS_ILOCK_SHARED);
>  	if (xfs_ipincount(ip)) {
>  		if (!datasync ||
> -		    (ip->i_itemp->ili_fsync_fields & ~XFS_ILOG_TIMESTAMP))
> -			lsn = ip->i_itemp->ili_last_lsn;
> +		    (iip->ili_fsync_fields & ~XFS_ILOG_TIMESTAMP))
> +			lsn = iip->ili_last_lsn;

I am still a little confused why the lock is elided in other read cases,
such as this one or perhaps the similar check in xfs_bmbt_to_iomap()..?

Similarly, it looks like we set the ili_[flush|last]_lsn fields outside
of this lock (though last_lsn looks like it's also covered by ilock),
yet the update to the inode_log_item struct implies they should be
protected. What's the intent there?

>  	}
>  
>  	if (lsn) {
>  		error = xfs_log_force_lsn(mp, lsn, XFS_LOG_SYNC, &log_flushed);
> -		ip->i_itemp->ili_fsync_fields = 0;
> +		spin_lock(&iip->ili_lock);
> +		iip->ili_fsync_fields = 0;
> +		spin_unlock(&iip->ili_lock);
>  	}
>  	xfs_iunlock(ip, XFS_ILOCK_SHARED);
>  
...
> diff --git a/fs/xfs/xfs_inode_item.h b/fs/xfs/xfs_inode_item.h
> index 4de5070e07655..44c47c08b0b59 100644
> --- a/fs/xfs/xfs_inode_item.h
> +++ b/fs/xfs/xfs_inode_item.h
> @@ -16,12 +16,24 @@ struct xfs_mount;
>  struct xfs_inode_log_item {
>  	struct xfs_log_item	ili_item;	   /* common portion */
>  	struct xfs_inode	*ili_inode;	   /* inode ptr */
> -	xfs_lsn_t		ili_flush_lsn;	   /* lsn at last flush */
> -	xfs_lsn_t		ili_last_lsn;	   /* lsn at last transaction */
> -	unsigned short		ili_lock_flags;	   /* lock flags */
> +	unsigned short		ili_lock_flags;	   /* inode lock flags */
> +	/*
> +	 * The ili_lock protects the interactions between the dirty state and
> +	 * the flush state of the inode log item. This allows us to do atomic
> +	 * modifications of multiple state fields without having to hold a
> +	 * specific inode lock to serialise them.
> +	 *
> +	 * We need atomic changes between indoe dirtying, inode flushing and

s/indoe/inode/

Brian

> +	 * inode completion, but these all hold different combinations of
> +	 * ILOCK and iflock and hence we need some other method of serialising
> +	 * updates to the flush state.
> +	 */
> +	spinlock_t		ili_lock;	   /* flush state lock */
>  	unsigned int		ili_last_fields;   /* fields when flushed */
>  	unsigned int		ili_fields;	   /* fields to be logged */
>  	unsigned int		ili_fsync_fields;  /* logged since last fsync */
> +	xfs_lsn_t		ili_flush_lsn;	   /* lsn at last flush */
> +	xfs_lsn_t		ili_last_lsn;	   /* lsn at last transaction */
>  };
>  
>  static inline int xfs_inode_clean(xfs_inode_t *ip)
> -- 
> 2.26.2.761.g0e0b3e54be
> 

