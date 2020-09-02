Return-Path: <SRS0=53rf=CL=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D3A3C433E2
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Sep 2020 14:49:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 37C4F20829
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Sep 2020 14:49:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HwbXJwzo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727842AbgIBOtK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 2 Sep 2020 10:49:10 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:58905 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727984AbgIBOKK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 2 Sep 2020 10:10:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599055809;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=mNa1NaMjxdys9KYFz9KPwerqjfEdBejN7COS9aOfJOs=;
        b=HwbXJwzoJxf2aeGdsGPbb7DdffUe/TK0kswqsfYiPqw1N+MRqUz3SdmkfRyIbBojXG2i2n
        QEllkq7gWA/UkjfN0NWuoY3fgxm0Mj0mS8Axb5nWYGXZMtPoLsfK+yehIy96M9gqgJtT3o
        Z9wTN+GSWesyul5hnDiUxvpuVp94y5w=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-476-rgAzRN8BNIOa3HYFLW5UFw-1; Wed, 02 Sep 2020 10:10:06 -0400
X-MC-Unique: rgAzRN8BNIOa3HYFLW5UFw-1
Received: by mail-pj1-f71.google.com with SMTP id ic18so2168366pjb.3
        for <linux-xfs@vger.kernel.org>; Wed, 02 Sep 2020 07:10:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=mNa1NaMjxdys9KYFz9KPwerqjfEdBejN7COS9aOfJOs=;
        b=hHyCbLbXJJfFJ5VHsR9BQe6vZUfIPwLFlz7xXIzYI0MsXzyy73Fi7x5oPFbp+t1CFA
         9IpFUfj70gXNiT6OhBFHb9Gu4qMpbZ77tmdW6GyrSKk81o3hpNHxdx18vu9sOC+MwLgK
         YRsrM014wDX7mW66vTlMgiLBXO66O2STjmkBGWD4MqnJbhZOVF//TICQYF8V1yh/vRWG
         VUrL3ns5FQf9lEPSIeClGgafU7oMPib04KlwHbRcZbrcjyH897m1s5x2+YpGoesCBDOx
         wBcyObr29dS04RyW9Ui56CIJWjOyx9050hSYk6Nn9RD8xr3fcWPAL/cXN4Bn1KoL5nGz
         rERg==
X-Gm-Message-State: AOAM531t1ytQjm32351Eitmn/Miimo8CDjXqy6zjj0CIw+BuTmBhQu3L
        EX+gIjc1ZRXeLVGDzAJRSOIIwadRhg8MakQnlI+MQmI1HCS1xNtflDq0aeWmaYdA8towlBdDQGt
        BBm18jO/8SwxRsROMlxzg
X-Received: by 2002:a17:90b:3750:: with SMTP id ne16mr2387162pjb.6.1599055804726;
        Wed, 02 Sep 2020 07:10:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJweZ0DNFy87fGJodk/5oI6jT8Ucgnk9dZO56l+ccpmrmIQchHe98RfNQpQqavktv7i8RZgcew==
X-Received: by 2002:a17:90b:3750:: with SMTP id ne16mr2387142pjb.6.1599055804416;
        Wed, 02 Sep 2020 07:10:04 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id a19sm5679705pfn.10.2020.09.02.07.10.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2020 07:10:04 -0700 (PDT)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     Gao Xiang <hsiangkao@redhat.com>
Subject: [PATCH] xfs: clean up calculation of LR header blocks
Date:   Wed,  2 Sep 2020 22:09:23 +0800
Message-Id: <20200902140923.24392-1-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.18.1
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Let's use DIV_ROUND_UP() to calculate log record header
blocks as what did in xlog_get_iclog_buffer_size() and
also wrap up a common helper for log recovery code.

Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
---
 fs/xfs/libxfs/xfs_log_format.h | 10 +++++++++
 fs/xfs/xfs_log.c               |  4 +---
 fs/xfs/xfs_log_recover.c       | 37 ++++++++--------------------------
 3 files changed, 19 insertions(+), 32 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index e3400c9c71cd..f273a7db5702 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -860,4 +860,14 @@ struct xfs_icreate_log {
 	__be32		icl_gen;	/* inode generation number to use */
 };
 
+static inline int xlog_logv2_rec_hblks(struct xlog_rec_header *rh)
+{
+	int	h_size = be32_to_cpu(rh->h_size);
+
+	if ((be32_to_cpu(rh->h_version) & XLOG_VERSION_2) &&
+	    (h_size > XLOG_HEADER_CYCLE_SIZE))
+		return DIV_ROUND_UP(h_size, XLOG_HEADER_CYCLE_SIZE);
+	return 1;
+}
+
 #endif /* __XFS_LOG_FORMAT_H__ */
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
index e2ec91b2d0f4..5fecc0c7aeb2 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -489,15 +489,10 @@ xlog_find_verify_log_record(
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
+	if (xfs_sb_version_haslogv2(&log->l_mp->m_sb))
+		xhdrs = xlog_logv2_rec_hblks(head);
+	else
 		xhdrs = 1;
-	}
 
 	if (*last_blk - i + extra_bblks !=
 	    BTOBB(be32_to_cpu(head->h_len)) + xhdrs)
@@ -1184,21 +1179,10 @@ xlog_check_unmount_rec(
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
+	if (xfs_sb_version_haslogv2(&log->l_mp->m_sb))
+		hblks = xlog_logv2_rec_hblks(rhead);
+	else
 		hblks = 1;
-	}
 
 	after_umount_blk = xlog_wrap_logbno(log,
 			rhead_blk + hblks + BTOBB(be32_to_cpu(rhead->h_len)));
@@ -3016,15 +3000,10 @@ xlog_do_recovery_pass(
 			}
 		}
 
-		if ((be32_to_cpu(rhead->h_version) & XLOG_VERSION_2) &&
-		    (h_size > XLOG_HEADER_CYCLE_SIZE)) {
-			hblks = h_size / XLOG_HEADER_CYCLE_SIZE;
-			if (h_size % XLOG_HEADER_CYCLE_SIZE)
-				hblks++;
+		hblks = xlog_logv2_rec_hblks(rhead);
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

