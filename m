Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4402DC433E0
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Jan 2021 19:28:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E22D4233FE
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Jan 2021 19:28:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388386AbhATT23 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 Jan 2021 14:28:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:60936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392527AbhATT2O (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 20 Jan 2021 14:28:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8B9AC23406;
        Wed, 20 Jan 2021 19:27:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611170853;
        bh=0G1nGHOD1ysau5uXBtct75nAxC9GvAfiSdG3zX1sibU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=B2LAMz2FJKAUc7o3gQ9IGpF3OMEuhVytc16Fum50M8ufQyb8znrOd/J/oUl/j9gkA
         nwvMUyEiH9LZUDdENvMcb5ITLyMa6y+rHhppgHm9gmhHEA+Q0JZvzaTPsyjxu8iqMY
         DZ/aKmxWozzGtiCjqBR3hFxe3MjKyngi821NH15zcr0/uVSzIBV/F7N9sQdX0L5wNZ
         NPCtwwuxMBFELWDS8iJt4G6rtQaJZLrGhy+goM8iXndlbZ7MbEdC0BC8K4W9ou/+gy
         Ca9u4hwNkWQflYIbapgFha5zQFkJtlFfC1MHjPdh8R/E/8409CeMcCtQJXxJr+NC4a
         E7UbAqXzyoOuA==
Date:   Wed, 20 Jan 2021 11:27:33 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Yumei Huang <yuhuang@redhat.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com,
        sandeen@sandeen.net, bfoster@redhat.com
Subject: Re: [PATCH] xfs: Fix assert failure in xfs_setattr_size()
Message-ID: <20210120192733.GN3134581@magnolia>
References: <316142100.64829455.1610706461022.JavaMail.zimbra@redhat.com>
 <1492355130.64829487.1610706535069.JavaMail.zimbra@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1492355130.64829487.1610706535069.JavaMail.zimbra@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jan 15, 2021 at 05:28:55AM -0500, Yumei Huang wrote:
> An assert failure is triggered by syzkaller test due to
> ATTR_KILL_PRIV is not cleared before xfs_setattr_size.
> As ATTR_KILL_PRIV is not checked/used by xfs_setattr_size,
> just remove it from the assert.
> 
> Signed-off-by: Yumei Huang <yuhuang@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_iops.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index 67c8dc9..f1e21b6 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -846,7 +846,7 @@
>          ASSERT(xfs_isilocked(ip, XFS_MMAPLOCK_EXCL));
>          ASSERT(S_ISREG(inode->i_mode));
>          ASSERT((iattr->ia_valid & (ATTR_UID|ATTR_GID|ATTR_ATIME|ATTR_ATIME_SET|
> -                ATTR_MTIME_SET|ATTR_KILL_PRIV|ATTR_TIMES_SET)) == 0);
> +                ATTR_MTIME_SET|ATTR_TIMES_SET)) == 0);
>  
>          oldsize = inode->i_size;
>          newsize = iattr->ia_size;
> -- 
> 1.8.3.1
> 
