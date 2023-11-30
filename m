Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F35FD55C34
	for <linux-xfs@vger.kernel.org>; Thu, 30 Nov 2023 17:36:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MvTU1zFA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ACE3C433C8;
	Thu, 30 Nov 2023 17:36:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701365781;
	bh=000KqNfkIqhsj3zdXgfs/t3nmpMo6QuwbF98Q8Zk0Mc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MvTU1zFA8+r44GIFWJ/+MkBD1+xV85/6aqR8x4vFXqbsJaMrQhGvjMQkq42c4NxDS
	 TW3choeFzeOf4QkQp1h0GBhneGjlr+DNoFk5W5dOgwWiZ3gz3Ukb+0Z6DWj6quvvto
	 fb15m855RiYJS6KVD59mU2Ojda86OUPysvMK1+YVO8qdSo2vZCL8WBC7+gRNuu3HsV
	 KkicUMASsU+UjzbJeUupisLve0cy7y+fRKKvyS6QCzDoNNKQFC7WMBn8PP4LhNLcUM
	 crvpbzqX8YoT8I9WMpbLg/32adTgMx8A7hOloJl9oVgqPn+70aYVeKXtzptjJXOiA5
	 I6RQHnmLJMXfg==
Date: Thu, 30 Nov 2023 09:36:20 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: leo.lilong@huawei.com, chandanbabu@kernel.org, hch@lst.de,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/7] xfs: recreate work items when recovering intent items
Message-ID: <20231130173620.GK361584@frogsfrogsfrogs>
References: <170120318847.13206.17051442307252477333.stgit@frogsfrogsfrogs>
 <170120321729.13206.3574213430456423200.stgit@frogsfrogsfrogs>
 <ZWhCeQo17PdVgSRE@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZWhCeQo17PdVgSRE@infradead.org>

On Thu, Nov 30, 2023 at 12:06:17AM -0800, Christoph Hellwig wrote:
> > +static inline void
> > +xfs_defer_recover_work_item(
> > +	struct xfs_defer_pending	*dfp,
> > +	struct list_head		*work)
> > +{
> > +	list_add_tail(work, &dfp->dfp_work);
> > +	dfp->dfp_count++;
> > +}
> 
> The same (arguably trivial) logic is also duplicated in xfs_defer_add.
> Maybe give the helper a more generic name and use it there as well?

Done.

> > +	INIT_LIST_HEAD(&attr->xattri_list);
> 
> No need to initialize this (and all the other list_heads in the items)
> as we're only adding them to the work list, but never actualy using them
> as the head of a list or do list_empty checks on them.

Ah, right, list_add_tail doesn't care about the current contents of
new->{next,prev}.  Fixed.

> > +	xfs_defer_recover_work_item(dfp, &bi->bi_list);
> 
> Does this commit on it's own actually work?  We add the items to
> the work list, but I don't think we ever take it off without the next
> patch?

Oops, I think "xfs: use xfs_defer_pending objects to recover intent
items" leaks the dfp in the success case.  After the loop in
xlog_recover_process_intents sets dfp->dfp_intent = NULL, it ought to be
calling xfs_defer_cancel_recovery to free the dfp_work items and the dfp
itself.

> > -	struct xfs_bmap_intent		fake = { };
> >  	struct xfs_trans_res		resv;
> >  	struct xfs_log_item		*lip = dfp->dfp_intent;
> >  	struct xfs_bui_log_item		*buip = BUI_ITEM(lip);
> > @@ -498,6 +520,7 @@ xfs_bui_item_recover(
> >  	struct xfs_mount		*mp = lip->li_log->l_mp;
> >  	struct xfs_map_extent		*map;
> >  	struct xfs_bud_log_item		*budp;
> > +	struct xfs_bmap_intent		*fake;
> 
> So this patch moves the intent structures off the stack, and the next
> one then renames it to work.  Maybe do the renames here so that we don't
> have to touch every single use of them twice?

The next patch removes those variables altogether, so I'll remove the
fake -> work rename entirely.

> Otherwise this looks nice, and I really like the better structure of
> the recovery code that this is leading towards.

Oh good!

--D
