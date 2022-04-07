Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC215C433EF
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Apr 2022 01:50:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231472AbiDGBwH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 Apr 2022 21:52:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232500AbiDGBwG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Apr 2022 21:52:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16CE4261
        for <linux-xfs@vger.kernel.org>; Wed,  6 Apr 2022 18:50:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 837E8B8248B
        for <linux-xfs@vger.kernel.org>; Thu,  7 Apr 2022 01:50:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C516C385A3;
        Thu,  7 Apr 2022 01:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649296204;
        bh=b8KHPVSMbKpSStRDfNcTseMlebOchjlWk6ZLUhn3QmA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jYERYP/jvVPH47DgiSoU/uCxHjUUcvi/O+AAWRIfElHVn2pPrYRQDInVe9cPJFcrY
         g2Xdn1PvC62bk8X4edqymA80eybDWUAqjaj07aT/CLvoppiEHlrbA9BRAAqn8SwsOP
         H75d24Pks0oIgmDITxMayXg6pfEy0qg8OX6m+SR/ydVaLuI2YAJt3WvlZ15H6K9mi1
         MuTgeJb4SNrlkrt6LRgsfoJXTxpT22yqBerGuV7M3Trkseesc8+qWa/gRrqe+ok/j+
         HwJptnh1OnVPyfhG5z2tNeKtvRqk926Wm7nCNc9YHkFsfTwWpaZjPLAYMsmFpuRkCU
         12svVNTjAKqhg==
Date:   Wed, 6 Apr 2022 18:50:03 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com,
        Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH V9 13/19] xfs: Replace numbered inode recovery error
 messages with descriptive ones
Message-ID: <20220407015003.GY27690@magnolia>
References: <20220406061904.595597-1-chandan.babu@oracle.com>
 <20220406061904.595597-14-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220406061904.595597-14-chandan.babu@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 06, 2022 at 11:48:57AM +0530, Chandan Babu R wrote:
> This commit also prints inode fields with invalid values instead of printing
> addresses of inode and buffer instances.
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
> Suggested-by: Dave Chinner <dchinner@redhat.com>

