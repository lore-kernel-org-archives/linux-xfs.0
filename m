Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAF46C32772
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Aug 2022 16:28:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229524AbiHVQ23 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 22 Aug 2022 12:28:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237027AbiHVQ2V (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 Aug 2022 12:28:21 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4208F2BD9;
        Mon, 22 Aug 2022 09:28:19 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id n4so13878228wrp.10;
        Mon, 22 Aug 2022 09:28:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=6pDOFEVfy1K9q+BjZ7R38iS5s9eH+edv8BSk6OFu1xM=;
        b=bKaQQ17Lfw5igPYj6dV9/QXA4Ds6wJYo+Gqf7YVzZh6f1N4pHbLGMCEILyJ6wKiRTb
         NRe5aGzRb7t8ue88Leeds+/k5Mqd+iEptB7v32/y5sbrKz799UczXz+EzKRwnte16ogE
         blWjELKSP0DU+dgCmLTN/e+5zqLjnDZ0971p2ttTHRgNGv1huLmBjmRJ3ro0UeyrhNZE
         8GC0hlOt0w0LJltpSa1bqGek8u2dHRfhWcSeLUt2Uv+5jHkoHQEoWt3unwfmci1Whc8v
         o8IQ39WEonSLnvAGHYGp17P/FNxVBba9x8e3+MTwh5UyV56LMezHpeyvdDqO84WCQuve
         ba3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=6pDOFEVfy1K9q+BjZ7R38iS5s9eH+edv8BSk6OFu1xM=;
        b=mfBbW57clRH8NsDu9A/k0sx50Ju2LYL8QrAPCAPTjZrn8wh7H1L6GPZPv2V3Kyc7bv
         1lxv0NpK8AOBWJnH8B63KScu92u2sPKDOwwTEf70Wh/eV0ZetL73kv5s6uGAQd0RbziW
         9OhmkHD5JMi7DK4DDTisD0Hco3fghdOEGMt8DmmPvmH77NQuFOfN63xwniBtqqlikJtk
         1GBodhbtKeIPnToVU7GCEzphq7sWh2TOEFghsYB/TPWu52XQtDqTal84SJQrqptwllfy
         0UGwIrSNxr49puPBDHgRQ3i6E4/1x7tcAS2m68I7+rHhxUceylAXLE5jXP1SaDMCGqCN
         9rlA==
X-Gm-Message-State: ACgBeo280yRClksoSSNnEQr6OJ6S41/1AGilHsM/Zr/juQiAnEuAI4LP
        BBxGVdeCTZWj0oYNsy9RC7Q=
X-Google-Smtp-Source: AA6agR520VIAwvFoMJou/rhDZvXvNam1uJMzbEH4KqdX8iMcJ+sZYwS78dIsUOB+SjLkoCOQDLb9Ag==
X-Received: by 2002:adf:f2ca:0:b0:225:4800:d201 with SMTP id d10-20020adff2ca000000b002254800d201mr3833968wrp.187.1661185697691;
        Mon, 22 Aug 2022 09:28:17 -0700 (PDT)
Received: from amir-ThinkPad-T480.ctera.local (bzq-166-168-31-246.red.bezeqint.net. [31.168.166.246])
        by smtp.gmail.com with ESMTPSA id z13-20020a5d44cd000000b00222ed7ea203sm11749229wrr.100.2022.08.22.09.28.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Aug 2022 09:28:17 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     "Darrick J . Wong" <djwong@kernel.org>
Cc:     Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
        Dave Chinner <dchinner@redhat.com>
Subject: [PATCH 5.10 CANDIDATE 6/6] xfs: only bother with sync_filesystem during readonly remount
Date:   Mon, 22 Aug 2022 19:28:02 +0300
Message-Id: <20220822162802.1661512-7-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220822162802.1661512-1-amir73il@gmail.com>
References: <20220822162802.1661512-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <djwong@kernel.org>

commit b97cca3ba9098522e5a1c3388764ead42640c1a5 upstream.

In commit 02b9984d6408, we pushed a sync_filesystem() call from the VFS
into xfs_fs_remount.  The only time that we ever need to push dirty file
data or metadata to disk for a remount is if we're remounting the
filesystem read only, so this really could be moved to xfs_remount_ro.

Once we've moved the call site, actually check the return value from
sync_filesystem.

Fixes: 02b9984d6408 ("fs: push sync_filesystem() down to the file system's remount_fs()")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/xfs/xfs_super.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index ff686cb16c7b..434c87cc9fbf 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1720,6 +1720,11 @@ xfs_remount_ro(
 	};
 	int			error;
 
+	/* Flush all the dirty data to disk. */
+	error = sync_filesystem(mp->m_super);
+	if (error)
+		return error;
+
 	/*
 	 * Cancel background eofb scanning so it cannot race with the final
 	 * log force+buftarg wait and deadlock the remount.
@@ -1790,8 +1795,6 @@ xfs_fc_reconfigure(
 	if (error)
 		return error;
 
-	sync_filesystem(mp->m_super);
-
 	/* inode32 -> inode64 */
 	if ((mp->m_flags & XFS_MOUNT_SMALL_INUMS) &&
 	    !(new_mp->m_flags & XFS_MOUNT_SMALL_INUMS)) {
-- 
2.25.1

