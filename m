Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E93033085D4
	for <linux-xfs@vger.kernel.org>; Thu, 19 Jun 2025 02:30:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750300263; cv=none; b=sQbgLWAXeQd3sKT82IOt9leJbzpXaszAH/XeXXFQo6Pkt1MoZcdkJ7gP7vS8LaGZql5jNsXR4GuJUjEOWIRRn7QFz7vi8uNpZ41i9F4L9epEoNs2RJYubQfJ0Vqc5RScbRSZFUXwUKPaCNOxUDop1WdukF6ZkZ5JJG+2D+iEdoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750300263; c=relaxed/simple;
	bh=UaAwpSqZ97E4o9XpN2ivmb3ocDTQkkTuge/oOJao+Wk=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bZOZGsuwNxdJYyT00QvC0QpHzAWwxYp1NsGrTMU3lMSf3dlCE0ndGrS8fWEKHYyaEVZMPs+Zsd3ZC+ERplij9dYoRW7uwNbkC+xBV8hhtndnyqaOzMj4FEbdXHmY85zY0zTmFUAqLdvIb1sKhGVWkckdiAeBIICSAR3WBHvJv7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4bN4Lb4cG5z2TSK0;
	Thu, 19 Jun 2025 10:29:27 +0800 (CST)
Received: from dggemv705-chm.china.huawei.com (unknown [10.3.19.32])
	by mail.maildlp.com (Postfix) with ESMTPS id D5D3F140159;
	Thu, 19 Jun 2025 10:30:56 +0800 (CST)
