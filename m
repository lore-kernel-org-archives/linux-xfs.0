Return-Path: <SRS0=chL6=C7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2971C4363D
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Sep 2020 15:54:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8100E2399A
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Sep 2020 15:54:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="e56GXi3N"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726614AbgIVPyF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Sep 2020 11:54:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48057 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726589AbgIVPyE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Sep 2020 11:54:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600790042;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=vzA9fIGV8mVEEzkLi74eaPAP6pnA1giRYep/BVOHNkM=;
        b=e56GXi3NXtS92zGoPMIC6lqkDpC+rtRQccLKPHed5kpuEZt540YHvUmMgqtYq8kNogUx89
        23PXnxAy3FF+8wzeXCsrS/DYKH8qI+upXbHfRgUWFsds3aMeRe4QtFax3TM7ZobpC8Pk04
        Y/BAEA2pLJZCt9iAJJSov0riWbsy6/U=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-151-oq-RqbiXMR2M5BSN7MpNUw-1; Tue, 22 Sep 2020 11:54:01 -0400
X-MC-Unique: oq-RqbiXMR2M5BSN7MpNUw-1
Received: by mail-pf1-f200.google.com with SMTP id s12so11565752pfu.11
        for <linux-xfs@vger.kernel.org>; Tue, 22 Sep 2020 08:54:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=vzA9fIGV8mVEEzkLi74eaPAP6pnA1giRYep/BVOHNkM=;
        b=H3OMIIiFPoVB9vT1s3OKAoMhQAnirpt8uRV1MPB3/0X+TuXBUy37C5H5bRvEim8o71
         zBYFUhubHGMADL8UqW/xwRdWP3E4p0gDj/3DyyWfvfMzLogGTZnEwtSgCxFol/uNKBCN
         Aqd6E7dW41hGxMP28+dGUi8+1JJLnfpwYu897v8Eh9rXUI6rP1qUV+sW7YR2g6vk/kR5
         mn/6wtwa7oVSYZGFGTvN1mL8LhMW2XuR9i5RYs8WM9D81gxorRcZUjkJzSUc6owMA+iA
         KQypEo0mbS/6Npj9D0+x0dkvo2eVUXNWf70x4m2mx/kpSUl1z0uOmOfNGfVhAmmaJNvb
         3yOQ==
X-Gm-Message-State: AOAM533ZpjV4dI5D/QOwGgEo+QQn9QPGPHJXdIeqz2uddGWpa59mhUvs
        evxw0zyVYDX/X27qnZVwQzB+shp3FRwwl5N/dsgtB9lWd+OquuLpRsw4TXYT6+QJ+w/KoYe2tHZ
        FFugUsCZIJEHw9cFwAWcl
X-Received: by 2002:a62:86c3:0:b029:14e:e050:289 with SMTP id x186-20020a6286c30000b029014ee0500289mr4520320pfd.50.1600790039754;
        Tue, 22 Sep 2020 08:53:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwGakEKnxGyMOzrj6iH6qc5+L9eHAzVbv1LLMBdtxvG3ZIEY45gwm5kTR5PNZGvq2Y376O0wQ==
X-Received: by 2002:a62:86c3:0:b029:14e:e050:289 with SMTP id x186-20020a6286c30000b029014ee0500289mr4520301pfd.50.1600790039450;
        Tue, 22 Sep 2020 08:53:59 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id mt8sm2784616pjb.17.2020.09.22.08.53.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2020 08:53:58 -0700 (PDT)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     Brian Foster <bfoster@redhat.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dave Chinner <david@fromorbit.com>,
        Gao Xiang <hsiangkao@redhat.com>
Subject: [PATCH v3.2] xfs: clean up calculation of LR header blocks
Date:   Tue, 22 Sep 2020 23:53:16 +0800
Message-Id: <20200922155316.31275-1-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20200917051341.9811-3-hsiangkao@redhat.com>
References: <20200917051341.9811-3-hsiangkao@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Let's use DIV_ROUND_UP() to calculate log record header
blocks as what did in xlog_get_iclog_buffer_size() and
wrap up a common helper for log recovery.

Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
---
changelog:
 - 'xlog_rec_header_t' => 'struct xlog_rec_header' to eliminate
   various structure typedefs (Brian).

 fs/xfs/xfs_log.c         |  4 +---
 fs/xfs/xfs_log_recover.c | 49 ++++++++++++++--------------------------
 2 files changed, 18 insertions(+), 35 deletions(-)

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
index 782ec3eeab4d..12cde89c090b 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -371,6 +371,19 @@ xlog_find_verify_cycle(
 	return error;
 }
 
+static inline int
+xlog_logrec_hblks(struct xlog *log, struct xlog_rec_header *rh)
+{
+	if (xfs_sb_version_haslogv2(&log->l_mp->m_sb)) {
+		int	h_size = be32_to_cpu(rh->h_size);
+
+		if ((be32_to_cpu(rh->h_version) & XLOG_VERSION_2) &&
+		    h_size > XLOG_HEADER_CYCLE_SIZE)
+			return DIV_ROUND_UP(h_size, XLOG_HEADER_CYCLE_SIZE);
+	}
+	return 1;
+}
+
 /*
  * Potentially backup over partial log record write.
  *
@@ -463,15 +476,7 @@ xlog_find_verify_log_record(
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
@@ -1158,22 +1163,7 @@ xlog_check_unmount_rec(
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
 
@@ -2989,15 +2979,10 @@ xlog_do_recovery_pass(
 		if (error)
 			goto bread_err1;
 
-		if ((be32_to_cpu(rhead->h_version) & XLOG_VERSION_2) &&
-		    (h_size > XLOG_HEADER_CYCLE_SIZE)) {
-			hblks = h_size / XLOG_HEADER_CYCLE_SIZE;
-			if (h_size % XLOG_HEADER_CYCLE_SIZE)
-				hblks++;
+		hblks = xlog_logrec_hblks(log, rhead);
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

