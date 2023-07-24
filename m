Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2C9CC41513
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Jul 2023 15:49:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231290AbjGXPtC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Jul 2023 11:49:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231248AbjGXPtB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Jul 2023 11:49:01 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCC62E57
        for <linux-xfs@vger.kernel.org>; Mon, 24 Jul 2023 08:49:00 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id ca18e2360f4ac-785d3a53ed6so45821239f.1
        for <linux-xfs@vger.kernel.org>; Mon, 24 Jul 2023 08:49:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1690213740; x=1690818540;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JxVUVt//RDm7fJf78yJOuIe4ZtlkJolhHRr3i1sX308=;
        b=yu+8+EyPAM0ktL1EsHkJNyG5xHqrXZ9GLEN26LGiwrMZCcenDgelJhegvPh+zwwzi6
         NUlMm5DFcyMTihkzfokLseyT1zaiV4J1SXsKyO6q4NwZ2WItu66zB/LdSbgaw3dYNDnb
         a3q2MwtaaEpSDRWa/BPoU2ZZ4kfDtSjo/L8kVS8ZLFqOc/PA7eFlXyYvmtLZsvNwF53D
         fV6hyTGxVZWNZb8gQJynaslObEECdc6GTIqhfTqUe/GDDjQCIcQ/U/lNjRg/bLN8XkhG
         7GtjU1GzNv45hIFCps28+I9r4YfaCRlV2CucOzIUyyoN8VcDpeJbPraQH2X5h3xoV8OV
         l09w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690213740; x=1690818540;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JxVUVt//RDm7fJf78yJOuIe4ZtlkJolhHRr3i1sX308=;
        b=gzZeR6cG2f7tV5hEuR2qwhJhAI3Yqa6SpD1HPArW4xU+oBAM5i1I0650vUGVuN7qDH
         WpxSZNBvQF9Vq1tX/lc3UaDsUq2Z3VXIIz7FRoCTnPqYlugvEfnC/pzwDooHArRdNSBu
         vmSoAnUaFTD+2ys2gSeHcRQaWa9ew20u6Bk7kt1lEvQuYuRfKTQ7+4krIQOwqMMY4pVT
         60Edf8dZoKkEgAWN6GBh+s5WAnQP6fjZv7tnAHUk20ew8/qxKfoleyNM6tPBBcsxtWEE
         7IaQ3YDC/PVb0XcqptQA/tvnv2ZlhEgJXg4QXPgEpTpqT+xej0bw5HAi2Bkoh+hRaLNi
         hROA==
X-Gm-Message-State: ABy/qLal4+8UgnI49dCKJ+1ZpZkz17AKq0wHpjsEWSfLUNAIYnllI9x7
        yQcZLFvV161rR3Op/BeqkptPKQ==
X-Google-Smtp-Source: APBJJlEyNLdP/VOWDtkD4E6VyjQZol8uAUFfJx1gGeUGkKFibN5/EPic6Z2+gbo5BwXMlvzmV68XEA==
X-Received: by 2002:a92:ad0f:0:b0:346:10c5:2949 with SMTP id w15-20020a92ad0f000000b0034610c52949mr6942788ilh.1.1690213740067;
        Mon, 24 Jul 2023 08:49:00 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id n12-20020a92dd0c000000b003423875af1bsm3098506ilm.1.2023.07.24.08.48.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Jul 2023 08:48:59 -0700 (PDT)
Message-ID: <3d97ae14-dd8d-7f82-395a-ccc17c6156be@kernel.dk>
Date:   Mon, 24 Jul 2023 09:48:58 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH] io_uring: Use io_schedule* in cqring wait
Content-Language: en-US
To:     Phil Elwell <phil@raspberrypi.com>
Cc:     andres@anarazel.de, asml.silence@gmail.com, david@fromorbit.com,
        hch@lst.de, io-uring@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linux-xfs@vger.kernel.org,
        stable <stable@vger.kernel.org>
References: <CAMEGJJ2RxopfNQ7GNLhr7X9=bHXKo+G5OOe0LUq=+UgLXsv1Xg@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAMEGJJ2RxopfNQ7GNLhr7X9=bHXKo+G5OOe0LUq=+UgLXsv1Xg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 7/24/23 9:35?AM, Phil Elwell wrote:
> Hi Andres,
> 
> With this commit applied to the 6.1 and later kernels (others not
> tested) the iowait time ("wa" field in top) in an ARM64 build running
> on a 4 core CPU (a Raspberry Pi 4 B) increases to 25%, as if one core
> is permanently blocked on I/O. The change can be observed after
> installing mariadb-server (no configuration or use is required). After
> reverting just this commit, "wa" drops to zero again.

There are a few other threads on this...

> I can believe that this change hasn't negatively affected performance,
> but the result is misleading. I also think it's pushing the boundaries
> of what a back-port to stable should do.

It's just a cosmetic thing, to be fair, and it makes quite a large
difference on important cases. This is why it also went to stable, which
btw was not Andres's decision at all. I've posted this patch in another
thread as well, but here it is in this thread too - this will limit the
cases that are marked as iowait.


diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 89a611541bc4..f4591b912ea8 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2493,11 +2493,20 @@ int io_run_task_work_sig(struct io_ring_ctx *ctx)
 	return 0;
 }
 
+static bool current_pending_io(void)
+{
+	struct io_uring_task *tctx = current->io_uring;
+
+	if (!tctx)
+		return false;
+	return percpu_counter_read_positive(&tctx->inflight);
+}
+
 /* when returns >0, the caller should retry */
 static inline int io_cqring_wait_schedule(struct io_ring_ctx *ctx,
 					  struct io_wait_queue *iowq)
 {
-	int token, ret;
+	int io_wait, ret;
 
 	if (unlikely(READ_ONCE(ctx->check_cq)))
 		return 1;
@@ -2511,17 +2520,19 @@ static inline int io_cqring_wait_schedule(struct io_ring_ctx *ctx,
 		return 0;
 
 	/*
-	 * Use io_schedule_prepare/finish, so cpufreq can take into account
-	 * that the task is waiting for IO - turns out to be important for low
-	 * QD IO.
+	 * Mark us as being in io_wait if we have pending requests, so cpufreq
+	 * can take into account that the task is waiting for IO - turns out
+	 * to be important for low QD IO.
 	 */
-	token = io_schedule_prepare();
+	io_wait = current->in_iowait;
+	if (current_pending_io())
+		current->in_iowait = 1;
 	ret = 0;
 	if (iowq->timeout == KTIME_MAX)
 		schedule();
 	else if (!schedule_hrtimeout(&iowq->timeout, HRTIMER_MODE_ABS))
 		ret = -ETIME;
-	io_schedule_finish(token);
+	current->in_iowait = io_wait;
 	return ret;
 }
 

-- 
Jens Axboe

