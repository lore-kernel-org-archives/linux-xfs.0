Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31731C432BE
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Aug 2021 02:59:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1645361181
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Aug 2021 02:59:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234557AbhHXDAA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 23 Aug 2021 23:00:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:55318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234521AbhHXC7Z (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 23 Aug 2021 22:59:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 97211611C9;
        Tue, 24 Aug 2021 02:58:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629773921;
        bh=KaKjJVdeVwQxJCv/lgw+1AwyAPRlqEtNrVfweZgoVlc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ixEIjIuoHio/uwgndvaM4VBjcXMjQZce6u9U+mzuOHlmC4sSSWR1VpMbGLaKvrirC
         u7r4NEDcwtTSdaXX2uO9kz3aQ0YlZWpowUB0yoKBUEGE1ckcf17VD2mS4v3DGiKkWd
         XlGupMMuBtesPKYoZfqmaSH6cw1JACgOx9WQj4ODmR79YDdFfroG2yO8E2h8JHsKY6
         T9DjF5jDA6AtiBXJ3vwr1zpFltJxUP3AVXwlRgmMUXTGiUzJHJVVDQOK5ZzrtC9JQ+
         EemJxdUT/qfjQVQQFTdR3Q5BehnklR16ybAv5ZzbtsP1KYSIGXugoQrfTvrZC5tpAh
         DUkU0hHwcdDpA==
Date:   Mon, 23 Aug 2021 19:58:41 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: fix I_DONTCACHE
Message-ID: <20210824025841.GE12640@magnolia>
References: <20210824023208.392670-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210824023208.392670-1-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 24, 2021 at 12:32:08PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Yup, the VFS hoist broke it, and nobody noticed. Bulkstat workloads
> make it clear that it doesn't work as it should.

Is there an easy way to test the dontcache behavior so that we don't
screw this up again?

/me's brain is fried, will study this in more detail in the morning.

--D

> Fixes: dae2f8ed7992 ("fs: Lift XFS_IDONTCACHE to the VFS layer")
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_icache.c | 3 ++-
>  fs/xfs/xfs_iops.c   | 2 +-
>  2 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index a3fe4c5307d3..f2210d927481 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -84,8 +84,9 @@ xfs_inode_alloc(
>  		return NULL;
>  	}
>  
> -	/* VFS doesn't initialise i_mode! */
> +	/* VFS doesn't initialise i_mode or i_state! */
>  	VFS_I(ip)->i_mode = 0;
> +	VFS_I(ip)->i_state = 0;
>  
>  	XFS_STATS_INC(mp, vn_active);
>  	ASSERT(atomic_read(&ip->i_pincount) == 0);
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index 0ff0cca94092..a607d6aca5c4 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -1344,7 +1344,7 @@ xfs_setup_inode(
>  	gfp_t			gfp_mask;
>  
>  	inode->i_ino = ip->i_ino;
> -	inode->i_state = I_NEW;
> +	inode->i_state |= I_NEW;
>  
>  	inode_sb_list_add(inode);
>  	/* make the inode look hashed for the writeback code */
> -- 
> 2.31.1
> 
