Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1C4DC43334
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jul 2022 17:16:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233240AbiGRRQn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 Jul 2022 13:16:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233100AbiGRRQm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Jul 2022 13:16:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13F942C12D;
        Mon, 18 Jul 2022 10:16:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9501E61582;
        Mon, 18 Jul 2022 17:16:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C28F3C341C0;
        Mon, 18 Jul 2022 17:16:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658164600;
        bh=d6KscDVDrA9I+4PRxjkUn0b5XrvScwDW2osOQpnQ+Bo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MyhWEdauYWHUif85Fr9+YI50paUINVAGUmbWkG/jkMAAuMNX7OTsCK7EKr8xwTsg5
         sCW/PsdcWfsBKxP5XsIZ0ldDLyJUjN5cf1uxBY7PclGgySBbMYA0Pnadw45TFTEYoP
         jgyVNL7oed9ykgEgZEDRK5m6rPENqOJDZyl56cqfJABXQUONYC6ar2Dt/ehGI7Vn6E
         9sZvTrq3KZCvDqmzuWNeLEe+wMys8M2KSvs/bwqe4DkdNxqwcaqE1yhEgKC6STJgiJ
         6OZz5eftGZs4JnqNRdhwxocO0E58Ex9gfEk5+m7ZMrbPLMcALIG13EsBYsN18jMKJ9
         F9VGhWmlfxjDA==
Date:   Mon, 18 Jul 2022 10:16:40 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Dave Chinner <dchinner@redhat.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Allison Henderson <allison.henderson@oracle.com>,
        linux-xfs@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] xfs: delete unnecessary NULL checks
Message-ID: <YtWVeOjhL5R+CEJQ@magnolia>
References: <YtVCOtQ7PCRfjXY6@kili>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YtVCOtQ7PCRfjXY6@kili>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jul 18, 2022 at 02:21:30PM +0300, Dan Carpenter wrote:
> These NULL check are no long needed after commit 2ed5b09b3e8f ("xfs:
> make inode attribute forks a permanent part of struct xfs_inode").
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Looks correct,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_inode_fork.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
> index 7c34184448e6..fa699f3792bf 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.c
> +++ b/fs/xfs/libxfs/xfs_inode_fork.c
> @@ -724,8 +724,7 @@ xfs_ifork_verify_local_attr(
>  
>  	if (fa) {
>  		xfs_inode_verifier_error(ip, -EFSCORRUPTED, "attr fork",
> -				ifp ? ifp->if_u1.if_data : NULL,
> -				ifp ? ifp->if_bytes : 0, fa);
> +				ifp->if_u1.if_data, ifp->if_bytes, fa);
>  		return -EFSCORRUPTED;
>  	}
>  
> -- 
> 2.35.1
> 
