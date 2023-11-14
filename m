Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DED76C072A2
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Nov 2023 01:53:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231713AbjKNBx5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 13 Nov 2023 20:53:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231969AbjKNBx4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 13 Nov 2023 20:53:56 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36C6FD43
        for <linux-xfs@vger.kernel.org>; Mon, 13 Nov 2023 17:53:53 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id d9443c01a7336-1cc68c1fac2so45882255ad.0
        for <linux-xfs@vger.kernel.org>; Mon, 13 Nov 2023 17:53:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699926832; x=1700531632; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=br54+cqWEk8yHjoqWphOFSoRh+0cWSk/62L3MX4Umkc=;
        b=kY2dlpgDKlcQKupE4kOgMSSvNx/VYwU2ZK6bv9ixYufDeJmLkbBi1YdXcmMtw7PQIh
         XuU88rMWni03I3zdRGEe4Lr4T2dkDJpMPwfFw3VS13Y0J924mJfxGu5HG0+tW78jP1Du
         cevXPBaOxClnsgGBPUzT9idgICmDMZDrDFjMZ4HSUcLub1Y5PVNS1oXotewdLjAmYg5B
         iPaPNJsU0+5sXNVUMV9dJllOHIINi0G76R47N/V5OGTHjThsLCSrjo9iyqQ31YBtHgMs
         Hvo735WbXUDoPTDCkmFAWgRAOw7SaGbA+vjI+etGL+qvzVGTH3NSY1l4MetlyzlroqOM
         kt0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699926832; x=1700531632;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=br54+cqWEk8yHjoqWphOFSoRh+0cWSk/62L3MX4Umkc=;
        b=MXcP06M4q4l6pfL8UdRh0h6Bm5xWDDWCHqpNJ3sNPywNz/VkTlWorYYPse+6vnX+3O
         kkOrD6Al/8HbrzQc5Q4qHo51l51ZaHtCWy7+Dciy7jULkcfNTX/NAT5RUK8qr+S58s9v
         0JcRvOuNWdebDJW8i6Sdi2yW32yEdX5seNBDUCtbky5aFZiNSJKeT//YUliUOWspxYBF
         9NiIk55Ptz/CVH+8YYMMZhP/EJpvgnqr2AZQQUm1Wktp0/TXH+rOZ5udVPjZ9qEGIi5T
         Ql///IRrIHx/WhFTxEqRBO9rAOZ090tD32/94X66taWh9lpRWf13D3ZsA54dV0uOYpRV
         hQcg==
X-Gm-Message-State: AOJu0YwdEEw/WZLwb+pHx5rD5JMzEMNu4byuKw6N6QcAAScvITWcqCsJ
        6c7NknbemUXVwMgocehOSFf8/ra7YhRPXQ==
X-Google-Smtp-Source: AGHT+IGG5lgqh4XOVE3tHWbMBOGfAaGNsVa/aX3P3uOStU7j5aQc0q9hsh8DhrusXF05z1iRQK+2Lg==
X-Received: by 2002:a17:902:ce90:b0:1cc:787f:fb7 with SMTP id f16-20020a170902ce9000b001cc787f0fb7mr1289767plg.19.1699926832455;
        Mon, 13 Nov 2023 17:53:52 -0800 (PST)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2a3:200:d177:a8ad:804f:74f1])
        by smtp.gmail.com with ESMTPSA id a17-20020a170902ecd100b001c9cb2fb8d8sm4668592plh.49.2023.11.13.17.53.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Nov 2023 17:53:52 -0800 (PST)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     amir73il@gmail.com, chandan.babu@oracle.com, fred@cloudflare.com,
        Zhang Yi <yi.zhang@huawei.com>,
        Dave Chinner <dchinner@redhat.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 CANDIDATE 06/17] xfs: flush inode gc workqueue before clearing agi bucket
Date:   Mon, 13 Nov 2023 17:53:27 -0800
Message-ID: <20231114015339.3922119-7-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.43.0.rc0.421.g78406f8d94-goog
In-Reply-To: <20231114015339.3922119-1-leah.rumancik@gmail.com>
References: <20231114015339.3922119-1-leah.rumancik@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Zhang Yi <yi.zhang@huawei.com>

[ Upstream commit 04a98a036cf8b810dda172a9dcfcbd783bf63655 ]

In the procedure of recover AGI unlinked lists, if something bad
happenes on one of the unlinked inode in the bucket list, we would call
xlog_recover_clear_agi_bucket() to clear the whole unlinked bucket list,
not the unlinked inodes after the bad one. If we have already added some
inodes to the gc workqueue before the bad inode in the list, we could
get below error when freeing those inodes, and finaly fail to complete
the log recover procedure.

 XFS (ram0): Internal error xfs_iunlink_remove at line 2456 of file
 fs/xfs/xfs_inode.c.  Caller xfs_ifree+0xb0/0x360 [xfs]

The problem is xlog_recover_clear_agi_bucket() clear the bucket list, so
the gc worker fail to check the agino in xfs_verify_agino(). Fix this by
flush workqueue before clearing the bucket.

Fixes: ab23a7768739 ("xfs: per-cpu deferred inode inactivation queues")
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
---
 fs/xfs/xfs_log_recover.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index aeb01d4c0423..04961ebf16ea 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2739,6 +2739,7 @@ xlog_recover_process_one_iunlink(
 	 * Call xlog_recover_clear_agi_bucket() to perform a transaction to
 	 * clear the inode pointer in the bucket.
 	 */
+	xfs_inodegc_flush(mp);
 	xlog_recover_clear_agi_bucket(mp, agno, bucket);
 	return NULLAGINO;
 }
-- 
2.43.0.rc0.421.g78406f8d94-goog

