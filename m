Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 851AEC433FE
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Mar 2022 20:59:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240964AbiCRVAk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 18 Mar 2022 17:00:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240992AbiCRVAj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 18 Mar 2022 17:00:39 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2FEC01B4E86
        for <linux-xfs@vger.kernel.org>; Fri, 18 Mar 2022 13:59:17 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-150-27.pa.vic.optusnet.com.au [49.186.150.27])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 3CF6210E51B6;
        Sat, 19 Mar 2022 07:59:14 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nVJgm-007574-DG; Sat, 19 Mar 2022 07:59:12 +1100
Date:   Sat, 19 Mar 2022 07:59:12 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     kbuild@lists.01.org, linux-xfs@vger.kernel.org, lkp@intel.com,
        kbuild-all@lists.01.org
Subject: Re: [kbuild] Re: [PATCH 3/7] xfs: xfs_ail_push_all_sync() stalls
 when racing with updates
Message-ID: <20220318205912.GF1544202@dread.disaster.area>
References: <20220317053907.164160-4-david@fromorbit.com>
 <202203172212.pRLbx3jA-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202203172212.pRLbx3jA-lkp@intel.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=6234f2a3
        a=sPqof0Mm7fxWrhYUF33ZaQ==:117 a=sPqof0Mm7fxWrhYUF33ZaQ==:17
        a=kj9zAlcOel0A:10 a=o8Y5sQTvuykA:10 a=NEAV23lmAAAA:8 a=VwQbUJbxAAAA:8
        a=i3X5FwGiAAAA:8 a=QyXUC8HyAAAA:8 a=yPCof4ZbAAAA:8 a=7-415B0cAAAA:8
        a=jOG9JjpHtk2UEyIpgh4A:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=mmqRlSCDY2ywfjPLJ4af:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 18, 2022 at 11:10:22AM +0300, Dan Carpenter wrote:
> Hi Dave,
> 
> url:    https://github.com/0day-ci/linux/commits/Dave-Chinner/xfs-log-recovery-fixes/20220317-141849 
> base:   https://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git  for-next
> config: parisc-randconfig-m031-20220317 (https://download.01.org/0day-ci/archive/20220317/202203172212.pRLbx3jA-lkp@intel.com/config )
> compiler: hppa-linux-gcc (GCC) 11.2.0
> 
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> smatch warnings:
> fs/xfs/xfs_trans_ail.c:476 xfsaild_push() error: uninitialized symbol 'target'.
> 
> vim +/target +476 fs/xfs/xfs_trans_ail.c
> 
> 0030807c66f058 Christoph Hellwig 2011-10-11  417  static long
> 0030807c66f058 Christoph Hellwig 2011-10-11  418  xfsaild_push(
> 0030807c66f058 Christoph Hellwig 2011-10-11  419  	struct xfs_ail		*ailp)
> 249a8c1124653f David Chinner     2008-02-05  420  {
> 57e809561118a4 Matthew Wilcox    2018-03-07  421  	xfs_mount_t		*mp = ailp->ail_mount;
> af3e40228fb2db Dave Chinner      2011-07-18  422  	struct xfs_ail_cursor	cur;
> efe2330fdc246a Christoph Hellwig 2019-06-28  423  	struct xfs_log_item	*lip;
> 9e7004e741de0b Dave Chinner      2011-05-06  424  	xfs_lsn_t		lsn;
> fe0da767311933 Dave Chinner      2011-05-06  425  	xfs_lsn_t		target;
> 43ff2122e6492b Christoph Hellwig 2012-04-23  426  	long			tout;
> 9e7004e741de0b Dave Chinner      2011-05-06  427  	int			stuck = 0;
> 43ff2122e6492b Christoph Hellwig 2012-04-23  428  	int			flushing = 0;
> 9e7004e741de0b Dave Chinner      2011-05-06  429  	int			count = 0;
> ^1da177e4c3f41 Linus Torvalds    2005-04-16  430  
> 670ce93fef93bb Dave Chinner      2011-09-30  431  	/*
> 43ff2122e6492b Christoph Hellwig 2012-04-23  432  	 * If we encountered pinned items or did not finish writing out all
> 0020a190cf3eac Dave Chinner      2021-08-10  433  	 * buffers the last time we ran, force a background CIL push to get the
> 0020a190cf3eac Dave Chinner      2021-08-10  434  	 * items unpinned in the near future. We do not wait on the CIL push as
> 0020a190cf3eac Dave Chinner      2021-08-10  435  	 * that could stall us for seconds if there is enough background IO
> 0020a190cf3eac Dave Chinner      2021-08-10  436  	 * load. Stalling for that long when the tail of the log is pinned and
> 0020a190cf3eac Dave Chinner      2021-08-10  437  	 * needs flushing will hard stop the transaction subsystem when log
> 0020a190cf3eac Dave Chinner      2021-08-10  438  	 * space runs out.
> 670ce93fef93bb Dave Chinner      2011-09-30  439  	 */
> 57e809561118a4 Matthew Wilcox    2018-03-07  440  	if (ailp->ail_log_flush && ailp->ail_last_pushed_lsn == 0 &&
> 57e809561118a4 Matthew Wilcox    2018-03-07  441  	    (!list_empty_careful(&ailp->ail_buf_list) ||
> 43ff2122e6492b Christoph Hellwig 2012-04-23  442  	     xfs_ail_min_lsn(ailp))) {
> 57e809561118a4 Matthew Wilcox    2018-03-07  443  		ailp->ail_log_flush = 0;
> 43ff2122e6492b Christoph Hellwig 2012-04-23  444  
> ff6d6af2351cae Bill O'Donnell    2015-10-12  445  		XFS_STATS_INC(mp, xs_push_ail_flush);
> 0020a190cf3eac Dave Chinner      2021-08-10  446  		xlog_cil_flush(mp->m_log);
> 670ce93fef93bb Dave Chinner      2011-09-30  447  	}
> 670ce93fef93bb Dave Chinner      2011-09-30  448  
> 57e809561118a4 Matthew Wilcox    2018-03-07  449  	spin_lock(&ailp->ail_lock);
> 8375f922aaa6e7 Brian Foster      2012-06-28  450  
> 29e90a4845ecee Dave Chinner      2022-03-17  451  	/*
> 29e90a4845ecee Dave Chinner      2022-03-17  452  	 * If we have a sync push waiter, we always have to push till the AIL is
> 29e90a4845ecee Dave Chinner      2022-03-17  453  	 * empty. Update the target to point to the end of the AIL so that
> 29e90a4845ecee Dave Chinner      2022-03-17  454  	 * capture updates that occur after the sync push waiter has gone to
> 29e90a4845ecee Dave Chinner      2022-03-17  455  	 * sleep.
> 29e90a4845ecee Dave Chinner      2022-03-17  456  	 */
> 29e90a4845ecee Dave Chinner      2022-03-17  457  	if (waitqueue_active(&ailp->ail_empty)) {
> 29e90a4845ecee Dave Chinner      2022-03-17  458  		lip = xfs_ail_max(ailp);
> 29e90a4845ecee Dave Chinner      2022-03-17  459  		if (lip)
> 29e90a4845ecee Dave Chinner      2022-03-17  460  			target = lip->li_lsn;
> 
> No else path.

Target will only be uninitialised here if the AIL is empty. 

> 29e90a4845ecee Dave Chinner      2022-03-17  461  	} else {
> 57e809561118a4 Matthew Wilcox    2018-03-07  462  		/* barrier matches the ail_target update in xfs_ail_push() */
> 8375f922aaa6e7 Brian Foster      2012-06-28  463  		smp_rmb();
> 57e809561118a4 Matthew Wilcox    2018-03-07  464  		target = ailp->ail_target;
> 57e809561118a4 Matthew Wilcox    2018-03-07  465  		ailp->ail_target_prev = target;
> 29e90a4845ecee Dave Chinner      2022-03-17  466  	}
> 8375f922aaa6e7 Brian Foster      2012-06-28  467  
> f376b45e861d8b Brian Foster      2020-07-16  468  	/* we're done if the AIL is empty or our push has reached the end */
> 57e809561118a4 Matthew Wilcox    2018-03-07  469  	lip = xfs_trans_ail_cursor_first(ailp, &cur, ailp->ail_last_pushed_lsn);
> 
> "lip" re-assigned here

If the AIL is empty, this will return NULL. Hence if xfs_ail_max()
returns NULL, so will this. Hence:

> 
> f376b45e861d8b Brian Foster      2020-07-16  470  	if (!lip)
> 9e7004e741de0b Dave Chinner      2011-05-06  471  		goto out_done;

We take this path, and never reference target...

> ^1da177e4c3f41 Linus Torvalds    2005-04-16  472  
> ff6d6af2351cae Bill O'Donnell    2015-10-12  473  	XFS_STATS_INC(mp, xs_push_ail);
> ^1da177e4c3f41 Linus Torvalds    2005-04-16  474  
> 249a8c1124653f David Chinner     2008-02-05  475  	lsn = lip->li_lsn;
> 50e86686dfb287 Dave Chinner      2011-05-06 @476  	while ((XFS_LSN_CMP(lip->li_lsn, target) <= 0)) {
>                                                                                          ^^^^^^

And this path will only be taken if there are items in the AIL,
and in that case we are guaranteed to have initialised target....

Not a bug.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
