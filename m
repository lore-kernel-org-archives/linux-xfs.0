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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90F9FC43381
	for <linux-xfs@archiver.kernel.org>; Sun, 10 Jan 2021 16:11:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 66FF922B2A
	for <linux-xfs@archiver.kernel.org>; Sun, 10 Jan 2021 16:11:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726346AbhAJQLC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 10 Jan 2021 11:11:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726303AbhAJQLB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 10 Jan 2021 11:11:01 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6F78C0617A9
        for <linux-xfs@vger.kernel.org>; Sun, 10 Jan 2021 08:09:57 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id q20so6208539pfu.8
        for <linux-xfs@vger.kernel.org>; Sun, 10 Jan 2021 08:09:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZflUbONAaK9/L9BOxfPqTzOfgjlgC/1JMj3JWXw1dMQ=;
        b=mS5FHYsM2krsMZUgpQE0s2ZTLIJx9hNFlIRRuH6FEWY4z4U3yNJbTsaX/IS4YVzD8G
         janl0PPjPM3bBK762XpxeKQOIVxf4BBaQig5r/9FQim1Wervf+aHlwymI0JYHf7nL9+k
         2p5nwvMDfDMQfYNzX//H2BvgXaZ+4ACyhTX/DUhTMN1eSgxa26UO8nr5LeHEx4/HwCU5
         t3gGM8HTku0DC7d1hSetbeaWdj0zHw/5G0b02GoiGtSMFSEBqqxJsJTl2wjAClIVEWXA
         wzhAdm8g94OIwqZLRQCzyGk8JHKZbzaKZIV/9vPFOTk8I0XSOBk58BFlq3XOnjj4UJCE
         bl+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZflUbONAaK9/L9BOxfPqTzOfgjlgC/1JMj3JWXw1dMQ=;
        b=GHQXKMtxgFG/z98ZV2LS9ZEnao8mhhbuLkIvh40xjWU/TR6JuPBGRlJKEMm4AJdWne
         vuaC8S5f+e/kbjucNB9qvcbscVj62pjuopteArSg5/ozW3QTneO6QuBwhRQ+TT2LaiNi
         iUhmJG4nAUCC9BCl7sUDcvrgqzqUUBdNkmocT1BGjhcjCSMAN6e+MgUZOZMqK4VZTbzI
         niCT6EsRBenh6Jjhy1cnh7/CI1YM5SQ42+UWaNNNfaQbubM28UScotjyGJZH9CBcuGCf
         2OhuFiBZdHOpqkKQC6Buf+FmZJQGZqBWXexWJQYH7tvUM4V/hle1KSrT7CdhzFth2F0Q
         yK6w==
X-Gm-Message-State: AOAM531pAqtVeIy5aYP6SXDDsx4OBYaJDGtPwAkH5bce9W9bxIu7XCOf
        YTjdnR5EWMwSasd4c8QFs9VbQCJk6wU=
X-Google-Smtp-Source: ABdhPJzZLe2uPXPR+FZS1so78ZbZvznlz+OhYgrjZ6MdRXrjgJoEwGPXqxgm8pJx/3RGJZTcpBN6AA==
X-Received: by 2002:a05:6a00:7c5:b029:19e:2965:7a6 with SMTP id n5-20020a056a0007c5b029019e296507a6mr12712667pfu.60.1610294997241;
        Sun, 10 Jan 2021 08:09:57 -0800 (PST)
Received: from localhost.localdomain ([122.179.92.100])
        by smtp.gmail.com with ESMTPSA id d6sm15525896pfo.199.2021.01.10.08.09.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Jan 2021 08:09:56 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com,
        djwong@kernel.org, hch@lst.de, allison.henderson@oracle.com
Subject: [PATCH V14 09/16] xfs: Check for extent overflow when moving extent from cow to data fork
Date:   Sun, 10 Jan 2021 21:37:13 +0530
Message-Id: <20210110160720.3922965-10-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210110160720.3922965-1-chandanrlinux@gmail.com>
References: <20210110160720.3922965-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Moving an extent to data fork can cause a sub-interval of an existing
extent to be unmapped. This will increase extent count by 1. Mapping in
the new extent can increase the extent count by 1 again i.e.
 | Old extent | New extent | Old extent |
Hence number of extents increases by 2.

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_inode_fork.h | 9 +++++++++
 fs/xfs/xfs_reflink.c           | 5 +++++
 2 files changed, 14 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index 917e289ad962..c8f279edc5c1 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -79,6 +79,15 @@ struct xfs_ifork {
 #define XFS_IEXT_WRITE_UNWRITTEN_CNT	(2)
 
 
+/*
+ * Moving an extent to data fork can cause a sub-interval of an existing extent
+ * to be unmapped. This will increase extent count by 1. Mapping in the new
+ * extent can increase the extent count by 1 again i.e.
+ * | Old extent | New extent | Old extent |
+ * Hence number of extents increases by 2.
+ */
+#define XFS_IEXT_REFLINK_END_COW_CNT	(2)
+
 /*
  * Fork handling.
  */
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 6fa05fb78189..ca0ac1426d74 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -628,6 +628,11 @@ xfs_reflink_end_cow_extent(
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
2.29.2

