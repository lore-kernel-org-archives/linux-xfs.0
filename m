Return-Path: <SRS0=iJk4=43=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 763E5C10F27
	for <linux-xfs@archiver.kernel.org>; Tue, 10 Mar 2020 11:34:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3F07924686
	for <linux-xfs@archiver.kernel.org>; Tue, 10 Mar 2020 11:34:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="C8Tiya+G"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726224AbgCJLez (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 Mar 2020 07:34:55 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:45143 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726205AbgCJLey (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Mar 2020 07:34:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583840094;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZOCwMpAMVE9wtaP/VHLmnpKjiqO3cM0OvoSFs/1p7KY=;
        b=C8Tiya+GhiEdqkyUHi8bZKsD01NqIlRparow9EE9i0FGaVAifd5hKrNfSsNDq1H/PgCo59
        cUkQFT6E4kwLiMTM2QCp9jqDdG6HBt0ng2k8cULjnplKw/DN8kBbYvpYvBw1NibTqsMtxO
        GseKQ5/+OZXRYXvbXLmr1GfiFBFZdno=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-44-pMkAeRPyN42YtH7tuTjXiQ-1; Tue, 10 Mar 2020 07:34:52 -0400
X-MC-Unique: pMkAeRPyN42YtH7tuTjXiQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 83EEA800D5A;
        Tue, 10 Mar 2020 11:34:51 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9612760C87;
        Tue, 10 Mar 2020 11:34:48 +0000 (UTC)
Date:   Tue, 10 Mar 2020 07:34:46 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 6/6] xfs: remove XFS_BUF_TO_SBP
Message-ID: <20200310113446.GF50276@bfoster>
References: <20200306145220.242562-1-hch@lst.de>
 <20200306145220.242562-7-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200306145220.242562-7-hch@lst.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 06, 2020 at 07:52:20AM -0700, Christoph Hellwig wrote:
> Just dereference bp->b_addr directly and make the code a little
> simpler and more clear.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_ag.c         |  2 +-
>  fs/xfs/libxfs/xfs_format.h     |  1 -
>  fs/xfs/libxfs/xfs_sb.c         | 17 +++++++++--------
>  fs/xfs/scrub/agheader.c        |  2 +-
>  fs/xfs/scrub/agheader_repair.c |  2 +-
>  fs/xfs/xfs_log_recover.c       |  2 +-
>  fs/xfs/xfs_mount.c             |  2 +-
>  fs/xfs/xfs_trans.c             |  2 +-
>  8 files changed, 15 insertions(+), 15 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
> index 447e363d8468..f9b8c177ebc3 100644
> --- a/fs/xfs/libxfs/xfs_ag.c
> +++ b/fs/xfs/libxfs/xfs_ag.c
> @@ -231,7 +231,7 @@ xfs_sbblock_init(
>  	struct xfs_buf		*bp,
>  	struct aghdr_init_data	*id)
>  {
> -	struct xfs_dsb		*dsb = XFS_BUF_TO_SBP(bp);
> +	struct xfs_dsb		*dsb = bp->b_addr;
>  
>  	xfs_sb_to_disk(dsb, &mp->m_sb);
>  	dsb->sb_inprogress = 1;
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index 03531f0f537a..81a1b7084008 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -560,7 +560,6 @@ xfs_is_quota_inode(struct xfs_sb *sbp, xfs_ino_t ino)
>  
>  #define XFS_SB_DADDR		((xfs_daddr_t)0) /* daddr in filesystem/ag */
>  #define	XFS_SB_BLOCK(mp)	XFS_HDR_BLOCK(mp, XFS_SB_DADDR)
> -#define XFS_BUF_TO_SBP(bp)	((xfs_dsb_t *)((bp)->b_addr))
>  
>  #define	XFS_HDR_BLOCK(mp,d)	((xfs_agblock_t)XFS_BB_TO_FSBT(mp,d))
>  #define	XFS_DADDR_TO_FSB(mp,d)	XFS_AGB_TO_FSB(mp, \
> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> index 2f60fc3c99a0..00266de58954 100644
> --- a/fs/xfs/libxfs/xfs_sb.c
> +++ b/fs/xfs/libxfs/xfs_sb.c
> @@ -220,7 +220,7 @@ xfs_validate_sb_common(
>  	struct xfs_buf		*bp,
>  	struct xfs_sb		*sbp)
>  {
> -	struct xfs_dsb		*dsb = XFS_BUF_TO_SBP(bp);
> +	struct xfs_dsb		*dsb = bp->b_addr;
>  	uint32_t		agcount = 0;
>  	uint32_t		rem;
>  
> @@ -681,7 +681,7 @@ xfs_sb_read_verify(
>  {
>  	struct xfs_sb		sb;
>  	struct xfs_mount	*mp = bp->b_mount;
> -	struct xfs_dsb		*dsb = XFS_BUF_TO_SBP(bp);
> +	struct xfs_dsb		*dsb = bp->b_addr;
>  	int			error;
>  
>  	/*
> @@ -707,7 +707,7 @@ xfs_sb_read_verify(
>  	 * Check all the superblock fields.  Don't byteswap the xquota flags
>  	 * because _verify_common checks the on-disk values.
>  	 */
> -	__xfs_sb_from_disk(&sb, XFS_BUF_TO_SBP(bp), false);
> +	__xfs_sb_from_disk(&sb, dsb, false);
>  	error = xfs_validate_sb_common(mp, bp, &sb);
>  	if (error)
>  		goto out_error;
> @@ -730,7 +730,7 @@ static void
>  xfs_sb_quiet_read_verify(
>  	struct xfs_buf	*bp)
>  {
> -	struct xfs_dsb	*dsb = XFS_BUF_TO_SBP(bp);
> +	struct xfs_dsb	*dsb = bp->b_addr;
>  
>  	if (dsb->sb_magicnum == cpu_to_be32(XFS_SB_MAGIC)) {
>  		/* XFS filesystem, verify noisily! */
> @@ -748,13 +748,14 @@ xfs_sb_write_verify(
>  	struct xfs_sb		sb;
>  	struct xfs_mount	*mp = bp->b_mount;
>  	struct xfs_buf_log_item	*bip = bp->b_log_item;
> +	struct xfs_dsb		*dsb = bp->b_addr;
>  	int			error;
>  
>  	/*
>  	 * Check all the superblock fields.  Don't byteswap the xquota flags
>  	 * because _verify_common checks the on-disk values.
>  	 */
> -	__xfs_sb_from_disk(&sb, XFS_BUF_TO_SBP(bp), false);
> +	__xfs_sb_from_disk(&sb, dsb, false);
>  	error = xfs_validate_sb_common(mp, bp, &sb);
>  	if (error)
>  		goto out_error;
> @@ -766,7 +767,7 @@ xfs_sb_write_verify(
>  		return;
>  
>  	if (bip)
> -		XFS_BUF_TO_SBP(bp)->sb_lsn = cpu_to_be64(bip->bli_item.li_lsn);
> +		dsb->sb_lsn = cpu_to_be64(bip->bli_item.li_lsn);
>  
>  	xfs_buf_update_cksum(bp, XFS_SB_CRC_OFF);
>  	return;
> @@ -927,7 +928,7 @@ xfs_log_sb(
>  	mp->m_sb.sb_ifree = percpu_counter_sum(&mp->m_ifree);
>  	mp->m_sb.sb_fdblocks = percpu_counter_sum(&mp->m_fdblocks);
>  
> -	xfs_sb_to_disk(XFS_BUF_TO_SBP(bp), &mp->m_sb);
> +	xfs_sb_to_disk(bp->b_addr, &mp->m_sb);
>  	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_SB_BUF);
>  	xfs_trans_log_buf(tp, bp, 0, sizeof(struct xfs_dsb) - 1);
>  }
> @@ -1007,7 +1008,7 @@ xfs_update_secondary_sbs(
>  		bp->b_ops = &xfs_sb_buf_ops;
>  		xfs_buf_oneshot(bp);
>  		xfs_buf_zero(bp, 0, BBTOB(bp->b_length));
> -		xfs_sb_to_disk(XFS_BUF_TO_SBP(bp), &mp->m_sb);
> +		xfs_sb_to_disk(bp->b_addr, &mp->m_sb);
>  		xfs_buf_delwri_queue(bp, &buffer_list);
>  		xfs_buf_relse(bp);
>  
> diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
> index 163478855e7b..e9bcf1faa183 100644
> --- a/fs/xfs/scrub/agheader.c
> +++ b/fs/xfs/scrub/agheader.c
> @@ -92,7 +92,7 @@ xchk_superblock(
>  	if (!xchk_process_error(sc, agno, XFS_SB_BLOCK(mp), &error))
>  		return error;
>  
> -	sb = XFS_BUF_TO_SBP(bp);
> +	sb = bp->b_addr;
>  
>  	/*
>  	 * Verify the geometries match.  Fields that are permanently
> diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
> index c801f5892210..31dbb5d556fd 100644
> --- a/fs/xfs/scrub/agheader_repair.c
> +++ b/fs/xfs/scrub/agheader_repair.c
> @@ -49,7 +49,7 @@ xrep_superblock(
>  
>  	/* Copy AG 0's superblock to this one. */
>  	xfs_buf_zero(bp, 0, BBTOB(bp->b_length));
> -	xfs_sb_to_disk(XFS_BUF_TO_SBP(bp), &mp->m_sb);
> +	xfs_sb_to_disk(bp->b_addr, &mp->m_sb);
>  
>  	/* Write this to disk. */
>  	xfs_trans_buf_set_type(sc->tp, bp, XFS_BLFT_SB_BUF);
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index b6cf99f7153f..6abc0863c9c3 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -5636,7 +5636,7 @@ xlog_do_recover(
>  
>  	/* Convert superblock from on-disk format */
>  	sbp = &mp->m_sb;
> -	xfs_sb_from_disk(sbp, XFS_BUF_TO_SBP(bp));
> +	xfs_sb_from_disk(sbp, bp->b_addr);
>  	xfs_buf_relse(bp);
>  
>  	/* re-initialise in-core superblock and geometry structures */
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index 56efe140c923..c5513e5a226a 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -310,7 +310,7 @@ xfs_readsb(
>  	/*
>  	 * Initialize the mount structure from the superblock.
>  	 */
> -	xfs_sb_from_disk(sbp, XFS_BUF_TO_SBP(bp));
> +	xfs_sb_from_disk(sbp, bp->b_addr);
>  
>  	/*
>  	 * If we haven't validated the superblock, do so now before we try
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index 3b208f9a865c..73c534093f09 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -450,7 +450,7 @@ xfs_trans_apply_sb_deltas(
>  	int		whole = 0;
>  
>  	bp = xfs_trans_getsb(tp, tp->t_mountp);
> -	sbp = XFS_BUF_TO_SBP(bp);
> +	sbp = bp->b_addr;
>  
>  	/*
>  	 * Check that superblock mods match the mods made to AGF counters.
> -- 
> 2.24.1
> 

