Return-Path: <SRS0=sZmN=5D=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBF62C10DCE
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Mar 2020 09:56:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BF98620767
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Mar 2020 09:56:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726550AbgCRJ4L (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Mar 2020 05:56:11 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:11514 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726310AbgCRJ4L (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Mar 2020 05:56:11 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02I9W8ur014185
        for <linux-xfs@vger.kernel.org>; Wed, 18 Mar 2020 05:56:10 -0400
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2yu719ksvf-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Wed, 18 Mar 2020 05:56:09 -0400
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.ibm.com>;
        Wed, 18 Mar 2020 09:56:07 -0000
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 18 Mar 2020 09:56:06 -0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 02I9u5Jw51839124
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Mar 2020 09:56:05 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9DA8111C064;
        Wed, 18 Mar 2020 09:56:05 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D44EF11C054;
        Wed, 18 Mar 2020 09:56:04 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.199.34.131])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 18 Mar 2020 09:56:04 +0000 (GMT)
From:   Chandan Rajendra <chandan@linux.ibm.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/5] xfs: add a new xfs_sb_version_has_v3inode helper
Date:   Wed, 18 Mar 2020 15:29:04 +0530
Organization: IBM
In-Reply-To: <20200317185756.1063268-2-hch@lst.de>
References: <20200317185756.1063268-1-hch@lst.de> <20200317185756.1063268-2-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-TM-AS-GCONF: 00
x-cbid: 20031809-0016-0000-0000-000002F31ABB
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20031809-0017-0000-0000-000033569F25
Message-Id: <9109512.9DYhazWb1d@localhost.localdomain>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-18_03:2020-03-17,2020-03-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 lowpriorityscore=0 malwarescore=0 impostorscore=0 mlxscore=0 phishscore=0
 priorityscore=1501 adultscore=0 clxscore=1015 bulkscore=0 mlxlogscore=999
 suspectscore=1 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003180046
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wednesday, March 18, 2020 12:27 AM Christoph Hellwig wrote: 
> Add a new wrapper to check if a file system supports the v3 inode format
> with a larger dinode core.  Previously we used xfs_sb_version_hascrc for
> that, which is technically correct but a little confusing to read.
> 
> Also move xfs_dinode_good_version next to xfs_sb_version_has_v3inode
> so that we have one place that documents the superblock version to
> inode version relationship.
>

