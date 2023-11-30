Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75D4E55C1E
	for <linux-xfs@vger.kernel.org>; Thu, 30 Nov 2023 17:14:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EvmNXjhC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB3E8C433C8;
	Thu, 30 Nov 2023 17:14:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701364495;
	bh=6KQTaO/uZsMw3cYcxVxA91D8Cb/lX2uKXrSexh5DAoo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EvmNXjhCQCHCUDY1aH7KjGBoM0kioYsfutGyJGu+TUITI0HNHfBCP/vcE0anDareW
	 5SI9Rz/i5R5q/ATjU+z8bO//C1QqEG5T468hmmOHYbHJX90iKDtJQ1d/oRYwwShKks
	 HE9cWUGP4AWIrfBywPpqvrjpzQb8mbnPgo1r3TvE0brZ10iQd2kX4YZW4x+4FQqn9+
	 JICyOdYHJogTNVbdihMXZ1nYiWA4QXo9Z0zh/8Y73V0oKjob/13HpyjP1Y2oG30adS
	 NDdTev4YL2kntZ2ZLcRlFADSdgG+cwu/ilgTzvMgrO/SwebvtQ4W0csQ+MwSXT4zyA
	 j7mWdKpw3AOgw==
Date: Thu, 30 Nov 2023 09:14:55 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: leo.lilong@huawei.com, chandanbabu@kernel.org, hch@lst.de,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/7] xfs: use xfs_defer_pending objects to recover intent
 items
Message-ID: <20231130171455.GI361584@frogsfrogsfrogs>
References: <170120318847.13206.17051442307252477333.stgit@frogsfrogsfrogs>
 <170120320014.13206.3481074226973016591.stgit@frogsfrogsfrogs>
 <ZWg/eyy9RUz2nliq@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZWg/eyy9RUz2nliq@infradead.org>

On Wed, Nov 29, 2023 at 11:53:31PM -0800, Christoph Hellwig wrote:
> > +/* Create a pending deferred work item for use with log recovery. */
> > +struct xfs_defer_pending *
> > +xfs_defer_start_recovery(
> > +	struct xfs_log_item		*lip,
> > +	enum xfs_defer_ops_type		dfp_type)
> > +{
> > +	struct xfs_defer_pending	*dfp;
> > +
> > +	dfp = kmem_cache_zalloc(xfs_defer_pending_cache,
> > +			GFP_NOFS | __GFP_NOFAIL);
> > +	dfp->dfp_type = dfp_type;
> > +	dfp->dfp_intent = lip;
> > +	INIT_LIST_HEAD(&dfp->dfp_work);
> > +	INIT_LIST_HEAD(&dfp->dfp_list);
> > +	return dfp;
> > +}
> 
> Initializing dfp_list here is a bit pointless as the caller instantly
> adds it to log->l_dfops.

I'd rather pass the list_head into xfs_defer_start_recovery so that it
can create a fully initialized dfp and add it to the tracker.

> > -#if defined(DEBUG) || defined(XFS_WARN)
> > +	spin_lock(&log->l_ailp->ail_lock);
> >  	last_lsn = xlog_assign_lsn(log->l_curr_cycle, log->l_curr_block);
> > +	spin_unlock(&log->l_ailp->ail_lock);
> 
> ail_lock shouldn't be needed here.

Oh, right, the AIL lock was to protect the cursor, not the debug
statements.

> Otherwise this looks reasonable to me.

<nod>

--D
