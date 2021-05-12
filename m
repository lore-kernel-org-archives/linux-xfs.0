Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36F1EC433B4
	for <linux-xfs@archiver.kernel.org>; Wed, 12 May 2021 23:44:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F10CF61419
	for <linux-xfs@archiver.kernel.org>; Wed, 12 May 2021 23:44:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233677AbhELXpY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 May 2021 19:45:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:48120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234031AbhELXVG (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 12 May 2021 19:21:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8FA8A613F6;
        Wed, 12 May 2021 23:19:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620861594;
        bh=BbojUeV/rhg6oXua+uSUTTjmE+lxCZvo2rdYt5cvrgk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=r99qTRf7zZa+AulG2tqIlk9Sxz+AX4SqLkxCnns0/TRs5knpAGoaUOGZq7t3MT1Jg
         m2GeG0etTo/rl2UIk6qlMbA32Lt/EF+8Svr1qCZPdOpz28ra3uwWslvLNalovZt/Xj
         MReYAI61EfhtUgbDz7GSvsyKkyqtdVi0I0fC6MKmLVaQeuyROqEUrllZf9NixHIkaD
         a8mJHUpVnarnvHrs40qpidINHqM3nuXTFoyQWCXdEA4fczF+KLh9XdHIuXSgXRyl9q
         Xk4wkMW0xbNvvoNer3AQBjLuYPNB9Xy66RqoN8ObAM8n2Ix0CqgnN5f+G1i/DiFGDC
         P5XnK/BRa6K2g==
Date:   Wed, 12 May 2021 16:19:53 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 20/22] xfs: inode allocation can use a single perag
 instance
Message-ID: <20210512231953.GO8582@magnolia>
References: <20210506072054.271157-1-david@fromorbit.com>
 <20210506072054.271157-21-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210506072054.271157-21-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 06, 2021 at 05:20:52PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Now that we've internalised the two-phase inode allocation, we can
> now easily make the AG selection and allocation atomic from the
> perspective of a single perag context. This will ensure AGs going
> offline/away cannot occur between the selection and allocation
> steps.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Make sense.
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_ialloc.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> index 2c0ef2dd46d9..d749bb7c7a69 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.c
> +++ b/fs/xfs/libxfs/xfs_ialloc.c
> @@ -1432,6 +1432,7 @@ int
>  xfs_dialloc_ag(
>  	struct xfs_trans	*tp,
>  	struct xfs_buf		*agbp,
> +	struct xfs_perag	*pag,
>  	xfs_ino_t		parent,
>  	xfs_ino_t		*inop)
>  {
> @@ -1446,7 +1447,6 @@ xfs_dialloc_ag(
>  	int				error;
>  	int				offset;
>  	int				i;
> -	struct xfs_perag		*pag = agbp->b_pag;
>  
>  	if (!xfs_sb_version_hasfinobt(&mp->m_sb))
>  		return xfs_dialloc_ag_inobt(tp, agbp, pag, parent, inop);
> @@ -1761,9 +1761,9 @@ xfs_dialloc(
>  	xfs_perag_put(pag);
>  	return error ? error : -ENOSPC;
>  found_ag:
> -	xfs_perag_put(pag);
>  	/* Allocate an inode in the found AG */
> -	error = xfs_dialloc_ag(*tpp, agbp, parent, &ino);
> +	error = xfs_dialloc_ag(*tpp, agbp, pag, parent, &ino);
> +	xfs_perag_put(pag);
>  	if (error)
>  		return error;
>  	*new_ino = ino;
> -- 
> 2.31.1
> 
