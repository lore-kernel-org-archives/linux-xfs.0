Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED60DC433B4
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Apr 2021 16:43:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B2FE26128D
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Apr 2021 16:43:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347576AbhDGQnm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 7 Apr 2021 12:43:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:58606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234029AbhDGQnl (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 7 Apr 2021 12:43:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1BCE36108B;
        Wed,  7 Apr 2021 16:43:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617813812;
        bh=daMBwvsq4L/S8sE8mnP5yYcBOG4MH7H9qca1LHt4+9U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CDeoKfnz99udE3a/rHhcnhupG/MhEtXSAnQEeybq9VlEz89p3fYwIYLXgMsim0zGQ
         /jBz1qFnMXsoZM1xUEi8S1P3WR3/f2LgIh+6cYam/53oRN9C3L+u75npfmTmTCx8Ps
         BzQK1+gy6BzGtyZda+oDYA6EMlkhqRzet+aoYJ5GHbknVjrUezwGcni5K+Mkls4BZY
         PU0DDnkMVQIO0XRm16dOK2NjwqE7s5Xu2muAeNP/uW63ibpRSHdpUMUUA5UhwtvDZS
         rHeBbHtputJkhbTeXJf/Zb5XTs0h2v6985WcpTtYKBX8jMKK4JR7cMdTKnpeQJZoZT
         Tc2i6Vj5v9VRA==
Date:   Wed, 7 Apr 2021 09:43:31 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Bhaskar Chowdhury <unixbhaskar@gmail.com>
Cc:     linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        rdunlap@infradead.org
Subject: Re: [PATCH V2] xfs: Rudimentary spelling fix
Message-ID: <20210407164331.GP3957620@magnolia>
References: <20210322034538.3022189-1-unixbhaskar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210322034538.3022189-1-unixbhaskar@gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 22, 2021 at 09:15:38AM +0530, Bhaskar Chowdhury wrote:
> s/sytemcall/syscall/
> 
> Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>

I forgot to ack this before putting it in for-next, so:
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>   Changes from V1:
>    Randy's suggestion incorporated.
> 
>  fs/xfs/xfs_inode.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index f93370bd7b1e..3087d03a6863 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -2870,7 +2870,7 @@ xfs_finish_rename(
>  /*
>   * xfs_cross_rename()
>   *
> - * responsible for handling RENAME_EXCHANGE flag in renameat2() sytemcall
> + * responsible for handling RENAME_EXCHANGE flag in renameat2() syscall
>   */
>  STATIC int
>  xfs_cross_rename(
> --
> 2.31.0
> 
