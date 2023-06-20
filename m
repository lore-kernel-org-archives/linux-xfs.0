Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3181FEB64DD
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Jun 2023 21:32:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230211AbjFTVcb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Jun 2023 17:32:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230184AbjFTVca (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Jun 2023 17:32:30 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0DE5170D
        for <linux-xfs@vger.kernel.org>; Tue, 20 Jun 2023 14:32:29 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id d2e1a72fcca58-666ecf9a081so3806147b3a.2
        for <linux-xfs@vger.kernel.org>; Tue, 20 Jun 2023 14:32:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20221208.gappssmtp.com; s=20221208; t=1687296749; x=1689888749;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A4OGB8ONrfrL7bW0bPYZHX1/QpOi68gd5YAQEg8Yi+A=;
        b=GiQTf4EqhkrSyk4P/oDo2GKMf8SskHHUOAgGDkqli0ONSSRtGs4bMium+3/Ql5pMgg
         9go4d141pj5br/OX2KUycpj3MtE9u32PW5vmnsbBCSv/OuVxbi3+0bkPz5OzuTmMJWOt
         Y1Iu2rsJZ0HNDH4R7LIWQO17qDNcSP5bq2Db5Emg1mLC2KnRiMnwCDpTVc4pjv2Gfh96
         IXc6rMLEnnt8mYzDzCt/Z6GG5chWOqXF9D+HNRslvbM0u3Uhy0WQr6qb8jYVqn56lLmG
         Ooh8F5ctZRBw9I/pKdIg7PEnzr/x8SfwMYy98KD+Mi7xR/5+K7FNckeXodhS2ue6f600
         3xRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687296749; x=1689888749;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=A4OGB8ONrfrL7bW0bPYZHX1/QpOi68gd5YAQEg8Yi+A=;
        b=R4vUmQtozWZ5wq9P6uhKbRm/DhuczIzbw8grFhIwwQzTf/4KkWxb2qmdr13eckx+K6
         OmgJ1N6XtNV2amLCryCPThY/9MINsCuBSwK95/4hrD1qzHt3E8bWxtrN0mBgYBUtlf4J
         JStyQr1mxy2L9ueAEa28hsZf3bJmZWLBGWK04VONqJZn/75i4W2xGMPZc6NcOAfIbWFD
         9hwppb7vAO9eQxFVNBxUh08jrrv2nE1yLD2rPaqj0BcS1KAp46nZ4dgiyLsSu3DqPHmZ
         eHZD8vErl5Y89tPsqw775zUyrvvmBCx0bhxXXcX5uhyzPamLPYYiyIlKD8r4nfvAXczE
         w5wg==
X-Gm-Message-State: AC+VfDy88SxwXkthkDzhnIx1g7g48FcZT+OULOB7JSfhfQ8saCBq/WwD
        ywa2oYT+qTTnbVGuPR6iLP2EkV6+tjcv79OQ6yk=
X-Google-Smtp-Source: ACHHUZ6LpO34z6guE3CZq38XbRFR2ZdKUKjYJtwy+Z871PC2n9JeDTQfao5SHq4eAkCEZSgkYaWhOA==
X-Received: by 2002:a05:6a20:1586:b0:122:79a0:ff74 with SMTP id h6-20020a056a20158600b0012279a0ff74mr3911424pzj.50.1687296749071;
        Tue, 20 Jun 2023 14:32:29 -0700 (PDT)
Received: from telecaster.hsd1.wa.comcast.net ([2620:10d:c090:400::5:ea8e])
        by smtp.gmail.com with ESMTPSA id 5-20020aa79205000000b0064d3a9def35sm1688188pfo.188.2023.06.20.14.32.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jun 2023 14:32:28 -0700 (PDT)
From:   Omar Sandoval <osandov@osandov.com>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J . Wong" <djwong@kernel.org>, kernel-team@fb.com,
        Prashant Nema <pnema@fb.com>
Subject: [PATCH 6/6] xfs: don't look for end of extent further than necessary in xfs_rtallocate_extent_near()
Date:   Tue, 20 Jun 2023 14:32:16 -0700
Message-ID: <554f3ce85edca54d14cc1e1b22c4207a3e8f36a7.1687296675.git.osandov@osandov.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <cover.1687296675.git.osandov@osandov.com>
References: <cover.1687296675.git.osandov@osandov.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Omar Sandoval <osandov@fb.com>

As explained in the previous commit, xfs_rtallocate_extent_near() looks
for the end of a free extent when searching backwards from the target
bitmap block. Since the previous commit, it searches from the last
bitmap block it checked to the bitmap block containing the start of the
extent.

This may still be more than necessary, since the free extent may not be
that long. We know the maximum size of the free extent from the realtime
summary. Use that to compute how many bitmap blocks we actually need to
check.

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 fs/xfs/xfs_rtalloc.c | 25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 4d9d0be2e616..2e2eb7c4a648 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -517,12 +517,29 @@ xfs_rtallocate_extent_near(
 			 * On the negative side of the starting location.
 			 */
 			else {		/* i < 0 */
+				int maxblocks;
+
 				/*
-				 * Loop backwards through the bitmap blocks from
-				 * where we last checked up to where we are now.
-				 * There should be an extent which ends in this
-				 * bitmap block and is long enough.
+				 * Loop backwards to find the end of the extent
+				 * we found in the realtime summary.
+				 *
+				 * maxblocks is the maximum possible number of
+				 * bitmap blocks from the start of the extent to
+				 * the end of the extent.
 				 */
+				if (maxlog == 0)
+					maxblocks = 0;
+				else if (maxlog < mp->m_blkbit_log)
+					maxblocks = 1;
+				else
+					maxblocks = 2 << (maxlog - mp->m_blkbit_log);
+				/*
+				 * We need to check bbno + i + maxblocks down to
+				 * bbno + i. We already checked bbno down to
+				 * bbno + j + 1, so we don't need to check those
+				 * again.
+				 */
+				j = min(i + maxblocks, j);
 				for (; j >= i; j--) {
 					error = xfs_rtallocate_extent_block(mp,
 						tp, bbno + j, minlen, maxavail,
-- 
2.41.0

