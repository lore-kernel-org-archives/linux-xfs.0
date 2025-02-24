Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9506B2571CF
	for <linux-xfs@vger.kernel.org>; Mon, 24 Feb 2025 12:54:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740401642; cv=none; b=JzdclrPZCH8X1MDkLdDtrylibm3G6rCw+s9z83++PgeQuhZA2jHaZwt/Xm8jZZ7cN2qLRvhSRQ4wHWAStqWobIZC6pladNdAuiQBCul5//hb+2iwT92OX92Ym5PA5TsWnLpLdoGibhk75IFqGKJLjAQjOpPahZIQnTyHC7YIVrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740401642; c=relaxed/simple;
	bh=cPqFlN9hhPH5PUCieVKmof6OSDpqARoal3nq00GKLP0=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=fU8N3z0B0bnLjgN3L+kKWP5zn5ip9hjBhoGe77tPTYDG3ce06xHsjYL1eiMYty8yhpp1WUr7VhNX1oisCOFAYWtfzi99MXjdblY3hZJc50H8Rbw7dZyAr8cTka7VqMZXDwEl62NpvWauY8hk+2I2XQ7pcIahureOpf1IuOM8WcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TH57CSHt; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TH57CSHt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740401639;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RyZKAT7kvX4bnRDx3j7DvsDLJEcrsNoetXZGX7kmB2s=;
	b=TH57CSHtoBgRQpYHt2CpKBFcA+t0AZ8In8QcZS2Sn68v871VacaHGEBGLLpTNBEvxQrnp6
	XUSR7/Gim74e/cpuOe2NeDLd5JKbAOXw5LJCiK6vshxLXFlAusq7e3BRxCD11ZavbS9879
	JTU4EkTOQ52jMKtVINiH+ShHeyV2L5U=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-650-sr5YoVDqONGmoayMPwNkzw-1; Mon,
 24 Feb 2025 07:53:56 -0500
X-MC-Unique: sr5YoVDqONGmoayMPwNkzw-1
X-Mimecast-MFC-AGG-ID: sr5YoVDqONGmoayMPwNkzw_1740401634
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E23A51800874;
	Mon, 24 Feb 2025 12:53:53 +0000 (UTC)
Received: from [10.45.224.44] (unknown [10.45.224.44])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A1C9D300018D;
	Mon, 24 Feb 2025 12:53:50 +0000 (UTC)
Date: Mon, 24 Feb 2025 13:53:47 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Jinliang Zheng <alexjlzheng@gmail.com>
cc: agk@redhat.com, snitzer@kernel.org, dm-devel@lists.linux.dev, 
    linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, 
    flyingpeng@tencent.com, txpeng@tencent.com, dchinner@redhat.com, 
    Jinliang Zheng <alexjlzheng@tencent.com>
Subject: Re: [PATCH] dm: fix unconditional IO throttle caused by
 REQ_PREFLUSH
In-Reply-To: <20250220112014.3209940-1-alexjlzheng@tencent.com>
Message-ID: <1931a9db-a81d-daf2-2e89-d1f183946618@redhat.com>
References: <20250220112014.3209940-1-alexjlzheng@tencent.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Applied, thanks.

Mikulas



On Thu, 20 Feb 2025, Jinliang Zheng wrote:

> When a bio with REQ_PREFLUSH is submitted to dm, __send_empty_flush()
> generates a flush_bio with REQ_OP_WRITE | REQ_PREFLUSH | REQ_SYNC,
> which causes the flush_bio to be throttled by wbt_wait().
> 
> An example from v5.4, similar problem also exists in upstream:
> 
>     crash> bt 2091206
>     PID: 2091206  TASK: ffff2050df92a300  CPU: 109  COMMAND: "kworker/u260:0"
>      #0 [ffff800084a2f7f0] __switch_to at ffff80004008aeb8
>      #1 [ffff800084a2f820] __schedule at ffff800040bfa0c4
>      #2 [ffff800084a2f880] schedule at ffff800040bfa4b4
>      #3 [ffff800084a2f8a0] io_schedule at ffff800040bfa9c4
>      #4 [ffff800084a2f8c0] rq_qos_wait at ffff8000405925bc
>      #5 [ffff800084a2f940] wbt_wait at ffff8000405bb3a0
>      #6 [ffff800084a2f9a0] __rq_qos_throttle at ffff800040592254
>      #7 [ffff800084a2f9c0] blk_mq_make_request at ffff80004057cf38
>      #8 [ffff800084a2fa60] generic_make_request at ffff800040570138
>      #9 [ffff800084a2fae0] submit_bio at ffff8000405703b4
>     #10 [ffff800084a2fb50] xlog_write_iclog at ffff800001280834 [xfs]
>     #11 [ffff800084a2fbb0] xlog_sync at ffff800001280c3c [xfs]
>     #12 [ffff800084a2fbf0] xlog_state_release_iclog at ffff800001280df4 [xfs]
>     #13 [ffff800084a2fc10] xlog_write at ffff80000128203c [xfs]
>     #14 [ffff800084a2fcd0] xlog_cil_push at ffff8000012846dc [xfs]
>     #15 [ffff800084a2fda0] xlog_cil_push_work at ffff800001284a2c [xfs]
>     #16 [ffff800084a2fdb0] process_one_work at ffff800040111d08
>     #17 [ffff800084a2fe00] worker_thread at ffff8000401121cc
>     #18 [ffff800084a2fe70] kthread at ffff800040118de4
> 
> After commit 2def2845cc33 ("xfs: don't allow log IO to be throttled"),
> the metadata submitted by xlog_write_iclog() should not be throttled.
> But due to the existence of the dm layer, throttling flush_bio indirectly
> causes the metadata bio to be throttled.
> 
> Fix this by conditionally adding REQ_IDLE to flush_bio.bi_opf, which makes
> wbt_should_throttle() return false to avoid wbt_wait().
> 
> Signed-off-by: Jinliang Zheng <alexjlzheng@tencent.com>
> Reviewed-by: Tianxiang Peng <txpeng@tencent.com>
> Reviewed-by: Hao Peng <flyingpeng@tencent.com>
> ---
>  drivers/md/dm.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index 4d1e42891d24..5ab7574c0c76 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -1540,14 +1540,18 @@ static void __send_empty_flush(struct clone_info *ci)
>  {
>  	struct dm_table *t = ci->map;
>  	struct bio flush_bio;
> +	blk_opf_t opf = REQ_OP_WRITE | REQ_PREFLUSH | REQ_SYNC;
> +
> +	if ((ci->io->orig_bio->bi_opf & (REQ_IDLE | REQ_SYNC)) ==
> +	    (REQ_IDLE | REQ_SYNC))
> +		opf |= REQ_IDLE;
>  
>  	/*
>  	 * Use an on-stack bio for this, it's safe since we don't
>  	 * need to reference it after submit. It's just used as
>  	 * the basis for the clone(s).
>  	 */
> -	bio_init(&flush_bio, ci->io->md->disk->part0, NULL, 0,
> -		 REQ_OP_WRITE | REQ_PREFLUSH | REQ_SYNC);
> +	bio_init(&flush_bio, ci->io->md->disk->part0, NULL, 0, opf);
>  
>  	ci->bio = &flush_bio;
>  	ci->sector_count = 0;
> -- 
> 2.41.1
> 

