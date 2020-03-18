Return-Path: <SRS0=sZmN=5D=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8739AC10DCE
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Mar 2020 15:31:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4973720724
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Mar 2020 15:31:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="seN6XOPN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726879AbgCRPb3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Mar 2020 11:31:29 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:60974 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726789AbgCRPb3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Mar 2020 11:31:29 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02IFMwK9105617;
        Wed, 18 Mar 2020 15:31:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=e0/ro+SSHZZ3bZ5VZEJ4/p7lHqKMtF/0L//U7ey4pcs=;
 b=seN6XOPN5qcNxiLyfO8Xyf9c9xNH5Tf0/En9nvTfI7B+oIYFLL4FOdkrZs0IIRIlgrng
 65d1fD5kictoMSakPRkVD3dX3AhFDJ6qEseiUaEG/atHJr5qsDgWpJ2ksbZVxqWkF3i+
 RTOxNXbrdBD08SfplIUChAd7BGcVo8zcGKtxs72Nw0OX8Wj1Txxa9tjXcOHsnGDLs5Br
 7iPOucXCXrka2pJWrIHqMq8PsChvKcMa47ZPVLvtG14Fwk0tvzfErSM45pLnaGMaLqTW
 UP4uR2s+y7cUKImlonI/n9phO+bNJdCo+A0Iv4v02r8+uKuvTRzminXEVnXTD2MVnfIo nw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2yrpprbcf3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Mar 2020 15:31:21 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02IFLofX133977;
        Wed, 18 Mar 2020 15:29:21 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2ys92gq6m6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Mar 2020 15:29:21 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 02IFTJSk031483;
        Wed, 18 Mar 2020 15:29:19 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 18 Mar 2020 08:29:19 -0700
Date:   Wed, 18 Mar 2020 08:29:19 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>,
        Chandan Rajendra <chandanrlinux@gmail.com>
