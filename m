Return-Path: <SRS0=H2w8=D3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B13EC433DF
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Oct 2020 05:04:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE02D22226
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Oct 2020 05:04:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391579AbgJTFE1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Oct 2020 01:04:27 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:57376 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2391577AbgJTFE1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Oct 2020 01:04:27 -0400
Received: from dread.disaster.area (pa49-179-6-140.pa.nsw.optusnet.com.au [49.179.6.140])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 81FCD3AABAE;
        Tue, 20 Oct 2020 16:04:24 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kUjot-002Nwg-TW; Tue, 20 Oct 2020 16:04:23 +1100
Date:   Tue, 20 Oct 2020 16:04:23 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     xiakaixu1987@gmail.com
Cc:     linux-xfs@vger.kernel.org, darrick.wong@oracle.com,
        Kaixu Xia <kaixuxia@tencent.com>
Subject: Re: [PATCH] xfs: remove the unused XFS_B_FSB_OFFSET macro
Message-ID: <20201020050423.GP7391@dread.disaster.area>
References: <1603169666-16106-1-git-send-email-kaixuxia@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1603169666-16106-1-git-send-email-kaixuxia@tencent.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0 cx=a_idp_d
        a=uDU3YIYVKEaHT0eX+MXYOQ==:117 a=uDU3YIYVKEaHT0eX+MXYOQ==:17
        a=kj9zAlcOel0A:10 a=afefHYAZSVUA:10 a=pGLkceISAAAA:8 a=GvQkQWPkAAAA:8
        a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=sL3wNouqfDCnbpfUFI8A:9
        a=CjuIK1q_8ugA:10 a=IZKFYfNWVLfQsFoIDbx0:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 20, 2020 at 12:54:26PM +0800, xiakaixu1987@gmail.com wrote:
> From: Kaixu Xia <kaixuxia@tencent.com>
> 
> There are no callers of the XFS_B_FSB_OFFSET macro, so remove it.
> 
> Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
> ---
>  fs/xfs/libxfs/xfs_format.h | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index dd764da08f6f..40b6fa3b4e01 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -625,7 +625,6 @@ xfs_is_quota_inode(struct xfs_sb *sbp, xfs_ino_t ino)
>  #define XFS_B_TO_FSB(mp,b)	\
>  	((((uint64_t)(b)) + (mp)->m_blockmask) >> (mp)->m_sb.sb_blocklog)
>  #define XFS_B_TO_FSBT(mp,b)	(((uint64_t)(b)) >> (mp)->m_sb.sb_blocklog)
> -#define XFS_B_FSB_OFFSET(mp,b)	((b) & (mp)->m_blockmask)

Looks fine.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
