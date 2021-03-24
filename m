Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7265C433C1
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Mar 2021 18:20:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8093461A16
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Mar 2021 18:20:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229948AbhCXSU1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Mar 2021 14:20:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:43120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229873AbhCXSUS (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 24 Mar 2021 14:20:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C4CDB61A0E;
        Wed, 24 Mar 2021 18:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616610017;
        bh=D9wUU1pKWmq5wUOuWkwuqDI1yI2XXK9YTnGM05QVQD8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=A7Ap6Shmwoo7oJ7MUnTVROL87+/S2H5nW732qKYhHjL3Tag1QbYqYOKLtI2KkgK3Z
         bMdB/g8B1Quui8DFrlEVkqxrsPHLyGaofih+kIzkdOv62u+s3nDvSq+SjIGCd4aiix
         j0t4E1BcfSKappVqdmgwRrUwqy6yZEMbqWXdrMRxIpbVVwdG31FkGFiM/JYn+F2+Ur
         fhahNtMcEtj2lM+1/eQkT33mXpgePA2zVdDV96R8x8eUOPWSGCH9FAS0xZtf03mKqf
         KLLEB9i+8D7J6IGhKv/zfyRGwx/icOdEEu0iLWRJo2drCbqbY3YyxukQrPL+Vp2Dle
         5s2zDRKTXfzkA==
Date:   Wed, 24 Mar 2021 11:20:17 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/18] xfs: move the di_projid field to struct xfs_inode
Message-ID: <20210324182017.GE22100@magnolia>
References: <20210324142129.1011766-1-hch@lst.de>
 <20210324142129.1011766-8-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210324142129.1011766-8-hch@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 24, 2021 at 03:21:18PM +0100, Christoph Hellwig wrote:
