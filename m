Return-Path: <SRS0=1m5L=5B=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E41BC0044D
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Mar 2020 13:16:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5AF522071C
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Mar 2020 13:16:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Xj5FZC1t"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731142AbgCPNQz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 16 Mar 2020 09:16:55 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:48719 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731033AbgCPNQz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Mar 2020 09:16:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584364614;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pqm+NftfO0YXMxrfmslAQD5KKUXxLwKMB3C+DK5CWic=;
        b=Xj5FZC1tkn09IfKr0rSRHSh+AWeqTPhnScoQDoJ2sv/o9ArZzN+ckqws33tkFVyCfC2UNN
        KV5ozpmqXlJ71wCFPyvDnesXH2vLvFMSXwqEEPlBlv3ZICv0OU4tkYIcJyTgK1DAnGw7kz
        y9hJblqlcvFyfFG9jcIxxtkDzH8qmVI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-359-fzqE1W0sNFyVXkVQ_DFKEA-1; Mon, 16 Mar 2020 09:16:53 -0400
X-MC-Unique: fzqE1W0sNFyVXkVQ_DFKEA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 137D8800EBC;
        Mon, 16 Mar 2020 13:16:52 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 95A911001DEF;
        Mon, 16 Mar 2020 13:16:51 +0000 (UTC)
Date:   Mon, 16 Mar 2020 09:16:49 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/5] xfs: add a new xfs_sb_version_has_large_dinode helper
Message-ID: <20200316131649.GE12313@bfoster>
References: <20200312142235.550766-1-hch@lst.de>
 <20200312142235.550766-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200312142235.550766-2-hch@lst.de>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 12, 2020 at 03:22:31PM +0100, Christoph Hellwig wrote:
> Add a new wrapper to check if a file system supports the newer large
> dinode format.  Previously we uses xfs_sb_version_hascrc for that,
> which is technically correct but a little confusing to read.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_format.h     |  5 +++++
>  fs/xfs/libxfs/xfs_ialloc.c     |  4 ++--
>  fs/xfs/libxfs/xfs_inode_buf.c  | 12 ++++++++----
>  fs/xfs/libxfs/xfs_trans_resv.c |  2 +-
>  fs/xfs/xfs_buf_item.c          |  2 +-
>  fs/xfs/xfs_log_recover.c       |  2 +-
>  6 files changed, 18 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index cd814f99da28..a28bf6a978ad 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -497,6 +497,11 @@ static inline bool xfs_sb_version_hascrc(struct xfs_sb *sbp)
>  	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5;
>  }
>  

A comment would be useful here to indicate what this means (i.e., we can
assume v3 inode format). The function name is a little vague too I
suppose (will the inode ever get larger than large? :P). I wonder if
something like _has_v3_inode() is more clear, but we can always change
it easily enough and either way is better than hascrc() IMO.

Brian

