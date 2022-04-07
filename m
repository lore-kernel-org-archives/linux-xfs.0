Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64395C433F5
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Apr 2022 01:20:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238918AbiDGBVx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 Apr 2022 21:21:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238580AbiDGBSY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Apr 2022 21:18:24 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BDC7E188A1E
        for <linux-xfs@vger.kernel.org>; Wed,  6 Apr 2022 18:13:13 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-233-190.pa.vic.optusnet.com.au [49.186.233.190])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id CE98310E56DB;
        Thu,  7 Apr 2022 11:13:12 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ncGhz-00EfEx-6t; Thu, 07 Apr 2022 11:13:11 +1000
Date:   Thu, 7 Apr 2022 11:13:11 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     linux-xfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH V9 15/19] xfs: Directory's data fork extent counter can
 never overflow
Message-ID: <20220407011311.GE1544202@dread.disaster.area>
References: <20220406061904.595597-1-chandan.babu@oracle.com>
 <20220406061904.595597-16-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220406061904.595597-16-chandan.babu@oracle.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=624e3aa9
        a=bHAvQTfMiaNt/bo4vVGwyA==:117 a=bHAvQTfMiaNt/bo4vVGwyA==:17
        a=kj9zAlcOel0A:10 a=z0gMJWrwH1QA:10 a=yPCof4ZbAAAA:8 a=7-415B0cAAAA:8
        a=gZcPHtI0QFPIeBUmpnEA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 06, 2022 at 11:48:59AM +0530, Chandan Babu R wrote:
> The maximum file size that can be represented by the data fork extent counter
> in the worst case occurs when all extents are 1 block in length and each block
> is 1KB in size.
> 
> With XFS_MAX_EXTCNT_DATA_FORK_SMALL representing maximum extent count and with
> 1KB sized blocks, a file can reach upto,
> (2^31) * 1KB = 2TB
> 
> This is much larger than the theoretical maximum size of a directory
> i.e. XFS_DIR2_SPACE_SIZE * 3 = ~96GB.
> 
> Since a directory's inode can never overflow its data fork extent counter,
> this commit removes all the overflow checks associated with
> it. xfs_dinode_verify() now performs a rough check to verify if a diretory's
> data fork is larger than 96GB.
> 
> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>

Mostly OK, just a simple cleanup needed.

> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index ee8d4eb7d048..54b106ae77e1 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -491,6 +491,15 @@ xfs_dinode_verify(
>  	if (mode && nextents + naextents > nblocks)
>  		return __this_address;
>  
> +	if (S_ISDIR(mode)) {
> +		uint64_t	max_dfork_nexts;
> +
> +		max_dfork_nexts = (XFS_DIR2_MAX_SPACES * XFS_DIR2_SPACE_SIZE) >>
> +					mp->m_sb.sb_blocklog;
> +		if (nextents > max_dfork_nexts)
> +			return __this_address;
> +	}

max_dfork_nexts for a directory is a constant that should be
calculated at mount time via xfs_da_mount() and stored in the
mp->m_dir_geo structure. Then this code simple becomes:

	if (S_ISDIR(mode) && nextents > mp->m_dir_geo->max_extents)
		return __this_address;

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
