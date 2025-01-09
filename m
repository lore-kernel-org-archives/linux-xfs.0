Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF3E72F2F
	for <linux-xfs@vger.kernel.org>; Thu,  9 Jan 2025 04:41:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736397703; cv=none; b=q/6cIUNU5e4WYlAsTkkVUbbRbh7pDvQBL3F+4frAy1xu1Mq6UtjJ556SLz+pGLAvfrj5MaqyuGPKLBFjKP1VM+I3W0Zt1x5QoVILPAfENDg7o4Y0snvumezExrOyVWboBdRoebMsG1+YvXFkWUJZrAi8NRyRpUps5nqT08BYZpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736397703; c=relaxed/simple;
	bh=xtK+yRXEdtOgndKO7CaADDScKv7608kP77RRWEjGQqI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Wzkt3jai3oyje3aFLx/Qcu1BKt5jiNgqyj/rmept5d/IOEWDQRULvdwZT+Um7tiQI3963J/d1wEPjXrWXqAzrqNl2xrb3XHX2JgetYLmDfpT2ZhnSpg5CMluubXMmKG+rbs5i31q5yjJodXtE80cHfGlDTIbLGCoGVVSQ5ZYgCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IEjUf0nd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IEjUf0nd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37C4CC4CED2;
	Thu,  9 Jan 2025 04:41:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736397703;
	bh=xtK+yRXEdtOgndKO7CaADDScKv7608kP77RRWEjGQqI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IEjUf0ndtwQYSQsh06sdmsrzBwNkoOwZdoIYfMjqGGIbJqj4epRWnYjYtdygR0gh0
	 gJzztoesrI9G/BpCei3OoR2F7sH98xblro/WPR6bXvXLP2lI98JYpwmDJ5AuuJwpwh
	 choz646z08xJr34JLw1ESQOUry2sCOmizhBNtG3ELyJ70yk+voUyxNA5BYJ9j3zBLp
	 +UV9nTBaseCO/QgOc97+MLyFTdCTFY0gW0G/9e3E/eywyFzLlSOhH7OhbBOjZJpVeS
	 H42dcFhYPPE0UVCG9ozQfB7X7r9ejDN/TuPu5BeWDjNHSN9LhxbSGBVwY6VyE9c60K
	 ZH8Sfp8qD3Bug==
Date: Wed, 8 Jan 2025 20:41:42 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Long Li <leo.lilong@huawei.com>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, david@fromorbit.com,
	yi.zhang@huawei.com, houtao1@huawei.com, yangerkun@huawei.com,
	lonuxli.64@gmail.com
Subject: Re: [PATCH v2] xfs: fix mount hang during primary superblock
 recovery failure
Message-ID: <20250109044142.GM1306365@frogsfrogsfrogs>
References: <20250109021320.429625-1-leo.lilong@huawei.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250109021320.429625-1-leo.lilong@huawei.com>

On Thu, Jan 09, 2025 at 10:13:20AM +0800, Long Li wrote:
> When mounting an image containing a log with sb modifications that require
> log replay, the mount process hang all the time and stack as follows:
> 
>   [root@localhost ~]# cat /proc/557/stack
>   [<0>] xfs_buftarg_wait+0x31/0x70
>   [<0>] xfs_buftarg_drain+0x54/0x350
>   [<0>] xfs_mountfs+0x66e/0xe80
>   [<0>] xfs_fs_fill_super+0x7f1/0xec0
>   [<0>] get_tree_bdev_flags+0x186/0x280
>   [<0>] get_tree_bdev+0x18/0x30
>   [<0>] xfs_fs_get_tree+0x1d/0x30
>   [<0>] vfs_get_tree+0x2d/0x110
>   [<0>] path_mount+0xb59/0xfc0
>   [<0>] do_mount+0x92/0xc0
>   [<0>] __x64_sys_mount+0xc2/0x160
>   [<0>] x64_sys_call+0x2de4/0x45c0
>   [<0>] do_syscall_64+0xa7/0x240
>   [<0>] entry_SYSCALL_64_after_hwframe+0x76/0x7e
> 
> During log recovery, while updating the in-memory superblock from the
> primary SB buffer, if an error is encountered, such as superblock
> corruption occurs or some other reasons, we will proceed to out_release
> and release the xfs_buf. However, this is insufficient because the
> xfs_buf's log item has already been initialized and the xfs_buf is held
> by the buffer log item as follows, the xfs_buf will not be released,
> causing the mount thread to hang.

