Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92A40C433B4
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Apr 2021 15:40:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 693EA6113A
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Apr 2021 15:40:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235869AbhDGPlG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 7 Apr 2021 11:41:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:41910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235715AbhDGPlF (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 7 Apr 2021 11:41:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F2EA361262;
        Wed,  7 Apr 2021 15:40:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617810056;
        bh=S1dtcFtV4V9umlJ7LlGG/m3ObX9IKA0nYaXeDsMOAdk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Gm0G74tXx7eyhsLJztT4Vo6veP4+9ETRJV2J55mcqm7uGQXXVaVq5qjFm2pKi1TJp
         2shVfsSTiTJ0dxLxmvKvpOsZvV8pwFl5CNq0TDq61q62PSYa5/xyAl/L+8kPENDDW0
         mQqTTyTndbuL40O7M3KbAsTJ93rOmLPhpLt1YhwEHuT5Npb++9SISs7FtVRlzcg88x
         DDao322eQ/2pG/kd/K8EnGRhzkDKwNuHZKxUFt9vP6FelnqbpjwAxv2ApxbfcvjLCQ
         9KvRNNsgcBMLhRm/xnSlNw0NUAG1Sv2gS3yQMf6uC6poYXkEKuWDLkst0ki1TKfTIC
         NNyRoGCm6FXRg==
Date:   Wed, 7 Apr 2021 08:40:55 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs: drop unused ioend private merge and setfilesize
 code
Message-ID: <20210407154055.GL3957620@magnolia>
References: <20210405145903.629152-1-bfoster@redhat.com>
 <20210405145903.629152-4-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210405145903.629152-4-bfoster@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Apr 05, 2021 at 10:59:02AM -0400, Brian Foster wrote:
> XFS no longer attaches anthing to ioend->io_private. Remove the
> unnecessary ->io_private merging code. This removes the only remaining
> user of xfs_setfilesize_ioend() so remove that function as well.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Hooray for de-warting,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_aops.c | 46 +---------------------------------------------
>  1 file changed, 1 insertion(+), 45 deletions(-)
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index 63ecc04de64f..a7f91f4186bc 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -85,31 +85,6 @@ xfs_setfilesize(
>  	return __xfs_setfilesize(ip, tp, offset, size);
>  }
>  
> -STATIC int
> -xfs_setfilesize_ioend(
> -	struct iomap_ioend	*ioend,
> -	int			error)
> -{
> -	struct xfs_inode	*ip = XFS_I(ioend->io_inode);
> -	struct xfs_trans	*tp = ioend->io_private;
> -
> -	/*
> -	 * The transaction may have been allocated in the I/O submission thread,
> -	 * thus we need to mark ourselves as being in a transaction manually.
> -	 * Similarly for freeze protection.
> -	 */
> -	xfs_trans_set_context(tp);
> -	__sb_writers_acquired(VFS_I(ip)->i_sb, SB_FREEZE_FS);
> -
> -	/* we abort the update if there was an IO error */
> -	if (error) {
> -		xfs_trans_cancel(tp);
> -		return error;
> -	}
> -
> -	return __xfs_setfilesize(ip, tp, ioend->io_offset, ioend->io_size);
> -}
> -
>  /*
>   * IO write completion.
>   */
> @@ -163,25 +138,6 @@ xfs_end_ioend(
>  	memalloc_nofs_restore(nofs_flag);
>  }
>  
> -/*
> - * If the to be merged ioend has a preallocated transaction for file
> - * size updates we need to ensure the ioend it is merged into also
> - * has one.  If it already has one we can simply cancel the transaction
> - * as it is guaranteed to be clean.
> - */
> -static void
> -xfs_ioend_merge_private(
> -	struct iomap_ioend	*ioend,
> -	struct iomap_ioend	*next)
> -{
> -	if (!ioend->io_private) {
> -		ioend->io_private = next->io_private;
> -		next->io_private = NULL;
> -	} else {
> -		xfs_setfilesize_ioend(next, -ECANCELED);
> -	}
> -}
> -
>  /* Finish all pending io completions. */
>  void
>  xfs_end_io(
> @@ -201,7 +157,7 @@ xfs_end_io(
>  	while ((ioend = list_first_entry_or_null(&tmp, struct iomap_ioend,
>  			io_list))) {
>  		list_del_init(&ioend->io_list);
> -		iomap_ioend_try_merge(ioend, &tmp, xfs_ioend_merge_private);
> +		iomap_ioend_try_merge(ioend, &tmp, NULL);
>  		xfs_end_ioend(ioend);
>  	}
>  }
> -- 
> 2.26.3
> 
