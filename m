Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A45FEC2B9F7
	for <linux-xfs@archiver.kernel.org>; Fri, 28 May 2021 16:31:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 78BDA613E5
	for <linux-xfs@archiver.kernel.org>; Fri, 28 May 2021 16:31:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236860AbhE1Qct (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 28 May 2021 12:32:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:44208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236030AbhE1Qct (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 28 May 2021 12:32:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DEA65613E3;
        Fri, 28 May 2021 16:31:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622219474;
        bh=RkV0PZ8cJavU/UGIrwMerGJGnaQlbnPiDnLkzsorh1U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=liO4fCJErGnnjn/I5o6DTmfwzTp1D34yzy8gU/P8wRlAdQBpIzlgn3i0IgP+KQfM4
         ieUeibpg5gwazIn9czOwtstYt6DqVDJrSWQI1IIQos7PP9+pFamslJO0LjZhz9gonT
         RGBWwn+P9p9oQZcN210rUj8dZs+eEGUFO3TAgOQJNy2fsTsx5dIjGH5q3Z05vpmrHw
         R0gzgjGTayEiy8RIBwL9RAofsnADvOx1MBtWUW34tLl025RnKwuGFtKA3IkY+ZUx93
         fkmpiedttmKcY2QqoPv15mcuE0UmqAXQOeT5IoJaVSVbZjjxXFLrmd7VNGX147fFZ8
         uW6MVb5mcGltg==
Date:   Fri, 28 May 2021 09:31:13 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Shaokun Zhang <zhangshaokun@hisilicon.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: sort variable alphabetically to avoid repeated
 declaration
Message-ID: <20210528163113.GP2402049@locust>
References: <1622181328-9852-1-git-send-email-zhangshaokun@hisilicon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1622181328-9852-1-git-send-email-zhangshaokun@hisilicon.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 28, 2021 at 01:55:28PM +0800, Shaokun Zhang wrote:
> Variable 'xfs_agf_buf_ops', 'xfs_agi_buf_ops', 'xfs_dquot_buf_ops' and
> 'xfs_symlink_buf_ops' are declared twice, so sort these variables
> alphabetically and remove the repeated declaration.
> 
> Cc: "Darrick J. Wong" <djwong@kernel.org>
> Signed-off-by: Shaokun Zhang <zhangshaokun@hisilicon.com>

Looks fine to me,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_shared.h | 20 ++++++++------------
>  1 file changed, 8 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_shared.h b/fs/xfs/libxfs/xfs_shared.h
> index 782fdd08f759..25c4cab58851 100644
> --- a/fs/xfs/libxfs/xfs_shared.h
> +++ b/fs/xfs/libxfs/xfs_shared.h
> @@ -22,30 +22,26 @@ struct xfs_inode;
>   * Buffer verifier operations are widely used, including userspace tools
>   */
>  extern const struct xfs_buf_ops xfs_agf_buf_ops;
> -extern const struct xfs_buf_ops xfs_agi_buf_ops;
> -extern const struct xfs_buf_ops xfs_agf_buf_ops;
>  extern const struct xfs_buf_ops xfs_agfl_buf_ops;
> -extern const struct xfs_buf_ops xfs_bnobt_buf_ops;
> -extern const struct xfs_buf_ops xfs_cntbt_buf_ops;
> -extern const struct xfs_buf_ops xfs_rmapbt_buf_ops;
> -extern const struct xfs_buf_ops xfs_refcountbt_buf_ops;
> +extern const struct xfs_buf_ops xfs_agi_buf_ops;
>  extern const struct xfs_buf_ops xfs_attr3_leaf_buf_ops;
>  extern const struct xfs_buf_ops xfs_attr3_rmt_buf_ops;
>  extern const struct xfs_buf_ops xfs_bmbt_buf_ops;
> +extern const struct xfs_buf_ops xfs_bnobt_buf_ops;
> +extern const struct xfs_buf_ops xfs_cntbt_buf_ops;
>  extern const struct xfs_buf_ops xfs_da3_node_buf_ops;
>  extern const struct xfs_buf_ops xfs_dquot_buf_ops;
> -extern const struct xfs_buf_ops xfs_symlink_buf_ops;
> -extern const struct xfs_buf_ops xfs_agi_buf_ops;
> -extern const struct xfs_buf_ops xfs_inobt_buf_ops;
> +extern const struct xfs_buf_ops xfs_dquot_buf_ra_ops;
>  extern const struct xfs_buf_ops xfs_finobt_buf_ops;
> +extern const struct xfs_buf_ops xfs_inobt_buf_ops;
>  extern const struct xfs_buf_ops xfs_inode_buf_ops;
>  extern const struct xfs_buf_ops xfs_inode_buf_ra_ops;
> -extern const struct xfs_buf_ops xfs_dquot_buf_ops;
> -extern const struct xfs_buf_ops xfs_dquot_buf_ra_ops;
> +extern const struct xfs_buf_ops xfs_refcountbt_buf_ops;
> +extern const struct xfs_buf_ops xfs_rmapbt_buf_ops;
> +extern const struct xfs_buf_ops xfs_rtbuf_ops;
>  extern const struct xfs_buf_ops xfs_sb_buf_ops;
>  extern const struct xfs_buf_ops xfs_sb_quiet_buf_ops;
>  extern const struct xfs_buf_ops xfs_symlink_buf_ops;
> -extern const struct xfs_buf_ops xfs_rtbuf_ops;
>  
>  /* log size calculation functions */
>  int	xfs_log_calc_unit_res(struct xfs_mount *mp, int unit_bytes);
> -- 
> 2.7.4
> 