Subject: Re: [PATCH 5/5] xfs: remove the di_version field from struct icdinode
Message-ID: <20200318152919.GX256767@magnolia>
References: <20200317185756.1063268-1-hch@lst.de>
 <20200317185756.1063268-6-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200317185756.1063268-6-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9564 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 mlxscore=0 spamscore=0 bulkscore=0 adultscore=0 suspectscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003180073
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9564 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 suspectscore=0 lowpriorityscore=0 phishscore=0 adultscore=0 clxscore=1015
 impostorscore=0 priorityscore=1501 spamscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003180073
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 17, 2020 at 07:57:56PM +0100, Christoph Hellwig wrote:
> We know the version is 3 if on a v5 file system.   For earlier file
> systems formats we always upgrade the remaining v1 inodes to v2 and
> thus only use v2 inodes.  Use the xfs_sb_version_has_large_dinode
> helper to check if we deal with small or large dinodes, and thus
> remove the need for the di_version field in struct icdinode.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

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
> index 240d74840306..39c5a6e24915 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -194,16 +194,14 @@ xfs_inode_from_disk(
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
> @@ -241,7 +239,7 @@ xfs_inode_from_disk(
>  	to->di_dmstate	= be16_to_cpu(from->di_dmstate);
>  	to->di_flags	= be16_to_cpu(from->di_flags);
>  
> -	if (to->di_version == 3) {
> +	if (xfs_sb_version_has_v3inode(&ip->i_mount->m_sb)) {
>  		inode_set_iversion_queried(inode,
>  					   be64_to_cpu(from->di_changecount));
>  		to->di_crtime.tv_sec = be32_to_cpu(from->di_crtime.t_sec);
> @@ -263,7 +261,6 @@ xfs_inode_to_disk(
>  	to->di_magic = cpu_to_be16(XFS_DINODE_MAGIC);
>  	to->di_onlink = 0;
>  
> -	to->di_version = from->di_version;
>  	to->di_format = from->di_format;
>  	to->di_uid = cpu_to_be32(i_uid_read(inode));
>  	to->di_gid = cpu_to_be32(i_gid_read(inode));
> @@ -292,7 +289,8 @@ xfs_inode_to_disk(
>  	to->di_dmstate = cpu_to_be16(from->di_dmstate);
>  	to->di_flags = cpu_to_be16(from->di_flags);
>  
> -	if (from->di_version == 3) {
> +	if (xfs_sb_version_has_v3inode(&ip->i_mount->m_sb)) {
> +		to->di_version = 3;
>  		to->di_changecount = cpu_to_be64(inode_peek_iversion(inode));
>  		to->di_crtime.t_sec = cpu_to_be32(from->di_crtime.tv_sec);
>  		to->di_crtime.t_nsec = cpu_to_be32(from->di_crtime.tv_nsec);
> @@ -304,6 +302,7 @@ xfs_inode_to_disk(
>  		uuid_copy(&to->di_uuid, &ip->i_mount->m_sb.sb_meta_uuid);
>  		to->di_flushiter = 0;
>  	} else {
> +		to->di_version = 2;
>  		to->di_flushiter = cpu_to_be16(from->di_flushiter);
>  	}
>  }
> @@ -621,7 +620,6 @@ xfs_iread(
>  	    xfs_sb_version_has_v3inode(&mp->m_sb) &&
>  	    !(mp->m_flags & XFS_MOUNT_IKEEP)) {
>  		VFS_I(ip)->i_generation = prandom_u32();
> -		ip->i_d.di_version = 3;
>  		return 0;
>  	}
>  
> @@ -663,7 +661,6 @@ xfs_iread(
>  		 * Partial initialisation of the in-core inode. Just the bits
>  		 * that xfs_ialloc won't overwrite or relies on being correct.
>  		 */
> -		ip->i_d.di_version = dip->di_version;
>  		VFS_I(ip)->i_generation = be32_to_cpu(dip->di_gen);
>  		ip->i_d.di_flushiter = be16_to_cpu(dip->di_flushiter);
>  
> @@ -677,7 +674,6 @@ xfs_iread(
>  		VFS_I(ip)->i_mode = 0;
>  	}
>  
> -	ASSERT(ip->i_d.di_version >= 2);
>  	ip->i_delayed_blks = 0;
>  
>  	/*
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
> index 66de5964045c..9b373dcf9e34 100644
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
> index 3df4d0af9f22..4f800f7fe888 100644
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
> +	if (xfs_sb_version_has_v3inode(&ip->i_mount->m_sb)) {
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
> +		ASSERT(!xfs_sb_version_has_v3inode(&ip->i_mount->m_sb) ||
>  		       (*src_log_flags & XFS_ILOG_DOWNER));
>  		(*src_log_flags) |= XFS_ILOG_DBROOT;
>  		break;
> @@ -1501,7 +1501,7 @@ xfs_swap_extent_forks(
>  		break;
>  	case XFS_DINODE_FMT_BTREE:
>  		(*target_log_flags) |= XFS_ILOG_DBROOT;
> -		ASSERT(tip->i_d.di_version < 3 ||
> +		ASSERT(!xfs_sb_version_has_v3inode(&ip->i_mount->m_sb) ||
>  		       (*target_log_flags & XFS_ILOG_DOWNER));
>  		break;
>  	}
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index dfb0a452a87d..14b922f2a6db 100644
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
> +	if (xfs_sb_version_has_v3inode(&mp->m_sb)) {
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
> +	if (!xfs_sb_version_has_v3inode(&mp->m_sb))
>  		ip->i_d.di_flushiter++;
>  
>  	/* Check the inline fork data before we write out. */
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index 451f9b6b2806..4a3d13d4a022 100644
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
> +	if (xfs_sb_version_has_v3inode(&ip->i_mount->m_sb)) {
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
> index ad825ffa7e4c..cdfb3cd9a25b 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -1263,7 +1263,7 @@ xfs_ioctl_setattr_xflags(
>  
>  	/* diflags2 only valid for v3 inodes. */
>  	di_flags2 = xfs_flags2diflags2(ip, fa->fsx_xflags);
> -	if (di_flags2 && ip->i_d.di_version < 3)
> +	if (di_flags2 && !xfs_sb_version_has_v3inode(&mp->m_sb))
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
> +	if (xfs_sb_version_has_v3inode(&mp->m_sb) &&
>  	    (ip->i_d.di_flags2 & XFS_DIFLAG2_COWEXTSIZE))
>  		ip->i_d.di_cowextsize = fa->fsx_cowextsize >>
>  				mp->m_sb.sb_blocklog;
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index 87093a05aad7..f7a99b3bbcf7 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -557,7 +557,7 @@ xfs_vn_getattr(
>  	stat->blocks =
>  		XFS_FSB_TO_BB(mp, ip->i_d.di_nblocks + ip->i_delayed_blks);
>  
> -	if (ip->i_d.di_version == 3) {
> +	if (xfs_sb_version_has_v3inode(&mp->m_sb)) {
>  		if (request_mask & STATX_BTIME) {
>  			stat->result_mask |= STATX_BTIME;
>  			stat->btime = ip->i_d.di_crtime;
> diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
> index d10660469884..ff2da28fed90 100644
> --- a/fs/xfs/xfs_itable.c
> +++ b/fs/xfs/xfs_itable.c
> @@ -110,7 +110,7 @@ xfs_bulkstat_one_int(
>  	buf->bs_forkoff = XFS_IFORK_BOFF(ip);
>  	buf->bs_version = XFS_BULKSTAT_VERSION_V5;
>  
> -	if (dic->di_version == 3) {
> +	if (xfs_sb_version_has_v3inode(&mp->m_sb)) {
>  		if (dic->di_flags2 & XFS_DIFLAG2_COWEXTSIZE)
>  			buf->bs_cowextsize_blks = dic->di_cowextsize;
>  	}
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 308cc5dcac14..11c3502b07b1 100644
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
> -- 
> 2.24.1
> 
