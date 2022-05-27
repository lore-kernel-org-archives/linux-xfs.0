Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08C4DC433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 27 May 2022 22:43:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236430AbiE0WnD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 27 May 2022 18:43:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235014AbiE0WnC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 27 May 2022 18:43:02 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C0A9F5E771
        for <linux-xfs@vger.kernel.org>; Fri, 27 May 2022 15:43:01 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id E7E41537A2C;
        Sat, 28 May 2022 08:43:00 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nuifa-00HBoV-TX; Sat, 28 May 2022 08:42:58 +1000
Date:   Sat, 28 May 2022 08:42:58 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: fix xfs_ifree() error handling to not leak perag ref
Message-ID: <20220527224258.GU1098723@dread.disaster.area>
References: <20220527133428.2291945-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220527133428.2291945-1-bfoster@redhat.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=629153f5
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=oZkIemNP1mAA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=siDB9RYKOpbEWRo_QVgA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 27, 2022 at 09:34:28AM -0400, Brian Foster wrote:
> For some reason commit 9a5280b312e2e ("xfs: reorder iunlink remove
> operation in xfs_ifree") replaced a jump to the exit path in the
> event of an xfs_difree() error with a direct return, which skips

Reason: the patchset that the fix was promoted from had moved all
the pag handling out of xfs_ifree to the caller, so direct return
was, in fact, the correct behaviour in the code it originated from.

The patch applied to upstream with no errors or fuzz, and I had
completely forgotten that somewhere in the ~50 patches in the stack
before that fix had completely reworked unlink pag handling...

How did you find this? I haven't noticed any specific increase in
unmount perag accounting leaks as a result of this, so I'm curious
as to how you noticed it and isolated it to this specific bug.

> Restore the original code to drop the reference on error.
> 
> Fixes: 9a5280b312e2e ("xfs: reorder iunlink remove operation in xfs_ifree")
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/xfs_inode.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index b2879870a17e..52d6f2c7d58b 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -2622,7 +2622,7 @@ xfs_ifree(
>  	 */
>  	error = xfs_difree(tp, pag, ip->i_ino, &xic);
>  	if (error)
> -		return error;
> +		goto out;

Looks good,

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
