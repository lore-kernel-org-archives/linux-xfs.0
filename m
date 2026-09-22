Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB9972AD03;
	Tue, 22 Sep 2026 15:02:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790089362; cv=none; b=MNK/lLZHpGIvntUX8uJS7U3jEyIYqDMWtXroHHlYDOF01KPJ4hnnSnKJKxkvjQ/Ny5jEZXKmXnDkcfFWIuckojD5dXHUyxmyiu4xNb72in8yfrTqbaJ4lC1h2CrkofP6Xid2RvY4G0JkFtDerr6/xB1um5wbRWB49xJq1QOLnPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790089362; c=relaxed/simple;
	bh=dkdmowZeLA68PqT4aiTaWrXQum02acntxxBhvRvX/1Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=m8Hk0ESGDDU2zKLm14kEc7BcvtAS68KLfGpigEBisWuU/REKGulQcMq5JVvk90RfpkEvBBmcXYVvxSTYhdxvVmh62+gknetN+Vbn8swlFlWxf9H3vK5w4dmyr5tD6jQ+46HNoAVN/hgRQ/tPRpL61aBngCntKNdwIKpDurutqoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NEMlG1kU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NEMlG1kU"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 894311F000FF;
	Tue, 22 Sep 2026 15:02:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790089360;
	bh=G1HtwqTKTxAAYspc1QgCb9R84JZgDhzw+6RQmEyd80U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=NEMlG1kUjWnqGhiHXoZMx3JEyFcuv5c8uxxT50mBnIBFmFm8lg5d9oApBUpkAe09A
	 UoQSsYWi9Jp6XxDNeob6QupZn5k4KS/AUoOMiiO4X/TfktVqFL5X8BkSDGwKfq+OyK
	 IVXnIs2bG82ykwSd7+z8s1e/1aaB/2fzwkhSgYC275HbEgPCLxGEp7UyKNgBMdwwsg
	 G5KONNs6XSjcDMqybT+FUHDflz6TX2Uek0sX1WZdxIWUOH4xurBzPJZbUxywYohpB8
	 I6wr/VSBhbhjeNcR8DNtkOhiZBSjssB/ADZuJCGnhIxo8r/W5gsTUDc8BL3UCEyJw2
	 uyTMRJ2bH6Fag==
Date: Tue, 22 Sep 2026 08:02:40 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: MingTao Huang <1037827920@qq.com>
Cc: Carlos Maiolino <cem@kernel.org>, Dave Chinner <dchinner@redhat.com>,
	Chandan Babu R <chandanbabu@kernel.org>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	MingTao Huang <mintaohuang@tencent.com>
Subject: Re: [PATCH] xfs: fix skipped flushing items not counted in
 xfsaild_push()
Message-ID: <20260922150240.GQ2705364@frogsfrogsfrogs>
References: <tencent_F801A9436DFB447AAFEC63D3E615B8052405@qq.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tencent_F801A9436DFB447AAFEC63D3E615B8052405@qq.com>

On Tue, Sep 22, 2026 at 04:14:29PM +0800, MingTao Huang wrote:
> From: MingTao Huang <mintaohuang@tencent.com>
> 
> Commit f3f7ae68a4ea ("xfs: skip flushing log items during push")
> introduced a fast path in xfsaild_push() that uses
> test_bit(XFS_LI_FLUSHING) to skip log items already being
> flushed.  However, the fast path jumps directly to the
> next_item label, bypassing flushing++, count++, and the
> ail_last_pushed_lsn update.  This causes three problems:
> 
> 1. The loop exit condition "count > 1000" becomes much harder to
>    trigger.  count was meant to track every item visited, but now it
>    only increments for non-flushing items that enter
>    xfsaild_push_item().  Each such item typically triggers an inode
>    cluster flush that marks dozens of neighbouring inodes as flushing,
>    so count effectively counts cluster flushes rather than individual
>    items.  The threshold shifts from 1000 items to ~1000 clusters,
>    letting the loop scan an order of magnitude more items per round.
>    Each cluster flush adds a buffer to ail_buf_list, and the resulting
>    oversized list causes xfs_buf_delwri_submit_nowait() -- which runs
>    list_sort() plus per-buffer trylock and IO submission -- to take so
>    long that the watchdog fires.
> 
> 2. The timeout decision "(stuck + flushing) * 100 / count > 90" is
>    computed without the fast-path flushing items, so the flushing ratio
>    is severely under-reported.  When most of the AIL is flushing, the
>    ratio appears near 0%.  xfsaild therefore selects
>    "tout = 0" when it should select "tout = 20" (20 ms
>    back-off to let IO complete).  The zero-backoff tight loop compounds
>    the ail_buf_list accumulation across rounds.
> 
> 3. ail_last_pushed_lsn is not advanced past flushing items, so the
>    next push round restarts scanning from the same position, repeatedly
>    traversing items that are still in-flight.
> 
> We hit this as a soft lockup during stress testing on an internal
> kernel that includes commit f3f7ae68a4ea ("xfs: skip flushing log
> items during push").  The xfsaild kthread was stuck for
> 22 seconds inside xfs_buf_delwri_submit_nowait(), called from
> xfsaild_push(), processing an excessively large ail_buf_list:
> 
>   watchdog: BUG: soft lockup - CPU#48 stuck for 22s! [xfsaild/dm-1:4931]
>   RIP: 0010:xfs_buf_delwri_submit_buffers+0xf2/0x250 [xfs]
>   Call Trace:
>    <TASK>
>    xfsaild_push+0x19b/0x7d0 [xfs]
>    xfsaild+0xb8/0x1a0 [xfs]
>    kthread+0xcc/0x100
>    ret_from_fork+0x5f/0xa0
>    ret_from_fork_asm+0x1b/0x30
>    </TASK>
>   Kernel panic - not syncing: softlockup: hung tasks
> 
> Fix this by accounting for flushing items in the fast path -- increment
> flushing and count, and update ail_last_pushed_lsn -- to match what the
> XFS_ITEM_FLUSHING case in xfsaild_push_item() already does.  This

Am I missing something?  xfsaild_push_item in 7.3-rc4 doesn't seem to
handle flushing.  Maybe you meant xfsaild_process_logitem?  In which
case bumping flushing/counted makes sense.  I /think/ bumping
ail_last_pushed_lsn makes sense too, but I want to think about that
more.

<confused>

--D

> ensures the loop exit condition, the timeout ratio, and the resume
> position all reflect the true state of the AIL.
> 
> Fixes: f3f7ae68a4ea ("xfs: skip flushing log items during push")
> Signed-off-by: MingTao Huang <mintaohuang@tencent.com>
> ---
>  fs/xfs/xfs_trans_ail.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
> index 99a9bf3762b7..0f72cd4e6983 100644
> --- a/fs/xfs/xfs_trans_ail.c
> +++ b/fs/xfs/xfs_trans_ail.c
> @@ -580,8 +580,12 @@ xfsaild_push(
>  	lsn = lip->li_lsn;
>  	while ((XFS_LSN_CMP(lip->li_lsn, ailp->ail_target) <= 0)) {
>  
> -		if (test_bit(XFS_LI_FLUSHING, &lip->li_flags))
> +		if (test_bit(XFS_LI_FLUSHING, &lip->li_flags)) {
> +			flushing++;
> +			count++;
> +			ailp->ail_last_pushed_lsn = lsn;
>  			goto next_item;
> +		}
>  
>  		xfsaild_process_logitem(ailp, lip, &stuck, &flushing);
>  		count++;
> -- 
> 2.43.7
> 
> 
