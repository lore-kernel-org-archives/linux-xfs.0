Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D48FFC6FD1C
	for <linux-xfs@archiver.kernel.org>; Sun, 26 Mar 2023 17:06:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229793AbjCZRGh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 26 Mar 2023 13:06:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbjCZRGg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 26 Mar 2023 13:06:36 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D70744B0
        for <linux-xfs@vger.kernel.org>; Sun, 26 Mar 2023 10:06:35 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id y20so8345372lfj.2
        for <linux-xfs@vger.kernel.org>; Sun, 26 Mar 2023 10:06:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679850393;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9Zxcq7ErUSbVeRmZthkOLVnHmf9zt54zi1yvanZB+iw=;
        b=NKoCFQsUOzvXf7eqAqZiKXIRUixexd0VlUeRaVAh7BB0wJEcSBAv8mQQgGX3Xzeu2r
         kShO/m/kADrHasT62vFSxiaCmDgLE6p/ZvJjjrkir3suBTPcJ31OMDbzQZo3KvSi3pym
         pJvC5JUwwKLBqL89Z6Qc6lv2ioeSX8KwpIKXen2+9ablCQga4/J4cpE/aXmF76qPkcvh
         yySpSw8EuSIiPeHZYynfV4yiUDvCPmP1lZ5I0piRNXqI45FPpIAhTFx9nCzvjDmRtiTY
         wk5aYA+7qnw3ig+ZCa1Z91p/Ln65jhUqwHHy9O62AoQFrAjPYJ3u4m3f1hNX+EzEaiAO
         4P9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679850393;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9Zxcq7ErUSbVeRmZthkOLVnHmf9zt54zi1yvanZB+iw=;
        b=dwIkLF3o6GlArk0M4LpRcsEeVDMgzm1/anI7+ahRPuv4+/j+88nNRRrmWrxxajFYi1
         ABEQ9Zp5GDwO0efT8B9ts4ZZ2sGIROI5LyEv7ekjPTMtStTlLbjJat2buP1pAn0AwE6z
         gbqPJ55tKW9btyKh9OTau4PbKZltIax39GPQs495Mv3ecRddnNUvLH3RqUJlbTjbiYy9
         J6AF5b44QsgJxAA6PTuAtCTffx6Ey/GO5L+0hUIgJG3KZrEXEIoJW4AxnfjISu1ZcQKp
         DsNZLtFisdbHT5zsvFz5MXRv6HT81S+NFA1XCZV1PW7mNK3mw0Dgd2YsGqyuE5L408mx
         QyCw==
X-Gm-Message-State: AAQBX9dvOCMakNF8kp24YjT8tI/QVRBv42G5dpkjQbeJ0In1lEsoAJZH
        4FMeYPvk/fql/uUWPOJOBKo=
X-Google-Smtp-Source: AKy350abkTjRVe6lG88W7ULDkS+CU7laMaVBf8nEEb93Kblhxi8ehXo2KO0dOSGNA7IQ8GDjwJ/IOg==
X-Received: by 2002:ac2:511c:0:b0:4d8:4f46:f0b9 with SMTP id q28-20020ac2511c000000b004d84f46f0b9mr2539069lfb.23.1679850392957;
        Sun, 26 Mar 2023 10:06:32 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id m7-20020ac24ac7000000b004d858fa34ebsm4288720lfp.112.2023.03.26.10.06.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Mar 2023 10:06:32 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     "Darrick J . Wong" <djwong@kernel.org>
Cc:     Chandan Babu R <chandan.babu@oracle.com>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH 5.10 CANDIDATE 1/2] xfs: shut down the filesystem if we screw up quota reservation
Date:   Sun, 26 Mar 2023 20:06:22 +0300
Message-Id: <20230326170623.386288-2-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230326170623.386288-1-amir73il@gmail.com>
References: <20230326170623.386288-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <djwong@kernel.org>

commit 2a4bdfa8558ca2904dc17b83497dc82aa7fc05e9 upstream.

If we ever screw up the quota reservations enough to trip the
assertions, something's wrong with the quota code.  Shut down the
filesystem when this happens, because this is corruption.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/xfs/xfs_trans_dquot.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index 288ea38c43ad..5ca210e6626c 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -16,6 +16,7 @@
 #include "xfs_quota.h"
 #include "xfs_qm.h"
 #include "xfs_trace.h"
+#include "xfs_error.h"
 
 STATIC void	xfs_trans_alloc_dqinfo(xfs_trans_t *);
 
@@ -708,9 +709,11 @@ xfs_trans_dqresv(
 					    XFS_TRANS_DQ_RES_INOS,
 					    ninos);
 	}
-	ASSERT(dqp->q_blk.reserved >= dqp->q_blk.count);
-	ASSERT(dqp->q_rtb.reserved >= dqp->q_rtb.count);
-	ASSERT(dqp->q_ino.reserved >= dqp->q_ino.count);
+
+	if (XFS_IS_CORRUPT(mp, dqp->q_blk.reserved < dqp->q_blk.count) ||
+	    XFS_IS_CORRUPT(mp, dqp->q_rtb.reserved < dqp->q_rtb.count) ||
+	    XFS_IS_CORRUPT(mp, dqp->q_ino.reserved < dqp->q_ino.count))
+		goto error_corrupt;
 
 	xfs_dqunlock(dqp);
 	return 0;
@@ -720,6 +723,10 @@ xfs_trans_dqresv(
 	if (xfs_dquot_type(dqp) == XFS_DQTYPE_PROJ)
 		return -ENOSPC;
 	return -EDQUOT;
+error_corrupt:
+	xfs_dqunlock(dqp);
+	xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
+	return -EFSCORRUPTED;
 }
 
 
-- 
2.34.1

