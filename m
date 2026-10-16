Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C6954D90B7;
	Fri, 16 Oct 2026 15:24:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792164250; cv=none; b=WUJk4MnjPPJNfEcDDO0pAz0t0p3Tvk36wb0l1H38fWZ5kst1ZJhVq6Rov3qRsFNTk0w1s2pC3tYDVB6VR2ev67gjYUm11i/uDVelezgNpV9w5l6U88aW4/BvoYmClOKXoJrtEwCfcamUMJna+VHp/sSZg8IrX41dsxW6TEXvaZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792164250; c=relaxed/simple;
	bh=Bi0rmlr2VCh4BqFpxy+1NHKLg00aHu723jx9jbLOy7k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZaROnZ0uEcSHeAsTX/XBJIUXE7N+kJdO7cDEcbe4Keg4Excfmeyhk69aB2rd2TblIhbGrHokkiySLJc2WSI9EBBSjZ/tXr+r6h4y4zwqdqfwlBEA99r4kQJu+FiF3KAMhBMZ3r8e+H3DnbRoCp0LZ0V88bG5E51pX2sYAfR1ZD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i7RX/cHN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i7RX/cHN"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 522F21F000D1;
	Fri, 16 Oct 2026 15:24:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792164240;
	bh=vEyGGAOev4ZHb3gYLENJSmTq0EzpiKa82QT+HChfkKs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=i7RX/cHNlAiZGRqzqdZOXQJ+JUOkKpTFvV/L43Jme5qQSTWQGCDUQEPl0UTsLXtBp
	 +U7K9rBwH21FmLr9ZrAJxWXU8PtxLu9UK9yzVgSdlcVqWpfq4vhHfABnocvO4+twwy
	 aTxYTFirRRQ/UyQNRO1JlfQT8ERB/jMiSb0UwshgTBE7lqiwktZVi2MZvReRK266Ma
	 IFf7iVJQGF8cc7xdt49BACZvRAF6aPvvhkIgi3DATJD3+NeE84KeElxsO+NKWDqk/Q
	 M7XdNgCBG8UuOhw6l4L6xgQx8ZbiC3FqXkWt97AEFL8qewDNtdleivJu8Sw6cp7aVY
	 0qM4+0quqFZAQ==
Date: Fri, 16 Oct 2026 08:23:59 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: vienna-0FFH <viennaoffh@gmail.com>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org,
	syzbot+e7f24354da9f7915bc54@syzkaller.appspotmail.com
Subject: Re: [PATCH] xfs: fix slab-use-after-free in xrep_newbt_free()
Message-ID: <20261016152359.GA107986@frogsfrogsfrogs>
References: <20261016085536.591-1-viennaoffh@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261016085536.591-1-viennaoffh@gmail.com>

On Fri, Oct 16, 2026 at 04:55:36PM +0800, vienna-0FFH wrote:
> syzbot reported a slab-use-after-free read in xfs_defer_item_unpause()
> while online repair was rebuilding a bmap btree:
> 
>   BUG: KASAN: slab-use-after-free in xfs_defer_item_unpause+0x116/0x250
>   Read of size 4 at addr ffff8880132c127c by task syz.0.0/5327
>   Call Trace:
>    xfs_defer_item_unpause
>    xrep_newbt_free+0x3fe/0x5f0
>    xrep_bmap_build_new_fork+0x5a9/0x740
>    xrep_bmap
>    xrep_attempt
>    xfs_scrub_metadata
> 
> The buggy address belongs to the object at ffff8880132c1240,
> which belongs to the cache xfs_defer_pending of size 64.
> 
> xrep_newbt_add_blocks() attaches a paused EFI to the repair transaction
> for each space reservation so that the blocks are reclaimed if the
> system goes down before the new btree is committed.  If a later
> xrep_defer_finish() fails (e.g. metadata I/O errors while staging the
> new btree), xfs_defer_finish_noroll() shuts the filesystem down and
> xfs_defer_cancel_list() frees all pending deferred work items, which
> includes the paused EFIs referenced by resv->autoreap.
> 
> The repair then unwinds through xrep_newbt_cancel() -> xrep_newbt_free().
> That function notices the shutdown and jumps to the junkit label, which
> calls xfs_alloc_commit_autoreap() for each leftover reservation.  That
> unpauses the deferred item through the stale pointer, causing the
> use-after-free.  The report confirms this: the object was allocated by
> xfs_alloc_schedule_autoreap() from xrep_newbt_add_blocks(), and freed
> by xfs_defer_cancel_list() from the failing xrep_defer_finish().
> 
> Beyond the use-after-free, unpausing the deferred item is pointless
> once the filesystem has been shut down: the remaining deferred work
> will be cancelled when the repair transaction is torn down, and any
> EFI that was committed to the log before the failure is replayed by
> log recovery on the next mount.
> 
> Fix this by only unpausing the autoreap when the filesystem is not shut
> down.
> 
> Fixes: 6bb9ea8ecd2c ("xfs: log EFIs for all btree blocks being used to stage a btree")
> Reported-by: syzbot+e7f24354da9f7915bc54@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=e7f24354da9f7915bc54
> Cc: stable@vger.kernel.org
> Signed-off-by: vienna-0FFH <viennaoffh@gmail.com>
> ---
>  fs/xfs/scrub/newbt.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/scrub/newbt.c b/fs/xfs/scrub/newbt.c
> index 584076b..83558fd 100644
> --- a/fs/xfs/scrub/newbt.c
> +++ b/fs/xfs/scrub/newbt.c
> @@ -516,10 +516,15 @@ junkit:
>  	/*
>  	 * If we still have reservations attached to @newbt, cleanup must have
>  	 * failed and the filesystem is about to go down.  Clean up the incore
> -	 * reservations and try to commit to freeing the space we used.
> +	 * reservations.  If the filesystem is already shut down, leave the
> +	 * autoreaps alone: a failed deferred finish has freed the pending
> +	 * work items they point to, and nothing will ever finish deferred
> +	 * work on a dead filesystem.  Any EFI that made it to the log is
> +	 * replayed by log recovery.
>  	 */
>  	list_for_each_entry_safe(resv, n, &xnr->resv_list, list) {
> -		xfs_alloc_commit_autoreap(sc->tp, &resv->autoreap);
> +		if (!xfs_is_shutdown(sc->mp))

What if some other thread initiates the shutdown?

--D

> +			xfs_alloc_commit_autoreap(sc->tp, &resv->autoreap);
>  		list_del(&resv->list);
>  		xfs_perag_put(resv->pag);
>  		kfree(resv);
> -- 
> 2.43.0
> 
> 
