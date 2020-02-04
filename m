Return-Path: <SRS0=4Qc2=3Y=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7D7DC35247
	for <linux-xfs@archiver.kernel.org>; Tue,  4 Feb 2020 21:39:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 849272084E
	for <linux-xfs@archiver.kernel.org>; Tue,  4 Feb 2020 21:39:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727566AbgBDVjg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 4 Feb 2020 16:39:36 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:56622 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727563AbgBDVjg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Feb 2020 16:39:36 -0500
Received: from dread.disaster.area (pa49-181-161-120.pa.nsw.optusnet.com.au [49.181.161.120])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id BED323A2E10;
        Wed,  5 Feb 2020 08:39:33 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1iz5uu-0005t7-8t; Wed, 05 Feb 2020 08:39:32 +1100
Date:   Wed, 5 Feb 2020 08:39:32 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Zorro Lang <zlang@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: fix invalid pointer dereference in
 xfs_attr3_node_inactive
Message-ID: <20200204213932.GM20628@dread.disaster.area>
References: <20200204070636.25572-1-zlang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200204070636.25572-1-zlang@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=SkgQWeG3jiSQFIjTo4+liA==:117 a=SkgQWeG3jiSQFIjTo4+liA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=l697ptgUJYAA:10
        a=7-415B0cAAAA:8 a=9zip6S78dTbaoqQT7ZoA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 04, 2020 at 03:06:36PM +0800, Zorro Lang wrote:
> This patch fixes below KASAN report. The xfs_attr3_node_inactive()
> gets 'child_bp' at there:
>   error = xfs_trans_get_buf(*trans, mp->m_ddev_targp,
>                             child_blkno,
>                             XFS_FSB_TO_BB(mp, mp->m_attr_geo->fsbcount), 0,
>                             &child_bp);
>   if (error)
>           return error;
>   error = bp->b_error;
> 
> But it turns to use 'bp', not 'child_bp'. And the 'bp' has been freed by:
>   xfs_trans_brelse(*trans, bp);

....
> ---
>  fs/xfs/xfs_attr_inactive.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
> index bbfa6ba84dcd..26230d150bf2 100644
> --- a/fs/xfs/xfs_attr_inactive.c
> +++ b/fs/xfs/xfs_attr_inactive.c
> @@ -211,7 +211,7 @@ xfs_attr3_node_inactive(
>  				&child_bp);
>  		if (error)
>  			return error;
> -		error = bp->b_error;
> +		error = child_bp->b_error;
>  		if (error) {
>  			xfs_trans_brelse(*trans, child_bp);
>  			return error;

Isn't this dead code now? i.e. any error that occurs on the buffer
during a xfs_trans_get_buf() call is returned directly and so it's
caught by the "if (error)" check. Hence this whole child_bp->b_error
check can be removed, right?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
