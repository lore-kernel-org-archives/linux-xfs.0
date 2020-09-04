Return-Path: <SRS0=m/8K=CN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B993C433E2
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Sep 2020 08:26:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E2881206C9
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Sep 2020 08:25:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729705AbgIDIZ6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 4 Sep 2020 04:25:58 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:55788 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726655AbgIDIZ4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Sep 2020 04:25:56 -0400
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-331-Nzw8gLCFPIqofLAfAE3QRg-1; Fri, 04 Sep 2020 04:25:53 -0400
X-MC-Unique: Nzw8gLCFPIqofLAfAE3QRg-1
Received: by mail-pf1-f199.google.com with SMTP id k13so1026324pfh.4
        for <linux-xfs@vger.kernel.org>; Fri, 04 Sep 2020 01:25:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Jx9fm4XtROeL7lBjB6Pmta4C5dtr9u/2RH9h7p2mhZ4=;
        b=BQzqKkntvLAFYEjbkd3OrDfBUNJPpvRtqn1tUYBnhW6r/MagL1Xk23Osjz/x4ZU0rB
         8wycRgCwB9MHOGfhe8GRxf4gXhcn8kHeu9gMRlCEHjdpThgq+aR/K54DMPUqtfhkBqE0
         X52/UUgRdJsDBlrbcHNSJeTmta5Njgg6+OUk6adjnvyQvKHtPx78jTiabIVatSCHk3Ub
         urLlZ1XvkT9vML9jLRerJPtY76JUu9E7dC1NQNR5anmFYtBElgeelxM1CYUs4I78UpiR
         6NF6jF6P1cjZcGyGkDO6Yh6bnzG5m48N+kNVQ82S+TYU4rcsBhkM2hwD5bXP9GK76rrJ
         +oUw==
X-Gm-Message-State: AOAM532WP1gNixNYcgOXHkGWJMlEIauT6O7BBqYPXYHSaqhAl15n5S3h
        rTGkBR8Zdva0ik13vGfoiBNV/7lTgyagltOBq3XpnF/8u/vWN+Pse183zpR5ahLVgKLAcTrpXaK
        4dOXrIf+q2TJ5qgwHmoTW
X-Received: by 2002:a17:902:326:: with SMTP id 35mr7778288pld.1.1599207952425;
        Fri, 04 Sep 2020 01:25:52 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwVvl/SHhPXlKxiBjAM7zZpczdAdRd+6f+JzTWjPAnZvyrt3w/Cyu6ForbUVH5ZgJpB7W9Sqg==
X-Received: by 2002:a17:902:326:: with SMTP id 35mr7778269pld.1.1599207952164;
        Fri, 04 Sep 2020 01:25:52 -0700 (PDT)
