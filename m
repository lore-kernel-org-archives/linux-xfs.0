Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EB0CC433DB
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Jan 2021 05:19:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 39B5120732
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Jan 2021 05:19:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729377AbhAZFSN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Jan 2021 00:18:13 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:34178 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730073AbhAYPiJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Jan 2021 10:38:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611589003;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UCwcmEg8C48v88WcM8UmzcFnM7Qb/xNTshegr92nNdM=;
        b=KJVKaGaTLII6A6q0MPCkVzz9EwU8AV+YEuyzkkxOPD6J/mCLODu51fG7Mmqrc6vS157a00
        PCBITlMNSpb6yNac4d1pSX3E4BIWnMjD9rG9bL4MI/XAj1t4yeN59XuErfXNk9ajOEM4MW
        YqsS9aZvikCWMdoL5EpfYVXWcSRzYAM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-66-WBk3K-vUM1ycrZyM_wTnLw-1; Mon, 25 Jan 2021 10:13:48 -0500
X-MC-Unique: WBk3K-vUM1ycrZyM_wTnLw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1BD4184E247;
        Mon, 25 Jan 2021 15:13:47 +0000 (UTC)
Received: from bfoster (ovpn-114-23.rdu2.redhat.com [10.10.114.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6C0B360C0F;
        Mon, 25 Jan 2021 15:13:46 +0000 (UTC)
Date:   Mon, 25 Jan 2021 10:13:44 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        hch@infradead.org, david@fromorbit.com
Subject: Re: [PATCH 1/4] xfs: clean up quota reservation callsites
Message-ID: <20210125151344.GC2047559@bfoster>
References: <161142789504.2170981.1372317837643770452.stgit@magnolia>
 <161142790077.2170981.3836953907583983452.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161142790077.2170981.3836953907583983452.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Jan 23, 2021 at 10:51:40AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Convert a few xfs_trans_*reserve* callsites that are open-coding other
> convenience functions.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_bmap.c |    3 +--
>  fs/xfs/xfs_bmap_util.c   |    4 ++--
>  fs/xfs/xfs_reflink.c     |    4 ++--
>  3 files changed, 5 insertions(+), 6 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 2cd24bb06040..aea179212946 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -4938,8 +4938,7 @@ xfs_bmap_del_extent_delay(
>  	 * sb counters as we might have to borrow some blocks for the
>  	 * indirect block accounting.
>  	 */
> -	error = xfs_trans_reserve_quota_nblks(NULL, ip,
> -			-((long)del->br_blockcount), 0,
> +	error = xfs_trans_unreserve_quota_nblks(NULL, ip, del->br_blockcount, 0,
>  			isrt ? XFS_QMOPT_RES_RTBLKS : XFS_QMOPT_RES_REGBLKS);
>  	if (error)
>  		return error;
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index f3f8c48ff5bf..792809debaaa 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -884,8 +884,8 @@ xfs_unmap_extent(
>  	}
>  
>  	xfs_ilock(ip, XFS_ILOCK_EXCL);
> -	error = xfs_trans_reserve_quota(tp, mp, ip->i_udquot, ip->i_gdquot,
> -			ip->i_pdquot, resblks, 0, XFS_QMOPT_RES_REGBLKS);
> +	error = xfs_trans_reserve_quota_nblks(tp, ip, resblks, 0,
> +			XFS_QMOPT_RES_REGBLKS);
>  	if (error)
>  		goto out_trans_cancel;
>  
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index e1c98dbf79e4..183142fd0961 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -508,8 +508,8 @@ xfs_reflink_cancel_cow_blocks(
>  			xfs_bmap_del_extent_cow(ip, &icur, &got, &del);
>  
>  			/* Remove the quota reservation */
> -			error = xfs_trans_reserve_quota_nblks(NULL, ip,
> -					-(long)del.br_blockcount, 0,
> +			error = xfs_trans_unreserve_quota_nblks(NULL, ip,
> +					del.br_blockcount, 0,
>  					XFS_QMOPT_RES_REGBLKS);
>  			if (error)
>  				break;
> 

