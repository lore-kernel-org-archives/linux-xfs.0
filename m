Return-Path: <SRS0=sZmN=5D=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EE1EC10DCE
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Mar 2020 15:33:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EC3E320724
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Mar 2020 15:33:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qfWjl/v1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726777AbgCRPdt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Mar 2020 11:33:49 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:40134 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726671AbgCRPdt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Mar 2020 11:33:49 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02IFO7Pt084855;
        Wed, 18 Mar 2020 15:33:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=2bk/ZsRG+uxDxnIXHWuw7hiAIFmMjmoZ2PIiSa4q4D8=;
 b=qfWjl/v1gKqV8OG2OLHZS9Ce3RjbvZtvHs+vQQ/tszVAAoTtrFkw0myD13Dt2GQvX9Gu
 gERIMUYHat5Awvi7Gu+GIaqPUu9dKL655ZaYrDa/zWnMZ0y4i5PELZz9RjbefE4Sxai4
 68iy9/40HCcPOEUBHClC3CQUruJ7yu0N7fmt6Phy4SNdcSiwIGyv2Yel3+GLuVBlWHyW
 whhRT/7F9HPVUVdQfDsirDtQ8+ikvO0Tbdq/aGNo12drZYuiUzWJ8F1l1nzJF2vkFCeY
 tYdHHFXjJApqy52tNwSyHTBlKyniP72CboVOfvmG+mxEEQgoI4fbSU4yZME3ep4DSjJU CQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2yub2736vx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Mar 2020 15:33:45 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02IFMfJS144432;
        Wed, 18 Mar 2020 15:33:45 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2ys8tu16wf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Mar 2020 15:33:44 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 02IFXiKW003429;
        Wed, 18 Mar 2020 15:33:44 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 18 Mar 2020 08:33:44 -0700
Date:   Wed, 18 Mar 2020 08:33:43 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/5] xfs: add a new xfs_sb_version_has_v3inode helper
Message-ID: <20200318153343.GB256767@magnolia>
References: <20200317185756.1063268-1-hch@lst.de>
 <20200317185756.1063268-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200317185756.1063268-2-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9564 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 mlxscore=0
 malwarescore=0 suspectscore=0 mlxlogscore=999 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003180073
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9564 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 impostorscore=0
 mlxlogscore=999 mlxscore=0 phishscore=0 adultscore=0 suspectscore=0
 clxscore=1015 priorityscore=1501 lowpriorityscore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003180073
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 17, 2020 at 07:57:52PM +0100, Christoph Hellwig wrote:
> Add a new wrapper to check if a file system supports the v3 inode format
> with a larger dinode core.  Previously we used xfs_sb_version_hascrc for
> that, which is technically correct but a little confusing to read.
> 
> Also move xfs_dinode_good_version next to xfs_sb_version_has_v3inode
> so that we have one place that documents the superblock version to
> inode version relationship.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok, will test...
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

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
> -- 
> 2.24.1
> 
