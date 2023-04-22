Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CDFDC6FD18
	for <linux-xfs@archiver.kernel.org>; Sat, 22 Apr 2023 03:57:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229513AbjDVD5Z (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Apr 2023 23:57:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjDVD5X (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Apr 2023 23:57:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E6DA1BDD
        for <linux-xfs@vger.kernel.org>; Fri, 21 Apr 2023 20:57:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1DD3461D8F
        for <linux-xfs@vger.kernel.org>; Sat, 22 Apr 2023 03:57:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 734AEC433D2;
        Sat, 22 Apr 2023 03:57:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682135841;
        bh=MzpohLVSirKcLZseC0GXnhizykVLRtEsS8g7T5Jb93c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EGEYQgcpsso5DEfE8Mrlup+rXZHSKfZW66RwtFwtzYy0tUfVgFYAMfjUrQfPPpLVy
         PAx6Kv1EmBANFY1CZPnDW1SLaKXSpIJWBTcDst0cIcVc/2RpU05eCOD2PAaF9bE2Ki
         wPrOr10RfuN4Uk6/mO7zLLz8biTjFpaa8DLqdAiPPNmxKZFNZBlZJFILJdoMS2ZgIZ
         yE2p43z6AXNFiJ0WCtS8ug/yWKvJdZg0XdRonXlgvt2TByPhLGXqWwTU+OxBxRP3kE
         Xra8YY22EOIcRqd46m+XoIscFrWgsbXTnZmN6DCeQkqnvOYSIarzwpIuDreZl3TXVk
         quyzENJKU1xJQ==
Date:   Fri, 21 Apr 2023 20:57:20 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Guo Xuenan <guoxuenan@huawei.com>
Cc:     dchinner@redhat.com, linux-xfs@vger.kernel.org, sandeen@redhat.com,
        guoxuenan@huaweicloud.com, houtao1@huawei.com, fangwei1@huawei.com,
        jack.qiu@huawei.com, yi.zhang@huawei.com
Subject: Re: [PATCH v2 2/2] xfs: clean up some unnecessary xfs_stack_trace
Message-ID: <20230422035720.GN360889@frogsfrogsfrogs>
References: <20230421113716.1890274-1-guoxuenan@huawei.com>
 <20230421113716.1890274-3-guoxuenan@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230421113716.1890274-3-guoxuenan@huawei.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Apr 21, 2023 at 07:37:16PM +0800, Guo Xuenan wrote:
> With xfs print level parsing correctly, these duplicate dump
> information can be removed.
> 
> Signed-off-by: Guo Xuenan <guoxuenan@huawei.com>
> ---
>  fs/xfs/libxfs/xfs_ialloc.c | 1 -
>  fs/xfs/xfs_error.c         | 9 ---------
>  fs/xfs/xfs_fsops.c         | 2 --
>  fs/xfs/xfs_log.c           | 2 --
>  4 files changed, 14 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> index a16d5de16933..df4e4eb19f14 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.c
> +++ b/fs/xfs/libxfs/xfs_ialloc.c
> @@ -2329,7 +2329,6 @@ xfs_imap(
>  				__func__, ino,
>  				XFS_AGINO_TO_INO(mp, pag->pag_agno, agino));
>  		}
> -		xfs_stack_trace();

Hmm, this one was unconditional, wasn't it?  That looks like an omission
to me, so I'm calling it out in case anyone had hard opinions about it.
Otherwise,

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

>  #endif /* DEBUG */
>  		return error;
>  	}
> diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
> index b2cbbba3e15a..7c8e1f3b69a6 100644
> --- a/fs/xfs/xfs_error.c
> +++ b/fs/xfs/xfs_error.c
> @@ -421,9 +421,6 @@ xfs_buf_corruption_error(
>  		  fa, bp->b_ops->name, xfs_buf_daddr(bp));
>  
>  	xfs_alert(mp, "Unmount and run xfs_repair");
> -
> -	if (xfs_error_level >= XFS_ERRLEVEL_HIGH)
> -		xfs_stack_trace();
>  }
>  
>  /*
> @@ -459,9 +456,6 @@ xfs_buf_verifier_error(
>  				sz);
>  		xfs_hex_dump(buf, sz);
>  	}
> -
> -	if (xfs_error_level >= XFS_ERRLEVEL_HIGH)
> -		xfs_stack_trace();
>  }
>  
>  /*
> @@ -509,7 +503,4 @@ xfs_inode_verifier_error(
>  				sz);
>  		xfs_hex_dump(buf, sz);
>  	}
> -
> -	if (xfs_error_level >= XFS_ERRLEVEL_HIGH)
> -		xfs_stack_trace();
>  }
> diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> index 13851c0d640b..e08b1ce109d9 100644
> --- a/fs/xfs/xfs_fsops.c
> +++ b/fs/xfs/xfs_fsops.c
> @@ -546,8 +546,6 @@ xfs_do_force_shutdown(
>  			why, flags, __return_address, fname, lnnum);
>  	xfs_alert(mp,
>  		"Please unmount the filesystem and rectify the problem(s)");
> -	if (xfs_error_level >= XFS_ERRLEVEL_HIGH)
> -		xfs_stack_trace();
>  }
>  
>  /*
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index fc61cc024023..e4e4da33281d 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -3808,8 +3808,6 @@ xlog_force_shutdown(
>  				shutdown_flags);
>  		xfs_alert(log->l_mp,
>  "Please unmount the filesystem and rectify the problem(s).");
> -		if (xfs_error_level >= XFS_ERRLEVEL_HIGH)
> -			xfs_stack_trace();
>  	}
>  
>  	/*
> -- 
> 2.31.1
> 
