Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A590C433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Oct 2021 18:53:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 07F4761050
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Oct 2021 18:53:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233435AbhJLSzw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Oct 2021 14:55:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:55208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232684AbhJLSzw (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 12 Oct 2021 14:55:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 78D9B60EDF;
        Tue, 12 Oct 2021 18:53:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634064830;
        bh=5i6zFWlNzq8KrSO6msVQFwHXudvF1xDPxQWTBEBBJX8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=I0aPrdeySVYOKm4aFJkSZpz3Iy1+A5eV7Aw6Z8W31tVcvMCWVMQVP2+NwylB1xQT/
         zjaKDhah2HtKQ92z/aJi+81uaob9AT0ce0+i+bIvDa/i+VZ5czI50wTNXkZ6nEkhAh
         450smtkM3x/LojM2AZWZCExkAdjKeoRw8cSja2HPgh50RLXUigTLJwLNJlRgYcpCy4
         sju+t9nBVcBX4L8Wvpkp02rhUn/0B3TQJbH4XR2mgCmIIo9mzwW8BKZN7FTAMDhQfP
         i5tlPWRqNxUF3wyfDhDR8NN2OsqxdEVtR1tcdrEcbhGpQKtYehrXQYcadJb9JceXac
         BCogf0q0ZSXAA==
Date:   Tue, 12 Oct 2021 11:53:49 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 1/4] xfs: fold perag loop iteration logic into helper
 function
Message-ID: <20211012185349.GL24307@magnolia>
References: <20211012165203.1354826-1-bfoster@redhat.com>
 <20211012165203.1354826-2-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211012165203.1354826-2-bfoster@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 12, 2021 at 12:52:00PM -0400, Brian Foster wrote:
> Fold the loop iteration logic into a helper in preparation for
> further fixups. No functional change in this patch.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_ag.h | 16 +++++++++++++---
>  1 file changed, 13 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
> index 4c6f9045baca..48eb22e8d717 100644
> --- a/fs/xfs/libxfs/xfs_ag.h
> +++ b/fs/xfs/libxfs/xfs_ag.h
> @@ -124,12 +124,22 @@ void xfs_perag_put(struct xfs_perag *pag);
>   * for_each_perag_from() because they terminate at sb_agcount where there are
>   * no perag structures in tree beyond end_agno.
>   */
> +static inline
> +struct xfs_perag *xfs_perag_next(

Dorky style nit: function name goes at the start of the line.

static inline struct xfs_perag *
xfs_perag_next(

With that fixed,

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> +	struct xfs_perag	*pag,
> +	xfs_agnumber_t		*next_agno)
> +{
> +	struct xfs_mount	*mp = pag->pag_mount;
> +
> +	*next_agno = pag->pag_agno + 1;
> +	xfs_perag_put(pag);
> +	return xfs_perag_get(mp, *next_agno);
> +}
> +
>  #define for_each_perag_range(mp, next_agno, end_agno, pag) \
>  	for ((pag) = xfs_perag_get((mp), (next_agno)); \
>  		(pag) != NULL && (next_agno) <= (end_agno); \
> -		(next_agno) = (pag)->pag_agno + 1, \
> -		xfs_perag_put(pag), \
> -		(pag) = xfs_perag_get((mp), (next_agno)))
> +		(pag) = xfs_perag_next((pag), &(next_agno)))
>  
>  #define for_each_perag_from(mp, next_agno, pag) \
>  	for_each_perag_range((mp), (next_agno), (mp)->m_sb.sb_agcount, (pag))
> -- 
> 2.31.1
> 
