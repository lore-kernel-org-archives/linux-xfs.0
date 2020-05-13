Return-Path: <SRS0=Dhh5=63=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AA0DC433DF
	for <linux-xfs@archiver.kernel.org>; Wed, 13 May 2020 17:02:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 795EB205CB
	for <linux-xfs@archiver.kernel.org>; Wed, 13 May 2020 17:02:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cQ9lG10o"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389507AbgEMRCu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 13 May 2020 13:02:50 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:23482 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728068AbgEMRCu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 May 2020 13:02:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589389367;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OslGx+K+sJ4LoTrXDHjH+946ysPoWr6IL7nvpabEvB0=;
        b=cQ9lG10osVzLq3cxAYsjSqBGYcTBS1b94eJTyQHJ6qcJOL8rWRoHsFA1uiG1d7W5zxwsms
        GPO6OtOq00PEmVtuXWZcOYw1qIuzToebS4TSToceNtepW8l2CTGo2TvjNScLRm3bwyhsZt
        SxjitZ1kSng8MEkZFGhmt6fNQ3nYP3U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-493-5BK4e3m5MbCoGImMvLISbA-1; Wed, 13 May 2020 13:02:40 -0400
X-MC-Unique: 5BK4e3m5MbCoGImMvLISbA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DAA7883DB78;
        Wed, 13 May 2020 17:02:39 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 85B525D9C5;
        Wed, 13 May 2020 17:02:39 +0000 (UTC)
Date:   Wed, 13 May 2020 13:02:37 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/5] [RFC] xfs: per-cpu CIL lists
Message-ID: <20200513170237.GB45326@bfoster>
References: <20200512092811.1846252-1-david@fromorbit.com>
 <20200512092811.1846252-5-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200512092811.1846252-5-david@fromorbit.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 12, 2020 at 07:28:10PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Next on the list to getting rid of the xc_cil_lock is making the CIL
