Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D323C433DB
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jan 2021 08:39:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 25E0420E65
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jan 2021 08:39:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387627AbhARIjb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 Jan 2021 03:39:31 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25737 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387846AbhARIja (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Jan 2021 03:39:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610959083;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wz17+lHWN5pIm7OBmFtmHLkQz3yGLrNrOnlyhJyqqAg=;
        b=MUjhcNWCczP8Ex39YST/9SCys/KsFXHHZQQMhV7EadAEx4Sg65Hzz5kCDxAyS0QXt9g0g8
        frQR156ftYgMrnOk1Mj2n/HVS1JMZsVnYYmHuK0nAzhjoRIYVH/oJdHb8MuIaCkpv0Z1F+
        AlMOYKjIL3CHfrhSzLgHmxYkrNzgO98=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-575-F4Bx60H0NVOfZ-LKDLZYgg-1; Mon, 18 Jan 2021 03:38:02 -0500
X-MC-Unique: F4Bx60H0NVOfZ-LKDLZYgg-1
Received: by mail-pf1-f197.google.com with SMTP id v26so10503428pff.23
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jan 2021 00:38:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wz17+lHWN5pIm7OBmFtmHLkQz3yGLrNrOnlyhJyqqAg=;
        b=HTMv5L2nFTTzkUxjejk8R2IJ+NfVkYhBrXY3lulBXBVSMDHdNGmG8zm7GhkZNPyWDH
         XDZagV+VPTxULW6Wk1n8Kk/+5xXOOBctBElJhI7PbKfNbnhqjRqmsFwi5MxfE8SAHC4e
         ITkHoSBin3/KQ/cR6898r+P4Xo9/PbYJxGOLjM73BzyJaK/Oti9Y49GXjMJbPNSNHVlK
         U3htCFNnDR70zH+eu3Vk5cU44xea5uskGBl0LaBVF9V02nxtPCRTes3L1wbtmz3ojPmD
         t+hTAPCDFFA72Kq/Jd5NXZAg5wrB4hQsZW9AAertQn82yYrpTNXyQ6q56gYr95WUKcAV
         OCAA==
X-Gm-Message-State: AOAM532K7hKfZvb7QgLPqu6XlbkRg8A5dnJTBiRzpQsaxy+WrJAxZchq
        NE3hEp8T8E7WPw7rdmke4tx/ALXGiFYSgwWb47gRO/LcEOPaorQ+NoTzVQEx3OIvCB3smFFLhTw
        lNHjAXj7gTJOjG0r2EXSxl8EOtJjskGEX5b68EBw6tTj27SNumC6tnZoKq8nn+Rv5l6OkYl+xTQ
        ==
X-Received: by 2002:a63:ec4f:: with SMTP id r15mr25041936pgj.344.1610959080789;
        Mon, 18 Jan 2021 00:38:00 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxLuvbKoqzN+jhwYRd47cTVMevyzUu+VqA/XP9uR8ZeeC1WKM5Uv3bPgUPapay2hqxYZdHnGw==
X-Received: by 2002:a63:ec4f:: with SMTP id r15mr25041920pgj.344.1610959080525;
        Mon, 18 Jan 2021 00:38:00 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id e5sm16293916pjs.0.2021.01.18.00.37.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jan 2021 00:38:00 -0800 (PST)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        Gao Xiang <hsiangkao@redhat.com>
Subject: [PATCH v5 3/5] xfs: hoist out xfs_resizefs_init_new_ags()
Date:   Mon, 18 Jan 2021 16:36:58 +0800
Message-Id: <20210118083700.2384277-4-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210118083700.2384277-1-hsiangkao@redhat.com>
References: <20210118083700.2384277-1-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Move out related logic for initializing new added AGs to a new helper
in preparation for shrinking. No logic changes.

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
---
 fs/xfs/xfs_fsops.c | 74 +++++++++++++++++++++++++++-------------------
 1 file changed, 44 insertions(+), 30 deletions(-)

diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 0bc9c5ebd199..db6ed354c465 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -20,6 +20,49 @@
 #include "xfs_ag.h"
 #include "xfs_ag_resv.h"
 
+/*
+ * Write new AG headers to disk. Non-transactional, but need to be
+ * written and completed prior to the growfs transaction being logged.
+ * To do this, we use a delayed write buffer list and wait for
+ * submission and IO completion of the list as a whole. This allows the
+ * IO subsystem to merge all the AG headers in a single AG into a single
+ * IO and hide most of the latency of the IO from us.
+ *
+ * This also means that if we get an error whilst building the buffer
+ * list to write, we can cancel the entire list without having written
+ * anything.
+ */
+static int
+xfs_resizefs_init_new_ags(
+	struct xfs_mount	*mp,
+	struct aghdr_init_data	*id,
+	xfs_agnumber_t		oagcount,
+	xfs_agnumber_t		nagcount,
+	xfs_rfsblock_t		*delta)
+{
+	xfs_rfsblock_t		nb = mp->m_sb.sb_dblocks + *delta;
+	int			error;
+
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

