Return-Path: <SRS0=53rf=CL=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D255EC433E7
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Sep 2020 14:23:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A6F0F2078E
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Sep 2020 14:23:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="P2EYm9tD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727877AbgIBOXI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 2 Sep 2020 10:23:08 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:25174 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727993AbgIBOUM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 2 Sep 2020 10:20:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599056406;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=7tVxD1zzqrMEk7KrmqokiAGJw0mBtBv5oIhXU3LpXa4=;
        b=P2EYm9tDruqvar/k2IhpnVDJw9KcLCkrY5Vbii/Y4rYPuaiiDCR9PFePZIHPDsmfQRtLhk
        LcUIMVsCnil4V6nDUmnJwQ3L+Aoq3181oYgeU064GnSKbuPDn3I3qNxJMg1oIW/Kuj1t64
        1XggsGJfIOV89YZ78T4Xolv2meZKudw=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-382-XWe--c_9Nna3klsg34dOaw-1; Wed, 02 Sep 2020 10:20:04 -0400
X-MC-Unique: XWe--c_9Nna3klsg34dOaw-1
Received: by mail-pl1-f200.google.com with SMTP id w20so2432267plp.8
        for <linux-xfs@vger.kernel.org>; Wed, 02 Sep 2020 07:20:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=7tVxD1zzqrMEk7KrmqokiAGJw0mBtBv5oIhXU3LpXa4=;
        b=OQuZTnN7xxRPPI+m0UtoqSZxh7Z70+IyJHlbbb9z21f2NhMvg90QuaAF3mW4X1dRar
         KeNkpFjJYllrQT2pQ3uSdJdYd56oaAUiyRAt6XG2q/ss9rCPj5qVvY+tZkmmriMuirkp
         0JkEufN8UJP9lNdkHYLzi0eVI9q5EAhLJPQKlcnn5S2LACYf5nGD8dxVSCwkjYTgWelO
         csoAl1Ryr1OXzyenoXn8TIkVU+MDLLwZK67nGIHuB8bG7/qqiOgsncO7+Na2OfnpSHXx
         /3vMQVrtt8IalEYmQKqe/+7DUYce5dtnDMpPtXXHSRAzBtSWqCWvd/Cwmd4ujvXEJRe1
         kzXA==
X-Gm-Message-State: AOAM530lboHTW1Q8RFnzNzM4rCjGCaE9G/2LPl9LmpLQB7SJts2UctvH
        uiWS6mTs1to1yXXEOXqlAMkcMTBtfUxKyDB7/VYLjDh3zIquyDG86JuPvb93p0xEfQLmpM+7Q1b
        RTOrLQbKsJzZdWsNXwz/A
X-Received: by 2002:a63:2fc7:: with SMTP id v190mr975894pgv.250.1599056403660;
        Wed, 02 Sep 2020 07:20:03 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz99roiDSkFizkv6pXBY5hcN1AXs9lX22FvxCf4Tadg3byrtbhETNS603FjIgJ6JVVdaq4nog==
X-Received: by 2002:a63:2fc7:: with SMTP id v190mr975868pgv.250.1599056403365;
        Wed, 02 Sep 2020 07:20:03 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id t10sm5588282pgp.15.2020.09.02.07.20.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2020 07:20:02 -0700 (PDT)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     Gao Xiang <hsiangkao@redhat.com>
