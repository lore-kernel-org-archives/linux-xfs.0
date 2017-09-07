Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42746 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932139AbdIGMYc (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 7 Sep 2017 08:24:32 -0400
Date: Thu, 7 Sep 2017 08:24:30 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: umount XFS hung when stopping the xfsaild kthread
Message-ID: <20170907122430.GB60838@bfoster.bfoster>
References: <c869cd34-269b-a13d-5009-390e70aa47ac@huawei.com>
 <20170905230043.GN17782@dastard>
 <20170906111145.GA54570@bfoster.bfoster>
 <20170906224107.GL29261@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170906224107.GL29261@wotan.suse.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: linux-xfs@vger.kernel.org

cc linux-xfs

On Thu, Sep 07, 2017 at 12:41:07AM +0200, Luis R. Rodriguez wrote:
> On Wed, Sep 06, 2017 at 07:11:45AM -0400, Brian Foster wrote:
> > FWIW, I ran a quick test on for-next since there hasn't been a reply to
> > this thread in that regard. Add a 10s delay between
> > kthread_should_stop() and __set_current_state() in xfsaild (when
> > unmounting and AIL is empty) and a 5s delay before kthread_stop() in
> > xfs_trans_ail_destroy() and the problem reproduces consistently.
> 
> Do you mean as follows?
> 

Essentially, though I also included empty AIL (!xfs_ail_min) and
unmounting (mp->m_flags & XFS_MOUNT_UNMOUNTING) logic to limit the
xfsaild delay to the case where care about.

Brian

> diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
> index 354368a906e5..475134833a4d 100644
> --- a/fs/xfs/xfs_trans_ail.c
> +++ b/fs/xfs/xfs_trans_ail.c
> @@ -515,6 +515,7 @@ xfsaild(
>  	set_freezable();
>  
>  	while (!kthread_should_stop()) {
> +		ssleep(10);
>  		if (tout && tout <= 20)
>  			__set_current_state(TASK_KILLABLE);
>  		else
> @@ -805,6 +806,7 @@ xfs_trans_ail_destroy(
>  {
>  	struct xfs_ail	*ailp = mp->m_ail;
>  
> +	ssleep(5);
>  	kthread_stop(ailp->xa_task);
>  	kmem_free(ailp);
>  }