The changes look good to me,

Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_format.h     | 17 +++++++++++++++++
>  fs/xfs/libxfs/xfs_ialloc.c     |  4 ++--
>  fs/xfs/libxfs/xfs_inode_buf.c  | 17 +++--------------
>  fs/xfs/libxfs/xfs_inode_buf.h  |  2 --
>  fs/xfs/libxfs/xfs_trans_resv.c |  2 +-
>  fs/xfs/xfs_buf_item.c          |  2 +-
>  fs/xfs/xfs_log_recover.c       |  2 +-
>  7 files changed, 25 insertions(+), 21 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index cd814f99da28..19899d48517c 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -497,6 +497,23 @@ static inline bool xfs_sb_version_hascrc(struct xfs_sb *sbp)
>  	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5;
>  }
>  
> +/*
> + * v5 file systems support V3 inodes only, earlier file systems support
> + * v2 and v1 inodes.
> + */
> +static inline bool xfs_sb_version_has_v3inode(struct xfs_sb *sbp)
> +{
> +	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5;
> +}
> +
> +static inline bool xfs_dinode_good_version(struct xfs_sb *sbp,
> +		uint8_t version)
> +{
> +	if (xfs_sb_version_has_v3inode(sbp))
> +		return version == 3;
> +	return version == 1 || version == 2;
> +}
> +
>  static inline bool xfs_sb_version_has_pquotino(struct xfs_sb *sbp)
>  {
>  	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5;
> diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> index 21ac3fb52f4e..4de61af3b840 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.c
> +++ b/fs/xfs/libxfs/xfs_ialloc.c
> @@ -304,7 +304,7 @@ xfs_ialloc_inode_init(
>  	 * That means for v3 inode we log the entire buffer rather than just the
>  	 * inode cores.
>  	 */
> -	if (xfs_sb_version_hascrc(&mp->m_sb)) {
> +	if (xfs_sb_version_has_v3inode(&mp->m_sb)) {
>  		version = 3;
>  		ino = XFS_AGINO_TO_INO(mp, agno, XFS_AGB_TO_AGINO(mp, agbno));
>  
> @@ -2872,7 +2872,7 @@ xfs_ialloc_setup_geometry(
>  	 * cannot change the behavior.
>  	 */
>  	igeo->inode_cluster_size_raw = XFS_INODE_BIG_CLUSTER_SIZE;
> -	if (xfs_sb_version_hascrc(&mp->m_sb)) {
> +	if (xfs_sb_version_has_v3inode(&mp->m_sb)) {
>  		int	new_size = igeo->inode_cluster_size_raw;
>  
>  		new_size *= mp->m_sb.sb_inodesize / XFS_DINODE_MIN_SIZE;
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index 17e88a8c8353..c862c8f1aaa9 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -44,17 +44,6 @@ xfs_inobp_check(
>  }
>  #endif
>  
> -bool
> -xfs_dinode_good_version(
> -	struct xfs_mount *mp,
> -	__u8		version)
> -{
> -	if (xfs_sb_version_hascrc(&mp->m_sb))
> -		return version == 3;
> -
> -	return version == 1 || version == 2;
> -}
> -
>  /*
>   * If we are doing readahead on an inode buffer, we might be in log recovery
>   * reading an inode allocation buffer that hasn't yet been replayed, and hence
> @@ -93,7 +82,7 @@ xfs_inode_buf_verify(
>  		dip = xfs_buf_offset(bp, (i << mp->m_sb.sb_inodelog));
>  		unlinked_ino = be32_to_cpu(dip->di_next_unlinked);
>  		di_ok = xfs_verify_magic16(bp, dip->di_magic) &&
> -			xfs_dinode_good_version(mp, dip->di_version) &&
> +			xfs_dinode_good_version(&mp->m_sb, dip->di_version) &&
>  			xfs_verify_agino_or_null(mp, agno, unlinked_ino);
>  		if (unlikely(XFS_TEST_ERROR(!di_ok, mp,
>  						XFS_ERRTAG_ITOBP_INOTOBP))) {
> @@ -454,7 +443,7 @@ xfs_dinode_verify(
>  
>  	/* Verify v3 integrity information first */
>  	if (dip->di_version >= 3) {
> -		if (!xfs_sb_version_hascrc(&mp->m_sb))
> +		if (!xfs_sb_version_has_v3inode(&mp->m_sb))
>  			return __this_address;
>  		if (!xfs_verify_cksum((char *)dip, mp->m_sb.sb_inodesize,
>  				      XFS_DINODE_CRC_OFF))
> @@ -629,7 +618,7 @@ xfs_iread(
>  
>  	/* shortcut IO on inode allocation if possible */
>  	if ((iget_flags & XFS_IGET_CREATE) &&
> -	    xfs_sb_version_hascrc(&mp->m_sb) &&
> +	    xfs_sb_version_has_v3inode(&mp->m_sb) &&
>  	    !(mp->m_flags & XFS_MOUNT_IKEEP)) {
>  		VFS_I(ip)->i_generation = prandom_u32();
>  		ip->i_d.di_version = 3;
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
> index 2683e1e2c4a6..66de5964045c 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.h
> +++ b/fs/xfs/libxfs/xfs_inode_buf.h
> @@ -59,8 +59,6 @@ void	xfs_inode_from_disk(struct xfs_inode *ip, struct xfs_dinode *from);
>  void	xfs_log_dinode_to_disk(struct xfs_log_dinode *from,
>  			       struct xfs_dinode *to);
>  
> -bool	xfs_dinode_good_version(struct xfs_mount *mp, __u8 version);
> -
>  #if defined(DEBUG)
>  void	xfs_inobp_check(struct xfs_mount *, struct xfs_buf *);
>  #else
> diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
> index 7a9c04920505..d1a0848cb52e 100644
> --- a/fs/xfs/libxfs/xfs_trans_resv.c
> +++ b/fs/xfs/libxfs/xfs_trans_resv.c
> @@ -187,7 +187,7 @@ xfs_calc_inode_chunk_res(
>  			       XFS_FSB_TO_B(mp, 1));
>  	if (alloc) {
>  		/* icreate tx uses ordered buffers */
> -		if (xfs_sb_version_hascrc(&mp->m_sb))
> +		if (xfs_sb_version_has_v3inode(&mp->m_sb))
>  			return res;
>  		size = XFS_FSB_TO_B(mp, 1);
>  	}
> diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> index 663810e6cd59..1545657c3ca0 100644
> --- a/fs/xfs/xfs_buf_item.c
> +++ b/fs/xfs/xfs_buf_item.c
> @@ -345,7 +345,7 @@ xfs_buf_item_format(
>  	 * occurs during recovery.
>  	 */
>  	if (bip->bli_flags & XFS_BLI_INODE_BUF) {
> -		if (xfs_sb_version_hascrc(&lip->li_mountp->m_sb) ||
> +		if (xfs_sb_version_has_v3inode(&lip->li_mountp->m_sb) ||
>  		    !((bip->bli_flags & XFS_BLI_INODE_ALLOC_BUF) &&
>  		      xfs_log_item_in_current_chkpt(lip)))
>  			bip->__bli_format.blf_flags |= XFS_BLF_INODE_BUF;
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 6abc0863c9c3..c467488212c2 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -2997,7 +2997,7 @@ xlog_recover_inode_pass2(
>  	 * superblock flag to determine whether we need to look at di_flushiter
>  	 * to skip replay when the on disk inode is newer than the log one
>  	 */
> -	if (!xfs_sb_version_hascrc(&mp->m_sb) &&
> +	if (!xfs_sb_version_has_v3inode(&mp->m_sb) &&
>  	    ldip->di_flushiter < be16_to_cpu(dip->di_flushiter)) {
>  		/*
>  		 * Deal with the wrap case, DI_MAX_FLUSH is less
> 


-- 
chandan



