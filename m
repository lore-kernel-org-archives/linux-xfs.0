Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64841C433DB
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Jan 2021 18:33:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2811B22597
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Jan 2021 18:33:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727241AbhAZRY7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Jan 2021 12:24:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729372AbhAZGfl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Jan 2021 01:35:41 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14418C06178A
        for <linux-xfs@vger.kernel.org>; Mon, 25 Jan 2021 22:33:11 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id s24so118552pjp.5
        for <linux-xfs@vger.kernel.org>; Mon, 25 Jan 2021 22:33:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=z+k0Pox3xLg6g4VRM1QJf7emz8PSzx7P6FqqWv5XY+g=;
        b=U3wcLzb7nr6YK2Mk9Q1Ug8iIyEXxjHWW44OYvGWQp8emrEyQxk0LXGzPX0x+3v7eRN
         YzzmIRV6usnxr8GngXGe00GLLp/OcyBsFSLddHbJlJZI7z7ThDMXZQQ2UtASZvD1RCkJ
         vc1vXsBLddve2GkS1LoDkphhnleKZIrfACNx2aFDHhMnZOiwTCMnoSDtYMrMoT7RcwnP
         HJyfonJ9pbcqum75DKlU1PJxajfIdcacwRMVi9aPG5HsE4GbeIDMDlAUyAASxvVyh3EU
         d9gvGu5iONV16uE0OmDoR0YT8+SfHfNt5mTXwwYvdDXZhNcO1tgTLst27LUn3BtImo+F
         lFOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=z+k0Pox3xLg6g4VRM1QJf7emz8PSzx7P6FqqWv5XY+g=;
        b=SvExh8+/5dWv/PO9WK+UFpK3iXVdzpwJd/xVIN00ew2zQvLLZiyorNa03VvInbv0fi
         eokp768iJrXeY/S6EVRoKE02rTCk5uL1cmsL8Fbb3HZG6crhbcMkGrQobs3cHr1bt+Qs
         UOXtalY1OoaeRPgLDHNR6wvJJ8bUMi0369znxJQzSfzVSUELGdg/WxJgkgJ6ZSrdBX8N
         zR3ps3LOPjHXSnOC8Q91ATMhzjAGR1ucJV4q17QyHFYF2JH4A1zJU5AWI+6X7ycFjv1u
         +3+IqSLV4gaHYe5DURQj+T10ozJano+BY5JpURJayxLzB5b3xCGVu68xXLJ9itlEfi6R
         vfnQ==
X-Gm-Message-State: AOAM532B+Vzwf9Stv7rtSe5RB+4vpH/7cIN46+LzJ/4KtKtshd++ogrE
        pMXUS6C4Nee6dvD6uq0/4If42f40PBM=
X-Google-Smtp-Source: ABdhPJxiNtCr+QZp/3pw5LwxrzRa+2jHm/3S/02QmUSxYfEGMBhe/LSgyT2xO0lTV9MnjQGyj4vWfA==
X-Received: by 2002:a17:90b:18a:: with SMTP id t10mr4535410pjs.28.1611642790599;
        Mon, 25 Jan 2021 22:33:10 -0800 (PST)
Received: from localhost.localdomain ([122.167.33.191])
        by smtp.gmail.com with ESMTPSA id w21sm17296578pff.220.2021.01.25.22.33.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jan 2021 22:33:10 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, djwong@kernel.org,
        hch@lst.de, allison.henderson@oracle.com,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH V15 08/16] xfs: Check for extent overflow when writing to unwritten extent
Date:   Tue, 26 Jan 2021 12:02:24 +0530
Message-Id: <20210126063232.3648053-9-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210126063232.3648053-1-chandanrlinux@gmail.com>
References: <20210126063232.3648053-1-chandanrlinux@gmail.com>
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