Much better for diagnosing recovery problems!!
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_inode_item_recover.c | 52 ++++++++++++++-------------------
>  1 file changed, 22 insertions(+), 30 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode_item_recover.c b/fs/xfs/xfs_inode_item_recover.c
> index 44b90614859e..96b222e18b0f 100644
> --- a/fs/xfs/xfs_inode_item_recover.c
> +++ b/fs/xfs/xfs_inode_item_recover.c
> @@ -324,13 +324,12 @@ xlog_recover_inode_commit_pass2(
>  	if (unlikely(S_ISREG(ldip->di_mode))) {
>  		if ((ldip->di_format != XFS_DINODE_FMT_EXTENTS) &&
>  		    (ldip->di_format != XFS_DINODE_FMT_BTREE)) {
> -			XFS_CORRUPTION_ERROR("xlog_recover_inode_pass2(3)",
> -					 XFS_ERRLEVEL_LOW, mp, ldip,
> -					 sizeof(*ldip));
> +			XFS_CORRUPTION_ERROR(
> +				"Bad log dinode data fork format for regular file",
> +				XFS_ERRLEVEL_LOW, mp, ldip, sizeof(*ldip));
>  			xfs_alert(mp,
> -		"%s: Bad regular inode log record, rec ptr "PTR_FMT", "
> -		"ino ptr = "PTR_FMT", ino bp = "PTR_FMT", ino %Ld",
> -				__func__, item, dip, bp, in_f->ilf_ino);
> +				"Bad inode 0x%llx, data fork format 0x%x",
> +				in_f->ilf_ino, ldip->di_format);
>  			error = -EFSCORRUPTED;
>  			goto out_release;
>  		}
> @@ -338,49 +337,42 @@ xlog_recover_inode_commit_pass2(
>  		if ((ldip->di_format != XFS_DINODE_FMT_EXTENTS) &&
>  		    (ldip->di_format != XFS_DINODE_FMT_BTREE) &&
>  		    (ldip->di_format != XFS_DINODE_FMT_LOCAL)) {
> -			XFS_CORRUPTION_ERROR("xlog_recover_inode_pass2(4)",
> -					     XFS_ERRLEVEL_LOW, mp, ldip,
> -					     sizeof(*ldip));
> +			XFS_CORRUPTION_ERROR(
> +				"Bad log dinode data fork format for directory",
> +				XFS_ERRLEVEL_LOW, mp, ldip, sizeof(*ldip));
>  			xfs_alert(mp,
> -		"%s: Bad dir inode log record, rec ptr "PTR_FMT", "
> -		"ino ptr = "PTR_FMT", ino bp = "PTR_FMT", ino %Ld",
> -				__func__, item, dip, bp, in_f->ilf_ino);
> +				"Bad inode 0x%llx, data fork format 0x%x",
> +				in_f->ilf_ino, ldip->di_format);
>  			error = -EFSCORRUPTED;
>  			goto out_release;
>  		}
>  	}
>  	if (unlikely(ldip->di_nextents + ldip->di_anextents > ldip->di_nblocks)){
> -		XFS_CORRUPTION_ERROR("xlog_recover_inode_pass2(5)",
> -				     XFS_ERRLEVEL_LOW, mp, ldip,
> -				     sizeof(*ldip));
> +		XFS_CORRUPTION_ERROR("Bad log dinode extent counts",
> +				XFS_ERRLEVEL_LOW, mp, ldip, sizeof(*ldip));
>  		xfs_alert(mp,
> -	"%s: Bad inode log record, rec ptr "PTR_FMT", dino ptr "PTR_FMT", "
> -	"dino bp "PTR_FMT", ino %Ld, total extents = %d, nblocks = %Ld",
> -			__func__, item, dip, bp, in_f->ilf_ino,
> -			ldip->di_nextents + ldip->di_anextents,
> +			"Bad inode 0x%llx, nextents 0x%x, anextents 0x%x, nblocks 0x%llx",
> +			in_f->ilf_ino, ldip->di_nextents, ldip->di_anextents,
>  			ldip->di_nblocks);
>  		error = -EFSCORRUPTED;
>  		goto out_release;
>  	}
>  	if (unlikely(ldip->di_forkoff > mp->m_sb.sb_inodesize)) {
> -		XFS_CORRUPTION_ERROR("xlog_recover_inode_pass2(6)",
> -				     XFS_ERRLEVEL_LOW, mp, ldip,
> -				     sizeof(*ldip));
> +		XFS_CORRUPTION_ERROR("Bad log dinode fork offset",
> +				XFS_ERRLEVEL_LOW, mp, ldip, sizeof(*ldip));
>  		xfs_alert(mp,
> -	"%s: Bad inode log record, rec ptr "PTR_FMT", dino ptr "PTR_FMT", "
> -	"dino bp "PTR_FMT", ino %Ld, forkoff 0x%x", __func__,
> -			item, dip, bp, in_f->ilf_ino, ldip->di_forkoff);
> +			"Bad inode 0x%llx, di_forkoff 0x%x",
> +			in_f->ilf_ino, ldip->di_forkoff);
>  		error = -EFSCORRUPTED;
>  		goto out_release;
>  	}
>  	isize = xfs_log_dinode_size(mp);
>  	if (unlikely(item->ri_buf[1].i_len > isize)) {
> -		XFS_CORRUPTION_ERROR("xlog_recover_inode_pass2(7)",
> -				     XFS_ERRLEVEL_LOW, mp, ldip,
> -				     sizeof(*ldip));
> +		XFS_CORRUPTION_ERROR("Bad log dinode size", XFS_ERRLEVEL_LOW,
> +				     mp, ldip, sizeof(*ldip));
>  		xfs_alert(mp,
> -			"%s: Bad inode log record length %d, rec ptr "PTR_FMT,
> -			__func__, item->ri_buf[1].i_len, item);
> +			"Bad inode 0x%llx log dinode size 0x%x",
> +			in_f->ilf_ino, item->ri_buf[1].i_len);
>  		error = -EFSCORRUPTED;
>  		goto out_release;
>  	}
> -- 
> 2.30.2
> 
