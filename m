Return-Path: <SRS0=tAZO=BL=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27A2AC433DF
	for <linux-xfs@archiver.kernel.org>; Sat,  1 Aug 2020 08:28:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 06BC8206E9
	for <linux-xfs@archiver.kernel.org>; Sat,  1 Aug 2020 08:28:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tAf8pJ7e"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726211AbgHAI2b (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 1 Aug 2020 04:28:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725931AbgHAI2b (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 1 Aug 2020 04:28:31 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B4CCC06174A
        for <linux-xfs@vger.kernel.org>; Sat,  1 Aug 2020 01:28:31 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id o13so17242070pgf.0
        for <linux-xfs@vger.kernel.org>; Sat, 01 Aug 2020 01:28:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FgAlb9yNf7l96b5IWGMu8LppF8sYhX8AhEMKnWW0vpI=;
        b=tAf8pJ7eVdh7ohzcXwGiU1X9b1TL3+acaKgwx4hj+K5QS2XQ746lv/38IqtjwDNuQH
         w8gWBwZ9vZB1o+p4SI9AdZbJIp0IEaPINZ8k+JFsj1W9d5D81f7g3pSgnkvdS7lbPQiF
         xV2GnXecRn8mdAFAuX6B7vYC0POU8PUk1hSRT5LmHyT1C3dr/TQYC1P73o1JpEjt1Hx4
         7qaaGqtaC8H/SZ7Ji/biCCAOX4Nbkym97cTqbtrCFtx2ikzs18IAp1UqkfDa4PCruhIn
         pdqlqxHP/8znenpIQBll45Mp56MU429ziI51bemPxyo6z3Y68teFhD/IGtySJxei3uP+
         Fueg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FgAlb9yNf7l96b5IWGMu8LppF8sYhX8AhEMKnWW0vpI=;
        b=bXkymJeABcRwRRrJ3NvKNUXnXOAh7LbEB77Iu3ZQqDUGh/kKnJxIvLr3NylmV6P7pY
         5XdmnrYPTTibpmb3dhgXD6ZBPMdK5cGw6Bncf3XOSrSopinkj3qIKf7ka9IkP414NeeQ
         Ad1RlTfXiJL4i9TyW9Ob2TG/Nd9o+HdE6Wdj1ibL3Wvjb3hgypc0HOSVTlP0/k1jF750
         vv6oz3tZk21hCBm4I1tFW1bg2QcoXGPzaBAv6uUROVjhmQTFgHDXt6IvI0hwSZht6rd7
         kZZyRQdA2vqttAq+dEck1tEq2i6THRaZIwfY9RNirxwtKjyYg7d8jq8gerWqEcryfBLT
         w6TA==
X-Gm-Message-State: AOAM532Heiyak1FVknc6SB8g7p+qkx6mUp2p2bixLNV4crbmz+NZWJtT
        SrC+O7/1F2S3fbJMCizD8tqknnVQ
X-Google-Smtp-Source: ABdhPJyXG6aPYDl3G3q3gwTWSVDKfX/XYm4DWh1KMYqDzMxgstLKk8Rd1Pubt78IfQujmDqZyLD69Q==
X-Received: by 2002:a63:4956:: with SMTP id y22mr7046906pgk.380.1596270510316;
        Sat, 01 Aug 2020 01:28:30 -0700 (PDT)
Received: from localhost.localdomain ([122.182.254.175])
        by smtp.gmail.com with ESMTPSA id 127sm13433380pgf.5.2020.08.01.01.28.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Aug 2020 01:28:29 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com,
        david@fromorbit.com
Subject: [PATCH RESEND 1/2] xfs: Add helper for checking per-inode extent count overflow
Date:   Sat,  1 Aug 2020 13:58:02 +0530
Message-Id: <20200801082803.12109-2-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200801082803.12109-1-chandanrlinux@gmail.com>
References: <20200801082803.12109-1-chandanrlinux@gmail.com>
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

This commit adds a new helper function (i.e. xfs_trans_resv_ext_cnt())
to check for overflow of the per-inode data and xattr extent counters. A
future patch will use this function to make sure that a transaction will
not cause the extent counter to overflow.

Suggested-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_trans_resv.c | 33 +++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_trans_resv.h |  1 +
 2 files changed, 34 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
index d1a0848cb52e..68d9833d403d 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.c
+++ b/fs/xfs/libxfs/xfs_trans_resv.c
@@ -832,6 +832,39 @@ xfs_calc_sb_reservation(
 	return xfs_calc_buf_res(1, mp->m_sb.sb_sectsize);
 }
 
+int
+xfs_trans_resv_ext_cnt(
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
index 7241ab28cf84..8268a89caa16 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.h
+++ b/fs/xfs/libxfs/xfs_trans_resv.h
@@ -93,5 +93,6 @@ struct xfs_trans_resv {
 
 void xfs_trans_resv_calc(struct xfs_mount *mp, struct xfs_trans_resv *resp);
 uint xfs_allocfree_log_count(struct xfs_mount *mp, uint num_ops);
+int xfs_trans_resv_ext_cnt(struct xfs_inode *ip, int whichfork, int nr_exts);
 
 #endif	/* __XFS_TRANS_RESV_H__ */
-- 
2.20.1

