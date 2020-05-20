Return-Path: <SRS0=A2Vo=7C=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7FE1C433DF
	for <linux-xfs@archiver.kernel.org>; Wed, 20 May 2020 06:38:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 99890205CB
	for <linux-xfs@archiver.kernel.org>; Wed, 20 May 2020 06:38:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726224AbgETGi2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 May 2020 02:38:28 -0400
Received: from verein.lst.de ([213.95.11.211]:47915 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725998AbgETGi2 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 20 May 2020 02:38:28 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 3DEDA68B02; Wed, 20 May 2020 08:38:25 +0200 (CEST)
Date:   Wed, 20 May 2020 08:38:25 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 05/11] xfs: remove flags argument from xfs_inode_ag_walk
Message-ID: <20200520063825.GE2742@lst.de>
References: <158993911808.976105.13679179790848338795.stgit@magnolia> <158993914950.976105.8586367797907212993.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158993914950.976105.8586367797907212993.stgit@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 19, 2020 at 06:45:49PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> The incore inode walk code passes a flags argument and a pointer from
> the xfs_inode_ag_iterator caller all the way to the iteration function.
> We can reduce the function complexity by passing flags through the
> private pointer.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_icache.c      |   38 ++++++++++++++------------------------
>  fs/xfs/xfs_icache.h      |    4 ++--
>  fs/xfs/xfs_qm_syscalls.c |   25 +++++++++++++++++--------
>  3 files changed, 33 insertions(+), 34 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index e716b19879c6..87b98bfdf27d 100644
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
>  	while ((pag = xfs_ici_walk_get_perag(mp, ag, tag))) {
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
> +	int			ret = 0;
> +
> +	wait = (eofb && (eofb->eof_flags & XFS_EOF_FLAGS_SYNC));

No need for the outer braces.

> @@ -1484,7 +1481,7 @@ xfs_inode_free_eofblocks(
>  	 * scanner moving and revisit the inode in a subsequent pass.
>  	 */
>  	if (!xfs_ilock_nowait(ip, XFS_IOLOCK_EXCL)) {
> -		if (flags & SYNC_WAIT)
> +		if (wait)
>  			ret = -EAGAIN;
>  		return ret;

Just me, but I'd prefer an explicit:

		if (wait)
			return -EAGAIN;
		return 0;

here.  Not really new in this patch, but if you touch this area anyway..

> index a9460bdcca87..571ecb17b3bf 100644
> --- a/fs/xfs/xfs_qm_syscalls.c
> +++ b/fs/xfs/xfs_qm_syscalls.c
> @@ -726,12 +726,17 @@ xfs_qm_scall_getquota_next(
>  	return error;
>  }
>  
> +struct xfs_dqrele {
> +	uint		flags;
> +};

> +	struct xfs_dqrele	dqr = {
> +		.flags		= flags,
> +	};

Instead of a new structure we could just take the address of flags and
pass that to simplify the code a bit.
