Return-Path: <SRS0=AE4z=7E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 207A8C433E1
	for <linux-xfs@archiver.kernel.org>; Fri, 22 May 2020 12:04:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E3669206C3
	for <linux-xfs@archiver.kernel.org>; Fri, 22 May 2020 12:04:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BP+EVEIK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728979AbgEVMEB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 22 May 2020 08:04:01 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:42330 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728947AbgEVMEB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 May 2020 08:04:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590149039;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RgQnoBYkri8wEW1r9pdCzO52WLXyQnu9wILmIJhI9n4=;
        b=BP+EVEIK76B5JwLxq0j3OA1RjQnOBWGZQmyGgjqqqC7ICb/a/xM/rbrpJ8nuSn9iKiNPnK
        aJss6fWPZSBGINdqfrN8EkYzSkonVC9FDH92dlR2V2i0X5AtFG/v54DHktVyEi+pg81vwU
        jOCNXDn3a20Fg1/8rxFvr/E8iDTvDDw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-407-1mia4WGDOLeCqVyb2UJGbA-1; Fri, 22 May 2020 08:03:57 -0400
X-MC-Unique: 1mia4WGDOLeCqVyb2UJGbA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7B2BD8D8F47;
        Fri, 22 May 2020 12:03:46 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E666610013D9;
        Fri, 22 May 2020 12:03:45 +0000 (UTC)
Date:   Fri, 22 May 2020 08:03:43 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 05/12] xfs: remove flags argument from xfs_inode_ag_walk
Message-ID: <20200522120343.GF50656@bfoster>
References: <159011600616.77079.14748275956667624732.stgit@magnolia>
 <159011603978.77079.10531037194098683108.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159011603978.77079.10531037194098683108.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 21, 2020 at 07:53:59PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> The incore inode walk code passes a flags argument and a pointer from
