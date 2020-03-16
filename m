Return-Path: <SRS0=1m5L=5B=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E5E9C2BB1D
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Mar 2020 14:46:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5F06820679
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Mar 2020 14:46:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731639AbgCPOqN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 16 Mar 2020 10:46:13 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:61210 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729643AbgCPOqN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Mar 2020 10:46:13 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02GEWYNJ083934
        for <linux-xfs@vger.kernel.org>; Mon, 16 Mar 2020 10:46:12 -0400
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2yrr5e2cdk-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Mon, 16 Mar 2020 10:46:12 -0400
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.ibm.com>;
        Mon, 16 Mar 2020 14:46:10 -0000
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 16 Mar 2020 14:46:08 -0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 02GEk77w46661700
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Mar 2020 14:46:07 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B771EA405F;
        Mon, 16 Mar 2020 14:46:07 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E2039A4054;
        Mon, 16 Mar 2020 14:46:06 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.85.73.127])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 16 Mar 2020 14:46:06 +0000 (GMT)
From:   Chandan Rajendra <chandan@linux.ibm.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/5] xfs: remove the di_version field from struct icdinode
Date:   Mon, 16 Mar 2020 20:19:07 +0530
Organization: IBM
In-Reply-To: <20200312142235.550766-6-hch@lst.de>
References: <20200312142235.550766-1-hch@lst.de> <20200312142235.550766-6-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-TM-AS-GCONF: 00
x-cbid: 20031614-0028-0000-0000-000003E5B930
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20031614-0029-0000-0000-000024AB0AAD
Message-Id: <2575073.Eovd9JGMvs@localhost.localdomain>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-16_03:2020-03-12,2020-03-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=1
 mlxlogscore=999 clxscore=1015 impostorscore=0 malwarescore=0
 lowpriorityscore=0 mlxscore=0 phishscore=0 bulkscore=0 adultscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003160068
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thursday, March 12, 2020 7:52 PM Christoph Hellwig wrote: 
> We know the version is 3 if on a v5 file system.   For earlier file
> systems formats we always upgrade the remaining v1 inodes to v2 and
> thus only use v2 inodes.  Use the xfs_sb_version_has_large_dinode
> helper to check if we deal with small or large dinodes, and thus
> remove the need for the di_version field in struct icdinode.
>

