Return-Path: <SRS0=WYbU=5O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD6D2C43331
	for <linux-xfs@archiver.kernel.org>; Sun, 29 Mar 2020 23:03:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7C8D02074A
	for <linux-xfs@archiver.kernel.org>; Sun, 29 Mar 2020 23:03:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728041AbgC2XDX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 29 Mar 2020 19:03:23 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:57189 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727591AbgC2XDW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 29 Mar 2020 19:03:22 -0400
Received: from dread.disaster.area (pa49-179-23-206.pa.nsw.optusnet.com.au [49.179.23.206])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 751613A315A;
        Mon, 30 Mar 2020 10:03:20 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jIgxb-0005bR-Te; Mon, 30 Mar 2020 10:03:19 +1100
Date:   Mon, 30 Mar 2020 10:03:19 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     xiakaixu1987@gmail.com
Cc:     linux-xfs@vger.kernel.org, darrick.wong@oracle.com,
        Kaixu Xia <kaixuxia@tencent.com>
Subject: Re: [PATCH] xfs: remove redundant variable assignment in
 xfs_symlink()
Message-ID: <20200329230319.GV10776@dread.disaster.area>
References: <1585479815-13459-1-git-send-email-kaixuxia@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1585479815-13459-1-git-send-email-kaixuxia@tencent.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=n/Z79dAqQwRlp4tcgfhWYA==:117 a=n/Z79dAqQwRlp4tcgfhWYA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=SS2py6AdgQ4A:10
        a=pGLkceISAAAA:8 a=GvQkQWPkAAAA:8 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=u_ExDgcpYvUp_e9d2PgA:9 a=CjuIK1q_8ugA:10 a=IZKFYfNWVLfQsFoIDbx0:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Mar 29, 2020 at 07:03:35PM +0800, xiakaixu1987@gmail.com wrote:
> From: Kaixu Xia <kaixuxia@tencent.com>
> 
> The variables 'udqp' and 'gdqp' have been initialized, so remove
> redundant variable assignment in xfs_symlink().
> 
> Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
> ---
>  fs/xfs/xfs_symlink.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
> index d762d42..3ad82c3 100644
> --- a/fs/xfs/xfs_symlink.c
> +++ b/fs/xfs/xfs_symlink.c
> @@ -176,7 +176,6 @@
>  		return -ENAMETOOLONG;
>  	ASSERT(pathlen > 0);
>  
> -	udqp = gdqp = NULL;
>  	prid = xfs_get_initial_prid(dp);

Looks fine.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
