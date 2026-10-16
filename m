Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5B8146D544;
	Fri, 16 Oct 2026 13:17:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792156661; cv=none; b=J7GfOuMedHcKUUGSBpxGR5CmeDh+p5hca0Gs6z9CXiPRmJ9z5QXwBEkz3GvUq8bp4O+wwuwumW9AfJL40zGYZqSrGTqxSm8GOrw2eO4DE4m1vBzgqGPcXIDW8b8Tt24SK/vk8yChMvUpo5zFOkokWWnIyqtgy64/sgls2ytiffY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792156661; c=relaxed/simple;
	bh=LghpJlqgje1ikJ4RFXppVdUHfr61B8+UteErcEp18gc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nBbccSQAnZaQh18GNFUTMdGM/1FW+YNaO+w5RjmecZ6wT752YjzYGyw01pcrlDCv/K6zsFdkMUHJ/m87ojXa9Tv4v7drp+nzfgKDR/UjLM3urTKZZoc4CI4YJYPQwzMGMAydfMDIbMuOMJnPHRUmmBDRuoLhSyHU+X/8obYJyK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gP3Mxvon; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gP3Mxvon"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D2541F000C4;
	Fri, 16 Oct 2026 13:17:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792156660;
	bh=XBpZBUCdIQck+e7XlkaERd7QLLf8bgSjy7oFp7WfFf0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gP3Mxvon1yqiZXzu+C9K8iuNUO4eI4QWh4SGQ8MOUVhm6mEIdGtEkbmiHVPTiZVYF
	 zbJryGJobqygeMqkLCasnplqIc9MrUPAD2ddi1frsU+egxtEXV+Qkiy6bmKeDgdGIY
	 Bvr6ranOjEyu4lDNLrw81qc4eaBF2b9EZgoBkwezwGWd8ISRWaE/RDPXDoxQ3a+sqD
	 RHM+c8St4/m/AGowxu9+AN0Kdh1BJ8+8lLSM4ZQfhUAbaAS3VDNTBqZRn06YVrTuiJ
	 G2QNsDEICQRlTXeECo55ZsOFfk1T1tLQo4JLEHDJGNujTFSllAgkAVf3Ctr9Ntn91i
	 ki5PJsRDjQNbg==
Date: Fri, 16 Oct 2026 15:17:35 +0200
From: Carlos Maiolino <cem@kernel.org>
To: vienna-0FFH <viennaoffh@gmail.com>
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org, syzbot+e7f24354da9f7915bc54@syzkaller.appspotmail.com
Subject: Re: [PATCH] xfs: fix slab-use-after-free in xrep_newbt_free()
Message-ID: <atIj2DeA3TOMJQ2-@cronus.toxiclabs.cc>
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

From Documentation/process/submitting-patches.rst:

"using a known identity (sorry, no anonymous contributions.)"

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
> +			xfs_alloc_commit_autoreap(sc->tp, &resv->autoreap);
>  		list_del(&resv->list);
>  		xfs_perag_put(resv->pag);
>  		kfree(resv);
> -- 
> 2.43.0
> 
> 
