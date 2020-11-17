Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBE8EC8300A
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Nov 2020 13:45:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7786720729
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Nov 2020 13:45:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RQCfLNH4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732628AbgKQNpN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Nov 2020 08:45:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732150AbgKQNpM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Nov 2020 08:45:12 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80D65C0613CF
        for <linux-xfs@vger.kernel.org>; Tue, 17 Nov 2020 05:45:12 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id 34so12835908pgp.10
        for <linux-xfs@vger.kernel.org>; Tue, 17 Nov 2020 05:45:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gjkXFZh3Yb0k29wFDewcPx5MIG4z7sYEJ/SPODbUO9A=;
        b=RQCfLNH4SZZk9qqdLoMxZp3PNKUWf73izakzsGJT4DTURKKNvVQC1g67VtqTZMKPeX
         4pskWWvIGVDFWsAF+T7vP5AqI59xNW2RUieBpGEb/wsFiwP4KAMEkkKaFSRUEpkAfmo9
         iQaDrlIgvm7rCeMygVMeZwSmerXI24R8Yq5RwT0UfYgWF2mN6h5ebIRrREIu5qkjXgi3
         Si1Ji25fq90bKuEwAWYFNQKPhUzVyeme1qhqpYUgSFBRpOZDISENiqjbIe55hKupkxTF
         wnBLX6AD8YGJXvfj8N4sEY9JYokoa3syqrPOCnORZA/5UaMYic1q3EcDKHmLmb/JMtgG
         N4kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gjkXFZh3Yb0k29wFDewcPx5MIG4z7sYEJ/SPODbUO9A=;
        b=JoRs43Q7wVkJm2/rgeWADSKoT55AyOR2BEzGvUvEdURs4wiNTpStl7cyU/Ang5U6ek
         OpXsJe8OHURk3VJfQhPUyZRoraKBoS7xoRiPLXBijAv8Awts9LorVX/roJog7CTpBS+L
         mCWStWdhgfVpfJfVe7r4bRB2edFN5l8EFX8fOKbKTs/GhEIgSY0I5KoAj/vSEgPGs1Ss
         UgRttUUGOuiu3Uuc59LIolJGnXD4y+hJIanuhbMy9XwS1svDod+rebbNccmpu08fdgwj
         bCdkHgB0322SQUYbvF0uLcljAs8U+A8IBhAE7ZNYoO9bIKubopcL0Rt/H1oVWJHHySUn
         KtJw==
X-Gm-Message-State: AOAM530KhAfVWaRKNJHMHYYCrV2/35vAxDBe9sL6Ro0pkl2xDt0aedBr
        hRFkq3zxIThPuSn5iCCw26mdUnCJEg8=
X-Google-Smtp-Source: ABdhPJz1l4yFOP5YRlKVPEnhcj2vNXWEHM9xzSADsJumDa3CVOPzsAiCiELctC9F0NPrV7SB+ISNxQ==
X-Received: by 2002:a63:9241:: with SMTP id s1mr3458069pgn.291.1605620711746;
        Tue, 17 Nov 2020 05:45:11 -0800 (PST)
Received: from localhost.localdomain ([122.179.49.210])
        by smtp.gmail.com with ESMTPSA id y3sm3669399pjb.18.2020.11.17.05.45.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2020 05:45:11 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com,
        Allison Henderson <allison.henderson@oracle.com>
Subject: [PATCH V11 09/14] xfs: Check for extent overflow when swapping extents
Date:   Tue, 17 Nov 2020 19:14:11 +0530
Message-Id: <20201117134416.207945-10-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201117134416.207945-1-chandanrlinux@gmail.com>
References: <20201117134416.207945-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Removing an initial range of source/donor file's extent and adding a new
extent (from donor/source file) in its place will cause extent count to
increase by 1.

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_inode_fork.h |  7 +++++++
 fs/xfs/xfs_bmap_util.c         | 16 ++++++++++++++++
 2 files changed, 23 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index b99e67e7b59b..969b06160d44 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -87,6 +87,13 @@ struct xfs_ifork {
  */
 #define XFS_IEXT_REFLINK_END_COW_CNT	(2)
 
+/*
+ * Removing an initial range of source/donor file's extent and adding a new
+ * extent (from donor/source file) in its place will cause extent count to
+ * increase by 1.
+ */
+#define XFS_IEXT_SWAP_RMAP_CNT		(1)
+
 /*
  * Fork handling.
  */
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 0776abd0103c..b6728fdf50ae 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1407,6 +1407,22 @@ xfs_swap_extent_rmap(
 					irec.br_blockcount);
 			trace_xfs_swap_extent_rmap_remap_piece(tip, &uirec);
 
+			if (xfs_bmap_is_real_extent(&uirec)) {
+				error = xfs_iext_count_may_overflow(ip,
+						XFS_DATA_FORK,
+						XFS_IEXT_SWAP_RMAP_CNT);
+				if (error)
+					goto out;
+			}
+
+			if (xfs_bmap_is_real_extent(&irec)) {
+				error = xfs_iext_count_may_overflow(tip,
+						XFS_DATA_FORK,
+						XFS_IEXT_SWAP_RMAP_CNT);
+				if (error)
+					goto out;
+			}
+
 			/* Remove the mapping from the donor file. */
 			xfs_bmap_unmap_extent(tp, tip, &uirec);
 
-- 
2.28.0

