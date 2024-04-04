Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 908A913A86C
	for <linux-xfs@vger.kernel.org>; Thu,  4 Apr 2024 20:55:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712264125; cv=none; b=GMps05WGSlApF2GHplDWhHDOs3tfmj+ftoC/xtCrU3i4JXECTvAtI+K2VSkpweYvbK2C8tDSJHzGbXWWmZrZI2wckQq7J7L7yvrvFWiJ5X1zSMx31DVblRuyBGq4vsFwEIgdf3jczSzG8yHgW1TpaGYszrmFr+a4uFuAoN4OvoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712264125; c=relaxed/simple;
	bh=sorFsq488L7ajJS64yjM1MHZTqEJY1vLbzYYcHsFTeg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iZW2s0YzFomp/YYkdNf34K2UKqony6WpVdWPIsoihBhMJ0Kiu8CwYXA0UzPaHqq8sf56j4QPQVKMvXkY+hc1yaOk+tz8wNtH5XQTCbynzp9zanU/EDS9SPk7rJt6Rgaae0MOCtZiqWmG6WjW69Q89shtpY/8CPXF42iaDbsrZEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B229XrXj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B229XrXj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19543C433C7;
	Thu,  4 Apr 2024 20:55:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712264125;
	bh=sorFsq488L7ajJS64yjM1MHZTqEJY1vLbzYYcHsFTeg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=B229XrXjiz8+SbLmQIpAJxLVhiqNmIG5kcfOOTEXk14W3mFpqJ34ftUFDKei+kjKW
	 YzVZAzCrfWkAEvjpAK5XuvHWovZEYhr6+9s4y5fJZHoCfLbk66u96IDby2W4cMCjPg
	 buV2pdonv3AMZYq374sNIyd4Jp0OdioGEb9Zw22BYbCS44JhuBojT6USINABzduktZ
	 HWMS+OPWxth69CPzU7sxG4pvQaK9Me+hPs8gATVQuNhcUh5sMGJXdHpHOuagLGHNUD
	 sKlRxd9sylCnBuSb6neGHIjcSqXPhe2/CnS4aWc5OV2+LCEApy3Dtgnm/MEnIPJ/q0
	 1/LMvscSODF0A==
Date: Thu, 4 Apr 2024 13:55:24 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [bug report] xfs: repair free space btrees
Message-ID: <20240404205524.GG6414@frogsfrogsfrogs>
References: <4e8b2fc3-838a-458e-b306-2f8a0062ba76@moroto.mountain>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4e8b2fc3-838a-458e-b306-2f8a0062ba76@moroto.mountain>

