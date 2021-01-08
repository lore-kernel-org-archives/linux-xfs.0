Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69DBEC4332B
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Jan 2021 19:11:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 397E223975
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Jan 2021 19:11:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728735AbhAHTLx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 8 Jan 2021 14:11:53 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:48939 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727893AbhAHTLx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Jan 2021 14:11:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610133026;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9r6Hfypg+BnRyMugOxC/mh3KnOIHWx419LbWB8rbYGk=;
        b=Scy3n2lA9qxzVdFVXvlcreOhrpl2M72jV4BcF/gaQukSqcafJ2lSmqV4XTgg5L1uCfsyDr
        SBDH+gh6Ls4fNkqwmEryn/CTJbuKkyZz5zrawaXwzBxIKl1+3iEXWc6ymmSk5BngGWjIoQ
        HlhJCw9EZTpKzM4YTo6P7q05Tu6C0x8=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-138-GQgppty8OliUYVpiI-SmGg-1; Fri, 08 Jan 2021 14:10:25 -0500
X-MC-Unique: GQgppty8OliUYVpiI-SmGg-1
Received: by mail-pf1-f200.google.com with SMTP id q13so7227240pfn.18
        for <linux-xfs@vger.kernel.org>; Fri, 08 Jan 2021 11:10:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9r6Hfypg+BnRyMugOxC/mh3KnOIHWx419LbWB8rbYGk=;
        b=aEc+UF/6P7JmxQBSt1kFYwI+SDHpAANC7ackqrOpF3c4il5Gx9sJBdbkphng7dEJxO
         Z4jgjwklAshj15V9nytMgzB9DZ5ZW7FAN/H6jttZep75iEPFa9lI8gwVC2Q8z8+L1na6
         cPxZ9waEQWAdWfBv/r2N3hibUGlB2iTZvNqU+szB2dAMN01h5BbeijbwF1xiyrl/3V4W
         8GrvzccER6Sntxobbcofg7AmqcE7X+n6ljQYn2E77J0gt16Gy9VjBf3nT4ts3pfdkLyv
         MTfPOtL0yLqPVCE0E44GOFlqpP33dGbI+1eOFPGZWGn/uaw3AV1tXrJ8zsvqe6luyR5H
         a0Pw==
X-Gm-Message-State: AOAM531aiPX8VJ87alM/1xmNkAyWcOo3zoSS28MYTI7MTV5wxEWqBrYT
        XW1N4CUYcCY1kjkPMJzAdXAGrUc9Uu+Q6PujIWE5rZRra54Oi4x4MEAAeU0ptbYtzm28spKZF/n
        12+BUrUC1L2QnwP9VJ4cpfXAgM5NwSU3A6Ezq9Rf2Xn97EJ0Bzmi1wkrrAzHDh4VaFIIVpUAfrg
        ==
X-Received: by 2002:a17:902:c584:b029:da:cc62:22f1 with SMTP id p4-20020a170902c584b02900dacc6222f1mr5278793plx.54.1610133023782;
        Fri, 08 Jan 2021 11:10:23 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzNJn7MnDiWqDL3AyFgFVCk8lwVRVRzSAO4wbvzp1vB8gk+DcNqCJiZEoJXeO6p1DvfdHbaBA==
X-Received: by 2002:a17:902:c584:b029:da:cc62:22f1 with SMTP id p4-20020a170902c584b02900dacc6222f1mr5278769plx.54.1610133023437;
        Fri, 08 Jan 2021 11:10:23 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id h15sm9761824pfo.71.2021.01.08.11.10.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jan 2021 11:10:23 -0800 (PST)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        Gao Xiang <hsiangkao@redhat.com>
Subject: [PATCH v3 3/4] xfs: hoist out xfs_resizefs_init_new_ags()
Date:   Sat,  9 Jan 2021 03:09:18 +0800
Message-Id: <20210108190919.623672-4-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210108190919.623672-1-hsiangkao@redhat.com>
References: <20210108190919.623672-1-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Move out related logic for initializing new added AGs to a new helper
in preparation for shrinking. No logic changes.

Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
---
 fs/xfs/xfs_fsops.c | 74 +++++++++++++++++++++++++++-------------------
 1 file changed, 44 insertions(+), 30 deletions(-)

diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 6c5f6a50da2e..a792d1f0ac55 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -20,6 +20,49 @@
 #include "xfs_ag.h"
 #include "xfs_ag_resv.h"
 
+static int
+xfs_resizefs_init_new_ags(
+	xfs_mount_t		*mp,
+	struct aghdr_init_data	*id,
+	xfs_agnumber_t		oagcount,
+	xfs_agnumber_t		nagcount,
+	xfs_rfsblock_t		*delta)
+{
+	xfs_rfsblock_t		nb = mp->m_sb.sb_dblocks + *delta;
+	int			error;
+
+	/*
+	 * Write new AG headers to disk. Non-transactional, but need to be
+	 * written and completed prior to the growfs transaction being logged.
+	 * To do this, we use a delayed write buffer list and wait for
+	 * submission and IO completion of the list as a whole. This allows the
+	 * IO subsystem to merge all the AG headers in a single AG into a single
+	 * IO and hide most of the latency of the IO from us.
+	 *
+	 * This also means that if we get an error whilst building the buffer
+	 * list to write, we can cancel the entire list without having written
+	 * anything.
+	 */
+	INIT_LIST_HEAD(&id->buffer_list);
+	for (id->agno = nagcount - 1;
+	     id->agno >= oagcount;
+	     id->agno--, *delta -= id->agsize) {
+
+		if (id->agno == nagcount - 1)
+			id->agsize = nb - (id->agno *
+					(xfs_rfsblock_t)mp->m_sb.sb_agblocks);
+		else
+			id->agsize = mp->m_sb.sb_agblocks;
+
+		error = xfs_ag_init_headers(mp, id);
+		if (error) {
+			xfs_buf_delwri_cancel(&id->buffer_list);
+			return error;
+		}
+	}
+	return xfs_buf_delwri_submit(&id->buffer_list);
+}
+
 /*
  * growfs operations
  */
@@ -74,36 +117,7 @@ xfs_growfs_data_private(
 	if (error)
 		return error;
 
-	/*
-	 * Write new AG headers to disk. Non-transactional, but need to be
-	 * written and completed prior to the growfs transaction being logged.
-	 * To do this, we use a delayed write buffer list and wait for
-	 * submission and IO completion of the list as a whole. This allows the
-	 * IO subsystem to merge all the AG headers in a single AG into a single
-	 * IO and hide most of the latency of the IO from us.
-	 *
-	 * This also means that if we get an error whilst building the buffer
-	 * list to write, we can cancel the entire list without having written
-	 * anything.
-	 */
-	INIT_LIST_HEAD(&id.buffer_list);
-	for (id.agno = nagcount - 1;
-	     id.agno >= oagcount;
-	     id.agno--, delta -= id.agsize) {
-
-		if (id.agno == nagcount - 1)
-			id.agsize = nb -
-				(id.agno * (xfs_rfsblock_t)mp->m_sb.sb_agblocks);
-		else
-			id.agsize = mp->m_sb.sb_agblocks;
-
-		error = xfs_ag_init_headers(mp, &id);
-		if (error) {
-			xfs_buf_delwri_cancel(&id.buffer_list);
-			goto out_trans_cancel;
-		}
-	}
-	error = xfs_buf_delwri_submit(&id.buffer_list);
+	error = xfs_resizefs_init_new_ags(mp, &id, oagcount, nagcount, &delta);
 	if (error)
 		goto out_trans_cancel;
 
-- 
2.27.0

