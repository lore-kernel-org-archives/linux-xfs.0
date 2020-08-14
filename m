Return-Path: <SRS0=kyg5=BY=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12301C433DF
	for <linux-xfs@archiver.kernel.org>; Fri, 14 Aug 2020 08:10:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DFC902068E
	for <linux-xfs@archiver.kernel.org>; Fri, 14 Aug 2020 08:09:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dBm0Fa2e"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726983AbgHNIJ7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 14 Aug 2020 04:09:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726124AbgHNIJ6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 14 Aug 2020 04:09:58 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A88B7C061383
        for <linux-xfs@vger.kernel.org>; Fri, 14 Aug 2020 01:09:58 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id kr4so4050452pjb.2
        for <linux-xfs@vger.kernel.org>; Fri, 14 Aug 2020 01:09:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tlyHPZEKvK+K/Yh1ZPL8iZ8QU0zmi8O2NrxJ/v+wsaM=;
        b=dBm0Fa2eyAt+EGIiU5TWWgkTtK+sCDbuZdamQGNCy82csoJZ2kng/KBarV2Lh562av
         /u/1q8qPz0uWY/01viNx2gqJwPoh8x2WjeG/alhT8wqzR3NgfRagYPJTUiikh/pYoqpN
         xJ8tKJvlqoucW4r3EoT1g4vK/DDXaimJcrQlHCEq8nmeYr0DVP92Y7chpKYZdqZinATU
         ylpWSpjMLDX3QfJAnaYnd5saE3USlkRalFY04m9hn/2gMP6ZGa6Aw+0SO9h+TrPIergu
         FPXtol85WSiAMotC4nkXRtrYeAIJm6dnOsPJFg4g7yYYu/ntJ4iiLVaIuELobbWcicbZ
         Tpmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tlyHPZEKvK+K/Yh1ZPL8iZ8QU0zmi8O2NrxJ/v+wsaM=;
        b=S9vUoklYukEa9po638x9OxaBlkVTrQM9muA8NZWswkp+bqBJ79CLqfYxBpYOrzuQ5w
         1oO7xGTMQB8jdPryQmYGgSiX8Iy1OV1aiHik4SWnk9HmWL596p/+e0KmNTyEnpMiTh2J
         T+Fi4LecTDiql/i1Y9b4EswyH2t9R+ZiOsl/OVpDuvGeisRHkj+J34wDFSC2Fjcrlf/o
         S79C497XYe2pZJ48n9nMhFLJRIpwCFWPwq1q/chdhtzWqBTui9JvPMNKFoSB9BQHHb1r
         uYekmaIpX6XqX0c3Y4iFtmKE8F97whEp56vm+h/oCcN0gUwpHHNCYqAsDc0v2Az3/gFL
         Wuvg==
X-Gm-Message-State: AOAM5311GlwhzaV3jecRvvJNKQsakyzkvMuas7+6kPSb45g3wwNP1zDr
        53yXgaTdYffdOY8xTEHR5pYQvdPe41Q=
X-Google-Smtp-Source: ABdhPJw/CdVvAktiEAic7ExoUPrYr3rFbJJw4EFDs3nh1WpE25gZuna3hycUjkxOpHAcscHC1QWR7A==
X-Received: by 2002:a17:90a:3549:: with SMTP id q67mr1339346pjb.56.1597392597933;
        Fri, 14 Aug 2020 01:09:57 -0700 (PDT)
Received: from localhost.localdomain ([122.179.47.119])
        by smtp.gmail.com with ESMTPSA id z17sm8594289pfq.38.2020.08.14.01.09.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Aug 2020 01:09:57 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com,
        david@fromorbit.com
Subject: [PATCH V2 08/10] xfs: Check for extent overflow when moving extent from cow to data fork
Date:   Fri, 14 Aug 2020 13:38:31 +0530
Message-Id: <20200814080833.84760-9-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200814080833.84760-1-chandanrlinux@gmail.com>
References: <20200814080833.84760-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Moving an extent to data fork can cause a sub-interval of an existing
extent to be unmapped. This will increase extent count by 1. Mapping in
the new extent can increase the extent count by 1 again i.e.
 | Old extent | New extent | Old extent |
Hence number of extents increases by 2.

Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_inode_fork.h | 10 +++++++++-
 fs/xfs/xfs_reflink.c           |  6 ++++++
 2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index 63f83a13e0a8..d750bdff17c9 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -76,7 +76,15 @@ struct xfs_ifork {
  * increase by 1.
  */
 #define XFS_IEXT_INSERT_HOLE_CNT 1
-
+/*
+ * Moving an extent to data fork can cause a sub-interval of an
+ * existing extent to be unmapped. This will increase extent count by
+ * 1. Mapping in the new extent can increase the extent count by 1
+ * again i.e.
+ * | Old extent | New extent | Old extent |
+ * Hence number of extents increases by 2.
+ */
+#define XFS_IEXT_REFLINK_END_COW_CNT 2
 /*
  * Fork handling.
  */
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index aac83f9d6107..04a7754ee681 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -29,6 +29,7 @@
 #include "xfs_iomap.h"
 #include "xfs_sb.h"
 #include "xfs_ag_resv.h"
+#include "xfs_trans_resv.h"
 
 /*
  * Copy on Write of Shared Blocks
@@ -628,6 +629,11 @@ xfs_reflink_end_cow_extent(
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	xfs_trans_ijoin(tp, ip, 0);
 
+	error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
+			XFS_IEXT_REFLINK_END_COW_CNT);
+	if (error)
+		goto out_cancel;
+
 	/*
 	 * In case of racing, overlapping AIO writes no COW extents might be
 	 * left by the time I/O completes for the loser of the race.  In that
-- 
2.28.0

