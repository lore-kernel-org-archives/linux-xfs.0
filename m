Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C0471F540F;
	Thu, 20 Feb 2025 11:20:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740050423; cv=none; b=FjnFnFid0nKwQ75wHpd6Kp3Up81bGmK4RuO8n2hJnuvRQVBRElLaebYfzf8s+WKtK0OQ8h2zMwwbJYMPLn/Edy95XXcCllSfLqKJeu6tzkY/jobl0A4+gKjYkfoyFXdX8CQqm+N3+rGJ2inoDjHhuUzyCruaK3bpJqmyIfKHDA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740050423; c=relaxed/simple;
	bh=aB9iYa4f7CgYHrJR8ObpqI3CttJJdJHba49AY45THM8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=B1xMlUokAId9ObZymT5AfqOiOR7uc/pi1tpFyj/7IrvoKdPNDHG8iAsgfbzpSI6iwJQIR+PgzcUMlWIVkGKfPRv5eIPL6RGC7ro+1jacan20W0A1NPaC+SVpsteRrbRzb8vX8Hwif+cny4DQVCtZ6lA+4BajZKv49IFwOS8Ht4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Xf5d4Z0f; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Xf5d4Z0f"
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-2fc4418c0e1so3256932a91.1;
        Thu, 20 Feb 2025 03:20:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740050422; x=1740655222; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=RDdAz+z00kXmgO7AxUttI27htMRIY711jJ3qwv4+HTs=;
        b=Xf5d4Z0fl+4W8nQJZuogOPMiqEM0dra9OpcznQWZ6/OH0MY0rObny/XWK3NOynOM7N
         I9MAIqoXAIUR33dlfFUyjKgMvDbzs9q1p+iUeZA4yDtKCRhEBdOiabVRrg0EVFGGKqyx
         kdS/dUIO7/POOrPmTHORLFPovbg4mnIevXjfOcEisiCC61fQCc/SbxHI0yxF36jAGeJl
         mVuRRJVohJSsuh3W1btXRELoiCCUi2WcIV/uf9/1SBWGEeFPIg4/nLjNPJyEHf/XwBWu
         +pXMrVW9wg96ZVmGV/8YfbgHV4iV0Rnpj07eew0H+GUi5K5YMCLWKlQlxmVUOlKM9KSV
         bHZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740050422; x=1740655222;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RDdAz+z00kXmgO7AxUttI27htMRIY711jJ3qwv4+HTs=;
        b=syuqwGWCNAyuqbQ1Ygn9MFrSHZRjaqcXxMf6afKo/0m+IvGmx/0gzuiQpIrEXnm48o
         jcMT2886WhjpD3PBHFAIPPZeiDs4Fxwg4NLeKh2WfDKhpLr0ldX4OzF2MZa7bDKE29mZ
         dd95NNZupvsWGyo9kXiVys0o0rl6iRw2jZq0iGS4ZXvhpuKCOAF39810eOPER1qCxCCo
         2gvqruJ7TdUnCJV93o6TTZ9vrrMm5sd1GHzLlw1oE1E1Nl70WjT2X4OWNR7+QZQ3TIgq
         I1JHyt5WC4iBJvzE9NPQlM5JFaA2B1wrjwPbBdwrp/oO48UYk7Tcd/44KAeeEhcpFwMd
         ENKg==
X-Forwarded-Encrypted: i=1; AJvYcCWE8NLxS+2cJG3q4KgjAlYFer4xRIw5FjTKT+pcfFgu+EaMYLvYuLOEta7X4JC2Uk3NQtqBz+gaXRq7j90=@vger.kernel.org, AJvYcCWI/7ladKX9FYDiXMI6lFJXuMWvS0Wmp/aoskwhxiZ7zogreSASwjyxdSOYhHw9KGlwyGqT4Z6gf27N@vger.kernel.org
X-Gm-Message-State: AOJu0YxKJXxJefc1jP34V8ZiqH65S3F4nqehixC6PCB4PmLSs47vO+kY
	Ixr60UYWHHt2FRvya56ijrMo0ZnS+ZkDuTzZG91Z0yWgfzfGCi/S
X-Gm-Gg: ASbGnctDZhEi/FMYrzSVkqU3Vg872R1qIGH2VE58Ohf2VEjF1YwB0i5eKvZy/tHcTdW
	lE56VoobzE+IqYUX+qaDSdESM78DFDXO5BiIIBoK06qP+N0V1Vgi3DQUEA0bWaehpY4HBjNC4wH
	AsUhx6358jSfDOI3mJl1uNXJbQ8KoaOJLgvRd2mcOeDhNTf8NsuP0zha3jHSlIGITWIst78uAwX
	IZiAA/VJS5RtW1+3TBVCYcCwArAkrj3VMvf7Tjbsv7G5stYcHIO8OIPsprYZj080xfOqvfkorMd
	+scoJZMItHbwTiGej7puLq0CuJMfLrM=
