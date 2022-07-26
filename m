Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23152CCA490
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Jul 2022 09:21:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237971AbiGZJVi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Jul 2022 05:21:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237954AbiGZJVh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Jul 2022 05:21:37 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA17D2D1E7;
        Tue, 26 Jul 2022 02:21:35 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id c72so14098800edf.8;
        Tue, 26 Jul 2022 02:21:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=W/AykhyPl65/j+auUUWur0bYoX/8hx08RF+gKniVLY0=;
        b=cY8GZ0xJIvYQWdMW5Plr23BIa3lDcbGcC0lkq/3p7P86j3RNJZ2Hc+Mu7tJg4fNYdi
         nZtuG+Bkt35+5KDUoVXC0lXrqUdF/pTGCGHA8ElpNybi5uWX9SlL1Ol8QzsuhQ3dFqFf
         SB0VsFJeGCdULIoHkdRjoqanKqqNS/O3/1q78n8CpoGV1Ng8C625e0YiPqOyJWv2V85Y
         kJYxYZkZIZ1SDrZEGaNfdEKJ7A0PjjnjjOE7LxjzmymJBrSwh3cb3nzU49kZOtkPkL+V
         PGIDDNrnc9v71mzAcD4n1K6pLGeEmmRtqestKPyHc6pr9N6tPn7Lm+F8ejCa/1m6/Pwg
         tMhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=W/AykhyPl65/j+auUUWur0bYoX/8hx08RF+gKniVLY0=;
        b=zUuk11kxDEXKhrL5fE5GAODtYpFZhUS5Nms9ubVX6MUaj6nw9L34O8zXEi8823VoZa
         btheT4nc8/rKRPoONAuuwB7YAesJ+g44rsOdon1hUacabDxbQgEwbGkyaCB9c8DwTNu3
         rk9Dr/X2OHvtNdrvjg2PlxZPa2rExPA5a02FwXNeCsIuOUqpXEWfDcB+VbQp20c5ahdO
         Dhyu0diFftOIsom+dGfpTksq4Ej30cWNRIRTqMBT8DqSyu+BLLDaWRVsRtg0BXPXC0ft
         h06BIVLrNXD+enXlLtMVDv5pVSFF6jnw78zuqMAwZBdnz/rXXvL8JCuKCpC23Lcn722M
         NrKw==
X-Gm-Message-State: AJIora+o5LXROlYl+eIUhWhk3SwvCGO7vP04ipC2iWDzJ1xIkXZmkgFo
        235CmKs3GvYnk3lzjlLLPpc=
X-Google-Smtp-Source: AGRyM1t1m42yHt2+K4LLN/Fc7AEusfqnDA8gFas/mnIuQwSNxVfmpa+/BvOlNoBdn7ggQrhtPSnf3A==
X-Received: by 2002:a05:6402:34c6:b0:43c:3e85:dc02 with SMTP id w6-20020a05640234c600b0043c3e85dc02mr4333159edc.268.1658827294199;
        Tue, 26 Jul 2022 02:21:34 -0700 (PDT)
Received: from amir-ThinkPad-T480.kpn (2a02-a45a-4ae9-1-7aa-6650-a0dd-61a2.fixed6.kpn.net. [2a02:a45a:4ae9:1:7aa:6650:a0dd:61a2])
        by smtp.gmail.com with ESMTPSA id w17-20020a056402071100b0043aa17dc199sm8161528edx.90.2022.07.26.02.21.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jul 2022 02:21:33 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     "Darrick J . Wong" <djwong@kernel.org>
Cc:     Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH 5.10 CANDIDATE 4/9] xfs: fix log intent recovery ENOSPC shutdowns when inactivating inodes
Date:   Tue, 26 Jul 2022 11:21:20 +0200
Message-Id: <20220726092125.3899077-5-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220726092125.3899077-1-amir73il@gmail.com>
References: <20220726092125.3899077-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <djwong@kernel.org>

commit 81ed94751b1513fcc5978dcc06eb1f5b4e55a785 upstream.

During regular operation, the xfs_inactive operations create
transactions with zero block reservation because in general we're
freeing space, not asking for more.  The per-AG space reservations
created at mount time enable us to handle expansions of the refcount
btree without needing to reserve blocks to the transaction.

Unfortunately, log recovery doesn't create the per-AG space reservations
when intent items are being recovered.  This isn't an issue for intent
item recovery itself because they explicitly request blocks, but any
inode inactivation that can happen during log recovery uses the same
xfs_inactive paths as regular runtime.  If a refcount btree expansion
happens, the transaction will fail due to blk_res_used > blk_res, and we
shut down the filesystem unnecessarily.

Fix this problem by making per-AG reservations temporarily so that we
can handle the inactivations, and releasing them at the end.  This
brings the recovery environment closer to the runtime environment.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/xfs/xfs_mount.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 44b05e1d5d32..a2a5a0fd9233 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -968,9 +968,17 @@ xfs_mountfs(
 	/*
 	 * Finish recovering the file system.  This part needed to be delayed
 	 * until after the root and real-time bitmap inodes were consistently
-	 * read in.
+	 * read in.  Temporarily create per-AG space reservations for metadata
+	 * btree shape changes because space freeing transactions (for inode
+	 * inactivation) require the per-AG reservation in lieu of reserving
+	 * blocks.
 	 */
+	error = xfs_fs_reserve_ag_blocks(mp);
+	if (error && error == -ENOSPC)
+		xfs_warn(mp,
+	"ENOSPC reserving per-AG metadata pool, log recovery may fail.");
 	error = xfs_log_mount_finish(mp);
+	xfs_fs_unreserve_ag_blocks(mp);
 	if (error) {
 		xfs_warn(mp, "log mount finish failed");
 		goto out_rtunmount;
-- 
2.25.1

