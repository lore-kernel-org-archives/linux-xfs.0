Return-Path: <SRS0=vNgo=5K=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BD1EC43331
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Mar 2020 13:30:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2588E2076A
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Mar 2020 13:30:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ePKF48XG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727277AbgCYNat (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Mar 2020 09:30:49 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:55766 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726967AbgCYNat (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Mar 2020 09:30:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585143047;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1TwyIO13FF/FxwIcJZ+elAHugIzthIcFcVlJtGhRCcM=;
        b=ePKF48XGbsvDhCWKOo0sAuKRWnsopp5n7Dz0NHP7Rmr7N2gjG7RN9AHNkWmJo4+HQU8jfA
        Y/XnTgfCu79nr1rkzbRwht94gZJUh+oCLdmA9r599g/jTALfX21B1sIlf1GMyfZft9GuvJ
        Ds3uPol4sp1nbBAQzK610u5RwChi+tM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-486-Y-FsyP0LNUGaoytEB21aQA-1; Wed, 25 Mar 2020 09:30:42 -0400
X-MC-Unique: Y-FsyP0LNUGaoytEB21aQA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7C6F8800D5B;
        Wed, 25 Mar 2020 13:30:41 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 34B431001920;
        Wed, 25 Mar 2020 13:30:41 +0000 (UTC)
Date:   Wed, 25 Mar 2020 09:30:39 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 8/8] xfs: factor inode lookup from xfs_ifree_cluster
Message-ID: <20200325133039.GC11912@bfoster>
References: <20200325014205.11843-1-david@fromorbit.com>
 <20200325014205.11843-9-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200325014205.11843-9-david@fromorbit.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 25, 2020 at 12:42:05PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> There's lots of indent in this code which makes it a bit hard to
> follow. We are also going to completely rework the inode lookup code
> as part of the inode reclaim rework, so factor out the inode lookup
> code from the inode cluster freeing code.
> 
> Based on prototype code from Christoph Hellwig.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

https://lore.kernel.org/linux-xfs/20191104232000.GR4153244@magnolia/
https://lore.kernel.org/linux-xfs/20191101120521.GE59146@bfoster/

>  fs/xfs/xfs_inode.c | 152 +++++++++++++++++++++++++--------------------
>  1 file changed, 84 insertions(+), 68 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 14b922f2a6db7..5c930863ed5b8 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -2503,6 +2503,88 @@ xfs_iunlink_remove(
>  	return error;
>  }
>  
> +/*
> + * Look up the inode number specified and mark it stale if it is found. If it is
> + * dirty, return the inode so it can be attached to the cluster buffer so it can
> + * be processed appropriately when the cluster free transaction completes.
> + */
> +static struct xfs_inode *
> +xfs_ifree_get_one_inode(
> +	struct xfs_perag	*pag,
> +	struct xfs_inode	*free_ip,
> +	int			inum)
> +{
> +	struct xfs_mount	*mp = pag->pag_mount;
> +	struct xfs_inode	*ip;
> +
> +retry:
> +	rcu_read_lock();
> +	ip = radix_tree_lookup(&pag->pag_ici_root, XFS_INO_TO_AGINO(mp, inum));
> +
> +	/* Inode not in memory, nothing to do */
> +	if (!ip)
> +		goto out_rcu_unlock;
> +
> +	/*
> +	 * because this is an RCU protected lookup, we could find a recently
> +	 * freed or even reallocated inode during the lookup. We need to check
> +	 * under the i_flags_lock for a valid inode here. Skip it if it is not
> +	 * valid, the wrong inode or stale.
> +	 */
> +	spin_lock(&ip->i_flags_lock);
> +	if (ip->i_ino != inum || __xfs_iflags_test(ip, XFS_ISTALE)) {
> +		spin_unlock(&ip->i_flags_lock);
> +		goto out_rcu_unlock;
> +	}
> +	spin_unlock(&ip->i_flags_lock);
> +
> +	/*
> +	 * Don't try to lock/unlock the current inode, but we _cannot_ skip the
> +	 * other inodes that we did not find in the list attached to the buffer
> +	 * and are not already marked stale. If we can't lock it, back off and
> +	 * retry.
> +	 */
> +	if (ip != free_ip) {
> +		if (!xfs_ilock_nowait(ip, XFS_ILOCK_EXCL)) {
> +			rcu_read_unlock();
> +			delay(1);
> +			goto retry;
> +		}
> +
> +		/*
> +		 * Check the inode number again in case we're racing with
> +		 * freeing in xfs_reclaim_inode().  See the comments in that
> +		 * function for more information as to why the initial check is
> +		 * not sufficient.
> +		 */
> +		if (ip->i_ino != inum) {
> +			xfs_iunlock(ip, XFS_ILOCK_EXCL);
> +			goto out_rcu_unlock;
> +		}
> +	}
> +	rcu_read_unlock();
> +
> +	xfs_iflock(ip);
> +	xfs_iflags_set(ip, XFS_ISTALE);
> +
> +	/*
> +	 * We don't need to attach clean inodes or those only with unlogged
> +	 * changes (which we throw away, anyway).
> +	 */
> +	if (!ip->i_itemp || xfs_inode_clean(ip)) {
> +		ASSERT(ip != free_ip);
> +		xfs_ifunlock(ip);
> +		xfs_iunlock(ip, XFS_ILOCK_EXCL);
> +		goto out_no_inode;
> +	}
> +	return ip;
> +
> +out_rcu_unlock:
> +	rcu_read_unlock();
> +out_no_inode:
> +	return NULL;
> +}
> +
>  /*
>   * A big issue when freeing the inode cluster is that we _cannot_ skip any
>   * inodes that are in memory - they all must be marked stale and attached to
> @@ -2603,77 +2685,11 @@ xfs_ifree_cluster(
>  		 * even trying to lock them.
>  		 */
>  		for (i = 0; i < igeo->inodes_per_cluster; i++) {
> -retry:
> -			rcu_read_lock();
> -			ip = radix_tree_lookup(&pag->pag_ici_root,
> -					XFS_INO_TO_AGINO(mp, (inum + i)));
> -
> -			/* Inode not in memory, nothing to do */
> -			if (!ip) {
> -				rcu_read_unlock();
> +			ip = xfs_ifree_get_one_inode(pag, free_ip, inum + i);
> +			if (!ip)
>  				continue;
> -			}
> -
> -			/*
> -			 * because this is an RCU protected lookup, we could
> -			 * find a recently freed or even reallocated inode
> -			 * during the lookup. We need to check under the
> -			 * i_flags_lock for a valid inode here. Skip it if it
> -			 * is not valid, the wrong inode or stale.
> -			 */
> -			spin_lock(&ip->i_flags_lock);
> -			if (ip->i_ino != inum + i ||
> -			    __xfs_iflags_test(ip, XFS_ISTALE)) {
> -				spin_unlock(&ip->i_flags_lock);
> -				rcu_read_unlock();
> -				continue;
> -			}
> -			spin_unlock(&ip->i_flags_lock);
> -
> -			/*
> -			 * Don't try to lock/unlock the current inode, but we
> -			 * _cannot_ skip the other inodes that we did not find
> -			 * in the list attached to the buffer and are not
> -			 * already marked stale. If we can't lock it, back off
> -			 * and retry.
> -			 */
> -			if (ip != free_ip) {
> -				if (!xfs_ilock_nowait(ip, XFS_ILOCK_EXCL)) {
> -					rcu_read_unlock();
> -					delay(1);
> -					goto retry;
> -				}
> -
> -				/*
> -				 * Check the inode number again in case we're
> -				 * racing with freeing in xfs_reclaim_inode().
> -				 * See the comments in that function for more
> -				 * information as to why the initial check is
> -				 * not sufficient.
> -				 */
> -				if (ip->i_ino != inum + i) {
> -					xfs_iunlock(ip, XFS_ILOCK_EXCL);
> -					rcu_read_unlock();
> -					continue;
> -				}
> -			}
> -			rcu_read_unlock();
>  
> -			xfs_iflock(ip);
> -			xfs_iflags_set(ip, XFS_ISTALE);
> -
> -			/*
> -			 * we don't need to attach clean inodes or those only
> -			 * with unlogged changes (which we throw away, anyway).
> -			 */
>  			iip = ip->i_itemp;
> -			if (!iip || xfs_inode_clean(ip)) {
> -				ASSERT(ip != free_ip);
> -				xfs_ifunlock(ip);
> -				xfs_iunlock(ip, XFS_ILOCK_EXCL);
> -				continue;
> -			}
> -
>  			iip->ili_last_fields = iip->ili_fields;
>  			iip->ili_fields = 0;
>  			iip->ili_fsync_fields = 0;
> -- 
> 2.26.0.rc2
> 

