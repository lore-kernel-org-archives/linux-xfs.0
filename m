Return-Path: <SRS0=eQWr=DM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91D89C4363A
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Oct 2020 16:20:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4BD7C206DD
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Oct 2020 16:20:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ImTnBpe6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728083AbgJEQUX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 5 Oct 2020 12:20:23 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44290 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726638AbgJEQUX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Oct 2020 12:20:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601914822;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Vn9DDhR9ZJxZdK6AmbfK5dz8y2v2VRKuDv9AGOzscSI=;
        b=ImTnBpe6KfsXSADaWvyCJ2zzRFgZgQjznqtq05NnyKCfz6g/JUZ/01DxNG6H8RTgm1OvVx
        YTuAy5OAMrAC7EJOEHNKpDUsTXNj6/uLL1F2iOZfGaeQkA1Pmrk6LjWFR9aKwM+HDMyFdi
        /sFCPk7/mGz1aUxW3Z2um2W6XKjY+vs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-251-S7fqDtYsPHu7L2u9xBPZdQ-1; Mon, 05 Oct 2020 12:20:18 -0400
X-MC-Unique: S7fqDtYsPHu7L2u9xBPZdQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2F1579CC05;
        Mon,  5 Oct 2020 16:20:17 +0000 (UTC)
Received: from bfoster (ovpn-112-249.rdu2.redhat.com [10.10.112.249])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 927F45C1BD;
        Mon,  5 Oct 2020 16:20:16 +0000 (UTC)
Date:   Mon, 5 Oct 2020 12:20:14 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@lst.de
Subject: Re: [PATCH v3.3 3/3] xfs: fix an incore inode UAF in xfs_bui_recover
Message-ID: <20201005162014.GB6539@bfoster>
References: <160140142711.830434.5161910313856677767.stgit@magnolia>
 <160140144660.830434.10498291551366134327.stgit@magnolia>
 <20201004191127.GC49547@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201004191127.GC49547@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Oct 04, 2020 at 12:11:27PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> In xfs_bui_item_recover, there exists a use-after-free bug with regards
> to the inode that is involved in the bmap replay operation.  If the
> mapping operation does not complete, we call xfs_bmap_unmap_extent to
> create a deferred op to finish the unmapping work, and we retain a
> pointer to the incore inode.
> 
> Unfortunately, the very next thing we do is commit the transaction and
> drop the inode.  If reclaim tears down the inode before we try to finish
> the defer ops, we dereference garbage and blow up.  Therefore, create a
> way to join inodes to the defer ops freezer so that we can maintain the
> xfs_inode reference until we're done with the inode.
> 
> Note: This imposes the requirement that there be enough memory to keep
> every incore inode in memory throughout recovery.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> v3.3: ihold the captured inode and let callers iunlock/irele their own
> reference
> v3.2: rebase on updated defer capture patches
> ---
>  fs/xfs/libxfs/xfs_defer.c  |   43 ++++++++++++++++++++++++++++++++++++++-----
>  fs/xfs/libxfs/xfs_defer.h  |   11 +++++++++--
>  fs/xfs/xfs_bmap_item.c     |    7 +++++--
>  fs/xfs/xfs_extfree_item.c  |    2 +-
>  fs/xfs/xfs_inode.c         |    8 ++++++++
>  fs/xfs/xfs_inode.h         |    2 ++
>  fs/xfs/xfs_log_recover.c   |    7 ++++++-
>  fs/xfs/xfs_refcount_item.c |    2 +-
>  fs/xfs/xfs_rmap_item.c     |    2 +-
>  9 files changed, 71 insertions(+), 13 deletions(-)
> 
...
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 2bfbcf28b1bd..24b1e2244905 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -3813,3 +3813,11 @@ xfs_iunlock2_io_mmap(
>  	if (!same_inode)
>  		inode_unlock(VFS_I(ip1));
>  }
> +
> +/* Grab an extra reference to the VFS inode. */
> +void
> +xfs_ihold(
> +	struct xfs_inode	*ip)
> +{
> +	ihold(VFS_I(ip));
> +}

It looks to me that the only reason xfs_irele() exists is for a
tracepoint. We don't have that here, so what's the purpose of the
helper?

Otherwise the patch looks good to me:

Reviewed-by: Brian Foster <bfoster@redhat.com>

> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index 751a3d1d7d84..e9b0186b594c 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -476,4 +476,6 @@ void xfs_end_io(struct work_struct *work);
>  int xfs_ilock2_io_mmap(struct xfs_inode *ip1, struct xfs_inode *ip2);
>  void xfs_iunlock2_io_mmap(struct xfs_inode *ip1, struct xfs_inode *ip2);
>  
> +void xfs_ihold(struct xfs_inode *ip);
> +
>  #endif	/* __XFS_INODE_H__ */
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 001e1585ddc6..a8289adc1b29 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -2439,6 +2439,7 @@ xlog_finish_defer_ops(
>  {
>  	struct xfs_defer_capture *dfc, *next;
>  	struct xfs_trans	*tp;
> +	struct xfs_inode	*ip;
>  	int			error = 0;
>  
>  	list_for_each_entry_safe(dfc, next, capture_list, dfc_list) {
> @@ -2464,9 +2465,13 @@ xlog_finish_defer_ops(
>  		 * from recovering a single intent item.
>  		 */
>  		list_del_init(&dfc->dfc_list);
> -		xfs_defer_ops_continue(dfc, tp);
> +		xfs_defer_ops_continue(dfc, tp, &ip);
>  
>  		error = xfs_trans_commit(tp);
> +		if (ip) {
> +			xfs_iunlock(ip, XFS_ILOCK_EXCL);
> +			xfs_irele(ip);
> +		}
>  		if (error)
>  			return error;
>  	}
> diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
> index 0478374add64..ad895b48f365 100644
> --- a/fs/xfs/xfs_refcount_item.c
> +++ b/fs/xfs/xfs_refcount_item.c
> @@ -544,7 +544,7 @@ xfs_cui_item_recover(
>  	}
>  
>  	xfs_refcount_finish_one_cleanup(tp, rcur, error);
> -	return xfs_defer_ops_capture_and_commit(tp, capture_list);
> +	return xfs_defer_ops_capture_and_commit(tp, NULL, capture_list);
>  
>  abort_error:
>  	xfs_refcount_finish_one_cleanup(tp, rcur, error);
> diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
> index 0d8fa707f079..1163f32c3e62 100644
> --- a/fs/xfs/xfs_rmap_item.c
> +++ b/fs/xfs/xfs_rmap_item.c
> @@ -567,7 +567,7 @@ xfs_rui_item_recover(
>  	}
>  
>  	xfs_rmap_finish_one_cleanup(tp, rcur, error);
> -	return xfs_defer_ops_capture_and_commit(tp, capture_list);
> +	return xfs_defer_ops_capture_and_commit(tp, NULL, capture_list);
>  
>  abort_error:
>  	xfs_rmap_finish_one_cleanup(tp, rcur, error);
> 

