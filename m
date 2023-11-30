Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="LQzSYkGS"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8525410D4
	for <linux-xfs@vger.kernel.org>; Wed, 29 Nov 2023 23:53:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=0mdUl44heWm6470dflqQ/J81tvDzOpFXK7luepzXj4I=; b=LQzSYkGSN5vts6Z74neFoXPSAQ
	NKu9qfZUnnVQuKh4FzxnPyI3jDSc6GkGkHcTeJpy5aq+8gGtnYetVaUXmx/u/oIG9OSjHby8hkAP4
	jYYHBg5O54EAWgkhnV6ZgMHsf8P5iJIZyMFW87qWls/Xupie+N+yWqqpuLC7PlL22Oy+HQhKfIAJ5
	gljcVWYYiX8f3k9jylt2/S7Q7FsFt1Ba1zj/HVcYFvSFOFKkB/gGSChLeaJCeQr5nc47msJudHgA/
	HT3NR5WQoWfoz/K5hLfJnmRpcyjF7hlo68Biyzk0tra9sx1PNphTR7TQ9nTWRImKCDqwA9iFOEpq+
	LghrYCdQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1r8brX-00A8oc-2n;
	Thu, 30 Nov 2023 07:53:31 +0000
Date: Wed, 29 Nov 2023 23:53:31 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: leo.lilong@huawei.com, chandanbabu@kernel.org, hch@lst.de,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/7] xfs: use xfs_defer_pending objects to recover intent
 items
Message-ID: <ZWg/eyy9RUz2nliq@infradead.org>
References: <170120318847.13206.17051442307252477333.stgit@frogsfrogsfrogs>
 <170120320014.13206.3481074226973016591.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170120320014.13206.3481074226973016591.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

> +/* Create a pending deferred work item for use with log recovery. */
> +struct xfs_defer_pending *
> +xfs_defer_start_recovery(
> +	struct xfs_log_item		*lip,
> +	enum xfs_defer_ops_type		dfp_type)
> +{
> +	struct xfs_defer_pending	*dfp;
> +
> +	dfp = kmem_cache_zalloc(xfs_defer_pending_cache,
> +			GFP_NOFS | __GFP_NOFAIL);
> +	dfp->dfp_type = dfp_type;
> +	dfp->dfp_intent = lip;
> +	INIT_LIST_HEAD(&dfp->dfp_work);
> +	INIT_LIST_HEAD(&dfp->dfp_list);
> +	return dfp;
> +}

Initializing dfp_list here is a bit pointless as the caller instantly
adds it to log->l_dfops.

> -#if defined(DEBUG) || defined(XFS_WARN)
> +	spin_lock(&log->l_ailp->ail_lock);
>  	last_lsn = xlog_assign_lsn(log->l_curr_cycle, log->l_curr_block);
> +	spin_unlock(&log->l_ailp->ail_lock);

ail_lock shouldn't be needed here.

Otherwise this looks reasonable to me.
