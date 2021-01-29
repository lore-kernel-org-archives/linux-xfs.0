Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D996FC433DB
	for <linux-xfs@archiver.kernel.org>; Fri, 29 Jan 2021 16:34:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ACE8264E02
	for <linux-xfs@archiver.kernel.org>; Fri, 29 Jan 2021 16:34:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231452AbhA2Qe0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 29 Jan 2021 11:34:26 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:54102 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231454AbhA2Qcj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 29 Jan 2021 11:32:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611937870;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9ZPQ41qnTeXWgPE0nPJBxFLx330fKGLVQfVYniwPYnQ=;
        b=Ees6c4+FE/vee8vcBOot+Edf+KJtdbQv0YtnkOXUX1qWjoB8D/+kIYXSOxei7rr+atb+hT
        mn1g+yoE5NmrIEVKPhL2IRFi2R57vIKwyIr2kvr1Wk5olZOU66cxC4gDy8lcw1JZOfEC0P
        ZI69pEbIadtmdupZtffXbmb4wVwRkZk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-582-Uk9N8TCEN_2W2TBh9ft0FA-1; Fri, 29 Jan 2021 11:31:08 -0500
X-MC-Unique: Uk9N8TCEN_2W2TBh9ft0FA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BE23FCC625;
        Fri, 29 Jan 2021 16:31:05 +0000 (UTC)