Subject: [PATCH v2] xfs: avoid LR buffer overrun due to crafted h_len
Date:   Wed,  2 Sep 2020 22:19:23 +0800
Message-Id: <20200902141923.26422-1-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20200902141012.24605-1-hsiangkao@redhat.com>
References: <20200902141012.24605-1-hsiangkao@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Currently, crafted h_len has been blocked for the log
header of the tail block in commit a70f9fe52daa ("xfs:
detect and handle invalid iclog size set by mkfs").

However, each log record could still have crafted
h_len and cause log record buffer overrun. So let's
check h_len for each log record as well instead.

Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
---
v2: fix a misjudgement "unlikely(hlen >= hsize)"

 fs/xfs/xfs_log_recover.c | 70 +++++++++++++++++++++-------------------
 1 file changed, 37 insertions(+), 33 deletions(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index e2ec91b2d0f4..2d9195fb9367 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2904,7 +2904,8 @@ STATIC int
 xlog_valid_rec_header(
 	struct xlog		*log,
 	struct xlog_rec_header	*rhead,
-	xfs_daddr_t		blkno)
+	xfs_daddr_t		blkno,
+	int			hsize)
 {
 	int			hlen;
 
@@ -2920,10 +2921,39 @@ xlog_valid_rec_header(
 		return -EFSCORRUPTED;
 	}
 
-	/* LR body must have data or it wouldn't have been written */
+	/*
+	 * LR body must have data (or it wouldn't have been written) and
+	 * h_len must not be greater than h_size with one exception.
+	 *
+	 * That is that xfsprogs has a bug where record length is based on
+	 * lsunit but h_size (iclog size) is hardcoded to 32k. This means
+	 * the log buffer allocated can be too small for the record to
+	 * cause an overrun.
+	 *
+	 * Detect this condition here. Use lsunit for the buffer size as
+	 * long as this looks like the mkfs case. Otherwise, return an
+	 * error to avoid a buffer overrun.
+	 */
 	hlen = be32_to_cpu(rhead->h_len);
-	if (XFS_IS_CORRUPT(log->l_mp, hlen <= 0 || hlen > INT_MAX))
+	if (XFS_IS_CORRUPT(log->l_mp, hlen <= 0))
 		return -EFSCORRUPTED;
+
+	if (hsize && XFS_IS_CORRUPT(log->l_mp,
+				    hsize < be32_to_cpu(rhead->h_size)))
+		return -EFSCORRUPTED;
+	hsize = be32_to_cpu(rhead->h_size);
+
+	if (unlikely(hlen > hsize)) {
+		if (XFS_IS_CORRUPT(log->l_mp, hlen > log->l_mp->m_logbsize ||
+				   rhead->h_num_logops != cpu_to_be32(1)))
+			return -EFSCORRUPTED;
+
+		xfs_warn(log->l_mp,
+		"invalid iclog size (%d bytes), using lsunit (%d bytes)",
+			 hsize, log->l_mp->m_logbsize);
+		rhead->h_size = cpu_to_be32(log->l_mp->m_logbsize);
+	}
+
 	if (XFS_IS_CORRUPT(log->l_mp,
 			   blkno > log->l_logBBsize || blkno > INT_MAX))
 		return -EFSCORRUPTED;
@@ -2951,7 +2981,7 @@ xlog_do_recovery_pass(
 	xfs_daddr_t		rhead_blk;
 	char			*offset;
 	char			*hbp, *dbp;
-	int			error = 0, h_size, h_len;
+	int			error = 0, h_size;
 	int			error2 = 0;
 	int			bblks, split_bblks;
 	int			hblks, split_hblks, wrapped_hblks;
@@ -2984,37 +3014,11 @@ xlog_do_recovery_pass(
 			goto bread_err1;
 
 		rhead = (xlog_rec_header_t *)offset;
-		error = xlog_valid_rec_header(log, rhead, tail_blk);
+		error = xlog_valid_rec_header(log, rhead, tail_blk, 0);
 		if (error)
 			goto bread_err1;
 
-		/*
-		 * xfsprogs has a bug where record length is based on lsunit but
-		 * h_size (iclog size) is hardcoded to 32k. Now that we
-		 * unconditionally CRC verify the unmount record, this means the
-		 * log buffer can be too small for the record and cause an
-		 * overrun.
-		 *
-		 * Detect this condition here. Use lsunit for the buffer size as
-		 * long as this looks like the mkfs case. Otherwise, return an
-		 * error to avoid a buffer overrun.
-		 */
 		h_size = be32_to_cpu(rhead->h_size);
-		h_len = be32_to_cpu(rhead->h_len);
-		if (h_len > h_size) {
-			if (h_len <= log->l_mp->m_logbsize &&
-			    be32_to_cpu(rhead->h_num_logops) == 1) {
-				xfs_warn(log->l_mp,
-		"invalid iclog size (%d bytes), using lsunit (%d bytes)",
-					 h_size, log->l_mp->m_logbsize);
-				h_size = log->l_mp->m_logbsize;
-			} else {
-				XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW,
-						log->l_mp);
-				error = -EFSCORRUPTED;
-				goto bread_err1;
-			}
-		}
 
 		if ((be32_to_cpu(rhead->h_version) & XLOG_VERSION_2) &&
 		    (h_size > XLOG_HEADER_CYCLE_SIZE)) {
@@ -3096,7 +3100,7 @@ xlog_do_recovery_pass(
 			}
 			rhead = (xlog_rec_header_t *)offset;
 			error = xlog_valid_rec_header(log, rhead,
-						split_hblks ? blk_no : 0);
+					split_hblks ? blk_no : 0, h_size);
 			if (error)
 				goto bread_err2;
 
@@ -3177,7 +3181,7 @@ xlog_do_recovery_pass(
 			goto bread_err2;
 
 		rhead = (xlog_rec_header_t *)offset;
-		error = xlog_valid_rec_header(log, rhead, blk_no);
+		error = xlog_valid_rec_header(log, rhead, blk_no, h_size);
 		if (error)
 			goto bread_err2;
 
-- 
2.18.1

