Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="SbKqNcKd"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37935A3
	for <linux-xfs@vger.kernel.org>; Thu, 30 Nov 2023 00:06:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=2m0QKjvmcnE5gIwP8GafGiXD/dFNm8y731ma4peJr9s=; b=SbKqNcKdgCVF8jGKki1qLTJbk8
	hwPrcnNa/4MGGtHw4QHUAGgpwX8tDfIO7x8EanYRBoldcKtdTfIjMRW7pBDfyH61px4l4A2qWq/gp
	avi4+oCt3r/3+NgnhBLlan0Xdk6jBgDLzwBWqAeXtNVDXEy48j9VxaeWZsDJrtPSXl6e3LzaG6CCR
	S1kH/plQ6oO9fkIwuLx/cNf1zm9O8dsJV8zDquaQIu+g7UmqNt2jp0jFfUEOmlLw3ao3IziUUlX0o
	MScWnRLPCgKIueXDdMf6YZNKTSBxG9egwCjvzIYzYlbsxXZHSIH3w28+1S61Ek52bECs9l+UFwh+C
	ILwOEwGA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1r8c3t-00AASh-0l;
	Thu, 30 Nov 2023 08:06:17 +0000
Date: Thu, 30 Nov 2023 00:06:17 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: leo.lilong@huawei.com, chandanbabu@kernel.org, hch@lst.de,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/7] xfs: recreate work items when recovering intent items
Message-ID: <ZWhCeQo17PdVgSRE@infradead.org>
References: <170120318847.13206.17051442307252477333.stgit@frogsfrogsfrogs>
 <170120321729.13206.3574213430456423200.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170120321729.13206.3574213430456423200.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

> +static inline void
> +xfs_defer_recover_work_item(
> +	struct xfs_defer_pending	*dfp,
> +	struct list_head		*work)
> +{
> +	list_add_tail(work, &dfp->dfp_work);
> +	dfp->dfp_count++;
> +}

The same (arguably trivial) logic is also duplicated in xfs_defer_add.
Maybe give the helper a more generic name and use it there as well?

> +	INIT_LIST_HEAD(&attr->xattri_list);

No need to initialize this (and all the other list_heads in the items)
as we're only adding them to the work list, but never actualy using them
as the head of a list or do list_empty checks on them.

> +	xfs_defer_recover_work_item(dfp, &bi->bi_list);

Does this commit on it's own actually work?  We add the items to
the work list, but I don't think we ever take it off without the next
patch?

> -	struct xfs_bmap_intent		fake = { };
>  	struct xfs_trans_res		resv;
>  	struct xfs_log_item		*lip = dfp->dfp_intent;
>  	struct xfs_bui_log_item		*buip = BUI_ITEM(lip);
> @@ -498,6 +520,7 @@ xfs_bui_item_recover(
>  	struct xfs_mount		*mp = lip->li_log->l_mp;
>  	struct xfs_map_extent		*map;
>  	struct xfs_bud_log_item		*budp;
> +	struct xfs_bmap_intent		*fake;

So this patch moves the intent structures off the stack, and the next
one then renames it to work.  Maybe do the renames here so that we don't
have to touch every single use of them twice?

Otherwise this looks nice, and I really like the better structure of
the recovery code that this is leading towards.