Received: from bfoster (ovpn-114-23.rdu2.redhat.com [10.10.114.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 315F010023B2;
        Fri, 29 Jan 2021 16:31:05 +0000 (UTC)
Date:   Fri, 29 Jan 2021 11:31:03 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org,
        hch@infradead.org, david@fromorbit.com
Subject: Re: [PATCH 2/2] xfs: set WQ_SYSFS on all workqueues in debug mode
Message-ID: <20210129163103.GJ2665284@bfoster>
References: <161181380539.1525344.442839530784024643.stgit@magnolia>
 <161181381679.1525344.10913812775756159263.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161181381679.1525344.10913812775756159263.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 27, 2021 at 10:03:36PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> When CONFIG_XFS_DEBUG=y, set WQ_SYSFS on all workqueues that we create
> so that we (developers) have a means to monitor cpu affinity and whatnot
> for background workers.  In the next patchset we'll expose knobs for
> some of the workqueues publicly and document it, but not now.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_log.c       |    5 +++--
>  fs/xfs/xfs_mru_cache.c |    2 +-
>  fs/xfs/xfs_super.c     |   23 ++++++++++++++---------
>  fs/xfs/xfs_super.h     |    6 ++++++
>  4 files changed, 24 insertions(+), 12 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index d8b814227734..9aa30e7cd314 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -1492,8 +1492,9 @@ xlog_alloc_log(
>  	log->l_iclog->ic_prev = prev_iclog;	/* re-write 1st prev ptr */
>  
>  	log->l_ioend_workqueue = alloc_workqueue("xfs-log/%s",
> -			WQ_MEM_RECLAIM | WQ_FREEZABLE | WQ_HIGHPRI, 0,
> -			mp->m_super->s_id);
> +			XFS_WQFLAGS(WQ_FREEZABLE | WQ_MEM_RECLAIM |
> +				    WQ_HIGHPRI),
> +			0, mp->m_super->s_id);
>  	if (!log->l_ioend_workqueue)
>  		goto out_free_iclog;
>  
> diff --git a/fs/xfs/xfs_mru_cache.c b/fs/xfs/xfs_mru_cache.c
> index a06661dac5be..34c3b16f834f 100644
> --- a/fs/xfs/xfs_mru_cache.c
> +++ b/fs/xfs/xfs_mru_cache.c
> @@ -294,7 +294,7 @@ int
>  xfs_mru_cache_init(void)
>  {
>  	xfs_mru_reap_wq = alloc_workqueue("xfs_mru_cache",
> -				WQ_MEM_RECLAIM|WQ_FREEZABLE, 1);
> +			XFS_WQFLAGS(WQ_MEM_RECLAIM | WQ_FREEZABLE), 1);
>  	if (!xfs_mru_reap_wq)
>  		return -ENOMEM;
>  	return 0;
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index aed74a3fc787..8959561351ca 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -495,33 +495,37 @@ xfs_init_mount_workqueues(
>  	struct xfs_mount	*mp)
>  {
>  	mp->m_buf_workqueue = alloc_workqueue("xfs-buf/%s",
> -			WQ_MEM_RECLAIM|WQ_FREEZABLE, 1, mp->m_super->s_id);
> +			XFS_WQFLAGS(WQ_FREEZABLE | WQ_MEM_RECLAIM),
> +			1, mp->m_super->s_id);
>  	if (!mp->m_buf_workqueue)
>  		goto out;
>  
>  	mp->m_unwritten_workqueue = alloc_workqueue("xfs-conv/%s",
> -			WQ_MEM_RECLAIM|WQ_FREEZABLE, 0, mp->m_super->s_id);
> +			XFS_WQFLAGS(WQ_FREEZABLE | WQ_MEM_RECLAIM),
> +			0, mp->m_super->s_id);
>  	if (!mp->m_unwritten_workqueue)
>  		goto out_destroy_buf;
>  
>  	mp->m_cil_workqueue = alloc_workqueue("xfs-cil/%s",
> -			WQ_MEM_RECLAIM | WQ_FREEZABLE | WQ_UNBOUND,
> +			XFS_WQFLAGS(WQ_FREEZABLE | WQ_MEM_RECLAIM | WQ_UNBOUND),
>  			0, mp->m_super->s_id);
>  	if (!mp->m_cil_workqueue)
>  		goto out_destroy_unwritten;
>  
>  	mp->m_reclaim_workqueue = alloc_workqueue("xfs-reclaim/%s",
> -			WQ_MEM_RECLAIM|WQ_FREEZABLE, 0, mp->m_super->s_id);
> +			XFS_WQFLAGS(WQ_FREEZABLE | WQ_MEM_RECLAIM),
> +			0, mp->m_super->s_id);
>  	if (!mp->m_reclaim_workqueue)
>  		goto out_destroy_cil;
>  
>  	mp->m_eofblocks_workqueue = alloc_workqueue("xfs-eofblocks/%s",
> -			WQ_MEM_RECLAIM|WQ_FREEZABLE, 0, mp->m_super->s_id);
> +			XFS_WQFLAGS(WQ_FREEZABLE | WQ_MEM_RECLAIM),
> +			0, mp->m_super->s_id);
>  	if (!mp->m_eofblocks_workqueue)
>  		goto out_destroy_reclaim;
>  
> -	mp->m_sync_workqueue = alloc_workqueue("xfs-sync/%s", WQ_FREEZABLE, 0,
> -					       mp->m_super->s_id);
> +	mp->m_sync_workqueue = alloc_workqueue("xfs-sync/%s",
> +			XFS_WQFLAGS(WQ_FREEZABLE), 0, mp->m_super->s_id);
>  	if (!mp->m_sync_workqueue)
>  		goto out_destroy_eofb;
>  
> @@ -2085,11 +2089,12 @@ xfs_init_workqueues(void)
>  	 * max_active value for this workqueue.
>  	 */
>  	xfs_alloc_wq = alloc_workqueue("xfsalloc",
> -			WQ_MEM_RECLAIM|WQ_FREEZABLE, 0);
> +			XFS_WQFLAGS(WQ_MEM_RECLAIM | WQ_FREEZABLE), 0);
>  	if (!xfs_alloc_wq)
>  		return -ENOMEM;
>  
> -	xfs_discard_wq = alloc_workqueue("xfsdiscard", WQ_UNBOUND, 0);
> +	xfs_discard_wq = alloc_workqueue("xfsdiscard", XFS_WQFLAGS(WQ_UNBOUND),
> +			0);
>  	if (!xfs_discard_wq)
>  		goto out_free_alloc_wq;
>  
> diff --git a/fs/xfs/xfs_super.h b/fs/xfs/xfs_super.h
> index b552cf6d3379..1ca484b8357f 100644
> --- a/fs/xfs/xfs_super.h
> +++ b/fs/xfs/xfs_super.h
> @@ -75,6 +75,12 @@ extern void xfs_qm_exit(void);
>  				XFS_ASSERT_FATAL_STRING \
>  				XFS_DBG_STRING /* DBG must be last */
>  
> +#ifdef DEBUG
> +# define XFS_WQFLAGS(wqflags)	(WQ_SYSFS | (wqflags))
> +#else
> +# define XFS_WQFLAGS(wqflags)	(wqflags)
> +#endif
> +
>  struct xfs_inode;
>  struct xfs_mount;
>  struct xfs_buftarg;
> 

