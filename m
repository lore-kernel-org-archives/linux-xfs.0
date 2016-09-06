Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4F6F47CA1
	for <xfs@oss.sgi.com>; Tue,  6 Sep 2016 10:21:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0A23A304043
	for <xfs@oss.sgi.com>; Tue,  6 Sep 2016 08:21:57 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id 6EbqFz4BKcoTUw8p (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 06 Sep 2016 08:21:56 -0700 (PDT)
Date: Tue, 6 Sep 2016 08:21:55 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 16/71] xfs: log refcount intent items
Message-ID: <20160906152155.GJ24287@infradead.org>
References: <147216791538.867.12413509832420924168.stgit@birch.djwong.org>
	<147216802075.867.12945255918683675311.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <147216802075.867.12945255918683675311.stgit@birch.djwong.org>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, xfs@oss.sgi.com

> +	__uint64_t			cui_id;
> +	struct xfs_ail_cursor		cur;
> +	struct xfs_ail			*ailp = log->l_ailp;
> +
> +	cud_formatp = item->ri_buf[0].i_addr;
> +	ASSERT(item->ri_buf[0].i_len == sizeof(struct xfs_cud_log_format));

Should we return -EFSCORRUPTED here instead?

> +	/* XXX: do nothing for now */

What else would be do in the future here?

> +static void
> +xfs_trans_set_refcount_flags(
> +	struct xfs_phys_extent		*refc,
> +	enum xfs_refcount_intent_type	type)
> +{
> +	refc->pe_flags = 0;
> +	switch (type) {
> +	case XFS_REFCOUNT_INCREASE:
> +		refc->pe_flags |= XFS_REFCOUNT_EXTENT_INCREASE;
> +		break;
> +	case XFS_REFCOUNT_DECREASE:
> +		refc->pe_flags |= XFS_REFCOUNT_EXTENT_DECREASE;
> +		break;
> +	case XFS_REFCOUNT_ALLOC_COW:
> +		refc->pe_flags |= XFS_REFCOUNT_EXTENT_ALLOC_COW;
> +		break;
> +	case XFS_REFCOUNT_FREE_COW:
> +		refc->pe_flags |= XFS_REFCOUNT_EXTENT_FREE_COW;
> +		break;

Is there any good reasons to use a type enum in core, but flags on
disk?

> +int
> +xfs_trans_log_finish_refcount_update(
> +	struct xfs_trans		*tp,
> +	struct xfs_cud_log_item		*cudp,
> +	enum xfs_refcount_intent_type	type,
> +	xfs_fsblock_t			startblock,
> +	xfs_extlen_t			blockcount,
> +	struct xfs_btree_cur		**pcur)
> +{
> +	int				error;
> +
> +	/* XXX: leave this empty for now */
> +	error = -EFSCORRUPTED;

Lift might be a lot easier if this patch and "xfs: connect refcount
adjust functions to upper layers" were merged into one.  It's not like
they are testable independently anyway.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
