Return-Path: <SRS0=m/8K=CN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C1F4C433E2
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Sep 2020 08:26:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0017C206C9
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Sep 2020 08:26:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729795AbgIDI0F (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 4 Sep 2020 04:26:05 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:52273 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729707AbgIDI0B (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Sep 2020 04:26:01 -0400
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-156-W98EW4DVNHaYg9Gw-1sTCQ-1; Fri, 04 Sep 2020 04:25:57 -0400
X-MC-Unique: W98EW4DVNHaYg9Gw-1sTCQ-1
Received: by mail-pg1-f200.google.com with SMTP id 184so3177208pgg.11
        for <linux-xfs@vger.kernel.org>; Fri, 04 Sep 2020 01:25:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=T3Dua6ImRlGMOPYnscNP+WL018NUIBxWZFaGT+awHkE=;
        b=sOvXbm5DqSDDCnwftnqEXV422PehsbElxSRS6h4Kw5nGjWaVvHorWtKb+VYdQ5XOC4
         LNk6ksQAmRDnkV3jcZLcByM1mTtZEg+rvOFOqAqkt2nkpagPa+fT10Kh6GBM3I1SQoTU
         2HZRtn2PxcJofCyka7YQdNPjvmAikaAcDnOYviLlmxdvhCfUUQAG+rG5Fh3U4G0Qe+TT
         DOjV+3OjzO7yr2scsxjdAIr+nhKSgtqPhGV5C7A0Iq5HFNu7kGTZ3+a3+TRaMNPS+zSA
         p7Ee/TmzHg3iP1JL38dV/KZ91YHOFKKnepTZTaq8DEMs+k8yJNEYEN9EjRUQCGl80Ywr
         fjdw==
X-Gm-Message-State: AOAM531J9xs5Nz6MtZ2AV1mHiAYEvDl/fiNboQWjIbQATrs09klE0nCq
        NAx/i6Ikwin8RzAEyzjsGC/834Cj3fhZ085+xSuvBeNJ5BRL+hNTbBElvCcYzcrX94mi1i+nvuD
        58UZnQI1ZhR0uTayRU64T
X-Received: by 2002:a62:1b81:: with SMTP id b123mr7585806pfb.149.1599207956228;
        Fri, 04 Sep 2020 01:25:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwqaAhUhOOsWNwLt2gwKtXF4uLXDBozS8dEWpqAlFVVwVPciNcn3UVckk4fkchI+BSWu+JkWQ==
X-Received: by 2002:a62:1b81:: with SMTP id b123mr7585788pfb.149.1599207955917;
        Fri, 04 Sep 2020 01:25:55 -0700 (PDT)
Received: from xiangao.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id b64sm5721012pfa.200.2020.09.04.01.25.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2020 01:25:55 -0700 (PDT)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J . Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        Gao Xiang <hsiangkao@redhat.com>
Subject: [PATCH v2 2/2] xfs: clean up calculation of LR header blocks
Date:   Fri,  4 Sep 2020 16:25:16 +0800
Message-Id: <20200904082516.31205-3-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20200904082516.31205-1-hsiangkao@redhat.com>
References: <20200904082516.31205-1-hsiangkao@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Let's use DIV_ROUND_UP() to calculate log record header
blocks as what did in xlog_get_iclog_buffer_size() and
wrap up common helpers for log recovery.

Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
---
v1: https://lore.kernel.org/r/20200902140923.24392-1-hsiangkao@redhat.com

changes since v1:
 - add another helper xlog_logrec_hblks() for the cases with
   xfs_sb_version_haslogv2(), and use xlog_logrecv2_hblks()
   for the case of xlog_do_recovery_pass() since it has more
   complex logic other than just calculate hblks...

 fs/xfs/xfs_log.c         |  4 +--
 fs/xfs/xfs_log_recover.c | 53 ++++++++++++++++------------------------
 2 files changed, 22 insertions(+), 35 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index ad0c69ee8947..7a4ba408a3a2 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1604,9 +1604,7 @@ xlog_cksum(
 		int		i;
 		int		xheads;
 
-		xheads = size / XLOG_HEADER_CYCLE_SIZE;
-		if (size % XLOG_HEADER_CYCLE_SIZE)
-			xheads++;
+		xheads = DIV_ROUND_UP(size, XLOG_HEADER_CYCLE_SIZE);
 
 		for (i = 1; i < xheads; i++) {
 			crc = crc32c(crc, &xhdr[i].hic_xheader,
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 28d952794bfa..c6163065f6e0 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -397,6 +397,23 @@ xlog_find_verify_cycle(
 	return error;
 }
 
+static inline int xlog_logrecv2_hblks(struct xlog_rec_header *rh)
+{
+	int	h_size = be32_to_cpu(rh->h_size);
+
+	if ((be32_to_cpu(rh->h_version) & XLOG_VERSION_2) &&
+	    h_size > XLOG_HEADER_CYCLE_SIZE)
+		return DIV_ROUND_UP(h_size, XLOG_HEADER_CYCLE_SIZE);
+	return 1;
+}
+
+static inline int xlog_logrec_hblks(struct xlog *log, xlog_rec_header_t *rh)
+{
+	if (!xfs_sb_version_haslogv2(&log->l_mp->m_sb))
+		return 1;
+	return xlog_logrecv2_hblks(rh);
+}
+
 /*
  * Potentially backup over partial log record write.
  *
@@ -489,15 +506,7 @@ xlog_find_verify_log_record(
 	 * reset last_blk.  Only when last_blk points in the middle of a log
 	 * record do we update last_blk.
 	 */
-	if (xfs_sb_version_haslogv2(&log->l_mp->m_sb)) {
-		uint	h_size = be32_to_cpu(head->h_size);
-
-		xhdrs = h_size / XLOG_HEADER_CYCLE_SIZE;
-		if (h_size % XLOG_HEADER_CYCLE_SIZE)
-			xhdrs++;
-	} else {
-		xhdrs = 1;
-	}
+	xhdrs = xlog_logrec_hblks(log, head);
 
 	if (*last_blk - i + extra_bblks !=
 	    BTOBB(be32_to_cpu(head->h_len)) + xhdrs)
@@ -1184,22 +1193,7 @@ xlog_check_unmount_rec(
 	 * below. We won't want to clear the unmount record if there is one, so
 	 * we pass the lsn of the unmount record rather than the block after it.
 	 */
-	if (xfs_sb_version_haslogv2(&log->l_mp->m_sb)) {
-		int	h_size = be32_to_cpu(rhead->h_size);
-		int	h_version = be32_to_cpu(rhead->h_version);
-
-		if ((h_version & XLOG_VERSION_2) &&
-		    (h_size > XLOG_HEADER_CYCLE_SIZE)) {
-			hblks = h_size / XLOG_HEADER_CYCLE_SIZE;
-			if (h_size % XLOG_HEADER_CYCLE_SIZE)
-				hblks++;
-		} else {
-			hblks = 1;
-		}
-	} else {
-		hblks = 1;
-	}
-
+	hblks = xlog_logrec_hblks(log, rhead);
 	after_umount_blk = xlog_wrap_logbno(log,
 			rhead_blk + hblks + BTOBB(be32_to_cpu(rhead->h_len)));
 
@@ -3024,15 +3018,10 @@ xlog_do_recovery_pass(
 		if (error)
 			goto bread_err1;
 
-		if ((be32_to_cpu(rhead->h_version) & XLOG_VERSION_2) &&
-		    (h_size > XLOG_HEADER_CYCLE_SIZE)) {
-			hblks = h_size / XLOG_HEADER_CYCLE_SIZE;
-			if (h_size % XLOG_HEADER_CYCLE_SIZE)
-				hblks++;
+		hblks = xlog_logrecv2_hblks(rhead);
+		if (hblks != 1) {
 			kmem_free(hbp);
 			hbp = xlog_alloc_buffer(log, hblks);
-		} else {
-			hblks = 1;
 		}
 	} else {
 		ASSERT(log->l_sectBBsize == 1);
-- 
2.18.1

