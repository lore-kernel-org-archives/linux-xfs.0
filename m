Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81FBE11C86
	for <linux-xfs@vger.kernel.org>; Sun,  7 Jan 2024 22:13:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="qCXcKDaG"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-6d9bba6d773so1041454b3a.1
        for <linux-xfs@vger.kernel.org>; Sun, 07 Jan 2024 14:13:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1704665634; x=1705270434; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=A5xc77vvTUnpGEBEU3UW27b1PuszV15B9rIQ3gJupFQ=;
        b=qCXcKDaGU4jPTE4IZRhePnSGb1CoQuucI1QotSsQMBdqJ8+zWBfwsENm2h5qRYIsoD
         4ca0I5beam8+ljubEDsFVyzVdQZzDERkDs/74UOxmiPnEx50sNnsTsluBi6tEGDrmW9w
         NYDs82RWd0QVGDswAIuEWyF3CQijhGFFidKa4CMVrtC5Ag52joYlqPQtLmz+ao7DqVpw
         +mjO18qhV1VNt6x5GuRYRh/X01sUFfToBeSsmo089YqxfBM1WsyW2/cSIYL0bYFwuZS+
         bbIKkYrEMzUN5RzjKUJO1hD8UqN/IOgnD+3Ybhsryuz8wAPOD+wZeJ+WzzAwiv54sV0F
         f1Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704665634; x=1705270434;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A5xc77vvTUnpGEBEU3UW27b1PuszV15B9rIQ3gJupFQ=;
        b=CvaWxges0X1jk6My/sR7T4rQ1fxUTOjKHeO4DzK51R2JmRhjXXf4+rA87rx1D4rsPz
         ZOShMdOxQP5P9aLjnyOeZFO0VGhuqSU+k74GhdVC1k+lGq50GlXk3u2V1pSxsALdAt/n
         Wqmb+beInvbET5oao+GSDD8KlhRWBYPFv+fDJjG9tzN52ftzMHiTdlaEpvKy7luPGHWR
         uNtkgmvRjOVDAA00ZcF9jcvHrZY2LFGTG9WSkHHSVB/FNPRJR+/bYFax7TR3ekQGgAgX
         /uP4CiGAb4keV4psQqsdsw4cONILyScdpDgwRKEn2MDfsREpW6R+n/h1duumAhnHeXCB
         wnFA==
X-Gm-Message-State: AOJu0YwWDKrjwINlcle7mD1di4Y41Hbup4jCE88XrnXTriLhsHMgNJaQ
	wgVZHr1EpugpBa6jbbz2d99ZRQva3Nquhw==
X-Google-Smtp-Source: AGHT+IEdjtistb1IMJBmEae4TTP83w5LnH10q4R5Ljvheyso/Itko3wkWl3oSJ1qkMHiEag1LK6Uog==
X-Received: by 2002:aa7:8688:0:b0:6d9:b173:4f9b with SMTP id d8-20020aa78688000000b006d9b1734f9bmr2883915pfo.38.1704665634533;
        Sun, 07 Jan 2024 14:13:54 -0800 (PST)
Received: from dread.disaster.area (pa49-180-249-6.pa.nsw.optusnet.com.au. [49.180.249.6])
        by smtp.gmail.com with ESMTPSA id a28-20020a62d41c000000b006d9a0902934sm4952070pfh.70.2024.01.07.14.13.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Jan 2024 14:13:53 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rMbOw-007NHJ-0b;
	Mon, 08 Jan 2024 09:13:50 +1100
Date: Mon, 8 Jan 2024 09:13:50 +1100
From: Dave Chinner <david@fromorbit.com>
To: Long Li <leo.lilong@huawei.com>
Cc: djwong@kernel.org, chandanbabu@kernel.org, linux-xfs@vger.kernel.org,
	yi.zhang@huawei.com, houtao1@huawei.com, yangerkun@huawei.com
Subject: Re: [PATCH] xfs: ensure submit buffers on LSN boundaries in error
 handlers
Message-ID: <ZZsiHu15pAMl+7aY@dread.disaster.area>
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

Why was it not recovered? Because of an injected IO error during
recovery?

> Consider the following situation, Transaction A and Transaction B are in
> the same record, so Transaction A and Transaction B share the same LSN1.
> If the buf item in Transaction A has been recovered, then the buf item in
> Transaction B cannot be recovered, because log recovery skips items with a
> metadata LSN >= the current LSN of the recovery item.

This makes no sense to me. Transactions don't exist in the journal;
they are purely in-memory constructs that are aggregated
in memory (in the CIL) before being written to disk as an atomic
checkpoint. Hence a log item can only appear once in a checkpoint
regardless of how many transactions it is modified in memory between
CIL checkpoints.

