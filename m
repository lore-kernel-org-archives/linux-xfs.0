Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52694C433E0
	for <linux-xfs@archiver.kernel.org>; Sun, 10 Jan 2021 03:31:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 24B84229EF
	for <linux-xfs@archiver.kernel.org>; Sun, 10 Jan 2021 03:31:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726476AbhAJDbH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 9 Jan 2021 22:31:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726301AbhAJDbH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 9 Jan 2021 22:31:07 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72884C0617AA
        for <linux-xfs@vger.kernel.org>; Sat,  9 Jan 2021 19:30:03 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id z21so10317583pgj.4
        for <linux-xfs@vger.kernel.org>; Sat, 09 Jan 2021 19:30:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZflUbONAaK9/L9BOxfPqTzOfgjlgC/1JMj3JWXw1dMQ=;
        b=ujVEwGINJQck72U6EUgcIAdx1YAKYf90fVzwn2kw4FYDCMT3nHSrGfDEMlQR+cHzys
         O14xtYNHICflWdxLuUqiByTLl7g6KEqX93RgyRqjncTdgkThazl8LL8Xjv8L4d6jt3Ko
         HKLQJ62iRxA2ykcD3mtJ1yr8/R/8GZKkqPM81MBN8y7v/bLPDNa5jfQVXQaAG4vhDcpT
         AVEkhwDynuP161Vud6EPXyI2kyKCPTKW5NyMlb7POp23N+KEa/BKOmgJSmaWGd5CuYNd
         CKkNCw6SSK/hlA4SIs8rzGRiEoAyNZo+p1Fx35I0NfXGgDepYvLGtGQOG2pzMHeADxEh
         Xkxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZflUbONAaK9/L9BOxfPqTzOfgjlgC/1JMj3JWXw1dMQ=;
        b=bkDcn2qa6xTK15QhiZHxXBOkcdgoR22YgIwcSF0a5MCIb7bOWGTMB9gW5723HH02nb
         TPb/Y4gATiSOondrGIlxAhHVMnlnAt4lDUfvHziw+mV6H9xJ0dz8fhTv+49jqEMXj25P
         U/QWvYNOcJtnG3vC7/gtcxKHo2Nki8qs5w1nk8ZTcA3YOZsrWdAKYA/+Zj/0eoRx5bbK
         PAOxgETzUdYYQojWsp3MwKMEdtf1VQ176TmIBug2knTb2i9bSGHoXVHaH1QaNIFjskw/
         mDrfNq2YkxsTl0e0atQncC/8rMohDLdQWDz2ZWAd57sHQXdzYOD30LhlGFmks7F92B9A
         iE2A==
X-Gm-Message-State: AOAM53159kTV2LKjG6ldkRL+lJgMOYs+aPNopeYnr1P8vgv1ziApqe4p
        oIWTqbDhjg+DcJsFeRs9dmL6wz622HVzdw==
X-Google-Smtp-Source: ABdhPJyob+ibKq3r1ulJ6LquAV5zssuGnkqhA7g7TY0Bk90llV8umSunY4k9+q0Kh/SlxhjngMz8KA==
X-Received: by 2002:a65:6a53:: with SMTP id o19mr13945736pgu.212.1610249402905;
        Sat, 09 Jan 2021 19:30:02 -0800 (PST)
Received: from localhost.localdomain ([122.179.92.100])
        by smtp.gmail.com with ESMTPSA id x6sm14079861pfq.57.2021.01.09.19.30.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Jan 2021 19:30:02 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com,
        djwong@kernel.org, hch@lst.de, allison.henderson@oracle.com
Subject: [PATCH V13 09/16] xfs: Check for extent overflow when moving extent from cow to data fork
Date:   Sun, 10 Jan 2021 08:59:21 +0530
Message-Id: <20210110032928.3120861-10-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210110032928.3120861-1-chandanrlinux@gmail.com>
References: <20210110032928.3120861-1-chandanrlinux@gmail.com>
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

