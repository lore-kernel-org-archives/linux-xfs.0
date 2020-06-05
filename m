Return-Path: <SRS0=6H2z=7S=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44F98C433E0
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Jun 2020 16:27:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 24FF42077D
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Jun 2020 16:27:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FJ2YdTFX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728214AbgFEQ0k (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 5 Jun 2020 12:26:40 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:20854 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728020AbgFEQ0d (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Jun 2020 12:26:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591374392;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CKudkMnPPt0dT/t5Txayx+2azru0In6f+KZjvvJ6ot0=;
        b=FJ2YdTFXC4N47tddlwbfYPkzBPcvQjP1ykkPAueASm6WqZMP1Nc58ser/B5XBFOPOZbfiq
        ui5V8kgxtYtTgkpr4SGSC+XAxQ6nSOKQ0XQt6Orce4hCH6vFakQ4ZrPE7A4ipe24UEpNje
        2u+GKpV/Rf361Y+kAcTBEKl48d8ONQo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-352-rjjiEADnNUae3vblKYdb2Q-1; Fri, 05 Jun 2020 12:26:30 -0400
X-MC-Unique: rjjiEADnNUae3vblKYdb2Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 53E0164ACA;
        Fri,  5 Jun 2020 16:26:29 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EEA2560BF4;
        Fri,  5 Jun 2020 16:26:28 +0000 (UTC)
Date:   Fri, 5 Jun 2020 12:26:27 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 21/30] xfs: remove SYNC_TRYLOCK from inode reclaim
Message-ID: <20200605162627.GE23747@bfoster>
References: <20200604074606.266213-1-david@fromorbit.com>
 <20200604074606.266213-22-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200604074606.266213-22-david@fromorbit.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 04, 2020 at 05:45:57PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> All background reclaim is SYNC_TRYLOCK already, and even blocking
> reclaim (SYNC_WAIT) can use trylock mechanisms as
> xfs_reclaim_inodes_ag() will keep cycling until there are no more
> reclaimable inodes. Hence we can kill SYNC_TRYLOCK from inode
> reclaim and make everything unconditionally non-blocking.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_icache.c | 29 ++++++++++++-----------------
>  1 file changed, 12 insertions(+), 17 deletions(-)
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index d1c47a0e0b0ec..ebe55124d6cb8 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -174,7 +174,7 @@ xfs_reclaim_worker(
>  	struct xfs_mount *mp = container_of(to_delayed_work(work),
>  					struct xfs_mount, m_reclaim_work);
>  
> -	xfs_reclaim_inodes(mp, SYNC_TRYLOCK);
> +	xfs_reclaim_inodes(mp, 0);
>  	xfs_reclaim_work_queue(mp);
>  }
>  
> @@ -1030,10 +1030,9 @@ xfs_cowblocks_worker(
>   * Grab the inode for reclaim exclusively.
>   * Return 0 if we grabbed it, non-zero otherwise.
>   */
> -STATIC int
> +static int
>  xfs_reclaim_inode_grab(
> -	struct xfs_inode	*ip,
> -	int			flags)
> +	struct xfs_inode	*ip)
>  {
>  	ASSERT(rcu_read_lock_held());
>  
> @@ -1042,12 +1041,10 @@ xfs_reclaim_inode_grab(
>  		return 1;
>  
>  	/*
> -	 * If we are asked for non-blocking operation, do unlocked checks to
> -	 * see if the inode already is being flushed or in reclaim to avoid
> -	 * lock traffic.
> +	 * Do unlocked checks to see if the inode already is being flushed or in
> +	 * reclaim to avoid lock traffic.
>  	 */
> -	if ((flags & SYNC_TRYLOCK) &&
> -	    __xfs_iflags_test(ip, XFS_IFLOCK | XFS_IRECLAIM))
> +	if (__xfs_iflags_test(ip, XFS_IFLOCK | XFS_IRECLAIM))
>  		return 1;
>  
>  	/*
> @@ -1114,8 +1111,7 @@ xfs_reclaim_inode_grab(
>  static bool
>  xfs_reclaim_inode(
>  	struct xfs_inode	*ip,
> -	struct xfs_perag	*pag,
> -	int			sync_mode)
> +	struct xfs_perag	*pag)
>  {
>  	xfs_ino_t		ino = ip->i_ino; /* for radix_tree_delete */
>  
> @@ -1209,7 +1205,6 @@ xfs_reclaim_inode(
>  static int
>  xfs_reclaim_inodes_ag(
>  	struct xfs_mount	*mp,
> -	int			flags,
>  	int			*nr_to_scan)
>  {
>  	struct xfs_perag	*pag;
> @@ -1254,7 +1249,7 @@ xfs_reclaim_inodes_ag(
>  			for (i = 0; i < nr_found; i++) {
>  				struct xfs_inode *ip = batch[i];
>  
> -				if (done || xfs_reclaim_inode_grab(ip, flags))
> +				if (done || xfs_reclaim_inode_grab(ip))
>  					batch[i] = NULL;
>  
>  				/*
> @@ -1285,7 +1280,7 @@ xfs_reclaim_inodes_ag(
>  			for (i = 0; i < nr_found; i++) {
>  				if (!batch[i])
>  					continue;
> -				if (!xfs_reclaim_inode(batch[i], pag, flags))
> +				if (!xfs_reclaim_inode(batch[i], pag))
>  					skipped++;
>  			}
>  
> @@ -1311,13 +1306,13 @@ xfs_reclaim_inodes(
>  	int		nr_to_scan = INT_MAX;
>  	int		skipped;
>  
> -	xfs_reclaim_inodes_ag(mp, mode, &nr_to_scan);
> +	xfs_reclaim_inodes_ag(mp, &nr_to_scan);
>  	if (!(mode & SYNC_WAIT))
>  		return 0;
>  
>  	do {
>  		xfs_ail_push_all_sync(mp->m_ail);
> -		skipped = xfs_reclaim_inodes_ag(mp, mode, &nr_to_scan);
> +		skipped = xfs_reclaim_inodes_ag(mp, &nr_to_scan);
>  	} while (skipped > 0);
>  
>  	return 0;
> @@ -1341,7 +1336,7 @@ xfs_reclaim_inodes_nr(
>  	xfs_reclaim_work_queue(mp);
>  	xfs_ail_push_all(mp->m_ail);
>  
> -	xfs_reclaim_inodes_ag(mp, SYNC_TRYLOCK, &nr_to_scan);
> +	xfs_reclaim_inodes_ag(mp, &nr_to_scan);
>  	return 0;
>  }
>  
> -- 
> 2.26.2.761.g0e0b3e54be
> 

