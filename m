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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04E8FC4338F
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Jul 2021 11:47:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D6DAB60F37
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Jul 2021 11:47:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233616AbhGZLHJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Jul 2021 07:07:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233463AbhGZLHI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Jul 2021 07:07:08 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF14BC061764
        for <linux-xfs@vger.kernel.org>; Mon, 26 Jul 2021 04:47:36 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id mz5-20020a17090b3785b0290176ecf64922so3473429pjb.3
        for <linux-xfs@vger.kernel.org>; Mon, 26 Jul 2021 04:47:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TaGlgI/19FC6KZUGDzzcYsr4gYxU9CrV0gr47YVo+PY=;
        b=AhtSqnJWXFZNLkApKBIu34irgGy2YjCV4az1rJMCfTP0eWhXJQLsPyhVkfSSy5E79Q
         biXaaGPkiPBhMxAoBg/r4afwIcBDl0ncdTgxKXyg3CdDqDUWltU8J6bz0OkVmbnsYP6V
         8Uh2UdexlwbrEZyjRzgV1AK7R6d7tNKjgHV/yjYCPZY7XiVBfX1w9Z/TzZfnBWTulMS1
         RRskMkic0OZ3/0DEjhdlINYn8BN4ch6ezSXd0wz755hHABQM+0PrQKiEVNxQLhH510zu
         NVZxmjzGkNvhpkHl82UD9Pq2IeRC/jkElfc0jA3Kzvz845oI+ATFR6Sfr/NIq/8NFV5J
         +YHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TaGlgI/19FC6KZUGDzzcYsr4gYxU9CrV0gr47YVo+PY=;
        b=piZXpkB23p/vsH3KiEUOciqXgq5ln1TY/rzcDjEo0eoz5HIkw0p0BtQyeahw+3sVUM
         aOI6bS15sBziSx3YTvjbJoVM5iOYPZnzv/BRdZSN9CvBFpk1YPZ32vE2HBhs/VTjsGwQ
         4PA51OY4cHhW7sRE/45TmMX/2OkU1ktoqXIX+RHOnV3L3F98rFJ2DS9L59tINLWU357y
         nMrPuY0h7O8rRz6Lo6I7nJuekbKMRkvDAFQmo/rBYPapBbjG+LwnC52+BZsnVyprwpy7
         mxcOzIjGHnnLX372U0FDVrDd6X+P7h0hfaGVprpUBy8880/v9NFJ09HXlstqqUFLRN1r
         5yAw==
X-Gm-Message-State: AOAM5339m6FXwEzOvLKBUYgwLrgOZcZUj0STX1FF0lTL7a37tLmr88uA
        CPdfA2BPuAbpcXng3mkwMorGS54/VnQ=
X-Google-Smtp-Source: ABdhPJyhItVl6PFRE3GV+TFUFUgyCwvrdrZ2v2rv2r7Lqf8jwPgMmmiw8Llg0FAFyFvv2K7kI8SJfQ==
X-Received: by 2002:a62:ee0f:0:b029:335:a681:34f6 with SMTP id e15-20020a62ee0f0000b0290335a68134f6mr17503602pfi.55.1627300056426;
        Mon, 26 Jul 2021 04:47:36 -0700 (PDT)
Received: from localhost.localdomain ([122.179.41.55])
        by smtp.gmail.com with ESMTPSA id y10sm35936900pjy.18.2021.07.26.04.47.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jul 2021 04:47:36 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, djwong@kernel.org
Subject: [PATCH V2 01/12] xfsprogs: Move extent count limits to xfs_format.h
Date:   Mon, 26 Jul 2021 17:17:13 +0530
Message-Id: <20210726114724.24956-2-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210726114724.24956-1-chandanrlinux@gmail.com>
References: <20210726114724.24956-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Maximum values associated with extent counters i.e. Maximum extent length,
Maximum data extents and Maximum xattr extents are dictated by the on-disk
format. Hence move these definitions over to xfs_format.h.

Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 libxfs/xfs_format.h | 7 +++++++
 libxfs/xfs_types.h  | 7 -------
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index b7704620c..24277f45a 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -1109,6 +1109,13 @@ enum xfs_dinode_fmt {
 	{ XFS_DINODE_FMT_BTREE,		"btree" }, \
 	{ XFS_DINODE_FMT_UUID,		"uuid" }
 
+/*
+ * Max values for extlen, extnum, aextnum.
+ */
+#define	MAXEXTLEN	((uint32_t)0x001fffff)	/* 21 bits */
+#define	MAXEXTNUM	((int32_t)0x7fffffff)	/* signed int */
+#define	MAXAEXTNUM	((int16_t)0x7fff)	/* signed short */
+
 /*
  * Inode minimum and maximum sizes.
  */
diff --git a/libxfs/xfs_types.h b/libxfs/xfs_types.h
index 5c0cc8060..8908346b1 100644
--- a/libxfs/xfs_types.h
+++ b/libxfs/xfs_types.h
@@ -56,13 +56,6 @@ typedef void *		xfs_failaddr_t;
 #define	NULLFSINO	((xfs_ino_t)-1)
 #define	NULLAGINO	((xfs_agino_t)-1)
 
-/*
- * Max values for extlen, extnum, aextnum.
- */
-#define	MAXEXTLEN	((xfs_extlen_t)0x001fffff)	/* 21 bits */
-#define	MAXEXTNUM	((xfs_extnum_t)0x7fffffff)	/* signed int */
-#define	MAXAEXTNUM	((xfs_aextnum_t)0x7fff)		/* signed short */
-
 /*
  * Minimum and maximum blocksize and sectorsize.
  * The blocksize upper limit is pretty much arbitrary.
-- 
2.30.2

