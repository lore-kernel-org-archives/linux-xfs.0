Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D8C71DA32B
	for <linux-xfs@vger.kernel.org>; Wed,  3 Jul 2024 06:22:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719987774; cv=none; b=q1rA9QYOIc6u3ozTyNJd7U7ziDyXEUA3ZuVCi1CFIe8ffxKYaY6lJ3bDSLO/hYKphHNDP39wt4wj+lzjXwzZp6nID4gVA+1ECErXtXBvxFCqCZFsHOHzsMQjZgv5o7tc+K8uOyG/oD6Q/lJFbOHQnNRrBGIcjnSW+buLf32KYgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719987774; c=relaxed/simple;
	bh=tnlFSmDwfz2cf79IY57tLfaqJret+pTtUc2aNJtJ7qY=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NcskqeCxHdBYjhNJ2Z42hneFAUqC+ztoCAPwUEQNTpEQxJ0GJMzCn256xqNDxKRq/YnZIUBr651C0TytNWlomQb04pCcSzuLceEZ5RYhOG4m75b4MUV5b95FhkaH4VrCNAXTHEedlKvsUJRplzdNWUVAhqdjgjzDvCX4Zw/0Bws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.163])
	by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4WDV2w4WJpz1X4Ks;
	Wed,  3 Jul 2024 14:18:32 +0800 (CST)
Received: from kwepemi500009.china.huawei.com (unknown [7.221.188.199])
	by mail.maildlp.com (Postfix) with ESMTPS id 07E06180028;
	Wed,  3 Jul 2024 14:22:39 +0800 (CST)
Received: from localhost (10.175.127.227) by kwepemi500009.china.huawei.com
 (7.221.188.199) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Wed, 3 Jul
 2024 14:22:38 +0800
Date: Wed, 3 Jul 2024 14:33:55 +0800
From: Long Li <leo.lilong@huawei.com>
To: "Darrick J. Wong" <djwong@kernel.org>
CC: <chandanbabu@kernel.org>, <linux-xfs@vger.kernel.org>,
	<david@fromorbit.com>, <yi.zhang@huawei.com>, <houtao1@huawei.com>,
	<yangerkun@huawei.com>
Subject: Re: [PATCH] xfs: get rid of xfs_ag_resv_rmapbt_alloc
Message-ID: <20240703063355.GA518841@ceph-admin>
References: <20240702134851.2654558-1-leo.lilong@huawei.com>
 <20240703051446.GF612460@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20240703051446.GF612460@frogsfrogsfrogs>
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemi500009.china.huawei.com (7.221.188.199)

On Tue, Jul 02, 2024 at 10:14:46PM -0700, Darrick J. Wong wrote:
> On Tue, Jul 02, 2024 at 09:48:51PM +0800, Long Li wrote:
> > The pag in xfs_ag_resv_rmapbt_alloc() is already held when the struct
> > xfs_btree_cur is initialized in xfs_rmapbt_init_cursor(), so there is no
> > need to get pag again.
> > 
> > On the other hand, in xfs_rmapbt_free_block(), the similar function
> > xfs_ag_resv_rmapbt_free() was removed in commit 92a005448f6f ("xfs: get
> > rid of unnecessary xfs_perag_{get,put} pairs"), xfs_ag_resv_rmapbt_alloc()
> > was left because scrub used it, but now scrub has removed it. Therefore,
> > we could get rid of xfs_ag_resv_rmapbt_alloc() just like the rmap free
> > block, make the code cleaner.
> > 
> > Signed-off-by: Long Li <leo.lilong@huawei.com>
> > ---
> >  fs/xfs/libxfs/xfs_ag_resv.h    | 19 -------------------
> >  fs/xfs/libxfs/xfs_rmap_btree.c |  8 +++++++-
> >  2 files changed, 7 insertions(+), 20 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_ag_resv.h b/fs/xfs/libxfs/xfs_ag_resv.h
> > index ff20ed93de77..f247eeff7358 100644
> > --- a/fs/xfs/libxfs/xfs_ag_resv.h
> > +++ b/fs/xfs/libxfs/xfs_ag_resv.h
> > @@ -33,23 +33,4 @@ xfs_perag_resv(
> >  	}
> >  }
> >  
> > -/*
> > - * RMAPBT reservation accounting wrappers. Since rmapbt blocks are sourced from
> > - * the AGFL, they are allocated one at a time and the reservation updates don't
> > - * require a transaction.
> > - */
> > -static inline void
> > -xfs_ag_resv_rmapbt_alloc(
> > -	struct xfs_mount	*mp,
> > -	xfs_agnumber_t		agno)
> > -{
> > -	struct xfs_alloc_arg	args = { NULL };
> > -	struct xfs_perag	*pag;
> > -
> > -	args.len = 1;
> > -	pag = xfs_perag_get(mp, agno);
> > -	xfs_ag_resv_alloc_extent(pag, XFS_AG_RESV_RMAPBT, &args);
> > -	xfs_perag_put(pag);
> > -}
> > -
> >  #endif	/* __XFS_AG_RESV_H__ */
> > diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
> > index 9e759efa81cc..aa1d29814b74 100644
> > --- a/fs/xfs/libxfs/xfs_rmap_btree.c
> > +++ b/fs/xfs/libxfs/xfs_rmap_btree.c
> > @@ -88,6 +88,7 @@ xfs_rmapbt_alloc_block(
> >  	struct xfs_buf		*agbp = cur->bc_ag.agbp;
> >  	struct xfs_agf		*agf = agbp->b_addr;
> >  	struct xfs_perag	*pag = cur->bc_ag.pag;
> > +	struct xfs_alloc_arg    args = { NULL };
> 
> You could make this even more compact with
> 
> 	struct xfs_alloc_arg	args = { .len = 1 };

It's ok for me, I will send a new version. thanks!

> 
> Otherwise this looks ok to me as a cleanup.
> 
> --D
> 
> >  	int			error;
> >  	xfs_agblock_t		bno;
> >  
> > @@ -107,7 +108,12 @@ xfs_rmapbt_alloc_block(
> >  	be32_add_cpu(&agf->agf_rmap_blocks, 1);
> >  	xfs_alloc_log_agf(cur->bc_tp, agbp, XFS_AGF_RMAP_BLOCKS);
> >  
> > -	xfs_ag_resv_rmapbt_alloc(cur->bc_mp, pag->pag_agno);
> > +	/*
> > +	 * Since rmapbt blocks are sourced from the AGFL, they are allocated one
> > +	 * at a time and the reservation updates don't require a transaction.
> > +	 */
> > +	args.len = 1;
> > +	xfs_ag_resv_alloc_extent(pag, XFS_AG_RESV_RMAPBT, &args);
> >  
> >  	*stat = 1;
> >  	return 0;
> > -- 
> > 2.39.2
> > 
> > 
