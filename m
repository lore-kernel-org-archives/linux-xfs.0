Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 126C2C07E9A
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Jul 2021 04:16:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E47B3613AA
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Jul 2021 04:16:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229850AbhGNETc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 14 Jul 2021 00:19:32 -0400
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:47526 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229518AbhGNETc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Jul 2021 00:19:32 -0400
Received: from dread.disaster.area (pa49-181-34-10.pa.nsw.optusnet.com.au [49.181.34.10])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id 8FB031B0FF6;
        Wed, 14 Jul 2021 14:16:38 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1m3WK5-006JHL-OG; Wed, 14 Jul 2021 14:16:37 +1000
Date:   Wed, 14 Jul 2021 14:16:37 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Wang Shilong <wangshilong1991@gmail.com>
Cc:     linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        Wang Shilong <wshilong@ddn.com>
Subject: Re: [PATCH v4] fs: forbid invalid project ID
Message-ID: <20210714041637.GW664593@dread.disaster.area>
References: <20210710143959.58077-1-wangshilong1991@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210710143959.58077-1-wangshilong1991@gmail.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0
        a=hdaoRb6WoHYrV466vVKEyw==:117 a=hdaoRb6WoHYrV466vVKEyw==:17
        a=kj9zAlcOel0A:10 a=e_q4qTt1xDgA:10 a=lB0dNpNiAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=tKE4i-voY_5ZeL1wqn4A:9 a=CjuIK1q_8ugA:10
        a=c-ZiYqmG3AbHTdtsH08C:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Jul 10, 2021 at 10:39:59PM +0800, Wang Shilong wrote:
> From: Wang Shilong <wshilong@ddn.com>
> 
> fileattr_set_prepare() should check if project ID
> is valid, otherwise dqget() will return NULL for
> such project ID quota.
> 
> Signed-off-by: Wang Shilong <wshilong@ddn.com>
> ---
> v3->v3:
> only check project Id if caller is allowed
> to change and being changed.
> 
> v2->v3: move check before @fsx_projid is accessed
> and use make_kprojid() helper.
> 
> v1->v2: try to fix in the VFS
>  fs/ioctl.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/fs/ioctl.c b/fs/ioctl.c
> index 1e2204fa9963..d4fabb5421cd 100644
> --- a/fs/ioctl.c
> +++ b/fs/ioctl.c
> @@ -817,6 +817,14 @@ static int fileattr_set_prepare(struct inode *inode,
>  		if ((old_ma->fsx_xflags ^ fa->fsx_xflags) &
>  				FS_XFLAG_PROJINHERIT)
>  			return -EINVAL;
> +	} else {
> +		/*
> +		 * Caller is allowed to change the project ID. If it is being
> +		 * changed, make sure that the new value is valid.
> +		 */
> +		if (old_ma->fsx_projid != fa->fsx_projid &&
> +		    !projid_valid(make_kprojid(&init_user_ns, fa->fsx_projid)))
> +			return -EINVAL;
>  	}
>  
>  	/* Check extent size hints. */

Looks good. Thanks!

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