X-Google-Smtp-Source: AGHT+IGV4jQprhKqJGmQUGNTjzYtK0gBBu6xHVZW9GbADGQiOwx9wMtZT6Y4K+Qo0qZ7VcdtJx1nEQ==
X-Received: by 2002:a05:6a21:6b18:b0:1e1:b105:158f with SMTP id adf61e73a8af0-1eee2fda2dbmr4692334637.19.1740050421582;
        Thu, 20 Feb 2025 03:20:21 -0800 (PST)
Received: from localhost.localdomain ([119.28.17.178])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-adcbe0311b6sm10704374a12.56.2025.02.20.03.20.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Feb 2025 03:20:21 -0800 (PST)
From: Jinliang Zheng <alexjlzheng@gmail.com>
X-Google-Original-From: Jinliang Zheng <alexjlzheng@tencent.com>
To: agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com
Cc: dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	flyingpeng@tencent.com,
	txpeng@tencent.com,
	dchinner@redhat.com,
	Jinliang Zheng <alexjlzheng@tencent.com>
Subject: [PATCH] dm: fix unconditional IO throttle caused by REQ_PREFLUSH
Date: Thu, 20 Feb 2025 19:20:14 +0800
Message-ID: <20250220112014.3209940-1-alexjlzheng@tencent.com>
X-Mailer: git-send-email 2.41.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When a bio with REQ_PREFLUSH is submitted to dm, __send_empty_flush()
generates a flush_bio with REQ_OP_WRITE | REQ_PREFLUSH | REQ_SYNC,
which causes the flush_bio to be throttled by wbt_wait().

An example from v5.4, similar problem also exists in upstream:

    crash> bt 2091206
    PID: 2091206  TASK: ffff2050df92a300  CPU: 109  COMMAND: "kworker/u260:0"
     #0 [ffff800084a2f7f0] __switch_to at ffff80004008aeb8
     #1 [ffff800084a2f820] __schedule at ffff800040bfa0c4
     #2 [ffff800084a2f880] schedule at ffff800040bfa4b4
     #3 [ffff800084a2f8a0] io_schedule at ffff800040bfa9c4
     #4 [ffff800084a2f8c0] rq_qos_wait at ffff8000405925bc
     #5 [ffff800084a2f940] wbt_wait at ffff8000405bb3a0
     #6 [ffff800084a2f9a0] __rq_qos_throttle at ffff800040592254
     #7 [ffff800084a2f9c0] blk_mq_make_request at ffff80004057cf38
     #8 [ffff800084a2fa60] generic_make_request at ffff800040570138
     #9 [ffff800084a2fae0] submit_bio at ffff8000405703b4
    #10 [ffff800084a2fb50] xlog_write_iclog at ffff800001280834 [xfs]
    #11 [ffff800084a2fbb0] xlog_sync at ffff800001280c3c [xfs]
    #12 [ffff800084a2fbf0] xlog_state_release_iclog at ffff800001280df4 [xfs]
    #13 [ffff800084a2fc10] xlog_write at ffff80000128203c [xfs]
    #14 [ffff800084a2fcd0] xlog_cil_push at ffff8000012846dc [xfs]
    #15 [ffff800084a2fda0] xlog_cil_push_work at ffff800001284a2c [xfs]
    #16 [ffff800084a2fdb0] process_one_work at ffff800040111d08
    #17 [ffff800084a2fe00] worker_thread at ffff8000401121cc
    #18 [ffff800084a2fe70] kthread at ffff800040118de4

After commit 2def2845cc33 ("xfs: don't allow log IO to be throttled"),
the metadata submitted by xlog_write_iclog() should not be throttled.
But due to the existence of the dm layer, throttling flush_bio indirectly
causes the metadata bio to be throttled.

Fix this by conditionally adding REQ_IDLE to flush_bio.bi_opf, which makes
wbt_should_throttle() return false to avoid wbt_wait().

Signed-off-by: Jinliang Zheng <alexjlzheng@tencent.com>
Reviewed-by: Tianxiang Peng <txpeng@tencent.com>
Reviewed-by: Hao Peng <flyingpeng@tencent.com>
---
 drivers/md/dm.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 4d1e42891d24..5ab7574c0c76 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1540,14 +1540,18 @@ static void __send_empty_flush(struct clone_info *ci)
 {
 	struct dm_table *t = ci->map;
 	struct bio flush_bio;
+	blk_opf_t opf = REQ_OP_WRITE | REQ_PREFLUSH | REQ_SYNC;
+
+	if ((ci->io->orig_bio->bi_opf & (REQ_IDLE | REQ_SYNC)) ==
+	    (REQ_IDLE | REQ_SYNC))
+		opf |= REQ_IDLE;
 
 	/*
 	 * Use an on-stack bio for this, it's safe since we don't
 	 * need to reference it after submit. It's just used as
 	 * the basis for the clone(s).
 	 */
-	bio_init(&flush_bio, ci->io->md->disk->part0, NULL, 0,
-		 REQ_OP_WRITE | REQ_PREFLUSH | REQ_SYNC);
+	bio_init(&flush_bio, ci->io->md->disk->part0, NULL, 0, opf);
 
 	ci->bio = &flush_bio;
 	ci->sector_count = 0;
-- 
2.41.1

