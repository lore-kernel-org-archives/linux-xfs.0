Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 054E7C433B4
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Apr 2021 01:08:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D189461132
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Apr 2021 01:08:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234998AbhDPBIz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 15 Apr 2021 21:08:55 -0400
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:39047 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235109AbhDPBIv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Apr 2021 21:08:51 -0400
Received: from dread.disaster.area (pa49-181-239-12.pa.nsw.optusnet.com.au [49.181.239.12])
        by mail110.syd.optusnet.com.au (Postfix) with ESMTPS id 05E071087F2;
        Fri, 16 Apr 2021 11:08:07 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lXCxp-009yQz-Ir; Fri, 16 Apr 2021 11:08:05 +1000
Date:   Fri, 16 Apr 2021 11:08:05 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: remove xfs_quiesce_attr declaration
Message-ID: <20210416010805.GS63242@dread.disaster.area>
References: <20210414145724.GZ3957620@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210414145724.GZ3957620@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0 cx=a_idp_f
        a=gO82wUwQTSpaJfP49aMSow==:117 a=gO82wUwQTSpaJfP49aMSow==:17
        a=kj9zAlcOel0A:10 a=3YhXtTcJ-WEA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=jIAqPTkNe88oqebGVLYA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 14, 2021 at 07:57:24AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> The function was renamed, so get rid of the declaration.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_super.h |    1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_super.h b/fs/xfs/xfs_super.h
> index 1ca484b8357f..d2b40dc60dfc 100644
> --- a/fs/xfs/xfs_super.h
> +++ b/fs/xfs/xfs_super.h
> @@ -86,7 +86,6 @@ struct xfs_mount;
>  struct xfs_buftarg;
>  struct block_device;
>  
> -extern void xfs_quiesce_attr(struct xfs_mount *mp);
>  extern void xfs_flush_inodes(struct xfs_mount *mp);
>  extern void xfs_blkdev_issue_flush(struct xfs_buftarg *);
>  extern xfs_agnumber_t xfs_set_inode_alloc(struct xfs_mount *,

*nod*

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
