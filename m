Return-Path: <SRS0=Vfs/=DQ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4DF8C433DF
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Oct 2020 11:32:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A22222268
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Oct 2020 11:32:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OKponI/z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732208AbgJILc4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 9 Oct 2020 07:32:56 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54084 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729986AbgJILcz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Oct 2020 07:32:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602243173;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=o5q46GWVpUwwuBLO26ow+MAn2CxD0q2DtjbU+4uvkVQ=;
        b=OKponI/zITgsoYQ2Sc8uQ3Xm793HbJHgP8YfeRLR5UZNEvYk/murjMC+iBcX1koeY33yQk
        By5P70+BQcTKR69mw3H6oR6wEvP9nVA0z6Pq4PTfZWrAR2tos62qh5QqP6klvpEpSjxotY
        pCHlQZ4xDBlRByWLath6nyKZeDpoiLs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-237-NNyJNzMCNua6apA9DzBsbQ-1; Fri, 09 Oct 2020 07:32:52 -0400
X-MC-Unique: NNyJNzMCNua6apA9DzBsbQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C8F6918A822E;
        Fri,  9 Oct 2020 11:32:50 +0000 (UTC)
Received: from bfoster (ovpn-112-249.rdu2.redhat.com [10.10.112.249])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 41AA17664E;
        Fri,  9 Oct 2020 11:32:50 +0000 (UTC)
Date:   Fri, 9 Oct 2020 07:32:48 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     xiakaixu1987@gmail.com
Cc:     linux-xfs@vger.kernel.org, darrick.wong@oracle.com,
        Kaixu Xia <kaixuxia@tencent.com>
Subject: Re: [PATCH v4 2/3] xfs: check tp->t_dqinfo value instead of the
 XFS_TRANS_DQ_DIRTY flag
Message-ID: <20201009113248.GD769470@bfoster>
References: <1602130749-23093-1-git-send-email-kaixuxia@tencent.com>
 <1602130749-23093-3-git-send-email-kaixuxia@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1602130749-23093-3-git-send-email-kaixuxia@tencent.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 08, 2020 at 12:19:08PM +0800, xiakaixu1987@gmail.com wrote:
