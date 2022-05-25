Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2B3FC4321E
	for <linux-xfs@archiver.kernel.org>; Wed, 25 May 2022 11:17:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231358AbiEYLRk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 May 2022 07:17:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235257AbiEYLRk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 May 2022 07:17:40 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3384DBF57;
        Wed, 25 May 2022 04:17:39 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id m32-20020a05600c3b2000b0039756bb41f2so3138759wms.3;
        Wed, 25 May 2022 04:17:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GX4MGgyF/rjjoLGNo+9vAqeePSGvpBNozK+r4g9/A+k=;
        b=dlw0Mg6gf3WNt8D6bhTQyID0LYoJJu+FAy8sfn/2lG1PC0eQ+HbwP1ZdGeFD4PbuMA
         twUcX5S6riP5FUAwDKCviI2RecKNaZZ3FWBW/mQOxVa1P+ceTTaVY7ihIS7+spQtL1Sg
         k8PdsWHzdk7pNvrRo/ykfDK7RgRIQ8D4FfxcDUp3PM5HKIldzZD3PrtugAgxc/ADngwa
         oSxvxhNhPm844QrmW9Xww46yI3/le5LHCxgeobuc9eOgFcf6IfJcKdHEKC/AEHVX0KRq
         AsAz3QtSb9wocwzYGry5S8FbVNH5BVs/1wNGCURAVG+EZ9YecdKN6C4Rsj3EZb+vOohq
         rq0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GX4MGgyF/rjjoLGNo+9vAqeePSGvpBNozK+r4g9/A+k=;
        b=xm8yQaoN+tsk5ZbTNcMiKd95Ul6+r+Df+9lJCp5s2JOpCP5xcz3Gaht5CSVuyj+LxU
         bcTBgH85+KsLaQ1lTT65NZGIlgSyRVEY6HTUmwyCREkOW4A/jEXEZkDypA5kFWdB4P2H
         urfZxC4F6Yizm1NVbZNhb0+QIoFnw3Hb5tsE2bxpIIrxmjEpauzAZ9H6NMZput0Shj8f
         lGLPIDp4h48oWnc1tQ+Ysok2aEKFSGSkzpsefKJ4g4yiWvmndx3ahF/bg0xUuX1uEpnp
         62KEgRQGAWgJt5yVZ5cmNuxai9jo4Ixt8evZp7qYhEXne9v7ucBmuADydTmgTRF+/2a9
         wf+g==
X-Gm-Message-State: AOAM532E7k0BdkIlR62/WCBdX3Wu+Ot4khm1reLSZp5wmw0m8wF6dyMA
        KfHXoT5Tl4h/ASN98eFYuVQ=
X-Google-Smtp-Source: ABdhPJyC68W7SAjRUxetk9N2SwY3o8lg1eXakzy/Ukr/JkU2bUbF2Dq2GKbLiOjTb1iBspIP/jgvTw==
X-Received: by 2002:a05:600c:2904:b0:397:3673:83d1 with SMTP id i4-20020a05600c290400b00397367383d1mr7569254wmd.122.1653477457781;
        Wed, 25 May 2022 04:17:37 -0700 (PDT)
Received: from localhost.localdomain ([5.29.19.200])
        by smtp.gmail.com with ESMTPSA id e12-20020a056000178c00b0020c5253d8besm2059904wrg.10.2022.05.25.04.17.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 May 2022 04:17:37 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Dave Chinner <david@fromorbit.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Cc:     Luis Chamberlain <mcgrof@kernel.org>,
        Theodore Ts'o <tytso@mit.edu>,
        Adam Manzanares <a.manzanares@samsung.com>,
        Tyler Hicks <code@tyhicks.com>, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, zlang@redhat.com,
        Dave Chinner <dchinner@redhat.com>
Subject: [PATH 5.10 3/4] xfs: fix the forward progress assertion in xfs_iwalk_run_callbacks
Date:   Wed, 25 May 2022 14:17:14 +0300
Message-Id: <20220525111715.2769700-4-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220525111715.2769700-1-amir73il@gmail.com>
References: <20220525111715.2769700-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit a5336d6bb2d02d0e9d4d3c8be04b80b8b68d56c8 upstream.

In commit 27c14b5daa82 we started tracking the last inode seen during an
inode walk to avoid infinite loops if a corrupt inobt record happens to
have a lower ir_startino than the record preceeding it.  Unfortunately,
the assertion trips over the case where there are completely empty inobt
records (which can happen quite easily on 64k page filesystems) because
we advance the tracking cursor without actually putting the empty record
into the processing buffer.  Fix the assert to allow for this case.

Reported-by: zlang@redhat.com
Fixes: 27c14b5daa82 ("xfs: ensure inobt record walks always make forward progress")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Zorro Lang <zlang@redhat.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/xfs/xfs_iwalk.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_iwalk.c b/fs/xfs/xfs_iwalk.c
index 2a45138831e3..eae3aff9bc97 100644
--- a/fs/xfs/xfs_iwalk.c
+++ b/fs/xfs/xfs_iwalk.c
@@ -363,7 +363,7 @@ xfs_iwalk_run_callbacks(
 	/* Delete cursor but remember the last record we cached... */
 	xfs_iwalk_del_inobt(tp, curpp, agi_bpp, 0);
 	irec = &iwag->recs[iwag->nr_recs - 1];
-	ASSERT(next_agino == irec->ir_startino + XFS_INODES_PER_CHUNK);
+	ASSERT(next_agino >= irec->ir_startino + XFS_INODES_PER_CHUNK);
 
 	error = xfs_iwalk_ag_recs(iwag);
 	if (error)
-- 
2.25.1

