Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93DB2C43334
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Jul 2022 09:21:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237954AbiGZJVi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Jul 2022 05:21:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237911AbiGZJVh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Jul 2022 05:21:37 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBCEC2F661;
        Tue, 26 Jul 2022 02:21:36 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id z18so4656966edb.10;
        Tue, 26 Jul 2022 02:21:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qjqWOrmUuBfznIWOWNPwH/yjoVbrP7MvKb9s1JvXu5I=;
        b=mfpWnz8cFaizaaStkA9/MWgN9CkqF9WvZ6eXqF1KgmCoZ0hVYSSO6lLqKdSV1AaNK9
         5XpRdhSw4xIdsWUCgfURQQuTGg2z+1/QsEHd9yH86z9X0Ot6H5moq9xii8Ho7SgNfMxG
         L/hGynvvAGu4+h4AFBiA0x4fRRY81mmIMfbq0AyKrnIcseTXN7MRqwLWCmf/Fsnyktq5
         ipj4LJMnpCRZnSgV4Eoqcu/RGZEm8LhlmGsfC+NuRM8lEBnIun1gxgDcmn9QlE4G6DW3
         iSBvIRSzLD7SrutiPqTL6xtrmvnbLfAFHwlsuc+kT9rFzIBsWXZfQAkcJE1kkVZlmYei
         28yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qjqWOrmUuBfznIWOWNPwH/yjoVbrP7MvKb9s1JvXu5I=;
        b=g7fd/luWj+JW27O5pdYkpEXZO6VD084EZQgvBvUvJP8qSKNhMyXw8Pi8nr00DFYr6f
         zhPob1QUuBQMs94yPYlC04uytrZBr9ISZluW3D4sl5ttjMHzOulDqvfM6PRRkgFq5ic1
         wvIAM/oyI183W5Pz79ZF4ylA9ToNfBP5nH8tR4JR/M9qYuTOpt0/lfWhp5SX6fNrZw5r
         QQkMtUXkIDd861JdV21a8z+23nftX196dFLb2KovSjBEcuT9EN7q87/BVPn3/OLwfahF
         wWZ+9Rat+wmo5XW7158lCyhoPSZL3aE9eT5iPVFrIG++NeMoRiQGJaZjqyGeeCYgOJyp
         J3NA==
X-Gm-Message-State: AJIora8Rx/HKnXOyri2EzwGbcxYCQBbTnYlJISs0FHnixHO1648D/NUr
        IMxWXeSLv/z/m9Ux3TL2hpu45EHCaWeApw==
X-Google-Smtp-Source: AGRyM1ucBvjwBNawtTDz/KGK+980MJaJdK8uAx7qQr9Z4NIepYaw1LaC7ETc81LFrTusNmpcZMK6Qg==
X-Received: by 2002:aa7:db87:0:b0:43b:a0d5:8848 with SMTP id u7-20020aa7db87000000b0043ba0d58848mr17340232edt.60.1658827295376;
        Tue, 26 Jul 2022 02:21:35 -0700 (PDT)
Received: from amir-ThinkPad-T480.kpn (2a02-a45a-4ae9-1-7aa-6650-a0dd-61a2.fixed6.kpn.net. [2a02:a45a:4ae9:1:7aa:6650:a0dd:61a2])
        by smtp.gmail.com with ESMTPSA id w17-20020a056402071100b0043aa17dc199sm8161528edx.90.2022.07.26.02.21.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jul 2022 02:21:34 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     "Darrick J . Wong" <djwong@kernel.org>
Cc:     Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH 5.10 CANDIDATE 5/9] xfs: force the log offline when log intent item recovery fails
Date:   Tue, 26 Jul 2022 11:21:21 +0200
Message-Id: <20220726092125.3899077-6-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220726092125.3899077-1-amir73il@gmail.com>
References: <20220726092125.3899077-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <djwong@kernel.org>

commit 4e6b8270c820c8c57a73f869799a0af2b56eff3e upstream.

If any part of log intent item recovery fails, we should shut down the
log immediately to stop the log from writing a clean unmount record to
disk, because the metadata is not consistent.  The inability to cancel a
dirty transaction catches most of these cases, but there are a few
things that have slipped through the cracks, such as ENOSPC from a
transaction allocation, or runtime errors that result in cancellation of
a non-dirty transaction.

This solves some weird behaviors reported by customers where a system
goes down, the first mount fails, the second succeeds, but then the fs
goes down later because of inconsistent metadata.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/xfs/xfs_log.c         | 3 +++
 fs/xfs/xfs_log_recover.c | 5 ++++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 05791456adbb..22d7d74231d4 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -765,6 +765,9 @@ xfs_log_mount_finish(
 	if (readonly)
 		mp->m_flags |= XFS_MOUNT_RDONLY;
 
+	/* Make sure the log is dead if we're returning failure. */
+	ASSERT(!error || (mp->m_log->l_flags & XLOG_IO_ERROR));
+
 	return error;
 }
 
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 87886b7f77da..69408782019e 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2457,8 +2457,10 @@ xlog_finish_defer_ops(
 
 		error = xfs_trans_alloc(mp, &resv, dfc->dfc_blkres,
 				dfc->dfc_rtxres, XFS_TRANS_RESERVE, &tp);
-		if (error)
+		if (error) {
+			xfs_force_shutdown(mp, SHUTDOWN_LOG_IO_ERROR);
 			return error;
+		}
 
 		/*
 		 * Transfer to this new transaction all the dfops we captured
@@ -3454,6 +3456,7 @@ xlog_recover_finish(
 			 * this) before we get around to xfs_log_mount_cancel.
 			 */
 			xlog_recover_cancel_intents(log);
+			xfs_force_shutdown(log->l_mp, SHUTDOWN_LOG_IO_ERROR);
 			xfs_alert(log->l_mp, "Failed to recover intents");
 			return error;
 		}
-- 
2.25.1

