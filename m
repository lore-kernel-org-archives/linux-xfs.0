Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CDB3C433E6
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Feb 2021 15:44:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EC15D64F4B
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Feb 2021 15:44:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235107AbhBBPoL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Feb 2021 10:44:11 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:51196 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235626AbhBBPkk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Feb 2021 10:40:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612280353;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8LUGO5ujYJqGZ9hLqZxa3wpXflZ1vYiyQ3HDA+txbFw=;
        b=O2nf4BKZ81mDsvxldsq8RtvJPqm7fzwYQKaTLhPhK2tv4MzhXbmcMGcbS75ax5wOjeKlrb
        UvEo9ok89XIIimbpC69PBMphKXlPk8xjMekl6qFVenIC9iTfJ/6tR1e8btSlqDQEGl17sS
        kYp5usmgraqZ9AFKTA5zWr7gDO0HSPc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-294-AGuyM_2mOeOc6i8NgyJ8Lw-1; Tue, 02 Feb 2021 10:39:11 -0500
X-MC-Unique: AGuyM_2mOeOc6i8NgyJ8Lw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A241F835E21;
        Tue,  2 Feb 2021 15:39:10 +0000 (UTC)
Received: from bfoster (ovpn-114-23.rdu2.redhat.com [10.10.114.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0BFB45C5FC;
        Tue,  2 Feb 2021 15:39:09 +0000 (UTC)
Date:   Tue, 2 Feb 2021 10:39:08 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com
Subject: Re: [PATCH 08/12] xfs: flush eof/cowblocks if we can't reserve quota
 for inode creation
Message-ID: <20210202153908.GH3336100@bfoster>
References: <161214512641.140945.11651856181122264773.stgit@magnolia>
 <161214517156.140945.6151197680730753044.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161214517156.140945.6151197680730753044.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Jan 31, 2021 at 06:06:11PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> If an inode creation is unable to reserve enough quota to handle the
> modification, try clearing whatever space the filesystem might have been
> hanging onto in the hopes of speeding up the filesystem.  The flushing
> behavior will become particularly important when we add deferred inode
> inactivation because that will increase the amount of space that isn't
> actively tied to user data.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_icache.c |   73 ++++++++++++++++++++++++++++++---------------------
>  fs/xfs/xfs_icache.h |    2 +
>  fs/xfs/xfs_trans.c  |    8 ++++++
>  3 files changed, 53 insertions(+), 30 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index 4a074aa12b52..cd369dd48818 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -1646,64 +1646,77 @@ xfs_start_block_reaping(
>  }
>  
>  /*
> - * Run cow/eofblocks scans on the quotas applicable to the inode. For inodes
> - * with multiple quotas, we don't know exactly which quota caused an allocation
> - * failure. We make a best effort by including each quota under low free space
> - * conditions (less than 1% free space) in the scan.
> + * Run cow/eofblocks scans on the supplied dquots.  We don't know exactly which
> + * quota caused an allocation failure, so we make a best effort by including
> + * each quota under low free space conditions (less than 1% free space) in the
> + * scan.
>   *
>   * Callers must not hold any inode's ILOCK.  If requesting a synchronous scan
>   * (XFS_EOF_FLAGS_SYNC), the caller also must not hold any inode's IOLOCK or
>   * MMAPLOCK.
>   */
>  int
> -xfs_blockgc_free_quota(
> -	struct xfs_inode	*ip,
> +xfs_blockgc_free_dquots(
> +	struct xfs_dquot	*udqp,
> +	struct xfs_dquot	*gdqp,
> +	struct xfs_dquot	*pdqp,
>  	unsigned int		eof_flags)
>  {
>  	struct xfs_eofblocks	eofb = {0};
> -	struct xfs_dquot	*dq;
> +	struct xfs_mount	*mp = NULL;
>  	bool			do_work = false;
>  	int			error;
>  
> +	if (!udqp && !gdqp && !pdqp)
> +		return 0;
> +	if (udqp)
> +		mp = udqp->q_mount;
> +	if (!mp && gdqp)
> +		mp = gdqp->q_mount;
> +	if (!mp && pdqp)
> +		mp = pdqp->q_mount;
> +
>  	/*
>  	 * Run a scan to free blocks using the union filter to cover all
>  	 * applicable quotas in a single scan.
>  	 */
>  	eofb.eof_flags = XFS_EOF_FLAGS_UNION | eof_flags;
>  
> -	if (XFS_IS_UQUOTA_ENFORCED(ip->i_mount)) {
> -		dq = xfs_inode_dquot(ip, XFS_DQTYPE_USER);
> -		if (dq && xfs_dquot_lowsp(dq)) {
> -			eofb.eof_uid = VFS_I(ip)->i_uid;
> -			eofb.eof_flags |= XFS_EOF_FLAGS_UID;
> -			do_work = true;
> -		}
> +	if (XFS_IS_UQUOTA_ENFORCED(mp) && udqp && xfs_dquot_lowsp(udqp)) {
> +		eofb.eof_uid = make_kuid(mp->m_super->s_user_ns, udqp->q_id);
> +		eofb.eof_flags |= XFS_EOF_FLAGS_UID;
> +		do_work = true;
>  	}
>  
> -	if (XFS_IS_GQUOTA_ENFORCED(ip->i_mount)) {
> -		dq = xfs_inode_dquot(ip, XFS_DQTYPE_GROUP);
> -		if (dq && xfs_dquot_lowsp(dq)) {
> -			eofb.eof_gid = VFS_I(ip)->i_gid;
> -			eofb.eof_flags |= XFS_EOF_FLAGS_GID;
> -			do_work = true;
> -		}
> +	if (XFS_IS_UQUOTA_ENFORCED(mp) && gdqp && xfs_dquot_lowsp(gdqp)) {
> +		eofb.eof_gid = make_kgid(mp->m_super->s_user_ns, gdqp->q_id);
> +		eofb.eof_flags |= XFS_EOF_FLAGS_GID;
> +		do_work = true;
>  	}
>  
> -	if (XFS_IS_PQUOTA_ENFORCED(ip->i_mount)) {
> -		dq = xfs_inode_dquot(ip, XFS_DQTYPE_PROJ);
> -		if (dq && xfs_dquot_lowsp(dq)) {
> -			eofb.eof_prid = ip->i_d.di_projid;
> -			eofb.eof_flags |= XFS_EOF_FLAGS_PRID;
> -			do_work = true;
> -		}
> +	if (XFS_IS_PQUOTA_ENFORCED(mp) && pdqp && xfs_dquot_lowsp(pdqp)) {
> +		eofb.eof_prid = pdqp->q_id;
> +		eofb.eof_flags |= XFS_EOF_FLAGS_PRID;
> +		do_work = true;
>  	}
>  
>  	if (!do_work)
>  		return 0;
>  
> -	error = xfs_icache_free_eofblocks(ip->i_mount, &eofb);
> +	error = xfs_icache_free_eofblocks(mp, &eofb);
>  	if (error)
>  		return error;
>  
> -	return xfs_icache_free_cowblocks(ip->i_mount, &eofb);
> +	return xfs_icache_free_cowblocks(mp, &eofb);
> +}
> +
> +/* Run cow/eofblocks scans on the quotas attached to the inode. */
> +int
> +xfs_blockgc_free_quota(
> +	struct xfs_inode	*ip,
> +	unsigned int		eof_flags)
> +{
> +	return xfs_blockgc_free_dquots(xfs_inode_dquot(ip, XFS_DQTYPE_USER),
> +			xfs_inode_dquot(ip, XFS_DQTYPE_GROUP),
> +			xfs_inode_dquot(ip, XFS_DQTYPE_PROJ), eof_flags);
>  }
> diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
> index d64ea8f5c589..5f520de637f6 100644
> --- a/fs/xfs/xfs_icache.h
> +++ b/fs/xfs/xfs_icache.h
> @@ -54,6 +54,8 @@ long xfs_reclaim_inodes_nr(struct xfs_mount *mp, int nr_to_scan);
>  
>  void xfs_inode_set_reclaim_tag(struct xfs_inode *ip);
>  
> +int xfs_blockgc_free_dquots(struct xfs_dquot *udqp, struct xfs_dquot *gdqp,
> +		struct xfs_dquot *pdqp, unsigned int eof_flags);
>  int xfs_blockgc_free_quota(struct xfs_inode *ip, unsigned int eof_flags);
>  
>  void xfs_inode_set_eofblocks_tag(struct xfs_inode *ip);
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index f62c1c5f210f..ee3cb916c5c9 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -1102,13 +1102,21 @@ xfs_trans_alloc_icreate(
>  	struct xfs_trans	**tpp)
>  {
>  	struct xfs_trans	*tp;
> +	bool			retried = false;
>  	int			error;
>  
> +retry:
>  	error = xfs_trans_alloc(mp, resv, dblocks, 0, 0, &tp);
>  	if (error)
>  		return error;
>  
>  	error = xfs_trans_reserve_quota_icreate(tp, udqp, gdqp, pdqp, dblocks);
> +	if (!retried && (error == -EDQUOT || error == -ENOSPC)) {
> +		xfs_trans_cancel(tp);
> +		xfs_blockgc_free_dquots(udqp, gdqp, pdqp, 0);
> +		retried = true;
> +		goto retry;
> +	}
>  	if (error) {
>  		xfs_trans_cancel(tp);
>  		return error;
> 

