Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4FE097F37
	for <xfs@oss.sgi.com>; Wed, 20 Jan 2016 15:19:50 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D2E48AC002
	for <xfs@oss.sgi.com>; Wed, 20 Jan 2016 13:19:49 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	Ea4ZrzdbTBNpXH4U for <xfs@oss.sgi.com>;
	Wed, 20 Jan 2016 13:19:47 -0800 (PST)
Date: Thu, 21 Jan 2016 08:19:44 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] Revert "xfs: clear PF_NOFREEZE for xfsaild kthread"
Message-ID: <20160120211944.GE20456@dastard>
References: <1452661968-11482-1-git-send-email-david@fromorbit.com>
	<20160120084750.GA14187@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160120084750.GA14187@dhcp22.suse.cz>
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
To: Michal Hocko <mhocko@suse.cz>
Cc: jkosina@suse.cz, Hendrik Woltersdorf <hendrikw@arcor.de>, xfs@oss.sgi.com

On Wed, Jan 20, 2016 at 09:47:50AM +0100, Michal Hocko wrote:
> On Wed 13-01-16 16:12:48, Dave Chinner wrote:
> > This reverts commit 24ba16bb3d499c49974669cd8429c3e4138ab102 as it
> > prevents machines from suspending. This regression occurs when the
> > xfsaild is idle on entry to suspend, and so there s no activity to
> > wake it from it's idle sleep and hence see that it is supposed to
> > freeze. Hence the freezer times out waiting for it and suspend is
> > cancelled.
> > 
> > There is no obvious fix for this short of freezing the filesystem
> > properly, so revert this change for now.
> 
> We had a similar report opensuse bugzilla just recently. I believe the
> proper fix should be the following:
....
> diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
> index aa67339b9537..d6c9c3e9e02b 100644
> --- a/fs/xfs/xfs_trans_ail.c
> +++ b/fs/xfs/xfs_trans_ail.c
> @@ -520,14 +520,14 @@ xfsaild(
>  		if (!xfs_ail_min(ailp) &&
>  		    ailp->xa_target == ailp->xa_target_prev) {
>  			spin_unlock(&ailp->xa_lock);
> -			schedule();
> +			freezable_schedule();

Oh, wonderful. A completely separate set of undocumented schedule
functions defined inside the freezer header files that are needed
just for freezable kthreads. Perhaps there should be some
documentation somewhere on how to write suspend safe kthreads?

This is too late for the current merge window, but I'll queue it up
for the next one so we can get some testing on it first.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
