Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 645FEC433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Oct 2021 18:54:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B1B960F23
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Oct 2021 18:54:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233551AbhJLS4q (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Oct 2021 14:56:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:55346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234701AbhJLS4p (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 12 Oct 2021 14:56:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A06DA60EDF;
        Tue, 12 Oct 2021 18:54:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634064883;
        bh=9eDbzXJRQc0sqSMLwGfiXcxq1kZZSWpwLV87A/vZc24=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VaA8jfFYnDgBQSTI1bIPnHI1mQu6TAx0dTANGEmsXXN1spa/jLUIcCobBLbPAr8E9
         HC6pxh9QGJ9QxO3O7MhM4br49G7h09Zb8Y8OvTFr/4UxBK6yMVbtYcQzgckts+2oLi
         H8lVRYuzbpY+PMtoPhnN+swe+Qewt0rkqIEt0J1O2NN3bKe3B7cNoWYQb/bV+CUTNC
         3tFY+6rII5c7UjHhBEH77GpQvbrQ7JP+LsX8HhfQAAZ9qLvHdQYFjbu0CbY20oeTAk
         KZ0eH+isF7yEXbWWzGcs+jF+nAzxwmD3hnAojhPvBWtd9WdY4NE2VFIaDljNa5qhGq
         IfsLSEpFxmWTA==
Date:   Tue, 12 Oct 2021 11:54:43 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 2/4] xfs: rename the next_agno perag iteration variable
Message-ID: <20211012185443.GM24307@magnolia>
References: <20211012165203.1354826-1-bfoster@redhat.com>
 <20211012165203.1354826-3-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211012165203.1354826-3-bfoster@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 12, 2021 at 12:52:01PM -0400, Brian Foster wrote:
> Rename the next_agno variable to be consistent across the several
> iteration macros and shorten line length.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_ag.h | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
> index 48eb22e8d717..cf8baae2ba18 100644
> --- a/fs/xfs/libxfs/xfs_ag.h
> +++ b/fs/xfs/libxfs/xfs_ag.h
> @@ -127,22 +127,22 @@ void xfs_perag_put(struct xfs_perag *pag);
>  static inline
>  struct xfs_perag *xfs_perag_next(
>  	struct xfs_perag	*pag,
> -	xfs_agnumber_t		*next_agno)
> +	xfs_agnumber_t		*agno)
>  {
>  	struct xfs_mount	*mp = pag->pag_mount;
>  
> -	*next_agno = pag->pag_agno + 1;
> +	*agno = pag->pag_agno + 1;
>  	xfs_perag_put(pag);
> -	return xfs_perag_get(mp, *next_agno);
> +	return xfs_perag_get(mp, *agno);
>  }
>  
> -#define for_each_perag_range(mp, next_agno, end_agno, pag) \
> -	for ((pag) = xfs_perag_get((mp), (next_agno)); \
> -		(pag) != NULL && (next_agno) <= (end_agno); \
> -		(pag) = xfs_perag_next((pag), &(next_agno)))
> +#define for_each_perag_range(mp, agno, end_agno, pag) \
> +	for ((pag) = xfs_perag_get((mp), (agno)); \
> +		(pag) != NULL && (agno) <= (end_agno); \
> +		(pag) = xfs_perag_next((pag), &(agno)))
>  
> -#define for_each_perag_from(mp, next_agno, pag) \
> -	for_each_perag_range((mp), (next_agno), (mp)->m_sb.sb_agcount, (pag))
> +#define for_each_perag_from(mp, agno, pag) \
> +	for_each_perag_range((mp), (agno), (mp)->m_sb.sb_agcount, (pag))
>  
>  
>  #define for_each_perag(mp, agno, pag) \
> -- 
> 2.31.1
> 