> In preparation of removing the historic icinode struct, move the projid
> field into the containing xfs_inode structure.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_inode_buf.c | 8 ++++----
>  fs/xfs/libxfs/xfs_inode_buf.h | 1 -
>  fs/xfs/xfs_bmap_util.c        | 2 +-
>  fs/xfs/xfs_dquot.c            | 2 +-
>  fs/xfs/xfs_icache.c           | 4 ++--
>  fs/xfs/xfs_inode.c            | 6 +++---
>  fs/xfs/xfs_inode.h            | 3 ++-
>  fs/xfs/xfs_inode_item.c       | 4 ++--
>  fs/xfs/xfs_ioctl.c            | 6 +++---
>  fs/xfs/xfs_iops.c             | 2 +-
>  fs/xfs/xfs_itable.c           | 2 +-
>  fs/xfs/xfs_qm.c               | 4 ++--
>  fs/xfs/xfs_qm_bhv.c           | 2 +-
>  13 files changed, 23 insertions(+), 23 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index 062157dcfdfcd3..6b7d651d7c4cf4 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -206,10 +206,10 @@ xfs_inode_from_disk(
>  	 */
>  	if (unlikely(from->di_version == 1)) {
>  		set_nlink(inode, be16_to_cpu(from->di_onlink));
> -		to->di_projid = 0;
> +		ip->i_projid = 0;
>  	} else {
>  		set_nlink(inode, be32_to_cpu(from->di_nlink));
> -		to->di_projid = (prid_t)be16_to_cpu(from->di_projid_hi) << 16 |
> +		ip->i_projid = (prid_t)be16_to_cpu(from->di_projid_hi) << 16 |
>  					be16_to_cpu(from->di_projid_lo);
>  	}
>  
> @@ -294,8 +294,8 @@ xfs_inode_to_disk(
>  	to->di_format = xfs_ifork_format(&ip->i_df);
>  	to->di_uid = cpu_to_be32(i_uid_read(inode));
>  	to->di_gid = cpu_to_be32(i_gid_read(inode));
> -	to->di_projid_lo = cpu_to_be16(from->di_projid & 0xffff);
> -	to->di_projid_hi = cpu_to_be16(from->di_projid >> 16);
> +	to->di_projid_lo = cpu_to_be16(ip->i_projid & 0xffff);
> +	to->di_projid_hi = cpu_to_be16(ip->i_projid >> 16);
>  
>  	memset(to->di_pad, 0, sizeof(to->di_pad));
>  	to->di_atime = xfs_inode_to_disk_ts(ip, inode->i_atime);
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
> index d7a019df05d647..406f667992883f 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.h
> +++ b/fs/xfs/libxfs/xfs_inode_buf.h
> @@ -17,7 +17,6 @@ struct xfs_dinode;
>   */
>  struct xfs_icdinode {
>  	uint16_t	di_flushiter;	/* incremented on flush */
> -	prid_t		di_projid;	/* owner's project id */
>  	xfs_fsize_t	di_size;	/* number of bytes in file */
>  	xfs_rfsblock_t	di_nblocks;	/* # of direct & btree blocks used */
>  	xfs_extlen_t	di_extsize;	/* basic/minimum extent size for file */

<snip>

> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index e97957f5309281..674d1a0b781cd3 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -54,6 +54,7 @@ typedef struct xfs_inode {
>  	/* Miscellaneous state. */
>  	unsigned long		i_flags;	/* see defined flags below */
>  	uint64_t		i_delayed_blks;	/* count of delay alloc blks */
> +	uint32_t		i_projid;	/* owner's project id */

Shouldn't this be prid_t to match the field removed from icdinode?

The rest of the name conversions look ok though.

--D

>  
>  	struct xfs_icdinode	i_d;		/* most of ondisk inode */
>  
> @@ -175,7 +176,7 @@ static inline prid_t
>  xfs_get_initial_prid(struct xfs_inode *dp)
>  {
>  	if (dp->i_d.di_flags & XFS_DIFLAG_PROJINHERIT)
> -		return dp->i_d.di_projid;
> +		return dp->i_projid;
>  
>  	return XFS_PROJID_DEFAULT;
>  }
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index 4c3d1d829753b2..3af00685adc4b8 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -357,8 +357,8 @@ xfs_inode_to_log_dinode(
>  	to->di_format = xfs_ifork_format(&ip->i_df);
>  	to->di_uid = i_uid_read(inode);
>  	to->di_gid = i_gid_read(inode);
> -	to->di_projid_lo = from->di_projid & 0xffff;
> -	to->di_projid_hi = from->di_projid >> 16;
> +	to->di_projid_lo = ip->i_projid & 0xffff;
> +	to->di_projid_hi = ip->i_projid >> 16;
>  
>  	memset(to->di_pad, 0, sizeof(to->di_pad));
>  	memset(to->di_pad3, 0, sizeof(to->di_pad3));
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 99dfe89a8d08b8..8d22127284d360 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -1123,7 +1123,7 @@ xfs_fill_fsxattr(
>  	fa->fsx_extsize = ip->i_d.di_extsize << ip->i_mount->m_sb.sb_blocklog;
>  	fa->fsx_cowextsize = ip->i_d.di_cowextsize <<
>  			ip->i_mount->m_sb.sb_blocklog;
> -	fa->fsx_projid = ip->i_d.di_projid;
> +	fa->fsx_projid = ip->i_projid;
>  	if (ifp && (ifp->if_flags & XFS_IFEXTENTS))
>  		fa->fsx_nextents = xfs_iext_count(ifp);
>  	else
> @@ -1505,12 +1505,12 @@ xfs_ioctl_setattr(
>  		VFS_I(ip)->i_mode &= ~(S_ISUID|S_ISGID);
>  
>  	/* Change the ownerships and register project quota modifications */
> -	if (ip->i_d.di_projid != fa->fsx_projid) {
> +	if (ip->i_projid != fa->fsx_projid) {
>  		if (XFS_IS_QUOTA_RUNNING(mp) && XFS_IS_PQUOTA_ON(mp)) {
>  			olddquot = xfs_qm_vop_chown(tp, ip,
>  						&ip->i_pdquot, pdqp);
>  		}
> -		ip->i_d.di_projid = fa->fsx_projid;
> +		ip->i_projid = fa->fsx_projid;
>  	}
>  
>  	/*
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index 66ebccb5a6fffb..9f2ea7f7d35ea3 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -705,7 +705,7 @@ xfs_setattr_nonsize(
>  		 */
>  		ASSERT(udqp == NULL);
>  		ASSERT(gdqp == NULL);
> -		error = xfs_qm_vop_dqalloc(ip, uid, gid, ip->i_d.di_projid,
> +		error = xfs_qm_vop_dqalloc(ip, uid, gid, ip->i_projid,
>  					   qflags, &udqp, &gdqp, NULL);
>  		if (error)
>  			return error;
> diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
> index 444b551d540f44..a40fe601ef61d4 100644
> --- a/fs/xfs/xfs_itable.c
> +++ b/fs/xfs/xfs_itable.c
> @@ -86,7 +86,7 @@ xfs_bulkstat_one_int(
>  	/* xfs_iget returns the following without needing
>  	 * further change.
>  	 */
> -	buf->bs_projectid = ip->i_d.di_projid;
> +	buf->bs_projectid = ip->i_projid;
>  	buf->bs_ino = ino;
>  	buf->bs_uid = from_kuid(sb_userns, i_uid_into_mnt(mnt_userns, inode));
>  	buf->bs_gid = from_kgid(sb_userns, i_gid_into_mnt(mnt_userns, inode));
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index bfa4164990b171..9599d40ff2ec49 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -1716,7 +1716,7 @@ xfs_qm_vop_dqalloc(
>  	}
>  	if ((flags & XFS_QMOPT_PQUOTA) && XFS_IS_PQUOTA_ON(mp)) {
>  		ASSERT(O_pdqpp);
> -		if (ip->i_d.di_projid != prid) {
> +		if (ip->i_projid != prid) {
>  			xfs_iunlock(ip, lockflags);
>  			error = xfs_qm_dqget(mp, prid,
>  					XFS_DQTYPE_PROJ, true, &pq);
> @@ -1877,7 +1877,7 @@ xfs_qm_vop_create_dqattach(
>  	}
>  	if (pdqp && XFS_IS_PQUOTA_ON(mp)) {
>  		ASSERT(ip->i_pdquot == NULL);
> -		ASSERT(ip->i_d.di_projid == pdqp->q_id);
> +		ASSERT(ip->i_projid == pdqp->q_id);
>  
>  		ip->i_pdquot = xfs_qm_dqhold(pdqp);
>  		xfs_trans_mod_dquot(tp, pdqp, XFS_TRANS_DQ_ICOUNT, 1);
> diff --git a/fs/xfs/xfs_qm_bhv.c b/fs/xfs/xfs_qm_bhv.c
> index 639398091ad6ba..df00dfbf5c9d19 100644
> --- a/fs/xfs/xfs_qm_bhv.c
> +++ b/fs/xfs/xfs_qm_bhv.c
> @@ -60,7 +60,7 @@ xfs_qm_statvfs(
>  	struct xfs_mount	*mp = ip->i_mount;
>  	struct xfs_dquot	*dqp;
>  
> -	if (!xfs_qm_dqget(mp, ip->i_d.di_projid, XFS_DQTYPE_PROJ, false, &dqp)) {
> +	if (!xfs_qm_dqget(mp, ip->i_projid, XFS_DQTYPE_PROJ, false, &dqp)) {
>  		xfs_fill_statvfs_from_dquot(statp, dqp);
>  		xfs_qm_dqput(dqp);
>  	}
> -- 
> 2.30.1
> 
