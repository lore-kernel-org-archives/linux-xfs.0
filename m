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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F4B2C433DB
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Jan 2021 10:33:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E229E221F9
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Jan 2021 10:33:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726258AbhADKdD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 Jan 2021 05:33:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726240AbhADKdD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Jan 2021 05:33:03 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82823C06179E
        for <linux-xfs@vger.kernel.org>; Mon,  4 Jan 2021 02:31:57 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id 15so18799065pgx.7
        for <linux-xfs@vger.kernel.org>; Mon, 04 Jan 2021 02:31:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZflUbONAaK9/L9BOxfPqTzOfgjlgC/1JMj3JWXw1dMQ=;
        b=rI5Rwd9wRkJWE5PbBaj9W3byr8PcgiS9YJWOJqJaKlrBNQut8lH77PUatB4b1kb04A
         gcwlo3u4wSkB/1p8fUPFq3olKFGj/sBIYMZBrbHM6lUJCyojVLCJrw+kbh3IOB22HbXq
         slkZ9E5SJHf/hEq8UBp56WBszE8CoKkbtw7lP8wfz8SPOdCH3bJOqW7jv/GzST2QNpdT
         U4Rk+0JEg5NFrPz56LLnOA7u+HxYrSIE1wYZy5rmgpJ8MwQigdFCTDJQiOg8XRO82wVr
         UDkTCspMC8djpLnC5ZDm8gIrhvOWzCOZYVMDDUh8Fak3BRGRJ1Mrj+ssiHhIQEH1tBOk
         piFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZflUbONAaK9/L9BOxfPqTzOfgjlgC/1JMj3JWXw1dMQ=;
        b=KhQ6i4CtiacQ/nF1sV7755y7iM+EslGUodZHfHG73qpCeadIW+hCBEFn8ns3GYIdry
         68HCJWotM7AKE3h5vr8DmG7ic0z4ez4T72R0fYjEG5ozb7sWLPv87s1i67ooE/QoERWJ
         Onfk8MTWZ4RgxaKhgIjqbxzoit6Cemcfnnzbdzm8XVkLaiDWGCCpjwfSv4RJex/SKhJ/
         RDfxhniVXw+Yy3ynSLJgR8TjR898j1xxt05SX0WklB+nuZw8Pj3pFh0JFqTst1MchGVG
         waPIDsyYeeZyYd9taRpBnU3MW1VJsgO07M+mRJVSJy4Io9Q/GxY7co1eS8EHEaPjizqB
         gIWg==
X-Gm-Message-State: AOAM5303ZRx/zGJEuW141Ie95mE9RnDDFzKVs/kYIKqWjSEZ6sCLQJBm
        MaN3kk6H0DnkwtsatvcI9+q7ycF/wpNlbg==
X-Google-Smtp-Source: ABdhPJzkAKD5Gtc77cKvL9F+zUKIgY+tExLklmmOW5ywXdNgSw6aI0v1TSnvSRD+IC3ZcMlulc/NgA==
X-Received: by 2002:a62:808d:0:b029:19e:b084:d5b0 with SMTP id j135-20020a62808d0000b029019eb084d5b0mr45903044pfd.80.1609756317032;
        Mon, 04 Jan 2021 02:31:57 -0800 (PST)
Received: from localhost.localdomain ([122.167.42.132])
        by smtp.gmail.com with ESMTPSA id q6sm51265782pfu.23.2021.01.04.02.31.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Jan 2021 02:31:56 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com,
        hch@lst.de, allison.henderson@oracle.com
Subject: [PATCH V12 07/14] xfs: Check for extent overflow when moving extent from cow to data fork
Date:   Mon,  4 Jan 2021 16:01:13 +0530
Message-Id: <20210104103120.41158-8-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210104103120.41158-1-chandanrlinux@gmail.com>
References: <20210104103120.41158-1-chandanrlinux@gmail.com>
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

