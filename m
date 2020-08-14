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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 460F8C433E1
	for <linux-xfs@archiver.kernel.org>; Fri, 14 Aug 2020 08:09:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2227F2068E
	for <linux-xfs@archiver.kernel.org>; Fri, 14 Aug 2020 08:09:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hnYH9ZRz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726979AbgHNIJy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 14 Aug 2020 04:09:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726124AbgHNIJy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 14 Aug 2020 04:09:54 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01051C061383
        for <linux-xfs@vger.kernel.org>; Fri, 14 Aug 2020 01:09:54 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id c6so4051883pje.1
        for <linux-xfs@vger.kernel.org>; Fri, 14 Aug 2020 01:09:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rO4iHtZIMFEfgqsFUNnGKzsFXKqfUXz/pnT3iA7Os4o=;
        b=hnYH9ZRz/A3K1al8xWJOujVIVGMFzCATuCL5jgg0y9MJeflIaCRIksw+M1tln/3Pxw
         0C0a4ieZ0z2IJrTge8SSh72QcF4bA+xiJg3oFHtRrERb16nkbhywdX4NjFvfUIsEDB/P
         LJ1muCrJSaCbeucLaMuvwqBqcT95FzkrE3XMzQmGI3qPQY/SLskAGTFw1frbhpplkea8
         r8CoZxJWXdzRiG/3CQNF4DsgOIVSso40c1k39KCh7hSmHcPKa1xZ/vFBsKGt7GIFtpS0
         SokcaUJjUcmKy8PQD7DEHyNBtk+bsyGv+HHE2Dstslxmx0MAvqWySmeRyo14zS4HWIIV
         EwCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rO4iHtZIMFEfgqsFUNnGKzsFXKqfUXz/pnT3iA7Os4o=;
        b=pLsbFt2KZ9nbYpCh+IC0C3uo3zpyJownaxNvGvrQd29VFPzdVy8NdxZW3DJgomjt71
         GAT+bfhLllaumVO4Bo2cNgJB4eFhhgTNlD7eMt8BBkaUjunekixtq3i6lvWVML/i73r4
         cae8T1MV7Q2z/wmAOc+n4eJsvnbECgsUX0UQeNSV3B9+CUlCvgNF4Ha2iHuyGTn3E1Wg
         lEJtzQ1QQOVUjyz8KMYwFeb2ksaSlc041ciO/rXtkZxaQd0MF6ME+RJBLd5rQRHSAtce
         RPuryJixpMzpQZafW7z8M9bPTa5iR0y94n7a0Xchvc1B/LFdJl5QII70pigQMJrLFVyy
         jA/A==
X-Gm-Message-State: AOAM532rm3GoYCPWI3yBDoC6PmOyp5E913aLnmBcXa20IYQQsunzmZt+
        qs+gTq0zD7Im/YZUSD2TcP235Ye+9k8=
X-Google-Smtp-Source: ABdhPJxNq6IAY05T0+6HSMUKa3T20drFbhGB4Qu0XB/Tj2dpizmOs7AakUjtKOZNB0GWTGTs1OHbIg==
X-Received: by 2002:a17:90a:f68a:: with SMTP id cl10mr1352893pjb.40.1597392593303;
        Fri, 14 Aug 2020 01:09:53 -0700 (PDT)
Received: from localhost.localdomain ([122.179.47.119])
        by smtp.gmail.com with ESMTPSA id z17sm8594289pfq.38.2020.08.14.01.09.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Aug 2020 01:09:52 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com,
        david@fromorbit.com
Subject: [PATCH V2 06/10] xfs: Check for extent overflow when writing to unwritten extent
Date:   Fri, 14 Aug 2020 13:38:29 +0530
Message-Id: <20200814080833.84760-7-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200814080833.84760-1-chandanrlinux@gmail.com>
References: <20200814080833.84760-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

A write to a sub-interval of an existing unwritten extent causes
the original extent to be split into 3 extents
i.e. | Unwritten | Real | Unwritten |
Hence extent count can increase by 2.

Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_inode_fork.h | 7 +++++++
 fs/xfs/xfs_iomap.c             | 5 +++++
 2 files changed, 12 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index e39ce09a824f..a929fa094cf6 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -63,6 +63,13 @@ struct xfs_ifork {
  */
 #define XFS_IEXT_DIR_MANIP_CNT(mp) \
 	((XFS_DA_NODE_MAXDEPTH + 1 + 1) * (mp)->m_dir_geo->fsbcount)
+/*
+ * A write to a sub-interval of an existing unwritten extent causes
+ * the original extent to be split into 3 extents
+ * i.e. | Unwritten | Real | Unwritten |
+ * Hence extent count can increase by 2.
+ */
+#define XFS_IEXT_WRITE_UNWRITTEN_CNT 2
 
 /*
  * Fork handling.
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 0af679ef9a33..81cccd4abcc6 100644
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

