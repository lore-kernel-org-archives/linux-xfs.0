Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54077184F
	for <linux-xfs@vger.kernel.org>; Thu,  4 Jan 2024 02:01:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cbg1wt6H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABA18C433C9;
	Thu,  4 Jan 2024 02:01:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704333681;
	bh=oZLbiGigBkOfTwisTEvZ6ECmKwOfzOmRJBghpSlPst0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cbg1wt6Hw3HvBEvWZFzTYlDvMTSFne+rPc90YBXdp9fbzllDLd9hF3AW4noDaMTHt
	 J/Alw/z+7WSlkKJf36X4hFpza9ZUw5jK4ZWULefVd1elQOhZxLy1tw7fEtg0e9UnPm
	 Kz+1+GndVS6WxiZsGkb8Ku1B74G+JYcD+SrG/OG1TLC6xUpZHrzvsoMMsBHVQbVFzD
	 lMNaRI3S8FgTbzhbw+fXoUi70ZNRwqHijFWi+XS666njzVZ89mENdVKUfCJLC4xuME
	 k9j6FcFiCnWvKV5ERnVgI76WyqGhV3P5WCyD6RkUStuzubaQ31GJxNguWNO6MXnoaE
	 vZavpq4i9uk/Q==
Date: Wed, 3 Jan 2024 18:01:21 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Long Li <leo.lilong@huawei.com>
Cc: chandanbabu@kernel.org, linux-xfs@vger.kernel.org, yi.zhang@huawei.com,
	houtao1@huawei.com, yangerkun@huawei.com
Subject: Re: [PATCH] xfs: ensure submit buffers on LSN boundaries in error
 handlers
Message-ID: <20240104020121.GS361584@frogsfrogsfrogs>
References: <20231228124646.142757-1-leo.lilong@huawei.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231228124646.142757-1-leo.lilong@huawei.com>