On Thu, Apr 04, 2024 at 10:32:32AM +0300, Dan Carpenter wrote:
> Hello Darrick J. Wong,
> 
> Commit 4bdfd7d15747 ("xfs: repair free space btrees") from Dec 15,
> 2023 (linux-next), leads to the following Smatch static checker
> warning:
> 
> 	fs/xfs/scrub/alloc_repair.c:781 xrep_abt_build_new_trees()
> 	warn: missing unwind goto?
> 
> fs/xfs/scrub/alloc_repair.c
>     702 STATIC int
>     703 xrep_abt_build_new_trees(
>     704         struct xrep_abt                *ra)
>     705 {
>     706         struct xfs_scrub        *sc = ra->sc;
>     707         struct xfs_btree_cur        *bno_cur;
>     708         struct xfs_btree_cur        *cnt_cur;
>     709         struct xfs_perag        *pag = sc->sa.pag;
>     710         bool                        needs_resort = false;
>     711         int                        error;
>     712 
>     713         /*
>     714          * Sort the free extents by length so that we can set up the free space
>     715          * btrees in as few extents as possible.  This reduces the amount of
>     716          * deferred rmap / free work we have to do at the end.
>     717          */
>     718         error = xrep_cntbt_sort_records(ra, false);
>     719         if (error)
>     720                 return error;
>     721 
>     722         /*
>     723          * Prepare to construct the new btree by reserving disk space for the
>     724          * new btree and setting up all the accounting information we'll need
>     725          * to root the new btree while it's under construction and before we
>     726          * attach it to the AG header.
>     727          */
>     728         xrep_newbt_init_bare(&ra->new_bnobt, sc);
>     729         xrep_newbt_init_bare(&ra->new_cntbt, sc);
>     730 
>     731         ra->new_bnobt.bload.get_records = xrep_abt_get_records;
>     732         ra->new_cntbt.bload.get_records = xrep_abt_get_records;
>     733 
>     734         ra->new_bnobt.bload.claim_block = xrep_abt_claim_block;
>     735         ra->new_cntbt.bload.claim_block = xrep_abt_claim_block;
>     736 
>     737         /* Allocate cursors for the staged btrees. */
>     738         bno_cur = xfs_bnobt_init_cursor(sc->mp, NULL, NULL, pag);
>     739         xfs_btree_stage_afakeroot(bno_cur, &ra->new_bnobt.afake);
>     740 
>     741         cnt_cur = xfs_cntbt_init_cursor(sc->mp, NULL, NULL, pag);
>     742         xfs_btree_stage_afakeroot(cnt_cur, &ra->new_cntbt.afake);
>     743 
>     744         /* Last chance to abort before we start committing fixes. */
>     745         if (xchk_should_terminate(sc, &error))
>     746                 goto err_cur;
>     747 
>     748         /* Reserve the space we'll need for the new btrees. */
>     749         error = xrep_abt_reserve_space(ra, bno_cur, cnt_cur, &needs_resort);
>     750         if (error)
>     751                 goto err_cur;
>     752 
>     753         /*
>     754          * If we need to re-sort the free extents by length, do so so that we
>     755          * can put the records into the cntbt in the correct order.
>     756          */
>     757         if (needs_resort) {
>     758                 error = xrep_cntbt_sort_records(ra, needs_resort);
>     759                 if (error)
>     760                         goto err_cur;
>     761         }
>     762 
>     763         /*
>     764          * Due to btree slack factors, it's possible for a new btree to be one
>     765          * level taller than the old btree.  Update the alternate incore btree
>     766          * height so that we don't trip the verifiers when writing the new
>     767          * btree blocks to disk.
>     768          */
>     769         pag->pagf_repair_bno_level = ra->new_bnobt.bload.btree_height;
>     770         pag->pagf_repair_cnt_level = ra->new_cntbt.bload.btree_height;
>     771 
>     772         /* Load the free space by length tree. */
>     773         ra->array_cur = XFARRAY_CURSOR_INIT;
>     774         ra->longest = 0;
>     775         error = xfs_btree_bload(cnt_cur, &ra->new_cntbt.bload, ra);
>     776         if (error)
>     777                 goto err_levels;
>                         ^^^^^^^^^^^^^^^^
>     778 
>     779         error = xrep_bnobt_sort_records(ra);
>     780         if (error)
> --> 781                 return error;
>                         ^^^^^^^^^^^^^
> Should this be a goto err_levels?

Yep.  Thanks for the report.

--D

>     782 
>     783         /* Load the free space by block number tree. */
>     784         ra->array_cur = XFARRAY_CURSOR_INIT;
>     785         error = xfs_btree_bload(bno_cur, &ra->new_bnobt.bload, ra);
>     786         if (error)
>     787                 goto err_levels;
>     788 
>     789         /*
>     790          * Install the new btrees in the AG header.  After this point the old
>     791          * btrees are no longer accessible and the new trees are live.
>     792          */
>     793         xfs_allocbt_commit_staged_btree(bno_cur, sc->tp, sc->sa.agf_bp);
>     794         xfs_btree_del_cursor(bno_cur, 0);
>     795         xfs_allocbt_commit_staged_btree(cnt_cur, sc->tp, sc->sa.agf_bp);
>     796         xfs_btree_del_cursor(cnt_cur, 0);
>     797 
>     798         /* Reset the AGF counters now that we've changed the btree shape. */
>     799         error = xrep_abt_reset_counters(ra);
>     800         if (error)
>     801                 goto err_newbt;
>     802 
>     803         /* Dispose of any unused blocks and the accounting information. */
>     804         xrep_abt_dispose_reservations(ra, error);
>     805 
>     806         return xrep_roll_ag_trans(sc);
>     807 
>     808 err_levels:
>     809         pag->pagf_repair_bno_level = 0;
>     810         pag->pagf_repair_cnt_level = 0;
>     811 err_cur:
>     812         xfs_btree_del_cursor(cnt_cur, error);
>     813         xfs_btree_del_cursor(bno_cur, error);
>     814 err_newbt:
>     815         xrep_abt_dispose_reservations(ra, error);
>     816         return error;
>     817 }
> 
> regards,
> dan carpenter
