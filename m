Return-Path: <SRS0=bjGU=EK=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDCB2C388F7
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Nov 2020 11:49:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 885B12236F
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Nov 2020 11:49:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZW9RWodg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728523AbgKDLtq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Nov 2020 06:49:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729584AbgKDLtQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Nov 2020 06:49:16 -0500
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26B88C0613D3
        for <linux-xfs@vger.kernel.org>; Wed,  4 Nov 2020 03:49:16 -0800 (PST)
Received: by mail-pf1-x443.google.com with SMTP id j18so17108183pfa.0
        for <linux-xfs@vger.kernel.org>; Wed, 04 Nov 2020 03:49:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ywayyo/R3ddq6HHEYVmmePZP9io7RXBTDj4Ca6E+ifo=;
        b=ZW9RWodgMdroMGTyZ5IsWHOuf4J+Gq7yeZLPVlajcIR6ZE772bCl59Kd6weSkfnzyK
         67PnnW+NxFd8DfM5mVQT59OvNAHTfYFS9ubNl4S1L2XBKw9uu47qC6yeXarjVcGRx2lJ
         SPx1b3s25U6X491ZFDfgNm8ZTi2mX8hfJ7p29Gt+nmmjesPrpv26UqJ8JBZr6Co0NMOZ
         6E6GdAUYrJWawEyZRyuF6sFobgSFQ2rkFf1kKsVK5yawlagf0Lq5O1jfK9QL3yqNlDcp
         UYl+D8zgiRxzEO9TjUCbpevs9ilhLThCX/DeK2AwI2AaJjxd9gqQkaVmA23OWqo+98ER
         iZ2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ywayyo/R3ddq6HHEYVmmePZP9io7RXBTDj4Ca6E+ifo=;
        b=LCoFgXY100q0D0Dzh+/TWVta414Y6qxZj76UIvcc5MYZIbjbbiKCgroXrLkWE8jAfZ
         e0I1NETxY+nflpQY1y23ez5UJ8PM/gzPNARb0OqVx9tNdmSPl0N1GQJ1pPdq2t/dMOUa
         xoCr6RAV2dKRRwnW6P2FcW/H5cwBgBGfWw6x17Q0LWXWbiRtP3I2d7EPbsPpBXF2/RuN
         FGwegaH0VVou6kL+pWK7qY6BmVXK8i/0unrS5C9T84Xn4P3seHtFy4pFXhneCX7MyTD9
         f4nTZohwPViUtUWktJtor5o2aPDvq8qEtikcnnE2ghLAQfEivQkOhXX9TmFd8zbETTrv
         k9rw==
X-Gm-Message-State: AOAM533+dBI/kv1PorF0ygb9b/TRcvhra5Z3HCovVcz5jmUXOrfQFNLt
        5ebx5fR7Gz+4kvryeK8IcwKwELzuzfw=
X-Google-Smtp-Source: ABdhPJyz9G9w1dFijNfEMmc4xdOXhCuo1benLy6Aln8T6fZvX8J04vb6jhOwkaNkBFwZZG+dI/oH0A==
X-Received: by 2002:a05:6a00:228a:b029:18b:212a:1af7 with SMTP id f10-20020a056a00228ab029018b212a1af7mr9676534pfe.55.1604490555443;
        Wed, 04 Nov 2020 03:49:15 -0800 (PST)
Received: from localhost.localdomain ([122.171.54.58])
        by smtp.gmail.com with ESMTPSA id o13sm2118819pjq.19.2020.11.04.03.49.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2020 03:49:14 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com,
        allison.henderson@oracle.com
Subject: [PATCH 2/2] xfsprogs: Add error injection to allocate only single block sized extents for files
Date:   Wed,  4 Nov 2020 17:18:59 +0530
Message-Id: <20201104114900.172147-2-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201104114900.172147-1-chandanrlinux@gmail.com>
References: <20201104114900.172147-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit adds XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT error tag which
enables inject command to limit space allocation for files to single
block sized extents.

One way to use this error tag is to,
1. Consume all of the free space by sequentially writing to a file.
2. Punch alternate blocks of the file. This causes CNTBT to contain
   sufficient number of one block sized extent records.
3. Inject XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT error tag.

After step 3, space allocation requests issued by XFS kernel module for
files will be limited to single block sized extents only.

ENOSPC error code is returned to userspace when there aren't any "single
block sized" free extents left in the filesystem.

Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 io/inject.c           | 1 +
 libxfs/xfs_errortag.h | 4 +++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/io/inject.c b/io/inject.c
index 9e3d5ad4..9a401a1e 100644
--- a/io/inject.c
+++ b/io/inject.c
@@ -56,6 +56,7 @@ error_tag(char *name)
 		{ XFS_ERRTAG_IUNLINK_FALLBACK,		"iunlink_fallback" },
 		{ XFS_ERRTAG_BUF_IOERROR,		"buf_ioerror" },
 		{ XFS_ERRTAG_REDUCE_MAX_IEXTENTS,	"reduce_max_iextents" },
+		{ XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT,	"bmap_alloc_minlen_extent" },
 		{ XFS_ERRTAG_MAX,			NULL }
 	};
 	int	count;
diff --git a/libxfs/xfs_errortag.h b/libxfs/xfs_errortag.h
index 1c56fcce..6ca9084b 100644
--- a/libxfs/xfs_errortag.h
+++ b/libxfs/xfs_errortag.h
@@ -57,7 +57,8 @@
 #define XFS_ERRTAG_IUNLINK_FALLBACK			34
 #define XFS_ERRTAG_BUF_IOERROR				35
 #define XFS_ERRTAG_REDUCE_MAX_IEXTENTS			36
-#define XFS_ERRTAG_MAX					37
+#define XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT		37
+#define XFS_ERRTAG_MAX					38
 
 /*
  * Random factors for above tags, 1 means always, 2 means 1/2 time, etc.
@@ -99,5 +100,6 @@
 #define XFS_RANDOM_IUNLINK_FALLBACK			(XFS_RANDOM_DEFAULT/10)
 #define XFS_RANDOM_BUF_IOERROR				XFS_RANDOM_DEFAULT
 #define XFS_RANDOM_REDUCE_MAX_IEXTENTS			1
+#define XFS_RANDOM_BMAP_ALLOC_MINLEN_EXTENT		1
 
 #endif /* __XFS_ERRORTAG_H_ */
-- 
2.28.0

