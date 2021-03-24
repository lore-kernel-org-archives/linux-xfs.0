Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AFAAC433E3
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Mar 2021 01:08:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF5F0619F5
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Mar 2021 01:08:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231653AbhCXBHm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 Mar 2021 21:07:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:43190 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234131AbhCXBHN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Mar 2021 21:07:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616548033;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IqyPORiRBsaMBUZZkY2wZzVB8e3bpA9jsQaFe2SMBDk=;
        b=YDoDkDJ9LOOu5SGXxL9q1XeXpFCb7jy/I2gQFmKw+StyvWM8+MdJfqlkMnrmvGY+hKLwz0
        KAxJeeZwLD8PJttEg3tvIVX2sYAI9jhyCkH3RqihRVlwIc9ZUZSd3YPdb+kzRDiPOMsiDj
        3KSrgqqCTU/YNtEcsGVZukoH0c4PU3I=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-574-dE_czg30OL-K9He8wNgKUA-1; Tue, 23 Mar 2021 21:07:11 -0400
X-MC-Unique: dE_czg30OL-K9He8wNgKUA-1
Received: by mail-pj1-f70.google.com with SMTP id md1so2935401pjb.0
        for <linux-xfs@vger.kernel.org>; Tue, 23 Mar 2021 18:07:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IqyPORiRBsaMBUZZkY2wZzVB8e3bpA9jsQaFe2SMBDk=;
        b=VLNTDJqzaufjiRwKvzCcMH4X3xJOT3FUPjkYVBib+6OifNu8LUNlOBeB7RIXoXzIon
         bJpUAlcRzhceMDcCI3a6EbXDC7CNXjMqxYvGJILa3APSefR60zQi6OXPIsHDRRT1c8Vz
         ycPmm4DeFtANDDZigo70/PyavXfg22mRKFjSz5/EPp+47cMZEj8XAz/lITLiXV+EKmMT
         hchhf+wMJvcPKqPP0kBiUqaZ6y6zm/oAPq169vljdiSc6Q5Ur93rBX0c6tMuhU7WJzS0
         Xvg5f9nRxU9P9jdQsrSGZrNZHowa0cisi5t/bLsN323sZ8mrsyBUYr14hV+adbNM2m0u
         +jqA==
X-Gm-Message-State: AOAM530H5v+kV5FYBuCpsF7vWuy0tz87xtonlJlklaOPwNMtIgcIioZq
        FVWbzfCTVR0wGtJEVeU2n97nRxhn4gdQKfwHceS7ftROws/58gHsmUJgY+pc0dLJooQrSSGVLsW
        UuuQWphmNxDGZoVnqnidp5CSVuLTUT7VnSpcIXvR304nucP74R3A6Erf9xQFoVAntiXvT8Uz0PQ
        ==
X-Received: by 2002:aa7:9521:0:b029:1f1:b27f:1a43 with SMTP id c1-20020aa795210000b02901f1b27f1a43mr873973pfp.4.1616548030519;
        Tue, 23 Mar 2021 18:07:10 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwKWfmdd66vk2DhqPobnMcEecu4mHav2F7eHHQx7XfjWkQD4LVZNRXPYOVosJ6h6AFIAZRjBg==
X-Received: by 2002:aa7:9521:0:b029:1f1:b27f:1a43 with SMTP id c1-20020aa795210000b02901f1b27f1a43mr873937pfp.4.1616548030048;
        Tue, 23 Mar 2021 18:07:10 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id t18sm379219pgg.33.2021.03.23.18.07.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Mar 2021 18:07:09 -0700 (PDT)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        Brian Foster <bfoster@redhat.com>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@lst.de>,
        Eric Sandeen <sandeen@sandeen.net>,
        Gao Xiang <hsiangkao@redhat.com>
