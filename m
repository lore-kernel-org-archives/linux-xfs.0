Received: from canpmsgout12.his.huawei.com (canpmsgout12.his.huawei.com [113.46.200.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C2683033FC
	for <linux-xfs@vger.kernel.org>; Sat, 14 Mar 2026 02:53:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773456808; cv=none; b=NfapEGATy7Mo6YhvKxbI5oLS/F+g0A5sgH3emB04JXptwya0WGNb1mPDMYXHhr5pxmSSZqFSIrgp7CCZxVAsvF9v9H63nwjxBsykQlXzWryZyNSBDtWni/5ETlu1fow/3A32rQq1UOTZNzu5WN2GgaF7umUp114qO7vj6nUpaVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773456808; c=relaxed/simple;
	bh=FfRjLqW/LrCB/Q1sUWBGbubRQPE3P0brgbQ1DIf4TUU=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aGRje+4WpLC59FKNBAcGCqMJm+VI9d7OM4FiV8sofOnNZ9J/DP4CGaIF7LquV1s/S8SYmHizWcE1xyCrUNbyXrVvj92wqA7oBIzzRlQV/7gflRvBviR82BeZk/LrejZgQ92tBWdHBaNlBpSdfFn3SDWuHpZqkyZLQBmN75cgDc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=qemLukki; arc=none smtp.client-ip=113.46.200.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="qemLukki"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=2gATAJ5HfXTSqcKOEP5PZoaKji8ttvmt0ijeDWdncYU=;
	b=qemLukkidDPc/XMrDF6f5OTHYy9tpIR9UgqA5tDUxC+QSIlSzks7srMx+ODY0sKLByFlRQ2Zr
	KnK3sKfYDExVD6wsdG1g/swKyOUIOGMsu2a4RelP8/xccZz+siw8BumrGpzHpIiH0e2c7peQxqY
	VfOArvnyIRl6CAEUAjOQhu8=
Received: from mail.maildlp.com (unknown [172.19.163.200])
	by canpmsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4fXm430JF3znTXh;
	Sat, 14 Mar 2026 10:47:47 +0800 (CST)
Received: from dggemv712-chm.china.huawei.com (unknown [10.1.198.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 3D62340563;
	Sat, 14 Mar 2026 10:53:21 +0800 (CST)
Received: from kwepemn100013.china.huawei.com (7.202.194.116) by
 dggemv712-chm.china.huawei.com (10.1.198.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 14 Mar 2026 10:53:20 +0800
Received: from localhost (10.50.85.155) by kwepemn100013.china.huawei.com
 (7.202.194.116) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Sat, 14 Mar
 2026 10:53:20 +0800
Date: Sat, 14 Mar 2026 10:49:20 +0800
From: Long Li <leo.lilong@huawei.com>
To: "Darrick J. Wong" <djwong@kernel.org>
CC: <cem@kernel.org>, <linux-xfs@vger.kernel.org>, <david@fromorbit.com>,
	<yi.zhang@huawei.com>, <houtao1@huawei.com>, <yangerkun@huawei.com>,
	<lonuxli.64@gmail.com>
Subject: Re: [PATCH v2 2/4] xfs: factor out xfs_attr3_node_entry_remove
Message-ID: <abTMsCTEfLLbi1rH@localhost.localdomain>
References: <20260312085800.1213919-1-leo.lilong@huawei.com>
 <20260312085800.1213919-3-leo.lilong@huawei.com>
 <20260313150112.GP1770774@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20260313150112.GP1770774@frogsfrogsfrogs>
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemn100013.china.huawei.com (7.202.194.116)

On Fri, Mar 13, 2026 at 08:01:12AM -0700, Darrick J. Wong wrote:
> On Thu, Mar 12, 2026 at 04:57:58PM +0800, Long Li wrote:
> > Factor out wrapper xfs_attr3_node_entry_remove function, which
> > exported for external use.
> > 
> > Signed-off-by: Long Li <leo.lilong@huawei.com>
> > ---
> >  fs/xfs/libxfs/xfs_da_btree.c | 54 ++++++++++++++++++++++++++++--------
> >  fs/xfs/libxfs/xfs_da_btree.h |  2 ++
> >  2 files changed, 45 insertions(+), 11 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
> > index 766631f0562e..0b9fe3e4370d 100644
> > --- a/fs/xfs/libxfs/xfs_da_btree.c
> > +++ b/fs/xfs/libxfs/xfs_da_btree.c
> > @@ -1506,21 +1506,20 @@ xfs_da3_fixhashpath(
> >  }
> >  
> >  /*
> > - * Remove an entry from an intermediate node.
> > + * Internal implementation to remove an entry from an intermediate node.
> >   */
> >  STATIC void
> > -xfs_da3_node_remove(
> > -	struct xfs_da_state	*state,
> > -	struct xfs_da_state_blk	*drop_blk)
> > +__xfs_da3_node_remove(
> > +	struct xfs_trans	*tp,
> > +	struct xfs_inode	*dp,
> > +	struct xfs_da_geometry  *geo,
> > +	struct xfs_da_state_blk *drop_blk)
> >  {
> >  	struct xfs_da_intnode	*node;
> >  	struct xfs_da3_icnode_hdr nodehdr;
> >  	struct xfs_da_node_entry *btree;
> >  	int			index;
> >  	int			tmp;
> > -	struct xfs_inode	*dp = state->args->dp;
> > -
> > -	trace_xfs_da_node_remove(state->args);
> >  
> >  	node = drop_blk->bp->b_addr;
> >  	xfs_da3_node_hdr_from_disk(dp->i_mount, &nodehdr, node);
> > @@ -1536,17 +1535,17 @@ xfs_da3_node_remove(
> >  		tmp  = nodehdr.count - index - 1;
> >  		tmp *= (uint)sizeof(xfs_da_node_entry_t);
> >  		memmove(&btree[index], &btree[index + 1], tmp);
> > -		xfs_trans_log_buf(state->args->trans, drop_blk->bp,
> > +		xfs_trans_log_buf(tp, drop_blk->bp,
> >  		    XFS_DA_LOGRANGE(node, &btree[index], tmp));
> >  		index = nodehdr.count - 1;
> >  	}
> >  	memset(&btree[index], 0, sizeof(xfs_da_node_entry_t));
> > -	xfs_trans_log_buf(state->args->trans, drop_blk->bp,
> > +	xfs_trans_log_buf(tp, drop_blk->bp,
> >  	    XFS_DA_LOGRANGE(node, &btree[index], sizeof(btree[index])));
> >  	nodehdr.count -= 1;
> >  	xfs_da3_node_hdr_to_disk(dp->i_mount, node, &nodehdr);
> > -	xfs_trans_log_buf(state->args->trans, drop_blk->bp,
> > -	    XFS_DA_LOGRANGE(node, &node->hdr, state->args->geo->node_hdr_size));
> > +	xfs_trans_log_buf(tp, drop_blk->bp,
> > +	    XFS_DA_LOGRANGE(node, &node->hdr, geo->node_hdr_size));
> >  
> >  	/*
> >  	 * Copy the last hash value from the block to propagate upwards.
> > @@ -1554,6 +1553,39 @@ xfs_da3_node_remove(
> >  	drop_blk->hashval = be32_to_cpu(btree[index - 1].hashval);
> >  }
> >  
> > +/*
> > + * Remove an entry from an intermediate node.
> > + */
> > +STATIC void
> > +xfs_da3_node_remove(
> > +	struct xfs_da_state	*state,
> > +	struct xfs_da_state_blk	*drop_blk)
> > +{
> > +	trace_xfs_da_node_remove(state->args);
> > +
> > +	__xfs_da3_node_remove(state->args->trans, state->args->dp,
> > +			state->args->geo, drop_blk);
> > +}
> > +
> > +/*
> > + * Remove an entry from a node at the specified index, this is an exported
> > + * wrapper for removing entries from intermediate nodes.
> 
> "exported" is confusing since in kernel-land that usually implies
> EXPORT_SYMBOL_GPL(), which this clearly isn't.  You could trim this to
> 
> /*
>  * Remove an entry from an intermediate attr node at the specified
>  * index.
>  */
> 
> With that touched up,
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
> 
> --D

Thanks for your review, it will be update.

Long Li
