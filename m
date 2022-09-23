Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3996C07E9D
	for <linux-xfs@archiver.kernel.org>; Fri, 23 Sep 2022 21:47:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231981AbiIWVrW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 23 Sep 2022 17:47:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbiIWVrV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 23 Sep 2022 17:47:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1AEF1438E3
        for <linux-xfs@vger.kernel.org>; Fri, 23 Sep 2022 14:47:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 73F50B81E12
        for <linux-xfs@vger.kernel.org>; Fri, 23 Sep 2022 21:47:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25545C433D6;
        Fri, 23 Sep 2022 21:47:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663969638;
        bh=N0oD4u3I5z30E+AbKcsU31nZeAsJC0eMbDpMgUuKWB4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GHEgDt2UzCAlEIX2AoHEFEBIKG1/3rT0eLlgLVMI7ZTo2Wl6K6hVehx/Fvkyd+Icc
         OOp4ASEaKuln1cKkGI4XpKzC9dfdcrdlJ5LjlhS5E3Ziseo/7Ja0qkWhhokG7paQfX
         JLZfY+HTUyKgitCvYiBVZZ7SWGaXwkN8boL5cf8+eSaUXo5pWJhbuY0xj5Z8tDhxaN
         brH1NwzZjy5JyZdfgN+peO2MpRgGK+JoMkGidfGj3ZLQf1JrLjtpG31PRSgj1uN45n
         v1nSPefP60Fu0Ty9FSnYU14f3JZWh7RlFx3AXyEVWFuSLAMJAsV8Buj/TfXP0F1jvP
         FrFL6R8QgZ99w==
Date:   Fri, 23 Sep 2022 14:47:17 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     allison.henderson@oracle.com
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3 25/26] xfs: fix unit conversion error in
 xfs_log_calc_max_attrsetm_res
Message-ID: <Yy4pZcjowhK+WWNS@magnolia>
References: <20220922054458.40826-1-allison.henderson@oracle.com>
 <20220922054458.40826-26-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220922054458.40826-26-allison.henderson@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 21, 2022 at 10:44:57PM -0700, allison.henderson@oracle.com wrote:
> From: Allison Henderson <allison.henderson@oracle.com>

Er, did you change this patch much?

I was really hoping you'd *RVB* tag it and send it back out. :)

--D

> 
> Dave and I were discussing some recent test regressions as a result of
> me turning on nrext64=1 on realtime filesystems, when we noticed that
> the minimum log size of a 32M filesystem jumped from 954 blocks to 4287
> blocks.
> 
> Digging through xfs_log_calc_max_attrsetm_res, Dave noticed that @size
> contains the maximum estimated amount of space needed for a local format
> xattr, in bytes, but we feed this quantity to XFS_NEXTENTADD_SPACE_RES,
> which requires units of blocks.  This has resulted in an overestimation
> of the minimum log size over the years.
> 
> We should nominally correct this, but there's a backwards compatibility
> problem -- if we enable it now, the minimum log size will decrease.  If
> a corrected mkfs formats a filesystem with this new smaller log size, a
> user will encounter mount failures on an uncorrected kernel due to the
> larger minimum log size computations there.
> 
> However, the large extent counters feature is still EXPERIMENTAL, so we
> can gate the correction on that feature (or any features that get added
> after that) being enabled.  Any filesystem with nrext64 or any of the
> as-yet-undefined feature bits turned on will be rejected by old
> uncorrected kernels, so this should be safe even in the upgrade case.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_log_rlimit.c | 43 ++++++++++++++++++++++++++++++++++
>  1 file changed, 43 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_log_rlimit.c b/fs/xfs/libxfs/xfs_log_rlimit.c
> index 9975b93a7412..e5c606fb7a6a 100644
> --- a/fs/xfs/libxfs/xfs_log_rlimit.c
> +++ b/fs/xfs/libxfs/xfs_log_rlimit.c
> @@ -16,6 +16,39 @@
>  #include "xfs_bmap_btree.h"
>  #include "xfs_trace.h"
>  
> +/*
> + * Decide if the filesystem has the parent pointer feature or any feature
> + * added after that.
> + */
> +static inline bool
> +xfs_has_parent_or_newer_feature(
> +	struct xfs_mount	*mp)
> +{
> +	if (!xfs_sb_is_v5(&mp->m_sb))
> +		return false;
> +
> +	if (xfs_sb_has_compat_feature(&mp->m_sb, ~0))
> +		return true;
> +
> +	if (xfs_sb_has_ro_compat_feature(&mp->m_sb,
> +				~(XFS_SB_FEAT_RO_COMPAT_FINOBT |
> +				 XFS_SB_FEAT_RO_COMPAT_RMAPBT |
> +				 XFS_SB_FEAT_RO_COMPAT_REFLINK |
> +				 XFS_SB_FEAT_RO_COMPAT_INOBTCNT)))
> +		return true;
> +
> +	if (xfs_sb_has_incompat_feature(&mp->m_sb,
> +				~(XFS_SB_FEAT_INCOMPAT_FTYPE |
> +				 XFS_SB_FEAT_INCOMPAT_SPINODES |
> +				 XFS_SB_FEAT_INCOMPAT_META_UUID |
> +				 XFS_SB_FEAT_INCOMPAT_BIGTIME |
> +				 XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR |
> +				 XFS_SB_FEAT_INCOMPAT_NREXT64)))
> +		return true;
> +
> +	return false;
> +}
> +
>  /*
>   * Calculate the maximum length in bytes that would be required for a local
>   * attribute value as large attributes out of line are not logged.
> @@ -31,6 +64,16 @@ xfs_log_calc_max_attrsetm_res(
>  	       MAXNAMELEN - 1;
>  	nblks = XFS_DAENTER_SPACE_RES(mp, XFS_ATTR_FORK);
>  	nblks += XFS_B_TO_FSB(mp, size);
> +
> +	/*
> +	 * Starting with the parent pointer feature, every new fs feature
> +	 * corrects a unit conversion error in the xattr transaction
> +	 * reservation code that resulted in oversized minimum log size
> +	 * computations.
> +	 */
> +	if (xfs_has_parent_or_newer_feature(mp))
> +		size = XFS_B_TO_FSB(mp, size);
> +
>  	nblks += XFS_NEXTENTADD_SPACE_RES(mp, size, XFS_ATTR_FORK);
>  
>  	return  M_RES(mp)->tr_attrsetm.tr_logres +
> -- 
> 2.25.1
> 
