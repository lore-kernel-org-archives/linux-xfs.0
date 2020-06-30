Return-Path: <SRS0=3PXQ=AL=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96CE5C433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Jun 2020 17:46:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7140420774
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Jun 2020 17:46:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="JnJsDFfM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726699AbgF3Rq0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 30 Jun 2020 13:46:26 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:42952 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726813AbgF3Rq0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Jun 2020 13:46:26 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05UHcECd055651;
        Tue, 30 Jun 2020 17:46:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=AvBVd1Su1yyokj9l2B5h68zRnm6eosBG8u3v1RQhgh4=;
 b=JnJsDFfMb4otYtbIgKwLY2VYQoliwGL/GWkXixCwsj5EvdCjXhhbsGYHrffYM0R5gQba
 Q7XiDpgUEBGiZYAHWLB9gmDI08thDLiZdnEx/A87LqJIK4DgoHmYygCv6Uaak5e4r2hg
 pHX1TspvI7nS8fxY1Ot7p8ZG9e9rTRC1+W7YPAnokM4izo9uTDPyPBoZbOGr7mMnw+W4
 MiiiGhjmptW13DCNyK+j08OWqAAQ0sQDCUnFAc7lJJTiKlx3eYLhQoP3v1MCAwy62Jss
 6Jm4ijzOxl0MBlG72ivxcBLaLUX6ezZXWckVsZmAddeCNwMi4mgsufnRCsxMNrZdp56A Bg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 31xx1dtven-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 30 Jun 2020 17:46:21 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05UHcdtf080637;
        Tue, 30 Jun 2020 17:44:20 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 31xfvssw62-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Jun 2020 17:44:20 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 05UHiJ8S010913;
        Tue, 30 Jun 2020 17:44:19 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 30 Jun 2020 17:44:19 +0000
