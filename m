Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5441482EF
	for <linux-xfs@vger.kernel.org>; Sun,  6 Oct 2024 14:53:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728226382; cv=none; b=LW5eNKnCKVQaOHqUgYYOcd7navD2H7MCdgJSeweB4a59yIIj8PAgvNNAt9aQKYu6SENbzut4naNFyWCpIm26z7FqDzx2UUSaL/a3uF4G4hDNRmNtQTLNHWOGFlISP+kZXNxRo1IdHF7c38J/RwjUg/W0pHqTg/JSyf/zFk1Rq+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728226382; c=relaxed/simple;
	bh=aUA1bM8P1Ew8vQnt7B9NnQGncWdEinSrEJ/F9sbP0Yw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Doukh1GnWBe8er+tCvB8bam+gJCxbKOUcLSZm1kqej/9R3yoWk2vQcFT+aqF/ml39ChW74t9W8aQsjXagBMLZjyF5fmaQfe44+oVxHZXcYF9CJdDXvb7Mo5swDeV+OMZ6UKupR3/22u2VBtqYbbX0Oyeem821CMVHz2MxEk6PqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=shopee.com; spf=pass smtp.mailfrom=shopee.com; dkim=pass (2048-bit key) header.d=shopee.com header.i=@shopee.com header.b=UqcEU7c8; arc=none smtp.client-ip=209.85.215.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=shopee.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shopee.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shopee.com header.i=@shopee.com header.b="UqcEU7c8"
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-7db90a28cf6so3065061a12.0
        for <linux-xfs@vger.kernel.org>; Sun, 06 Oct 2024 07:53:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shopee.com; s=shopee.com; t=1728226380; x=1728831180; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2N3sStJpxaR2HR+abJXgKtrpDLoMQudskN/sLQC1NOU=;
        b=UqcEU7c8PNl2etyuIiEZvkWioZe2OicNj67J8AhtdKEgQqqysFRaezha7Iw06uT/pY
         OdTZCwGNB5PvzuS9cCTAwlsZBqYlymlYdZto4Tmc5yoyQvsGF6bVe9QpOjXCiF+hvMgR
         E+VCn5MRKxrRIDmGVSy6NRt33iE8wcnlfxcybIEi3050FsoYXdvDPZp8+4Tkv7HSkw69
         w/1gi7Lm4ACq8+9/h4SbaEsit8iNPfORdxoe9byfx7Qk2eFaX+q9d6ht1tuH84TN9eIe
         h2N9qNYyWwEVkaTsH0rr9W3stO+xP4x/toCHznr5izoX0i1wGNPHvbO5ULO89cDr7qgu
         fMoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728226380; x=1728831180;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2N3sStJpxaR2HR+abJXgKtrpDLoMQudskN/sLQC1NOU=;
        b=Qm7cUMdUDKJTSv/DzToeGnY9bML+Nh5MsXaE+GlYWmlS7vUcr1XKUmpack4moi0uEJ
         dbBH5/GUE3R5kGuJ24vbRX/Y/B4Vgy2dY5gJRWQBzA3r2Y14JALRUXU+Z0ng5aQw9BIW
         WmVtjFFe/z+M15+nP+CYnxwtyg30G+w1CUdHi9HFixCS3N2TN+3z62YjP9B8x50NRBbr
         5HYdF1xPHpPotZaU4g5daimJrdE9vyeq9gQul114OkFlDAovzwsZ+RVewLhOvMbzvEe3
         bbeSd71okQv5JH5D088XrhueaF5qKZ3GCv2z8OFI3L4fHYxAh9DbE12LuPKcnNDJn8W6
         9Edw==
X-Forwarded-Encrypted: i=1; AJvYcCUsYJZzxwqaBGPiON3MjHIL5ajRUFVY6JZg3t5PLPQtLyHc0/j5hBA5ULnQfCURMPL4G/3dhqzuu00=@vger.kernel.org
X-Gm-Message-State: AOJu0YxTwCYg6gkEjqHlsFUoZBhBmf44DSYClZvOBegQWGQiZ0dDUzoF
	JyOKfqnQIJZeyTooZcRBq9j1+OnZQol4pqR4e8gwIVP6qVoiQcgsZFMUEeP2JLs=
X-Google-Smtp-Source: AGHT+IHG4IQr7deYQUJRIYz9fhcCuV66BnPCOFrXxZCcjoVgw9zfF27tSDdPFaL2+eQyuT6EmIQ+7w==
X-Received: by 2002:a17:90a:fb8b:b0:2e0:7580:6853 with SMTP id 98e67ed59e1d1-2e1e5dba9e2mr12443142a91.17.1728226380265;
        Sun, 06 Oct 2024 07:53:00 -0700 (PDT)
