Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF74DC433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 18:13:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 884CA64E0E
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 18:13:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231346AbhA1SNL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 28 Jan 2021 13:13:11 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40397 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231795AbhA1SK2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 28 Jan 2021 13:10:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611857341;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NnRZrSDqr/Zym+m0E3sJqngHySUjodJKA86oyaf2cqc=;
        b=ZBeWEDLl8iIX20w7g6hEtJaF07ywm071/DjSLESiijq/0hWZAftR1OQ7Fu/qc8rZu0GYb9
        2JyA0FRxDwZnRMlMy+F84dSbBZlciFCeCxG3jaSvCup9rIhO3BJc6mD/8EKqzCFKh5e0bc
        yQpLJNtsIES9pyUaAufxn3ds+fyFL/M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-515-Wb4JwNjXOdeo_ayZ7Ds3rA-1; Thu, 28 Jan 2021 13:08:59 -0500
X-MC-Unique: Wb4JwNjXOdeo_ayZ7Ds3rA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2A331803623;
        Thu, 28 Jan 2021 18:08:58 +0000 (UTC)
Received: from bfoster (ovpn-114-23.rdu2.redhat.com [10.10.114.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 940851F402;
        Thu, 28 Jan 2021 18:08:57 +0000 (UTC)
Date:   Thu, 28 Jan 2021 13:08:55 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com
Subject: Re: [PATCH 03/13] xfs: remove xfs_trans_unreserve_quota_nblks
 completely
Message-ID: <20210128180855.GB2619139@bfoster>
References: <161181366379.1523592.9213241916555622577.stgit@magnolia>
 <161181368129.1523592.7737855214929870215.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161181368129.1523592.7737855214929870215.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 27, 2021 at 10:01:21PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> xfs_trans_cancel will release all the quota resources that were reserved
> on behalf of the transaction, so get rid of the explicit unreserve step.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_bmap_util.c |    7 ++-----
>  fs/xfs/xfs_iomap.c     |    6 ++----
>  fs/xfs/xfs_quota.h     |    2 --
>  fs/xfs/xfs_reflink.c   |    5 +----
>  4 files changed, 5 insertions(+), 15 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index 792809debaaa..f0a8f3377281 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
...
> @@ -856,9 +856,6 @@ xfs_alloc_file_space(
>  
>  	return error;
>  
> -error0:	/* unlock inode, unreserve quota blocks, cancel trans */
> -	xfs_trans_unreserve_quota_nblks(tp, ip, (long)qblocks, 0, quota_flag);
> -
>  error1:	/* Just cancel transaction */

Maybe just use 'error' here now..? Otherwise LGTM:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  	xfs_trans_cancel(tp);
>  	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index 514e6ae010e0..de0e371ba4dd 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -253,7 +253,7 @@ xfs_iomap_write_direct(
>  	error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
>  			XFS_IEXT_ADD_NOSPLIT_CNT);
>  	if (error)
> -		goto out_res_cancel;
> +		goto out_trans_cancel;
>  
>  	xfs_trans_ijoin(tp, ip, 0);
>  
> @@ -265,7 +265,7 @@ xfs_iomap_write_direct(
>  	error = xfs_bmapi_write(tp, ip, offset_fsb, count_fsb, bmapi_flags, 0,
>  				imap, &nimaps);
>  	if (error)
> -		goto out_res_cancel;
> +		goto out_trans_cancel;
>  
>  	/*
>  	 * Complete the transaction
> @@ -289,8 +289,6 @@ xfs_iomap_write_direct(
>  	xfs_iunlock(ip, XFS_ILOCK_EXCL);
>  	return error;
>  
> -out_res_cancel:
> -	xfs_trans_unreserve_quota_nblks(tp, ip, (long)qblocks, 0, quota_flag);
>  out_trans_cancel:
>  	xfs_trans_cancel(tp);
>  	goto out_unlock;
> diff --git a/fs/xfs/xfs_quota.h b/fs/xfs/xfs_quota.h
> index 159d338bf161..a395dabee033 100644
> --- a/fs/xfs/xfs_quota.h
> +++ b/fs/xfs/xfs_quota.h
> @@ -164,8 +164,6 @@ xfs_quota_reserve_blkres(struct xfs_inode *ip, int64_t dblocks)
>  #define xfs_qm_unmount_quotas(mp)
>  #endif /* CONFIG_XFS_QUOTA */
>  
> -#define xfs_trans_unreserve_quota_nblks(tp, ip, nblks, ninos, flags) \
> -	xfs_trans_reserve_quota_nblks(tp, ip, -(nblks), -(ninos), flags)
>  #define xfs_trans_reserve_quota(tp, mp, ud, gd, pd, nb, ni, f) \
>  	xfs_trans_reserve_quota_bydquots(tp, mp, ud, gd, pd, nb, ni, \
>  				f | XFS_QMOPT_RES_REGBLKS)
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index bea64ed5a57f..15435229bc1f 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -411,7 +411,7 @@ xfs_reflink_allocate_cow(
>  			XFS_BMAPI_COWFORK | XFS_BMAPI_PREALLOC, 0, cmap,
>  			&nimaps);
>  	if (error)
> -		goto out_unreserve;
> +		goto out_trans_cancel;
>  
>  	xfs_inode_set_cowblocks_tag(ip);
>  	error = xfs_trans_commit(tp);
> @@ -436,9 +436,6 @@ xfs_reflink_allocate_cow(
>  	trace_xfs_reflink_convert_cow(ip, cmap);
>  	return xfs_reflink_convert_cow_locked(ip, offset_fsb, count_fsb);
>  
> -out_unreserve:
> -	xfs_trans_unreserve_quota_nblks(tp, ip, (long)resblks, 0,
> -			XFS_QMOPT_RES_REGBLKS);
>  out_trans_cancel:
>  	xfs_trans_cancel(tp);
>  	return error;
> 

