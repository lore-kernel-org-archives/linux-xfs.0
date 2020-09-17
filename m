Return-Path: <SRS0=EbdE=C2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B2FEC433E2
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 05:22:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3A455208E4
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 05:22:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dPS35JsG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726139AbgIQFWE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Sep 2020 01:22:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:43690 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726129AbgIQFWE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Sep 2020 01:22:04 -0400
X-Greylist: delayed 454 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Sep 2020 01:22:02 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600320122;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=NLFMkHZx5n33AbXWV/APjBNFG0kStV2CEUxDMV3rff4=;
        b=dPS35JsGEDYNjucgSSQ1surVncbVrd56eYzQYP+jO6tyUCDw6J3V5WVy0Iu9MyJ7UAG9KA
        +laBgmW1535DkUBa2g1f9+dWZwmzfj6rIoxGUMhOq6IJVP19saUTTp6j0KN4SGTnqmInyA
        zjYZUnyRQtUGEn2vLttiKySDLOfVnhM=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-579-RdBPc46bP228v52mVGNT5Q-1; Thu, 17 Sep 2020 01:14:40 -0400
X-MC-Unique: RdBPc46bP228v52mVGNT5Q-1
Received: by mail-pg1-f198.google.com with SMTP id y26so699012pga.22
        for <linux-xfs@vger.kernel.org>; Wed, 16 Sep 2020 22:14:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=NLFMkHZx5n33AbXWV/APjBNFG0kStV2CEUxDMV3rff4=;
        b=PZ3Y2GDGvoQ9AOQC9c2MozlO2A2RSXr6jsgJtGMHyJfA+KnYu/uzvU8vXdQ/xvXhsx
         r2ctth/6YaxFtZ9SvFO4PpFzP9DCVKFZGk6NjLY/J9npfsto5PazLH6+MVTBi1vbm1dt
         PtdAFPsqAg13aht8W3COYxFlCR2Ptk7VTcUA0agO2FvFQ+MiBNCyHJDAP8YVD63DEf+k
         Ce/isAvQoouU0KCLNYURutV3Q8tSPVFhygzh4qR/a/FmhWqfHjs/DGZPZZ4U975WdUT5
         7PtluYgFs5z2CkpwuELbQTHIP85CmQNDEUkH7jRSfybkxUFizqVnHa+O9nHmyhX+Q9GF
         fjcQ==
X-Gm-Message-State: AOAM531WxIMDk808zaFw/2xub9iSJnf3/UxTNhKZC+Boeu+umwk6SXYl
        hDEFfFWMZeBdHrgXkg41D4CeoFDJFYwUR3S436iP3QAqkoVKVX7mubb6pU0g/QT0lmMlCpEM+vt
        RDN85xg+Y5HDIGoA4fbmH
X-Received: by 2002:a62:4ed6:0:b029:142:2501:35ec with SMTP id c205-20020a624ed60000b0290142250135ecmr9969178pfb.76.1600319678827;
        Wed, 16 Sep 2020 22:14:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxhTOCoTWHqPk/t6gCcCr+78Ocx5MDbmXnOIaNWKoLT+tkgDq16OmvXoNwIniuOU7RERoNtKg==
X-Received: by 2002:a62:4ed6:0:b029:142:2501:35ec with SMTP id c205-20020a624ed60000b0290142250135ecmr9969163pfb.76.1600319678592;
        Wed, 16 Sep 2020 22:14:38 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id w2sm4269921pgb.43.2020.09.16.22.14.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2020 22:14:38 -0700 (PDT)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     Brian Foster <bfoster@redhat.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dave Chinner <david@fromorbit.com>,
        Gao Xiang <hsiangkao@redhat.com>
Subject: [PATCH v3 2/2] xfs: clean up calculation of LR header blocks
Date:   Thu, 17 Sep 2020 13:13:41 +0800
Message-Id: <20200917051341.9811-3-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20200917051341.9811-1-hsiangkao@redhat.com>
References: <20200917051341.9811-1-hsiangkao@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Let's use DIV_ROUND_UP() to calculate log record header
blocks as what did in xlog_get_iclog_buffer_size() and
wrap up a common helper for log recovery.

Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
---
v2: https://lore.kernel.org/r/20200904082516.31205-3-hsiangkao@redhat.com

changes since v2:
 - get rid of xlog_logrecv2_hblks() and use xlog_logrec_hblks()
   entirely (Brian).

 fs/xfs/xfs_log.c         |  4 +---
 fs/xfs/xfs_log_recover.c | 48 ++++++++++++++--------------------------
 2 files changed, 17 insertions(+), 35 deletions(-)

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
index 782ec3eeab4d..28dd98b5a703 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -371,6 +371,18 @@ xlog_find_verify_cycle(
 	return error;
 }
 
+static inline int xlog_logrec_hblks(struct xlog *log, xlog_rec_header_t *rh)
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
@@ -463,15 +475,7 @@ xlog_find_verify_log_record(
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
@@ -1158,22 +1162,7 @@ xlog_check_unmount_rec(
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
 
@@ -2989,15 +2978,10 @@ xlog_do_recovery_pass(
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

