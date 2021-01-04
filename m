Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2988AC433E0
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Jan 2021 10:33:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E82B722286
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Jan 2021 10:33:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726248AbhADKdB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 Jan 2021 05:33:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726240AbhADKdB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Jan 2021 05:33:01 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 130C5C06179A
        for <linux-xfs@vger.kernel.org>; Mon,  4 Jan 2021 02:31:55 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id j13so10618595pjz.3
        for <linux-xfs@vger.kernel.org>; Mon, 04 Jan 2021 02:31:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=z+k0Pox3xLg6g4VRM1QJf7emz8PSzx7P6FqqWv5XY+g=;
        b=S7B4+Z4ZkMRQGFXJ0LBV6/5CXFioNR/Wd9ESauBPp0CPMmnBaAUZT1Lrw5qm1FHh/d
         I6qssJOWMF+GR5vvDNEeDEpVY5g5whE2ybnM0Vd6+invZHqQwVbe1/sGVlz6VZzB07Kb
         cE2EVv2cB/zkg0lM7oj+6fRwiJg0iTxzm6fgOCgGkX1qrHgktpyavujVE+NsJeugqTY7
         /CqoPD+zjCZixUwLDGNNHZ46W13Z4moakvN7y4H+63oeHKsomV9bNpeTaUV1N2g8tv0G
         y+nYkIpq6UHo23tudsoLvrNf3dr914yIpyEQndrEq3uLxc/jQKOkV6THkyaPE1Ew/b86
         aMSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=z+k0Pox3xLg6g4VRM1QJf7emz8PSzx7P6FqqWv5XY+g=;
        b=qOoLxnO5GojRJiOTcFKp28C0Lapu2gjKazYeorWzHTB9lk1wGTfGT/ixV9fT6PO6e3
         InoiEcURU6HELgNSLoRE9BG11bTgeYJwHVxDmJKMr5G1D4sSabPgekaguHcNWHQUpt7F
         G0kUGpTvAnqof+Ch24+29n+qdwwhwgZ8QDIDx6YRoWNNk76DnPIT22S2TpiX4njur50R
         1NHWuV8KsHVVCqMkQY04uNnU1iLOnQCmM2D0Lnnt0Rgcz93pqisfSkkRU3TVtFyCB/I1
         WzWoV79YSDRwsxR/JnaChQ4jnmC6OKkU1+8SC5DRk5PoYBHAdkQ9YaBA8RZI7nkrshnE
         nJIg==
X-Gm-Message-State: AOAM5301MSGruK819JAiivhEiacgUOVpK6EiZJcBR2RyOwgyiRhzS2ig
        axWMpVplU/fw912kweSRjxTk1DUOa/5yXw==
X-Google-Smtp-Source: ABdhPJx5kitqY1KYOKMnQEVcXISedIYD6GP5AdHgjMRDI8KPscGizkc35bBdQ6Y8pPuq+rUBv+j4ng==
X-Received: by 2002:a17:902:7596:b029:da:b7a3:cdd0 with SMTP id j22-20020a1709027596b02900dab7a3cdd0mr71197192pll.14.1609756314597;
        Mon, 04 Jan 2021 02:31:54 -0800 (PST)
Received: from localhost.localdomain ([122.167.42.132])
        by smtp.gmail.com with ESMTPSA id q6sm51265782pfu.23.2021.01.04.02.31.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Jan 2021 02:31:54 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com,
        hch@lst.de, allison.henderson@oracle.com
Subject: [PATCH V12 06/14] xfs: Check for extent overflow when writing to unwritten extent
Date:   Mon,  4 Jan 2021 16:01:12 +0530
Message-Id: <20210104103120.41158-7-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210104103120.41158-1-chandanrlinux@gmail.com>
References: <20210104103120.41158-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

A write to a sub-interval of an existing unwritten extent causes
the original extent to be split into 3 extents
i.e. | Unwritten | Real | Unwritten |
Hence extent count can increase by 2.

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_inode_fork.h | 9 +++++++++
 fs/xfs/xfs_iomap.c             | 5 +++++
 2 files changed, 14 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index 8d89838e23f8..917e289ad962 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -70,6 +70,15 @@ struct xfs_ifork {
 #define XFS_IEXT_ATTR_MANIP_CNT(rmt_blks) \
 	(XFS_DA_NODE_MAXDEPTH + max(1, rmt_blks))
 
+/*
+ * A write to a sub-interval of an existing unwritten extent causes the original
+ * extent to be split into 3 extents
+ * i.e. | Unwritten | Real | Unwritten |
+ * Hence extent count can increase by 2.
+ */
+#define XFS_IEXT_WRITE_UNWRITTEN_CNT	(2)
+
+
 /*
  * Fork handling.
  */
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index f53690febb22..5bf84622421d 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -566,6 +566,11 @@ xfs_iomap_write_unwritten(
 		if (error)
 			goto error_on_bmapi_transaction;
 
+		error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
+				XFS_IEXT_WRITE_UNWRITTEN_CNT);
+		if (error)
+			goto error_on_bmapi_transaction;
+
 		/*
 		 * Modify the unwritten extent state of the buffer.
 		 */
-- 
2.29.2

