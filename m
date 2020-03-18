Return-Path: <SRS0=sZmN=5D=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4970EC10DCE
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Mar 2020 16:17:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 15D4F2071C
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Mar 2020 16:17:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="crPCbL9m"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726903AbgCRQRc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Mar 2020 12:17:32 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:37816 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726473AbgCRQRc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Mar 2020 12:17:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584548250;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HT5sI7N96lC4/PITaS1UR7Bk5oKnLhLI23BYwkOZPl0=;
        b=crPCbL9mnGGF+CAUpyQpk5u61Y535f/nrV9IfX3u2UjMvrZdSsIiN24q+880/wkze5frXa
        75udBX6MMEkIEYkiKaDFLI1pseN1nK2dp46/M0x+PttrkbDgc2enFFsGAyViG1ZRtEv49R
        KvuwmEUk/SwK3iLhzQr+BbPuaUkkK+A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-467-tl5sppXKM7OzNZkPQEPqrg-1; Wed, 18 Mar 2020 12:17:28 -0400
X-MC-Unique: tl5sppXKM7OzNZkPQEPqrg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D8A5B18FF661;
        Wed, 18 Mar 2020 16:17:27 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7A0DA5C1D8;
        Wed, 18 Mar 2020 16:17:27 +0000 (UTC)
Date:   Wed, 18 Mar 2020 12:17:25 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/5] xfs: add a new xfs_sb_version_has_v3inode helper
Message-ID: <20200318161725.GF32848@bfoster>
References: <20200317185756.1063268-1-hch@lst.de>
 <20200317185756.1063268-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200317185756.1063268-2-hch@lst.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
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
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

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

