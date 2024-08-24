Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EC2BB644
	for <linux-xfs@vger.kernel.org>; Sat, 24 Aug 2024 01:54:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724464465; cv=none; b=j1yS5VeY0rMpts9LvJm7NHG4NR7+Czm3HS7UmKab+LHennw7ysgN4EHJ+HIYA3Q+1g76Jygx+dtad6ZR/ppwaGdM6TCVU1Gvn8vF45eyRUKfeMoNjNcEJXmoqM96n4KbEvQmu/BMnsw4wBLYj4G1Wg4fM0plN0VN/rXAQvitRGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724464465; c=relaxed/simple;
	bh=bqJBD47+GWdlXxypIApRlSnQ7VdbjIEk91am9DrxUck=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DptEs8PLMBbDFz7zGyPoDVaQix1YydlNZxzA92xtHUkYPD+N+4IOz3enZ4z4nLxkfptHa2snyASvkMBTvBZhNSFPtL3y10wSWukiZzYcHjEGEjtNDJnt2ingEMJq1tflBOL42/4Ntnz0wMfrEQZg8jN0DuzAJ94lzCYEkP2ahRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4WrKjx12xVz1j73S;
	Sat, 24 Aug 2024 09:54:13 +0800 (CST)
Received: from dggpemf500017.china.huawei.com (unknown [7.185.36.126])
	by mail.maildlp.com (Postfix) with ESMTPS id A37C614011B;
	Sat, 24 Aug 2024 09:54:18 +0800 (CST)
Received: from localhost (10.175.127.227) by dggpemf500017.china.huawei.com
 (7.185.36.126) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Sat, 24 Aug
 2024 09:53:33 +0800
Date: Sat, 24 Aug 2024 10:03:37 +0800
From: Long Li <leo.lilong@huawei.com>
To: "Darrick J. Wong" <djwong@kernel.org>
CC: <chandanbabu@kernel.org>, <linux-xfs@vger.kernel.org>,
	<david@fromorbit.com>, <yi.zhang@huawei.com>, <houtao1@huawei.com>,
	<yangerkun@huawei.com>
Subject: Re: [PATCH 4/5] xfs: fix a UAF when dquot item push
Message-ID: <20240824015849.GA3833553@ceph-admin>
References: <20240823110439.1585041-1-leo.lilong@huawei.com>
 <20240823110439.1585041-5-leo.lilong@huawei.com>
 <20240823172038.GH865349@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20240823172038.GH865349@frogsfrogsfrogs>
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemf500017.china.huawei.com (7.185.36.126)

On Fri, Aug 23, 2024 at 10:20:38AM -0700, Darrick J. Wong wrote:
> On Fri, Aug 23, 2024 at 07:04:38PM +0800, Long Li wrote:
> > If errors are encountered while pushing a dquot log item, the dquot dirty
> > flag is cleared. Without the protection of dqlock and dqflock locks, the
> > dquot reclaim thread may free the dquot. Accessing the log item in xfsaild
> > after this can trigger a UAF.
> > 
> >   CPU0                              CPU1
> >   push item                         reclaim dquot
> >   -----------------------           -----------------------
> >   xfsaild_push_item
> >     xfs_qm_dquot_logitem_push(lip)
> >       xfs_dqlock_nowait(dqp)
> >       xfs_dqflock_nowait(dqp)
> >       spin_unlock(&lip->li_ailp->ail_lock)
> >       xfs_qm_dqflush(dqp, &bp)
> >                        <encountered some errors>
> >         xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE)
> >         dqp->q_flags &= ~XFS_DQFLAG_DIRTY
> >                        <dquot is not diry>
> >         xfs_trans_ail_delete(lip, 0)
> >         xfs_dqfunlock(dqp)
> >       spin_lock(&lip->li_ailp->ail_lock)
> >       xfs_dqunlock(dqp)
> >                                     xfs_qm_shrink_scan
> >                                       list_lru_shrink_walk
> >                                         xfs_qm_dquot_isolate
> >                                           xfs_dqlock_nowait(dqp)
> >                                           xfs_dqfunlock(dqp)
> >                                           //dquot is clean, not flush it
> >                                           xfs_dqfunlock(dqp)
> >                                           dqp->q_flags |= XFS_DQFLAG_FREEING
> >                                           xfs_dqunlock(dqp)
> >                                           //add dquot to dispose list
> >                                       //free dquot in dispose list
> >                                       xfs_qm_dqfree_one(dqp)
> >   trace_xfs_ail_xxx(lip)  //UAF
> > 
> > Fix this by returning XFS_ITEM_UNSAFE in xfs_qm_dquot_logitem_push() when
> > dquot flush encounters errors (excluding EAGAIN error), ensuring xfsaild
> > does not access the log item after it is pushed.
> > 
> > Fixes: 9e4c109ac822 ("xfs: add AIL pushing tracepoints")
> > Signed-off-by: Long Li <leo.lilong@huawei.com>
> > ---
> >  fs/xfs/xfs_dquot_item.c | 10 +++++++++-
> >  1 file changed, 9 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/xfs/xfs_dquot_item.c b/fs/xfs/xfs_dquot_item.c
> > index 7d19091215b0..afc7ad91ddef 100644
> > --- a/fs/xfs/xfs_dquot_item.c
> > +++ b/fs/xfs/xfs_dquot_item.c
> > @@ -160,8 +160,16 @@ xfs_qm_dquot_logitem_push(
> >  		if (!xfs_buf_delwri_queue(bp, buffer_list))
> >  			rval = XFS_ITEM_FLUSHING;
> >  		xfs_buf_relse(bp);
> > -	} else if (error == -EAGAIN)
> > +	} else if (error == -EAGAIN) {
> >  		rval = XFS_ITEM_LOCKED;
> > +	} else {
> > +		/*
> > +		 * The dirty flag has been cleared; the dquot may be reclaimed
> > +		 * after unlock. It's unsafe to access the item after it has
> > +		 * been pushed.
> > +		 */
> > +		rval = XFS_ITEM_UNSAFE;
> > +	}
> >  
> >  	spin_lock(&lip->li_ailp->ail_lock);
> 
> Um, didn't we just establish that lip could have been freed?  Why is it
> safe to continue accessing the AIL through the lip here?
> 
> --D
> 

We are still within the dqlock context here, and the dquot will only be
released after the dqlock is released. In contrast, during the inode item
push, the inode log item may be released within xfs_iflush_cluster() - this
is where the two cases differ. However, for the sake of code consistency,
should we also avoid accessing the AIL through lip here?

Thanks,
Long Li