> the xfs_inode_ag_iterator caller all the way to the iteration function.
> We can reduce the function complexity by passing flags through the
> private pointer.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_icache.c      |   43 +++++++++++++++++--------------------------
>  fs/xfs/xfs_icache.h      |    4 ++--
>  fs/xfs/xfs_qm_syscalls.c |   15 ++++++++-------
>  3 files changed, 27 insertions(+), 35 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index 6d7f3014d547..53c6cc7bc02a 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -790,9 +790,7 @@ STATIC int
>  xfs_inode_ag_walk(
>  	struct xfs_mount	*mp,
>  	struct xfs_perag	*pag,
> -	int			(*execute)(struct xfs_inode *ip, int flags,
> -					   void *args),
> -	int			flags,
> +	int			(*execute)(struct xfs_inode *ip, void *args),
>  	void			*args,
>  	int			tag,
>  	int			iter_flags)
> @@ -868,7 +866,7 @@ xfs_inode_ag_walk(
>  			if ((iter_flags & XFS_AGITER_INEW_WAIT) &&
>  			    xfs_iflags_test(batch[i], XFS_INEW))
>  				xfs_inew_wait(batch[i]);
> -			error = execute(batch[i], flags, args);
> +			error = execute(batch[i], args);
>  			xfs_irele(batch[i]);
>  			if (error == -EAGAIN) {
>  				skipped++;
> @@ -972,9 +970,7 @@ int
>  xfs_inode_ag_iterator(
>  	struct xfs_mount	*mp,
>  	int			iter_flags,
> -	int			(*execute)(struct xfs_inode *ip, int flags,
> -					   void *args),
> -	int			flags,
> +	int			(*execute)(struct xfs_inode *ip, void *args),
>  	void			*args,
>  	int			tag)
>  {
> @@ -986,7 +982,7 @@ xfs_inode_ag_iterator(
>  	ag = 0;
>  	while ((pag = xfs_inode_walk_get_perag(mp, ag, tag))) {
>  		ag = pag->pag_agno + 1;
> -		error = xfs_inode_ag_walk(mp, pag, execute, flags, args, tag,
> +		error = xfs_inode_ag_walk(mp, pag, execute, args, tag,
>  				iter_flags);
>  		xfs_perag_put(pag);
>  		if (error) {
> @@ -1443,12 +1439,14 @@ xfs_inode_match_id_union(
>  STATIC int
>  xfs_inode_free_eofblocks(
>  	struct xfs_inode	*ip,
> -	int			flags,
>  	void			*args)
>  {
> -	int ret = 0;
> -	struct xfs_eofblocks *eofb = args;
> -	int match;
> +	struct xfs_eofblocks	*eofb = args;
> +	bool			wait;
> +	int			match;
> +	int			ret;
> +
> +	wait = eofb && (eofb->eof_flags & XFS_EOF_FLAGS_SYNC);
>  
>  	if (!xfs_can_free_eofblocks(ip, false)) {
>  		/* inode could be preallocated or append-only */
> @@ -1461,8 +1459,7 @@ xfs_inode_free_eofblocks(
>  	 * If the mapping is dirty the operation can block and wait for some
>  	 * time. Unless we are waiting, skip it.
>  	 */
> -	if (!(flags & SYNC_WAIT) &&
> -	    mapping_tagged(VFS_I(ip)->i_mapping, PAGECACHE_TAG_DIRTY))
> +	if (!wait && mapping_tagged(VFS_I(ip)->i_mapping, PAGECACHE_TAG_DIRTY))
>  		return 0;
>  
>  	if (eofb) {
> @@ -1484,10 +1481,11 @@ xfs_inode_free_eofblocks(
>  	 * scanner moving and revisit the inode in a subsequent pass.
>  	 */
>  	if (!xfs_ilock_nowait(ip, XFS_IOLOCK_EXCL)) {
> -		if (flags & SYNC_WAIT)
> -			ret = -EAGAIN;
> -		return ret;
> +		if (wait)
> +			return -EAGAIN;
> +		return 0;
>  	}
> +
>  	ret = xfs_free_eofblocks(ip);
>  	xfs_iunlock(ip, XFS_IOLOCK_EXCL);
>  
> @@ -1498,16 +1496,10 @@ static int
>  __xfs_icache_free_eofblocks(
>  	struct xfs_mount	*mp,
>  	struct xfs_eofblocks	*eofb,
> -	int			(*execute)(struct xfs_inode *ip, int flags,
> -					   void *args),
> +	int			(*execute)(struct xfs_inode *ip, void *args),
>  	int			tag)
>  {
> -	int flags = SYNC_TRYLOCK;
> -
> -	if (eofb && (eofb->eof_flags & XFS_EOF_FLAGS_SYNC))
> -		flags = SYNC_WAIT;
> -
> -	return xfs_inode_ag_iterator(mp, 0, execute, flags, eofb, tag);
> +	return xfs_inode_ag_iterator(mp, 0, execute, eofb, tag);
>  }
>  
>  int
> @@ -1732,7 +1724,6 @@ xfs_prep_free_cowblocks(
>  STATIC int
>  xfs_inode_free_cowblocks(
>  	struct xfs_inode	*ip,
> -	int			flags,
>  	void			*args)
>  {
>  	struct xfs_eofblocks	*eofb = args;
> diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
> index 2d5ab9957d9f..e7f86ebd7b22 100644
> --- a/fs/xfs/xfs_icache.h
> +++ b/fs/xfs/xfs_icache.h
> @@ -72,8 +72,8 @@ void xfs_cowblocks_worker(struct work_struct *);
>  void xfs_queue_cowblocks(struct xfs_mount *);
>  
>  int xfs_inode_ag_iterator(struct xfs_mount *mp, int iter_flags,
> -	int (*execute)(struct xfs_inode *ip, int flags, void *args),
> -	int flags, void *args, int tag);
> +	int (*execute)(struct xfs_inode *ip, void *args),
> +	void *args, int tag);
>  
>  int xfs_icache_inode_is_allocated(struct xfs_mount *mp, struct xfs_trans *tp,
>  				  xfs_ino_t ino, bool *inuse);
> diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
> index a9460bdcca87..4b61a683a43e 100644
> --- a/fs/xfs/xfs_qm_syscalls.c
> +++ b/fs/xfs/xfs_qm_syscalls.c
> @@ -729,9 +729,10 @@ xfs_qm_scall_getquota_next(
>  STATIC int
>  xfs_dqrele_inode(
>  	struct xfs_inode	*ip,
> -	int			flags,
>  	void			*args)
>  {
> +	uint			*flags = args;
> +
>  	/* skip quota inodes */
>  	if (ip == ip->i_mount->m_quotainfo->qi_uquotaip ||
>  	    ip == ip->i_mount->m_quotainfo->qi_gquotaip ||
> @@ -743,15 +744,15 @@ xfs_dqrele_inode(
>  	}
>  
>  	xfs_ilock(ip, XFS_ILOCK_EXCL);
> -	if ((flags & XFS_UQUOTA_ACCT) && ip->i_udquot) {
> +	if ((*flags & XFS_UQUOTA_ACCT) && ip->i_udquot) {
>  		xfs_qm_dqrele(ip->i_udquot);
>  		ip->i_udquot = NULL;
>  	}
> -	if ((flags & XFS_GQUOTA_ACCT) && ip->i_gdquot) {
> +	if ((*flags & XFS_GQUOTA_ACCT) && ip->i_gdquot) {
>  		xfs_qm_dqrele(ip->i_gdquot);
>  		ip->i_gdquot = NULL;
>  	}
> -	if ((flags & XFS_PQUOTA_ACCT) && ip->i_pdquot) {
> +	if ((*flags & XFS_PQUOTA_ACCT) && ip->i_pdquot) {
>  		xfs_qm_dqrele(ip->i_pdquot);
>  		ip->i_pdquot = NULL;
>  	}
> @@ -768,10 +769,10 @@ xfs_dqrele_inode(
>   */
>  void
>  xfs_qm_dqrele_all_inodes(
> -	struct xfs_mount *mp,
> -	uint		 flags)
> +	struct xfs_mount	*mp,
> +	uint			flags)
>  {
>  	ASSERT(mp->m_quotainfo);
>  	xfs_inode_ag_iterator(mp, XFS_AGITER_INEW_WAIT, xfs_dqrele_inode,
> -			flags, NULL, XFS_ICI_NO_TAG);
> +			&flags, XFS_ICI_NO_TAG);
>  }
> 

