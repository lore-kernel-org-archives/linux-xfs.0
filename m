Return-Path: <SRS0=RpwR=EJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0CEAC55179
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Nov 2020 15:07:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 59899223FD
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Nov 2020 15:07:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LwEWAo+K"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728257AbgKCPHk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 3 Nov 2020 10:07:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728192AbgKCPHN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Nov 2020 10:07:13 -0500
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14BAEC0613D1
        for <linux-xfs@vger.kernel.org>; Tue,  3 Nov 2020 07:07:13 -0800 (PST)
Received: by mail-pf1-x444.google.com with SMTP id 10so14438668pfp.5
        for <linux-xfs@vger.kernel.org>; Tue, 03 Nov 2020 07:07:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XvpLSvlcyBaKGUc+FLHnNx0Ewse7iXgrENCBElNIo4Y=;
        b=LwEWAo+KER8UgZl20SX8/sqbglwmNReRFZqeNZSbOuTEoRgWVt3LBid1bDKzmHtoDD
         NS3/dQfY7v5xR178yha1pAuM9RmfE7+oIjRXhqqLBzggR7RdS0wSJ1pKcb7AWD6KHElb
         ibl770WpFE47wz8o06isP8f+toeE80EpNP0JbwY4knVya0LtDz6BBb38ivg7oqm6RIka
         SP7/2a4Spl1OH9GlmkVT4yXMCdCxynpke7d2oGI4Uis+2BNZ7wbLMx0p5kwo1anAhs7Z
         XL/o8M9/Es22QfbQAnsUQQhGnAqsbsSZAjMOiAzTxuGClyIAFg4m/bcQc/V0NzxXp2hw
         CVPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XvpLSvlcyBaKGUc+FLHnNx0Ewse7iXgrENCBElNIo4Y=;
        b=KeZIgMqgAy6pWrD1KbZPvp1lDXfXhDfmGiyjwBrlzEPamd7uTliQl/w+shgH+cMT/r
         LOpg+UGP/8tdPtLoLxOrhuRhNQW4piK4kCJavxdM0qyt+4wEwB6nqfP1a2wpS1+d4PWK
         +D/uIwRN+n67uMzE6qPlQEa0x9OoSN/jWEG/PtXwDkmb/JBA0xW1ykLWC//TiMEAvqQH
         TbA3XLRxfPqHtBOQvprclxaWjeVD7Uqm7swJ6cJV3RS5PcnhmmygtgosTOI5qnuDepjD
         dvGoAaiB6aLWbbAwjn+V5ZE1Y4fdrh7K57mnG1tvgr0bE6nTIfoGBPg4TBEkTSUlVZhJ
         ZxGw==
X-Gm-Message-State: AOAM531ty9Dw8iQY3b8AuXfZ1nNWf+03cbVDq5NGCgmykfoEGf/YEDG4
        3ouBXqFsT/TIptIiO3nDm3T56wfQQe8RdQ==
X-Google-Smtp-Source: ABdhPJwFwxizwCcDh1eJEzwUXWJO1q6eazD0AhjHHdatRV1hU9b6C8jDR/T6o7ZLIfplyBY9PKnUHw==
X-Received: by 2002:a63:b50a:: with SMTP id y10mr17175662pge.88.1604416032322;
        Tue, 03 Nov 2020 07:07:12 -0800 (PST)
Received: from localhost.localdomain ([122.179.48.228])
        by smtp.gmail.com with ESMTPSA id 15sm15936955pgs.52.2020.11.03.07.07.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2020 07:07:11 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com,
        david@fromorbit.com, hch@infradead.org,
        allison.henderson@oracle.com, Christoph Hellwig <hch@lst.de>
Subject: [PATCH V10 06/14] xfs: Check for extent overflow when writing to unwritten extent
Date:   Tue,  3 Nov 2020 20:36:34 +0530
Message-Id: <20201103150642.2032284-7-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201103150642.2032284-1-chandanrlinux@gmail.com>
References: <20201103150642.2032284-1-chandanrlinux@gmail.com>
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

