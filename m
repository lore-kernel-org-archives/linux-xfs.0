Return-Path: <SRS0=E2x8=5X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09DF1C2BA16
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Apr 2020 06:39:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DA01820730
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Apr 2020 06:39:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726635AbgDGGjD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 7 Apr 2020 02:39:03 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:44478 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726030AbgDGGjD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Apr 2020 02:39:03 -0400
Received: from dread.disaster.area (pa49-180-164-3.pa.nsw.optusnet.com.au [49.180.164.3])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 0A21C7EC303;
        Tue,  7 Apr 2020 16:39:00 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jLhsw-0007yQ-P8; Tue, 07 Apr 2020 16:38:58 +1000
Date:   Tue, 7 Apr 2020 16:38:58 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     xiakaixu1987@gmail.com
Cc:     linux-xfs@vger.kernel.org, darrick.wong@oracle.com,
        Kaixu Xia <kaixuxia@tencent.com>
Subject: Re: [PATCH v2] xfs: check if reserved free disk blocks is needed
Message-ID: <20200407063858.GB24067@dread.disaster.area>
References: <1586225124-22430-1-git-send-email-kaixuxia@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1586225124-22430-1-git-send-email-kaixuxia@tencent.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=K0+o7W9luyMo1Ua2eXjR1w==:117 a=K0+o7W9luyMo1Ua2eXjR1w==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=cl8xLZFz6L8A:10
        a=pGLkceISAAAA:8 a=GvQkQWPkAAAA:8 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=PbOI2D4jyc3WPFW4fVgA:9 a=CjuIK1q_8ugA:10 a=IZKFYfNWVLfQsFoIDbx0:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 07, 2020 at 10:05:24AM +0800, xiakaixu1987@gmail.com wrote:
> From: Kaixu Xia <kaixuxia@tencent.com>
> 
> We share an inode between gquota and pquota with the older
> superblock that doesn't have separate pquotino, and for the
> need_alloc == false case we don't need to call xfs_dir_ialloc()
> function, so add the check if reserved free disk blocks is
> needed.
> 
> Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> ---
> v2:
>  - improve the commit log.
> 
>  fs/xfs/xfs_qm.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index 6678baa..b684b04 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -780,7 +780,8 @@ struct xfs_qm_isolate {
>  	}
>  
>  	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_create,
> -			XFS_QM_QINOCREATE_SPACE_RES(mp), 0, 0, &tp);
> +			need_alloc ? XFS_QM_QINOCREATE_SPACE_RES(mp) : 0,
> +			0, 0, &tp);

looks fine.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
