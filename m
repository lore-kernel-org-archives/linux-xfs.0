Return-Path: <SRS0=AE4z=7E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10A04C433DF
	for <linux-xfs@archiver.kernel.org>; Fri, 22 May 2020 12:24:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D410720759
	for <linux-xfs@archiver.kernel.org>; Fri, 22 May 2020 12:23:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="h7r5illm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728987AbgEVMX7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 22 May 2020 08:23:59 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:53748 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728409AbgEVMX7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 May 2020 08:23:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590150237;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/UuIliNZ68X8xhJcL83tGfJtRUJzhTf1EMLDsK+tHgM=;
        b=h7r5illmCEKPoKRUI6WHozwXy5L0PA3NqV62HOqf6RLIz63PYE5KnQ2gYGhhuC9ktRuPAT
        4lE2bFMljTr01O8i4VbteoAx5ZbG+j7V7LXTT62gBxThniMkqg2ZjSb4tMj8vrn/IaQGT6
        DnZaCj5Vb0lrJzmt3tC0L/H91mqbRLA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-502-Gvtz8cLGMdiU7CIORnPt1g-1; Fri, 22 May 2020 08:23:55 -0400
X-MC-Unique: Gvtz8cLGMdiU7CIORnPt1g-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 575B4835B40;
        Fri, 22 May 2020 12:23:54 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DCDF6100239B;
        Fri, 22 May 2020 12:23:53 +0000 (UTC)
Date:   Fri, 22 May 2020 08:23:52 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 11/12] xfs: straighten out all the naming around incore
 inode tree walks
Message-ID: <20200522122352.GL50656@bfoster>
References: <159011600616.77079.14748275956667624732.stgit@magnolia>
 <159011607872.77079.14383762107157416126.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159011607872.77079.14383762107157416126.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 21, 2020 at 07:54:38PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> We're not very consistent about function names for the incore inode
