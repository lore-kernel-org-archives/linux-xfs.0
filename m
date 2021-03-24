Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B059CC433C1
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Mar 2021 17:51:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 83A2961A1D
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Mar 2021 17:51:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237299AbhCXRvQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Mar 2021 13:51:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:60422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237329AbhCXRuy (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 24 Mar 2021 13:50:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 41E6E619F9;
        Wed, 24 Mar 2021 17:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616608254;
        bh=kjwRWJj6g2Fi1SNSxXyjgAiO6rUKlhPr0SBC3BPkIs0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VojcD0uZOhVwMhjgOTo3zjn3VE5uo0EPVozj+OLg19C0TyUF3ppAHRRHLQclDABXg
         tSx7rmRsFzwLaBGYm5mWOEJJcfN2ONAZN8qfLvqKhs5Jwcd+9gUv6clfcB0c3P6dt5
         QD2GdKG7T58QCDof6nZumpguavAF9qLRAZ5xXRJ2qWiasPrUhSXZ1yK7yATVqCJNaq
         t2jzG/gSkWnSlLv3B0q5JS/ACqSVV489RAlO/Zh6Pt3d30s3maDH5uhUzGXiHcotJX
         VHtJEKHbU5F21WXc105MxFE6ODBPngHmXonMAhZQhqL2Euqr19J5vxkJDMkeK05bmh
         Wk99Mmo09oJnA==
Date:   Wed, 24 Mar 2021 10:50:52 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: use s_inodes in xfs_qm_dqrele_all_inodes
Message-ID: <20210324175052.GW22100@magnolia>
References: <20210324070307.908462-1-hch@lst.de>
 <20210324070307.908462-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210324070307.908462-2-hch@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 24, 2021 at 08:03:05AM +0100, Christoph Hellwig wrote:
> Using xfs_inode_walk in xfs_qm_dqrele_all_inodes is complete overkill,
> given that function simplify wants to iterate all live inodes known
> to the VFS.  Just iterate over the s_inodes list.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Seems fine to me...
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_icache.c      |  2 +-
>  fs/xfs/xfs_icache.h      |  2 ++
>  fs/xfs/xfs_qm_syscalls.c | 56 +++++++++++++++++++++++++---------------
>  3 files changed, 38 insertions(+), 22 deletions(-)
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index 1d7720a0c068b7..c0d084e3526a9c 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -233,7 +233,7 @@ xfs_inode_clear_reclaim_tag(
>  	xfs_perag_clear_reclaim_tag(pag);
>  }
>  
> -static void
> +void
>  xfs_inew_wait(
>  	struct xfs_inode	*ip)
>  {
> diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
> index d1fddb1524200b..d70d93c2bb1084 100644
> --- a/fs/xfs/xfs_icache.h
> +++ b/fs/xfs/xfs_icache.h
> @@ -78,4 +78,6 @@ int xfs_icache_inode_is_allocated(struct xfs_mount *mp, struct xfs_trans *tp,
>  void xfs_blockgc_stop(struct xfs_mount *mp);
>  void xfs_blockgc_start(struct xfs_mount *mp);
>  
> +void xfs_inew_wait(struct xfs_inode *ip);
> +
>  #endif
> diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
> index ca1b57d291dc90..88dfd520ae91de 100644
> --- a/fs/xfs/xfs_qm_syscalls.c
> +++ b/fs/xfs/xfs_qm_syscalls.c
> @@ -748,41 +748,27 @@ xfs_qm_scall_getquota_next(
>  	return error;
>  }
>  
> -STATIC int
> +static void
>  xfs_dqrele_inode(
>  	struct xfs_inode	*ip,
> -	void			*args)
> +	uint			flags)
>  {
> -	uint			*flags = args;
> -
> -	/* skip quota inodes */
> -	if (ip == ip->i_mount->m_quotainfo->qi_uquotaip ||
> -	    ip == ip->i_mount->m_quotainfo->qi_gquotaip ||
> -	    ip == ip->i_mount->m_quotainfo->qi_pquotaip) {
> -		ASSERT(ip->i_udquot == NULL);
> -		ASSERT(ip->i_gdquot == NULL);
> -		ASSERT(ip->i_pdquot == NULL);
> -		return 0;
> -	}
> -
>  	xfs_ilock(ip, XFS_ILOCK_EXCL);
> -	if ((*flags & XFS_UQUOTA_ACCT) && ip->i_udquot) {
> +	if ((flags & XFS_UQUOTA_ACCT) && ip->i_udquot) {
>  		xfs_qm_dqrele(ip->i_udquot);
>  		ip->i_udquot = NULL;
>  	}
> -	if ((*flags & XFS_GQUOTA_ACCT) && ip->i_gdquot) {
> +	if ((flags & XFS_GQUOTA_ACCT) && ip->i_gdquot) {
>  		xfs_qm_dqrele(ip->i_gdquot);
>  		ip->i_gdquot = NULL;
>  	}
> -	if ((*flags & XFS_PQUOTA_ACCT) && ip->i_pdquot) {
> +	if ((flags & XFS_PQUOTA_ACCT) && ip->i_pdquot) {
>  		xfs_qm_dqrele(ip->i_pdquot);
>  		ip->i_pdquot = NULL;
>  	}
>  	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> -	return 0;
>  }
>  
> -
>  /*
>   * Go thru all the inodes in the file system, releasing their dquots.
>   *
> @@ -794,7 +780,35 @@ xfs_qm_dqrele_all_inodes(
>  	struct xfs_mount	*mp,
>  	uint			flags)
>  {
> +	struct super_block	*sb = mp->m_super;
> +	struct inode		*inode, *old_inode = NULL;
> +
>  	ASSERT(mp->m_quotainfo);
> -	xfs_inode_walk(mp, XFS_INODE_WALK_INEW_WAIT, xfs_dqrele_inode,
> -			&flags, XFS_ICI_NO_TAG);
> +
> +	spin_lock(&sb->s_inode_list_lock);
> +	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
> +		struct xfs_inode	*ip = XFS_I(inode);
> +
> +		if (XFS_FORCED_SHUTDOWN(mp))
> +			break;
> +		if (xfs_is_quota_inode(&mp->m_sb, ip->i_ino))
> +			continue;
> +		if (xfs_iflags_test(ip, XFS_IRECLAIMABLE | XFS_IRECLAIM))
> +			continue;
> +		if (!igrab(inode))
> +			continue;
> +		spin_unlock(&sb->s_inode_list_lock);
> +
> +		iput(old_inode);
> +		old_inode = inode;
> +
> +		if (xfs_iflags_test(ip, XFS_INEW))
> +			xfs_inew_wait(ip);
> +		xfs_dqrele_inode(ip, flags);
> +
> +		spin_lock(&sb->s_inode_list_lock);
> +	}
> +	spin_unlock(&sb->s_inode_list_lock);
> +
> +	iput(old_inode);
>  }
> -- 
> 2.30.1
> 
