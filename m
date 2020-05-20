Return-Path: <SRS0=A2Vo=7C=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9CE0C433E0
	for <linux-xfs@archiver.kernel.org>; Wed, 20 May 2020 07:01:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 793C220756
	for <linux-xfs@archiver.kernel.org>; Wed, 20 May 2020 07:01:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="crcHrTqN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726425AbgETHBx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 May 2020 03:01:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726369AbgETHBw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 May 2020 03:01:52 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEC1FC061A0E
        for <linux-xfs@vger.kernel.org>; Wed, 20 May 2020 00:01:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=9HG7oB88+Ec/hAoAPsWB5bdy5mGseAU0sAsBscxpHCA=; b=crcHrTqNozHKzjDWZF9a0lV9YV
        Yee6S2W/dtL4jQmIzKmP1R2droUCHVrNigu3hEIbxjmuUozTUTHLCcOT2eWNtss1bcqJFBf1ncyds
        fFOesc28/nrfU+clkXOq0CWoKyGrxwvAb9wWpxMgeMaI9fKfOG89sm/ihCvaI2aEjaaSMmhXPyt0i
        1fCeo8CRud/7Scw/HGytSE1e0efz6y746AsRN1KR/YUzlsty0siFCMWnQw0WbD9wSldEQTb2EGIto
        mukahpryoj9519As613hfmfFstp5e5wBrhTBlB3azdDCDnzwJkJtXaHIrD8FguMCmOEwGlPrtdx2D
        wq+vp9Kw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jbIjg-0006xQ-If; Wed, 20 May 2020 07:01:52 +0000
Date:   Wed, 20 May 2020 00:01:52 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: remove the m_active_trans counter
Message-ID: <20200520070152.GD25811@infradead.org>
References: <20200519222310.2576434-1-david@fromorbit.com>
 <20200519222310.2576434-3-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200519222310.2576434-3-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 20, 2020 at 08:23:10AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> It's a global atomic counter, and we are hitting it at a rate of
> half a million transactions a second, so it's bouncing the counter
> cacheline all over the place on large machines. We don't actually
> need it anymore - it used to be required because the VFS freeze code
> could not track/prevent filesystem transactions that were running,
> but that problem no longer exists.
> 
> Hence to remove the counter, we simply have to ensure that nothing
> calls xfs_sync_sb() while we are trying to quiesce the filesytem.
> That only happens if the log worker is still running when we call
> xfs_quiesce_attr(). The log worker is cancelled at the end of
> xfs_quiesce_attr() by calling xfs_log_quiesce(), so just call it
> early here and then we can remove the counter altogether.
> 
> Concurrent create, 50 million inodes, identical 16p/16GB virtual
> machines on different physical hosts. Machine A has twice the CPU
> cores per socket of machine B:
> 
> 		unpatched	patched
> machine A:	3m16s		2m00s
> machine B:	4m04s		4m05s
> 
> Create rates:
> 		unpatched	patched
> machine A:	282k+/-31k	468k+/-21k
> machine B:	231k+/-8k	233k+/-11k
> 
> Concurrent rm of same 50 million inodes:
> 
> 		unpatched	patched
> machine A:	6m42s		2m33s
> machine B:	4m47s		4m47s
> 
> The transaction rate on the fast machine went from just under
> 300k/sec to 700k/sec, which indicates just how much of a bottleneck
> this atomic counter was.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_mount.h |  1 -
>  fs/xfs/xfs_super.c | 17 +++++------------
>  fs/xfs/xfs_trans.c | 27 +++++++++++----------------
>  3 files changed, 16 insertions(+), 29 deletions(-)
> 
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index c1f92c1847bb2..3725d25ad97e8 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -176,7 +176,6 @@ typedef struct xfs_mount {
>  	uint64_t		m_resblks;	/* total reserved blocks */
>  	uint64_t		m_resblks_avail;/* available reserved blocks */
>  	uint64_t		m_resblks_save;	/* reserved blks @ remount,ro */
> -	atomic_t		m_active_trans;	/* number trans frozen */
>  	struct delayed_work	m_reclaim_work;	/* background inode reclaim */
>  	struct delayed_work	m_eofblocks_work; /* background eof blocks
>  						     trimming */
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index aae469f73efeb..fa58cb07c8fdf 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -874,8 +874,10 @@ xfs_restore_resvblks(struct xfs_mount *mp)
>   * there is no log replay required to write the inodes to disk - this is the
>   * primary difference between a sync and a quiesce.
>   *
> + * We cancel log work early here to ensure all transactions the log worker may
> + * run have finished before we clean up and log the superblock and write an
> + * unmount record. The unfreeze process is responsible for restarting the log
> + * worker correctly.
>   */
>  void
>  xfs_quiesce_attr(
> @@ -883,9 +885,7 @@ xfs_quiesce_attr(
>  {
>  	int	error = 0;
>  
> -	/* wait for all modifications to complete */
> -	while (atomic_read(&mp->m_active_trans) > 0)
> -		delay(100);
> +	cancel_delayed_work_sync(&mp->m_log->l_work);

Shouldn't the cancel_delayed_work_sync for l_work in xfs_log_quiesce
be removed now given that we've already cancelled it here?