Received: from kwepemn100013.china.huawei.com (7.202.194.116) by
 dggemv705-chm.china.huawei.com (10.3.19.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 19 Jun 2025 10:30:56 +0800
Received: from localhost (10.175.112.188) by kwepemn100013.china.huawei.com
 (7.202.194.116) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 19 Jun
 2025 10:30:56 +0800
Date: Thu, 19 Jun 2025 10:17:27 +0800
From: Long Li <leo.lilong@huawei.com>
To: <djwong@kernel.org>, <cem@kernel.org>
CC: <linux-xfs@vger.kernel.org>, <david@fromorbit.com>, <yi.zhang@huawei.com>,
	<houtao1@huawei.com>, <yangerkun@huawei.com>, <lonuxli.64@gmail.com>
Subject: Re: [PATCH] xfs: fix incorrect tail lsn tracking when AIL is empty
Message-ID: <aFNzNxgPNvHj4J2O@localhost.localdomain>
References: <20250523063046.564170-1-leo.lilong@huawei.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20250523063046.564170-1-leo.lilong@huawei.com>
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemn100013.china.huawei.com (7.202.194.116)

On Fri, May 23, 2025 at 02:30:46PM +0800, Long Li wrote:

Friendly ping, hoping someone can give me some suggestions.

> When the AIL is empty, we track ail_head_lsn as the tail LSN, where
> ail_head_lsn records the commit LSN of Checkpoint N, the last checkpoint
> inserted into the AIL. There are two possible scenarios when the AIL is
> empty:
> 
> 1. Items from Checkpoint N were previously inserted into the AIL, have
>    been written back, and subsequently removed from the AIL.
> 2. Items from Checkpoint N have not yet been inserted into the AIL, but
>    the preparation for insertion is complete, and ail_head_lsn has already
>    been updated to Checkpoint N's commit LSN.
> 
> For scenario 1, the items in Checkpoint N have already been written to the
> metadata area. Even in the event of a crash, Checkpoint N does not require
> recovery, so forwarding the tail LSN to Checkpoint N's commit LSN is
> reasonable.
> 
> For scenario 2, the items in Checkpoint N have not been written to the
> metadata area. If new logs (ie., Checkpoint N+1) are flushed to disk with
> the tail LSN recorded as Checkpoint N's commit LSN, a crash would make it
> impossible to recover Checkpoint N.
> 
> Checkpoint N    start N       commit N
>                    +-------------+------------+--------------+
> Checkpoint N+1                           start N+1      commit N+1
> 
> Scenario 2 is possible. I encountered this issue in the Linux 6.6, where
> l_last_sync_lsn was used to track the tail LSN when the AIL is empty.
> Although the code has been refactored and I have not reproduced this issue
> in the latest mainline kernel, I believe the problem still exists.
> 
> In the function xlog_cil_ail_insert(), which inserts items from the ctx
> into the AIL, the update of ail_head_lsn and the actual insertion of items
> into the AIL are not atomic. This process is not protected by `ail_lock`
> or `log->l_icloglock`, leaving a window that could result in the iclog
> being filled with an incorrect tail LSN.
> 
> When the AIL is empty, the tail LSN should be set to Checkpoint N's start
> LSN before the items from Checkpoint N are inserted into the AIL. This
> ensures that Checkpoint N can be recovered in case of a crash. After the
> items from Checkpoint N are inserted into the AIL, the tail LSN tracked
> for an empty AIL can then be updated to Checkpoint N's commit LSN. This
> cannot be achieved with ail_head_lsn alone, so a new variable,
> ail_tail_lsn, is introduced specifically to track the tail LSN when the
> AIL is empty.
> 
> Fixes: 14e15f1bcd73 ("xfs: push the grant head when the log head moves forward") # further than this
> Signed-off-by: Long Li <leo.lilong@huawei.com>
> ---
>  fs/xfs/xfs_log_cil.c     | 2 ++
>  fs/xfs/xfs_log_recover.c | 3 +++
>  fs/xfs/xfs_trans_ail.c   | 2 +-
>  fs/xfs/xfs_trans_priv.h  | 1 +
>  4 files changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index f66d2d430e4f..ecc31329669a 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -775,6 +775,7 @@ xlog_cil_ail_insert(
>  	xfs_trans_ail_cursor_last(ailp, &cur, ctx->start_lsn);
>  	old_head = ailp->ail_head_lsn;
>  	ailp->ail_head_lsn = ctx->commit_lsn;
> +	ailp->ail_tail_lsn = ctx->start_lsn;
>  	/* xfs_ail_update_finish() drops the ail_lock */
>  	xfs_ail_update_finish(ailp, NULLCOMMITLSN);
>  
> @@ -857,6 +858,7 @@ xlog_cil_ail_insert(
>  
>  	spin_lock(&ailp->ail_lock);
>  	xfs_trans_ail_cursor_done(&cur);
> +	ailp->ail_tail_lsn = ctx->commit_lsn;
>  	spin_unlock(&ailp->ail_lock);
>  }
>  
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 2f76531842f8..ef04fd8ded67 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -1179,6 +1179,8 @@ xlog_check_unmount_rec(
>  					log->l_curr_cycle, after_umount_blk);
>  			log->l_ailp->ail_head_lsn =
>  					atomic64_read(&log->l_tail_lsn);
> +			log->l_ailp->ail_tail_lsn =
> +					atomic64_read(&log->l_tail_lsn);
>  			*tail_blk = after_umount_blk;
>  
>  			*clean = true;
> @@ -1212,6 +1214,7 @@ xlog_set_state(
>  	if (bump_cycle)
>  		log->l_curr_cycle++;
>  	atomic64_set(&log->l_tail_lsn, be64_to_cpu(rhead->h_tail_lsn));
> +	log->l_ailp->ail_tail_lsn = be64_to_cpu(rhead->h_lsn);
>  	log->l_ailp->ail_head_lsn = be64_to_cpu(rhead->h_lsn);
>  }
>  
> diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
> index 67c328d23e4a..bdd45aaa5bc1 100644
> --- a/fs/xfs/xfs_trans_ail.c
> +++ b/fs/xfs/xfs_trans_ail.c
> @@ -740,7 +740,7 @@ __xfs_ail_assign_tail_lsn(
>  
>  	tail_lsn = __xfs_ail_min_lsn(ailp);
>  	if (!tail_lsn)
> -		tail_lsn = ailp->ail_head_lsn;
> +		tail_lsn = ailp->ail_tail_lsn;
>  
>  	WRITE_ONCE(log->l_tail_space,
>  			xlog_lsn_sub(log, ailp->ail_head_lsn, tail_lsn));
> diff --git a/fs/xfs/xfs_trans_priv.h b/fs/xfs/xfs_trans_priv.h
> index f945f0450b16..4ed9ada298ec 100644
> --- a/fs/xfs/xfs_trans_priv.h
> +++ b/fs/xfs/xfs_trans_priv.h
> @@ -56,6 +56,7 @@ struct xfs_ail {
>  	spinlock_t		ail_lock;
>  	xfs_lsn_t		ail_last_pushed_lsn;
>  	xfs_lsn_t		ail_head_lsn;
> +	xfs_lsn_t		ail_tail_lsn;
>  	int			ail_log_flush;
>  	unsigned long		ail_opstate;
>  	struct list_head	ail_buf_list;
> -- 
> 2.39.2
> 