> If there is still an
> inode item in transaction B that records the Extent X, the Extent X will
> be recorded in both the inode and the AGF btree block after transaction B
> is recovered.

That transaction should record both the addition to the inode BMBT
and the removal from the AGF. Hence if transaction B is recovered in
full with no errors, this should not occur.

> 
>   |------------Record (LSN1)------------------|---Record (LSN2)---|
>   |----------Trans A------------|-------------Trans B-------------|
>   |     Buf Item(Extent X)      | Buf Item / Inode item(Extent X) |
>   |     Extent X is freed       |     Extent X is allocated       |

This looks wrong. A transaction can only exist in a single CIL
checkpoint and everything in a checkpoint has the same LSN. Hence we
cannot have the situation where trans B spans two different
checkpoints and hence span LSNs.

These are valid representations:

  |------------Record (LSN1)----|-----------------Record (LSN2)---|
  |----------Trans A------------|-------------Trans B-------------|

  |------------Record (LSN1)--------------------------------------|
  |----------Trans A------------|-------------Trans B-------------|

  |-----------------------------------------------Record (LSN2)---|
  |----------Trans A------------|-------------Trans B-------------|

Only in the first case are there two instances of the AGF buf item
object in the journal (one in each checkpoint). In the latter two
cases, there is only one copy of the AGF buf log item that contains
extent X. Indeed, it will not contain extent X, because the CIL
aggregation results in the addition in trans A being elided by the
removal in trans B, essentially resulting in the buffer being
unchanged except for the LSN after recovery.

As such, I'm really not sure what you are trying to describe here -
if recovery of the checkpoint at LSN1 fails in any way, we should
never attempt to recovery the checkpoint at LSN2. If LSN1 recoveres
entirely successfully, then LSN2 should see the correct state and
recover appropriately, too. Hence I don't see how the situation you
are describing arises.

> After commit 12818d24db8a ("xfs: rework log recovery to submit buffers on
> LSN boundaries") was introduced, we submit buffers on lsn boundaries during
> log recovery. 

Correct - we submit all the changes in a checkpoint for submission
before we start recovering the next checkpoint. That's because
checkpoints are supposed to be atomic units of change moving the
on-disk state from one change set to the next.

If any error during processing of a checkpoint occurs, we are
supposed to abort recovery at that checkpoint so we don't create a
situation where future recovery attempts skip checkpoints that need
to be recovered.

It does not matter if we write back the modified buffers from
partially completed checkpoints - they were successfully recovered
in their entirity, and so it is safe to write them back knowing that
the next attempt to recover the failed checkpoint will see a
matching LSN and skip that buffer item. If writeback fails, then it
just doesn't matter as the next recovery attempt will see the old
LSN and recover that buf item again and write it back....

AFAICT, you're describing things working as they are supposed to,
and I don't see where the problem you are attempting to fix is yet.

> The above problem can be avoided under normal paths, but it's
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

What error is this, and why isn't it a fatal error causing the
checkpoint recovery to be aborted and the delwri list to be canceled?

>         ...
>           xlog_recover_buf_commit_pass2
>             xlog_recover_do_reg_buffer  //recover buf item in Trans B
>             xfs_buf_delwri_queue(bp, buffer_list)

This should never occur as we should be aborting log recovery on the
first failure, not continuing to process the checkpoint or starting
to process other checkpoints. Where are we failing to handle an
error?

>     if (!list_empty(&buffer_list))
>       xfs_buf_delwri_submit(&buffer_list); //submit regardless of error

Yes, that's fine (as per above). Indeed, this is how we handle
releasing the buffer log item on failure - this goes through IO
completion and that release the buf log item we added to the buffer
during recovery for LSN stamping.

> In order to make sure that submits buffers on lsn boundaries in the
> abnormal paths, we need to check error status before submit buffers that
> have been added from the last record processed. If error status exist,
> buffers in the bufffer_list should be canceled.

No, it does not need to be cancelled, it just needs to be processed.
Anything we've fully recovered is safe to write - it's no different
from having the system crash during AIL writeback having written
back these buffers and having to recover from part way through this
checkpoint.

> Canceling the buffers in the buffer_list directly isn't correct, unlike
> any other place where write list was canceled, these buffers has been
> initialized by xfs_buf_item_init() during recovery and held by buf
> item, buf items will not be released in xfs_buf_delwri_cancel(). If
> these buffers are submitted successfully, buf items assocated with
> the buffer will be released in io end process. So releasing buf item
> in write list cacneling process is needed.

Yes, that's why we use xfs_buf_delwri_submit() even on error - it
handles releasing the buffer log item in IO completion handling
(even on error).



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

I don't think this is a good idea - the delwri does not own the
buf log item reference, and so this will cause problems with
anything that already handles buf log item references correctly.

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
> 

-- 
Dave Chinner
david@fromorbit.com