> itself per-cpu.
> 
> This requires a trade-off: we no longer move items forward in the
> CIL; once they are on the CIL they remain there as we treat the
> percpu lists as lockless.
> 
> XXX: preempt_disable() around the list operations to ensure they
> stay local to the CPU.
> 
> XXX: this needs CPU hotplug notifiers to clean up when cpus go
> offline.
> 
> Performance now increases substantially - the transaction rate goes
> from 750,000/s to 1.05M/sec, and the unlink rate is over 500,000/s
> for the first time.
> 
> Using a 32-way concurrent create/unlink on a 32p/16GB virtual
> machine:
> 
> 	    create time     rate            unlink time
> unpatched	1m56s      533k/s+/-28k/s      2m34s
> patched		1m49s	   523k/s+/-14k/s      2m00s
> 
> Notably, the system time for the create went up, while variance went
> down. This indicates we're starting to hit some other contention
> limit as we reduce the amount of time we spend contending on the
> xc_cil_lock.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_log_cil.c  | 66 ++++++++++++++++++++++++++++---------------
>  fs/xfs/xfs_log_priv.h |  2 +-
>  2 files changed, 45 insertions(+), 23 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index 746c841757ed1..af444bc69a7cd 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
...
> @@ -687,7 +689,7 @@ xlog_cil_push_work(
>  	 * move on to a new sequence number and so we have to be able to push
>  	 * this sequence again later.
>  	 */
> -	if (list_empty(&cil->xc_cil)) {
> +	if (percpu_counter_read(&cil->xc_curr_res) == 0) {

It seems reasonable, but I need to think a bit more about the whole
percpu list thing. In the meantime, one thing that comes to mind is the
more of these list_empty() -> percpu_counter_read() translations I see
the less I like it because we're leaking this inherent raciness to
different contexts. Whether it's ultimately safe or not, it's subject to
change and far too subtle and indirect for my taste. 

Could we replace all of the direct ->xc_cil list checks with an atomic
bitop (i.e. XLOG_CIL_EMPTY) or something similar in the xfs_cil? AFAICT,
that could be done in a separate patch and we could ultimately reuse it
to close the race with the initial ctx reservation (via
test_and_set_bit()) because it's otherwise set in the same function. Hm?

Brian

>  		cil->xc_push_seq = 0;
>  		spin_unlock(&cil->xc_push_lock);
>  		goto out_skip;
> @@ -728,17 +730,21 @@ xlog_cil_push_work(
>  	spin_unlock(&cil->xc_push_lock);
>  
>  	/*
> -	 * pull all the log vectors off the items in the CIL, and
> -	 * remove the items from the CIL. We don't need the CIL lock
> -	 * here because it's only needed on the transaction commit
> -	 * side which is currently locked out by the flush lock.
> +	 * Remove the items from the per-cpu CIL lists and then pull all the
> +	 * log vectors off the items. We hold the xc_ctx_lock exclusively here,
> +	 * so nothing can be adding or removing from the per-cpu lists here.
>  	 */
> +	/* XXX: hotplug! */
> +	for_each_online_cpu(cpu) {
> +		list_splice_tail_init(per_cpu_ptr(cil->xc_cil, cpu), &cil_items);
> +	}
> +
>  	lv = NULL;
>  	num_iovecs = 0;
> -	while (!list_empty(&cil->xc_cil)) {
> +	while (!list_empty(&cil_items)) {
>  		struct xfs_log_item	*item;
>  
> -		item = list_first_entry(&cil->xc_cil,
> +		item = list_first_entry(&cil_items,
>  					struct xfs_log_item, li_cil);
>  		list_del_init(&item->li_cil);
>  		if (!ctx->lv_chain)
> @@ -927,7 +933,7 @@ xlog_cil_push_background(
>  	 * The cil won't be empty because we are called while holding the
>  	 * context lock so whatever we added to the CIL will still be there
>  	 */
> -	ASSERT(!list_empty(&cil->xc_cil));
> +	ASSERT(space_used != 0);
>  
>  	/*
>  	 * don't do a background push if we haven't used up all the
> @@ -993,7 +999,8 @@ xlog_cil_push_now(
>  	 * there's no work we need to do.
>  	 */
>  	spin_lock(&cil->xc_push_lock);
> -	if (list_empty(&cil->xc_cil) || push_seq <= cil->xc_push_seq) {
> +	if (percpu_counter_read(&cil->xc_curr_res) == 0 ||
> +	    push_seq <= cil->xc_push_seq) {
>  		spin_unlock(&cil->xc_push_lock);
>  		return;
>  	}
> @@ -1011,7 +1018,7 @@ xlog_cil_empty(
>  	bool		empty = false;
>  
>  	spin_lock(&cil->xc_push_lock);
> -	if (list_empty(&cil->xc_cil))
> +	if (percpu_counter_read(&cil->xc_curr_res) == 0)
>  		empty = true;
>  	spin_unlock(&cil->xc_push_lock);
>  	return empty;
> @@ -1163,7 +1170,7 @@ xlog_cil_force_lsn(
>  	 * we would have found the context on the committing list.
>  	 */
>  	if (sequence == cil->xc_current_sequence &&
> -	    !list_empty(&cil->xc_cil)) {
> +	    percpu_counter_read(&cil->xc_curr_res) != 0) {
>  		spin_unlock(&cil->xc_push_lock);
>  		goto restart;
>  	}
> @@ -1223,6 +1230,7 @@ xlog_cil_init(
>  	struct xfs_cil	*cil;
>  	struct xfs_cil_ctx *ctx;
>  	int		error = -ENOMEM;
> +	int		cpu;
>  
>  	cil = kmem_zalloc(sizeof(*cil), KM_MAYFAIL);
>  	if (!cil)
> @@ -1232,16 +1240,24 @@ xlog_cil_init(
>  	if (!ctx)
>  		goto out_free_cil;
>  
> +	/* XXX: CPU hotplug!!! */
> +	cil->xc_cil = alloc_percpu_gfp(struct list_head, GFP_KERNEL);
> +	if (!cil->xc_cil)
> +		goto out_free_ctx;
> +
> +	for_each_possible_cpu(cpu) {
> +		INIT_LIST_HEAD(per_cpu_ptr(cil->xc_cil, cpu));
> +	}
> +
>  	error = percpu_counter_init(&cil->xc_space_used, 0, GFP_KERNEL);
>  	if (error)
> -		goto out_free_ctx;
> +		goto out_free_pcp_cil;
>  
>  	error = percpu_counter_init(&cil->xc_curr_res, 0, GFP_KERNEL);
>  	if (error)
>  		goto out_free_space;
>  
>  	INIT_WORK(&cil->xc_push_work, xlog_cil_push_work);
> -	INIT_LIST_HEAD(&cil->xc_cil);
>  	INIT_LIST_HEAD(&cil->xc_committing);
>  	spin_lock_init(&cil->xc_cil_lock);
>  	spin_lock_init(&cil->xc_push_lock);
> @@ -1262,6 +1278,8 @@ xlog_cil_init(
>  
>  out_free_space:
>  	percpu_counter_destroy(&cil->xc_space_used);
> +out_free_pcp_cil:
> +	free_percpu(cil->xc_cil);
>  out_free_ctx:
>  	kmem_free(ctx);
>  out_free_cil:
> @@ -1274,6 +1292,7 @@ xlog_cil_destroy(
>  	struct xlog	*log)
>  {
>  	struct xfs_cil  *cil = log->l_cilp;
> +	int		cpu;
>  
>  	if (cil->xc_ctx) {
>  		if (cil->xc_ctx->ticket)
> @@ -1283,7 +1302,10 @@ xlog_cil_destroy(
>  	percpu_counter_destroy(&cil->xc_space_used);
>  	percpu_counter_destroy(&cil->xc_curr_res);
>  
> -	ASSERT(list_empty(&cil->xc_cil));
> +	for_each_possible_cpu(cpu) {
> +		ASSERT(list_empty(per_cpu_ptr(cil->xc_cil, cpu)));
> +	}
> +	free_percpu(cil->xc_cil);
>  	kmem_free(cil);
>  }
>  
> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> index f5e79a7d44c8e..0bb982920d070 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -264,7 +264,7 @@ struct xfs_cil {
>  	struct xlog		*xc_log;
>  	struct percpu_counter	xc_space_used;
>  	struct percpu_counter	xc_curr_res;
> -	struct list_head	xc_cil;
> +	struct list_head __percpu *xc_cil;
>  	spinlock_t		xc_cil_lock;
>  
>  	struct rw_semaphore	xc_ctx_lock ____cacheline_aligned_in_smp;
> -- 
> 2.26.1.301.g55bc3eb7cb9
> 

