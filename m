Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CD89C433EF
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Jan 2022 17:22:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242202AbiAERWV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 5 Jan 2022 12:22:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242200AbiAERWS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Jan 2022 12:22:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44870C061201
        for <linux-xfs@vger.kernel.org>; Wed,  5 Jan 2022 09:22:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 03ED2B81113
        for <linux-xfs@vger.kernel.org>; Wed,  5 Jan 2022 17:22:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B77B8C36AE3;
        Wed,  5 Jan 2022 17:22:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641403335;
        bh=TxmjTvhetJtI76K+LXxgkUSwQgr56yzFFrGDdqHpZhM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ntFzg7cp8lBwgzLGWdjFnPLTxb6fiCueRjhKuXdTOs4QeHiHZFsQ4Zz1ZW01fYZXv
         7Y1y6Cd+y1UyOlK0vMPiT01LNIY5Wg0kWIT15/P1zZZTQayR1M03xknk+GxnI8c+nO
         RXl9209bQXOcUkyiTS0D3L+O0CFjmOs5bJiySKY67WpbZYR/OaFh43XxV51ToUfuA7
         PAzX8UyIejrx4Phv9R9z8cOZdTDoQYNGtiGrao+tMEL4AV79Vn67BpVL/RSPBJdVag
         wR6fFYeXpQ4LUMTRKBg5rUW7Q926ukqZBYlDTypiVdpySjtKQss9q2yN132ou6fuGD
         SAWsXc6RU87Og==
Date:   Wed, 5 Jan 2022 09:22:15 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH V4 08/16] xfs: Introduce XFS_FSOP_GEOM_FLAGS_NREXT64
Message-ID: <20220105172215.GI656707@magnolia>
References: <20211214084519.759272-1-chandan.babu@oracle.com>
 <20211214084519.759272-9-chandan.babu@oracle.com>
 <20220105000524.GO31583@magnolia>
 <87y23u8fft.fsf@debian-BULLSEYE-live-builder-AMD64>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87y23u8fft.fsf@debian-BULLSEYE-live-builder-AMD64>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 05, 2022 at 07:14:55PM +0530, Chandan Babu R wrote:
> On 05 Jan 2022 at 05:35, Darrick J. Wong wrote:
> > On Tue, Dec 14, 2021 at 02:15:11PM +0530, Chandan Babu R wrote:
> >> XFS_FSOP_GEOM_FLAGS_NREXT64 indicates that the current filesystem instance
> >> supports 64-bit per-inode extent counters.
> >> 
> >> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
> >> ---
> >>  fs/xfs/libxfs/xfs_fs.h | 1 +
> >>  fs/xfs/libxfs/xfs_sb.c | 2 ++
> >>  2 files changed, 3 insertions(+)
> >> 
> >> diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
> >> index c43877c8a279..42bc39501d81 100644
> >> --- a/fs/xfs/libxfs/xfs_fs.h
> >> +++ b/fs/xfs/libxfs/xfs_fs.h
> >> @@ -251,6 +251,7 @@ typedef struct xfs_fsop_resblks {
> >>  #define XFS_FSOP_GEOM_FLAGS_REFLINK	(1 << 20) /* files can share blocks */
> >>  #define XFS_FSOP_GEOM_FLAGS_BIGTIME	(1 << 21) /* 64-bit nsec timestamps */
> >>  #define XFS_FSOP_GEOM_FLAGS_INOBTCNT	(1 << 22) /* inobt btree counter */
> >> +#define XFS_FSOP_GEOM_FLAGS_NREXT64	(1 << 23) /* 64-bit extent counter */
> >>  
> >>  /*
> >>   * Minimum and maximum sizes need for growth checks.
> >> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> >> index bd632389ae92..0c1add39177f 100644
> >> --- a/fs/xfs/libxfs/xfs_sb.c
> >> +++ b/fs/xfs/libxfs/xfs_sb.c
> >> @@ -1138,6 +1138,8 @@ xfs_fs_geometry(
> >>  	} else {
> >>  		geo->logsectsize = BBSIZE;
> >>  	}
> >> +	if (xfs_has_nrext64(mp))
> >> +		geo->flags |= XFS_FSOP_GEOM_FLAGS_NREXT64;
> >>  	geo->rtsectsize = sbp->sb_blocksize;
> >>  	geo->dirblocksize = xfs_dir2_dirblock_bytes(sbp);
> >>  
> >> -- 
> >> 2.30.2
> >> 
> 
> I think you accidently missed typing your response to this patch?

Yep.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> 
> -- 
> chandan