> From: Kaixu Xia <kaixuxia@tencent.com>
> 
> Nowadays the only things that the XFS_TRANS_DQ_DIRTY flag seems to do
> are indicates the tp->t_dqinfo->dqs[XFS_QM_TRANS_{USR,GRP,PRJ}] values
> changed and check in xfs_trans_apply_dquot_deltas() and the unreserve
> variant xfs_trans_unreserve_and_mod_dquots(). Actually, we also can
> use the tp->t_dqinfo value instead of the XFS_TRANS_DQ_DIRTY flag, that
> is to say, we allocate the new tp->t_dqinfo only when the qtrx values
> changed, so the tp->t_dqinfo value isn't NULL equals the XFS_TRANS_DQ_DIRTY
> flag is set, we only need to check if tp->t_dqinfo == NULL in
> xfs_trans_apply_dquot_deltas() and its unreserve variant to determine
> whether lock all of the dquots and join them to the transaction.
> 
> Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_shared.h |  1 -
>  fs/xfs/xfs_inode.c         |  8 +-------
>  fs/xfs/xfs_trans_dquot.c   | 13 ++-----------
>  3 files changed, 3 insertions(+), 19 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_shared.h b/fs/xfs/libxfs/xfs_shared.h
> index c795ae47b3c9..8c61a461bf7b 100644
> --- a/fs/xfs/libxfs/xfs_shared.h
> +++ b/fs/xfs/libxfs/xfs_shared.h
> @@ -62,7 +62,6 @@ void	xfs_log_get_max_trans_res(struct xfs_mount *mp,
>  #define	XFS_TRANS_SB_DIRTY	0x02	/* superblock is modified */
>  #define	XFS_TRANS_PERM_LOG_RES	0x04	/* xact took a permanent log res */
>  #define	XFS_TRANS_SYNC		0x08	/* make commit synchronous */
> -#define XFS_TRANS_DQ_DIRTY	0x10	/* at least one dquot in trx dirty */
>  #define XFS_TRANS_RESERVE	0x20    /* OK to use reserved data blocks */
>  #define XFS_TRANS_NO_WRITECOUNT 0x40	/* do not elevate SB writecount */
>  #define XFS_TRANS_RES_FDBLKS	0x80	/* reserve newly freed blocks */
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 2bfbcf28b1bd..4d2cebaa3637 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -959,7 +959,6 @@ xfs_dir_ialloc(
>  	xfs_buf_t	*ialloc_context = NULL;
>  	int		code;
>  	void		*dqinfo;
> -	uint		tflags;
>  
>  	tp = *tpp;
>  	ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
> @@ -1018,12 +1017,9 @@ xfs_dir_ialloc(
>  		 * and attach it to the next transaction.
>  		 */
>  		dqinfo = NULL;
> -		tflags = 0;
>  		if (tp->t_dqinfo) {
>  			dqinfo = (void *)tp->t_dqinfo;
>  			tp->t_dqinfo = NULL;
> -			tflags = tp->t_flags & XFS_TRANS_DQ_DIRTY;
> -			tp->t_flags &= ~(XFS_TRANS_DQ_DIRTY);
>  		}
>  
>  		code = xfs_trans_roll(&tp);
> @@ -1031,10 +1027,8 @@ xfs_dir_ialloc(
>  		/*
>  		 * Re-attach the quota info that we detached from prev trx.
>  		 */
> -		if (dqinfo) {
> +		if (dqinfo)
>  			tp->t_dqinfo = dqinfo;
> -			tp->t_flags |= tflags;
> -		}
>  
>  		if (code) {
>  			xfs_buf_relse(ialloc_context);
> diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
> index 67f1e275b34d..0ebfd7930382 100644
> --- a/fs/xfs/xfs_trans_dquot.c
> +++ b/fs/xfs/xfs_trans_dquot.c
> @@ -84,13 +84,6 @@ xfs_trans_dup_dqinfo(
>  
>  	xfs_trans_alloc_dqinfo(ntp);
>  
> -	/*
> -	 * Because the quota blk reservation is carried forward,
> -	 * it is also necessary to carry forward the DQ_DIRTY flag.
> -	 */
> -	if (otp->t_flags & XFS_TRANS_DQ_DIRTY)
> -		ntp->t_flags |= XFS_TRANS_DQ_DIRTY;
> -
>  	for (j = 0; j < XFS_QM_TRANS_DQTYPES; j++) {
>  		oqa = otp->t_dqinfo->dqs[j];
>  		nqa = ntp->t_dqinfo->dqs[j];
> @@ -270,8 +263,6 @@ xfs_trans_mod_dquot(
>  
>  	if (delta)
>  		trace_xfs_trans_mod_dquot_after(qtrx);
> -
> -	tp->t_flags |= XFS_TRANS_DQ_DIRTY;
>  }
>  
>  
> @@ -348,7 +339,7 @@ xfs_trans_apply_dquot_deltas(
>  	int64_t			totalbdelta;
>  	int64_t			totalrtbdelta;
>  
> -	if (!(tp->t_flags & XFS_TRANS_DQ_DIRTY))
> +	if (!tp->t_dqinfo)
>  		return;
>  
>  	ASSERT(tp->t_dqinfo);
> @@ -490,7 +481,7 @@ xfs_trans_unreserve_and_mod_dquots(
>  	struct xfs_dqtrx	*qtrx, *qa;
>  	bool			locked;
>  
> -	if (!tp->t_dqinfo || !(tp->t_flags & XFS_TRANS_DQ_DIRTY))
> +	if (!tp->t_dqinfo)
>  		return;
>  
>  	for (j = 0; j < XFS_QM_TRANS_DQTYPES; j++) {
> -- 
> 2.20.0
> 

