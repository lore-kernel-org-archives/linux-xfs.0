Return-Path: <SRS0=Awhw=ZE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7C8BC43331
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Nov 2019 16:23:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AABA22084F
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Nov 2019 16:23:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IRlKY6W0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726738AbfKLQXW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Nov 2019 11:23:22 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:32796 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726008AbfKLQXV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Nov 2019 11:23:21 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xACGKLPL126730;
        Tue, 12 Nov 2019 16:23:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=EcgCvCzzXrLfI1RFP0Mv0tQPd82yJUphIyYm5hESFZY=;
 b=IRlKY6W0hacGR8Ckkjx2xgZN8JokHL+goXNTryFffP8t5N2dLjjoEiGH4wttbMnEsama
 VktriocbhcR57oil7FEIziEzddn00ou6c71pWUKdOazzk98+bsG2WYbVWIr9Ae+hdcgX
 Cq+UJXIL51jWDNcUJs96Zxn+Z32ks5A01lCbq48V3UkmFUmd9eN9mgO5uQ5e5L/sQKgY
 qD1nksbdfCu44t1GII0LtKreemR3j/sdjhJPflIuWK8lwaMfr4Dwg2GCMCWnQrTRaAhX
 GXL7kx7ga5qg09sMYtHVUlt3xE4G7qGjplZC5DC735POzohpJEGtMfikDIIOwb7ZuTJG OQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2w5p3qnvps-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Nov 2019 16:23:16 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xACGNEsR142000;
        Tue, 12 Nov 2019 16:23:16 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2w7vbb38bj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Nov 2019 16:23:15 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xACGMjIL008278;
        Tue, 12 Nov 2019 16:22:45 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 12 Nov 2019 08:22:45 -0800