Received: from localhost.localdomain ([143.92.64.17])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e1e8664bfasm5213680a91.44.2024.10.06.07.52.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Oct 2024 07:52:59 -0700 (PDT)
From: Tang Yizhou <yizhou.tang@shopee.com>
X-Google-Original-From: Tang Yizhou
To: jack@suse.cz,
	hch@infradead.org,
	willy@infradead.org,
	akpm@linux-foundation.org,
	chandan.babu@oracle.com
Cc: linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	Tang Yizhou <yizhou.tang@shopee.com>
Subject: [PATCH v2 1/3] mm/page-writeback.c: Rename BANDWIDTH_INTERVAL to BW_DIRTYLIMIT_INTERVAL
Date: Sun,  6 Oct 2024 23:28:47 +0800
Message-Id: <20241006152849.247152-2-yizhou.tang@shopee.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20241006152849.247152-1-yizhou.tang@shopee.com>
References: <20241006152849.247152-1-yizhou.tang@shopee.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Tang Yizhou <yizhou.tang@shopee.com>

The name of the BANDWIDTH_INTERVAL macro is misleading, as it is not
only used in the bandwidth update functions wb_update_bandwidth() and
__wb_update_bandwidth(), but also in the dirty limit update function
domain_update_dirty_limit().

Rename BANDWIDTH_INTERVAL to BW_DIRTYLIMIT_INTERVAL to make things clear.

This patche doesn't introduce any behavioral changes.

v2: Rename UPDATE_INTERVAL to BW_DIRTYLIMIT_INTERVAL.

Signed-off-by: Tang Yizhou <yizhou.tang@shopee.com>
---
 mm/page-writeback.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index fcd4c1439cb9..3af7bc078dc0 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -54,9 +54,9 @@
 #define DIRTY_POLL_THRESH	(128 >> (PAGE_SHIFT - 10))
 
 /*
- * Estimate write bandwidth at 200ms intervals.
+ * Estimate write bandwidth or update dirty limit at 200ms intervals.
  */
-#define BANDWIDTH_INTERVAL	max(HZ/5, 1)
+#define BW_DIRTYLIMIT_INTERVAL	max(HZ/5, 1)
 
 #define RATELIMIT_CALC_SHIFT	10
 
@@ -1331,11 +1331,11 @@ static void domain_update_dirty_limit(struct dirty_throttle_control *dtc,
 	/*
 	 * check locklessly first to optimize away locking for the most time
 	 */
-	if (time_before(now, dom->dirty_limit_tstamp + BANDWIDTH_INTERVAL))
+	if (time_before(now, dom->dirty_limit_tstamp + BW_DIRTYLIMIT_INTERVAL))
 		return;
 
 	spin_lock(&dom->lock);
-	if (time_after_eq(now, dom->dirty_limit_tstamp + BANDWIDTH_INTERVAL)) {
+	if (time_after_eq(now, dom->dirty_limit_tstamp + BW_DIRTYLIMIT_INTERVAL)) {
 		update_dirty_limit(dtc);
 		dom->dirty_limit_tstamp = now;
 	}
@@ -1928,7 +1928,7 @@ static int balance_dirty_pages(struct bdi_writeback *wb,
 		wb->dirty_exceeded = gdtc->dirty_exceeded ||
 				     (mdtc && mdtc->dirty_exceeded);
 		if (time_is_before_jiffies(READ_ONCE(wb->bw_time_stamp) +
-					   BANDWIDTH_INTERVAL))
+					   BW_DIRTYLIMIT_INTERVAL))
 			__wb_update_bandwidth(gdtc, mdtc, true);
 
 		/* throttle according to the chosen dtc */
@@ -2705,7 +2705,7 @@ int do_writepages(struct address_space *mapping, struct writeback_control *wbc)
 	 * writeback bandwidth is updated once in a while.
 	 */
 	if (time_is_before_jiffies(READ_ONCE(wb->bw_time_stamp) +
-				   BANDWIDTH_INTERVAL))
+				   BW_DIRTYLIMIT_INTERVAL))
 		wb_update_bandwidth(wb);
 	return ret;
 }
@@ -3057,14 +3057,14 @@ static void wb_inode_writeback_end(struct bdi_writeback *wb)
 	atomic_dec(&wb->writeback_inodes);
 	/*
 	 * Make sure estimate of writeback throughput gets updated after
-	 * writeback completed. We delay the update by BANDWIDTH_INTERVAL
+	 * writeback completed. We delay the update by BW_DIRTYLIMIT_INTERVAL
 	 * (which is the interval other bandwidth updates use for batching) so
 	 * that if multiple inodes end writeback at a similar time, they get
 	 * batched into one bandwidth update.
 	 */
 	spin_lock_irqsave(&wb->work_lock, flags);
 	if (test_bit(WB_registered, &wb->state))
-		queue_delayed_work(bdi_wq, &wb->bw_dwork, BANDWIDTH_INTERVAL);
+		queue_delayed_work(bdi_wq, &wb->bw_dwork, BW_DIRTYLIMIT_INTERVAL);
 	spin_unlock_irqrestore(&wb->work_lock, flags);
 }
 
-- 
2.25.1

