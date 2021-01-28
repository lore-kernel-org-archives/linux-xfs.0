Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD017C433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 18:13:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 89F3E64E1C
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 18:13:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231256AbhA1SN2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 28 Jan 2021 13:13:28 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37834 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231203AbhA1SKI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 28 Jan 2021 13:10:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611857321;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=772feVMdBYXVmGOJ8jA+CjcgKy32Yp6xzQCcndPVPjY=;
        b=WLS1keI63GjaqGdIhgDas2uuGZqqHbnCq2sNFY5QmTsKD8hy0ZvonX0nIuCUmnAtf0CUkV
        VMqYoH36mOEUuuLrKG6PTieB/vW3hkjOpONwFD/Q99ZloSxV/dPKcXRt35NeZMhyalWfgr
        Dqr7fTWJVvrOBA2p3JDH7hSm1TujtXA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-425-ewmi-rnkMquz99zPZYAgAw-1; Thu, 28 Jan 2021 13:08:38 -0500
X-MC-Unique: ewmi-rnkMquz99zPZYAgAw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3882E803620;
        Thu, 28 Jan 2021 18:08:37 +0000 (UTC)
Received: from bfoster (ovpn-114-23.rdu2.redhat.com [10.10.114.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8E52619C95;
        Thu, 28 Jan 2021 18:08:36 +0000 (UTC)
Date:   Thu, 28 Jan 2021 13:08:34 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        hch@infradead.org, david@fromorbit.com
Subject: Re: [PATCH 02/13] xfs: create convenience wrappers for incore quota
 block reservations
Message-ID: <20210128180834.GA2619139@bfoster>
References: <161181366379.1523592.9213241916555622577.stgit@magnolia>
 <161181367558.1523592.4554805913065385916.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161181367558.1523592.4554805913065385916.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 27, 2021 at 10:01:15PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Create a couple of convenience wrappers for creating and deleting quota
> block reservations against future changes.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_bmap.c |   10 ++++------
>  fs/xfs/xfs_quota.h       |   19 +++++++++++++++++++
>  fs/xfs/xfs_reflink.c     |    5 ++---
>  3 files changed, 25 insertions(+), 9 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 0410627c6fcc..6edf1b5711c8 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -4097,8 +4097,7 @@ xfs_bmapi_reserve_delalloc(
>  	 * blocks.  This number gets adjusted later.  We return if we haven't
>  	 * allocated blocks already inside this loop.
>  	 */
> -	error = xfs_trans_reserve_quota_nblks(NULL, ip, (long)alen, 0,
> -						XFS_QMOPT_RES_REGBLKS);
> +	error = xfs_quota_reserve_blkres(ip, alen);
>  	if (error)
>  		return error;
>  
> @@ -4144,8 +4143,7 @@ xfs_bmapi_reserve_delalloc(
>  	xfs_mod_fdblocks(mp, alen, false);
>  out_unreserve_quota:
>  	if (XFS_IS_QUOTA_ON(mp))
> -		xfs_trans_unreserve_quota_nblks(NULL, ip, (long)alen, 0,
> -						XFS_QMOPT_RES_REGBLKS);
> +		xfs_quota_unreserve_blkres(ip, alen);
>  	return error;
>  }
>  
> @@ -4937,8 +4935,8 @@ xfs_bmap_del_extent_delay(
>  	 * sb counters as we might have to borrow some blocks for the
>  	 * indirect block accounting.
>  	 */
> -	error = xfs_trans_unreserve_quota_nblks(NULL, ip, del->br_blockcount, 0,
> -			isrt ? XFS_QMOPT_RES_RTBLKS : XFS_QMOPT_RES_REGBLKS);
> +	ASSERT(!isrt);
> +	error = xfs_quota_unreserve_blkres(ip, del->br_blockcount);
>  	if (error)
>  		return error;
>  	ip->i_delayed_blks -= del->br_blockcount;
> diff --git a/fs/xfs/xfs_quota.h b/fs/xfs/xfs_quota.h
> index 5a62398940d0..159d338bf161 100644
> --- a/fs/xfs/xfs_quota.h
> +++ b/fs/xfs/xfs_quota.h
> @@ -108,6 +108,12 @@ extern void xfs_qm_mount_quotas(struct xfs_mount *);
>  extern void xfs_qm_unmount(struct xfs_mount *);
>  extern void xfs_qm_unmount_quotas(struct xfs_mount *);
>  
> +static inline int
> +xfs_quota_reserve_blkres(struct xfs_inode *ip, int64_t dblocks)
> +{
> +	return xfs_trans_reserve_quota_nblks(NULL, ip, dblocks, 0,
> +			XFS_QMOPT_RES_REGBLKS);
> +}
>  #else
>  static inline int
>  xfs_qm_vop_dqalloc(struct xfs_inode *ip, kuid_t kuid, kgid_t kgid,
> @@ -136,6 +142,13 @@ static inline int xfs_trans_reserve_quota_bydquots(struct xfs_trans *tp,
>  {
>  	return 0;
>  }
> +
> +static inline int
> +xfs_quota_reserve_blkres(struct xfs_inode *ip, int64_t dblocks)
> +{
> +	return 0;
> +}
> +
>  #define xfs_qm_vop_create_dqattach(tp, ip, u, g, p)
>  #define xfs_qm_vop_rename_dqattach(it)					(0)
>  #define xfs_qm_vop_chown(tp, ip, old, new)				(NULL)
> @@ -157,6 +170,12 @@ static inline int xfs_trans_reserve_quota_bydquots(struct xfs_trans *tp,
>  	xfs_trans_reserve_quota_bydquots(tp, mp, ud, gd, pd, nb, ni, \
>  				f | XFS_QMOPT_RES_REGBLKS)
>  
> +static inline int
> +xfs_quota_unreserve_blkres(struct xfs_inode *ip, int64_t dblocks)
> +{
> +	return xfs_quota_reserve_blkres(ip, -dblocks);
> +}
> +
>  extern int xfs_mount_reset_sbqflags(struct xfs_mount *);
>  
>  #endif	/* __XFS_QUOTA_H__ */
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index 183142fd0961..bea64ed5a57f 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -508,9 +508,8 @@ xfs_reflink_cancel_cow_blocks(
>  			xfs_bmap_del_extent_cow(ip, &icur, &got, &del);
>  
>  			/* Remove the quota reservation */
> -			error = xfs_trans_unreserve_quota_nblks(NULL, ip,
> -					del.br_blockcount, 0,
> -					XFS_QMOPT_RES_REGBLKS);
> +			error = xfs_quota_unreserve_blkres(ip,
> +					del.br_blockcount);
>  			if (error)
>  				break;
>  		} else {
> 

