Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EBF3C4332B
	for <linux-xfs@archiver.kernel.org>; Thu, 21 Jan 2021 18:47:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F8DF23A1C
	for <linux-xfs@archiver.kernel.org>; Thu, 21 Jan 2021 18:47:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725275AbhAUSqA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 21 Jan 2021 13:46:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:34470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727525AbhAUSmY (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 21 Jan 2021 13:42:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2835820663;
        Thu, 21 Jan 2021 18:41:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611254498;
        bh=zUyVSomcOLJhZqUOWCun3ToANA99xAvMOlulwnj2ps8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VgUUy1wmJh3wnXnN8uP6I0WZG851YhCN2YKVHZYYztg/fUeyZBBI4DJzF6tlLoHc4
         EaoOfF1WXY8tRLMwp/kP/1j8csWEOUHds4ZtanprT30tj1dmTZEfFZoeQFuuK5tSsB
         zhV6O8Fl55tedNR36ZnMdGf9Y8ORFqw31XauriEhKInw+gZjv3n8Ju7lUnmARGnMYL
         Ghd9ZSRAFng90siSedQNlJl4x3Pki9PT2egyM9mneV5ZGXlkfXfhO6Y+nOHqbFsYOx
         uJ7Vn/12AVlNfhoH/2ngUADIireGx8vagPz94W6NtBFnwXqvho5tHIrIC6V4Xm1Gm9
         0S1D5J89ZEogw==
Date:   Thu, 21 Jan 2021 10:41:37 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Jeffrey Mitchell <jeffrey.mitchell@starlab.io>
Cc:     linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: set inode size after creating symlink
Message-ID: <20210121184137.GB1282159@magnolia>
References: <20210121151912.4429-1-jeffrey.mitchell@starlab.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210121151912.4429-1-jeffrey.mitchell@starlab.io>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 21, 2021 at 09:19:12AM -0600, Jeffrey Mitchell wrote:
> When XFS creates a new symlink, it writes its size to disk but not to the
> VFS inode. This causes i_size_read() to return 0 for that symlink until
> it is re-read from disk, for example when the system is rebooted.
> 
> I found this inconsistency while protecting directories with eCryptFS.

Heh.  No doubt caused by the fact that we only call i_size_write for
regular files, ecryptfs copies i_size_read() of the lower dentry into
the ecryptfs inode, and ecryptfs_getattr_link and doesn't call ->getattr
on the lower inode.

Do directories have the same problem?  I'm guessing no because every
other file type calls vfs_getattr on the lower dentry, which should link
us to xfs_vn_getattr.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D


> The command "stat path/to/symlink/in/ecryptfs" will report "Size: 0" if
> the symlink was created after the last reboot on an XFS root.
> 
> Call i_size_write() in xfs_symlink()
> 
> Signed-off-by: Jeffrey Mitchell <jeffrey.mitchell@starlab.io>
> ---
>  fs/xfs/xfs_symlink.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
> index 1f43fd7f3209..c835827ae389 100644
> --- a/fs/xfs/xfs_symlink.c
> +++ b/fs/xfs/xfs_symlink.c
> @@ -300,6 +300,7 @@ xfs_symlink(
>  		}
>  		ASSERT(pathlen == 0);
>  	}
> +	i_size_write(VFS_I(ip), ip->i_d.di_size);
>  
>  	/*
>  	 * Create the directory entry for the symlink.
> -- 
> 2.25.1
> 
