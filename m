Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 016FC320F
	for <linux-xfs@vger.kernel.org>; Sat, 31 Aug 2024 13:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725111320; cv=none; b=rvjg4EkeeuZ30mYVA3TQQwbS+cGOH+1o7CCr9n91NCwg+5M1rylhGwoY3fuyHUcDvHy5SyfRgZigxcWxzeC1uyi3s2as5bOFZjbp0XxQCNixwhDqie6xKufsXvaQ96b/QoK5+3LyU+kivhdc3NIJfCB9MNpXSwH9kZyJM++gnro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725111320; c=relaxed/simple;
	bh=BMsA3G3DocJPjg/xv1iObCUBqCPo8RTb9aYk03EdD7g=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i+c4vd8azR9YjNtqqVVxlPyBsV/BCa00Ul6YIPJIqxkhBBy2uQPMe7MF+rVd7FfeDzTy7SZArYBVVVmYv0EqOTzMyWrprmAmpI/iQnmH32G0GTbxgBoQJSMwTCYvfZAngt1IbnKYMvIKTAlpx9O5u+7A/XfJYXhazhz9CXkiRkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Wwwv71B6jzgYs1;
	Sat, 31 Aug 2024 21:33:07 +0800 (CST)
Received: from dggpemf500017.china.huawei.com (unknown [7.185.36.126])
	by mail.maildlp.com (Postfix) with ESMTPS id 8A6211800D1;
	Sat, 31 Aug 2024 21:35:12 +0800 (CST)
Received: from localhost (10.175.127.227) by dggpemf500017.china.huawei.com
 (7.185.36.126) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Sat, 31 Aug
 2024 21:35:12 +0800
Date: Sat, 31 Aug 2024 21:45:05 +0800
From: Long Li <leo.lilong@huawei.com>
To: Dave Chinner <david@fromorbit.com>, "Darrick J. Wong" <djwong@kernel.org>
CC: <chandanbabu@kernel.org>, <linux-xfs@vger.kernel.org>,
	<yi.zhang@huawei.com>, <houtao1@huawei.com>, <yangerkun@huawei.com>
Subject: Re: [PATCH 2/5] xfs: ensuere deleting item from AIL after shutdown
 in dquot flush
Message-ID: <20240831134505.GA1994623@ceph-admin>
References: <20240823110439.1585041-1-leo.lilong@huawei.com>
 <20240823110439.1585041-3-leo.lilong@huawei.com>
 <20240823170006.GF865349@frogsfrogsfrogs>
 <Zs2e/kFGwEAXqfIq@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <Zs2e/kFGwEAXqfIq@dread.disaster.area>
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemf500017.china.huawei.com (7.185.36.126)

On Tue, Aug 27, 2024 at 07:40:14PM +1000, Dave Chinner wrote:
> On Fri, Aug 23, 2024 at 10:00:06AM -0700, Darrick J. Wong wrote:
> > On Fri, Aug 23, 2024 at 07:04:36PM +0800, Long Li wrote:
> > > Deleting items from the AIL before the log is shut down can result in the
> > > log tail moving forward in the journal on disk because log writes can still
> > > be taking place. As a result, items that have been deleted from the AIL
> > > might not be recovered during the next mount, even though they should be,
> > > as they were never written back to disk.
> > > 
> > > Signed-off-by: Long Li <leo.lilong@huawei.com>
> > > ---
> > >  fs/xfs/xfs_dquot.c | 8 +++++++-
> > >  1 file changed, 7 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> > > index c1b211c260a9..4cbe3db6fc32 100644
> > > --- a/fs/xfs/xfs_dquot.c
> > > +++ b/fs/xfs/xfs_dquot.c
> > > @@ -1332,9 +1332,15 @@ xfs_qm_dqflush(
> > >  	return 0;
> > >  
> > >  out_abort:
> > > +	/*
> > > +	 * Shutdown first to stop the log before deleting items from the AIL.
> > > +	 * Deleting items from the AIL before the log is shut down can result
> > > +	 * in the log tail moving forward in the journal on disk because log
> > > +	 * writes can still be taking place.
> > > +	 */
> > > +	xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
> > >  	dqp->q_flags &= ~XFS_DQFLAG_DIRTY;
> > >  	xfs_trans_ail_delete(lip, 0);
> > > -	xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
> > 
> > I see the logic in shutting down the log before letting go of the dquot
> > log item that triggered the shutdown, but I wonder, why do we delete the
> > item from the AIL?  AFAICT the inode items don't do that on iflush
> > failure, but OTOH I couldn't figure out how the log items in the AIL get
> > deleted from the AIL after a shutdown. 
> 
> Intents are removed from the AIL when the transaction containing
> the deferred intent chain is cancelled instead of committed due the
> log being shut down.
> 
> For everything else in the AIL, the ->iop_push method is supposed to
> do any cleanup that is necessary by failing the item push and
> running the item failure method itself.
> 
> For buffers, this is running IO completion as if an IO error
> occurred. Error handling sees the shutdown and removes the item from
> the AIL.
> 
> For inodes, xfs_iflush_cluster() fails the inode buffer as if an IO
> error occurred, that then runs the individual inode abort code that
> removes the inode items from the AIL.
> 
> For dquots, it has the ancient cleanup method that inodes used to
> have. i.e. if the dquot has been flushed to the buffer, it is attached to
> the buffer and then the buffer submission will fail and run IO
> completion with an error. If the dquot hasn't been flushed to the
> buffer because either it or the underlying dquot buffer is corrupt
> it will remove the dquot from the AIL and then shut down the
> filesystem.
> 
> It's the latter case that could be an issue. It's not the same as
> the inode item case, because the tail pinning that the INODE_ALLOC
> inode item type flag causes does not happen with dquots. There is

I'd like to know if the "INODE_ALLOC inode item" refers to a buf
item with the XFS_BLI_INODE_ALLOC_BUF flag? I understand that when
this type of buf item undergoes relog, the tail lsn might be pinned,
but I'm not sure why it's mentioned here, Why does it cause inode
and dquot to be very different?

> still a potential window where the dquot could be at the tail of the
> log, and remocing it moves the tail forward at exactly the same time
> the log tail is being sampled during a log write, and the shutdown
> doesn't happen fast enough to prevent the log write going out to
> disk.
> 
> To make timing of such a race even more unlikely, it would have to
> race with a log write that contains a commit record, otherwise the
> log tail lsn in the iclog will be ignored because it wasn't
> contained within a complete checkpoint in the journal.  It's very
> unlikely that a filesystem will read a corrupt dquot from disk at
> exactly the same point in time these other journal pre-conditions
> are met, but it could happen...
> 

This is a very detailed explanation. I will add this to my commit
message in the next version. Yes, although the conditions for it
to occur are strict, it's still possible to happen.

Thanks,
Long Li

> > Or maybe during a shutdown we just stop xfsaild and let the higher
> > level objects free the log items during reclaim?
> 
> The AIL contains objects that have no references elsewhere in the
> filesystem. It must be pushed until empty during unmount after a
> shutdown to ensure that all the items in it have been pushed,
> failed, removed from the AIL and freed...
> 
> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
