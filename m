Return-Path: <SRS0=ZZxK=WW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F35EC3A59E
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 05:01:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4B8CB2080C
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 05:01:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gwoMFN1q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725933AbfHZFBj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Aug 2019 01:01:39 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:36168 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725868AbfHZFBj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Aug 2019 01:01:39 -0400
Received: by mail-pf1-f195.google.com with SMTP id w2so10978567pfi.3
        for <linux-xfs@vger.kernel.org>; Sun, 25 Aug 2019 22:01:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=cyUh//eAT9qWAoLVx92E9pzcMoiLn3kTnguaZgRwico=;
        b=gwoMFN1qx775xSafFhh0hW2UUDo/+6CpNnU5pZekLzJg91pril7IKcgDVmbhIM5Bry
         FYPMRhWo1Q/aAqRYWYtmpErFFkVqIT9P4LKOIz/yuYXNr7qVZtDCZhk4Ow2PA2uUyPrw
         sl53ICWXxAo1vC8pFm/PxSYZsJg9DSkKm2LLwHxIRqiqFTSn1ruZhomvoxvxTr2DxuU7
         +o9FO/ey2YcXgJlIQovxIENoWLPZrjIhRih2/exFm1e83LtVhP2tkG+SEla7cmT8a2Qt
         phLPEGawSdRgE21YaIQ2U/Je5wvVkT/SgnvvmL0P2SrWWcIeelh430aIP1m7379wnhN4
         iUIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=cyUh//eAT9qWAoLVx92E9pzcMoiLn3kTnguaZgRwico=;
        b=SR0qGSNNTnoT/bvTIrUwN6Y5950Je4RD9eU8xu5tsYM5pRASaOZlDZt8uTlDjhmI10
         HOz2Gl9tAtAb9Ten+440oo45/4Pyf4sq9L94MZ6M3yCHd3NuaYMYGP87ieRm1I9p9lGd
         Xq3fQ8MFHqICFxYPHqXfokQoA74SCjyG3ddtFEOTfdnhi8SMaZ3odKBUPZKEqXDRTWmP
         zjUr/sSTCSOqbz/9cc2cETVSUrofVc2P8tq8RJ2qjA1XEow8T64VUT+F/JahGqk1xJLP
         FOivtvBvJTO1sD7g4bPyIjT4y8ynieUpi0t9zUK9HZz3N8oOL/hE4gsY2YkQjQNw2S7f
         slFQ==
X-Gm-Message-State: APjAAAWf5bfel72AQ0Q8toXMOit0l//2CJSf4uJaiUe1xYZogitN0pWq
        VhII3Lj0ix4WQy8KN+KiJEqWRW4q
X-Google-Smtp-Source: APXvYqyv9wKv/OfbfpqRpYnD71DjqaOtVOkHa9jx1vp9S6I3svlm82U594yEHucSRbcJrK9cFuewug==
X-Received: by 2002:a17:90a:23c8:: with SMTP id g66mr17905178pje.123.1566795698632;
        Sun, 25 Aug 2019 22:01:38 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 1sm10747496pfx.56.2019.08.25.22.01.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 25 Aug 2019 22:01:38 -0700 (PDT)
Date:   Mon, 26 Aug 2019 13:01:30 +0800
From:   Murphy Zhou <jencce.kernel@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     darrick.wong@oracle.com
Subject: [PATCH] xfsdump: fix compiling errors due to typedef removal in
 xfsprogs
Message-ID: <20190826050130.eqzxbotjlblckmgu@XZHOUW.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Since xfsprogs commit
  32dd7d9c xfs: remove various bulk request typedef usage

Some typedef _t types have been removed, so did in header files.

Signed-off-by: Murphy Zhou <jencce.kernel@gmail.com>
---
 common/fs.c     | 2 +-
 common/hsmapi.c | 1 +
 common/util.h   | 3 +++
 3 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/common/fs.c b/common/fs.c
index a4c175c..ff8c75a 100644
--- a/common/fs.c
+++ b/common/fs.c
@@ -204,7 +204,7 @@ fs_mounted(char *typs, char *chrs, char *mnts, uuid_t *idp)
 int
 fs_getid(char *mnts, uuid_t *idb)
 {
-	xfs_fsop_geom_v1_t geo;
+	struct xfs_fsop_geom_v1 geo;
 	int fd;
 
 	fd = open(mnts, O_RDONLY);
diff --git a/common/hsmapi.c b/common/hsmapi.c
index e3e18a7..0771895 100644
--- a/common/hsmapi.c
+++ b/common/hsmapi.c
@@ -36,6 +36,7 @@
 #include "types.h"
 #include "hsmapi.h"
 #include "mlog.h"
+#include "util.h"
 
 /* This version of the HSM API supports the DMF attribute used in the initial
  * DMF release, as well as the attribute used in the pseudo multiple managed
diff --git a/common/util.h b/common/util.h
index 9a1729c..f43461f 100644
--- a/common/util.h
+++ b/common/util.h
@@ -34,6 +34,9 @@
  */
 typedef char *(*gwbfp_t)(void *contextp, size_t wantedsz, size_t *szp);
 typedef int (*wfp_t)(void *contextp, char *bufp, size_t bufsz);
+typedef struct xfs_bstat xfs_bstat_t;
+typedef struct xfs_inogrp xfs_inogrp_t;
+typedef struct xfs_fsop_bulkreq xfs_fsop_bulkreq_t;
 
 extern int write_buf(char *bufp,
 			   size_t bufsz,
-- 
2.18.1


