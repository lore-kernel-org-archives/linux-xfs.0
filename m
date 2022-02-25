Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8007FC433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Feb 2022 01:57:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234262AbiBYB6O (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Feb 2022 20:58:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236634AbiBYB6M (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Feb 2022 20:58:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52CCB1795D6
        for <linux-xfs@vger.kernel.org>; Thu, 24 Feb 2022 17:57:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0C1B4B82A89
        for <linux-xfs@vger.kernel.org>; Fri, 25 Feb 2022 01:57:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3414C340E9;
        Fri, 25 Feb 2022 01:57:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645754258;
        bh=VK3cM6VFmokqUao/CpegB4ul/Ty0F0SW0DEatTJ3Gwg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UmJtqeofA89a4wEw+hNlARRTvp3FEtuhSXASSFVdeygBhpHN02OA64ETI4KtvIw1h
         eIB+cWEFZdgd7RuPQguqKYfjEFzYIsMP8aFiRzdJ90yo2KB5xFxWMWnWno591geV4W
         m1RgQAusYo0wpiyllNrD1YjJc59UqTh7xoalzFod9wei1dI6aBBU9DZWNQHPg7kyfr
         EGKQ9Kn71AP9fclAgIKoo6Lhc30+ieTyQ2Q4LYgq/jVgYZyJ+h2JNv5fA4TI3+x5La
         rDGqkTWuVLoj1wyR4bInTqrC/67DTuVJ1f1T8tFtm3rk3Zaoc5oLhqDFQkHF4I7jDM
         mSasuJkw4MEeA==
Date:   Thu, 24 Feb 2022 17:57:38 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>
Cc:     linux-xfs@vger.kernel.org, christian.brauner@ubuntu.com, hch@lst.de
Subject: Re: [PATCH] xfs: do not clear S_ISUID|S_ISGID for idmapped mounts
Message-ID: <20220225015738.GP8313@magnolia>
References: <20220221182218.748084-1-andrey.zhadchenko@virtuozzo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220221182218.748084-1-andrey.zhadchenko@virtuozzo.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 21, 2022 at 09:22:18PM +0300, Andrey Zhadchenko wrote:
> xfs_fileattr_set() handles idmapped mounts correctly and do not drop this
> bits.
> Unfortunately chown syscall results in different callstask:
> i_op->xfs_vn_setattr()->...->xfs_setattr_nonsize() which checks if process
> has CAP_FSETID capable in init_user_ns rather than mntns userns.
> 
> Signed-off-by: Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>

LGTM...
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_iops.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index 09211e1d08ad..5b1fe635d153 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -774,7 +774,7 @@ xfs_setattr_nonsize(
>  		 * cleared upon successful return from chown()
>  		 */
>  		if ((inode->i_mode & (S_ISUID|S_ISGID)) &&
> -		    !capable(CAP_FSETID))
> +		    !capable_wrt_inode_uidgid(mnt_userns, inode, CAP_FSETID))
>  			inode->i_mode &= ~(S_ISUID|S_ISGID);
>  
>  		/*
> -- 
> 2.35.0.rc2
> 