Can you post a regression test for us, pretty please? :)

>   xlog_recover_do_primary_sb_buffer
>     xlog_recover_do_reg_buffer
>       xlog_recover_validate_buf_type
>         xfs_buf_item_init(bp, mp)
> 
> The solution is straightforward, we simply need to allow it to be
> handled by the normal buffer write process. The filesystem will be
> shutdown before the submission of buffer_list in xlog_do_recovery_pass(),
> ensuring the correct release of the xfs_buf as follows:
> 
>   xlog_do_recovery_pass
>     error = xlog_recover_process
>       xlog_recover_process_data
>         xlog_recover_process_ophdr
>           xlog_recovery_process_trans
>             ...
>               xlog_recover_buf_commit_pass2
>                 error = xlog_recover_do_primary_sb_buffer
>                   //Encounter error and return
>                 if (error)
>                   goto out_writebuf
>                 ...
>               out_writebuf:
>                 xfs_buf_delwri_queue(bp, buffer_list) //add bp to list
>                 return  error
>             ...
>     if (!list_empty(&buffer_list))
>       if (error)
>         xlog_force_shutdown(log, SHUTDOWN_LOG_IO_ERROR); //shutdown first
>       xfs_buf_delwri_submit(&buffer_list); //write buffer in list
>         __xfs_buf_submit
>           if (bp->b_mount->m_log && xlog_is_shutdown(bp->b_mount->m_log))
>             xfs_buf_ioend_fail(bp)  //release bp correctly
> 

Please add:
Cc: <stable@vger.kernel.org> # v6.12

> Fixes: 6a18765b54e2 ("xfs: update the file system geometry after recoverying superblock buffers")
> Signed-off-by: Long Li <leo.lilong@huawei.com>
> ---
> v1->v2: Add code comments and add the fixed stack description to the 
>         commit message.
>  fs/xfs/xfs_buf_item_recover.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
> index 3d0c6402cb36..04122bbdd5f3 100644
> --- a/fs/xfs/xfs_buf_item_recover.c
> +++ b/fs/xfs/xfs_buf_item_recover.c
> @@ -1079,7 +1079,7 @@ xlog_recover_buf_commit_pass2(
>  		error = xlog_recover_do_primary_sb_buffer(mp, item, bp, buf_f,
>  				current_lsn);
>  		if (error)
> -			goto out_release;
> +			goto out_writebuf;
>  
>  		/* Update the rt superblock if we have one. */
>  		if (xfs_has_rtsb(mp) && mp->m_rtsb_bp) {
> @@ -1096,6 +1096,15 @@ xlog_recover_buf_commit_pass2(
>  		xlog_recover_do_reg_buffer(mp, item, bp, buf_f, current_lsn);
>  	}
>  
> +	/*
> +	 * Buffer held by buf log item during 'normal' buffer recovery must
> +	 * be committed through buffer I/O submission path to ensure proper
> +	 * release. When error occurs during do sb buffer recovery, log

"...during sb buffer recovery..."

and with those two things amended,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D


> +	 * shutdown will be done before submitting buffer list so that buffers
> +	 * can be released correctly through ioend failure path.
> +	 */
> +out_writebuf:
> +
>  	/*
>  	 * Perform delayed write on the buffer.  Asynchronous writes will be
>  	 * slower when taking into account all the buffers to be flushed.
> -- 
> 2.39.2
> 
> 
