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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36C34C433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Jan 2021 23:02:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D967E2065E
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Jan 2021 23:02:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727249AbhAZXCj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Jan 2021 18:02:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726340AbhAZEnM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Jan 2021 23:43:12 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECE61C061574
        for <linux-xfs@vger.kernel.org>; Mon, 25 Jan 2021 20:42:30 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id a20so1317924pjs.1
        for <linux-xfs@vger.kernel.org>; Mon, 25 Jan 2021 20:42:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zK+Yus/H/KQ8mPXL2NFdDyAQre6Cuae1VDxVQMZwHV4=;
        b=UNhREswgSUU7IWpmldgMrKkMcUKoq+tMCsiQGUBmodfPUrtPcMykX77XjWkIGhIcUd
         SCLaaDC5ARY8VHjcdMrwyegjb22tYyDp9KrEweJ9FUIPmfbFljOGizeEHKVgU0/tBp4V
         Yst08XdW8MpQ5LvM5EQGRz9AQzLP0+9rLL7EejsQlGSD9vc2gBwBAOUaHDFB5xI/9cQT
         PBijNQNWTNJgp0AqgPrzeZ2hmG2uqET6iUm9cUUdyCel+nT0bSvp+BC+CzONzL3u9HJL
         DKpPjqSNQBd8yNhjXfvVhDq8yT4kdJdIzAVCF9ThmGzqljZcmvpMn1Xx0U7RPuHZopya
         syyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zK+Yus/H/KQ8mPXL2NFdDyAQre6Cuae1VDxVQMZwHV4=;
        b=m8t47yFmG+cMUtp8/rMWyVSqwF2mL77+cP/Eqy5iCrqCRyio+hlG5qVgZwy3GQ2qXC
         WIH3b22rbX/ipiNmwqdLAuh0HfDA+CD54R/DsrCTwkraTlPcuKxSxcs3Xv/43+JKe+/f
         ZQFMJAgSUKptxpjvNL21/hunHjc5VQKhJrZI8Eb5aqL72YafS1SJdJVfcWkN1DFbVAS3
         dfftNsxg9izlDToe6tGNkhgb4EJeJbxwayI/ab1pxmqlIqOEigOjm0kXIbEMyo8WBcN7
         PsHOIie8u9qhPg63Oe4P7RFqAvkA/HTrPNgyPPXmthDtrYG2Lw3Sc8475zCmlSJ2TYLU
         YMVA==
X-Gm-Message-State: AOAM531dU4JoFzuI/opGDPg8iL+CCJ66ZHL5RG6DS4PHHj047WmeM9g5
        pabakLsarygSbdXmHTw1iIxD22Nuj3U=
X-Google-Smtp-Source: ABdhPJxyc5UQFQr4p7yEjMn6hX8J3rSzbob+aQC9ESKZAVY2JwdssbQEMTopIICc8JKIOFMplD0hpQ==
X-Received: by 2002:a17:90a:6c26:: with SMTP id x35mr4033242pjj.52.1611636150416;
        Mon, 25 Jan 2021 20:42:30 -0800 (PST)
Received: from localhost.localdomain ([122.167.33.191])
        by smtp.gmail.com with ESMTPSA id j3sm832581pjs.50.2021.01.25.20.42.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jan 2021 20:42:29 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, sandeen@sandeen.net
Subject: [PATCH V1.1] xfsprogs: xfs_fsr: Limit the scope of cmp()
Date:   Tue, 26 Jan 2021 10:12:22 +0530
Message-Id: <20210126044222.2676922-1-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <eec86b5f-7a4c-c6e6-e8a0-1e4e9a7e042e@sandeen.net>
References: <eec86b5f-7a4c-c6e6-e8a0-1e4e9a7e042e@sandeen.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

cmp() function is being referred to from within fsr/xfs_fsr.c. Hence
this commit limits its scope to the current file.

Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fsr/xfs_fsr.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
index 635e4c70..b885395e 100644
--- a/fsr/xfs_fsr.c
+++ b/fsr/xfs_fsr.c
@@ -81,7 +81,6 @@ char * gettmpname(char *fname);
 char * getparent(char *fname);
 int fsrprintf(const char *fmt, ...);
 int read_fd_bmap(int, struct xfs_bstat *, int *);
-int cmp(const void *, const void *);
 static void tmp_init(char *mnt);
 static char * tmp_next(char *mnt);
 static void tmp_close(char *mnt);
@@ -577,6 +576,16 @@ fsrall_cleanup(int timeout)
 	}
 }
 
+/*
+ * To compare bstat structs for qsort.
+ */
+static int
+cmp(const void *s1, const void *s2)
+{
+	return( ((struct xfs_bulkstat *)s2)->bs_extents -
+	        ((struct xfs_bulkstat *)s1)->bs_extents);
+}
+
 /*
  * fsrfs -- reorganize a file system
  */
@@ -696,16 +705,6 @@ out0:
 	return 0;
 }
 
-/*
- * To compare bstat structs for qsort.
- */
-int
-cmp(const void *s1, const void *s2)
-{
-	return( ((struct xfs_bulkstat *)s2)->bs_extents -
-	        ((struct xfs_bulkstat *)s1)->bs_extents);
-}
-
 /*
  * reorganize by directory hierarchy.
  * Stay in dev (a restriction based on structure of this program -- either
-- 
2.29.2

