Return-Path: <SRS0=AE4z=7E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14832C433E0
	for <linux-xfs@archiver.kernel.org>; Fri, 22 May 2020 12:03:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DDD482072C
	for <linux-xfs@archiver.kernel.org>; Fri, 22 May 2020 12:03:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DncpowMM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728871AbgEVMD4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 22 May 2020 08:03:56 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:42568 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728544AbgEVMD4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 May 2020 08:03:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590149034;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wAjKsfEwIAed1evunRE3IPjC/f/LA9oymp03bCDVAMs=;
        b=DncpowMM5NnzlzLec+sWX9rE3Bhzxe/jCJ8+yU7To1XtZgLUVqjatjb/+Lr9LgExUF6k5o
        f3euYdNzTZVL+gQGf/xMk/LpndZ5JvR0D6hcZL0IYXTCX5fWE4fOcw5C1WvRcpSE+dd0cP
        LmT3mcsZ1Z+KTuRsKkh7C/C61ICO2iw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-115-Inzx_LcEMk2IM84dXtQB9A-1; Fri, 22 May 2020 08:03:50 -0400
X-MC-Unique: Inzx_LcEMk2IM84dXtQB9A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9BEC4E095E;
        Fri, 22 May 2020 12:03:38 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2D3EA10013D9;
        Fri, 22 May 2020 12:03:38 +0000 (UTC)
Date:   Fri, 22 May 2020 08:03:36 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/12] xfs: remove xfs_inode_ag_iterator_flags
Message-ID: <20200522120336.GE50656@bfoster>
References: <159011600616.77079.14748275956667624732.stgit@magnolia>
 <159011603321.77079.320022599197428040.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159011603321.77079.320022599197428040.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 21, 2020 at 07:53:53PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Combine xfs_inode_ag_iterator_flags and xfs_inode_ag_iterator_tag into a
> single wrapper function since there's only one caller of the _flags
> variant.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_icache.c      |   43 +++++++++++++------------------------------
>  fs/xfs/xfs_icache.h      |    5 +----
>  fs/xfs/xfs_qm_syscalls.c |    4 ++--
>  3 files changed, 16 insertions(+), 36 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index 6aafb547f21a..6d7f3014d547 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -956,38 +956,22 @@ xfs_cowblocks_worker(
>  	xfs_queue_cowblocks(mp);
>  }
>  
> -int
> -xfs_inode_ag_iterator_flags(
> +/* Fetch the next (possibly tagged) per-AG structure. */
> +static inline struct xfs_perag *
> +xfs_inode_walk_get_perag(
>  	struct xfs_mount	*mp,
> -	int			(*execute)(struct xfs_inode *ip, int flags,
> -					   void *args),
> -	int			flags,
> -	void			*args,
> -	int			iter_flags)
> +	xfs_agnumber_t		agno,
> +	int			tag)
>  {
> -	struct xfs_perag	*pag;
> -	int			error = 0;
> -	int			last_error = 0;
> -	xfs_agnumber_t		ag;
> -
> -	ag = 0;
> -	while ((pag = xfs_perag_get(mp, ag))) {
> -		ag = pag->pag_agno + 1;
> -		error = xfs_inode_ag_walk(mp, pag, execute, flags, args,
> -				XFS_ICI_NO_TAG, iter_flags);
> -		xfs_perag_put(pag);
> -		if (error) {
> -			last_error = error;
> -			if (error == -EFSCORRUPTED)
> -				break;
> -		}
> -	}
> -	return last_error;
> +	if (tag == XFS_ICI_NO_TAG)
> +		return xfs_perag_get(mp, agno);
> +	return xfs_perag_get_tag(mp, agno, tag);
>  }
>  
>  int
> -xfs_inode_ag_iterator_tag(
> +xfs_inode_ag_iterator(
>  	struct xfs_mount	*mp,
> +	int			iter_flags,
>  	int			(*execute)(struct xfs_inode *ip, int flags,
>  					   void *args),
>  	int			flags,
> @@ -1000,10 +984,10 @@ xfs_inode_ag_iterator_tag(
>  	xfs_agnumber_t		ag;
>  
>  	ag = 0;
> -	while ((pag = xfs_perag_get_tag(mp, ag, tag))) {
> +	while ((pag = xfs_inode_walk_get_perag(mp, ag, tag))) {
>  		ag = pag->pag_agno + 1;
>  		error = xfs_inode_ag_walk(mp, pag, execute, flags, args, tag,
> -					  0);
> +				iter_flags);
>  		xfs_perag_put(pag);
>  		if (error) {
>  			last_error = error;
> @@ -1523,8 +1507,7 @@ __xfs_icache_free_eofblocks(
>  	if (eofb && (eofb->eof_flags & XFS_EOF_FLAGS_SYNC))
>  		flags = SYNC_WAIT;
>  
> -	return xfs_inode_ag_iterator_tag(mp, execute, flags,
> -					 eofb, tag);
> +	return xfs_inode_ag_iterator(mp, 0, execute, flags, eofb, tag);
>  }
>  
>  int
> diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
> index 0556fa32074f..2d5ab9957d9f 100644
> --- a/fs/xfs/xfs_icache.h
> +++ b/fs/xfs/xfs_icache.h
> @@ -71,10 +71,7 @@ int xfs_inode_free_quota_cowblocks(struct xfs_inode *ip);
>  void xfs_cowblocks_worker(struct work_struct *);
>  void xfs_queue_cowblocks(struct xfs_mount *);
>  
> -int xfs_inode_ag_iterator_flags(struct xfs_mount *mp,
> -	int (*execute)(struct xfs_inode *ip, int flags, void *args),
> -	int flags, void *args, int iter_flags);
> -int xfs_inode_ag_iterator_tag(struct xfs_mount *mp,
> +int xfs_inode_ag_iterator(struct xfs_mount *mp, int iter_flags,
>  	int (*execute)(struct xfs_inode *ip, int flags, void *args),
>  	int flags, void *args, int tag);
>  
> diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
> index 5d5ac65aa1cc..a9460bdcca87 100644
> --- a/fs/xfs/xfs_qm_syscalls.c
> +++ b/fs/xfs/xfs_qm_syscalls.c
> @@ -772,6 +772,6 @@ xfs_qm_dqrele_all_inodes(
>  	uint		 flags)
>  {
>  	ASSERT(mp->m_quotainfo);
> -	xfs_inode_ag_iterator_flags(mp, xfs_dqrele_inode, flags, NULL,
> -				    XFS_AGITER_INEW_WAIT);
> +	xfs_inode_ag_iterator(mp, XFS_AGITER_INEW_WAIT, xfs_dqrele_inode,
> +			flags, NULL, XFS_ICI_NO_TAG);
>  }
> 

