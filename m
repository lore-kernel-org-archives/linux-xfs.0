Return-Path: <SRS0=AlMJ=EI=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A82DC4742C
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Nov 2020 09:51:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 139A2222B9
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Nov 2020 09:51:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JE87khMj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728248AbgKBJvU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 2 Nov 2020 04:51:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727992AbgKBJvT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Nov 2020 04:51:19 -0500
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5649CC0617A6
        for <linux-xfs@vger.kernel.org>; Mon,  2 Nov 2020 01:51:18 -0800 (PST)
Received: by mail-pg1-x544.google.com with SMTP id f38so10340543pgm.2
        for <linux-xfs@vger.kernel.org>; Mon, 02 Nov 2020 01:51:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XvpLSvlcyBaKGUc+FLHnNx0Ewse7iXgrENCBElNIo4Y=;
        b=JE87khMjH7Ufo01Xe95I8nyBqpIDle3AQ/pkCYcEc5aA/hfL0/FZvIDCSj7i/ZXTrB
         JziMUrKbqqq511VqnMveuYiB7GOLeU+OQoxVgHGwuz0vqHejyxrHpXXxlBTchagxMdnF
         umW+LyAVT5Hn8fZLHD68mpR2V0xxJjSrB4tNOHhJsYH3y+wmipOv5KuZP08oZHWN/Tu8
         u06sJXkAxiJ7XiestjIrDvB9tP6T45Gl0PMOmNe0i9eCZV3GRF2Mql6+XDg6LAZBC9ZF
         jxJwP+6ooXkAQZoultpGPpwQPEYr5n/nxqAItksWnYgdU5l6f2aeqHYxBzgZ/YAWmCX/
         qejA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XvpLSvlcyBaKGUc+FLHnNx0Ewse7iXgrENCBElNIo4Y=;
        b=c1aluZN2QDkrlKZL8FuK5AzMMxRZdrIunTZ/XfM5INSS84oOETykiZta8RIOh5ofBp
         CWaFX9LHttH0TkWv10IbKlverfDg/+CVUulTe+7D3qhD7JWAte8Yf5mYaM4aL7uay37k
         vh4ypNLUy1SpX2hJNg83cKjkeuDnZLlSpBkldVMRF3LN+kBjMM/qurRm4DYWrDBD23TE
         ScP1MIHj3OxYChZc6ImhSqO7WP/1dIr3WU5wQMFR6GKDSmqI/WQgcgxudkzxrjkAI1G/
         VdgKEhvJNGsKwlLmGYUHpAK1i991BrtWKpunlTvp48rNEDhkNkgTqSGsodvsiKGyoqnX
         1g9A==
X-Gm-Message-State: AOAM530Yr7lhRxpI6eYJzSOp6TTr7E5HzXA4SBHgbSMTclSFCnymnJC4
        G5z5b02Qv7R1NrFNm9YftwoC374oAuw=
X-Google-Smtp-Source: ABdhPJw2msX+ErFYxzmtp4l8DybB6wpFZfFf+cyb6AvZMbR7oZOCD6iOY99FUBNPV/Nej2JutvqkvQ==
X-Received: by 2002:a63:6386:: with SMTP id x128mr2416346pgb.148.1604310677660;
        Mon, 02 Nov 2020 01:51:17 -0800 (PST)
Received: from localhost.localdomain ([122.179.32.56])
        by smtp.gmail.com with ESMTPSA id x15sm467062pjh.21.2020.11.02.01.51.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 01:51:17 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com,
        david@fromorbit.com, hch@infradead.org,
        allison.henderson@oracle.com, Christoph Hellwig <hch@lst.de>
Subject: [PATCH V9 06/14] xfs: Check for extent overflow when writing to unwritten extent
Date:   Mon,  2 Nov 2020 15:20:40 +0530
Message-Id: <20201102095048.100956-7-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201102095048.100956-1-chandanrlinux@gmail.com>
References: <20201102095048.100956-1-chandanrlinux@gmail.com>
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

