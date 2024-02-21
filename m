Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0023A35
	for <linux-xfs@vger.kernel.org>; Wed, 21 Feb 2024 23:25:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708557937; cv=none; b=drsdB7tJ78KDtPd90PZ6DOMEHASGYRnhN/XjvhsPabxehqBi4IRtYJZ1Tagcb9kKGLv3a00DIQ6b6tXTQOIlKBNy/BeSQswZQ0THAknA7dT7qXQi0XQbjAlBgSjqvuFUC4hk5R7svEjMPj2ba8jZZYwFYlXi9VRESYXS7KZ+BMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708557937; c=relaxed/simple;
	bh=Ie33knH8NwTO0T+si9jgJ5h5Igx8RnfmsGGfm36Mu8s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uKf00PQkJpDZ1eLz9u4UEnCL8zr+E5ppORt/K9WWAfmJlWtfoF7AJykqcOnMcFDeRuKIar8wOWkuhrJNDMNmpCAXFGlc4WvdZVwWLtBgpK54a/0fnh/JY6k3ihefrb0YStTSyfNU2pGve8MuyBMNEMD4CZbbxNaL4KBTcWsLrtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lCt7CHoV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lCt7CHoV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CD17C433C7;
	Wed, 21 Feb 2024 23:25:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708557937;
	bh=Ie33knH8NwTO0T+si9jgJ5h5Igx8RnfmsGGfm36Mu8s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lCt7CHoVHngSRmTk5ppgTDo/fZTmVUJEgkhqVxYf9uKkfPmPAq3ceHsQxTML3MThc
	 smldltPL/TVul64F7JOKR9/S5Lw5uOEyUmxp8Dz7Z8KTejP8yV6IuAiS1yOD+0FMla
	 niAUzWUjJ1E06f1mtACi66PHkUW0v/Wkcv4t1tV84EL/VxOVTo4VZeb9bdFIvPuhh6
	 /0ZlMGEduMlHUT5ZTIcITSXUs/3+1mqCpZYil/RRl6zPFglGM5NudzKAEv/ASY5csx
	 ViJ9NUeSuzPuqypDiYNUymJipuEmMzXgF4jyYHbvJZsdkOa9670sJJasHiHiKNuRM0
	 jwQBPjJPxX9WQ==
Date: Wed, 21 Feb 2024 15:25:36 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, chandan.babu@oracle.com
Subject: Re: [PATCH] xfs: don't use current->journal_info
Message-ID: <20240221232536.GH616564@frogsfrogsfrogs>
References: <20240221224723.112913-1-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240221224723.112913-1-david@fromorbit.com>

On Thu, Feb 22, 2024 at 09:47:23AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> syzbot reported an ext4 panic during a page fault where found a
> journal handle when it didn't expect to find one. The structure
> it tripped over had a value of 'TRAN' in the first entry in the
> structure, and that indicates it tripped over a struct xfs_trans
> instead of a jbd2 handle.
> 
> The reason for this is that the page fault was taken during a
> copy-out to a user buffer from an xfs bulkstat operation. XFS uses
> an "empty" transaction context for bulkstat to do automated metadata
> buffer cleanup, and so the transaction context is valid across the
> copyout of the bulkstat info into the user buffer.
> 
> We are using empty transaction contexts like this in XFS in more
> places to reduce the risk of failing to release objects we reference
> during the operation, especially during error handling. Hence we
> really need to ensure that we can take page faults from these
> contexts without leaving landmines for the code processing the page
> fault to trip over.
> 
> We really only use current->journal_info for a single warning check
> in xfs_vm_writepages() to ensure we aren't doing writeback from a
> transaction context. Writeback might need to do allocation, so it
> can need to run transactions itself. Hence it's a debug check to
> warn us that we've done something silly, and largely it is not all
> that useful.
> 
> So let's just remove all the use of current->journal_info in XFS and
> get rid of all the potential issues from nested contexts where
> current->journal_info might get misused by another filesytsem
> context.

I wonder if this is too much, though?

Conceptually, I'd rather we set current->journal_info to some random
number whenever we start a !NO_WRITECOUNT (aka a non-empty) transaction
and clear it during transaction commit/cancel.  That way, *we* can catch
the case where some other filesystem starts a transaction and
accidentally bounces into an updating write fault inside XFS.