> iteration function.  Turn them all into xfs_inode_walk* variants.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Seems reasonable:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_icache.c      |   18 +++++++++---------
>  fs/xfs/xfs_icache.h      |    6 +++---
>  fs/xfs/xfs_qm_syscalls.c |    2 +-
>  3 files changed, 13 insertions(+), 13 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index 0e25d50372e2..baf59087caa5 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -747,12 +747,12 @@ xfs_icache_inode_is_allocated(
>   * ignore it.
>   */
>  STATIC bool
> -xfs_inode_ag_walk_grab(
> +xfs_inode_walk_ag_grab(
>  	struct xfs_inode	*ip,
>  	int			flags)
>  {
>  	struct inode		*inode = VFS_I(ip);
> -	bool			newinos = !!(flags & XFS_AGITER_INEW_WAIT);
> +	bool			newinos = !!(flags & XFS_INODE_WALK_INEW_WAIT);
>  
>  	ASSERT(rcu_read_lock_held());
>  
> @@ -796,7 +796,7 @@ xfs_inode_ag_walk_grab(
>   * inodes with the given radix tree @tag.
>   */
>  STATIC int
> -xfs_inode_ag_walk(
> +xfs_inode_walk_ag(
>  	struct xfs_mount	*mp,
>  	struct xfs_perag	*pag,
>  	int			(*execute)(struct xfs_inode *ip, void *args),
> @@ -844,7 +844,7 @@ xfs_inode_ag_walk(
>  		for (i = 0; i < nr_found; i++) {
>  			struct xfs_inode *ip = batch[i];
>  
> -			if (done || !xfs_inode_ag_walk_grab(ip, iter_flags))
> +			if (done || !xfs_inode_walk_ag_grab(ip, iter_flags))
>  				batch[i] = NULL;
>  
>  			/*
> @@ -872,7 +872,7 @@ xfs_inode_ag_walk(
>  		for (i = 0; i < nr_found; i++) {
>  			if (!batch[i])
>  				continue;
> -			if ((iter_flags & XFS_AGITER_INEW_WAIT) &&
> +			if ((iter_flags & XFS_INODE_WALK_INEW_WAIT) &&
>  			    xfs_iflags_test(batch[i], XFS_INEW))
>  				xfs_inew_wait(batch[i]);
>  			error = execute(batch[i], args);
> @@ -917,7 +917,7 @@ xfs_inode_walk_get_perag(
>   * @tag.
>   */
>  int
> -xfs_inode_ag_iterator(
> +xfs_inode_walk(
>  	struct xfs_mount	*mp,
>  	int			iter_flags,
>  	int			(*execute)(struct xfs_inode *ip, void *args),
> @@ -932,7 +932,7 @@ xfs_inode_ag_iterator(
>  	ag = 0;
>  	while ((pag = xfs_inode_walk_get_perag(mp, ag, tag))) {
>  		ag = pag->pag_agno + 1;
> -		error = xfs_inode_ag_walk(mp, pag, execute, args, tag,
> +		error = xfs_inode_walk_ag(mp, pag, execute, args, tag,
>  				iter_flags);
>  		xfs_perag_put(pag);
>  		if (error) {
> @@ -1528,7 +1528,7 @@ xfs_icache_free_eofblocks(
>  	struct xfs_mount	*mp,
>  	struct xfs_eofblocks	*eofb)
>  {
> -	return xfs_inode_ag_iterator(mp, 0, xfs_inode_free_eofblocks, eofb,
> +	return xfs_inode_walk(mp, 0, xfs_inode_free_eofblocks, eofb,
>  			XFS_ICI_EOFBLOCKS_TAG);
>  }
>  
> @@ -1778,7 +1778,7 @@ xfs_icache_free_cowblocks(
>  	struct xfs_mount	*mp,
>  	struct xfs_eofblocks	*eofb)
>  {
> -	return xfs_inode_ag_iterator(mp, 0, xfs_inode_free_cowblocks, eofb,
> +	return xfs_inode_walk(mp, 0, xfs_inode_free_cowblocks, eofb,
>  			XFS_ICI_COWBLOCKS_TAG);
>  }
>  
> diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
> index e7f86ebd7b22..93b54e7d55f0 100644
> --- a/fs/xfs/xfs_icache.h
> +++ b/fs/xfs/xfs_icache.h
> @@ -24,7 +24,7 @@ struct xfs_eofblocks {
>   * tags for inode radix tree
>   */
>  #define XFS_ICI_NO_TAG		(-1)	/* special flag for an untagged lookup
> -					   in xfs_inode_ag_iterator */
> +					   in xfs_inode_walk */
>  #define XFS_ICI_RECLAIM_TAG	0	/* inode is to be reclaimed */
>  #define XFS_ICI_EOFBLOCKS_TAG	1	/* inode has blocks beyond EOF */
>  #define XFS_ICI_COWBLOCKS_TAG	2	/* inode can have cow blocks to gc */
> @@ -40,7 +40,7 @@ struct xfs_eofblocks {
>  /*
>   * flags for AG inode iterator
>   */
> -#define XFS_AGITER_INEW_WAIT	0x1	/* wait on new inodes */
> +#define XFS_INODE_WALK_INEW_WAIT	0x1	/* wait on new inodes */
>  
>  int xfs_iget(struct xfs_mount *mp, struct xfs_trans *tp, xfs_ino_t ino,
>  	     uint flags, uint lock_flags, xfs_inode_t **ipp);
> @@ -71,7 +71,7 @@ int xfs_inode_free_quota_cowblocks(struct xfs_inode *ip);
>  void xfs_cowblocks_worker(struct work_struct *);
>  void xfs_queue_cowblocks(struct xfs_mount *);
>  
> -int xfs_inode_ag_iterator(struct xfs_mount *mp, int iter_flags,
> +int xfs_inode_walk(struct xfs_mount *mp, int iter_flags,
>  	int (*execute)(struct xfs_inode *ip, void *args),
>  	void *args, int tag);
>  
> diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
> index 4b61a683a43e..e8b63af93eb5 100644
> --- a/fs/xfs/xfs_qm_syscalls.c
> +++ b/fs/xfs/xfs_qm_syscalls.c
> @@ -773,6 +773,6 @@ xfs_qm_dqrele_all_inodes(
>  	uint			flags)
>  {
>  	ASSERT(mp->m_quotainfo);
> -	xfs_inode_ag_iterator(mp, XFS_AGITER_INEW_WAIT, xfs_dqrele_inode,
> +	xfs_inode_walk(mp, XFS_INODE_WALK_INEW_WAIT, xfs_dqrele_inode,
>  			&flags, XFS_ICI_NO_TAG);
>  }
> 