> +static inline bool xfs_sb_version_has_large_dinode(struct xfs_sb *sbp)
> +{
> +	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5;
> +}
> +
>  static inline bool xfs_sb_version_has_pquotino(struct xfs_sb *sbp)
>  {
>  	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5;
> diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> index b4a404278935..6adffaa68fb8 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.c
> +++ b/fs/xfs/libxfs/xfs_ialloc.c
> @@ -304,7 +304,7 @@ xfs_ialloc_inode_init(
>  	 * That means for v3 inode we log the entire buffer rather than just the
>  	 * inode cores.
>  	 */
> -	if (xfs_sb_version_hascrc(&mp->m_sb)) {
> +	if (xfs_sb_version_has_large_dinode(&mp->m_sb)) {
>  		version = 3;
>  		ino = XFS_AGINO_TO_INO(mp, agno, XFS_AGB_TO_AGINO(mp, agbno));
>  
> @@ -2872,7 +2872,7 @@ xfs_ialloc_setup_geometry(
>  	 * cannot change the behavior.
>  	 */
>  	igeo->inode_cluster_size_raw = XFS_INODE_BIG_CLUSTER_SIZE;
> -	if (xfs_sb_version_hascrc(&mp->m_sb)) {
> +	if (xfs_sb_version_has_large_dinode(&mp->m_sb)) {
>  		int	new_size = igeo->inode_cluster_size_raw;
>  
>  		new_size *= mp->m_sb.sb_inodesize / XFS_DINODE_MIN_SIZE;
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index 17e88a8c8353..a5aa2f220c28 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -44,14 +44,18 @@ xfs_inobp_check(
>  }
>  #endif
>  
> +/*
> + * v4 and earlier file systems only support the small dinode, and must use the
> + * v1 or v2 inode formats.  v5 file systems support a larger dinode, and must
> + * use the v3 inode format.
> + */
>  bool
>  xfs_dinode_good_version(
>  	struct xfs_mount *mp,
>  	__u8		version)
>  {
> -	if (xfs_sb_version_hascrc(&mp->m_sb))
> +	if (xfs_sb_version_has_large_dinode(&mp->m_sb))
>  		return version == 3;
> -
>  	return version == 1 || version == 2;
>  }
>  
> @@ -454,7 +458,7 @@ xfs_dinode_verify(
>  
>  	/* Verify v3 integrity information first */
>  	if (dip->di_version >= 3) {
> -		if (!xfs_sb_version_hascrc(&mp->m_sb))
> +		if (!xfs_sb_version_has_large_dinode(&mp->m_sb))
>  			return __this_address;
>  		if (!xfs_verify_cksum((char *)dip, mp->m_sb.sb_inodesize,
>  				      XFS_DINODE_CRC_OFF))
> @@ -629,7 +633,7 @@ xfs_iread(
>  
>  	/* shortcut IO on inode allocation if possible */
>  	if ((iget_flags & XFS_IGET_CREATE) &&
> -	    xfs_sb_version_hascrc(&mp->m_sb) &&
> +	    xfs_sb_version_has_large_dinode(&mp->m_sb) &&
>  	    !(mp->m_flags & XFS_MOUNT_IKEEP)) {
>  		VFS_I(ip)->i_generation = prandom_u32();
>  		ip->i_d.di_version = 3;
> diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
> index 7a9c04920505..294e23d47912 100644
> --- a/fs/xfs/libxfs/xfs_trans_resv.c
> +++ b/fs/xfs/libxfs/xfs_trans_resv.c
> @@ -187,7 +187,7 @@ xfs_calc_inode_chunk_res(
>  			       XFS_FSB_TO_B(mp, 1));
>  	if (alloc) {
>  		/* icreate tx uses ordered buffers */
> -		if (xfs_sb_version_hascrc(&mp->m_sb))
> +		if (xfs_sb_version_has_large_dinode(&mp->m_sb))
>  			return res;
>  		size = XFS_FSB_TO_B(mp, 1);
>  	}
> diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> index 663810e6cd59..d004ae3455d7 100644
> --- a/fs/xfs/xfs_buf_item.c
> +++ b/fs/xfs/xfs_buf_item.c
> @@ -345,7 +345,7 @@ xfs_buf_item_format(
>  	 * occurs during recovery.
>  	 */
>  	if (bip->bli_flags & XFS_BLI_INODE_BUF) {
> -		if (xfs_sb_version_hascrc(&lip->li_mountp->m_sb) ||
> +		if (xfs_sb_version_has_large_dinode(&lip->li_mountp->m_sb) ||
>  		    !((bip->bli_flags & XFS_BLI_INODE_ALLOC_BUF) &&
>  		      xfs_log_item_in_current_chkpt(lip)))
>  			bip->__bli_format.blf_flags |= XFS_BLF_INODE_BUF;
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 6abc0863c9c3..e5e976b5cc11 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -2997,7 +2997,7 @@ xlog_recover_inode_pass2(
>  	 * superblock flag to determine whether we need to look at di_flushiter
>  	 * to skip replay when the on disk inode is newer than the log one
>  	 */
> -	if (!xfs_sb_version_hascrc(&mp->m_sb) &&
> +	if (!xfs_sb_version_has_large_dinode(&mp->m_sb) &&
>  	    ldip->di_flushiter < be16_to_cpu(dip->di_flushiter)) {
>  		/*
>  		 * Deal with the wrap case, DI_MAX_FLUSH is less
> -- 
> 2.24.1
> 