On Thu, Dec 28, 2023 at 08:46:46PM +0800, Long Li wrote:
> While performing the IO fault injection test, I caught the following data
> corruption report:
> 
>  XFS (dm-0): Internal error ltbno + ltlen > bno at line 1957 of file fs/xfs/libxfs/xfs_alloc.c.  Caller xfs_free_ag_extent+0x79c/0x1130
>  CPU: 3 PID: 33 Comm: kworker/3:0 Not tainted 6.5.0-rc7-next-20230825-00001-g7f8666926889 #214
>  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS ?-20190727_073836-buildvm-ppc64le-16.ppc.fedoraproject.org-3.fc31 04/01/2014
>  Workqueue: xfs-inodegc/dm-0 xfs_inodegc_worker
>  Call Trace:
>   <TASK>
>   dump_stack_lvl+0x50/0x70
>   xfs_corruption_error+0x134/0x150
>   xfs_free_ag_extent+0x7d3/0x1130
>   __xfs_free_extent+0x201/0x3c0
>   xfs_trans_free_extent+0x29b/0xa10
>   xfs_extent_free_finish_item+0x2a/0xb0
>   xfs_defer_finish_noroll+0x8d1/0x1b40
>   xfs_defer_finish+0x21/0x200
>   xfs_itruncate_extents_flags+0x1cb/0x650
>   xfs_free_eofblocks+0x18f/0x250
>   xfs_inactive+0x485/0x570
>   xfs_inodegc_worker+0x207/0x530
>   process_scheduled_works+0x24a/0xe10
>   worker_thread+0x5ac/0xc60
>   kthread+0x2cd/0x3c0
>   ret_from_fork+0x4a/0x80
>   ret_from_fork_asm+0x11/0x20
>   </TASK>
>  XFS (dm-0): Corruption detected. Unmount and run xfs_repair
> 
> After analyzing the disk image, it was found that the corruption was
> triggered by the fact that extent was recorded in both the inode and AGF
> btrees. After a long time of reproduction and analysis, we found that the
> root cause of the problem was that the AGF btree block was not recovered.
> 
> Consider the following situation, Transaction A and Transaction B are in
> the same record, so Transaction A and Transaction B share the same LSN1.
> If the buf item in Transaction A has been recovered, then the buf item in
> Transaction B cannot be recovered, because log recovery skips items with a
> metadata LSN >= the current LSN of the recovery item. If there is still an
> inode item in transaction B that records the Extent X, the Extent X will
> be recorded in both the inode and the AGF btree block after transaction B
> is recovered.
> 
>   |------------Record (LSN1)------------------|---Record (LSN2)---|
>   |----------Trans A------------|-------------Trans B-------------|
>   |     Buf Item(Extent X)      | Buf Item / Inode item(Extent X) |
>   |     Extent X is freed       |     Extent X is allocated       |
> 
> After commit 12818d24db8a ("xfs: rework log recovery to submit buffers on
> LSN boundaries") was introduced, we submit buffers on lsn boundaries during
> log recovery. The above problem can be avoided under normal paths, but it's
> not guaranteed under abnormal paths. Consider the following process, if an
> error was encountered after recover buf item in transaction A and before
> recover buf item in transaction B, buffers that have been added to
> buffer_list will still be submitted, this violates the submits rule on lsn
> boundaries. So buf item in Transaction B cannot be recovered on the next
> mount due to current lsn of transaction equal to metadata lsn on disk.
> 
>   xlog_do_recovery_pass
>     error = xlog_recover_process
>       xlog_recover_process_data
>         ...
>           xlog_recover_buf_commit_pass2
>             xlog_recover_do_reg_buffer  //recover buf item in Trans A
>             xfs_buf_delwri_queue(bp, buffer_list)
>         ...
>         ====> Encountered error and returned
>         ...
>           xlog_recover_buf_commit_pass2
>             xlog_recover_do_reg_buffer  //recover buf item in Trans B
>             xfs_buf_delwri_queue(bp, buffer_list)
>     if (!list_empty(&buffer_list))
>       xfs_buf_delwri_submit(&buffer_list); //submit regardless of error
> 
> In order to make sure that submits buffers on lsn boundaries in the
> abnormal paths, we need to check error status before submit buffers that
> have been added from the last record processed. If error status exist,
> buffers in the bufffer_list should be canceled.

What was the error, specifically?  I would have though that recovery
would abort after "Encountered error and returned".  Does the recovery
somehow keep running and then finds the buf item in Trans B?

Or is the problem here that after the error, xfs submits the delwri
buffers?  And then the user tried to recover a second time, only this
time the recovery attempt reads Trans B, but then doesn't actually write
anything because the ondisk buffer now has the same LSN as Trans B?

<confused>

--D

> Canceling the buffers in the buffer_list directly isn't correct, unlike
> any other place where write list was canceled, these buffers has been
> initialized by xfs_buf_item_init() during recovery and held by buf
> item, buf items will not be released in xfs_buf_delwri_cancel(). If
> these buffers are submitted successfully, buf items assocated with
> the buffer will be released in io end process. So releasing buf item
> in write list cacneling process is needed.
> 
> Fixes: 50d5c8d8e938 ("xfs: check LSN ordering for v5 superblocks during recovery")
> Signed-off-by: Long Li <leo.lilong@huawei.com>
> ---
>  fs/xfs/xfs_buf.c         |  2 ++
>  fs/xfs/xfs_log_recover.c | 22 +++++++++++++---------
>  2 files changed, 15 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 8e5bd50d29fe..6a1b26aaf97e 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -2075,6 +2075,8 @@ xfs_buf_delwri_cancel(
>  		xfs_buf_lock(bp);
>  		bp->b_flags &= ~_XBF_DELWRI_Q;
>  		xfs_buf_list_del(bp);
> +		if (bp->b_log_item)
> +			xfs_buf_item_relse(bp);
>  		xfs_buf_relse(bp);
>  	}
>  }
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 1251c81e55f9..2cda6c90890d 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -2964,7 +2964,6 @@ xlog_do_recovery_pass(
>  	char			*offset;
>  	char			*hbp, *dbp;
>  	int			error = 0, h_size, h_len;
> -	int			error2 = 0;
>  	int			bblks, split_bblks;
>  	int			hblks, split_hblks, wrapped_hblks;
>  	int			i;
> @@ -3203,16 +3202,21 @@ xlog_do_recovery_pass(
>   bread_err1:
>  	kmem_free(hbp);
>  
> -	/*
> -	 * Submit buffers that have been added from the last record processed,
> -	 * regardless of error status.
> -	 */
> -	if (!list_empty(&buffer_list))
> -		error2 = xfs_buf_delwri_submit(&buffer_list);
> -
>  	if (error && first_bad)
>  		*first_bad = rhead_blk;
>  
> +	/*
> +	 * If there are no error, submit buffers that have been added from the
> +	 * last record processed, othrewise cancel the write list, to ensure
> +	 * submit buffers on LSN boundaries.
> +	 */
> +	if (!list_empty(&buffer_list)) {
> +		if (error)
> +			xfs_buf_delwri_cancel(&buffer_list);
> +		else
> +			error = xfs_buf_delwri_submit(&buffer_list);
> +	}
> +
>  	/*
>  	 * Transactions are freed at commit time but transactions without commit
>  	 * records on disk are never committed. Free any that may be left in the
> @@ -3226,7 +3230,7 @@ xlog_do_recovery_pass(
>  			xlog_recover_free_trans(trans);
>  	}
>  
> -	return error ? error : error2;
> +	return error;
>  }
>  
>  /*
> -- 
> 2.31.1
> 
> 
