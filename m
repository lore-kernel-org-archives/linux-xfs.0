Received: from canpmsgout10.his.huawei.com (canpmsgout10.his.huawei.com [113.46.200.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DBEA366804
	for <linux-xfs@vger.kernel.org>; Tue, 10 Mar 2026 02:19:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773109192; cv=none; b=mi5/GOmNy997/7ZGqZKrtkBCFtpPWbrSnlRSV70L784UxqBPgROsRYUQ0nSVpd7yxA44acU5df38YHovbc4X1Jw2YOWuvBaKWu1W+2krgnTnc22fZBKTokHRMZ8/E9ILT/Z/5pDzvtr435Cu1AmrFDvdb8kRLjfDxsZISoPVDzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773109192; c=relaxed/simple;
	bh=6DnuH/cAe4ji1oXk1MkEW6XoRgbG7OTtbIfP38umz60=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IUKPcmejZIC/jVuc74G+QGdAVFCGBs/RQMCV0FnWRze3cx6jdqpCPip6HrFiQN8r9o0JERxJlk8COdzevAxTuFYFjjTHCXjlRUpX4xKas3ugZKcxGfh+7Om3W7Jj2IWvrY95gYuD91EyE6714RRemN9vHUcJQGAnCuUof6xIbrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=hvtAVzLC; arc=none smtp.client-ip=113.46.200.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="hvtAVzLC"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=a0NxP2W5N2CJR94Njz1sEs1AVOAgmIrXB4mp4uQl+VE=;
	b=hvtAVzLCRKDREU5kzcPnFTursowCis1no+vDO58CVALnoj+guy7MWC859A0sBfsKS52sP74p2
	+vtjy2sdCrV++vtgv3lMRYjUfUV9DRh1l821Ck6BWC8IvQusUEeZ3td+0Jo89z7uw2qomP/oymg
	CHbeW1HT4PndKQlxXbTVHn0=
Received: from mail.maildlp.com (unknown [172.19.163.200])
	by canpmsgout10.his.huawei.com (SkyGuard) with ESMTPS id 4fVHWw2884z1K9Cg;
	Tue, 10 Mar 2026 10:14:52 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id 8B12640563;
	Tue, 10 Mar 2026 10:19:44 +0800 (CST)
Received: from kwepemn100013.china.huawei.com (7.202.194.116) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 10 Mar 2026 10:19:36 +0800
Received: from localhost (10.50.85.155) by kwepemn100013.china.huawei.com
 (7.202.194.116) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Tue, 10 Mar
 2026 10:19:36 +0800
Date: Tue, 10 Mar 2026 10:15:49 +0800
From: Long Li <leo.lilong@huawei.com>
To: "Darrick J. Wong" <djwong@kernel.org>
CC: <cem@kernel.org>, <linux-xfs@vger.kernel.org>, <david@fromorbit.com>,
	<yi.zhang@huawei.com>, <houtao1@huawei.com>, <yangerkun@huawei.com>,
	<lonuxli.64@gmail.com>
Subject: Re: [PATCH 2/4] xfs: factor out xfs_da3_node_entry_remove
Message-ID: <aa9-1QSzQ_xwzVLI@localhost.localdomain>
References: <20260309082752.2039861-1-leo.lilong@huawei.com>
 <20260309082752.2039861-3-leo.lilong@huawei.com>
 <20260309164229.GI6033@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20260309164229.GI6033@frogsfrogsfrogs>
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemn100013.china.huawei.com (7.202.194.116)

On Mon, Mar 09, 2026 at 09:42:29AM -0700, Darrick J. Wong wrote:
> On Mon, Mar 09, 2026 at 04:27:50PM +0800, Long Li wrote:
> > Factor out wrapper xfs_da3_node_entry_remove function, which
> > exported for external use.
> > 
> > Signed-off-by: Long Li <leo.lilong@huawei.com>
> > ---
> >  fs/xfs/libxfs/xfs_da_btree.c | 54 ++++++++++++++++++++++++++++--------
> >  fs/xfs/libxfs/xfs_da_btree.h |  2 ++
> >  2 files changed, 45 insertions(+), 11 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
> > index 766631f0562e..466c43098768 100644
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
> 
> Style nit: blank line after the tracepoint.
> 
> > +	__xfs_da3_node_remove(state->args->trans, state->args->dp,
> > +			state->args->geo, drop_blk);
> > +}
> > +
> > +/*
> > + * Remove an entry from a node at the specified index, this is an exported
> > + * wrapper for removing entries from intermediate nodes.
> > + */
> > +void
> > +xfs_da3_node_entry_remove(
> 
> This only applies to attr(ibute) structures, as evidenced by m_attr_geo
> below.  I think this ought to be named xfs_attr3_node_entry_remove.
> 

Agree with you, I will update it in the next version.

Thanks,
Long Li

> > +	struct xfs_trans	*tp,
> > +	struct xfs_inode	*dp,
> > +	struct xfs_buf		*bp,
> > +	int			index)
> > +{
> > +	struct xfs_da_state_blk blk;
> 
> 	struct xfs_da_state_blk blk = {
> 		.index		= index,
> 		.bp		= bp,
> 	};
> 
> Otherwise this looks ok to me.
> 
> --D
> 
> > +
> > +	memset(&blk, 0, sizeof(blk));
> > +	blk.index = index;
> > +	blk.bp = bp;
> > +
> > +	__xfs_da3_node_remove(tp, dp, dp->i_mount->m_attr_geo, &blk);
> > +}
> > +
> >  /*
> >   * Unbalance the elements between two intermediate nodes,
> >   * move all Btree elements from one node into another.
> > diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
> > index 354d5d65043e..6cec4313c83c 100644
> > --- a/fs/xfs/libxfs/xfs_da_btree.h
> > +++ b/fs/xfs/libxfs/xfs_da_btree.h
> > @@ -184,6 +184,8 @@ int	xfs_da3_split(xfs_da_state_t *state);
> >  int	xfs_da3_join(xfs_da_state_t *state);
> >  void	xfs_da3_fixhashpath(struct xfs_da_state *state,
> >  			    struct xfs_da_state_path *path_to_to_fix);
> > +void	xfs_da3_node_entry_remove(struct xfs_trans *tp, struct xfs_inode *dp,
> > +				struct xfs_buf *bp, int index);
> >  
> >  /*
> >   * Routines used for finding things in the Btree.
> > -- 
> > 2.39.2
> > 
> > 
> 
