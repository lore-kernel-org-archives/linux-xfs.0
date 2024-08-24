Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FF7BEEB5
	for <linux-xfs@vger.kernel.org>; Sat, 24 Aug 2024 02:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724468287; cv=none; b=aJh156HGMGkySJzLKHy41CCAcNbQmUfN0I755cA8Zu9tGlE8kQLd4AHmr1JRsXsYGjHGUBM0ztpQ9gohioFltwS4dvP0xT9aZvhqVDpPJu9086r6kSovFMsNwdr+vzObo5PMghk9Y9cDr3faZaTcchM65AbEcPb576qPlNZI+jI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724468287; c=relaxed/simple;
	bh=028j746FOY8ZgljuknB2ZYBPNLqGUdSukChmhx+rmVs=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u5G6iaT18v+GlNTnTvJQo0yrxcDzXpt6oXM9el3P5NdFxzM0E1CDiGXyq++NYXEBO2lD2kHVXTQyZDLnOx+Ur9poUJCyon0soTcf1MKPSi56DpxE4z3yTffi0INaqHcIsLRCoBvzofRiLRLgyKBJhwXC6vKM0h59vbvElOLGJvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4WrM6l477tzpVZ5;
	Sat, 24 Aug 2024 10:57:19 +0800 (CST)
Received: from dggpemf500017.china.huawei.com (unknown [7.185.36.126])
	by mail.maildlp.com (Postfix) with ESMTPS id 589F2140137;
	Sat, 24 Aug 2024 10:58:02 +0800 (CST)
Received: from localhost (10.175.127.227) by dggpemf500017.china.huawei.com
 (7.185.36.126) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Sat, 24 Aug
 2024 10:58:02 +0800
Date: Sat, 24 Aug 2024 11:08:05 +0800
From: Long Li <leo.lilong@huawei.com>
To: "Darrick J. Wong" <djwong@kernel.org>
CC: <chandanbabu@kernel.org>, <linux-xfs@vger.kernel.org>,
	<david@fromorbit.com>, <yi.zhang@huawei.com>, <houtao1@huawei.com>,
	<yangerkun@huawei.com>
Subject: Re: [PATCH 2/5] xfs: ensuere deleting item from AIL after shutdown
 in dquot flush
Message-ID: <20240824030805.GA871851@ceph-admin>
References: <20240823110439.1585041-1-leo.lilong@huawei.com>
 <20240823110439.1585041-3-leo.lilong@huawei.com>
 <20240823170006.GF865349@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20240823170006.GF865349@frogsfrogsfrogs>
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemf500017.china.huawei.com (7.185.36.126)

On Fri, Aug 23, 2024 at 10:00:06AM -0700, Darrick J. Wong wrote:
> On Fri, Aug 23, 2024 at 07:04:36PM +0800, Long Li wrote:
> > Deleting items from the AIL before the log is shut down can result in the
> > log tail moving forward in the journal on disk because log writes can still
> > be taking place. As a result, items that have been deleted from the AIL
> > might not be recovered during the next mount, even though they should be,
> > as they were never written back to disk.
> > 
> > Signed-off-by: Long Li <leo.lilong@huawei.com>
> > ---
> >  fs/xfs/xfs_dquot.c | 8 +++++++-
> >  1 file changed, 7 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> > index c1b211c260a9..4cbe3db6fc32 100644
> > --- a/fs/xfs/xfs_dquot.c
> > +++ b/fs/xfs/xfs_dquot.c
> > @@ -1332,9 +1332,15 @@ xfs_qm_dqflush(
> >  	return 0;
> >  
> >  out_abort:
> > +	/*
> > +	 * Shutdown first to stop the log before deleting items from the AIL.
> > +	 * Deleting items from the AIL before the log is shut down can result
> > +	 * in the log tail moving forward in the journal on disk because log
> > +	 * writes can still be taking place.
> > +	 */
> > +	xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
> >  	dqp->q_flags &= ~XFS_DQFLAG_DIRTY;
> >  	xfs_trans_ail_delete(lip, 0);
> > -	xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
> 
> I see the logic in shutting down the log before letting go of the dquot
> log item that triggered the shutdown, but I wonder, why do we delete the
> item from the AIL?  AFAICT the inode items don't do that on iflush
> failure, but OTOH I couldn't figure out how the log items in the AIL get
> deleted from the AIL after a shutdown.  Or maybe during a shutdown we
> just stop xfsaild and let the higher level objects free the log items
> during reclaim?
> 
> --D
> 

When inode flush failure, the inode item is also removed from the AIL. Since
the inode item has already been added to bp->b_li_list during precommit, it
can be deleted through the error handling xfs_buf_ioend_fail(bp), and this
deletion occurs after the log shutdown. However, during dquot item push,
the dquot item has not yet been attached to the buffer. Therefore, in this
case, the dquot item is directly removed from the AIL.

Thanks,
Long Li