I don't see any logical issues.

Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_inode_buf.c | 16 ++++++----------
>  fs/xfs/libxfs/xfs_inode_buf.h |  1 -
>  fs/xfs/xfs_bmap_util.c        | 16 ++++++++--------
>  fs/xfs/xfs_inode.c            | 16 ++--------------
>  fs/xfs/xfs_inode_item.c       |  8 +++-----
>  fs/xfs/xfs_ioctl.c            |  5 ++---
>  fs/xfs/xfs_iops.c             |  2 +-
>  fs/xfs/xfs_itable.c           |  2 +-
>  fs/xfs/xfs_log_recover.c      |  2 +-
>  9 files changed, 24 insertions(+), 44 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index 34ccf162abe1..7384b9194922 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -209,16 +209,14 @@ xfs_inode_from_disk(
>  	struct xfs_icdinode	*to = &ip->i_d;
>  	struct inode		*inode = VFS_I(ip);
>  
> -
>  	/*
>  	 * Convert v1 inodes immediately to v2 inode format as this is the
>  	 * minimum inode version format we support in the rest of the code.
> +	 * They will also be unconditionally written back to disk as v2 inodes.
>  	 */
> -	to->di_version = from->di_version;
> -	if (to->di_version == 1) {
> +	if (unlikely(from->di_version == 1)) {
>  		set_nlink(inode, be16_to_cpu(from->di_onlink));
>  		to->di_projid = 0;
> -		to->di_version = 2;
>  	} else {
>  		set_nlink(inode, be32_to_cpu(from->di_nlink));
>  		to->di_projid = (prid_t)be16_to_cpu(from->di_projid_hi) << 16 |
> @@ -256,7 +254,7 @@ xfs_inode_from_disk(
>  	to->di_dmstate	= be16_to_cpu(from->di_dmstate);
>  	to->di_flags	= be16_to_cpu(from->di_flags);
>  
> -	if (to->di_version == 3) {
> +	if (xfs_sb_version_has_large_dinode(&ip->i_mount->m_sb)) {
>  		inode_set_iversion_queried(inode,
>  					   be64_to_cpu(from->di_changecount));
>  		to->di_crtime.tv_sec = be32_to_cpu(from->di_crtime.t_sec);
> @@ -278,7 +276,6 @@ xfs_inode_to_disk(
>  	to->di_magic = cpu_to_be16(XFS_DINODE_MAGIC);
>  	to->di_onlink = 0;
>  
> -	to->di_version = from->di_version;
>  	to->di_format = from->di_format;
>  	to->di_uid = cpu_to_be32(i_uid_read(inode));
>  	to->di_gid = cpu_to_be32(i_gid_read(inode));
> @@ -307,7 +304,8 @@ xfs_inode_to_disk(
>  	to->di_dmstate = cpu_to_be16(from->di_dmstate);
>  	to->di_flags = cpu_to_be16(from->di_flags);
>  
> -	if (from->di_version == 3) {
> +	if (xfs_sb_version_has_large_dinode(&ip->i_mount->m_sb)) {
> +		to->di_version = 3;
>  		to->di_changecount = cpu_to_be64(inode_peek_iversion(inode));
>  		to->di_crtime.t_sec = cpu_to_be32(from->di_crtime.tv_sec);
>  		to->di_crtime.t_nsec = cpu_to_be32(from->di_crtime.tv_nsec);
> @@ -319,6 +317,7 @@ xfs_inode_to_disk(
>  		uuid_copy(&to->di_uuid, &ip->i_mount->m_sb.sb_meta_uuid);
>  		to->di_flushiter = 0;
>  	} else {
> +		to->di_version = 2;
>  		to->di_flushiter = cpu_to_be16(from->di_flushiter);
>  	}
>  }
> @@ -636,7 +635,6 @@ xfs_iread(
>  	    xfs_sb_version_has_large_dinode(&mp->m_sb) &&
>  	    !(mp->m_flags & XFS_MOUNT_IKEEP)) {
>  		VFS_I(ip)->i_generation = prandom_u32();
> -		ip->i_d.di_version = 3;
>  		return 0;
>  	}
>  
> @@ -678,7 +676,6 @@ xfs_iread(
>  		 * Partial initialisation of the in-core inode. Just the bits
>  		 * that xfs_ialloc won't overwrite or relies on being correct.
>  		 */
> -		ip->i_d.di_version = dip->di_version;
>  		VFS_I(ip)->i_generation = be32_to_cpu(dip->di_gen);
>  		ip->i_d.di_flushiter = be16_to_cpu(dip->di_flushiter);
>  
> @@ -692,7 +689,6 @@ xfs_iread(
>  		VFS_I(ip)->i_mode = 0;
>  	}
>  
> -	ASSERT(ip->i_d.di_version >= 2);
>  	ip->i_delayed_blks = 0;
>  
>  	/*
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
> index 2683e1e2c4a6..4e24fad3deb0 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.h
> +++ b/fs/xfs/libxfs/xfs_inode_buf.h
> @@ -16,7 +16,6 @@ struct xfs_dinode;
>   * format specific structures at the appropriate time.
>   */
>  struct xfs_icdinode {
> -	int8_t		di_version;	/* inode version */
>  	int8_t		di_format;	/* format of di_c data */
>  	uint16_t	di_flushiter;	/* incremented on flush */
>  	uint32_t	di_projid;	/* owner's project id */
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index 3df4d0af9f22..6ca37944d71f 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -1449,12 +1449,12 @@ xfs_swap_extent_forks(
>  	 * event of a crash. Set the owner change log flags now and leave the
>  	 * bmbt scan as the last step.
>  	 */
> -	if (ip->i_d.di_version == 3 &&
> -	    ip->i_d.di_format == XFS_DINODE_FMT_BTREE)
> -		(*target_log_flags) |= XFS_ILOG_DOWNER;
> -	if (tip->i_d.di_version == 3 &&
> -	    tip->i_d.di_format == XFS_DINODE_FMT_BTREE)
> -		(*src_log_flags) |= XFS_ILOG_DOWNER;
> +	if (xfs_sb_version_has_large_dinode(&ip->i_mount->m_sb)) {
> +		if (ip->i_d.di_format == XFS_DINODE_FMT_BTREE)
> +			(*target_log_flags) |= XFS_ILOG_DOWNER;
> +		if (tip->i_d.di_format == XFS_DINODE_FMT_BTREE)
> +			(*src_log_flags) |= XFS_ILOG_DOWNER;
> +	}
>  
>  	/*
>  	 * Swap the data forks of the inodes
> @@ -1489,7 +1489,7 @@ xfs_swap_extent_forks(
>  		(*src_log_flags) |= XFS_ILOG_DEXT;
>  		break;
>  	case XFS_DINODE_FMT_BTREE:
> -		ASSERT(ip->i_d.di_version < 3 ||
> +		ASSERT(!xfs_sb_version_has_large_dinode(&ip->i_mount->m_sb) ||
>  		       (*src_log_flags & XFS_ILOG_DOWNER));
>  		(*src_log_flags) |= XFS_ILOG_DBROOT;
>  		break;
> @@ -1501,7 +1501,7 @@ xfs_swap_extent_forks(
>  		break;
>  	case XFS_DINODE_FMT_BTREE:
>  		(*target_log_flags) |= XFS_ILOG_DBROOT;
> -		ASSERT(tip->i_d.di_version < 3 ||
> +		ASSERT(!xfs_sb_version_has_large_dinode(&ip->i_mount->m_sb) ||
>  		       (*target_log_flags & XFS_ILOG_DOWNER));
>  		break;
>  	}
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index ebfd8efb0efa..600c0b59bdd7 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -801,15 +801,6 @@ xfs_ialloc(
>  		return error;
>  	ASSERT(ip != NULL);
>  	inode = VFS_I(ip);
> -
> -	/*
> -	 * We always convert v1 inodes to v2 now - we only support filesystems
> -	 * with >= v2 inode capability, so there is no reason for ever leaving
> -	 * an inode in v1 format.
> -	 */
> -	if (ip->i_d.di_version == 1)
> -		ip->i_d.di_version = 2;
> -
>  	inode->i_mode = mode;
>  	set_nlink(inode, nlink);
>  	inode->i_uid = current_fsuid();
> @@ -847,14 +838,13 @@ xfs_ialloc(
>  	ip->i_d.di_dmstate = 0;
>  	ip->i_d.di_flags = 0;
>  
> -	if (ip->i_d.di_version == 3) {
> +	if (xfs_sb_version_has_large_dinode(&mp->m_sb)) {
>  		inode_set_iversion(inode, 1);
>  		ip->i_d.di_flags2 = 0;
>  		ip->i_d.di_cowextsize = 0;
>  		ip->i_d.di_crtime = tv;
>  	}
>  
> -
>  	flags = XFS_ILOG_CORE;
>  	switch (mode & S_IFMT) {
>  	case S_IFIFO:
> @@ -1115,7 +1105,6 @@ xfs_bumplink(
>  {
>  	xfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_CHG);
>  
> -	ASSERT(ip->i_d.di_version > 1);
>  	inc_nlink(VFS_I(ip));
>  	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
>  }
> @@ -3798,7 +3787,6 @@ xfs_iflush_int(
>  	ASSERT(ip->i_d.di_format != XFS_DINODE_FMT_BTREE ||
>  	       ip->i_d.di_nextents > XFS_IFORK_MAXEXT(ip, XFS_DATA_FORK));
>  	ASSERT(iip != NULL && iip->ili_fields != 0);
> -	ASSERT(ip->i_d.di_version > 1);
>  
>  	/* set *dip = inode's place in the buffer */
>  	dip = xfs_buf_offset(bp, ip->i_imap.im_boffset);
> @@ -3859,7 +3847,7 @@ xfs_iflush_int(
>  	 * backwards compatibility with old kernels that predate logging all
>  	 * inode changes.
>  	 */
> -	if (ip->i_d.di_version < 3)
> +	if (!xfs_sb_version_has_large_dinode(&mp->m_sb))
>  		ip->i_d.di_flushiter++;
>  
>  	/* Check the inline fork data before we write out. */
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index 451f9b6b2806..5800bfda96b2 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -305,8 +305,6 @@ xfs_inode_to_log_dinode(
>  	struct inode		*inode = VFS_I(ip);
>  
>  	to->di_magic = XFS_DINODE_MAGIC;
> -
> -	to->di_version = from->di_version;
>  	to->di_format = from->di_format;
>  	to->di_uid = i_uid_read(inode);
>  	to->di_gid = i_gid_read(inode);
> @@ -339,7 +337,8 @@ xfs_inode_to_log_dinode(
>  	/* log a dummy value to ensure log structure is fully initialised */
>  	to->di_next_unlinked = NULLAGINO;
>  
> -	if (from->di_version == 3) {
> +	if (xfs_sb_version_has_large_dinode(&ip->i_mount->m_sb)) {
> +		to->di_version = 3;
>  		to->di_changecount = inode_peek_iversion(inode);
>  		to->di_crtime.t_sec = from->di_crtime.tv_sec;
>  		to->di_crtime.t_nsec = from->di_crtime.tv_nsec;
> @@ -351,6 +350,7 @@ xfs_inode_to_log_dinode(
>  		uuid_copy(&to->di_uuid, &ip->i_mount->m_sb.sb_meta_uuid);
>  		to->di_flushiter = 0;
>  	} else {
> +		to->di_version = 2;
>  		to->di_flushiter = from->di_flushiter;
>  	}
>  }
> @@ -395,8 +395,6 @@ xfs_inode_item_format(
>  	struct xfs_log_iovec	*vecp = NULL;
>  	struct xfs_inode_log_format *ilf;
>  
> -	ASSERT(ip->i_d.di_version > 1);
> -
>  	ilf = xlog_prepare_iovec(lv, &vecp, XLOG_REG_TYPE_IFORMAT);
>  	ilf->ilf_type = XFS_LI_INODE;
>  	ilf->ilf_ino = ip->i_ino;
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index ad825ffa7e4c..a98909cc7ecb 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -1263,7 +1263,7 @@ xfs_ioctl_setattr_xflags(
>  
>  	/* diflags2 only valid for v3 inodes. */
>  	di_flags2 = xfs_flags2diflags2(ip, fa->fsx_xflags);
> -	if (di_flags2 && ip->i_d.di_version < 3)
> +	if (di_flags2 && !xfs_sb_version_has_large_dinode(&mp->m_sb))
>  		return -EINVAL;
>  
>  	ip->i_d.di_flags = xfs_flags2diflags(ip, fa->fsx_xflags);
> @@ -1601,7 +1601,6 @@ xfs_ioctl_setattr(
>  			olddquot = xfs_qm_vop_chown(tp, ip,
>  						&ip->i_pdquot, pdqp);
>  		}
> -		ASSERT(ip->i_d.di_version > 1);
>  		ip->i_d.di_projid = fa->fsx_projid;
>  	}
>  
> @@ -1614,7 +1613,7 @@ xfs_ioctl_setattr(
>  		ip->i_d.di_extsize = fa->fsx_extsize >> mp->m_sb.sb_blocklog;
>  	else
>  		ip->i_d.di_extsize = 0;
> -	if (ip->i_d.di_version == 3 &&
> +	if (xfs_sb_version_has_large_dinode(&mp->m_sb) &&
>  	    (ip->i_d.di_flags2 & XFS_DIFLAG2_COWEXTSIZE))
>  		ip->i_d.di_cowextsize = fa->fsx_cowextsize >>
>  				mp->m_sb.sb_blocklog;
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index 87093a05aad7..df2cd57e984e 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -557,7 +557,7 @@ xfs_vn_getattr(
>  	stat->blocks =
>  		XFS_FSB_TO_BB(mp, ip->i_d.di_nblocks + ip->i_delayed_blks);
>  
> -	if (ip->i_d.di_version == 3) {
> +	if (xfs_sb_version_has_large_dinode(&mp->m_sb)) {
>  		if (request_mask & STATX_BTIME) {
>  			stat->result_mask |= STATX_BTIME;
>  			stat->btime = ip->i_d.di_crtime;
> diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
> index d10660469884..4d4dad557c2f 100644
> --- a/fs/xfs/xfs_itable.c
> +++ b/fs/xfs/xfs_itable.c
> @@ -110,7 +110,7 @@ xfs_bulkstat_one_int(
>  	buf->bs_forkoff = XFS_IFORK_BOFF(ip);
>  	buf->bs_version = XFS_BULKSTAT_VERSION_V5;
>  
> -	if (dic->di_version == 3) {
> +	if (xfs_sb_version_has_large_dinode(&mp->m_sb)) {
>  		if (dic->di_flags2 & XFS_DIFLAG2_COWEXTSIZE)
>  			buf->bs_cowextsize_blks = dic->di_cowextsize;
>  	}
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 79fc85a4ff08..9db6003d125b 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -2869,8 +2869,8 @@ xfs_recover_inode_owner_change(
>  		return -ENOMEM;
>  
>  	/* instantiate the inode */
> +	ASSERT(dip->di_version >= 3);
>  	xfs_inode_from_disk(ip, dip);
> -	ASSERT(ip->i_d.di_version >= 3);
>  
>  	error = xfs_iformat_fork(ip, dip);
>  	if (error)
> 


-- 
chandan