Received: from xiangao.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id b64sm5721012pfa.200.2020.09.04.01.25.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2020 01:25:51 -0700 (PDT)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J . Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        Gao Xiang <hsiangkao@redhat.com>
Subject: [PATCH v3 1/2] xfs: avoid LR buffer overrun due to crafted h_{len,size}
Date:   Fri,  4 Sep 2020 16:25:15 +0800
Message-Id: <20200904082516.31205-2-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20200904082516.31205-1-hsiangkao@redhat.com>
References: <20200904082516.31205-1-hsiangkao@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Currently, crafted h_len has been blocked for the log
header of the tail block in commit a70f9fe52daa ("xfs:
detect and handle invalid iclog size set by mkfs").

However, each log record could still have crafted h_len,
h_size and cause log record buffer overrun. So let's
check (h_len vs h_size) and (h_size vs buffer size)
for each log record as well instead.

Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
---
v2: https://lore.kernel.org/r/20200902141923.26422-1-hsiangkao@redhat.com

changes since v2:
 - rename argument h_size to bufsize to make it clear (Brian);
 - leave the mkfs workaround logic in xlog_do_recovery_pass() (Brian);
 - add XLOG_VERSION_2 checking logic since old logrecv1 doesn't have
   h_size field just to be safe.

 fs/xfs/xfs_log_recover.c | 50 +++++++++++++++++++++++-----------------
 1 file changed, 29 insertions(+), 21 deletions(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index e2ec91b2d0f4..28d952794bfa 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2904,9 +2904,10 @@ STATIC int
 xlog_valid_rec_header(
 	struct xlog		*log,
 	struct xlog_rec_header	*rhead,
-	xfs_daddr_t		blkno)
+	xfs_daddr_t		blkno,
+	int			bufsize)
 {
-	int			hlen;
+	int			hlen, hsize = XLOG_BIG_RECORD_BSIZE;
 
 	if (XFS_IS_CORRUPT(log->l_mp,
 			   rhead->h_magicno != cpu_to_be32(XLOG_HEADER_MAGIC_NUM)))
@@ -2920,10 +2921,22 @@ xlog_valid_rec_header(
 		return -EFSCORRUPTED;
 	}
 
-	/* LR body must have data or it wouldn't have been written */
+	/*
+	 * LR body must have data (or it wouldn't have been written) and
+	 * h_len must not be greater than h_size with one exception (see
+	 * comments in xlog_do_recovery_pass()).
+	 */
 	hlen = be32_to_cpu(rhead->h_len);
-	if (XFS_IS_CORRUPT(log->l_mp, hlen <= 0 || hlen > INT_MAX))
+	if (xfs_sb_version_haslogv2(&log->l_mp->m_sb) &&
+	    (be32_to_cpu(rhead->h_version) & XLOG_VERSION_2))
+		hsize = be32_to_cpu(rhead->h_size);
+
+	if (XFS_IS_CORRUPT(log->l_mp, hlen <= 0 || hlen > hsize))
 		return -EFSCORRUPTED;
+
+	if (bufsize && XFS_IS_CORRUPT(log->l_mp, bufsize < hsize))
+		return -EFSCORRUPTED;
+
 	if (XFS_IS_CORRUPT(log->l_mp,
 			   blkno > log->l_logBBsize || blkno > INT_MAX))
 		return -EFSCORRUPTED;
@@ -2984,9 +2997,6 @@ xlog_do_recovery_pass(
 			goto bread_err1;
 
 		rhead = (xlog_rec_header_t *)offset;
-		error = xlog_valid_rec_header(log, rhead, tail_blk);
-		if (error)
-			goto bread_err1;
 
 		/*
 		 * xfsprogs has a bug where record length is based on lsunit but
@@ -3001,21 +3011,19 @@ xlog_do_recovery_pass(
 		 */
 		h_size = be32_to_cpu(rhead->h_size);
 		h_len = be32_to_cpu(rhead->h_len);
-		if (h_len > h_size) {
-			if (h_len <= log->l_mp->m_logbsize &&
-			    be32_to_cpu(rhead->h_num_logops) == 1) {
-				xfs_warn(log->l_mp,
+		if (h_len > h_size && h_len <= log->l_mp->m_logbsize &&
+		    rhead->h_num_logops == cpu_to_be32(1)) {
+			xfs_warn(log->l_mp,
 		"invalid iclog size (%d bytes), using lsunit (%d bytes)",
-					 h_size, log->l_mp->m_logbsize);
-				h_size = log->l_mp->m_logbsize;
-			} else {
-				XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW,
-						log->l_mp);
-				error = -EFSCORRUPTED;
-				goto bread_err1;
-			}
+				 h_size, log->l_mp->m_logbsize);
+			h_size = log->l_mp->m_logbsize;
+			rhead->h_size = cpu_to_be32(h_size);
 		}
 
+		error = xlog_valid_rec_header(log, rhead, tail_blk, 0);
+		if (error)
+			goto bread_err1;
+
 		if ((be32_to_cpu(rhead->h_version) & XLOG_VERSION_2) &&
 		    (h_size > XLOG_HEADER_CYCLE_SIZE)) {
 			hblks = h_size / XLOG_HEADER_CYCLE_SIZE;
@@ -3096,7 +3104,7 @@ xlog_do_recovery_pass(
 			}
 			rhead = (xlog_rec_header_t *)offset;
 			error = xlog_valid_rec_header(log, rhead,
-						split_hblks ? blk_no : 0);
+					split_hblks ? blk_no : 0, h_size);
 			if (error)
 				goto bread_err2;
 
@@ -3177,7 +3185,7 @@ xlog_do_recovery_pass(
 			goto bread_err2;
 
 		rhead = (xlog_rec_header_t *)offset;
-		error = xlog_valid_rec_header(log, rhead, blk_no);
+		error = xlog_valid_rec_header(log, rhead, blk_no, h_size);
 		if (error)
 			goto bread_err2;
 
-- 
2.18.1

