Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A18001D5178
	for <linux-xfs@vger.kernel.org>; Mon,  6 Jan 2025 19:55:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736193342; cv=none; b=Aza4GR0ChySZdEJleH5yLdU7DL5szaknsYAGpp+HWxC+opypBX4oG0cqesG9WS8bAINwqNBwwU24mXPUl2v+5z+0XbOyGULfbi/siTwKqeXUeP/WxF6yR2ncgyUMPqcKKBiSHh9wRMAmulsHCkwZXvl4VRBNNodNmzANEhGlseE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736193342; c=relaxed/simple;
	bh=V8CQXiHl4twLln8mop8HALESoPpI6phrwnHCsnfayCM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HozOZZFR5fMQJiDrtbgedw7FlwNampZVsI93uwDfA+W9UiWqN+mekFw51AOvX2mLQKqOa6GoKbDlGbpbuBABjCiq8IPnPxwcyZBVFCedxOlLTcPIfSo23ozuk3JCGdeQ+A+/fJ9s/gkmVa1O+DTq+u9PeBbHzo3oyn2zohenigQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Vgmi3rIa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Vgmi3rIa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05B88C4CED6;
	Mon,  6 Jan 2025 19:55:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736193342;
	bh=V8CQXiHl4twLln8mop8HALESoPpI6phrwnHCsnfayCM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Vgmi3rIahoC4CcWyBKkAlC378RoiBqoGFXRJYJjfPflGAeXPV0pmSIHDQnkLSXHQ6
	 ZQSBJy4V565NBJkwn1ZrgyMpK2jqL5IwvXEOOBPv43Q6zjCOTFFjAjim57N2x41MBX
	 Dr6DSkK2qqcp7k9Sndd+uU4iSNJMAAPccMJuVPOouWgPdw2ShMRWF5JCF/DV2vMMw2
	 f1yLlOS4SBZcXv17aQCptQ4d+CnH6IOlsXogar/3m6rDcDRqAfy/ShQGeAWWfHbIEb
	 L5q807Sqi7cAtm/r15s610/aDafbbdzSdfMW6/yAQfywAWIUJa3hYonsmmiDBWe7Ey
	 gXVqj6nT02d4w==
Date: Mon, 6 Jan 2025 11:55:41 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Long Li <leo.lilong@huawei.com>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, david@fromorbit.com,
	yi.zhang@huawei.com, houtao1@huawei.com, yangerkun@huawei.com,
	lonuxli.64@gmail.com
Subject: Re: [PATCH 2/2] xfs: fix mount hang during primary superblock
 recovery failure
Message-ID: <20250106195541.GL6174@frogsfrogsfrogs>
References: <20241231023423.656128-1-leo.lilong@huawei.com>
 <20241231023423.656128-3-leo.lilong@huawei.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241231023423.656128-3-leo.lilong@huawei.com>

On Tue, Dec 31, 2024 at 10:34:23AM +0800, Long Li wrote:
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
> 
>   xlog_recover_do_primary_sb_buffer
>     xlog_recover_do_reg_buffer
>       xlog_recover_validate_buf_type
>         xfs_buf_item_init(bp, mp)
> 
> The solution is straightforward: we simply need to allow it to be
> handled by the normal buffer write process. The filesystem will be
> shutdown before the submission of buffer_list in xlog_do_recovery_pass(),

What shuts it down?  If xlog_recover_do_primary_sb_buffer trips over
something like "mp->m_sb.sb_rgcount < orig_rgcount" then we haven't shut
anything down yet.  Am I missing something? <confused>

--D

> ensuring the correct release of the xfs_buf.
> 
> Fixes: 6a18765b54e2 ("xfs: update the file system geometry after recoverying superblock buffers")
> Signed-off-by: Long Li <leo.lilong@huawei.com>
> ---
>  fs/xfs/xfs_buf_item_recover.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
> index 3d0c6402cb36..ec2a42ef66ff 100644
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
> @@ -1096,6 +1096,7 @@ xlog_recover_buf_commit_pass2(
>  		xlog_recover_do_reg_buffer(mp, item, bp, buf_f, current_lsn);
>  	}
>  
> +out_writebuf:
>  	/*
>  	 * Perform delayed write on the buffer.  Asynchronous writes will be
>  	 * slower when taking into account all the buffers to be flushed.
> -- 
> 2.39.2
> 
> 