Date:   Tue, 12 Nov 2019 08:22:44 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] xfs: merge the projid fields in struct xfs_icdinode
Message-ID: <20191112162244.GY6219@magnolia>
References: <20191020082145.32515-1-hch@lst.de>
 <20191020082145.32515-3-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191020082145.32515-3-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9439 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911120138
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9439 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911120137
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Oct 20, 2019 at 10:21:43AM +0200, Christoph Hellwig wrote:
> There is no point in splitting the fields like this in an purely
> in-memory structure.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok, will give it a spin...
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_inode_buf.c | 11 +++++------
>  fs/xfs/libxfs/xfs_inode_buf.h |  3 +--
>  fs/xfs/xfs_dquot.c            |  2 +-
>  fs/xfs/xfs_icache.c           |  4 ++--
>  fs/xfs/xfs_inode.c            |  6 +++---
>  fs/xfs/xfs_inode.h            | 21 +--------------------
>  fs/xfs/xfs_inode_item.c       |  4 ++--
>  fs/xfs/xfs_ioctl.c            |  8 ++++----
>  fs/xfs/xfs_iops.c             |  2 +-
>  fs/xfs/xfs_itable.c           |  2 +-
>  fs/xfs/xfs_qm.c               |  8 ++++----
>  fs/xfs/xfs_qm_bhv.c           |  2 +-
>  12 files changed, 26 insertions(+), 47 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index d31156718b20..019c9be677cc 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -213,13 +213,12 @@ xfs_inode_from_disk(
>  	to->di_version = from->di_version;
>  	if (to->di_version == 1) {
>  		set_nlink(inode, be16_to_cpu(from->di_onlink));
> -		to->di_projid_lo = 0;
> -		to->di_projid_hi = 0;
> +		to->di_projid = 0;
>  		to->di_version = 2;
>  	} else {
>  		set_nlink(inode, be32_to_cpu(from->di_nlink));
> -		to->di_projid_lo = be16_to_cpu(from->di_projid_lo);
> -		to->di_projid_hi = be16_to_cpu(from->di_projid_hi);
> +		to->di_projid = (prid_t)be16_to_cpu(from->di_projid_hi) << 16 |
> +					be16_to_cpu(from->di_projid_lo);
>  	}
>  
>  	to->di_format = from->di_format;
> @@ -279,8 +278,8 @@ xfs_inode_to_disk(
>  	to->di_format = from->di_format;
>  	to->di_uid = cpu_to_be32(from->di_uid);
>  	to->di_gid = cpu_to_be32(from->di_gid);
> -	to->di_projid_lo = cpu_to_be16(from->di_projid_lo);
> -	to->di_projid_hi = cpu_to_be16(from->di_projid_hi);
> +	to->di_projid_lo = cpu_to_be16(from->di_projid & 0xffff);
> +	to->di_projid_hi = cpu_to_be16(from->di_projid >> 16);
>  
>  	memset(to->di_pad, 0, sizeof(to->di_pad));
>  	to->di_atime.t_sec = cpu_to_be32(inode->i_atime.tv_sec);
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
> index c9ac69c82d21..fd94b1078722 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.h
> +++ b/fs/xfs/libxfs/xfs_inode_buf.h
> @@ -21,8 +21,7 @@ struct xfs_icdinode {
>  	uint16_t	di_flushiter;	/* incremented on flush */
>  	uint32_t	di_uid;		/* owner's user id */
>  	uint32_t	di_gid;		/* owner's group id */
> -	uint16_t	di_projid_lo;	/* lower part of owner's project id */
> -	uint16_t	di_projid_hi;	/* higher part of owner's project id */
> +	uint32_t	di_projid;	/* owner's project id */
>  	xfs_fsize_t	di_size;	/* number of bytes in file */
>  	xfs_rfsblock_t	di_nblocks;	/* # of direct & btree blocks used */
>  	xfs_extlen_t	di_extsize;	/* basic/minimum extent size for file */
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index aeb95e7391c1..12074c1d250c 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -833,7 +833,7 @@ xfs_qm_id_for_quotatype(
>  	case XFS_DQ_GROUP:
>  		return ip->i_d.di_gid;
>  	case XFS_DQ_PROJ:
> -		return xfs_get_projid(ip);
> +		return ip->i_d.di_projid;
>  	}
>  	ASSERT(0);
>  	return 0;
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index 944add5ff8e0..ec302b7e48f3 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -1419,7 +1419,7 @@ xfs_inode_match_id(
>  		return 0;
>  
>  	if ((eofb->eof_flags & XFS_EOF_FLAGS_PRID) &&
> -	    xfs_get_projid(ip) != eofb->eof_prid)
> +	    ip->i_d.di_projid != eofb->eof_prid)
>  		return 0;
>  
>  	return 1;
> @@ -1443,7 +1443,7 @@ xfs_inode_match_id_union(
>  		return 1;
>  
>  	if ((eofb->eof_flags & XFS_EOF_FLAGS_PRID) &&
> -	    xfs_get_projid(ip) == eofb->eof_prid)
> +	    ip->i_d.di_projid == eofb->eof_prid)
>  		return 1;
>  
>  	return 0;
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 24efdbf534c7..685c21d0a6ca 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -809,7 +809,7 @@ xfs_ialloc(
>  	ip->i_d.di_uid = xfs_kuid_to_uid(current_fsuid());
>  	ip->i_d.di_gid = xfs_kgid_to_gid(current_fsgid());
>  	inode->i_rdev = rdev;
> -	xfs_set_projid(ip, prid);
> +	ip->i_d.di_projid = prid;
>  
>  	if (pip && XFS_INHERIT_GID(pip)) {
>  		ip->i_d.di_gid = pip->i_d.di_gid;
> @@ -1417,7 +1417,7 @@ xfs_link(
>  	 * the tree quota mechanism could be circumvented.
>  	 */
>  	if (unlikely((tdp->i_d.di_flags & XFS_DIFLAG_PROJINHERIT) &&
> -		     (xfs_get_projid(tdp) != xfs_get_projid(sip)))) {
> +		     tdp->i_d.di_projid != sip->i_d.di_projid)) {
>  		error = -EXDEV;
>  		goto error_return;
>  	}
> @@ -3269,7 +3269,7 @@ xfs_rename(
>  	 * tree quota mechanism would be circumvented.
>  	 */
>  	if (unlikely((target_dp->i_d.di_flags & XFS_DIFLAG_PROJINHERIT) &&
> -		     (xfs_get_projid(target_dp) != xfs_get_projid(src_ip)))) {
> +		     target_dp->i_d.di_projid != src_ip->i_d.di_projid)) {
>  		error = -EXDEV;
>  		goto out_trans_cancel;
>  	}
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index 558173f95a03..a0ca7ded3ab8 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -177,30 +177,11 @@ xfs_iflags_test_and_set(xfs_inode_t *ip, unsigned short flags)
>  	return ret;
>  }
>  
> -/*
> - * Project quota id helpers (previously projid was 16bit only
> - * and using two 16bit values to hold new 32bit projid was chosen
> - * to retain compatibility with "old" filesystems).
> - */
> -static inline prid_t
> -xfs_get_projid(struct xfs_inode *ip)
> -{
> -	return (prid_t)ip->i_d.di_projid_hi << 16 | ip->i_d.di_projid_lo;
> -}
> -
> -static inline void
> -xfs_set_projid(struct xfs_inode *ip,
> -		prid_t projid)
> -{
> -	ip->i_d.di_projid_hi = (uint16_t) (projid >> 16);
> -	ip->i_d.di_projid_lo = (uint16_t) (projid & 0xffff);
> -}
> -
>  static inline prid_t
>  xfs_get_initial_prid(struct xfs_inode *dp)
>  {
>  	if (dp->i_d.di_flags & XFS_DIFLAG_PROJINHERIT)
> -		return xfs_get_projid(dp);
> +		return dp->i_d.di_projid;
>  
>  	return XFS_PROJID_DEFAULT;
>  }
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index a15db5d679ac..e6ffeb1b8a92 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -309,8 +309,8 @@ xfs_inode_to_log_dinode(
>  	to->di_format = from->di_format;
>  	to->di_uid = from->di_uid;
>  	to->di_gid = from->di_gid;
> -	to->di_projid_lo = from->di_projid_lo;
> -	to->di_projid_hi = from->di_projid_hi;
> +	to->di_projid_lo = from->di_projid & 0xffff;
> +	to->di_projid_hi = from->di_projid >> 16;
>  
>  	memset(to->di_pad, 0, sizeof(to->di_pad));
>  	memset(to->di_pad3, 0, sizeof(to->di_pad3));
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index d58f0d6a699e..6ff01e4a8b7b 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -1116,7 +1116,7 @@ xfs_fill_fsxattr(
>  	fa->fsx_extsize = ip->i_d.di_extsize << ip->i_mount->m_sb.sb_blocklog;
>  	fa->fsx_cowextsize = ip->i_d.di_cowextsize <<
>  			ip->i_mount->m_sb.sb_blocklog;
> -	fa->fsx_projid = xfs_get_projid(ip);
> +	fa->fsx_projid = ip->i_d.di_projid;
>  
>  	if (attr) {
>  		if (ip->i_afp) {
> @@ -1569,7 +1569,7 @@ xfs_ioctl_setattr(
>  	}
>  
>  	if (XFS_IS_QUOTA_RUNNING(mp) && XFS_IS_PQUOTA_ON(mp) &&
> -	    xfs_get_projid(ip) != fa->fsx_projid) {
> +	    ip->i_d.di_projid != fa->fsx_projid) {
>  		code = xfs_qm_vop_chown_reserve(tp, ip, udqp, NULL, pdqp,
>  				capable(CAP_FOWNER) ?  XFS_QMOPT_FORCE_RES : 0);
>  		if (code)	/* out of quota */
> @@ -1606,13 +1606,13 @@ xfs_ioctl_setattr(
>  		VFS_I(ip)->i_mode &= ~(S_ISUID|S_ISGID);
>  
>  	/* Change the ownerships and register project quota modifications */
> -	if (xfs_get_projid(ip) != fa->fsx_projid) {
> +	if (ip->i_d.di_projid != fa->fsx_projid) {
>  		if (XFS_IS_QUOTA_RUNNING(mp) && XFS_IS_PQUOTA_ON(mp)) {
>  			olddquot = xfs_qm_vop_chown(tp, ip,
>  						&ip->i_pdquot, pdqp);
>  		}
>  		ASSERT(ip->i_d.di_version > 1);
> -		xfs_set_projid(ip, fa->fsx_projid);
> +		ip->i_d.di_projid = fa->fsx_projid;
>  	}
>  
>  	/*
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index 47d8cdb86e5c..c71c34798654 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -663,7 +663,7 @@ xfs_setattr_nonsize(
>  		ASSERT(gdqp == NULL);
>  		error = xfs_qm_vop_dqalloc(ip, xfs_kuid_to_uid(uid),
>  					   xfs_kgid_to_gid(gid),
> -					   xfs_get_projid(ip),
> +					   ip->i_d.di_projid,
>  					   qflags, &udqp, &gdqp, NULL);
>  		if (error)
>  			return error;
> diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
> index 11771112a634..4b31c29b7e6b 100644
> --- a/fs/xfs/xfs_itable.c
> +++ b/fs/xfs/xfs_itable.c
> @@ -84,7 +84,7 @@ xfs_bulkstat_one_int(
>  	/* xfs_iget returns the following without needing
>  	 * further change.
>  	 */
> -	buf->bs_projectid = xfs_get_projid(ip);
> +	buf->bs_projectid = ip->i_d.di_projid;
>  	buf->bs_ino = ino;
>  	buf->bs_uid = dic->di_uid;
>  	buf->bs_gid = dic->di_gid;
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index ecd8ce152ab1..168f4ae4bdb8 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -341,7 +341,7 @@ xfs_qm_dqattach_locked(
>  	}
>  
>  	if (XFS_IS_PQUOTA_ON(mp) && !ip->i_pdquot) {
> -		error = xfs_qm_dqattach_one(ip, xfs_get_projid(ip), XFS_DQ_PROJ,
> +		error = xfs_qm_dqattach_one(ip, ip->i_d.di_projid, XFS_DQ_PROJ,
>  				doalloc, &ip->i_pdquot);
>  		if (error)
>  			goto done;
> @@ -1693,7 +1693,7 @@ xfs_qm_vop_dqalloc(
>  		}
>  	}
>  	if ((flags & XFS_QMOPT_PQUOTA) && XFS_IS_PQUOTA_ON(mp)) {
> -		if (xfs_get_projid(ip) != prid) {
> +		if (ip->i_d.di_projid != prid) {
>  			xfs_iunlock(ip, lockflags);
>  			error = xfs_qm_dqget(mp, (xfs_dqid_t)prid, XFS_DQ_PROJ,
>  					true, &pq);
> @@ -1827,7 +1827,7 @@ xfs_qm_vop_chown_reserve(
>  	}
>  
>  	if (XFS_IS_PQUOTA_ON(ip->i_mount) && pdqp &&
> -	    xfs_get_projid(ip) != be32_to_cpu(pdqp->q_core.d_id)) {
> +	    ip->i_d.di_projid != be32_to_cpu(pdqp->q_core.d_id)) {
>  		prjflags = XFS_QMOPT_ENOSPC;
>  		pdq_delblks = pdqp;
>  		if (delblks) {
> @@ -1928,7 +1928,7 @@ xfs_qm_vop_create_dqattach(
>  	}
>  	if (pdqp && XFS_IS_PQUOTA_ON(mp)) {
>  		ASSERT(ip->i_pdquot == NULL);
> -		ASSERT(xfs_get_projid(ip) == be32_to_cpu(pdqp->q_core.d_id));
> +		ASSERT(ip->i_d.di_projid == be32_to_cpu(pdqp->q_core.d_id));
>  
>  		ip->i_pdquot = xfs_qm_dqhold(pdqp);
>  		xfs_trans_mod_dquot(tp, pdqp, XFS_TRANS_DQ_ICOUNT, 1);
> diff --git a/fs/xfs/xfs_qm_bhv.c b/fs/xfs/xfs_qm_bhv.c
> index 5d72e88598b4..ac8885d0f752 100644
> --- a/fs/xfs/xfs_qm_bhv.c
> +++ b/fs/xfs/xfs_qm_bhv.c
> @@ -60,7 +60,7 @@ xfs_qm_statvfs(
>  	xfs_mount_t		*mp = ip->i_mount;
>  	xfs_dquot_t		*dqp;
>  
> -	if (!xfs_qm_dqget(mp, xfs_get_projid(ip), XFS_DQ_PROJ, false, &dqp)) {
> +	if (!xfs_qm_dqget(mp, ip->i_d.di_projid, XFS_DQ_PROJ, false, &dqp)) {
>  		xfs_fill_statvfs_from_dquot(statp, dqp);
>  		xfs_qm_dqput(dqp);
>  	}
> -- 
> 2.20.1
> 
