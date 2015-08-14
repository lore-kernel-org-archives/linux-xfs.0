Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id CF8967F47
	for <xfs@oss.sgi.com>; Fri, 14 Aug 2015 06:14:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 7617BAC001
	for <xfs@oss.sgi.com>; Fri, 14 Aug 2015 04:14:17 -0700 (PDT)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) by cuda.sgi.com with
	ESMTP id 5u1zawlpnzbFjl3J (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 14 Aug 2015 04:14:15 -0700 (PDT)
Date: Fri, 14 Aug 2015 13:14:09 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH block/for-linus] writeback: fix syncing of I_DIRTY_TIME
	inodes
Message-ID: <20150814111408.GB8710@quack.suse.cz>
References: <20150812101204.GE17933@dhcp-13-216.nay.redhat.com>
	<20150813004435.GN3902@dastard>
	<20150813224415.GG4496@mtj.duckdns.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150813224415.GG4496@mtj.duckdns.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Eryu Guan <eguan@redhat.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, axboe@fb.com, Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org, kernel-team@fb.com

  Hello,

On Thu 13-08-15 18:44:15, Tejun Heo wrote:
> e79729123f63 ("writeback: don't issue wb_writeback_work if clean")
> updated writeback path to avoid kicking writeback work items if there
> are no inodes to be written out; unfortunately, the avoidance logic
> was too aggressive and made sync_inodes_sb() skip I_DIRTY_TIME inodes.
> This patch fixes the breakage by
> 
> * Removing bdi_has_dirty_io() shortcut from bdi_split_work_to_wbs().
>   The callers are already testing the condition.
> 
> * Removing bdi_has_dirty_io() shortcut from sync_inodes_sb() so that
>   it always calls into bdi_split_work_to_wbs().
> 
> * Making bdi_split_work_to_wbs() consider the b_dirty_time list for
>   WB_SYNC_ALL writebacks.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Fixes: e79729123f63 ("writeback: don't issue wb_writeback_work if clean")
> Cc: Ted Ts'o <tytso@google.com>
> Cc: Jan Kara <jack@suse.com>

So the patch looks good to me. But the fact that is fixes Eryu's problem
means there is something fishy going on. Either inodes get wrongly attached
to b_dirty_time list or bdi_has_dirty_io() somehow misbehaves only
temporarily and we don't catch it with the debug patch.

Can we add a test to wb_has_dirty_io() to also check whether it matches
bdi_has_dirty_io()? Since Eryu doesn't use lazytime (I assume, Eryu, please
speak up if you do), we could also warn if b_dirty_time lists get
non-empty. Hmm?

								Honza

> ---
> Hello,
> 
> So, this fixes I_DIRTY_TIME syncing problem for ext4 but AFAICS xfs
> doesn't even use the generic inode metadata writeback path, so this
> most likely won't do anything for the originally reported problem.
> I'll post another patch for debugging.
> 
> Thanks.
> 
>  fs/fs-writeback.c |   18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
> 
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -844,14 +844,15 @@ static void bdi_split_work_to_wbs(struct
>  	struct wb_iter iter;
>  
>  	might_sleep();
> -
> -	if (!bdi_has_dirty_io(bdi))
> -		return;
>  restart:
>  	rcu_read_lock();
>  	bdi_for_each_wb(wb, bdi, &iter, next_blkcg_id) {
> -		if (!wb_has_dirty_io(wb) ||
> -		    (skip_if_busy && writeback_in_progress(wb)))
> +		/* SYNC_ALL writes out I_DIRTY_TIME too */
> +		if (!wb_has_dirty_io(wb) &&
> +		    (base_work->sync_mode == WB_SYNC_NONE ||
> +		     list_empty(&wb->b_dirty_time)))
> +			continue;
> +		if (skip_if_busy && writeback_in_progress(wb))
>  			continue;
>  
>  		base_work->nr_pages = wb_split_bdi_pages(wb, nr_pages);
> @@ -899,8 +900,7 @@ static void bdi_split_work_to_wbs(struct
>  {
>  	might_sleep();
>  
> -	if (bdi_has_dirty_io(bdi) &&
> -	    (!skip_if_busy || !writeback_in_progress(&bdi->wb))) {
> +	if (!skip_if_busy || !writeback_in_progress(&bdi->wb)) {
>  		base_work->auto_free = 0;
>  		base_work->single_wait = 0;
>  		base_work->single_done = 0;
> @@ -2275,8 +2275,8 @@ void sync_inodes_sb(struct super_block *
>  	};
>  	struct backing_dev_info *bdi = sb->s_bdi;
>  
> -	/* Nothing to do? */
> -	if (!bdi_has_dirty_io(bdi) || bdi == &noop_backing_dev_info)
> +	/* bdi_has_dirty() ignores I_DIRTY_TIME but we can't, always kick wbs */
> +	if (bdi == &noop_backing_dev_info)
>  		return;
>  	WARN_ON(!rwsem_is_locked(&sb->s_umount));
>  
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
