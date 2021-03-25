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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 041F1C433C1
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Mar 2021 14:04:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D20F861864
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Mar 2021 14:04:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231284AbhCYOEM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Mar 2021 10:04:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231332AbhCYOEB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Mar 2021 10:04:01 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9EB2C06175F
        for <linux-xfs@vger.kernel.org>; Thu, 25 Mar 2021 07:04:00 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id x126so2137706pfc.13
        for <linux-xfs@vger.kernel.org>; Thu, 25 Mar 2021 07:04:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/90JFOT/tJrDN3Hm6IMek5HUiq5mXsliH81wrzAl6po=;
        b=he0imXOiXJz/2m5XyxTheR9Uaq201JUZMwfJfU11iWiKkO09ml7ljlQOjcOwqUOCu8
         6W33UOiNen9T89vlUZ2U2rQIFTHPvWF53dB8jfxNu17c7oRamv07fsAn2fWwst/klFtp
         pY9tVtHbULNkOiDMwSuDiAgwnRGVF490JmjK8TilKlv6TwGJme6ukB9vveumixmufDgi
         GgWQpjNNx3PKQU4er5CwOW83PMnclzjE+Pq8HabQzhaTvTDAgIoqqo/CrH1z2ZADx4zf
         tIs6z6rzkA/tODZ6hWgHQn19lsbRhaButc7m+Sv/oRGIoX7pqrvM0Xpt1layOEWXVswN
         8U8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/90JFOT/tJrDN3Hm6IMek5HUiq5mXsliH81wrzAl6po=;
        b=HKbUYfeJ7OScODuQsUJL7JWn8vnej3xTmwK5WPDGMT5I33cy43pcQuEKZbfKhhfPc0
         a4pN4aUWs7/OR2t/adcHLEZqRBY5G4wVByJkKOAY8LYCN3qpr4G9GdByLW2gGA1HV9pw
         oc/mFhMiD1bc6JgqH3MzUekk7lB0OM52/rlMDqpJixJRAUo757nLBFLEVv8ZKZBP1HEX
         TLLHc1+n/cbmUec5UwJf5aUcCrxx5CAKlWKqDsvWegWn7lyCoJCVSZaMdKaNVxb/SJbb
         YAum5k5AVxUVmIyb0y5Jhged10qSdiq/yz1QFu5reg+eH7cvalMkcD77dL/Qs2HUpzxB
         vQfw==
X-Gm-Message-State: AOAM5318VlUBDLHv8azS4ON7r0nfOySdaPNkYNH8WZrKHrUlmobSuuMk
        7PAKUM0+f0VXw39GJluP1ajsyqMd8Eo=
X-Google-Smtp-Source: ABdhPJwA5IntyGOoaxwROtLR3UvQt1kTmkpOK2MZLm/pOw6ACHSo4O2OHsROqqAv0O7U189rHM02aw==
X-Received: by 2002:a17:902:8482:b029:e6:325b:5542 with SMTP id c2-20020a1709028482b02900e6325b5542mr10150478plo.70.1616681040283;
        Thu, 25 Mar 2021 07:04:00 -0700 (PDT)
Received: from localhost.localdomain ([122.171.175.121])
        by smtp.gmail.com with ESMTPSA id x2sm5876379pgb.89.2021.03.25.07.03.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Mar 2021 07:04:00 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, djwong@kernel.org
Subject: [PATCH 2/2] xfs: Fix dax inode extent calculation when direct write is performed on an unwritten extent
Date:   Thu, 25 Mar 2021 19:33:39 +0530
Message-Id: <20210325140339.6603-2-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210325140339.6603-1-chandanrlinux@gmail.com>
References: <20210325140339.6603-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

With dax enabled filesystems, a direct write operation into an existing
unwritten extent results in xfs_iomap_write_direct() zero-ing and converting
the extent into a normal extent before the actual data is copied from the
userspace buffer.

The inode extent count can increase by 2 if the extent range being written to
maps to the middle of the existing unwritten extent range. Hence this commit
uses XFS_IEXT_WRITE_UNWRITTEN_CNT as the extent count delta when such a write
operation is being performed.

Fixes: 727e1acd297c ("xfs: Check for extent overflow when trivally adding a new extent")
Reported-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/xfs_iomap.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index e17ab7f42928..8b27c10a3d08 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -198,6 +198,7 @@ xfs_iomap_write_direct(
 	bool			force = false;
 	int			error;
 	int			bmapi_flags = XFS_BMAPI_PREALLOC;
+	int			nr_exts = XFS_IEXT_ADD_NOSPLIT_CNT;
 
 	ASSERT(count_fsb > 0);
 
@@ -232,6 +233,7 @@ xfs_iomap_write_direct(
 		bmapi_flags = XFS_BMAPI_CONVERT | XFS_BMAPI_ZERO;
 		if (imap->br_state == XFS_EXT_UNWRITTEN) {
 			force = true;
+			nr_exts = XFS_IEXT_WRITE_UNWRITTEN_CNT;
 			dblocks = XFS_DIOSTRAT_SPACE_RES(mp, 0) << 1;
 		}
 	}
@@ -241,8 +243,7 @@ xfs_iomap_write_direct(
 	if (error)
 		return error;
 
-	error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
-			XFS_IEXT_ADD_NOSPLIT_CNT);
+	error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK, nr_exts);
 	if (error)
 		goto out_trans_cancel;
 
-- 
2.29.2

