Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr1-f68.google.com ([209.85.221.68]:36335 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387575AbeHANtQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Aug 2018 09:49:16 -0400
Received: by mail-wr1-f68.google.com with SMTP id h9-v6so19862115wro.3
        for <linux-xfs@vger.kernel.org>; Wed, 01 Aug 2018 05:03:47 -0700 (PDT)
Date: Wed, 1 Aug 2018 14:03:44 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH] xfs: refactor log recovery check
Message-ID: <20180801120344.v7blohxao7j6gisg@odin.usersys.redhat.com>
References: <20180801000622.GA30972@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180801000622.GA30972@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>

On Tue, Jul 31, 2018 at 05:06:22PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Add a predicate to decide if the log is actively in recovery and use
> that instead of open-coding a pagf_init check in the attr leaf verifier.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Sounds good

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
>  fs/xfs/libxfs/xfs_attr_leaf.c |    3 +--
>  fs/xfs/xfs_log.c              |    9 +++++++++
>  fs/xfs/xfs_log.h              |    1 +
>  3 files changed, 11 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index 4e7ef79a83c7..6fc5425b1474 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -242,7 +242,6 @@ xfs_attr3_leaf_verify(
>  	struct xfs_attr3_icleaf_hdr	ichdr;
>  	struct xfs_mount		*mp = bp->b_target->bt_mount;
>  	struct xfs_attr_leafblock	*leaf = bp->b_addr;
> -	struct xfs_perag		*pag = bp->b_pag;
>  	struct xfs_attr_leaf_entry	*entries;
>  	uint16_t			end;
>  	int				i;
> @@ -270,7 +269,7 @@ xfs_attr3_leaf_verify(
>  	 * because we may have transitioned an empty shortform attr to a leaf
>  	 * if the attr didn't fit in shortform.
>  	 */
> -	if (pag && pag->pagf_init && ichdr.count == 0)
> +	if (!xfs_log_in_recovery(mp) && ichdr.count == 0)
>  		return __this_address;
>  
>  	/*
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index fd10b1426382..00df4f39093a 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -4104,3 +4104,12 @@ xfs_log_check_lsn(
>  
>  	return valid;
>  }
> +
> +bool
> +xfs_log_in_recovery(
> +	struct xfs_mount	*mp)
> +{
> +	struct xlog		*log = mp->m_log;
> +
> +	return log->l_flags & XLOG_ACTIVE_RECOVERY;
> +}
> diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
> index 3c1f6a8b4b70..73a64bf32f6f 100644
> --- a/fs/xfs/xfs_log.h
> +++ b/fs/xfs/xfs_log.h
> @@ -153,5 +153,6 @@ bool	xfs_log_item_in_current_chkpt(struct xfs_log_item *lip);
>  void	xfs_log_work_queue(struct xfs_mount *mp);
>  void	xfs_log_quiesce(struct xfs_mount *mp);
>  bool	xfs_log_check_lsn(struct xfs_mount *, xfs_lsn_t);
> +bool	xfs_log_in_recovery(struct xfs_mount *);
>  
>  #endif	/* __XFS_LOG_H__ */

-- 
Carlos
