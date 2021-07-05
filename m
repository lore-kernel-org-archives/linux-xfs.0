Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 861B0C07E98
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Jul 2021 08:21:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6E648613C8
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Jul 2021 08:21:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230263AbhGEIXj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 5 Jul 2021 04:23:39 -0400
Received: from out4436.biz.mail.alibaba.com ([47.88.44.36]:43496 "EHLO
        out4436.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230245AbhGEIXd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Jul 2021 04:23:33 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R271e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=2;SR=0;TI=SMTPD_---0Uek3Zio_1625473243;
Received: from B-P7TQMD6M-0146.local(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0Uek3Zio_1625473243)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 05 Jul 2021 16:20:44 +0800
Date:   Mon, 5 Jul 2021 16:20:43 +0800
From:   Gao Xiang <hsiangkao@linux.alibaba.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: reset child dir '..' entry when unlinking child
Message-ID: <YOLA20XrTxS3TN/h@B-P7TQMD6M-0146.local>
Mail-Followup-To: "Darrick J. Wong" <djwong@kernel.org>,
        xfs <linux-xfs@vger.kernel.org>
References: <20210703030233.GD24788@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210703030233.GD24788@locust>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jul 02, 2021 at 08:02:33PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> While running xfs/168, I noticed a second source of post-shrink
> corruption errors causing shutdowns.
> 
> Let's say that directory B has a low inode number and is a child of
> directory A, which has a high number.  If B is empty but open, and
> unlinked from A, B's dotdot link continues to point to A.  If A is then
> unlinked and the filesystem shrunk so that A is no longer a valid inode,
> a subsequent AIL push of B will trip the inode verifiers because the
> dotdot entry points outside of the filesystem.
> 
> To avoid this problem, reset B's dotdot entry to the root directory when
> unlinking directories, since the root directory cannot be removed.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

I think it is reasonable to clean dotdot for all deaddir
cases (compared with skipping validating such dotdot dirent which
sounds a bit hacky though since dotdot was actually outdated...)

Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>

Thanks,
Gao Xiang

> ---
>  fs/xfs/xfs_inode.c |   13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 52be5c6d0b3b..03e25246e936 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -2817,6 +2817,19 @@ xfs_remove(
>  		error = xfs_droplink(tp, ip);
>  		if (error)
>  			goto out_trans_cancel;
> +
> +		/*
> +		 * Point the unlinked child directory's ".." entry to the root
> +		 * directory to eliminate back-references to inodes that may
> +		 * get freed before the child directory is closed.  If the fs
> +		 * gets shrunk, this can lead to dirent inode validation errors.
> +		 */
> +		if (dp->i_ino != tp->t_mountp->m_sb.sb_rootino) {
> +			error = xfs_dir_replace(tp, ip, &xfs_name_dotdot,
> +					tp->t_mountp->m_sb.sb_rootino, 0);
> +			if (error)
> +				return error;
> +		}
>  	} else {
>  		/*
>  		 * When removing a non-directory we need to log the parent
