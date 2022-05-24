Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50188C433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 24 May 2022 03:48:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233911AbiEXDsw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 23 May 2022 23:48:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234016AbiEXDst (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 May 2022 23:48:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A64816CAAD
        for <linux-xfs@vger.kernel.org>; Mon, 23 May 2022 20:48:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 420A66135A
        for <linux-xfs@vger.kernel.org>; Tue, 24 May 2022 03:48:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F555C385AA;
        Tue, 24 May 2022 03:48:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653364126;
        bh=m6+9znr7FuWVvb/B3P+6qLhe5yjlvzJspMD+Akx7jp0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=U8hQLBw6rk1CPbDafUqJk4tHDISAY/nD8E9vrinXIQssS71BD9tEZ05Np8NCO2I+P
         nSLXKO4oG1NRQCecLyzkPwsTgILn/5stHi/e8JDTYN84K9fUlioCm/MqVfCE+34/Jw
         662zAfF+QMk7DrRWe8XPvz+Sb2T1Pw/xg4xzuCkuoRYAdvA+syMhP/eBQcW6hlwl2K
         wKdK+HPmaAE83wmfBGYp/wyVZho4L0emwTCImOjt6s6YwPYkRBfyWS113HpkQMcJ4g
         TDXiAPpx6WJerPLwywEtsM2yIDj4zfbNOTaWF7c9oUQP2p35KblBJ/2fgMeDNQ/32Z
         bmYaoZT9sFfSw==
Date:   Mon, 23 May 2022 20:48:46 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: assert in xfs_btree_del_cursor should take into
 account error
Message-ID: <YoxVnupPDEYB+9EG@magnolia>
References: <20220524022158.1849458-1-david@fromorbit.com>
 <20220524022158.1849458-4-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220524022158.1849458-4-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 24, 2022 at 12:21:58PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> xfs/538 on a 1kB block filesystem failed with this assert:
> 
> XFS: Assertion failed: cur->bc_btnum != XFS_BTNUM_BMAP || cur->bc_ino.allocated == 0 || xfs_is_shutdown(cur->bc_mp), file: fs/xfs/libxfs/xfs_btree.c, line: 448
> 
> The problem was that an allocation failed unexpectedly in
> xfs_bmbt_alloc_block() after roughly 150,000 minlen allocation error
> injections, resulting in an EFSCORRUPTED error being returned to
> xfs_bmapi_write(). The error occurred on extent-to-btree format
> conversion allocating the new root block:
> 
>  RIP: 0010:xfs_bmbt_alloc_block+0x177/0x210
>  Call Trace:
>   <TASK>
>   xfs_btree_new_iroot+0xdf/0x520
>   xfs_btree_make_block_unfull+0x10d/0x1c0
>   xfs_btree_insrec+0x364/0x790
>   xfs_btree_insert+0xaa/0x210
>   xfs_bmap_add_extent_hole_real+0x1fe/0x9a0
>   xfs_bmapi_allocate+0x34c/0x420
>   xfs_bmapi_write+0x53c/0x9c0
>   xfs_alloc_file_space+0xee/0x320
>   xfs_file_fallocate+0x36b/0x450
>   vfs_fallocate+0x148/0x340
>   __x64_sys_fallocate+0x3c/0x70
>   do_syscall_64+0x35/0x80
>   entry_SYSCALL_64_after_hwframe+0x44/0xa
> 
> Why the allocation failed at this point is unknown, but is likely
> that we ran the transaction out of reserved space and filesystem out
> of space with bmbt blocks because of all the minlen allocations
> being done causing worst case fragmentation of a large allocation.
> 
> Regardless of the cause, we've then called xfs_bmapi_finish() which
> calls xfs_btree_del_cursor(cur, error) to tear down the cursor.
> 
> So we have a failed operation, error != 0, cur->bc_ino.allocated > 0
> and the filesystem is still up. The assert fails to take into
> account that allocation can fail with an error and the transaction
> teardown will shut the filesystem down if necessary. i.e. the
> assert needs to check "|| error != 0" as well, because at this point
> shutdown is pending because the current transaction is dirty....
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_btree.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
> index 786ec1cb1bba..32100cfb9dfc 100644
> --- a/fs/xfs/libxfs/xfs_btree.c
> +++ b/fs/xfs/libxfs/xfs_btree.c
> @@ -445,8 +445,14 @@ xfs_btree_del_cursor(
>  			break;
>  	}
>  
> +	/*
> +	 * If we are doing a BMBT update, the number of unaccounted blocks
> +	 * allocated during this cursor life time should be zero. If it's not
> +	 * zero, then we should be shut down or on our way to shutdown due to
> +	 * cancelling a dirty transaction on error.
> +	 */
>  	ASSERT(cur->bc_btnum != XFS_BTNUM_BMAP || cur->bc_ino.allocated == 0 ||
> -	       xfs_is_shutdown(cur->bc_mp));
> +	       xfs_is_shutdown(cur->bc_mp) || error != 0);

Ewww, multiline assertions! 8-D

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

>  	if (unlikely(cur->bc_flags & XFS_BTREE_STAGING))
>  		kmem_free(cur->bc_ops);
>  	if (!(cur->bc_flags & XFS_BTREE_LONG_PTRS) && cur->bc_ag.pag)
> -- 
> 2.35.1
> 