Date:   Tue, 30 Jun 2020 10:44:17 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/15] xfs: move the di_projid field to struct xfs_inode
Message-ID: <20200630174417.GY7606@magnolia>
References: <20200620071102.462554-1-hch@lst.de>
 <20200620071102.462554-3-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200620071102.462554-3-hch@lst.de>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9667 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 adultscore=0 spamscore=0
 phishscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006300121
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9667 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 clxscore=1015 adultscore=0
 suspectscore=1 mlxlogscore=999 cotscore=-2147483648 lowpriorityscore=0
 malwarescore=0 phishscore=0 impostorscore=0 mlxscore=0 spamscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006300121
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Jun 20, 2020 at 09:10:49AM +0200, Christoph Hellwig wrote:
> In preparation of removing the historic icinode struct, move the projid
> field into the containing xfs_inode structure.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks pretty straightforward,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_inode_buf.c | 8 ++++----
>  fs/xfs/libxfs/xfs_inode_buf.h | 1 -
>  fs/xfs/xfs_bmap_util.c        | 2 +-
>  fs/xfs/xfs_dquot.c            | 2 +-
>  fs/xfs/xfs_icache.c           | 4 ++--
>  fs/xfs/xfs_inode.c            | 6 +++---
>  fs/xfs/xfs_inode.h            | 3 ++-
>  fs/xfs/xfs_inode_item.c       | 4 ++--
>  fs/xfs/xfs_ioctl.c            | 8 ++++----
>  fs/xfs/xfs_iops.c             | 2 +-
>  fs/xfs/xfs_itable.c           | 2 +-
>  fs/xfs/xfs_qm.c               | 8 ++++----
>  fs/xfs/xfs_qm_bhv.c           | 2 +-
>  13 files changed, 26 insertions(+), 26 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index 6f84ea85fdd837..b064cb8072c84a 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -218,10 +218,10 @@ xfs_inode_from_disk(
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
> @@ -290,8 +290,8 @@ xfs_inode_to_disk(
>  	to->di_format = xfs_ifork_format(&ip->i_df);
>  	to->di_uid = cpu_to_be32(i_uid_read(inode));
>  	to->di_gid = cpu_to_be32(i_gid_read(inode));
> -	to->di_projid_lo = cpu_to_be16(from->di_projid & 0xffff);
> -	to->di_projid_hi = cpu_to_be16(from->di_projid >> 16);
> +	to->di_projid_lo = cpu_to_be16(ip->i_projid & 0xffff);
> +	to->di_projid_hi = cpu_to_be16(ip->i_projid >> 16);
>  
>  	memset(to->di_pad, 0, sizeof(to->di_pad));
>  	to->di_atime.t_sec = cpu_to_be32(inode->i_atime.tv_sec);
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
> index 865ac493c72a24..b826d81b356956 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.h
> +++ b/fs/xfs/libxfs/xfs_inode_buf.h
> @@ -17,7 +17,6 @@ struct xfs_dinode;
>   */
>  struct xfs_icdinode {
>  	uint16_t	di_flushiter;	/* incremented on flush */
> -	uint32_t	di_projid;	/* owner's project id */
>  	xfs_fsize_t	di_size;	/* number of bytes in file */
>  	xfs_rfsblock_t	di_nblocks;	/* # of direct & btree blocks used */
>  	xfs_extlen_t	di_extsize;	/* basic/minimum extent size for file */
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index f37f5cc4b19ffe..e42553884c23cf 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -1217,7 +1217,7 @@ xfs_swap_extents_check_format(
>  	if (XFS_IS_QUOTA_ON(ip->i_mount) &&
>  	    (!uid_eq(VFS_I(ip)->i_uid, VFS_I(tip)->i_uid) ||
>  	     !gid_eq(VFS_I(ip)->i_gid, VFS_I(tip)->i_gid) ||
> -	     ip->i_d.di_projid != tip->i_d.di_projid))
> +	     ip->i_projid != tip->i_projid))
>  		return -EINVAL;
>  
>  	/* Should never get a local format */
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index d5b7f03e93c8db..912b978a6a72d5 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -868,7 +868,7 @@ xfs_qm_id_for_quotatype(
>  	case XFS_DQ_GROUP:
>  		return i_gid_read(VFS_I(ip));
>  	case XFS_DQ_PROJ:
> -		return ip->i_d.di_projid;
> +		return ip->i_projid;
>  	}
>  	ASSERT(0);
>  	return 0;
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index 660e7abd4e8b76..a3bbd6e4bb6fc8 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -1439,7 +1439,7 @@ xfs_inode_match_id(
>  		return false;
>  
>  	if ((eofb->eof_flags & XFS_EOF_FLAGS_PRID) &&
> -	    ip->i_d.di_projid != eofb->eof_prid)
> +	    ip->i_projid != eofb->eof_prid)
>  		return false;
>  
>  	return true;
> @@ -1463,7 +1463,7 @@ xfs_inode_match_id_union(
>  		return true;
>  
>  	if ((eofb->eof_flags & XFS_EOF_FLAGS_PRID) &&
> -	    ip->i_d.di_projid == eofb->eof_prid)
> +	    ip->i_projid == eofb->eof_prid)
>  		return true;
>  
>  	return false;
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 88a9e496480216..40e4d3ed29a798 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -806,7 +806,7 @@ xfs_ialloc(
>  	set_nlink(inode, nlink);
>  	inode->i_uid = current_fsuid();
>  	inode->i_rdev = rdev;
> -	ip->i_d.di_projid = prid;
> +	ip->i_projid = prid;
>  
>  	if (pip && XFS_INHERIT_GID(pip)) {
>  		inode->i_gid = VFS_I(pip)->i_gid;
> @@ -1398,7 +1398,7 @@ xfs_link(
>  	 * the tree quota mechanism could be circumvented.
>  	 */
>  	if (unlikely((tdp->i_d.di_flags & XFS_DIFLAG_PROJINHERIT) &&
> -		     tdp->i_d.di_projid != sip->i_d.di_projid)) {
> +		     tdp->i_projid != sip->i_projid)) {
>  		error = -EXDEV;
>  		goto error_return;
>  	}
> @@ -3264,7 +3264,7 @@ xfs_rename(
>  	 * tree quota mechanism would be circumvented.
>  	 */
>  	if (unlikely((target_dp->i_d.di_flags & XFS_DIFLAG_PROJINHERIT) &&
> -		     target_dp->i_d.di_projid != src_ip->i_d.di_projid)) {
> +		     target_dp->i_projid != src_ip->i_projid)) {
>  		error = -EXDEV;
>  		goto out_trans_cancel;
>  	}
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index dadcf19458960d..51ea9d53407863 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -54,6 +54,7 @@ typedef struct xfs_inode {
>  	/* Miscellaneous state. */
>  	unsigned long		i_flags;	/* see defined flags below */
>  	uint64_t		i_delayed_blks;	/* count of delay alloc blks */
> +	uint32_t		i_projid;	/* owner's project id */
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
> index ba47bf65b772be..e546b4b58ce2e0 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -308,8 +308,8 @@ xfs_inode_to_log_dinode(
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
> index a40f88cf3ab786..d93f4fc40fd99e 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -1110,7 +1110,7 @@ xfs_fill_fsxattr(
>  	fa->fsx_extsize = ip->i_d.di_extsize << ip->i_mount->m_sb.sb_blocklog;
>  	fa->fsx_cowextsize = ip->i_d.di_cowextsize <<
>  			ip->i_mount->m_sb.sb_blocklog;
> -	fa->fsx_projid = ip->i_d.di_projid;
> +	fa->fsx_projid = ip->i_projid;
>  	if (ifp && (ifp->if_flags & XFS_IFEXTENTS))
>  		fa->fsx_nextents = xfs_iext_count(ifp);
>  	else
> @@ -1518,7 +1518,7 @@ xfs_ioctl_setattr(
>  	}
>  
>  	if (XFS_IS_QUOTA_RUNNING(mp) && XFS_IS_PQUOTA_ON(mp) &&
> -	    ip->i_d.di_projid != fa->fsx_projid) {
> +	    ip->i_projid != fa->fsx_projid) {
>  		code = xfs_qm_vop_chown_reserve(tp, ip, NULL, NULL, pdqp,
>  				capable(CAP_FOWNER) ?  XFS_QMOPT_FORCE_RES : 0);
>  		if (code)	/* out of quota */
> @@ -1555,12 +1555,12 @@ xfs_ioctl_setattr(
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
> index d66528fa365707..5440f555c9cc2c 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -696,7 +696,7 @@ xfs_setattr_nonsize(
>  		 */
>  		ASSERT(udqp == NULL);
>  		ASSERT(gdqp == NULL);
> -		error = xfs_qm_vop_dqalloc(ip, uid, gid, ip->i_d.di_projid,
> +		error = xfs_qm_vop_dqalloc(ip, uid, gid, ip->i_projid,
>  					   qflags, &udqp, &gdqp, NULL);
>  		if (error)
>  			return error;
> diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
> index 16ca97a7ff00fb..97b3b794dd4ada 100644
> --- a/fs/xfs/xfs_itable.c
> +++ b/fs/xfs/xfs_itable.c
> @@ -84,7 +84,7 @@ xfs_bulkstat_one_int(
>  	/* xfs_iget returns the following without needing
>  	 * further change.
>  	 */
> -	buf->bs_projectid = ip->i_d.di_projid;
> +	buf->bs_projectid = ip->i_projid;
>  	buf->bs_ino = ino;
>  	buf->bs_uid = i_uid_read(inode);
>  	buf->bs_gid = i_gid_read(inode);
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index d6cd833173447a..ea22dcf868b474 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -346,7 +346,7 @@ xfs_qm_dqattach_locked(
>  	}
>  
>  	if (XFS_IS_PQUOTA_ON(mp) && !ip->i_pdquot) {
> -		error = xfs_qm_dqattach_one(ip, ip->i_d.di_projid, XFS_DQ_PROJ,
> +		error = xfs_qm_dqattach_one(ip, ip->i_projid, XFS_DQ_PROJ,
>  				doalloc, &ip->i_pdquot);
>  		if (error)
>  			goto done;
> @@ -1711,7 +1711,7 @@ xfs_qm_vop_dqalloc(
>  		}
>  	}
>  	if ((flags & XFS_QMOPT_PQUOTA) && XFS_IS_PQUOTA_ON(mp)) {
> -		if (ip->i_d.di_projid != prid) {
> +		if (ip->i_projid != prid) {
>  			xfs_iunlock(ip, lockflags);
>  			error = xfs_qm_dqget(mp, (xfs_dqid_t)prid, XFS_DQ_PROJ,
>  					true, &pq);
> @@ -1844,7 +1844,7 @@ xfs_qm_vop_chown_reserve(
>  	}
>  
>  	if (XFS_IS_PQUOTA_ON(ip->i_mount) && pdqp &&
> -	    ip->i_d.di_projid != be32_to_cpu(pdqp->q_core.d_id)) {
> +	    ip->i_projid != be32_to_cpu(pdqp->q_core.d_id)) {
>  		pdq_delblks = pdqp;
>  		if (delblks) {
>  			ASSERT(ip->i_pdquot);
> @@ -1942,7 +1942,7 @@ xfs_qm_vop_create_dqattach(
>  	}
>  	if (pdqp && XFS_IS_PQUOTA_ON(mp)) {
>  		ASSERT(ip->i_pdquot == NULL);
> -		ASSERT(ip->i_d.di_projid == be32_to_cpu(pdqp->q_core.d_id));
> +		ASSERT(ip->i_projid == be32_to_cpu(pdqp->q_core.d_id));
>  
>  		ip->i_pdquot = xfs_qm_dqhold(pdqp);
>  		xfs_trans_mod_dquot(tp, pdqp, XFS_TRANS_DQ_ICOUNT, 1);
> diff --git a/fs/xfs/xfs_qm_bhv.c b/fs/xfs/xfs_qm_bhv.c
> index fc2fa418919f7f..b616ad772a6df8 100644
> --- a/fs/xfs/xfs_qm_bhv.c
> +++ b/fs/xfs/xfs_qm_bhv.c
> @@ -60,7 +60,7 @@ xfs_qm_statvfs(
>  	struct xfs_mount	*mp = ip->i_mount;
>  	struct xfs_dquot	*dqp;
>  
> -	if (!xfs_qm_dqget(mp, ip->i_d.di_projid, XFS_DQ_PROJ, false, &dqp)) {
> +	if (!xfs_qm_dqget(mp, ip->i_projid, XFS_DQ_PROJ, false, &dqp)) {
>  		xfs_fill_statvfs_from_dquot(statp, dqp);
>  		xfs_qm_dqput(dqp);
>  	}
> -- 
> 2.26.2
> 