Subject: [PATCH v9 2/5] xfs: hoist out xfs_resizefs_init_new_ags()
Date:   Wed, 24 Mar 2021 09:06:18 +0800
Message-Id: <20210324010621.2244671-3-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210324010621.2244671-1-hsiangkao@redhat.com>
References: <20210324010621.2244671-1-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Move out related logic for initializing new added AGs to a new helper
in preparation for shrinking. No logic changes.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
---
 fs/xfs/xfs_fsops.c | 107 +++++++++++++++++++++++++++------------------
 1 file changed, 64 insertions(+), 43 deletions(-)

diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 9f9ba8bd0213..d1ba04124c28 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -20,6 +20,64 @@
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
+	struct xfs_trans	*tp,
+	struct aghdr_init_data	*id,
+	xfs_agnumber_t		oagcount,
+	xfs_agnumber_t		nagcount,
+	xfs_rfsblock_t		delta,
+	bool			*lastag_extended)
+{
+	struct xfs_mount	*mp = tp->t_mountp;
+	xfs_rfsblock_t		nb = mp->m_sb.sb_dblocks + delta;
+	int			error;
+
+	*lastag_extended = false;
+
+	INIT_LIST_HEAD(&id->buffer_list);
+	for (id->agno = nagcount - 1;
+	     id->agno >= oagcount;
+	     id->agno--, delta -= id->agsize) {
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
+
+	error = xfs_buf_delwri_submit(&id->buffer_list);
+	if (error)
+		return error;
+
+	xfs_trans_agblocks_delta(tp, id->nfree);
+
+	if (delta) {
+		*lastag_extended = true;
+		error = xfs_ag_extend_space(mp, tp, id, delta);
+	}
+	return error;
+}
+
 /*
  * growfs operations
  */
@@ -34,6 +92,7 @@ xfs_growfs_data_private(
 	xfs_agnumber_t		nagimax = 0;
 	xfs_rfsblock_t		nb, nb_div, nb_mod;
 	xfs_rfsblock_t		delta;
+	bool			lastag_extended;
 	xfs_agnumber_t		oagcount;
 	struct xfs_trans	*tp;
 	struct aghdr_init_data	id = {};
@@ -74,48 +133,11 @@ xfs_growfs_data_private(
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
+	error = xfs_resizefs_init_new_ags(tp, &id, oagcount, nagcount,
+					  delta, &lastag_extended);
 	if (error)
 		goto out_trans_cancel;
 
-	xfs_trans_agblocks_delta(tp, id.nfree);
-
-	/* If there are new blocks in the old last AG, extend it. */
-	if (delta) {
-		error = xfs_ag_extend_space(mp, tp, &id, delta);
-		if (error)
-			goto out_trans_cancel;
-	}
-
 	/*
 	 * Update changed superblock fields transactionally. These are not
 	 * seen by the rest of the world until the transaction commit applies
@@ -123,9 +145,8 @@ xfs_growfs_data_private(
 	 */
 	if (nagcount > oagcount)
 		xfs_trans_mod_sb(tp, XFS_TRANS_SB_AGCOUNT, nagcount - oagcount);
-	if (nb > mp->m_sb.sb_dblocks)
-		xfs_trans_mod_sb(tp, XFS_TRANS_SB_DBLOCKS,
-				 nb - mp->m_sb.sb_dblocks);
+	if (delta)
+		xfs_trans_mod_sb(tp, XFS_TRANS_SB_DBLOCKS, delta);
 	if (id.nfree)
 		xfs_trans_mod_sb(tp, XFS_TRANS_SB_FDBLOCKS, id.nfree);
 
@@ -152,7 +173,7 @@ xfs_growfs_data_private(
 	 * If we expanded the last AG, free the per-AG reservation
 	 * so we can reinitialize it with the new size.
 	 */
-	if (delta) {
+	if (lastag_extended) {
 		struct xfs_perag	*pag;
 
 		pag = xfs_perag_get(mp, id.agno);
-- 
2.27.0

