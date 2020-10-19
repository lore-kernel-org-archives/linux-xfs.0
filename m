Return-Path: <SRS0=Yj0O=D2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A152EC433E7
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Oct 2020 06:41:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5491F22260
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Oct 2020 06:41:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XbwyXCjq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726996AbgJSGla (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 19 Oct 2020 02:41:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726840AbgJSGl3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 19 Oct 2020 02:41:29 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8611BC061755
        for <linux-xfs@vger.kernel.org>; Sun, 18 Oct 2020 23:41:29 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id x13so5434658pgp.7
        for <linux-xfs@vger.kernel.org>; Sun, 18 Oct 2020 23:41:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0V3DO6nHiBSINlQ/fV4OzjiC+RHGej2jIrHfYsPI47M=;
        b=XbwyXCjqWPbwVvr2NkHzl6TGqHC6AAaPNoWNM/Z4yFchmNE2mnBr2hE0ePAbkIFMeV
         1+s0AE0btz9B0kirMEafWGUpWBZ7espED/Lvrm8OZYHuqCRIGdWPs9WJANNeVyLiCXga
         mISRF9JQaQdkC12TVmNRIx5XrMS3FO/qGnUz1MAitLFvC7HwNLVsCgdRIo9iBH5G8t9L
         bZkgZApK1N5sd6MtluhUsurrcyGMOkmx7R3eU5td8bwP+ZM2WcM5UojW3OjGHogdync0
         uMPsGeIYBHvO3YAsd3UcthvLChRdXePOQjfZT0WJMsRAniiob35BFWhAXks9wLOWkrii
         /Ukg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0V3DO6nHiBSINlQ/fV4OzjiC+RHGej2jIrHfYsPI47M=;
        b=LCEYf3p/D/xmzNNZUN0iZFNMSrGNSEV/xdwjhnsHWj6rJHgwfKm7BKlnH/am5Bb0Fh
         odZxNaNXwECgicMRjUG+lQ4A2Z2hwGlsjQ/FfqA/jHzJ4KYbwKoca+Fa+3HYKpBTkBnk
         Y9BZrgGZJ0kK65ixU5QQ2X6lRU0GlVWySxk9AjlQsiFYDyu1Gs9PPHiX5psJHeipCt5f
         hiOPwjQq3OOwggv6VaS5+c3hu1rbVeWAbDB+F9G3or1edA6V2hy9B4qBIY6gNsPIi6Zr
         FVZoCo7SB8qYkN/PmNjbKv87LkR1e6XKLS+TyBVrydkhBNX8ibvDxVSirOtPt5Lxpzi/
         rTYQ==
X-Gm-Message-State: AOAM531TXP1t+M9kjZLy0dYwc1ABDUWws0G8AOQF9uZ+mDR+TexjIsbK
        TeQjFz/4V/EHNcEG4JO0tHfPJIa3JTA=
X-Google-Smtp-Source: ABdhPJxj5qIH+8t2abOxDqk0y5vKC+WP4FeQlKpD1fL8qwFlqBedx5DmzLqpaB1/CSBEW2/PJivVnw==
X-Received: by 2002:a65:55ce:: with SMTP id k14mr13033551pgs.65.1603089688859;
        Sun, 18 Oct 2020 23:41:28 -0700 (PDT)
Received: from localhost.localdomain ([122.179.121.224])
        by smtp.gmail.com with ESMTPSA id w74sm11164189pff.200.2020.10.18.23.41.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Oct 2020 23:41:28 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com,
        david@fromorbit.com, hch@infradead.org,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH V7 06/14] xfs: Check for extent overflow when writing to unwritten extent
Date:   Mon, 19 Oct 2020 12:10:40 +0530
Message-Id: <20201019064048.6591-7-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201019064048.6591-1-chandanrlinux@gmail.com>
References: <20201019064048.6591-1-chandanrlinux@gmail.com>
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
Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_inode_fork.h | 8 ++++++++
 fs/xfs/xfs_iomap.c             | 5 +++++
 2 files changed, 13 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index fd93fdc67ee4..afb647e1e3fa 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -70,6 +70,14 @@ struct xfs_ifork {
 #define XFS_IEXT_DIR_MANIP_CNT(mp) \
 	((XFS_DA_NODE_MAXDEPTH + 1 + 1) * (mp)->m_dir_geo->fsbcount)
 
+/*
+ * A write to a sub-interval of an existing unwritten extent causes the original
+ * extent to be split into 3 extents
+ * i.e. | Unwritten | Real | Unwritten |
+ * Hence extent count can increase by 2.
+ */
+#define XFS_IEXT_WRITE_UNWRITTEN_CNT	(2)
+
 /*
  * Fork handling.
  */
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index a302a96823b8..2aa788379611 100644
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
2.28.0

