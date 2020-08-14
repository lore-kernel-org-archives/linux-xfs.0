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
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF85DC433E1
	for <linux-xfs@archiver.kernel.org>; Fri, 14 Aug 2020 08:09:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AF6A620771
	for <linux-xfs@archiver.kernel.org>; Fri, 14 Aug 2020 08:09:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="B+BwYPqg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726895AbgHNIJn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 14 Aug 2020 04:09:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726124AbgHNIJm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 14 Aug 2020 04:09:42 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6000CC061383
        for <linux-xfs@vger.kernel.org>; Fri, 14 Aug 2020 01:09:42 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id d19so4161117pgl.10
        for <linux-xfs@vger.kernel.org>; Fri, 14 Aug 2020 01:09:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jHxSR/pm2ySJla9ecEacKlDwTrfPRZHpq7fjIF3KGuc=;
        b=B+BwYPqgPa4nvP2Fs9GFbi3EQsmJpmUseCqklQCij+rtwoyUqx8jTxPYiJxicxqvHg
         W8+XarEdVFZ4lox3UPcZX/aVT708Anrr9aUAkD/VfLd/p50zImNs9kfhmh76d52hEVde
         iARMij4j5tBSHTXF8OgUWiZT6RaWIHpNNAXikeETwZu/ndNW0rXjVBGmXkAGDl3DsE/R
         UXO1OaBCZ4GCfXMrz78jRS0UK7Q+PMIG8br500m859Uzqfn9R5JQ7lwhl9zArxn2sfvY
         Waa7eNf1RyhQEa4CUjwndH5TSpDmiWsq44RybKrIUdkNqDVV/Swds18JPp/88nCcNR+i
         FxYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jHxSR/pm2ySJla9ecEacKlDwTrfPRZHpq7fjIF3KGuc=;
        b=UB4UsKZAgWGPzheoSnGGjht6N1RvsoJDLcX2KdsLar55H8o/LgJoZh97QcPTF8yEm/
         T9iVjzsxTV1sq2bSncHODgCXtX5HrTk5WGjQ+xL6HhuRfd0+UDw42y6cJUK9/TA1yrHV
         1dlcZSqFevZXI2FlDyXXchVycdJY7GZmxHm24oSZp3+2DpouHE28+SKUGFVl5/QzfW1Y
         TTkyOKOQJ4hosd3o2EQjDEWYlfW56h0N25ogDDH7AHSAsWxLmrm+/BvfWZC8ccfjLTQz
         vJflmdnndyzCYykFA4a/3nUUNS21pUVK/3fvcaqm44MQd4zQ596Ei0+A/109bwApbeN1
         81oA==
X-Gm-Message-State: AOAM5331OcaJCpE8aaHfO3rcj8XBrHanaYPzk7ZyqdaVUJ3irv1D9Vir
        OYBks2xBzeQS5qBZDEa22hqf9d/YLYg=
X-Google-Smtp-Source: ABdhPJxw1hEyZFi0NYP8hxPzAesaor2yRsvQFkYXPAC12JrlInP1lB0FkhvAnw2I+IKeNqJqlDSmFQ==
X-Received: by 2002:a62:3303:: with SMTP id z3mr1054349pfz.252.1597392581653;
        Fri, 14 Aug 2020 01:09:41 -0700 (PDT)
Received: from localhost.localdomain ([122.179.47.119])
        by smtp.gmail.com with ESMTPSA id z17sm8594289pfq.38.2020.08.14.01.09.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Aug 2020 01:09:41 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com,
        david@fromorbit.com
Subject: [PATCH V2 01/10] xfs: Add helper for checking per-inode extent count overflow
Date:   Fri, 14 Aug 2020 13:38:24 +0530
Message-Id: <20200814080833.84760-2-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200814080833.84760-1-chandanrlinux@gmail.com>
References: <20200814080833.84760-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

XFS does not check for possible overflow of per-inode extent counter
fields when adding extents to either data or attr fork.

For e.g.
1. Insert 5 million xattrs (each having a value size of 255 bytes) and
   then delete 50% of them in an alternating manner.

2. On a 4k block sized XFS filesystem instance, the above causes 98511
   extents to be created in the attr fork of the inode.

   xfsaild/loop0  2035 [003]  9643.390490: probe:xfs_iflush_int: (ffffffffac6225c0) if_nextents=98511 inode=131

3. The incore inode fork extent counter is a signed 32-bit
   quantity. However the on-disk extent counter is an unsigned 16-bit
   quantity and hence cannot hold 98511 extents.

4. The following incorrect value is stored in the attr extent counter,
   # xfs_db -f -c 'inode 131' -c 'print core.naextents' /dev/loop0
   core.naextents = -32561

This commit adds a new helper function (i.e.
xfs_iext_count_may_overflow()) to check for overflow of the per-inode
data and xattr extent counters. Future patches will use this function to
make sure that an FS operation will not cause the extent counter to
overflow.

Suggested-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_trans_resv.c | 33 +++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_trans_resv.h |  2 ++
 2 files changed, 35 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
index d1a0848cb52e..d21990d9df7a 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.c
+++ b/fs/xfs/libxfs/xfs_trans_resv.c
@@ -832,6 +832,39 @@ xfs_calc_sb_reservation(
 	return xfs_calc_buf_res(1, mp->m_sb.sb_sectsize);
 }
 
+int
+xfs_iext_count_may_overflow(
+	struct xfs_inode	*ip,
+	int			whichfork,
+	int			nr_to_add)
+{
+	struct xfs_ifork	*ifp;
+	uint64_t		max_exts = 0;
+	uint64_t		nr_exts;
+
+	switch (whichfork) {
+	case XFS_DATA_FORK:
+		max_exts = MAXEXTNUM;
+		break;
+
+	case XFS_ATTR_FORK:
+		max_exts = MAXAEXTNUM;
+		break;
+
+	default:
+		ASSERT(0);
+		break;
+	}
+
+	ifp = XFS_IFORK_PTR(ip, whichfork);
+	nr_exts = ifp->if_nextents + nr_to_add;
+
+	if (nr_exts > max_exts)
+		return -EFBIG;
+
+	return 0;
+}
+
 void
 xfs_trans_resv_calc(
 	struct xfs_mount	*mp,
diff --git a/fs/xfs/libxfs/xfs_trans_resv.h b/fs/xfs/libxfs/xfs_trans_resv.h
index 7241ab28cf84..9d71b51990ac 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.h
+++ b/fs/xfs/libxfs/xfs_trans_resv.h
@@ -93,5 +93,7 @@ struct xfs_trans_resv {
 
 void xfs_trans_resv_calc(struct xfs_mount *mp, struct xfs_trans_resv *resp);
 uint xfs_allocfree_log_count(struct xfs_mount *mp, uint num_ops);
+int xfs_iext_count_may_overflow(struct xfs_inode *ip, int whichfork,
+		int nr_exts);
 
 #endif	/* __XFS_TRANS_RESV_H__ */
-- 
2.28.0

