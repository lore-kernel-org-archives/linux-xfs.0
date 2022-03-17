Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FE67C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Mar 2022 09:12:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231755AbiCQJOG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Mar 2022 05:14:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230307AbiCQJOF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Mar 2022 05:14:05 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AE7CE728B
        for <linux-xfs@vger.kernel.org>; Thu, 17 Mar 2022 02:12:49 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 5788421110;
        Thu, 17 Mar 2022 09:12:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1647508368; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iHQtB7lyFU+K2r0Jct93UoLAulQiCsBBFXE6M+b0tFE=;
        b=Ke1FKEh+rF8XDQpE89d4i7is7B6gi18RaoT3f4yIjpdlQM7A0DFbFcFFBAz5JAmsO5f/80
        GkFDPz0xHuf4FkYhh+rNa5cM+LDDIU1HJrrhkDjpHQ3+Lk/BnVbpPYkMAkK+f0xRmvmO8f
        W90PNiTMf3cGUNPY0MqcjjMFqiUdGXU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1647508368;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iHQtB7lyFU+K2r0Jct93UoLAulQiCsBBFXE6M+b0tFE=;
        b=ii6MdISH2+vuAvXwB+N2fffYW5jikVb64877ShTywoF3c2ZSy8Tq/nZziv0lu4H8bN46Y5
        8XPLzdsLbIZFliCA==
Received: from quack3.suse.cz (unknown [10.100.200.198])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 3CCA1A3B87;
        Thu, 17 Mar 2022 09:12:48 +0000 (UTC)
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id 5A187A0615; Thu, 17 Mar 2022 10:12:47 +0100 (CET)
Date:   Thu, 17 Mar 2022 10:12:47 +0100
From:   Jan Kara <jack@suse.cz>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, jack@suse.cz
Subject: Re: [PATCH] xfs: drop async cache flushes from CIL commits.
Message-ID: <20220317091247.ajk3astyxmmghrsf@quack3.lan>
References: <20220317051219.137547-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220317051219.137547-1-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu 17-03-22 16:12:19, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Jan Kara reported a performance regression in dbench that he
> bisected down to commit bad77c375e8d ("xfs: CIL checkpoint
> flushes caches unconditionally").
> 
> Whilst developing the journal flush/fua optimisations this cache was
> part of, it appeared to made a significant difference to
> performance. However, now that this patchset has settled and all the
> correctness issues fixed, there does not appear to be any
> significant performance benefit to asynchronous cache flushes.
> 
> In fact, the opposite is true on some storage types and workloads,
> where additional cache flushes that can occur from fsync heavy
> workloads have measurable and significant impact on overall
> throughput.
> 
> Local dbench testing shows little difference on dbench runs with
> sync vs async cache flushes on either fast or slow SSD storage, and
> no difference in streaming concurrent async transaction workloads
> like fs-mark.
> 
> Fast NVME storage.
> 
> From `dbench -t 30`, CIL scale:
> 
> clients		async			sync
> 		BW	Latency		BW	Latency
> 1		 935.18   0.855		 915.64   0.903
> 8		2404.51   6.873		2341.77   6.511
> 16		3003.42   6.460		2931.57   6.529
> 32		3697.23   7.939		3596.28   7.894
> 128		7237.43  15.495		7217.74  11.588
> 512		5079.24  90.587		5167.08  95.822
> 
> fsmark, 32 threads, create w/ 64 byte xattr w/32k logbsize
> 
> 	create		chown		unlink
> async   1m41s		1m16s		2m03s
> sync	1m40s		1m19s		1m54s
> 
> Slower SATA SSD storage:
> 
> From `dbench -t 30`, CIL scale:
> 
> clients		async			sync
> 		BW	Latency		BW	Latency
> 1		  78.59  15.792		  83.78  10.729
> 8		 367.88  92.067		 404.63  59.943
> 16		 564.51  72.524		 602.71  76.089
> 32		 831.66 105.984		 870.26 110.482
> 128		1659.76 102.969		1624.73  91.356
> 512		2135.91 223.054		2603.07 161.160
> 
> fsmark, 16 threads, create w/32k logbsize
> 
> 	create		unlink
> async   5m06s		4m15s
> sync	5m00s		4m22s
> 
> And on Jan's test machine:
> 
>                    5.18-rc8-vanilla       5.18-rc8-patched
> Amean     1        71.22 (   0.00%)       64.94 *   8.81%*
> Amean     2        93.03 (   0.00%)       84.80 *   8.85%*
> Amean     4       150.54 (   0.00%)      137.51 *   8.66%*
> Amean     8       252.53 (   0.00%)      242.24 *   4.08%*
> Amean     16      454.13 (   0.00%)      439.08 *   3.31%*
> Amean     32      835.24 (   0.00%)      829.74 *   0.66%*
> Amean     64     1740.59 (   0.00%)     1686.73 *   3.09%*
> 
> Performance and cache flush behaviour is restored to pre-regression
> levels.
> 
> As such, we can now consider the async cache flush mechanism an
> unnecessary exercise in premature optimisation and hence we can
> now remove it and the infrastructure it requires completely.
> 
> Fixes: bad77c375e8d ("xfs: CIL checkpoint flushes caches unconditionally")
> Reported-and-tested-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Thanks!

> @@ -1058,7 +1048,7 @@ xlog_cil_push_work(
>  	 * Before we format and submit the first iclog, we have to ensure that
>  	 * the metadata writeback ordering cache flush is complete.
>  	 */
> -	wait_for_completion(&bdev_flush);
> +//	wait_for_completion(&bdev_flush);
>  
>  	error = xlog_cil_write_chain(ctx, &lvhdr);
>  	if (error)

I guess this should be removed instead of commented-out...

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
