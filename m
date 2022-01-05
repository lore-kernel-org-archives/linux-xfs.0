Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EA58C433F5
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Jan 2022 00:05:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234869AbiAEAF0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 4 Jan 2022 19:05:26 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:40792 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234017AbiAEAFZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Jan 2022 19:05:25 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2E7DD615F8
        for <linux-xfs@vger.kernel.org>; Wed,  5 Jan 2022 00:05:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83C6BC36AE0;
        Wed,  5 Jan 2022 00:05:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641341124;
        bh=Ly5MGrm2W6KsVx58/0g+2gtOAOnDUiNPEf8v+wkf7Tg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DfmFGICnyi65zZh46bB0wtoZD9ZpyPA9BLuvY0oya+tcvETD0Qc4P8fnKTZ/MjL8p
         0g3ZzcIc+SD8RNuQVgQdvbfcytvJkUFW2P8JBzT+ScztBRgxh/tdBSFc55wks+YfxK
         WnSnADoAPv9LwYrW9R/OTVFZr+6bwwtOzOlkXqGe2X9L5ha4UDtI4voLs5OVdctWZb
         Xgm4SzPhVRgiDoozaqZMOPyWmRzMcJvsB8+jqWdvF2A7CeWqjUP2pj8Qarqo76AUqd
         lJcsdGWWkqPXyT+2wkTP+SdYFyfN5gcNtUL8cS9hwOoGS2a6uOH9+Nt4U/Kci4V3nC
         BKQ8pYRs4I3OQ==
Date:   Tue, 4 Jan 2022 16:05:24 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH V4 08/16] xfs: Introduce XFS_FSOP_GEOM_FLAGS_NREXT64
Message-ID: <20220105000524.GO31583@magnolia>
References: <20211214084519.759272-1-chandan.babu@oracle.com>
 <20211214084519.759272-9-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211214084519.759272-9-chandan.babu@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Dec 14, 2021 at 02:15:11PM +0530, Chandan Babu R wrote:
> XFS_FSOP_GEOM_FLAGS_NREXT64 indicates that the current filesystem instance
> supports 64-bit per-inode extent counters.
> 
> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_fs.h | 1 +
>  fs/xfs/libxfs/xfs_sb.c | 2 ++
>  2 files changed, 3 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
> index c43877c8a279..42bc39501d81 100644
> --- a/fs/xfs/libxfs/xfs_fs.h
> +++ b/fs/xfs/libxfs/xfs_fs.h
> @@ -251,6 +251,7 @@ typedef struct xfs_fsop_resblks {
>  #define XFS_FSOP_GEOM_FLAGS_REFLINK	(1 << 20) /* files can share blocks */
>  #define XFS_FSOP_GEOM_FLAGS_BIGTIME	(1 << 21) /* 64-bit nsec timestamps */
>  #define XFS_FSOP_GEOM_FLAGS_INOBTCNT	(1 << 22) /* inobt btree counter */
> +#define XFS_FSOP_GEOM_FLAGS_NREXT64	(1 << 23) /* 64-bit extent counter */
>  
>  /*
>   * Minimum and maximum sizes need for growth checks.
> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> index bd632389ae92..0c1add39177f 100644
> --- a/fs/xfs/libxfs/xfs_sb.c
> +++ b/fs/xfs/libxfs/xfs_sb.c
> @@ -1138,6 +1138,8 @@ xfs_fs_geometry(
>  	} else {
>  		geo->logsectsize = BBSIZE;
>  	}
> +	if (xfs_has_nrext64(mp))
> +		geo->flags |= XFS_FSOP_GEOM_FLAGS_NREXT64;
>  	geo->rtsectsize = sbp->sb_blocksize;
>  	geo->dirblocksize = xfs_dir2_dirblock_bytes(sbp);
>  
> -- 
> 2.30.2
> 
