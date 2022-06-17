Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3D40C433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Jun 2022 22:06:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346556AbiFQWGt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Jun 2022 18:06:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347171AbiFQWGs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Jun 2022 18:06:48 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 24BB359BA8
        for <linux-xfs@vger.kernel.org>; Fri, 17 Jun 2022 15:06:47 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 2E4F910EB8B7;
        Sat, 18 Jun 2022 08:06:46 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1o2K73-007t9r-2F; Sat, 18 Jun 2022 08:06:45 +1000
Date:   Sat, 18 Jun 2022 08:06:45 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     xiakaixu1987@gmail.com
Cc:     linux-xfs@vger.kernel.org, djwong@kernel.org, hch@infradead.org,
        Kaixu Xia <kaixuxia@tencent.com>
Subject: Re: [RESEND PATCH 2/2] xfs: use invalidate_lock to check the state
 of mmap_lock
Message-ID: <20220617220645.GJ227878@dread.disaster.area>
References: <1655433034-17934-1-git-send-email-kaixuxia@tencent.com>
 <1655433034-17934-3-git-send-email-kaixuxia@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1655433034-17934-3-git-send-email-kaixuxia@tencent.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=OJNEYQWB c=1 sm=1 tr=0 ts=62acfaf6
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=JPEYwPQDsx4A:10 a=pGLkceISAAAA:8 a=GvQkQWPkAAAA:8
        a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=58jBzQUU7SrdiHN2rt4A:9
        a=CjuIK1q_8ugA:10 a=IZKFYfNWVLfQsFoIDbx0:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jun 17, 2022 at 10:30:34AM +0800, xiakaixu1987@gmail.com wrote:
> From: Kaixu Xia <kaixuxia@tencent.com>
> 
> We should use invalidate_lock and XFS_MMAPLOCK_SHARED to check the state
> of mmap_lock rw_semaphore in xfs_isilocked(), rather than i_rwsem and
> XFS_IOLOCK_SHARED.
> 
> Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
> ---
>  fs/xfs/xfs_inode.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 8b8bac7eba8c..3e1c62ffa4f7 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -365,8 +365,8 @@ xfs_isilocked(
>  	}
>  
>  	if (lock_flags & (XFS_MMAPLOCK_EXCL|XFS_MMAPLOCK_SHARED)) {
> -		return __xfs_rwsem_islocked(&VFS_I(ip)->i_rwsem,
> -				(lock_flags & XFS_IOLOCK_SHARED));
> +		return __xfs_rwsem_islocked(&VFS_I(ip)->i_mapping->invalidate_lock,
> +				(lock_flags & XFS_MMAPLOCK_SHARED));

Looks good.

Fixes: 2433480a7e1d ("xfs: Convert to use invalidate_lock")

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
