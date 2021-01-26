Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19688C433DB
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Jan 2021 13:00:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D74D623101
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Jan 2021 13:00:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404060AbhAZM7c (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Jan 2021 07:59:32 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48392 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2392458AbhAZM6u (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Jan 2021 07:58:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611665843;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sDTzhpSeJaPZiyMCJtzCnkLWVqNEgtet32jXfgUpbis=;
        b=ApMO2/kt3ngEp+DEyHwo2w5xGRMsn+/y60x7Wv2pVFlrv99iMYe9uaBI36z8zV7AfZC4jU
        860PlZeFgUVH097bGpF/BawFfEzIpUO7DvJuLrxrXCWtBfA3s7eHzYpYgRjbc7HD7rG7ZM
        nw0Lj8EXQ+0CV98oza3plN7yfj6j0lU=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-571-5RVeXsDaPvej8gyRlER05A-1; Tue, 26 Jan 2021 07:57:21 -0500
X-MC-Unique: 5RVeXsDaPvej8gyRlER05A-1
Received: by mail-pl1-f198.google.com with SMTP id q12so9634722plr.9
        for <linux-xfs@vger.kernel.org>; Tue, 26 Jan 2021 04:57:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sDTzhpSeJaPZiyMCJtzCnkLWVqNEgtet32jXfgUpbis=;
        b=CukdJrF+Awaw+oGZgF2geqhzrwMNJuYeMqgh7yMUZloWqt5PTiX1Rwxe2R6ttQ/ORg
         9MMVrHHgDhVPW7NogoPhgVyXxQWBfbiYSRO7KN3/QDTxIejcwonWWek3BXOjjOV/O66i
         ai7AGsvVltJAQ/J4R9eMbbE0pMYXWX0gIqC2L5I7vxOY/HTcWO4q5eLXtkeg5bzvgKjp
         X95vksr+p2XNG7PUQm48OsstGqTLlhU66VFjIRlOmbPO8brrSjQmHNMoBb+tcManSPUg
         PIFBN7jexeQqeMcLp6z6VUZtcK4w2YiUhHbc7jsw3/vXU5HRU5UcQj+54wWF9phVI2yI
         18QA==
X-Gm-Message-State: AOAM5302pV8GrgNv8Y4aCgKHPobyVfZdprCalxe0ym0P3b5lzwcnGY5W
        tOhm9PCEkBFu2qMmmwkX/RKBXBYSiR57QiPU/PU6FDDUmmvs7J0WADtHgXMn1QYKEJYWAYHhBIn
        vFUrddG71mYmz1FUGl7lMbuVxoRvNYl+nX0aYOfF1YzIi7G5cZxQpH9XPfQUHc3j1NaIbZo5WMQ
        ==
X-Received: by 2002:a17:902:ecca:b029:de:b5bc:c852 with SMTP id a10-20020a170902eccab02900deb5bcc852mr6058289plh.59.1611665840643;
        Tue, 26 Jan 2021 04:57:20 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzDCGMxxRL0D6F10dx61vgDNWokSAdVV7h6HxqhkiJKXohPr19Nus94vI+QG7RopG1yTk96mg==
X-Received: by 2002:a17:902:ecca:b029:de:b5bc:c852 with SMTP id a10-20020a170902eccab02900deb5bcc852mr6058258plh.59.1611665840258;
        Tue, 26 Jan 2021 04:57:20 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id b203sm19243174pfb.11.2021.01.26.04.57.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jan 2021 04:57:19 -0800 (PST)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        Gao Xiang <hsiangkao@redhat.com>
Subject: [PATCH v6 4/7] xfs: hoist out xfs_resizefs_init_new_ags()
Date:   Tue, 26 Jan 2021 20:56:18 +0800
Message-Id: <20210126125621.3846735-5-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210126125621.3846735-1-hsiangkao@redhat.com>
References: <20210126125621.3846735-1-hsiangkao@redhat.com>
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
index 2e490fb75832..6c4ab5e31054 100644
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