That might be outweighed by the weird semantics of ext4 where the
zeroness of journal_info changes its behavior in ways I don't want to
understand.  Thoughts?

--D

> Reported-by: syzbot+cdee56dbcdf0096ef605@syzkaller.appspotmail.com
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/scrub/common.c | 4 +---
>  fs/xfs/xfs_aops.c     | 7 -------
>  fs/xfs/xfs_icache.c   | 8 +++++---
>  fs/xfs/xfs_trans.h    | 9 +--------
>  4 files changed, 7 insertions(+), 21 deletions(-)
> 
> diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
> index 81f2b96bb5a7..d853348a48c8 100644
> --- a/fs/xfs/scrub/common.c
> +++ b/fs/xfs/scrub/common.c
> @@ -1000,9 +1000,7 @@ xchk_irele(
>  	struct xfs_scrub	*sc,
>  	struct xfs_inode	*ip)
>  {
> -	if (current->journal_info != NULL) {
> -		ASSERT(current->journal_info == sc->tp);
> -
> +	if (sc->tp) {
>  		/*
>  		 * If we are in a transaction, we /cannot/ drop the inode
>  		 * ourselves, because the VFS will trigger writeback, which
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index 813f85156b0c..bc3b649d29c4 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -502,13 +502,6 @@ xfs_vm_writepages(
>  {
>  	struct xfs_writepage_ctx wpc = { };
>  
> -	/*
> -	 * Writing back data in a transaction context can result in recursive
> -	 * transactions. This is bad, so issue a warning and get out of here.
> -	 */
> -	if (WARN_ON_ONCE(current->journal_info))
> -		return 0;
> -
>  	xfs_iflags_clear(XFS_I(mapping->host), XFS_ITRUNCATED);
>  	return iomap_writepages(mapping, wbc, &wpc.ctx, &xfs_writeback_ops);
>  }
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index 06046827b5fe..9b966af7d55c 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -2030,8 +2030,10 @@ xfs_inodegc_want_queue_work(
>   *  - Memory shrinkers queued the inactivation worker and it hasn't finished.
>   *  - The queue depth exceeds the maximum allowable percpu backlog.
>   *
> - * Note: If the current thread is running a transaction, we don't ever want to
> - * wait for other transactions because that could introduce a deadlock.
> + * Note: If we are in a NOFS context here (e.g. current thread is running a
> + * transaction) the we don't want to block here as inodegc progress may require
> + * filesystem resources we hold to make progress and that could result in a
> + * deadlock. Hence we skip out of here if we are in a scoped NOFS context.
>   */
>  static inline bool
>  xfs_inodegc_want_flush_work(
> @@ -2039,7 +2041,7 @@ xfs_inodegc_want_flush_work(
>  	unsigned int		items,
>  	unsigned int		shrinker_hits)
>  {
> -	if (current->journal_info)
> +	if (current->flags & PF_MEMALLOC_NOFS)
>  		return false;
>  
>  	if (shrinker_hits > 0)
> diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
> index c6d0795085a3..2bd673715ace 100644
> --- a/fs/xfs/xfs_trans.h
> +++ b/fs/xfs/xfs_trans.h
> @@ -269,19 +269,14 @@ static inline void
>  xfs_trans_set_context(
>  	struct xfs_trans	*tp)
>  {
> -	ASSERT(current->journal_info == NULL);
>  	tp->t_pflags = memalloc_nofs_save();
> -	current->journal_info = tp;
>  }
>  
>  static inline void
>  xfs_trans_clear_context(
>  	struct xfs_trans	*tp)
>  {
> -	if (current->journal_info == tp) {
> -		memalloc_nofs_restore(tp->t_pflags);
> -		current->journal_info = NULL;
> -	}
> +	memalloc_nofs_restore(tp->t_pflags);
>  }
>  
>  static inline void
> @@ -289,10 +284,8 @@ xfs_trans_switch_context(
>  	struct xfs_trans	*old_tp,
>  	struct xfs_trans	*new_tp)
>  {
> -	ASSERT(current->journal_info == old_tp);
>  	new_tp->t_pflags = old_tp->t_pflags;
>  	old_tp->t_pflags = 0;
> -	current->journal_info = new_tp;
>  }
>  
>  #endif	/* __XFS_TRANS_H__ */
> -- 
> 2.43.0
> 
> 
