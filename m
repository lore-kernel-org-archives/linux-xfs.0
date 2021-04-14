Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCA17C433ED
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Apr 2021 00:49:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8544E61222
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Apr 2021 00:49:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244071AbhDNAuO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 13 Apr 2021 20:50:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:35434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242865AbhDNAuN (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 13 Apr 2021 20:50:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EF356613B6;
        Wed, 14 Apr 2021 00:49:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618361393;
        bh=rld1JTFq+8fub0Ecr82AxgdXTmVuDSHp77K1SN3x4CY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WbgK/R1Vk+E2C6ymeIghkYJkFEvaV5Z+64wqzjk67ZCX+pcmAjRZLPs+GGuT/xmZ1
         ZHOTy+8y6wUVOQ7o2kRMXXjwacAVPhx0qfVGATdGeUnycQvmydqRcWU40O5qBwPs77
         sM9XzEdD7uf+wYn8jCzf0uuS7pQTYKJGgNvIRiirIqno7zIA3Fg/36ou+tXgq+Vre7
         cGX62p3KxOUuK4yj8GAFqkfW8dGBPDnPA4iY+I8LKA4woys/CiZgpe1kkk33+o5MFa
         iq5EDcEVFsnSKJwrSJgKq3+3Q19TVbSNuLgrhqHFTbBHWvHpc0FEdI+kulW+N7J9Pi
         Z1mwD303e2XYg==
Date:   Tue, 13 Apr 2021 17:49:50 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3 1/2] xfs: set a mount flag when perag reservation is
 active
Message-ID: <20210414004950.GW3957620@magnolia>
References: <20210412133059.1186634-1-bfoster@redhat.com>
 <20210412133059.1186634-2-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210412133059.1186634-2-bfoster@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Apr 12, 2021 at 09:30:58AM -0400, Brian Foster wrote:
> perag reservation is enabled at mount time on a per AG basis. The
> upcoming in-core allocation btree accounting mechanism needs to know
> when reservation is enabled and that all perag AGF contexts are
> initialized. As a preparation step, set a flag in the mount
> structure and unconditionally initialize the pagf on all mounts
> where at least one reservation is active.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_ag_resv.c | 24 ++++++++++++++----------
>  fs/xfs/xfs_mount.h          |  1 +
>  2 files changed, 15 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_ag_resv.c b/fs/xfs/libxfs/xfs_ag_resv.c
> index 6c5f8d10589c..9b2fc4abad2c 100644
> --- a/fs/xfs/libxfs/xfs_ag_resv.c
> +++ b/fs/xfs/libxfs/xfs_ag_resv.c
> @@ -254,6 +254,7 @@ xfs_ag_resv_init(
>  	xfs_extlen_t			ask;
>  	xfs_extlen_t			used;
>  	int				error = 0;
> +	bool				has_resv = false;
>  
>  	/* Create the metadata reservation. */
>  	if (pag->pag_meta_resv.ar_asked == 0) {
> @@ -291,6 +292,8 @@ xfs_ag_resv_init(
>  			if (error)
>  				goto out;
>  		}
> +		if (ask)
> +			has_resv = true;
>  	}
>  
>  	/* Create the RMAPBT metadata reservation */
> @@ -304,18 +307,19 @@ xfs_ag_resv_init(
>  		error = __xfs_ag_resv_init(pag, XFS_AG_RESV_RMAPBT, ask, used);
>  		if (error)
>  			goto out;
> +		if (ask)
> +			has_resv = true;
>  	}
>  
> -#ifdef DEBUG
> -	/* need to read in the AGF for the ASSERT below to work */
> -	error = xfs_alloc_pagf_init(pag->pag_mount, tp, pag->pag_agno, 0);
> -	if (error)
> -		return error;
> -
> -	ASSERT(xfs_perag_resv(pag, XFS_AG_RESV_METADATA)->ar_reserved +
> -	       xfs_perag_resv(pag, XFS_AG_RESV_RMAPBT)->ar_reserved <=
> -	       pag->pagf_freeblks + pag->pagf_flcount);
> -#endif
> +	if (has_resv) {
> +		mp->m_has_agresv = true;

If the metadata reservation succeeds but the rmapbt reservation fails
with ENOSPC, won't we fail to set m_has_agresv true here?  We don't fail
the entire mount if ENOSPC happens, which means that there's a slight
chance of doing the wrong thing here if all the AGs are (somehow) like
that.

--D

> +		error = xfs_alloc_pagf_init(mp, tp, pag->pag_agno, 0);
> +		if (error)
> +			return error;
> +		ASSERT(xfs_perag_resv(pag, XFS_AG_RESV_METADATA)->ar_reserved +
> +		       xfs_perag_resv(pag, XFS_AG_RESV_RMAPBT)->ar_reserved <=
> +		       pag->pagf_freeblks + pag->pagf_flcount);
> +	}
>  out:
>  	return error;
>  }
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index 81829d19596e..8847ffd29777 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -139,6 +139,7 @@ typedef struct xfs_mount {
>  	bool			m_fail_unmount;
>  	bool			m_finobt_nores; /* no per-AG finobt resv. */
>  	bool			m_update_sb;	/* sb needs update in mount */
> +	bool			m_has_agresv;	/* perag reservations active */
>  
>  	/*
>  	 * Bitsets of per-fs metadata that have been checked and/or are sick.
> -- 
> 2.26.3
> 
